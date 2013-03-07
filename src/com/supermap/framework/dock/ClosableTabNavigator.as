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
    import com.supermap.framework.events.BaseEventDispatcher;
    import com.supermap.framework.events.FloatPanelEvent;
    import com.supermap.framework.skins.FloatPanelSkin;
    
    import flash.display.*;
    
    import mx.containers.*;
    import mx.core.*;
    
    import spark.components.NavigatorContent;

    /**
     * 停靠面板内部的标签页基类
     * @see mx.containers.TabNavigator
     * @author gis
     */
    public class ClosableTabNavigator extends TabNavigator
    {
        /**
         *
         * @default
         */
        public var autoRemove:Boolean = true;

        /**
         *  构造函数
         */
        public function ClosableTabNavigator()
        {

        }

        //todo:...
        /**
         *  @private
         */
        public function closeChild():void
        {
            if (selectedChild is IDockableTabChild&&IDockableTabChild(selectedChild).closeTabEnabled)
            {
                if (IDockableTabChild(selectedChild).closeTab())
                {
                    removeChild(selectedChild as DisplayObject);
                }
            }
        }

        /**
         *  覆写removechild方法保留之前的对mx.control.TitleWindow的处理
         *  同时增加对spark.conponments.TitleWindow的处理
         *  2012.4.6
         */
        override public function removeChild(param1:DisplayObject):DisplayObject
        {
            var childChangeEvent:ChildChangeEvent = null;
            var navigatorContent:NavigatorContent = null;
            if (param1 == selectedChild)
            {
                if (selectedIndex != (numChildren-1))
                {
                    childChangeEvent = new ChildChangeEvent(ChildChangeEvent.CHILD_CHANGE);
                    navigatorContent = NavigatorContent(getChildAt((selectedIndex+1)));
                    childChangeEvent.newTitle = navigatorContent.label;
                    if (navigatorContent is IDockableTabChild)
                    {
                        childChangeEvent.useCloseButton = IDockableTabChild(navigatorContent).closeTabEnabled;
                    }
                    dispatchEvent(childChangeEvent);
                }
            }
            var child:* = super.removeChild(param1);
            if (numChildren == 0)
            {
                if (autoRemove && parent!=null)
                {
					var floatPanel:FloatPanel;
                    if (this.document is FloatPanelSkin)
                    {
                        floatPanel = (this.document as FloatPanelSkin).hostComponent as FloatPanel;
                        if (floatPanel)
                        {
                            //从容器里移除 
                            if (floatPanel.contains(this))
                                floatPanel.removeElement(this);
                        }
                    }
                    else
                    {
                        if (this.owner is FloatPanel)
                        {
							floatPanel =  FloatPanel(this.owner);
							floatPanel.removeElement(this);
                        }
                    }
					BaseEventDispatcher.getInstance().dispatchEvent(new FloatPanelEvent(FloatPanelEvent.FLOATPANEL_REMOVE, floatPanel));
                }
                else
                {
                    dispatchEvent(new ChildChangeEvent(ChildChangeEvent.CHILD_CHANGE));
                }
            }
            return child;
        }

        /**
         *  @override
         */
        override public function set selectedIndex(param1:int):void
        {
            var navigatorContent:NavigatorContent = null;
            super.selectedIndex = param1;
            var childChangeEvent:ChildChangeEvent = new ChildChangeEvent(ChildChangeEvent.CHILD_CHANGE);
            if (param1 >= 0)
            {
                navigatorContent = NavigatorContent(getChildAt(param1));
                childChangeEvent.newTitle = navigatorContent.label;
                if (navigatorContent is IDockableTabChild)
                {
                    childChangeEvent.useCloseButton = IDockableTabChild(navigatorContent).closeTabEnabled;
                }
            }
            dispatchEvent(childChangeEvent);
        }

        /**
         *  覆写方法.实现自定义的TabBar
         *  @override
         */
        override protected function createChildren():void
        {
            if (!this.tabBar)
            {
                this.tabBar = new RichTabBar();
                this.tabBar.name = "tabBar";
                this.focusEnabled = true;
                this.tabBar.styleName = this;
                this.tabBar.setStyle("borderStyle", "none");
                this.tabBar.setStyle("paddingTop", 0);
                this.tabBar.setStyle("paddingBottom", 0);
                rawChildren.addChild(this.tabBar);
            }
            super.createChildren();
            this.invalidateSize();
        }

        /**
         *  @override
         */
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
        }
    }
}
