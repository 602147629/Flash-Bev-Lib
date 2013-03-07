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
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;

    [Bindable]
    [RemoteClass(alias = "dock.DockData")]
    /**
     *
     * @private
     * @author gis
     */
    public class DockData extends EventDispatcher
    {
        /**
         *  这里的name与titlewindow的title保持一一对应(废弃)
         */
        public var name:String;

        /**
         *  这里的图标也与titlewindow的titleimg保持一一对应(废弃)
         */
        public var icon:String;
    }
}
