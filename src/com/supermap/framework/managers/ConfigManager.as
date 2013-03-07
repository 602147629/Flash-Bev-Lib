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
package com.supermap.framework.managers
{
    import com.supermap.framework.commands.ICommand;
    import com.supermap.framework.core.IPlugin;

    import flash.events.Event;
    import flash.events.EventDispatcher;

    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    import mx.rpc.http.HTTPService;

    /**
     *  配置管理器.
     *  TODO：可以返回基础组件以及基础模块的元数据信息。
     *  @private
     */
    public class ConfigManager extends EventDispatcher
    {
        /**
         *  配置文件路径
         */
        public static const CONFIG:String = "config.xml";

        /**
         *  默认的容器包路径
         */
        public static var ContainerPackagePath:String = "com.supermap.containers";

        public static var ComponentPackagePath:String = "com.supermap.framework.components";

        public static var instance:ConfigManager;

        public var configData:Array;

        private var httpService:HTTPService;

        /**
         *
         *  解析congfig文件
         *
         */
        public function ConfigManager(component:IPlugin = null, command:ICommand = null)
        {
            if (!instance)
            {
                if (CONFIG&&!httpService)
                {
                    httpService = new HTTPService();
                    httpService.url = "config.xml";

                    httpService.addEventListener(ResultEvent.RESULT, resultHandler);
                    httpService.addEventListener(FaultEvent.FAULT, faultHandler);
                    httpService.resultFormat = "e4x";
                    httpService.send();

                }
            }
            else
                instance = new ConfigManager(component, command);
        }

        public static function getInstance():ConfigManager
        {
            return instance ||= new ConfigManager(null, null);
        }

        private function resultHandler(evt:ResultEvent):void
        {
            configData = [];
            var xml:XML = evt.result as XML;

            var baseContainerValue:String = xml.BaseComponent.@includeIn;
            var baseGear:String = xml.BaseGear.@includeIn;
            var baseTemplateValue:String = xml.BaseTemplate.@includeIn;

            var xmlList:XMLList = xml.children();
            var i:int = xmlList.length();

            var vectorKey:Vector.<String> = new Vector.<String>();
            var vectorValue:Vector.<String> = new Vector.<String>();

            for (var j:int = 0; j<i; j++)
            {
                var localName:String = xmlList[j].localName();
                var localContainer:String = xmlList[j].@includeIn;
                vectorKey.push(localName);
                vectorValue.push(localContainer);
            }
            configData.push(vectorKey, vectorValue);
            dispatchEvent(new Event("config"));
        }

        private function faultHandler(evt:FaultEvent):void
        {

        }

        /**
         *  根据传入的键获取到对应的值
         *  @param String 传入key
         *  @return String 返回值
         */
        public function getValue(key:String = ""):String
        {
            var returnValue:String = "";
            if (configData&&configData.length)
            {
                var vectorKey:Vector.<String>;
                var vectorValue:Vector.<String>;

                vectorKey = configData[0];
                vectorValue = configData[1];

                var len:int = vectorKey.length;
                for (var i:int = 0; i<len; i++)
                {
                    if (key==vectorKey[i])
                    {
                        returnValue = vectorValue[i];
                        return ContainerPackagePath+"."+returnValue;
                    }
                }
            }
            return returnValue;
        }

        public function getKey(value:String = ""):String
        {
            var returnKey:String = "";
            if (configData&&configData.length)
            {
                var vectorKey:Vector.<String>;
                var vectorValue:Vector.<String>;

                vectorKey = configData[0];
                vectorValue = configData[1];

                var len:int = vectorKey.length;
                for (var i:int = 0; i<len; i++)
                {
                    if (value==vectorValue[i])
                    {
                        returnKey = vectorKey[i];
                        return returnKey;
                    }
                }
            }
            return returnKey;
        }
    }
}
