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
    import flash.events.*;

    /**
     * 标签页索引改变事件.
     * @see com.supermap.framework.dock.ClosableTabNavigator
     * @see com.supermap.framework.dock.DockableTabNavigator
     * @author gis
     */
    public class ChildChangeEvent extends Event
    {
        /**
         *
         * @default
         */
        public var newTitle:String = "";

        /**
         *
         * @default
         */
        public var useCloseButton:Boolean = false;

        /**
         *
         * @default
         */
        public static const CHILD_CHANGE:String = "childChange";

        /**
         *
         * @param param1
         * @param param2
         * @param param3
         */
        public function ChildChangeEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
        {
            super(param1, param2, param3);
        }
    }
}
