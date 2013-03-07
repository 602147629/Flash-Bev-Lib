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
    import com.supermap.containers.LayoutContainer;
    
    import flash.display.DisplayObject;
    import flash.events.*;
    
    import mx.containers.TabNavigator;
    import mx.core.*;
    import mx.events.FlexEvent;
    
    import spark.components.NavigatorContent;
    import spark.components.supportClasses.Skin;
    import spark.skins.SparkSkin;

    /**
     * 停靠面板内部的标签页
     * 该类主要处理了对内部容器显示上布局设置以及拖拽标签页逻辑的实现.
     * @see com.supermap.framework.dock.ClosableTabNavigator
     * @author gis
     */
    public class DockableTabNavigator extends ClosableTabNavigator implements IDockableContainer
    {
        /**
         *
         * @default
         */
        public var autoCreatePanelEnabled:Boolean = true;

        /**
         *
         * @default
         */
        public var multiTabEnabled:Boolean = true;

        /**
         *
         * @default
         */
        protected var _floatEnabled:Boolean = true;

        /**
         *
         * @default
         */
        public var dockId:String = "";

        private var bPanelFloat:Boolean = false;

        private var dragStarter:DragStarter;
		
		//private var _pluginContainer:Array;

        /**
         *
         */
        public function DockableTabNavigator()
        {
            addEventListener(FlexEvent.CREATION_COMPLETE, createCompleteHandler);
        }

        /**
         *  暂时设置为内容的自动剪切显示 布局是否显示滚动条还待完善 内容自适应问题......
         *  2012.4.19
		 *  添加滚动条 当内容宽高大于默认的宽高时候 则出现滚动条
		 *  2012.5.18 
         */
        private function createCompleteHandler(event:FlexEvent):void
        {
//            var num:int = this.numChildren;
//            for (var i:int = 0; i<num; i++)
//            {
//                (this.getChildAt(0) as NavigatorContent).layout.clipAndEnableScrolling = true;
//            }
        }

        private function tabDroped(param1:DockSource, param2:UIComponent, param3:String):void
        {
            //只允许子项数量为5 但是当程序启动的时候 用户配置项如果大于5是能够正常显示的  只是不允许再往里面拖拽新的标签页而已
            //TODO:对鼠标显示效果的屏蔽......
            if (this.owner is FloatPanel)
            {
                if (this.numChildren>=(this.owner as FloatPanel).tabLimitNum)
                {
                    return;
                }
            }
            else if (this.document is SparkSkin)
            {
                if (this.numChildren>=((this.document as SparkSkin).owner as FloatPanel).tabLimitNum)
                {
                    return;
                }
            }

            param1.targetTabNav.removeChild(param1.targetChild as DisplayObject);
			
			//取出来hit的那个标签页的索引
            var childIndex:*;
			if(this.tabBar.contains(param2 as DisplayObject))
				childIndex = this.tabBar.getChildIndex(param2);
			
            if (param3 == DockManager.RIGHT)
            {
                childIndex++;
            }
			if(childIndex !=　0 &&　!childIndex)
			{
				//处理到达movearea区域检测问题 dock后 并显示该标签页
				addChildAt(param1.targetChild as DisplayObject, this.tabBar.numChildren);
				childIndex = this.tabBar.numChildren - 1;
				//(this.tabBar.owner as TabNavigator).selectedIndex = this.tabBar.numChildren;
			}
			else{
	            //添加拖拽的子对象到tabnavigator对象显示列表里 
	            addChildAt(param1.targetChild as DisplayObject, childIndex);
			}
            tabBar.getChildAt(childIndex)["selected"] = true;
            tabBar.getChildAt(selectedIndex)["selected"] = false;
            getChildAt(selectedIndex).visible = false;
            selectedIndex = childIndex;
        }

        /**
         *
         * @return
         */
        public function get floatEnabled():Boolean
        {
            return _floatEnabled;
        }

        /**
         *
         * @param param1
         * @param param2
         * @param param3
         * @return
         */
        public function dockAsk(param1:DockSource, param2:UIComponent, param3:String):Boolean
        {
            if (multiTabEnabled
				&&(param1.targetChild != selectedChild || tabBar.getChildIndex(param2) != tabBar.selectedIndex)
				&&dockId == param1.dockId
				&&(param1.dockType == DockManager.DRAGTAB || param1.targetTabNav != this))
            {
                return true;
            }
            return false;
        }

        /**
         *
         * @param param1
         */
        public function set floatEnabled(param1:Boolean):void
        {
            _floatEnabled = param1;
        }

        /**
         *
         */
        public function toFloat():void
        {
            bPanelFloat = true;
        }

        override public function get explicitMinHeight():Number
        {
            var minHeight:* = super.explicitMinHeight;
            if (!isNaN(minHeight))
            {
                return minHeight;
            }
            if (selectedChild != null && !isNaN(selectedChild.explicitMinHeight))
            {
                return tabBar.minHeight+selectedChild.explicitMinHeight+getStyle("paddingTop")+getStyle("paddingBottom");
            }
            return tabBar.minHeight+getStyle("paddingTop")+getStyle("paddingBottom");
        }

        override protected function childrenCreated():void
        {
            super.childrenCreated();
            dragStarter = new DragStarter(tabBar);
            dragStarter.startListen(startDragTab);
        }

        override public function get explicitMinWidth():Number
        {
            var minWidth:* = super.explicitMinWidth;
            if (!isNaN(minWidth))
            {
                return minWidth;
            }
            if (selectedChild != null && !isNaN(selectedChild.explicitMinWidth))
            {
                return selectedChild.explicitMinWidth+getStyle("paddingLeft")+getStyle("paddingRight");
            }
            return getStyle("paddingLeft")+getStyle("paddingRight");
        }

        private function panelDroped(param1:DockSource):void
        {
            if (param1.targetTabNav == this)
            {
                return;
            }
            while (param1.targetTabNav.numChildren > 0)
            {
                addChild(param1.targetTabNav.removeChildAt(0));
            }
        }

        /**
         *
         * @param param1
         * @param param2
         * @param param3
         */
        public function dockIn(param1:DockSource, param2:UIComponent, param3:String):void
        {
            switch (param1.dockType)
            {
                case DockManager.DRAGTAB:
                {
                    tabDroped(param1, param2, param3);
                    break;
                }
                case DockManager.DRAGPANNEL:
                {
                    panelDroped(param1);
                    break;
                }
                default:
                {
                    break;
                }
            }
        }

        private function startDragTab(event:MouseEvent):void
        {
            var tab:*;
            if (event.target.owner is RichTab)
            {
                tab = UIComponent(event.target.owner);
            }
            else
                tab = UIComponent(event.target);
            var dockSource:* = new DockSource(DockManager.DRAGTAB, this, dockId);
            dockSource.targetChild = selectedChild;
            dockSource.tabInFloatPanel = bPanelFloat;
            dockSource.multiTabEnabled = multiTabEnabled;
            dockSource.floatEnabled = floatEnabled;
            dockSource.autoCreatePanelEnabled = autoCreatePanelEnabled;
            //trace("this.numChildren:" + this.numChildren);
            if (tab.stage)
                DockManager.doDock(tab, dockSource, event);
            //trace("dockableTabNavigator:" + tab);
        }
    }
}
