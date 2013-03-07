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
    import com.supermap.framework.GCPlus;
    import com.supermap.framework.core.IPlugin;
    import com.supermap.framework.events.BaseEventDispatcher;
    import com.supermap.framework.managers.EventManager;
    import com.supermap.web.mapping.Map;
    import com.supermap.web.sm_internal;

    use namespace sm_internal;

    /**
     *  框架本身用到的map类，该类继承SuperMap iClient for Flex里的map类
     *  这里不影响对map的使用，只是扩展了map，使得该地图组件在框架里当做一个插件使用。
     */
    public class MapControl extends Map implements IPlugin
    {
        sm_internal var listeners:Array = [];

        public function MapControl()
        {
            super();
        }

        /**
         *  TODO:派发全局共享数据
         *  @param String evtClass 事件类型完全限定名
         *  @param String evtType  事件类型
         *  @param Model 数据对象。
         */
        public function notify(evtClass:String = "", evtType:String = "", data:* = null):void
        {

        }

        /**
         *  返回插件类名
         *  @see IPlugin 插件接口
         */
        public function get type():String
        {
            return this.className;
        }

        /**
         *  获取事件总线
         */
        public function get EventBus():Object
        {
            return BaseEventDispatcher.getInstance();
        }

        //重载EventDispatcher		
        /** add Managed EventListener
         * @param  type
         * @param  listener
         * @param  useCapture
         * @param  priority
         * @param  useWeakPeference
         */
        public override function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakPeference:Boolean = false):void
        {
            if (listener!=null)
            {
                listeners.push({ theType: type, theListener: listener });
            }
            super.addEventListener(type, listener, useCapture, priority, useWeakPeference);
        }

        /**
         *  移除所有监听器
         */
        sm_internal function clearListeners():void
        {
            EventManager.getEventManagerInstance().clearListeners(this);
        }

        /**
         *  插件销毁
         *  注意：框架本身只是把内置的事件监听以及对象引用给移除，如果用户自己还写了引用，需要手动也清理掉，这样才会最终释放资源。
         *
         */
        public function destroy():void
        {
            clearListeners();
            GCPlus.clear(true);
        }

//		public function setInjector(injector:Injector = null) : void
//		{
//			
//		}
    }
}
