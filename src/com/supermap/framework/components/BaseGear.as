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
    import com.supermap.framework.core.GearStates;
    import com.supermap.framework.core.IGear;
    import com.supermap.framework.core.ITemplate;
    import com.supermap.framework.events.BaseEvent;
    import com.supermap.framework.events.BaseEventDispatcher;
    import com.supermap.framework.events.GearEvent;
    import com.supermap.framework.managers.ConfigManager;
    import com.supermap.framework.managers.EventManager;
    import com.supermap.framework.managers.PluginManager;
    import com.supermap.web.mapping.Map;
    import com.supermap.web.sm_internal;
    
    import flash.events.Event;
    
    import mx.core.IVisualElementContainer;
    import mx.events.FlexEvent;
    import mx.modules.Module;

    use namespace sm_internal;

    [Event(name = "gearShareData", type = "com.supermap.framework.events.GearEvent")]

    /**
     *  基础模块实现类.
     *  该类继承自Module类,主要用来模块化主应用程序.
     *  TODO:该类的很多属性要支持动态修改,目前只能在初始化的时候设置其作用......
     *  @see com.supermap.framework.core.IPlugin
     *  @see com.supermap.framework.core.IGear
     */
    public class BaseGear extends Module implements IGear
    {
        public function BaseGear()
        {
            super();
            this.autoLayout = true;

            addEventListener(FlexEvent.CREATION_COMPLETE, initGearTemplate);
        }

        private var _EventBus:Object;

        private var _map:Map;

        private var _dlgTitle:String = "";

        [Bindable]
        private var _dlgID:String;

        private var _dlgIcon:String;

        private var _gearPreload:String;

        private var _gearState:String;

        private var _gearTemplate:ITemplate;

        private var _isDraggable:Boolean = true;

        private var _isResizeable:Boolean = true;

        private var _topPad:Number = 0;

        private var _leftPad:Number = 0;

        private var _styleObject:Object;

        private var _configData:Object;
		
		sm_internal var parentSize:Object;


        /**
         *  @private
         */
        public function set pluginID(ID:String):void
        {

        }

        /**
         *  @private
         */
        public function get pluginID():String
        {
            return "";
        }

        /**
         *  对象销毁
         */
        public function destroy():void
        {
            clearListeners();
            GCPlus.clear(true);
        }

        /**
         *  移除所有监听器
         */
        sm_internal function clearListeners():void
        {
            EventManager.getEventManagerInstance().clearListeners(this);
        }

//		public function setInjector(injector:Injector = null) : void
//		{
//			
//		}

        /**
         *  获取事件总线
         */
        public function get EventBus():Object
        {
            return BaseEventDispatcher.getInstance();
        }

        public function get configData():Object
        {
            return _configData;
        }

        public function set configData(value:Object):void
        {
            _configData = value;
        }

        /**
         *  @private
         */
        public function get styleObject():Object
        {
            return _styleObject;
        }

        /**
         *  @private
         */
        public function get leftPad():Number
        {
            return _leftPad;
        }

        /**
         *  @private
         */
        public function set leftPad(value:Number):void
        {
            _leftPad = value;
        }

        public function get topPad():Number
        {
            return _topPad;
        }

        /**
         *  @private
         */
        public function set topPad(value:Number):void
        {
            _topPad = value;
        }

        /**
         *  获取map对象
         */
        public function get map():Map
        {
            return _map;
        }

        /**
         *  绑定map对象
         */
        [Bindable]
        public function set map(value:Map):void
        {
            this._map = value;
        }

        /**
         *  获取是否支持拖拽
         *  @return Boolean
         */
        public function get isDraggable():Boolean
        {
            return _isDraggable;
        }

        /**
         *  设置是否支持拖拽
         *  @param Boolean
         */
        public function set isDraggable(value:Boolean):void
        {
            _isDraggable = value;
            setGearTemplateControl();
        }

        /**
         *  获取是否支持缩放
         *  @return Boolean
         */
        public function get isResizeable():Boolean
        {
            return _isResizeable;
        }

        /**
         *  设置是否支持缩放
         *  @param Boolean
         */
        public function set isResizeable(value:Boolean):void
        {
            _isResizeable = value;
            setGearTemplateControl();
        }

        /**
         *  设置id
         *  @param String
         */
        public function setId(value:String):void
        {
            this._dlgID = value;
        }

        /**
         *  获取id
         *  @return String
         */
        public function getId():String
        {
            return this._dlgID;
        }

        /**
         *  获取标题
         *  @return String
         */
        public function getTitle():String
        {
            return _dlgTitle;
        }

        /**
         *  设置标题
         *  @param String
         */
        public function setTitle(value:String):void
        {
            _dlgTitle = value;
        }

        /**
         *  设置标题头位置显示图片
         *  @param String 图片url
         */
        public function setIcon(value:String):void
        {
            _dlgIcon = value;
        }

        /**
         *  获取标题头位置图片url
         *  @return String 图片url
         */
        public function getIcon():String
        {
            return _dlgIcon;
        }

        /**
         *  设置map对象
         *  @param Map
         */
        public function setMap(value:Map):void
        {
            this._map = value;
        }

        /**
         *  设置配置数据
         *  @param Object
         *  @private
         */
        public function setConfigData(value:Object):void
        {
            if (value)
                this._configData = value;
        }

        /**
         *  设置样式数据
         *  @param Object
         *  @private
         */
        public function setStyleObject(value:Object):void
        {
            if (value)
                this._styleObject = value;
        }

        /**
         *  返回该类类名
         */
        public function get type():String
        {
            //return "IGear";
            return this.className;
        }

        /**
         *  TODO:派发全局共享数据
         *  @param String evtClass 事件类型完全限定名
         *  @param String evtType  事件类型
         *  @param Model 数据对象。
         */
        public function notify(evtClass:String = "", evtType:String = "", data:* = null):void
        {
            //EventBus.dispatchBaseEvent();
        }

        private function initGearTemplate(event:Event):void
        {
            var children:Array = this.getChildren();
            for each (var child:Object in children)
            {
                if (child is ITemplate)
                {
                    _gearTemplate = child as ITemplate;

                    _gearTemplate.baseGear = this;

                    if (_gearState)
                    {
                        _gearTemplate.gearState = _gearState;
                    }

                    if (_gearPreload==GearStates.GEAR_MINIMIZED)
                    {
                        _gearTemplate.gearState = GearStates.GEAR_MINIMIZED;
                    }
                }
            }
        }

        private function setGearTemplateControl():void
        {
            var children:Array = this.getChildren();
            for each (var child:Object in children)
            {
                if (child is ITemplate)
                {
                    _gearTemplate = child as ITemplate;
//	                _gearTemplate.resizable = isResizeable;
//	                _gearTemplate.draggable = isDraggable;
                }
            }
        }

        private function onChangeState(event:BaseEvent):void
        {
            var data:Object = event.data;
            var reqId:String = data.id as String;
            var reqState:String = data.state as String;

            if (reqId==this.getId())
            {
                this.setState(reqState);
            }
        }

        /**
         *  设置是否预加载
         */
        public function setPreload(value:String):void
        {
            _gearPreload = value;
        }

        /**
         *  设置状态
         *  @private
         */
        public function setState(value:String):void
        {
            _gearState = value;
            if (_gearTemplate)
            {
                _gearTemplate.gearState = value;
            }
            notifyStateChanged(value);
        }

        private function notifyStateChanged(gearState:String):void
        {
            var data:Object = { id: this.getId(), state: gearState };
            EventBus.dispatchEvent(new GearEvent(GearEvent.GEAR_STATE_CHANGED, data));
        }

        /**
         *  在模块之间共享数据。按照key-value的方式组织数据。
         *  全局的数据共享参加notify方法
         */
        public function shareBevData(key:String, value:Object):void
        {
            var data:Object = { key: key, value: value };
            EventBus.dispatchEvent(new GearEvent(GearEvent.GEAR_SHARE_DATA, data));
        }

        sm_internal function setXYPosition(x:Number, y:Number):void
        {
            this.setLayoutBoundsPosition(x, y);
        }

        sm_internal function setRelativePosition(left:String, right:String, top:String, bottom:String):void
        {
            if (left)
            {
                this.left = Number(left);
            }
            if (right)
            {
                this.right = Number(right);
            }
            if (top)
            {
                this.top = Number(top);
            }
            if (bottom)
            {
                this.bottom = Number(bottom);
            }
        }

        /**
         *  覆写基类里的方法,根据传入的具体类型动态生成管理容器
         *  比方说 我们继承自baseComponent写一个类的时候
         *  baseComponent.addTo();即可实现添加舞台
         *
         *  @param String 传入参数为container的id 这里建议使用gearContainer
         *  @return IVisualElementContainer 返回一个容器
         */
        public function addTo(containId:String = ""):IVisualElementContainer
        {
            var container:LayoutComponent; //声明一个基础容器

            if (containId)
            {
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
                    container = PluginManager.getInstance().createPlugin(parentClassType) as LayoutComponent;
                    if (container)
                        container.addElement(this);
                    return container;
                }
            }

            return container;
        }

        private function get parentType():String
        {
            return "BaseGear";
        }

    }
}
