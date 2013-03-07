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
    import spark.components.supportClasses.Skin;

    /**
     *  提供对baseComponent基础组件的默认边框风格的设置
     *  暂是低级别的控制
     *  @private
     */
    public interface IStyle
    {
        /**
         *  组件边框可见性(基础组件)
         */
        function setBorderEabled(isBorder:Boolean = true):void;

        /**
         *  组件边框样式(基础组件)
         */
        function setBorderStyle(style:Object):void;

        /**
         *  组件切换皮肤接口(基础模块)
         */
        function setComponentSkin(skin:Skin):void;

        /**
         *  组件间共享样式对象
         */
        function setStyleObject(value:Object):void

    }
}
