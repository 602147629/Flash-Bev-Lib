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

    import spark.components.NavigatorContent;

    /**
     * @private
     * @author gis
     */
    public class DockSource extends Object
    {
        /**
         *
         * @default
         */
        public var tabInFloatPanel:Boolean = false;

        /**
         *
         * @default
         */
        public var floatEnabled:Boolean = true;

        /**
         *
         * @default
         */
        public var autoCreatePanelEnabled:Boolean = true;

        /**
         *
         * @default
         */
        public var targetChild:INavigatorContent;

        /**
         *
         * @default
         */
        public var multiTabEnabled:Boolean = true;

        /**
         *
         * @default
         */
        public var dockType:String;

        /**
         *
         * @default
         */
        public var dockId:String;

        /**
         *
         * @default
         */
        public var targetPanel:DockablePanel;

        /**
         *
         * @default
         */
        public var lockPanel:Boolean = false;

        /**
         *
         * @default
         */
        public var targetTabNav:DockableTabNavigator;

        /**
         *
         * @param param1
         * @param param2
         * @param param3
         */
        public function DockSource(param1:String, param2:DockableTabNavigator, param3:String = "")
        {
            this.dockType = param1;
            this.targetTabNav = param2;
            this.dockId = param3;
        }
    }
}
