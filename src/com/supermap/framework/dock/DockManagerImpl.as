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
package com.supermap.framework.dock
{
    import com.supermap.framework.skins.FloatPanelSkin;
    import com.supermap.web.sm_internal;
    
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    
    import mx.containers.*;
    import mx.core.*;
    import mx.managers.*;
    import mx.styles.*;
    
    import spark.components.Group;
	use namespace sm_internal;

    /**
     * @private
     * @author gis
     */
    public class DockManagerImpl extends Object
    {
        private var cursorClass:Class = null;

        private var dragImage:DragProxyImage = null;

        private var bDoingDock:Boolean = false;

        private var hintFocus:DisplayObject = null;

        private var PendApp:UIComponent = null;

        private var state:String = "dockDisable";

        private var dockHint:IFlexDisplayObject = null;

        private var dragInitiator:UIComponent;

        private var finder:DockFinder;

        private var dockSource:DockSource;

        private var cursorID:int = 0;

        private var _app:UIComponent = null;

        private var stage:Stage;

        private static const PANEL:String = "dockPANEL";

        private static const TAB:String = "dockTAB";

        private static const DISABLE:String = "dockDisable";

        private static const FLOAT:String = "dockFloat";

        function DockManagerImpl()
        {
            finder = new DockFinder();
        }

        /**
         *
         */
        protected function removeDockHint():void
        {
            if (dockHint)
            {
                dockHint.parent.removeChild(DisplayObject(dockHint));
                dockHint = null;
            }
        }

        /**
         *
         * @param param1
         */
        public function set app(param1:UIComponent):void
        {
            if (bDoingDock)
            {
                PendApp = param1;
            }
            else
            {
                _app = param1;
            }
        }

        //TODO:
        private function insertPanelH(param1:DockablePanel, param2:Container, param3:String):void
        {
        }

        /**
         *
         * @return
         */
        public function get dockType():String
        {
            return dockSource.dockType;
        }

        private function updateState(param1:String):void
        {
            if (this.state!=param1)
            {
                updateCursor(param1);
            }
            this.state = param1;
            if (param1==TAB||param1==PANEL)
            {
				if(isMoveArea)
					setHintposition(finder.lastAccepter, DockManager.RIGHT);
				else					
               		setHintposition(finder.lastAccepter, finder.lastPosition);
                dockHint.visible = true;
            }
            else
            {
                dockHint.visible = false;
            }
            if (param1==FLOAT)
            {
                dragImage.alpha = 1;
            }
            else
            {
                dragImage.alpha = 0.5;
            }
			
			//2012.7.17
			if(isMoveArea)
				isMoveArea = false;
        }

        /**
         *
         * @param param1
         */
        public function newDockableApp(param1:UIComponent):void
        {
            if (_app!=null)
            {
                return;
            }
            var component:* = param1;
            while (component!=null)
            {
                if (component is Canvas||component is Application)
                {
                    _app = Container(component);
                    return;
                }
                component = component.parent;
            }
        }

        private function createDragProxyImage(param1:UIComponent, param2:MouseEvent):DragProxyImage
        {
            dragImage = new DragProxyImage();
            dragInitiator.systemManager.popUpChildren.addChild(dragImage);
            dragImage.dragSource(param1, param2);
            return dragImage;
        }

        private function floatPanel():void
        {
            //trace("dockSource.targetTabNav.numChildren:" + dockSource.targetTabNav.numChildren);
            //当鼠标释放的时候判断拖拽出来的tab标签页是不是只有一个(一个panel里有一个tab的情况) 那么这个情况下 不要重新new一个panel 
            //这个情况下对标签页的拖拽需要屏蔽掉
            if (dockSource.targetTabNav.numChildren<2)
            {
                return;
            }
            var floatPanel:FloatPanel = null;
            if (dockSource.dockType==DockManager.DRAGTAB)
            {
                floatPanel = new FloatPanel(dockSource.targetChild);
            }
            else if (dockSource.dockType==DockManager.DRAGPANNEL)
            {
                floatPanel = new FloatPanel(dockSource.targetTabNav);
            }
            else
            {
                floatPanel = new FloatPanel();
            }
            FlexGlobals.topLevelApplication.addElement(floatPanel);
            var bound:* = dragImage.getBounds(app);
            floatPanel.move(bound.x, bound.y);
        }

        private function removeDragProxyImage():void
        {
            if (dragImage)
            {
                dragImage.parent.removeChild(dragImage);
                dragImage = null;
            }
        }

        /**
         *
         * @param param1
         * @param param2
         * @param param3
         * @return
         */
        public function doDock(param1:UIComponent, param2:DockSource, param3:MouseEvent):Boolean
        {
            if (bDoingDock||DragManager.isDragging)
            {
                return false;
            }
            this.dragInitiator = param1;
            stage = param1.stage;
            this.dockSource = param2;
            createDockHint();
            createDragProxyImage(param1, param3);
            stage.addEventListener(MouseEvent.MOUSE_UP, handleDockComplete);
            stage.addEventListener(MouseEvent.MOUSE_MOVE, handleDockMove);
            bDoingDock = true;
            return true;
        }

        /**
         *
         * @param param1
         * @param param2
         */
        public function movePanel(param1:Container, param2:String):void
        {
            var dockablePanel:DockablePanel = null;
            if (dockSource.dockType==DockManager.DRAGTAB)
            {
                dockablePanel = new DockablePanel(dockSource.targetChild);
            }
            else if (dockSource.dockType==DockManager.DRAGPANNEL)
            {
                dockablePanel = dockSource.targetPanel;
            }
            else
            {
                dockablePanel = new DockablePanel();
            }
            switch (param2)
            {
                case DockManager.LEFT:
                case DockManager.RIGHT:
                {
                    insertPanelH(dockablePanel, param1, param2);
                    return;
                }
                case DockManager.TOP:
                case DockManager.BOTTOM:
                {
                    insertPanelV(dockablePanel, param1, param2);
                    return;
                }
                default:
                {
                    break;
                }
            }
            return;
        }

        /**
         *
         * @return
         */
        public function get app():UIComponent
        {
            if (_app!=null)
            {
                return _app;
            }
            return UIComponent(FlexGlobals.topLevelApplication);
        }

        private function handleDockComplete(event:MouseEvent):void
        {
            switch (state)
            {
                case TAB:
                {
					//if(dockSource.targetTabNav != finder.lastTabNav){
					if(!isMoveArea)
                    	finder.lastTabNav.dockIn(dockSource, finder.lastBtn, finder.lastPosition);
					else{
						finder.lastTabNav.dockIn(dockSource, finder.lastBtn, finder.lastPosition);
//						isMoveArea = false;
					}
					//}
                    break;
                }
                case PANEL:
                {
                    movePanel(Container(finder.lastAccepter), finder.lastPosition);
                    break;
                }
                case FLOAT:
                {
                    floatPanel();
                    break;
                }
                default:
                {
                    break;
                }
            }
            endDock();
        }

        private function handleHitNothing():void
        {
            if (!dockSource.floatEnabled||dockSource.tabInFloatPanel||dockSource.dockType==DockManager.DRAGTAB&&!dockSource.autoCreatePanelEnabled)
            {
                updateState(DISABLE);
            }
            else
            {
                updateState(FLOAT);
            }
        }

        /**
         *
         * @return
         */
        public function hasApp():Boolean
        {
            return _app==null;
        }

        //TODO:
        private function insertPanelV(param1:DockablePanel, param2:Container, param3:String):void
        {
        }

        private function setHintposition(param1:UIComponent, param2:String):void
        {
            var rect:* = param1.getRect(dockHint.parent);
            switch (param2)
            {
                case DockManager.LEFT:
                {
                    rect.width = rect.width/4;
                    break;
                }
                case DockManager.TOP:
                {
                    rect.height = rect.height/4;
                    break;
                }
                case DockManager.RIGHT:
                {
                    rect.x = rect.x+3*rect.width/4;
                    rect.width = rect.width/4;
                    break;
                }
                case DockManager.BOTTOM:
                {
                    rect.y = rect.y+3*rect.height/4;
                    rect.height = rect.height/4;
                    break;
                }
                default:
                {
                    break;
                }
            }
            dockHint.width = rect.width;
            dockHint.height = rect.height;
            dockHint.move(rect.x, rect.y);
        }

        private function endDock():void
        {
            stage.removeEventListener(MouseEvent.MOUSE_UP, handleDockComplete);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleDockMove);
            dockSource = null;
            bDoingDock = false;
            removeDockHint();
            removeDragProxyImage();
            finder.clear();
            CursorManager.removeCursor(cursorID);
            cursorID = CursorManager.NO_CURSOR;
            if (PendApp!=null)
            {
                _app = PendApp;
                PendApp = null;
            }
        }

        private function handleDockMove(event:MouseEvent):void
        {
            var pt:* = new Point(FlexGlobals.topLevelApplication.mouseX, FlexGlobals.topLevelApplication.mouseY);
			//trace(FlexGlobals.topLevelApplication.mouseX, FlexGlobals.topLevelApplication.mouseY);
            var rect:* = FlexGlobals.topLevelApplication.getBounds(FlexGlobals.topLevelApplication);
            if (!rect.containsPoint(pt))
            {
                updateState(DISABLE);
                return;
            }
			var dragStageX:Number = FlexGlobals.topLevelApplication.mouseX;
			var dragStageY:Number = FlexGlobals.topLevelApplication.mouseY;
            var dis:* = findObjectsUnderPoint(event, dragStageX, dragStageY);
            if (dis == null)
            {
                handleHitNothing();
                return;
            }
			
			if(isMoveArea && finder.findTabBar(dis))
			{
				if (finder.checkTabBar2(dockSource))
				{
					updateState(TAB);
					return;
				}
			}
			
            if (dockSource.multiTabEnabled&&!dockSource.lockPanel&&finder.findTabBar(dis))
            {
                if (finder.checkTabBar(dockSource))
                {
                    updateState(TAB);
                }
                else
                {
                    updateState(DISABLE);
                }
                return;
            }
			
            if ((dockSource.dockType==DockManager.DRAGPANNEL||dockSource.autoCreatePanelEnabled)&&finder.findPanel(dis))
            {
                if (finder.checkPanel(dockSource))
                {
                    updateState(PANEL);
                    return;
                }
            }
            handleHitNothing();
        }
		
		sm_internal var isMoveArea:Boolean = false;
		private function findObjectsUnderPoint(event:MouseEvent = null, dragStageX:Number = 0, dragStageY:Number = 0):DisplayObject
		{
			var displayObject:DisplayObject = null;
			var array:* = app.getObjectsUnderPoint(new Point(FlexGlobals.topLevelApplication.stage.mouseX, FlexGlobals.topLevelApplication.stage.mouseY));
			var i:* = array.length-1;
			while (i>=0)
			{
				displayObject = array[i];
				
				//添加tab移动到movearea的判断......
				var rect:Rectangle;
				if(displayObject.toString().indexOf("moveArea") != -1)
				{
					if((displayObject as Group).document is FloatPanelSkin)
					{
						var moveArea:Group = displayObject as Group;
						var globalPt:Point = moveArea.localToGlobal(new Point(moveArea.x, moveArea.y));
						rect = new Rectangle(globalPt.x , globalPt.y , moveArea.width, moveArea.height);
					}
				}
				
				if(rect &&　rect.contains(dragStageX, dragStageY)){
					dragImage.stopDrag();
					dragImage.startDrag(false, new Rectangle(rect.x + 10, rect.y + 15, rect.width - 40, 0));
					dragImage.setBorder();
					//当鼠标在这里释放的时候 直接添加到索引的最后一个位置
					isMoveArea = true;
				}
				else
				{
					dragImage.stopDrag();
					dragImage.clearBorder();
					//dragImage.dragSource( this.dragInitiator, event);
					dragImage.startDrag();
				}
					
				if (displayObject!=dockHint&&displayObject!=dragImage&&!dragImage.contains(displayObject))
				{
					return displayObject;
				}
				i = i-1;
			}
			return null;
		}

        private function createDockHint():IFlexDisplayObject
        {
            var hit:Class = null;
            var param1:uint = 16776960;
            var param2:uint = 16711680;
            var param3:Number = 5;
            var i:Number = -1;
            var declaration:* = FlexGlobals.topLevelApplication.styleManager.getStyleDeclaration("net.goozo.mx.dockalbe.DockHint");
            if (declaration!=null)
            {
                hit = declaration.getStyle("hintSkin");
                param1 = declaration.getStyle("hintColorIn");
                param2 = declaration.getStyle("hintColorOut");
                i = declaration.getStyle("hintAlpha");
                param3 = declaration.getStyle("hintRadius");
            }
            if (hit==DockHint)
            {
                dockHint = new DockHint(param1, param2, param3);
            }
            else if (hit!=null)
            {
                dockHint = new hit;
            }
            else
            {
                dockHint = new DockHint();
            }
            if (i>=0)
            {
                dockHint.alpha = i;
            }
            dragInitiator.systemManager.popUpChildren.addChild(DisplayObject(dockHint));
            return dockHint;
        }

        /**
         *
         * @param param1
         */
        public function updateCursor(param1:String):void
        {
            var cursor:Class = null;
            var styleManager:IStyleManager2 = FlexGlobals.topLevelApplication.styleManager;
            var declaration:* = styleManager.getStyleDeclaration("mx.managers.DragManager");
            if (param1==TAB)
            {
                cursor = declaration.getStyle("copyCursor");
            }
            else if (param1==FLOAT)
            {
                cursor = declaration.getStyle("linkCursor");
            }
            else if (param1==DISABLE)
            {
                cursor = declaration.getStyle("rejectCursor");
            }
            else
            {
                cursor = declaration.getStyle("moveCursor");
            }
            if (cursor!=cursorClass)
            {
                cursorClass = cursor;
                if (cursorID!=CursorManager.NO_CURSOR)
                {
                    CursorManager.removeCursor(cursorID);
                }
                cursorID = CursorManager.setCursor(cursorClass, 2, 0, 0);
            }
        }
    }
}
