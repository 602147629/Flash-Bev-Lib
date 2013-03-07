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
    import flash.display.DisplayObject;
    import flash.events.MouseEvent;

    import mx.collections.IList;
    import mx.containers.ViewStack;
    import mx.controls.TabBar;
    import mx.core.*;
    use namespace mx_internal;

    /**
     * @private
     * @author gis
     */
    public class RichTabBar extends TabBar
    {
        /**
         *
         */
        public function RichTabBar()
        {
            super();
            navItemFactory = new ClassFactory(RichTab);
        }

        override protected function createNavItem(label:String, icon:Class = null):IFlexDisplayObject
        {
            var tab:RichTab = super.createNavItem(label, icon) as RichTab;
            tab.addEventListener(RichTab.CLOSE_TAB, onClickHandler);
            return tab;
        }

        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
        }

        private function onClickHandler(event:MouseEvent):void
        {
            var index:int = getChildIndex(DisplayObject(event.currentTarget));
            if (dataProvider is IList)
            {
                dataProvider.removeItemAt(index);
            }
            else if (dataProvider is ViewStack)
            {
                var vStack:ViewStack = ViewStack(this.dataProvider);
                var child:DisplayObject = vStack.getChildAt(index);
                vStack.removeChild(child);
            }
        }
    }
}

