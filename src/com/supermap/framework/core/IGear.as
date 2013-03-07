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

    //import com.supermap.web.mapping.Map;

    /**
     *  基础模块接口.
     *  规范了基础模块要实现的几个基础功能方面.
     *  @see com.supermap.framework.components.BaseGear
     */
    public interface IGear extends IPlugin
    {
        /**
         *  ID
         */
        function setId(value:String):void;
        function getId():String;

        /**
         *  Title
         */
        function setTitle(value:String):void;
        function getTitle():String;

        /**
         *  Icon
         */
        function setIcon(value:String):void;
        function getIcon():String;

        /**
         *  Map
         *  这个考虑把接口放在iplugin接口里定义
         */
        //function setMap(value:Map):void;

        /**
         *  预加载
         *  @param String
         */
        function setPreload(value:String):void;

        /**
         *  配置文件
         * @param Object
         */
        function setConfigData(value:Object):void;

    }
}
