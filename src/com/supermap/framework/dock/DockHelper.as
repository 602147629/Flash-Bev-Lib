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
    import mx.core.*;

    /**
     * @private
     * @author gis
     */
    public class DockHelper extends Object
    {

        function DockHelper()
        {
        }

        /**
         *
         * @param param1
         * @param param2
         */
        public static function replace(param1:UIComponent, param2:UIComponent):void
        {
            if (param1.parent==null)
            {
                return;
            }
            param2.x = param1.x;
            param2.y = param1.y;
            param2.height = param1.height;
            param2.width = param1.width;
            param2.percentHeight = param1.percentHeight;
            param2.percentWidth = param1.percentWidth;
            param2.setStyle("left", param1.getStyle("left"));
            param2.setStyle("right", param1.getStyle("right"));
            param2.setStyle("top", param1.getStyle("top"));
            param2.setStyle("bottom", param1.getStyle("bottom"));
            param2.setStyle("baseline", param1.getStyle("baseline"));
            param2.setStyle("horizontalCenter", param1.getStyle("horizontalCenter"));
            param2.setStyle("verticalCenter", param1.getStyle("verticalCenter"));
            var childIndex:* = param1.parent.getChildIndex(param1);
            param1.parent.addChildAt(param2, childIndex);
            param1.parent.removeChild(param1);
        }
    }
}
