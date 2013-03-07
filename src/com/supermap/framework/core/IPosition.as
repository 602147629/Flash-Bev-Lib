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
     *  布局接口.
     *  统一规范各个容器内部的布局规范.
     *  @private
     */
    public interface IPosition
    {
        /**
         *  XY绝对位置接口
         */
        function setXYPosition(x:Number, y:Number):void;
        /**
         *  相对位置接口
         */
        function setRelativePosition(left:String, right:String, top:String, bottom:String):void;

        /**
         *  拖拽接口
         */
        function set isDraggable(value:Boolean):void;
        function get isDraggable():Boolean;
        function set isResizeable(value:Boolean):void;
        function get isResizeable():Boolean;

    }
}
