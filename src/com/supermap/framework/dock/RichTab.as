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
    import flash.events.MouseEvent;
    
    import mx.controls.Button;
    import mx.controls.tabBarClasses.Tab;
    import mx.core.*;
    import mx.events.FlexEvent;

    use namespace mx_internal;

    /**
     * @private
     * @author gis
     */
    public class RichTab extends Tab
    {
        /**
         *
         * @default
         */
        public static const CLOSE_TAB:String = "Close_Tab";

        /**
         *
         * @default
         */
        public var btn_Close:Button;

        [Embed(source = "assets/tab_close.png")]
        private var icon:Class;
		
		[Embed(source="assets/tab_close_over.png")]
		private var mouseOverIcon:Class;

        /**
         *
         */
        public function RichTab()
        {
            super();
            this.mouseChildren = true;
            addEventListener(FlexEvent.CREATION_COMPLETE, createCompleteHandler);
        }

        private function createCompleteHandler(event:FlexEvent):void
        {
            this.btn_Close.width = 2;
            this.btn_Close.height = 2;
            this.btn_Close.setStyle("icon", icon);
        }

        override protected function createChildren():void
        {
            super.createChildren();
            this.btn_Close = new Button();
            this.btn_Close.width = 2;
            this.btn_Close.height = 2;
            //this.btn_Close.setStyle("icon", IconUtil.getClass(this.btn_Close, "images/03.png"));
            this.btn_Close.toolTip = "关闭";
            this.btn_Close.name = "closeButton";
            this.btn_Close.addEventListener(MouseEvent.CLICK, onClickHandler);
			this.btn_Close.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			this.btn_Close.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
            this.addChild(this.btn_Close);
        }
		
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            this.setChildIndex(this.btn_Close, this.numChildren-1);
            if (this.selected)
            {
                this.btn_Close.visible = true;
                this.btn_Close.enabled = true;
            }
            else
            {
                this.btn_Close.visible = false;
                this.btn_Close.enabled = false;
            }
            this.btn_Close.width = 2;
            this.btn_Close.height = 2;
            this.btn_Close.x = unscaledWidth-this.btn_Close.width-6;
            this.btn_Close.y = 5;
        }

        private function onClickHandler(event:MouseEvent):void
        {
            this.dispatchEvent(new MouseEvent(RichTab.CLOSE_TAB));
            event.stopImmediatePropagation();
        }
		
		private function mouseOverHandler(event:MouseEvent):void
		{
			this.btn_Close.setStyle("icon", mouseOverIcon);
		}
		
		private function mouseOutHandler(event:MouseEvent):void
		{
			this.btn_Close.setStyle("icon", icon);
		}
    }
}

