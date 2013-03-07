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
    import com.supermap.containers.LayoutContainer;

    import flash.events.Event;

    import spark.primitives.Path;

    /**
     * 停靠条信息提示框
     * @author gis
     */
    public class ToolTipContainer extends LayoutContainer
    {

        [SkinPart(required = "false")]
        /**
         *
         * @default
         */
        public var path:Path;

        private var _currentItems:Array;

        private static var _instance:ToolTipContainer;

        /**
         *
         */
        public function ToolTipContainer()
        {
            super();
        }

        /**
         *
         * @return
         */
        public function get currentItems():Array
        {
            return _currentItems;
        }

        /**
         *
         * @param value
         */
        public function set currentItems(value:Array):void
        {
            _currentItems = value;
        }

        /**
         *
         * @return
         */
        public static function getInstance():ToolTipContainer
        {
            if (!_instance)
                return new ToolTipContainer();
            return _instance;
        }

        override protected function partAdded(partName:String, instance:Object):void
        {
            super.partAdded(partName, instance);
        }

        override protected function partRemoved(partName:String, instance:Object):void
        {
            super.partRemoved(partName, instance);
        }
    }
}
