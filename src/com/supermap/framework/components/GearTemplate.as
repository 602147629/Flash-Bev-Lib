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
    import com.supermap.framework.events.BaseEventDispatcher;
    import com.supermap.framework.events.GearEvent;
    import com.supermap.framework.managers.EventManager;
    import com.supermap.web.sm_internal;
    
    import flash.events.Event;
    import flash.events.MouseEvent;
    
    import mx.controls.Image;
    import mx.core.FlexGlobals;
    import mx.core.UIComponent;
    import mx.events.FlexEvent;
    import mx.managers.CursorManager;
    import mx.managers.DragManager;
    import mx.utils.NameUtil;
    
    import spark.components.Group;
    import spark.components.SkinnableContainer;

    use namespace sm_internal;

    [Event(name = "open", type = "flash.events.Event")]
    [Event(name = "minimized", type = "flash.events.Event")]
    [Event(name = "closed", type = "flash.events.Event")]
    [Event(name = "gearStateFromMinimized", type = "com.supermap.events.GearEvent")]

    [SkinState("open")]
    [SkinState("minimized")]
    [SkinState("closed")]

    /**
     *  基础模板类.
     *  该类是基础模块统一外观的逻辑封装类.继承自SkinnableContainer.
     *  该类也可以单独定义皮肤外观文件,以便于更好的呈现统一模板.
     *  @see com.supermap.framework.core.ITemplate
     */
    public class GearTemplate extends SkinnableContainer implements ITemplate
    {

        [SkinPart(required = "false")]
        public var GearFrame:Group;

        [SkinPart(required = "false")]
        public var header:Group;

        [SkinPart(required = "false")]
        public var headerToolGroup:Group;

        [SkinPart(required = "false")]
        public var icon:Image;

        [SkinPart(required = "false")]
        public var closeButton:Image;

        [SkinPart(required = "false")]
        public var minimizeButton:Image;

        [SkinPart(required = "false")]
        public var resizeButton:Group;

        [Bindable]
        public var enableCloseButton:Boolean = true;

        [Bindable]
        public var enableMinimizeButton:Boolean = true;

        [Bindable]
        public var enableResizeButton:Boolean = true;

        [Bindable]
        public var enableDraging:Boolean = true;

        [Bindable]
        public var gearWidth:Number;

        [Bindable]
        public var gearHeight:Number;

        [Embed(source = "assets/t_resizecursor.png")]
        public var resizeCursor:Class;

		sm_internal var parentSize:Object;
		
        [Bindable]
        public var enableIcon:Boolean = true;

        private static const GEAR_OPENED:String = "open";

        private static const GEAR_MINIMIZED:String = "minimized";

        private static const GEAR_CLOSED:String = "closed";

        [Bindable]
        [Embed(source = "assets/template-default.png")]
        public var GEAR_DEFAULT_ICON:Class;

        public static const GEAR_DEFAULT_TITLE:String = "默认模板";

        private var _gearId:String;

        private var _gearState:String = GEAR_OPENED;

        private var _cursorID:int = 0;

        private var _gearTitle:String = "";

        private var _gearIcon:String = "";

        [Bindable]
        private var _draggable:Boolean = true;

        private var _resizable:Boolean = true;

        private var _baseGear:IGear;

        private var _EventBus:Object;

        public function set baseGear(value:IGear):void
        {
            _baseGear = value;

            //处理默认ID
            if (!value.getId())
                this.GearId = NameUtil.createUniqueName(value);
            else
                this.GearId = value.getId();

            //处理默认标题
            if (!value.getTitle())
                this.GearTitle = GearTemplate.GEAR_DEFAULT_TITLE;
            else
                this.GearTitle = value.getTitle();

            //处理默认图标
//			if(!value.getIcon())
//				this.GearIcon = GearTemplate.GEAR_DEFAULT_ICON;
//			else
            this.GearIcon = value.getIcon();

        }

        /**
         *  对象销毁
         *  使用之前请先清理自己的外部使用过的引用,然后再调用该方法.
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
         *  TODO:派发全局共享数据
         *  @param String evtClass 事件类型完全限定名
         *  @param String evtType  事件类型
         *  @param Model 数据对象。
         */
        public function notify(evtClass:String = "", evtType:String = "", data:* = null):void
        {

        }

        /**
         *  获取事件总线
         */
        public function get EventBus():Object
        {
            return BaseEventDispatcher.getInstance();
        }

        /**
         *  根据模板关联的基础组件,获取绑定在该模板上的组件
         *  @return IGear
         */
        public function get baseGear():IGear
        {
            return _baseGear;
        }

        /**
         *  设置是否支持缩放
         *  @param Boolean 默认为true
         */
        public function set resizable(value:Boolean):void
        {
            if (enableResizeButton)
            {
                _resizable = value;
                resizeButton.visible = _resizable;
            }
        }

        /**
         *  返回是否可缩放
         *  @return Boolean
         */
        [Bindable]
        public function get resizable():Boolean
        {
            return _resizable;
        }

        /**
         *  设置是否可拖拽
         *  @param Boolean 默认为true
         */
        public function set draggable(value:Boolean):void
        {
            if (enableDraging)
            {
                _draggable = value;
            }
            else
            {
                _draggable = false;
            }
        }

        /**
         *  @private
         */
        public function get GearId():String
        {
            return _gearId;
        }

        /**
         *  @private
         */
        public function set GearId(value:String):void
        {
            _gearId = value;
        }

        [Bindable]
        public function get GearTitle():String
        {
            return _gearTitle;
        }

        public function set GearTitle(value:String):void
        {
            _gearTitle = value;
        }

        [Bindable]
        public function get GearIcon():String
        {
            return _gearIcon;
        }

        public function set GearIcon(value:String):void
        {
            _gearIcon = value;
        }

        /**
         *  设置模板状态
         *  @param String
         */
        public function set gearState(value:String):void
        {
            this.icon.toolTip = "";
            _gearState = value;
            if (_gearState==GEAR_MINIMIZED)
            {
                this.icon.toolTip = this.GearTitle;
            }
            invalidateSkinState();

            dispatchEvent(new Event(value));
        }

        /**
         *  获取皮肤状态
         */
        public function get gearState():String
        {
            return _gearState;
        }

        private var _selectedTitlebarButtonIndex:int = -1;

        private var _selectedTitlebarButtonIndexChanged:Boolean = false;

        /**
         *  @private
         */
        public function get selectedTitlebarButtonIndex():int
        {
            return _selectedTitlebarButtonIndex;
        }

        /**
         *  @private
         */
        public function set selectedTitlebarButtonIndex(value:int):void
        {
            if (_selectedTitlebarButtonIndex!=value)
            {
                _selectedTitlebarButtonIndex = value;
                _selectedTitlebarButtonIndexChanged = true;
                invalidateProperties();
            }
        }

        /**
         *  获取该类类名
         */
        public function get type():String
        {
            //return "ITemplate";
            return this.className;
        }

        /**
         *  构造函数
         */
        public function GearTemplate()
        {
            super();

            this.width = 400;
            this.height = 300;
            setStyle("skinClass", GearTemplateSkin);
            this.addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
        }

        private function creationCompleteHandler(event:Event):void
        {
            gearWidth = width;
            gearHeight = height;
        }

        protected override function partAdded(partName:String, instance:Object):void
        {
            super.partAdded(partName, instance);
            if (instance==icon)
            {
                icon.addEventListener(MouseEvent.CLICK, icon_clickHandler);
            }
            if (instance==GearFrame)
            {
                GearFrame.addEventListener(MouseEvent.MOUSE_DOWN, mouse_downHandler);
                GearFrame.addEventListener(MouseEvent.MOUSE_UP, mouse_upHandler);

               	//GearFrame.stage.addEventListener(MouseEvent.MOUSE_UP, mouse_upHandler);
                GearFrame.stage.addEventListener(Event.MOUSE_LEAVE, stageout_Handler);
            }
            if (instance==header)
            {
                header.addEventListener(MouseEvent.MOUSE_DOWN, mouse_downHandler);
                header.addEventListener(MouseEvent.MOUSE_UP, mouse_upHandler);
            }
            if (instance==closeButton)
            {
                closeButton.addEventListener(MouseEvent.CLICK, close_clickHandler);
            }
            if (instance==minimizeButton)
            {
                minimizeButton.addEventListener(MouseEvent.CLICK, minimize_clickHandler);
            }
            if (instance==resizeButton)
            {
                resizeButton.addEventListener(MouseEvent.MOUSE_OVER, resize_overHandler);
                resizeButton.addEventListener(MouseEvent.MOUSE_OUT, resize_outHandler);
                resizeButton.addEventListener(MouseEvent.MOUSE_DOWN, resize_downHandler);
            }
        }

        override protected function getCurrentSkinState():String
        {
            return _gearState;
        }

        override protected function commitProperties():void
        {
            super.commitProperties();
        }

        /**
         *  鼠标按下mousedown回调函数
         *  @private
         */
        public function mouse_downHandler(event:MouseEvent):void
        {
            if (_draggable&&enableDraging)
            {
                header.addEventListener(MouseEvent.MOUSE_MOVE, mouse_moveHandler);
                GearFrame.addEventListener(MouseEvent.MOUSE_MOVE, mouse_moveHandler);
				GearFrame.stage.addEventListener(MouseEvent.MOUSE_UP, mouse_upHandler);
            }
        }

        private var gearMoveStarted:Boolean = false;

        private function mouse_moveHandler(event:MouseEvent):void
        {
            if (!gearMoveStarted)
            {
                gearMoveStarted = true;
                this.alpha = 0.7;
                var gear:UIComponent = parent as UIComponent;

                if (!DragManager.isDragging)
                {
                    gear.startDrag();
                }

                if (_resizable)
                {
                    //ViewerEventDispatcher.dispatchEvent(new GearEvent(GearEvent.GEAR_FOCUS, GearId));
                }
            }
        }

        private function mouse_upHandler(event:MouseEvent):void
        {
            header.removeEventListener(MouseEvent.MOUSE_MOVE, mouse_moveHandler);
            GearFrame.removeEventListener(MouseEvent.MOUSE_MOVE, mouse_moveHandler);
			if(GearFrame.stage)
				GearFrame.stage.addEventListener(MouseEvent.MOUSE_UP, mouse_upHandler);
			
            this.alpha = 1;
            var gear:UIComponent = parent as UIComponent;

            gear.stopDrag();
			
			var appHeight:Number;
			var appWidth:Number;
			
			var parentSize:Object;
			if(this.baseGear)
				parentSize = (this.baseGear as BaseGear).parentSize;
			if(parentSize)
			{
				appHeight = parentSize.height;
				appWidth = parentSize.width;
			}
			else
			{
	            appHeight = FlexGlobals.topLevelApplication.height;
	            appWidth = FlexGlobals.topLevelApplication.width;
			}
            gear.parent;
            if (gear.y<0)
            {
                gear.y = 0;
            }
            if((gear.y+37) > (appHeight-40))
            {
                gear.y = appHeight-40-this.height; //TODO:37像素是顶部headbar的高度 需要外部传递进来
            }
            if (gear.x<0)
            {
                gear.x = 20;
            }
            //当拖拽到边缘外部的时候，允许弹回
            if (this.gearState==GearStates.GEAR_OPENED)
            {
                if (gear.x>(appWidth-gear.width-20)) //1156
                {
                    gear.x = appWidth-gear.width-20;
                }
            }
            else if (this.gearState==GearStates.GEAR_MINIMIZED)
            {
                if (gear.x>(appWidth-gear.width-20)) //1156
                {
                    gear.x = appWidth-gear.width-20;
                }
            }

            gear.left = gear.right = gear.top = gear.bottom = undefined;

            gearMoveStarted = false;
        }

        private function stageout_Handler(event:Event):void
        {
            if (gearMoveStarted)
            {
                mouse_upHandler(null);
            }
        }

        private function notifyStateChanged(widgetState:String):void
        {
            var data:Object = { id: _gearId, state: widgetState };

            EventBus.dispatchEvent(new GearEvent(GearEvent.GEAR_STATE_CHANGED, data));
        }

        protected function icon_clickHandler(event:MouseEvent):void
        {
            //处理当模块从minimizes状态到open状态时派发事件
            if (gearState==GEAR_MINIMIZED)
            {
                //this.dispatchEvent(new GearEvent(GearEvent.GEAR_STATE_FROM_MINIMIZED, this.baseGear));
            }
            gearState = GEAR_OPENED;

            this.GearFrame.toolTip = "";
            this.icon.toolTip = "";

            notifyStateChanged(GearStates.GEAR_OPENED);
        }

        protected function close_clickHandler(event:MouseEvent):void
        {
            gearState = GEAR_CLOSED;
            notifyStateChanged(GearStates.GEAR_CLOSED);
        }

        protected function minimize_clickHandler(event:MouseEvent):void
        {
            gearState = GEAR_MINIMIZED;
            this.GearFrame.toolTip = this.GearTitle;
            this.icon.toolTip = this.GearTitle;

            notifyStateChanged(GearStates.GEAR_MINIMIZED);
        }

        private function resize_overHandler(event:MouseEvent):void
        {
            _cursorID = CursorManager.setCursor(resizeCursor, 2, -10, -10);
        }

        private function resize_outHandler(event:MouseEvent):void
        {
            CursorManager.removeCursor(_cursorID);
        }

        private function resize_downHandler(event:MouseEvent):void
        {
            if (_resizable&&this.enableResizeButton)
            {
                stage.addEventListener(MouseEvent.MOUSE_MOVE, resize_moveHandler);
                stage.addEventListener(MouseEvent.MOUSE_UP, resize_upHandler);
            }
        }

        private function resize_moveHandler(event:MouseEvent):void
        {
            const minimumResizeWidth:Number = minWidth?minWidth:200;
            const minimumResizeHeight:Number = minHeight?minHeight:100;

            var bevGear:BaseGear;
            if (parent is IGear)
            {
                bevGear = parent as BaseGear;
            }
            if ((stage.mouseX<stage.width-20)&&(stage.mouseY<stage.height-20))
            {
                if ((stage.mouseX-parent.x)>minimumResizeWidth)
                {
                    width = (stage.mouseX-parent.x)-bevGear.leftPad;
                }
                if ((stage.mouseY-parent.y)>minimumResizeHeight)
                {
                    height = (stage.mouseY-parent.y)-bevGear.topPad;
                }
            }
        }

        private function resize_upHandler(event:MouseEvent):void
        {
            gearWidth = width;
            gearHeight = height;

            stage.removeEventListener(MouseEvent.MOUSE_MOVE, resize_moveHandler);
            stage.removeEventListener(MouseEvent.MOUSE_UP, resize_upHandler);

            var p:UIComponent = parent as UIComponent;
            p.stopDrag();
        }
    }

}
