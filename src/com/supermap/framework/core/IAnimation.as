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

    /**
     *  该接口统一规范动画功能,提供常用基础动画的目标设置等功能.
     *  @private
     */
    public interface IAnimation
    {
        /**
         *  TODO:支持简单的动画设置 比如 move resize animation时间轴动画等
         *
         */
        function set componentAnimation(animation:Object):void;
        function get componentAnimation():Object;

        /**
         *  销毁对象上的所有动画实例
         */
        function clearAnimation():void;

        /**
         *  后期提供pbj链接接口(高级)
         */
        function setAnimationShader(shader:Class):void;

    }
}
