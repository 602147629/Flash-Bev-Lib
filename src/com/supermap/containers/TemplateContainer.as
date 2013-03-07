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
    import com.supermap.framework.components.GearTemplate;
    import com.supermap.framework.components.LayoutComponent;
    import com.supermap.framework.core.GearStates;
    import com.supermap.framework.core.IGear;
    import com.supermap.framework.dock.FloatPanel;
    import com.supermap.framework.events.GearEvent;
    import com.supermap.web.mapping.Map;
    import com.supermap.web.sm_internal;
    import com.supermap.web.utils.Hashtable;
    
    import flash.events.TimerEvent;
    import flash.system.ApplicationDomain;
    import flash.utils.Timer;
    
    import mx.core.IVisualElement;
    import mx.events.FlexEvent;
    import mx.events.ModuleEvent;
    import mx.modules.IModuleInfo;
    import mx.modules.ModuleManager;
    
    import spark.components.TitleWindow;

    use namespace sm_internal;


    /**
     *  基础模板容器
     *  该容器主要用来装载带有统一模板(GearTemplate)的功能模块(BaseGear).
     *
     */
    public class TemplateContainer extends LayoutComponent
    {
        /**
         *  预加载的一些Gears 数据来自于XML文件
         */
        private var gearArray:Array;

        private var gearObject:Object;

        private var gearLeft:String;

        private var gearTop:String;

        private var gearRight:String;

        private var gearBottom:String;

        private var proload:String;

        private var gearLabel:String;

        private var gearIcon:String;

        private var gearID:String;

        private var info:IModuleInfo;

        private var moduleTable:Hashtable = new Hashtable();

        private var gearTable:Hashtable = new Hashtable();


        private var ctlInfo:IModuleInfo;

        private var ctnInfo:IModuleInfo;

        private var isDraggable:Boolean = true;

        private var isResizeable:Boolean = true;

        private var _refX:Number = 0;

        private var _refY:Number = 0;

        private var _map:Map;

        [Bindable]
        private var _gearData:Object;

        /**
         *  窗体距顶部的距离
         */
        private var _topPad:Number = 0;

        private var _leftPad:Number = 0;


        public function TemplateContainer()
        {
            addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
            EventBus.addEventListener(GearEvent.GEAR_STATE_CHANGED, closeHandler);
            setStyle("borderAlpha", 0);
            setStyle("backgroundAlpha", 0);
        }

        /**
         *  获取类名
         */
        override public function get type():String
        {
            return this.className;
        }

        private var curId:String = "";

        private function closeHandler(event:GearEvent):void
        {
            var data:Object = event.data;

            if (data.state as String==GearStates.GEAR_CLOSED)
            {
                curId = data.id as String;
                var timer:Timer = new Timer(500, 1);
                timer.addEventListener(TimerEvent.TIMER_COMPLETE, removeGear);
                timer.start();
            }
        }

        private function removeGear(event:TimerEvent):void
        {
            var gear:IVisualElement;
            for (var i:int = 0; i<this.numElements; i++)
            {
                gear = this.getElementAt(i);

                var baseGear:IGear = gear as IGear;

                if (baseGear.getId()==curId)
                {
                    this.removeElement(gear);

                    if (this.numElements==0)
                    {

                    }
                    return;
                }
            }
        }

        /**
         *  @private
         */
        public function get topPad():Number
        {
            return _topPad;
        }

        /**
         *  @private
         */
        public function set topPad(value:Number):void
        {
            _topPad = value;
        }

        /**
         *  @private
         */
        public function get leftPad():Number
        {
            return _leftPad;
        }

        /**
         *  @private
         */
        public function set leftPad(value:Number):void
        {
            _leftPad = value;
        }

        /**
         *  获取加载数据项
         *
         */
        public function get gearData():Object
        {
            return _gearData;
        }

        /**
         *  设置加载数据项
         *  一般该数据通过外部xml数据解析后传入
         */
        public function set gearData(value:Object):void
        {
            _gearData = value;
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

        protected function creationCompleteHandler(event:FlexEvent):void
        {
            EventBus.addEventListener(GearEvent.GEAR_RUN, onRunGearHandler);
            this.loadProGear();
        }

        private function loadProGear():void
        {
            gearArray = [];
            if (gearData)
            {
                for (var i:int = 0; i <= gearData.length-1; i++)
                {
                    var gearObj:Object = gearData[i] as Object;
                    //设置加载时候的状态
                    if (gearObj.preload=="open" || gearObj.preload=="minimized")
                    {
                        gearArray.push(gearObj);
                    }
                }
                loadPreGear();
            }
        }

        private function loadPreGear():void
        {
            if (gearArray.length)
            {
                var ctl:Object = gearArray[0];
                gearID = ctl.id;
                gearLeft = ctl.left;
                gearTop = ctl.top;
                gearRight = ctl.right;
                gearBottom = ctl.bottom;
                proload = ctl.preload;
                gearLabel = ctl.label;
                gearIcon = ctl.icon;
                gearArray.splice(0, 1);
                EventBus.dispatchEvent(new GearEvent(GearEvent.GEAR_RUN, gearID));
            }
        }

        private function onRunGearHandler(event:GearEvent):void
        {
            var id:String = event.data as String;
            var ary:Array = this.gearData as Array;
            var wgt:Object = getObj(ary, id);
            var preload:String = wgt.preload;
            var label:String = wgt.label;
            var icon:String = wgt.icon;
            var config:String = wgt.config;
            var url:String = wgt.url;

            var wx:Number = Number(wgt.x);
            var wy:Number = Number(wgt.y);
            var wleft:String = wgt.left;
            var wtop:String = wgt.top;
            var baseGear:BaseGear;
            if (gearTable.containsKey(id))
            {
				baseGear = gearTable.find(id) as BaseGear;
				baseGear.setState(GearStates.GEAR_OPENED);
				this.addElement(baseGear);
            }
            else
            {
                if (moduleTable.containsKey(url))
                {
					baseGear = gearTable.find(id) as BaseGear;
					baseGear.setState(GearStates.GEAR_OPENED);
                }
                else
                {
                    loadGear(id);
                }
            }
        }

        private function getObj(fromAry:Array, id:String):Object
        {
            var wgt:Object;
            var aryNum:int = fromAry.length;
            for (var i:int = 0; i < aryNum; i++)
            {
                if (fromAry[i].id == id)
                {
                    wgt = fromAry[i];
                    return wgt;
                }
            }
            return null;
        }

        private function loadGear(id:String = ""):void
        {
            var ary:Array = this.gearData as Array;
            var gear:Object = getObj(ary, id);
            var preload:String = gear.preload;
            var url:String = gear.url;

            ctlInfo = ModuleManager.getModule(url);
            ctlInfo.data = { id: id, preload: preload };
            ctlInfo.addEventListener(ModuleEvent.READY, gearReadyHandler);
            ctlInfo.addEventListener(ModuleEvent.ERROR, moduleErrorHandler);
            ctlInfo.load(ApplicationDomain.currentDomain, null, null, moduleFactory);
            //this.cursorManager.setBusyCursor();
        }

        private function moduleErrorHandler(event:ModuleEvent):void
        {

        }

        private function gearReadyHandler(event:ModuleEvent):void
        {
            //this.cursorManager.removeBusyCursor();
            var info:IModuleInfo = event.module;
            moduleTable.add(info.url, info);

            var id:String = info.data.id;
            var ary:Array = this.gearData as Array;
            var gearObj:Object = getObj(ary, id);
            var preload:String = info.data.preload;

            var label:String = gearObj.label;
            var icon:String = gearObj.icon;
            var config:String = gearObj.config;
            var gearX:String = gearObj.x;
            var gearY:String = gearObj.y;
            var gx:Number = Number(gearObj.x);
            var gy:Number = Number(gearObj.y);
            var gleft:String = gearObj.left;
            var gtop:String = gearObj.top;
            var gright:String = gearObj.right;
            var gbottom:String = gearObj.bottom;

            var gear:BaseGear = info.factory.create() as BaseGear;
            gear.id = id;
            gear.setId(id);
            gear.setTitle(label);
            gear.setIcon(icon);
            gear.setMap(map);
            gear.isDraggable = this.isDraggable;
            gear.isResizeable = this.isResizeable;
            gear.setPreload(preload);

			//当容器在浮动面板里的时候 自适应面板本身 而不是舞台 2012.5.5
			if(this.owner is TitleWindow)
			{
				EventBus.addEventListener(GearEvent.GEAR_TEMPLATE_RESIZE, getPanelSizeHandler);
			}			
			
            if (gear is BaseGear)
            {
                var bevGear:BaseGear = gear as BaseGear;
                bevGear.topPad = _topPad;
                bevGear.leftPad = _leftPad;
            }

            if (gleft||gtop||gright||gbottom)
            {
                gear.setRelativePosition(gleft, gright, gtop, gbottom);
            }
            else if (gx && gy)
            {
                gear.setXYPosition(gx, gy);
            }
            else
            {
                setAutoXY();
                gx = _refX;
                gy = _refY
                gear.setXYPosition(gx, gy);
            }
            gearTable.add(id, gear);
            this.addElement(gear);
			//TODO:初始化的时候 允许通过外部配置初始化状态......
            gear.setState(GearStates.GEAR_OPENED);
            loadPreGear();
        }

		private function getPanelSizeHandler(event:GearEvent):void
		{
			for(var i:int = 0; i < this.numElements; i++)
			{
				var baseGear:BaseGear = this.getElementAt(i) as BaseGear;
				if(baseGear)
				{
					baseGear.parentSize = 
						{
							width: event.data.width,
							height:event.data.height
						}
				}
			}
		}
		
        private function setAutoXY():void
        {
            var gear:Number = 300;

            var siftUnit:Number = 20;

            if (_refX==0)
            {
                _refX = siftUnit;
            }
            else
            {
                _refX = _refX+gear+20;
            }

            if (_refY==0)
            {
                _refY = Math.round(gear/2);
            }

            if (((_refX+gear)>this.width))
            {
                _refX = siftUnit
                _refY = _refY+Math.round(gear+siftUnit)/2;
            }
            else if ((_refY+gear)>this.height)
            {
                _refX = siftUnit;
                _refY = Math.round(gear/2);
            }
        }
    }
}
