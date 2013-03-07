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
    import com.supermap.web.sm_internal;

    import flash.events.Event;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;

    use namespace sm_internal;

    /**
     *  基础事件类.
     *  该类是框架自定义事件的基类.
     *  通过自定义事件可以更好控制和展现数据流.
     *  自定义事件可以直接集成子该类.用户不必再为每一个自定义事件类覆写ToString方法与Clone方法.
     */
    public class BaseEvent extends Event
    {
        /**
         *  事件当前类型
         */
        protected var _currentType:String;

        /**
         *  事件数据
         */
        protected var _data:Object = null;

        /**
         *  构造函数
         *  @param Sting 事件类型
         *  @param Object 传入数据
         */
        public function BaseEvent(type:String = "", data:Object = null)
        {
            super(type);
            //事件当前类型为默认传入类型
            _currentType = type;
            //事件数据
            if (data!=null)
                _data = data;
        }

        /**
         *  设置数据
         *  @private
         */
        public function set data(value:Object):void
        {
            _data = value;
        }

        /**
         *  获取数据
         *  @return Object 如果不设置,默认为null
         */
        public function get data():Object
        {
            return _data;
        }


        /**
         *  获取事件当前类型
         *  @return String
         */
        public function get currentType():String
        {
            return _currentType;
        }

        /**
         *  设置事件当前类型
         *  @param String
         */
        public function set currentType(value:String):void
        {
            _currentType = value;
        }

        //----------------------------------------
        //
        //  override methods
        //
        //----------------------------------------
        /**
         *  覆写clone方法
         *  @return Event 返回自身的一个克隆
         */
        override public function clone():Event
        {
            var instance:Class = getDefinitionByName(toString()) as Class;
            var evt:* = new instance(currentType, data);
            return evt;
        }

        /**
         *  覆写toString方法
         *  @return String 返回完全限定类名
         */
        override public function toString():String
        {
            return getQualifiedClassName(this);
        }

        private static var instance:BaseEvent;

        /**
         * 获取一个事件单例
         * @return
         */
        public function getInstance():BaseEvent
        {
            var _instance:Class = getDefinitionByName(toString()) as Class;
            return instance ||= new _instance(currentType, data);
        }
    }
}
