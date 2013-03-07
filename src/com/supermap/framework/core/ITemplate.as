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
     *  统一模板接口.
     *  该接口规范了模板逻辑的功能职责.
     *  @see com.supermap.framework.core.GearTemplate
     */
    public interface ITemplate extends IPlugin
    {
        /**
         *  设置基础模块
         */
        function set baseGear(value:IGear):void;

        /**
         *  设置基础模块状态(该接口考虑与IState接口的关系)
         *  @private
         */
        function set gearState(value:String):void;
    }
}
