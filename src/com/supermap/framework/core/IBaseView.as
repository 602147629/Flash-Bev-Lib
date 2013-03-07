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
package com.supermap.framework.core
{
    import flash.events.Event;

    /**
     *  组件委托接口.
     *  用来规范组件委托要实现的功能.
     *  @see com.supermap.framework.components.ComponentDelegate
     *  @private
     */
    public interface IBaseView
    {
        /**
         *  注册
         *  @param flash.events.Event
         *
         */
        function registerView(event:Event):void;
        /**
         *  取消注册
         *  @param flash.events.Event
         *
         */
        function unregisterView(event:Event):void;
        /**
         *  获取id
         *  @return String
         *
         */
        function get viewId():String;
    }
}
