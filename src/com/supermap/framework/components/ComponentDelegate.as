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
    import com.supermap.containers.LayoutContainer;
    import com.supermap.framework.core.IBaseView;
    
    import flash.events.Event;
    
    import mx.events.FlexEvent;

    /**
    *  组件委托类.
    *  该类主要用来代理基础组件,当基础组件添加到舞台或者移除自舞台的时候进行监听,动态的注册到
    *  组件委托管理类里去.
    *  @private
    */
    public class ComponentDelegate implements IBaseView
    {
        /**
        *  代表一个基础组件的引用
        */
        protected var component:Object;

        /**
        *  基础组件的ID标识
        *  该id在基础组件里覆写过
        */
        protected var id:String;

        /**
        *  构造函数
        *  @param Object 第一个参数为基础组件
        *  @param String 第二个参数为基础组件的Id,默认为空
        */
        public function ComponentDelegate(document:Object, id:String = "")
        {
            initialized(document, id);
        }

        /**
        *  组件初始化处理函数
        *  @param Object 第一个参数为基础组件
        *  @param String 第二个参数为基础组件的Id
        */
        public function initialized(document:Object, id:String):void
        {
            this.component = document;

			if(!id)
				this.id = this.component.name;//要求用户必须设置id 但是没有设置的时候 默认使用name 那么在cmd里需要用这个代替id 否则报错
			else
            	this.id = id;

            component.addEventListener(Event.ADDED, registerView);
            component.addEventListener(Event.REMOVED, unregisterView);
            //component.addEventListener(FlexEvent.CREATION_COMPLETE, createCompleteHandler);
            //如果只是添加到容器 并没有进入到监听 但是已经到舞台上去了 这个时候也要应该注册到字典类里 
			//这里的判断需要完善  2012.5.27
			if(this.component is LayoutContainer)
			{
				ComponentDelegateManager.getInstance().register(id, this);
			}
        }

        private function createCompleteHandler(event:FlexEvent):void
        {
            ComponentDelegateManager.getInstance().register(id, this);
        }

        /**
        *  把组件注册到组件委托管理类中
        *  @param Event
        */
        public function registerView(event:Event):void
        {
            if (event.target==component)
            {
                ComponentDelegateManager.getInstance().register(id, this);
            }
        }

        /**
         *  取消组件在组件委托管理类中的注册信息
         *  @param Event
         */
        public function unregisterView(event:Event):void
        {
            if (event.target==component)
            {
                ComponentDelegateManager.getInstance().unregister(id);
            }
        }

        /**
        *  获取该组件的Id
        */
        public function get viewId():String
        {
            return id;
        }

        /**
        *  获取当前组件委托类里对应的基础组件的引用
        *  @param Object 返回component属性
        */
        public function getComponentObj():Object
        {
            if (!component)
            {
                //抛出错误......
            }
            return component;
        }
    }
}

