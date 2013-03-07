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
package com.supermap.framework.components
{
    import flash.utils.Dictionary;

    /**
    *  组件委托管理类.
    *  该类主要使用本身的一个单例来管理组件委托对象(ComponentDelegate).
    *  通过该类可以检测加载到舞台上的对象是否已经被注册,也就是说只有注册到该类的对象才能正常使用框架本身的注入与命令等功能.
    *  TODO:该类开放的接口需要重新考虑一下......
    *  @private
    */
    public class ComponentDelegateManager
    {
        /**
        *  静态变量.
        */
        private static var viewLocator:ComponentDelegateManager;

        /**
        *  组件委托字典.
        */
        private var ComponentDelegates:Dictionary;

        /**
        *  获取本身的一个全局单例
        *  @return ComponentDelegateManager
        */
        public static function getInstance():ComponentDelegateManager
        {
            if (viewLocator==null)
                viewLocator = new ComponentDelegateManager();

            return viewLocator;
        }

        /**
        *  构造函数
        */
        public function ComponentDelegateManager()
        {
            if (ComponentDelegateManager.viewLocator!=null)
            {
//            throw new CairngormError(
//               CairngormMessageCodes.SINGLETON_EXCEPTION, "ViewLocator" );
            }

            ComponentDelegates = new Dictionary();
        }

        /**
        *  注册组件委托.
        *  通过管理组件委托来间接管理基础组件本身.
        *  @param String
        *  @param ComponentDelegate
        */
        public function register(viewName:String, viewHelper:ComponentDelegate):void
        {
            if (registrationExistsFor(viewName))
            {
//            throw new CairngormError(
//               CairngormMessageCodes.VIEW_ALREADY_REGISTERED, viewName );
            }

            ComponentDelegates[viewName] = viewHelper;
        }

        /**
         *  取消组件委托的注册信息.	   *
         *  @param String
         */
        public function unregister(viewName:String):void
        {
            if (!registrationExistsFor(viewName))
            {
//            throw new CairngormError(
//               CairngormMessageCodes.VIEW_NOT_FOUND, viewName );
            }

            delete ComponentDelegates[viewName];
        }

        /**
         *  根据组件委托ID获取组件委托实例.
         *  @param String
         */
        public function getComponentDelegate(viewName:String):ComponentDelegate
        {
            if (!registrationExistsFor(viewName))
            {
//            throw new CairngormError(
//               CairngormMessageCodes.VIEW_NOT_FOUND, viewName );
            }

            return ComponentDelegates[viewName];
        }

        /**
         *  获取组件委托内部对基础组件的引用.
         *  @param String
         *  @return Object 基础组件的引用
         */
        public function getComponent(viewName:String):Object
        {
            if (!getComponentDelegate(viewName))
            {
                throw new Error("没有找到应该包含的基础组件!");
            }
            return (ComponentDelegates[viewName] as ComponentDelegate).getComponentObj();
        }

        /**
         *  判断是否存在某个组件委托.
         *  @param String
         *  @return Boolean 返回一个逻辑值.
         */
        public function registrationExistsFor(viewName:String):Boolean
        {
            return ComponentDelegates[viewName]!=undefined;
        }
    }
}
