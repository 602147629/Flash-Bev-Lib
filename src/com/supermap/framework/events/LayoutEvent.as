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
package com.supermap.framework.events
{
    import flash.events.Event;

    /**
     *  布局事件类型.
	 *  @private
     */
    public class LayoutEvent extends BaseEvent
    {
        /**
         *  当布局改变后派发该事件(已经初始化完毕)
         */
        public static const LAYOUT_CHANGED:String = "layoutChanged";

        /**
         *  当布局初始化完成之后派发
         */
        public static const LAYOUT_COMPLETE:String = "layoutComplete";

        public function LayoutEvent(type:String = "", data:Object = null)
        {
            super(type, data);
        }
    }
}
