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
    import com.supermap.framework.events.BaseEvent;
    
    import flash.events.Event;

    /**
     *  该类是兼容之前版本暂时留下来的事件类型,后续考虑与PluginEvent合并
     */
    public class GearEvent extends BaseEvent
    {
        //--------------------------------------------------------------------------
        //
        //  Class constants
        //
        //--------------------------------------------------------------------------
        /**
         * 定义当Gear载入URL时，GearEvent事件的type属性值。
         */
        public static const GEAR_LOAD_URL:String = "gearLoadURL";

        /**
         * 定义当Gear卸载URL时，GearEvent事件的type属性值。
         */
        public static const GEAR_UNLOAD_URL:String = "gearunLoadURL";

        /**
         * 定义当Gear初始化时，GearEvent事件的type属性值。
         */
        public static const GEAR_INITIALIZE:String = "gearInitialize";

        /**
         * 定义当Gear数据改变时，GearEvent事件的type属性值。
         */
        public static const GEAR_DATA_CHANGE:String = "gearDataChange";

        /**
         * 定义当Gear移除时，GearEvent事件的type属性值。
         */
        public static const GEAR_UNLOAD:String = "gearUnload";

        public static const GEAR_STYLE_CHANGE:String = "gearStyleChange";

        public static const GEAR_CHANGE_STATE:String = "gearChangeState";

        public static const GEAR_STATE_CHANGED:String = "gearStateChanged";

        public static const GEAR_STATE_FROM_MINIMIZED:String = "gearStateFromMinimized";

        public static const GEAR_FOCUS:String = "gearfocus";

        public static const GEAR_ADDED:String = "gearAdded";

        public static const GEAR_RUN:String = "gearRun";

        public static const GEAR_SHARE_DATA:String = "gearShareData";

        public static const GEAR_ACCORDION_CHANGE:String = "gearAccordionChange";

		public static const GEAR_TEMPLATE_RESIZE:String = "gearTemplateResize";
        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------
        /**
         * 处理Gear对象时，都会将 GearEvent 对象分派到事件流中。
         * @param type 定义事件类型。
         * @param data 定义事件信息。
         */
        public function GearEvent(type:String = "", data:Object = null)
        {
            super(type, data);
        }
    }
}
