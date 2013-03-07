/////////////////////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2013 SuperMap. All Rights Reserved.
//
//	Licensed under the Apache License, Version 2.0 (the "License");
//	you may not use this file except in compliance with the License.
//	You may obtain a copy of the License at
//
//	http://www.apache.org/licenses/LICENSE-2.0
//
//	Unless required by applicable law or agreed to in writing, software
//	distributed under the License is distributed on an  "AS IS" BASIS,
//	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//	See the License for the specific language governing permissions and
//	limitations under the License.
//
///////////////////////////////////////////////////////////////////////////////////////////// 
package com.supermap.framework.components
{
    import com.supermap.framework.GCPlus;
    import com.supermap.framework.core.IAnimation;
    import com.supermap.framework.core.IPlugin;
    import com.supermap.framework.core.IState;
    import com.supermap.framework.core.IStyle;
    import com.supermap.framework.events.BaseEvent;
    import com.supermap.framework.events.BaseEventDispatcher;
    import com.supermap.framework.events.StyleEvent;
    import com.supermap.framework.managers.ConfigManager;
    import com.supermap.framework.managers.EventManager;
    import com.supermap.framework.managers.PluginManager;
    import com.supermap.web.sm_internal;
    
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.utils.getQualifiedClassName;
    
    import inject.Injector;
    import inject.utils.ReflectUtil;
    
    import mx.core.IVisualElementContainer;
    import mx.events.FlexEvent;
    
    import spark.components.Group;
    import spark.components.supportClasses.Skin;
    import spark.components.supportClasses.SkinnableComponent;

    use namespace sm_internal;

    [Event(name = "styleChanged", type = "com.supermap.framework.events.StyleEvent")]

    //----------------------------------------
    //
    //  默认显示一个黑色的边框 动画默认无
    //  如果用户设置了skin 就不添加默认的外观部件(黑色边框)
    //
    //----------------------------------------
    /**
     *  基础组件类
     *  该类主要用来作为框架本身可视化组件的基类,同时也是MapContianer,GearContainer与TemplateContainer容器的父类.
     *
     */
    public class BaseComponent extends SkinnableComponent implements IPlugin, IState, IAnimation, IStyle
    {

        /**
         *  默认皮肤
         */
        [SkinPart(required = "false")]
        public var border:Group;

        /**
         *  配置管理器
         *  从解析后的xml节点里取到每一个实现的接口对应的事件类型字符串
         */
        private var config:ConfigManager;

        /**
         *  事件管理器
         *  封装反射逻辑,根据事件字符串生成一个全局的事件单例
         */
        private var eventManager:EventManager;

        /**
         *  插件管理器
         */
        protected var pluginManager:PluginManager;

        /**
         *  组件委托
         *  当处理命令回调的时候,根据组件委托获取对基础组件本身的引用
         */
        private var componentDelegate:ComponentDelegate;

        /**
         * 类描述xml文件
         *
         */
        private var describe:XML;

        /**
         *  默认边框颜色样式
         */
        private var _borderColor:uint = 0x000000;

        /**
         *  默认边框透明度样式
         */
        private var _borderAlpha:Number = 1;

        /**
         *  默认边框宽度样式
         */
        private var _borderWeight:Number = 1;

        /**
         *  默认边框颜色样式是否修改
         */
        private var borderColorChanged:Boolean = false;

        /**
         *  默认边框透明度样式是否修改
         */
        private var borderAlphaChanged:Boolean = false;

        /**
         *  默认边框宽度样式是否修改
         */
        private var borderWeightChanged:Boolean = false;


        protected var reflectUtil:ReflectUtil;

        /**
         *  基础组件默认宽度为100像素
         */
        private var defaultWidth:int = 100;

        /**
         *  基础组件默认高度为100像素
         */
        private var defaultHeight:int = 100;

        /**
         *  配置文件信息
         */
        protected var configData:Array;

        private var _EventBus:Object;

        private var _metaData:Object;

        sm_internal var listeners:Array = [];

        /**
         *  构造函数
         */
        public function BaseComponent()
        {
            super();

//			width = defaultWidth;
//			height = defaultHeight;

            Injector.getInstance().injectToPlugin(this);
            Injector.getInstance().getMetaData(this);

            eventManager = new EventManager();
            pluginManager = new PluginManager();

            if (!ConfigManager.getInstance().hasEventListener("config"))
                ConfigManager.getInstance().addEventListener("config", getConfigDataHandler);

            addEventListener(FlexEvent.INITIALIZE, createCompleteHandler);
            addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);

            //setStyle("skinClass", BaseComponentSkin);
        }

        /**
         *  获取该类的元数据注入信息
         *  这里主要包含了event与inject标签注入的信息
         *  @return Object 返回注入信息对象 通过for或者for each可以获取到该对象的键值对详细信息
         */
        public function get metaData():Object
        {
            _metaData = Injector.getInstance().getMetaData(this);
            return _metaData;
        }

        /**
         *  覆写移除插件本身的监听，并在必要时候释放资源
         */
        protected function removeFromStageHandler(event:Event):void
        {
            clearListeners(); //移除各种监听			
        }

        /**
         *  对象销毁
         */
        public function destroy():void
        {
            clearListeners();
            GCPlus.clear(true);
        }

//		public function setInjector(injector:Injector = null) : void
//		{
//			
//		}

        /**
         *  移除所有监听器
         */
        sm_internal function clearListeners():void
        {
            eventManager.clearListeners(this);
        }

        //重载EventDispatcher		
        /** add Managed EventListener
        * @param  type
        * @param  listener
        * @param  useCapture
        * @param  priority
        * @param  useWeakPeference
        */
        public override function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakPeference:Boolean = false):void
        {
            if (listener!=null)
            {
                listeners.push({ theType: type, theListener: listener });
            }
            super.addEventListener(type, listener, useCapture, priority, useWeakPeference);
        }

        private function createCompleteHandler(event:FlexEvent):void
        {
            componentDelegate = new ComponentDelegate(this, id);
        }

        /**
         *  获取事件总线
         */
        public function get EventBus():Object
        {
            return BaseEventDispatcher.getInstance();
        }

        private function getConfigDataHandler(event:Event):void
        {
            configData = ConfigManager.getInstance().configData as Array;
        }

        /**
         *  该组件的父容器类型
         *  当调用自身的addTo方法的时候 会根据自身的类型来取到对应的容器类型 这里已经在
         *  内核配置文件里配置好了 各个基础组件对应的基础容器 类型都是匹配过的
         *  这样保证 直接通过子类能得到可以管理加载它的父类容器
         *  这也是插件容器产生的一种基本情况:根据子类动态分配父类容器来进行管理
         *  @private
         */
        private function get parentType():String
        {
            var className:String = getQualifiedClassName(this);
            var pluginType:String = (className.split("::")[1]);
            return pluginType;
        }

        /**
         *  设置组件ID
		 *  @private
         */
        public function set pluginID(ID:String):void
        {

        }

        /**
         *  获取组件ID
		 *  @private
         */
        public function get pluginID():String
        {
            return "";
        }

        public function get type():String
        {
            return "IPlugin";
        }

        /**
         *  TODO:派发全局共享数据
         *  @param String evtClass 事件类型完全限定名
         *  @param String evtType  事件类型
         *  @param Model 数据对象。
         */
        public function notify(evtClass:String = "", evtType:String = "", data:* = null):void
        {
            var evt:Event = EventManager.getEventInstance(evtClass, evtType, data, this);
            //EventBus.dispatchEvent(evt);
        }

        [Bindable]
        public function get borderWeight():Number
        {
            return _borderWeight;
        }

        /**
         *  设置默认边框宽度样式
         */
        public function set borderWeight(value:Number):void
        {
            if (_borderWeight!=value)
            {
                _borderWeight = value;
                borderWeightChanged = true;
                invalidateProperties();
            }
        }

        [Bindable]
        public function get borderAlpha():Number
        {
            return _borderAlpha;
        }

        /**
         *  设置默认边框透明度样式
         */
        public function set borderAlpha(value:Number):void
        {
            if (_borderAlpha!=value)
            {
                _borderAlpha = value;
                borderAlphaChanged = true;
                invalidateProperties();
            }
        }

        [Bindable]
        public function get borderColor():uint
        {
            return _borderColor;
        }

        /**
         *  设置默认边框颜色样式
         */
        public function set borderColor(value:uint):void
        {
            if (_borderColor!=value)
            {
                _borderColor = value;
                borderColorChanged = true;
                invalidateProperties();
            }
        }

        /**
         *  覆写基类里的方法,根据传入的具体类型动态生成管理容器
         *  比方说 我们继承自baseComponent写一个类的时候
         *  baseComponent.addTo();即可实现添加舞台
         *
         *  @param String 传入参数为container的id
         *  @return IVisualElementContainer 返回一个容器
         */
        public function addTo(containId:String = ""):IVisualElementContainer
        {
            var container:LayoutComponent;

            if (containId)
            {
                //TODO:需要先判断container的布局方式等初始化工作,结合本身是否设置过xy等信息......
                container = ComponentDelegateManager.getInstance().getComponent(containId) as LayoutComponent;
                if (container)
                {
                    if (container.contains(this))
                    {
                        return container; //如果已经包含了,将不做处理
                    }
                    else
                    {
                        container.addElement(this);
                    }
                }
            }
            else
            {
                var parentClassType:String = ConfigManager.getInstance().getValue(this.parentType);
                if (parentClassType)
                {
                    //根据插件类型生成容器添加在舞台
                    container = pluginManager.createPlugin(parentClassType) as LayoutComponent;
                    if (container)
                        container.addElement(this);
                    return container;
                }
            }

            return container;
        }

        /**
         *  获取组件当前状态.
         *  实现IState接口里的状态接口
         */
        override public function get currentState():String
        {
            return "normal";
        }

        /**
         *  设置组件当前状态.
         *  实现IState接口里的状态接口
         */
        override public function set currentState(value:String):void
        {

        }

        override protected function partAdded(partName:String, instance:Object):void
        {
            super.partAdded(partName, instance);
            if (instance==border)
            {
                border.addEventListener(MouseEvent.CLICK, testEventHandler);
                border.addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
            }
        }

        protected override function partRemoved(partName:String, instance:Object):void
        {
            super.partRemoved(partName, instance);
            if (instance==border)
            {
                border.removeEventListener(MouseEvent.CLICK, removeEventHandler);
            }
        }

        private var baseEvent:BaseEvent;

        override protected function commitProperties():void
        {
            super.commitProperties();
            if (borderWeightChanged||borderColorChanged||borderAlphaChanged)
            {
                //baseEvent = EventManager.getEventInstance("com.supermap.framework.events.StyleEvent", StyleEvent.STYLE_CHANGED) as BaseEvent;
//				if(borderWeightChanged)
//				{
//					baseEvent.data = {obj:this.borderWeight};
//					invalidateDisplayList();
//				}
//				if(borderColorChanged)
//				{
//					baseEvent.data = {obj:this.borderColor};
//					invalidateDisplayList();
//				}
//				if(borderAlphaChanged)
//				{
//					baseEvent.data = {obj:this.borderAlpha};
//					invalidateDisplayList();
//				}
                //派发事件单例
                //dispatchEvent(baseEvent);
            }
        }

        //测试框架事件派发问题
        private var StateEvent:BaseEvent;

        private function testEventHandler(evt:MouseEvent):void
        {
            //这里的字符串用解析后的字符串变量来替换。。。
            //var styleEvent:BaseEvent = EventManager.getEventInstance("event.StyleEvent");
            //StateEvent = EventManager.getEventInstance("event.StateEvent", "");
            //trace(StateEvent);
        }

        private function mouseHandler(evt:MouseEvent):void
        {
            //StateEvent = EventManager.getEventInstance("event.StyleEvent", "");
            //trace(StateEvent);
        }

        private function removeEventHandler(evt:MouseEvent):void
        {

        }


        /**
         *  清除本身的绘制(皮肤设置)
         */
        public function clearGraphics():void
        {
            this.graphics.clear();
        }

//		public function dispathEventInstance(evt:BaseEvent):void
//		{
//			
//		}

        /**
         *  TODO:组件边框样式设置是否可用
         */
        public function setBorderEabled(isBorder:Boolean = true):void
        {
            //this.border;
        }

        /**
         *  TODO:组件边框样式设置
         */
        public function setBorderStyle(style:Object):void
        {

        }

        /**
         *  TODO:设置本身组件外部链接skin
         */
        public function setComponentSkin(skin:Skin):void
        {

        }

        /**
         *  TODO:设置组件本身共享样式对象
         */
        public function setStyleObject(value:Object):void
        {

        }

        /**
         *  TODO:获取组件本身共享样式对象
         */
        public function getStyleObject(value:Object):Object
        {
            return null;
        }

        /**
         *  TODO:获取组件动画实例
         */
        public function get componentAnimation():Object
        {
            return null;
        }

        /**
         *  设置组件动画实例
         */
        public function set componentAnimation(animation:Object):void
        {

        }

        /**
         *  TODO:设置组件Shader动画
         *  @param 传入参数为绑定.pbj文件的变量
         */
        public function setAnimationShader(shader:Class):void
        {

        }

        /**
         *  TODO:清除组件动画
         */
        public function clearAnimation():void
        {

        }

//		public function setBorderEabled(isBorder:Boolean = true):void
//		{
//			border.visible = true;
//		}

    /**
     *  给事件类型绑定执行command
     */
//		public function addToCommand(eventType:String , command:Class):void
//		{
//			EventManager.getEventManagerInstance().addCommand(eventType, command , this);
//		}

    /**
     *  移除事件类型绑定执行command
     */
//		public function removeCommand(eventType:String, command:Class):void
//		{
//			EventManager.getEventManagerInstance().removeCommand(eventType, command, this);
//		}

    /**
     *  获取事件类型绑定的command
     */
//		public function getCommand(eventType:String):ICommand
//		{
//			return null;
//		}


    /**
     *  派发自定义事件
     *  这里是组件内部,以及组件与其他部分通信的关键方法.
     */
//		public function dispatchBaseEvent(event:BaseEvent):void
//		{
//			event.obj = this;
//			eventManager.getInstance().dispatchEvent(event);			
//		}
    }
}
