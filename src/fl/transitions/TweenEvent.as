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
package fl.transitions
{
    import flash.events.*;
	/**
	 *  @private
	 */
    public class TweenEvent extends Event
    {
        public var time:Number = NaN;
        public var position:Number = NaN;
        public static const MOTION_START:String = "motionStart";
        public static const MOTION_STOP:String = "motionStop";
        public static const MOTION_LOOP:String = "motionLoop";
        public static const MOTION_CHANGE:String = "motionChange";
        public static const MOTION_FINISH:String = "motionFinish";
        public static const MOTION_RESUME:String = "motionResume";

        public function TweenEvent(param1:String, param2:Number, param3:Number, param4:Boolean = false, param5:Boolean = false)
        {
            time = NaN;
            position = NaN;
            super(param1, param4, param5);
            this.time = param2;
            this.position = param3;
        }

        override public function clone() : Event
        {
            return new TweenEvent(this.type, this.time, this.position, this.bubbles, this.cancelable);
        }
    }
}
