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
     *  插件寄存在baseContianer里 是对baseComponent(插件实例)的操作
     *  最终都是以类似操作Element的方式来进行装卸的 因为这里暂不开放PluginEvent事件
     *  相关功能可以通过SDK内部的ElementADD等事件来进行监听即可.
     *  该接口更多的表征这个名称的含义 不带有太多的具体功能实现
     *  继承该接口的主要有IGear, ITemplate, BaseComponent
     *
     *  @see com.supermap.framework.core.IGear
     *  @see com.supermap.framework.core.ITemplate
     *  @see com.supermap.framework.components.BaseComponent
     */
    public interface IPlugin
    {

        /**
         *  全局共享数据接口.
     	 *  通过派发事件来把装载的数据传递出去,由于基础模块与基础组件都实现了该接口,因此在整个应用程序
         *  域内都可以拿到这个数据原型.
         *  @see com.supermap.framework.model.Model
         */
        function notify(evtClass:String = "", evtType:String = "", data:* = null):void

        /**
         *  返回该类ClassName
         */
        function get type():String;

        /**
         *  事件总线
         */
        function get EventBus():Object;

        /**
         *  插件销毁
         */
        function destroy():void;

	    /**
	     *  设置依赖注入器
	     */
         //function setInjector(injector:Injector = null) : void;
    }
}
