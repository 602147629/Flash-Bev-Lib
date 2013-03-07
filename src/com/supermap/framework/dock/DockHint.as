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
     *  @private
     */
    public class DockHint extends UIComponent
    {
        private var radius:Number;

        private var outColor:uint;

        private var inColor:uint;

        public function DockHint(param1:uint = 16776960, param2:uint = 16711680, param3:Number = 4)
        {
            this.inColor = param1;
            this.outColor = param2;
            this.radius = param3;
        }

        override protected function updateDisplayList(param1:Number, param2:Number):void
        {
            super.updateDisplayList(param1, param2);
            graphics.clear();
            graphics.lineStyle(2, inColor, 1, true);
            graphics.drawRoundRect(3, 3, param1-6, param2-6, radius);
            graphics.lineStyle(2, outColor, 1, true);
            graphics.drawRoundRect(1, 1, param1-2, param2-2, radius);
        }
    }
}
