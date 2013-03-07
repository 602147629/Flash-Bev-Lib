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
    import com.supermap.framework.components.LayoutComponent;

    /**
     *  布局接口.主要用来设置容器组件的内部布局方式.
     *  @see com.supermap.framework.core.BaseLayout
	 *  @private
     */
    public interface ILayout
    {
        /**
         *  设置布局方式
         *  @param String 基础布局类型
         *  @param LayoutComponent 基础容器组件
         *  @see com.supermap.framework.core.BaseLayout
         */
        function setLayout(baseLayout:String = BaseLayout.ABSOLUTE, preLayout:String = BaseLayout.ABSOLUTE, parent:LayoutComponent = null):String;

        /**
         *  获取布局方式
         *  @return String
         *  @see com.supermap.framework.core.BaseLayout
         */
        function getLayout():String;

    }
}
