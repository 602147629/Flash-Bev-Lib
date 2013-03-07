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
    import flash.geom.*;
    
    import mx.containers.TabNavigator;
    import mx.controls.Button;
    import mx.controls.TabBar;
    import mx.core.Container;
    import mx.core.UIComponent;
    import mx.managers.DragManager;
    
    import spark.components.Group;
    import spark.components.NavigatorContent;

	use namespace sm_internal;

    /**
     * @private
     * @author gis
     */
    public class DockFinder extends Object
    {

        /**
         *
         * @param param1
         * @return
         */
        public static function closestSideToBtn(param1:UIComponent):String
        {
            var bound:* = param1.getRect(param1);
            var rate:* = param1.mouseX/bound.width;
            if (rate<0.5)
            {
                return DockManager.LEFT;
            }
            return DockManager.RIGHT;
        }

        /**
         *
         * @param param1
         * @param param2
         * @return
         */
        public static function findHighestAccepter(param1:*, param2:String):*
        {
            switch (param2)
            {
                case DockManager.LEFT:
                case DockManager.RIGHT:
                {
                    return findHighestAccepterH(param1, param2);
                }
                case DockManager.TOP:
                case DockManager.BOTTOM:
                {
                    return findHighestAccepterV(param1, param2);
                }
                default:
                {
                    break;
                }
            }
            return null;
        }

        /**
         *
         * @param param1
         * @param param2
         * @return
         * @throws Error
         */
        public static function rateFromMouse(param1:UIComponent, param2:String):Number
        {
            var bound:* = param1.getRect(param1);
            var rateX:* = param1.mouseX/bound.width;
            var rateY:* = param1.mouseY/bound.height;
            switch (param2)
            {
                case DockManager.LEFT:
                {
                    return rateX;
                }
                case DockManager.TOP:
                {
                    return rateY;
                }
                case DockManager.RIGHT:
                {
                    return 1-rateX;
                }
                case DockManager.BOTTOM:
                {
                    return 1-rateY;
                }
                default:
                {
                    break;
                }
            }
            throw new Error("unknown side");
        }

        private static function findHighestAccepterH(param1:Container, param2:String):Container
        {
            var component:* = param1;
            var container:Container = null;
            var rate:Number = 0.25;
            while (rateFromMouse(component, param2)<rate&&rateFromMouse(param1, param2)<rate)
            {
                container = component;
                return container;
                rate = rate/2;
            }
            return container;
        }

        private static function findHighestAccepterV(param1:Container, param2:String):Container
        {
            var component:* = param1;
            var container:Container = null;
            var rate:Number = 0.25;
            while (rateFromMouse(component, param2)<rate&&rateFromMouse(param1, param2)<rate)
            {

                container = component;
                //TODO:
                return container;
                rate = rate/2;
            }
            return container;
        }

        function DockFinder()
        {
            clear();
        }

        /**
         *
         * @default
         */
        public var lastAccepter:UIComponent;

        /**
         *
         * @default
         */
        public var lastBtn:Button;

        /**
         *
         * @default
         */
        public var lastDistance:Number;

        /**
         *
         * @default
         */
        public var lastPanel:DockablePanel;

        /**
         *
         * @default
         */
        public var lastPosition:String;

        /**
         *
         * @default
         */
        public var lastTabBar:mx.controls.TabBar;

        /**
         *
         * @default
         */
        public var lastTabNav:DockableTabNavigator;

        private var checklog:Object;

        /**
         *
         * @param param1
         * @return
         */
        public function checkPanel(param1:DockSource):Boolean
        {
            lastPosition = closestSideToPanel(lastPanel);
            if (lastDistance>=0.25)
            {
                return false;
            }
            lastAccepter = findHighestAccepter(lastPanel, lastPosition);
            return lastPanel.dockAsk(param1, lastAccepter, lastPosition);
        }

        /**
         *
         * @param param1
         * @return
         */
        public function checkTabBar(param1:DockSource):Boolean
        {
            if (param1.dockType==DockManager.DRAGTAB)
            {
                lastPosition = closestSideToBtn(lastBtn);
                lastAccepter = lastBtn;
            }
            else
            {
                lastPosition = DockManager.WHOLE;
                lastAccepter = lastTabBar;
            }
            return lastTabNav.dockAsk(param1, lastAccepter, lastPosition);
        }
		
		sm_internal function checkTabBar2(param1:DockSource):Boolean
		{
			var tb:TabNavigator = param1.targetTabNav;
			
			var child:NavigatorContent = param1.targetChild as NavigatorContent;
			if(child && child.label == targetLabel){
				//trace("这是一样的!");
				return false;
			}
			return true;
		}

        /**
         *
         */
        public function clear():void
        {
            checklog = new Object();
        }

        /**
         *
         * @param param1
         * @return
         */
        public function closestSideToPanel(param1:UIComponent):String
        {
            var bound:* = param1.getRect(param1);
            var x:* = param1.mouseX/bound.width;
            var y:* = param1.mouseY/bound.height;
            var minX:* = 1-x;
            var minY:* = 1-y;
            lastDistance = Math.min(x, y, minX, minY);
            switch (lastDistance)
            {
                case x:
                {
                    return DockManager.LEFT;
                }
                case y:
                {
                    return DockManager.TOP;
                }
                case minX:
                {
                    return DockManager.RIGHT;
                }
                case minY:
                {
                    return DockManager.BOTTOM;
                }
                default:
                {
                    break;
                }
            }
            return "";
        }

        /**
         *
         * @param param1
         * @return
         */
        public function findPanel(param1:DisplayObject):Boolean
        {
            var displayObject:* = param1;
            while (displayObject!=DockManager.app)
            {

                if (displayObject is DockablePanel)
                {
                    lastPanel = DockablePanel(displayObject);
                    return true;
                }
                displayObject = displayObject.parent;
            }
            return false;
        }
		private var targetLabel:String;
        /**
         *  在鼠标拖拽标签页DockManangerImpl里mousemove的时候 会实时判断是否已经hit到了一个新的面板的标签页
         * @param param1
         * @return
         */
        public function findTabBar(param1:DisplayObject):Boolean
        {
			if((param1 is Group) && param1["id"] == "moveArea")
			{
				var fp:FloatPanel = ((param1 as Group).document as FloatPanelSkin).hostComponent;
				if(fp.numElements){
					var tb:TabNavigator = fp.getElementAt(0) as TabNavigator;
					if(tb && tb.numChildren == 1){
						targetLabel = (tb.getChildAt(0) as NavigatorContent).label;
						//trace("targetLabel:" +　targetLabel);
					}
				}					
			}
            var displayObject:* = param1;
            var i:int = 0;
            while (displayObject != DockManager.app)
            {
                if (displayObject is DockableTabNavigator)
                {
                    lastTabNav = DockableTabNavigator(displayObject);
                    i = i|4;
                    break;
                }
                else if (displayObject is mx.controls.TabBar)
                {
                    lastTabBar = TabBar(displayObject);
                    i = i|2;
                }
                else if (displayObject is Button)
                {
                    lastBtn = Button(displayObject);
                    i = i|1;
                }
                displayObject = displayObject.parent;
				
				if(DockManager.impl.isMoveArea && (displayObject is Group) && (displayObject as Group).document is FloatPanelSkin)
				{
					var floatPanel:FloatPanel = ((displayObject as Group).document as FloatPanelSkin).hostComponent;
					lastTabNav = floatPanel.tabNavigator as DockableTabNavigator;
					//这里把拖拽目标面板里的最后一个标签页richtab取出来 赋值给lastAccepter
					var lastLabel:String;
					if(lastTabNav.numChildren == 1)
					{
						lastLabel = (lastTabNav.getChildAt(0) as NavigatorContent).label;
					}
					lastAccepter = lastTabNav.getTabAt(lastTabNav.numChildren - 1);
					return true;
				}
            }
            if (i==7)
            {
                lastAccepter = lastBtn;
                return true;
            }
            return false;
        }
    }
}
