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
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import mx.core.*;

    /**
     * @private
     * @author gis
     */
    public class DragProxyImage extends UIComponent
    {
        private var rawImage:Bitmap;

        function DragProxyImage()
        {
        }

        /**
         *
         * @param param1
         * @param param2
         */
        public function dragSource(param1:DisplayObject, param2:MouseEvent):void
        {
            rawImage = new Bitmap();
            rawImage.bitmapData = new BitmapData(param1.width, param1.height, true, 0);
            rawImage.bitmapData.draw(param1);
            addChild(rawImage);
            rawImage.x = (-rawImage.width)/2;
            rawImage.y = (-rawImage.height)/2;
            var pt:* = new Point(0, 0);
            pt = param1.localToGlobal(pt);
            pt = parent.globalToLocal(pt);
            x = pt.x+rawImage.width/2+stage.mouseX-param2.stageX;
            y = pt.y+rawImage.height/2+stage.mouseY-param2.stageY;
            alpha = 0.5;
            startDrag();
        }
		
		/**
		 *  set border 2012.7.17 
		 */
		public function setBorder():void
		{
			graphics.lineStyle(1,0x2EA8E6,1);
			graphics.beginFill(0x2EA8E6, 1);
			graphics.drawRoundRectComplex(- rawImage.width/2, - rawImage.height/2, rawImage.width - 1, rawImage.height, 5, 5, 0, 0);
			//graphics.drawRect(- rawImage.width/2, - rawImage.height/2, rawImage.width + 1, rawImage.height + 1);
			graphics.endFill();
		}
		
		/**
		 *  clear border 2012.7.17 
		 */
		public function clearBorder():void
		{
			graphics.clear();
		}
    }
}
