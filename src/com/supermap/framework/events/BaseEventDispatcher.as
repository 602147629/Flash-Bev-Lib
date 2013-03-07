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
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.utils.Dictionary;
    
    import inject.Injector;

    /**
     *  基础事件派发器.
     *  通过该事件可以获取一个全局的事件派发器.
     *  它包含了对事件类型的一系列操作,确保事件流的
     *  各个阶段顺利进行.
     */
    public class BaseEventDispatcher
    {
        private static var instance:BaseEventDispatcher;

        private var eventDispatcher:IEventDispatcher;

        private static var commands:Dictionary = new Dictionary();

        /**
         * 构造函数
         */
        public function BaseEventDispatcher(target:IEventDispatcher = null)
        {
            eventDispatcher = new EventDispatcher(target);
        }

        /**
         * 返回单例类
         */
        public static function getInstance():BaseEventDispatcher
        {            
            instance ||= new BaseEventDispatcher();
            return instance;
        }

        /**
         *  绑定事件类型到命令(command)
         */
        public function addCommand(commandName:String, commandRef:Class, useWeakReference:Boolean = true):void
        {
            if (commands[commandName])
            {
                //暂不处理 直接覆盖已有的键
            }

            commands[commandName] = commandRef;
            getInstance().addEventListener(commandName, executeCommand, false, 0, useWeakReference);
        }

        /**
         *  移除事件类型到命令(command)的绑定
         */
        public function removeCommand(commandName:String, commandRef:Class):void
        {
            if (commands[commandName]===null)
                throw new Error("找不到该键");

            getInstance().removeEventListener(commandName, executeCommand);
            commands[commandName] = null;
            delete commands[commandName];
        }

        protected function executeCommand(event:BaseEvent):void
        {
            //根据事件类型取出来对应的command完全限定类名
            var commandToInitialise:Class = getCommand(event.type);
            var commandToExecute:* = Injector.getInstance().injectToCommand(commandToInitialise);
            commandToExecute.execute(event);
        }

        protected static function getCommand(commandName:String):Class
        {
            var command:Class = commands[commandName];

            if (command==null)
                throw new Error("找不到该键");

            return command;
        }

        /**
         * 添加监听
         */
        public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
        {
            eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
        }

        /**
         * 移除监听
         */
        public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
        {
            eventDispatcher.removeEventListener(type, listener, useCapture);
        }

        /**
         *  派发事件.这里主要是处理与事件绑定的command，使得事件派发是全局的单例来作为侦听器。
         */
        public function dispatchEvent(event:Event):Boolean
        {
            return eventDispatcher.dispatchEvent(event);
        }

//		public function dispatchEvent( event:BaseEvent ) : Boolean 
//		{
//			return eventDispatcher.dispatchEvent( event );
//		}

        /**
         * 判断是否包含了对某个事件的监听
         */
        public function hasEventListener(type:String):Boolean
        {
            return eventDispatcher.hasEventListener(type);
        }

        /**
         * 判断一个事件是否被触发.
         * 检查是否用此 EventDispatcher 对象或其任何始祖为指定事件类型注册了事件侦听器。
         * 将指定类型的事件分派给此 EventDispatcher 对象或其任一后代时，
         * 如果在事件流的任何阶段触发了事件侦听器，则此方法返回 true。
         */
        public function willTrigger(type:String):Boolean
        {
            return eventDispatcher.willTrigger(type);
        }
    }
}
