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

    /**
     *  主要用来处理插件组件的事件类型,非gear功能的插件.
     *  在插件操作的过程中对应着事件类型的派发.
     */
    public class PluginEvent extends BaseEvent
    {
        /**
         *  插件全部加载完毕后派发该事件
         */
        public static const PLUGINADDED:String = "pluginAdded";
		public static const MAPPLUGINADDED:String = "mapPluginAdded";

        public function PluginEvent(type:String = "", data:Object = null)
        {
            super(type, data);
        }
    }
}
