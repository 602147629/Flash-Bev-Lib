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
    import mx.core.ClassFactory;

    import spark.components.DataGroup;

    [Event(name = "dockItemMouseOut", type = "flash.events.Event")]
    [Event(name = "dockItemMouseOver", type = "flash.events.Event")]
    [Event(name = "dockItemClick", type = "flash.events.Event")]

    /**
     * 停靠条内部数据对象
     * @see com.supermap.framework.dock.DockBarItemRenderer
     * @author gis
     */
    public class DockBarDataGroup extends DataGroup
    {
        /**
         *
         */
        public function DockBarDataGroup()
        {
            super();
            this.itemRenderer = new ClassFactory(DockBarItemRenderer);
        }
    }
}
