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
package com.supermap.framework.managers
{
    import com.supermap.framework.events.BaseEvent;
    import com.supermap.framework.events.BaseEventDispatcher;
    import com.supermap.web.sm_internal;

    import flash.events.Event;
    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;

    use namespace sm_internal;

    /**
     *  事件管理器.
     *  可获取一个全局事件的单例,也可以取到一个BaseEvent事件子类的实例.
     *  同时为每一个事件类型注册一个命令,以及对命令的管理操作等.
     *  @see com.supermap.framework.events.BaseEventDispatcher
     *  @private
     */
    public class EventManager
    {
        /**
         *  这里是一个静态的实例,实际指向一个继承自基础事件的实例
         */
        private static var evtInstance:BaseEvent;

        private static var instance:EventManager;

        public var eventDictionary:Dictionary;

        public function EventManager(config:String = null)
        {
            eventDictionary = new Dictionary();
        }

        public static function getEventManagerInstance():EventManager
        {
            return instance ||= new EventManager(null);
        }

        public function getInstance(evt:String = null):BaseEventDispatcher
        {
            return BaseEventDispatcher.getInstance();
        }

        /**
         *
         *  根据传递进来的字符串来获取对应的事件实例(对实例类型的判断还要加强...)
         *
         */
        public static function getEventInstance(evt:String = "", eventType:String = "", data:* = null, plugin:* = null):Event
        {
            var evtInstance:Event;
            var mata:Object = plugin.metaData;
            if (mata)
            {
                for each (var value:String in mata)
                {
                    if (String(mata.eventType).indexOf(evt)!=-1)
                    {
                        var classReference:Class = getDefinitionByName(mata.eventType) as Class;
                        evtInstance = new classReference(eventType);
                    }
                }
            }
            EventManager.getEventManagerInstance().eventDictionary[eventType] = evtInstance;
            return evtInstance;
        }

        /**
         *  移除所有监听器
         */
        public function clearListeners(plugin:*):void
        {
            for (var i:int = 0; i<plugin.listeners.length; i++)
            {
                plugin.removeEventListener(plugin.listeners[i]["theType"], plugin.listeners[i]["theListener"]);
            }
            plugin.listeners = [];
        }
    }
}
