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

    import mx.core.*;

    /**
     * @private
     * @author gis
     */
    public class DockManager extends Object
    {
        /**
         *
         * @default
         */
        public static const DRAGTAB:String = "dragTab";

        /**
         *
         * @default
         */
        public static const FLOAT:String = "dockFloat";

        /**
         *
         * @default
         */
        public static const OUTSIDE:String = "outside";

        /**
         *
         * @default
         */
        public static const LEFT:String = "dockLeft";

        /**
         *
         * @default
         */
        public static const DRAGPANNEL:String = "dragPannel";

        /**
         *
         * @default
         */
        public static const WHOLE:String = "dockWhole";

        /**
         *
         * @default
         */
        public static const BOTTOM:String = "dockBottom";

        /**
         *
         * @default
         */
        public static const TOP:String = "dockTop";

        /**
         *
         * @default
         */
        public static const RIGHT:String = "dockRight";

        private static var _impl:DockManagerImpl = null;

        /**
         *
         */
        public function DockManager()
        {
        }

        /**
         *
         * @param param1
         */
        public static function set app(param1:UIComponent):void
        {
            impl.app = param1;
        }

        /**
         *
         * @param param1
         */
        public static function newDockableApp(param1:IDockableDividedBox):void
        {
            impl.newDockableApp(UIComponent(param1));
        }

        /**
         *
         * @param param1
         * @param param2
         * @param param3
         * @return
         */
        public static function doDock(param1:UIComponent, param2:DockSource, param3:MouseEvent):Boolean
        {
            return impl.doDock(param1, param2, param3);
        }

        public static function get impl():DockManagerImpl
        {
            if (_impl==null)
            {
                _impl = new DockManagerImpl();
            }
            return _impl;
        }

        /**
         *
         * @return
         */
        public static function get app():UIComponent
        {
            return impl.app;
        }

        /**
         *
         * @return
         */
        public static function hasApp():Boolean
        {
            return impl.hasApp();
        }
    }
}
