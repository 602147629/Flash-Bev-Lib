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
    import com.supermap.framework.components.BaseGear;
    import com.supermap.framework.components.LayoutComponent;
    import com.supermap.framework.core.*;
    import com.supermap.framework.events.PluginEvent;
    import com.supermap.web.mapping.Map;
    import com.supermap.web.sm_internal;
    import com.supermap.web.utils.Hashtable;
    
    import flash.system.ApplicationDomain;
    
    import mx.core.IVisualElement;
    import mx.events.FlexEvent;
    import mx.events.ModuleEvent;
    import mx.modules.IModuleInfo;
    import mx.modules.ModuleManager;

    use namespace sm_internal;

    /**
     *  基础模块容器.
     *  该容器主要用来装载继承自BaseGear的模块(不需要用GearTemplate模板以区分TemplateContainer).
     *
     */
    public class GearContainer extends LayoutComponent
    {
        private var gearArray:Array;

        private var gearObject:Object;

        private var gearLeft:String;

        private var gearTop:String;

        private var gearRight:String;

        private var gearBottom:String;
		
		private var hCenter:String;
		
		private var vCenter:String;

        private var info:IModuleInfo;

        private var gearTable:com.supermap.web.utils.Hashtable = new Hashtable();

        private var moduleTable:Hashtable = new Hashtable();

        private var _gearLayout:String;

        private var _map:Map;

        private var _gearContainerData:Object;

        /**
         *  构造函数
         */
        public function GearContainer()
        {
            this.addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
        }

        /**
         *  获取容器布局类型
         *  @return String 默认为BaseLayout.ABSOLUTE
         */
        public function get gearLayout():String
        {
            return _gearLayout;
        }

        /**
         *  获取该容器的类名
         */
        override public function get type():String
        {
            return this.className;
        }

        /**
         *  获取加载数据项
         *
         */
        public function get gearContainerData():Object
        {
            return _gearContainerData;
        }

        /**
         *  设置加载数据项
         *  一般该数据通过外部xml数据解析后传入
         */
        public function set gearContainerData(value:Object):void
        {
            if (value)
            {
                _gearContainerData = value;
            }
        }

        /**
         *  获取map
         */
        public function get map():Map
        {
            return _map;
        }

        /**
         *  设置map
         */
        public function set map(value:Map):void
        {
            _map = value;
        }

        /**
         * 容器创建完成后，根据配置文件设置容器的布局和加载模块
         */
        private function creationCompleteHandler(event:FlexEvent):void
        {
            if (_gearContainerData)
            {
                this.setContainerLayout();
                loadProGear();
            }
        }

        /**
         *  设置容器布局
         */
        private function setContainerLayout():void
        {
            var gc:Object = _gearContainerData.gearContainer;
			if(gc)
            	this.setLayout(gc.layout);
        }

        /**
         *  加载gear
         */
		private var proGears:Array;
        private function loadProGear():void
        {
            gearArray = new Array();
            proGears = _gearContainerData.gears;
            if (proGears && proGears.length)
            {
                for (var i:int = 0; i < proGears.length; i++)
                {
                    var gearObj:Object = proGears[i] as Object;
                    var url:String = proGears.url;
                    gearArray.push(gearObj);
                }
                loadPreGear();
            }
        }

        private function loadPreGear():void
        {
			var len:int = gearArray.length;
            if (!len)
            {
                EventBus.dispatchEvent(new PluginEvent(PluginEvent.PLUGINADDED, this));
                return;
            }
            if (len)
            {
                var ctl:Object = gearArray[0];
                gearLeft = ctl.left;
                gearTop = ctl.top;
                gearRight = ctl.right;
                gearBottom = ctl.bottom;				
                gearArray.splice(0, 1);
                proLoadGear(ctl.url, ctl);
            }
        }

        private function proLoadGear(gearURL:String = "", gearObj:Object = null):void
        {
            var id:String;
            var icon:String;
            var url:String;
            var gear:BaseGear;
            var label:String;
            if (gearObject)
            {
                gearLeft = gearObject.left;
                gearTop = gearObject.top;
                gearRight = gearObject.right;
                gearBottom = gearObject.bottom;
                id = gearObject.id;
                icon = gearObject.icon;
                url = gearObject.url;
                label = gearObject.label;
				hCenter = gearObject.horizontalCenter;
				vCenter = gearObject.verticalCenter;
            }
            else
            {
                id = gearObj.id;
                url = gearURL;
                icon = gearObj.icon;
                label = gearObj.label;
				hCenter = gearObj.horizontalCenter;
				vCenter = gearObj.verticalCenter;
            }

            if (gearTable.containsKey(id))
            {
                gear = gearTable.find(id) as BaseGear;
                var controlGear:IVisualElement = gear as IVisualElement;
                this.addElement(controlGear);
            }
            else
            {
                if (moduleTable.containsKey(url))
                {
                    var modInfo:IModuleInfo = moduleTable.find(url) as IModuleInfo;
                    gear = modInfo.factory.create() as BaseGear;
                    gear.setId(id);
                    gear.setTitle(label);
                    gear.setIcon(icon);
                    gear.setMap(map);
                    var controlIVE:IVisualElement = gear as IVisualElement;
                    this.addElement(controlIVE);
                }
                else
                {
                    loadGear(id, url, label, icon);
                }
            }
        }

        /**
         *  加载模块
         */
        private function loadGear(id:String, url:String, label:String, icon:String):void
        {
            info = ModuleManager.getModule(url);
            info.data = { id: id, label: label, icon: icon };
            info.addEventListener(ModuleEvent.READY, gearReadyHandler);
            info.load(ApplicationDomain.currentDomain, null, null, moduleFactory);
        }

        /**
         *  卸载模块
         */
        private function unLoadGear(id:String, url:String, label:String, icon:String):void
        {
            info = ModuleManager.getModule(url);
            info.data = { id: id, label: label, icon: icon };
            info.addEventListener(ModuleEvent.UNLOAD, gearUnLoadHandler);
            info.unload();
        }

        private function gearUnLoadHandler(event:ModuleEvent):void
        {

        }

        /**
         *  关于Gear精确定位......
         *  @private
         *
         */
        private function gearReadyHandler(event:ModuleEvent):void
        {
            var info:IModuleInfo = event.module;
            moduleTable.add(info.url, info);
            var id:String = info.data.id;
            var label:String = info.data.label;
            var icon:String = info.data.icon;
			var hCenter:int = info.data.hCenter;
            var gear:BaseGear = info.factory.create() as BaseGear;
            gear.id = id;
            gear.setId(id);
            gear.setTitle(label);
            gear.setIcon(icon);
            gear.setMap(map);
			var gearObj:Object = getObj(proGears, id);
			
//			gear.setStyleObject(styleObject);

            var controlIVE:IVisualElement = gear as IVisualElement;
            gear.setRelativePosition(gearLeft, gearRight, this.gearTop, this.gearBottom);
			if(gearObj.horizontalCenter != null)
			{
				gear.horizontalCenter = int(gearObj.horizontalCenter); 
			}
			if(gearObj.verticalCenter != null)
			{
				gear.verticalCenter = int(gearObj.verticalCenter); 
			}
            controlIVE = gear as IVisualElement;

            this.addElement(controlIVE);
            gearTable.add(id, gear);
            loadPreGear();
        }
		
		private function getObj(fromAry:Array, id:String):Object
		{
			var wgt:Object;
			var aryNum:int = fromAry.length;
			for (var i:int = 0; i<aryNum; i++)
			{
				if (fromAry[i].id==id)
				{
					wgt = fromAry[i];
					return wgt;
				}
			}
			return null;
		}
    }
}
