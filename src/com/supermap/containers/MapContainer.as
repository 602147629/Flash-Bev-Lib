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
package com.supermap.containers
{
    import com.supermap.framework.components.LayoutComponent;
    import com.supermap.framework.components.MapControl;
    import com.supermap.framework.events.LayoutEvent;
    import com.supermap.framework.events.PluginEvent;
    import com.supermap.web.core.Rectangle2D;
    import com.supermap.web.mapping.CloudLayer;
    import com.supermap.web.mapping.Map;
    import com.supermap.web.mapping.TiledDynamicRESTLayer;
    
    import flash.utils.Dictionary;
    
    import mx.events.FlexEvent;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    import mx.rpc.http.HTTPService;

	[Event(name = "mapPluginAdded", type = "com.supermap.framework.events.PluginEvent")]
    [Event(name = "layoutChanged", type = "com.supermap.framework.events.LayoutEvent")]
    /**
     *  主要用来读取map组件配置信息 并实现自身的初始化
     *  这里需要注意的是 在插件的操作方面 只提供对下一级别的操作 即针对map或者mapcontrol的操作
     *  如果要通过id直接取到layer的话 建议通过map单独处理
     *  插件容器本身不针对layer进行直接操作
     *  @param com.supermap.framework.components.MapControl
     */
    public class MapContainer extends LayoutContainer
    {
        public static const CLOUDLAYER:String = "CloudLayer";

        public static const TILEDDYNAMICRESTLAYER:String = "TiledDynamicRESTLayer";

        public function MapContainer()
        {
            super();
        }
		
        private var _configURL:String;

        private var _mapControls:Array;

        private var configURLChanged:Boolean = false;

        private var dict:Dictionary;
		
		private var _currentMap:Map;
		
		public function get currentMap():Map
		{
			return _currentMap;
		}

		public function set currentMap(value:Map):void
		{
			_currentMap = value;
		}

        /**
         *  获取配置文件路径
         */
        public function get configURL():String
        {
            return _configURL;
        }

        /**
         *  设置地图配置文件路径
         */
        public function set configURL(value:String):void
        {
            if (value&&value!=_configURL)
            {
                _configURL = value;
                configURLChanged = true;
            }
        }


        /**
         *  根据配置文件获取mapControl
         */
        public function getMapControl(mapControlId:String = ""):Object
        {
            return getPluginById(mapControlId);
        }

        /**
         *  获取地图配置后的数据
         *  @return Array
         */
        public function getMaps():Array
        {
            if (_mapControls)
            {
                return _mapControls;
            }
            else
                throw new Error("文件解析错误!请检查地图配置文件!");
        }

        /**
         *  发布应用程序级别上的数据共享。
         *  建议在container里采用notify的机制来处理事件派发流程。
         *  @param String 事件完全限定类名
         *  @param String 事件类型
         *  @param Model  事件数据对象
         *
         */
        override public function notify(evtClass:String = "", evtType:String = "", data:* = null):void
        {
			
        }

        /**
         *  根据配置文件里设置的ID移除mapControl
         */
        public function removeMapControl(mapControlId:String = ""):Object
        {
            return removePluginById(mapControlId);
        }

        /**
         *  获取该容器类名
         */
        override public function get type():String
        {
            return this.className;
        }

        override protected function commitProperties():void
        {
            super.commitProperties();
            if (configURLChanged)
            {
                configURLChanged = false;
                loadMaps();
                //notify("LayoutEvent", LayoutEvent.LAYOUT_CHANGED, {data:"mapChanged"});
            }
        }

        private function faultHandler(event:FaultEvent):void
        {

        }

        private function loadMaps():void
        {
            var httpService:HTTPService = new HTTPService();
            httpService.url = _configURL;
            httpService.addEventListener(ResultEvent.RESULT, resultHandler);
            httpService.addEventListener(FaultEvent.FAULT, faultHandler);
            httpService.resultFormat = "e4x";
            httpService.send();
        }

        private function mapCreateCompleteHandler(event:FlexEvent):void
        {
            for (var map:* in dict)
            {
                if (map==event.target)
                    (event.target as MapControl).viewBounds = dict[map];
            }
        }

        private function resultHandler(event:ResultEvent):void
        {
            var xml:XML = event.result as XML;
            var mapControls:XMLList = xml.MapContainer.MapControl;
            var mapsNum:int = 0;

            var mapControlNum:int = 0;
            if (mapControls)
            {
                mapControlNum = mapControls.length();
                _mapControls = [];
            }
            dict = new Dictionary();
            for (var i:int = 0; i < mapControlNum; i++)
            {
                //实例化map
                var map:MapControl = new MapControl();
                map.addEventListener(FlexEvent.CREATION_COMPLETE, mapCreateCompleteHandler);
                var viewBounds:String = mapControls[i].@viewbounds[0];
				var viewBoundsAry:Array;
				var view:Rectangle2D;
				if(viewBounds){
	                viewBoundsAry = viewBounds.split(",");
	                view = new Rectangle2D(Number(viewBoundsAry[0]), Number(viewBoundsAry[1]), Number(viewBoundsAry[2]), Number(viewBoundsAry[3]));
				}
				map.id = mapControls[i].@id[0];
				
				if(mapControls.@scales[0])
				{
					var scalesAry:Array = mapControls.@scales[0].split(",");
					var scaleLen:int = scalesAry.length;
					var scales:Array = [];
					for (var k:int = 0; k < scaleLen; k++)
					{
						scales.push(scalesAry[k]);
					}
					map.scales = scales;
				}
				
                this.addElement(map);
                _mapControls.push(map);
				currentMap = map;
                dict[map] = view;
                //取map节点里的子节点
                var children:XMLList = mapControls[i].children();
                var childrenNum:int = children.length();
                if (childrenNum)
                {
                    var layerName:String = children.localName();
                    if (layerName==CLOUDLAYER)
                    {
                        var cloudLayer:CloudLayer = new CloudLayer();
                        //cloudLayer.key = children.@key[0];
                        var strRes:Array = children.@resolutions[0].split(",");
                        var scaleNum:int = strRes.length;
                        var resolutions:Array = [];
                        for (var j:int = 0; j < scaleNum; j++)
                        {
							resolutions.push(strRes[j]);
                        }
                        //cloudLayer.resolutions = resolutions;

                        map.addLayer(cloudLayer);
                        map.viewBounds = view;
                    }
                    else if (layerName==TILEDDYNAMICRESTLAYER)
                    {
                        var tiledDynamicRestLayer:TiledDynamicRESTLayer = new TiledDynamicRESTLayer();
                        tiledDynamicRestLayer.url = children.@url[0];
                        map.addLayer(tiledDynamicRestLayer);
                        map.viewBounds = view;
                    }
                }
            }
			dispatchEvent(new PluginEvent(PluginEvent.MAPPLUGINADDED, this));
        }
    }
}
