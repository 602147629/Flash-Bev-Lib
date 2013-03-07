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
package com.supermap.framework.commands
{
    import com.supermap.framework.events.BaseEvent;

    /**
    *   该类描述了事件回调后的处理逻辑.主要职责是接受事件回调函数返回的事件类型,并从中获取数据.
    *
    */
    public class Command implements ICommand
    {
        /**
         *  构造函数
         */
        public function Command()
        {

        }

        /**
         *  绑定事件类型的回调处理函数,一般需要在自定义的Command类里覆写该方法
         *  @param BaseEvent
         */
        public function execute(event:BaseEvent):void
        {

        }
    }
}
