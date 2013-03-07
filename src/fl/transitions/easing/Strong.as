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
package fl.transitions.easing
{
	/**
	 *  @private
	 */
    public class Strong extends Object
    {

        public function Strong()
        {
        }

        public static function easeOut(param1:Number, param2:Number, param3:Number, param4:Number) : Number
        {
            var _loc_5:* = param1 / param4 - 1;
            param1 = param1 / param4 - 1;
            return param3 * (_loc_5 * param1 * param1 * param1 * param1 + 1) + param2;
        }

        public static function easeIn(param1:Number, param2:Number, param3:Number, param4:Number) : Number
        {
            var _loc_5:* = param1 / param4;
            param1 = param1 / param4;
            return param3 * _loc_5 * param1 * param1 * param1 * param1 + param2;
        }

        public static function easeInOut(param1:Number, param2:Number, param3:Number, param4:Number) : Number
        {
            var _loc_5:* = param1 / (param4 / 2);
            param1 = param1 / (param4 / 2);
            if (_loc_5 < 1)
            {
                return param3 / 2 * param1 * param1 * param1 * param1 * param1 + param2;
            }
            var _loc_6:* = param1 - 2;
            param1 = param1 - 2;
            return param3 / 2 * (_loc_6 * param1 * param1 * param1 * param1 + 2) + param2;
        }

    }
}
