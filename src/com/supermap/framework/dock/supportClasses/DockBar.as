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
package com.supermap.framework.dock.supportClasses
{
	import com.supermap.framework.events.FloatPanelEvent;
	
	import flash.events.MouseEvent;
	
	import mx.controls.Image;
	import mx.events.FlexEvent;
	
	import spark.components.Button;
	import spark.components.SkinnableContainer;

	[SkinState("unFold")]
	[SkinState("fold")]
	
	/**
	 *  停靠条类.
	 *  该类的一个实例对应这一个面板的状态.即当一个面板设置停靠后,便会生成该类的一个实例来对应面板的状态.
	 */
	public class DockBar extends SkinnableContainer
	{
		/**
		 *  左侧的按钮
		 */
		[SkinPart]
		public var dockBtn:Button;
		
		/**
		 *  右侧的容器.放置图标区域.
		 */
		[SkinPart]
		public var dockContainer:CustomContainer;
		
		private var _dockBarState:String = DockBar.FOLD;
		
		/**
		 *  停靠条展开状态.
		 */
		public static const UNFOLD:String = "unFold";//展开
		/**
		 *  停靠条折叠状态.
		 */
		public static const FOLD:String = "fold";//折叠
		
		/**
		 *  默认停靠条展开宽度.
		 */
		[Bindable]
		public var unfoldWidth:int = 100;
		
		private var _dataProvider:Array;
		private var dataProviderChange:Boolean = false;
		
		private var dockData:Array;
		
		public function DockBar()
		{
			super();
			addEventListener(FloatPanelEvent.FLOATPANEL_DOCKDATA, getDockDataHandler);
			addEventListener(MouseEvent.ROLL_OVER, openDockBarHandler);
			addEventListener(MouseEvent.ROLL_OUT, closeDockBarHandler);
		}
		
		private function getDockDataHandler(event:FloatPanelEvent):void
		{
			dockData = event.data as Array;
		}
		
		/**
		 *  @private
		 */
		public function get dataProvider():Array
		{
			return _dataProvider;
		}

		/**
		 *  @private
		 */
		public function set dataProvider(value:Array):void
		{
			if(value && value.length && _dataProvider != value)
			{
				_dataProvider = value;
				dataProviderChange = true;
				invalidateProperties();
			}
		}

		/**
		 *  获取停靠条当前状态.
		 */
		public function get dockBarState():String
		{
			return _dockBarState;
		}

		/**
		 *  设置停靠条当前状态.
		 */
		public function set dockBarState(value:String):void
		{
			if(value && value != _dockBarState){
				_dockBarState = value;
				invalidateSkinState();
			}
		}
		
		private function openDockBarHandler(event:MouseEvent):void
		{
				if(dockBarState == DockBar.FOLD)
				{
					dockBarState = DockBar.UNFOLD;
					
					if(dockData)
					{
						for(var i:int = 0; i < dockData.length; i++)
						{
							var obj:Object = dockData[i];
							var img:Image = new Image();
							img.addEventListener(MouseEvent.CLICK, openPanelHandler);
							img.addEventListener(MouseEvent.MOUSE_OVER, showToolTipHandler);
							img.width = img.height = 40;
							img.source = String(obj.image);
							dockContainer.addElement(img);
						}
					}
					
					var len:int = dockData.length;
					unfoldWidth = len * 40 + len * 5; 
				}
		}
		
		private function openPanelHandler(event:MouseEvent):void
		{
			var img:Image = event.currentTarget as Image;
			var len:int = dockData.length;
			var index:int;
			var obj:Object;
			for(var i:int = 0; i < len; i++)
			{
				var dockD:Object = dockData[i];
				if(dockD.image == img.source)
				{
					index = i;
					obj = {
						index:index,
						panelID:dockD.id
					}
					//todo:传递索引......
					dispatchEvent(new FloatPanelEvent(FloatPanelEvent.FLOATPANEL_DOCKOPEM, obj));
				}
			}
		}
		
		private var tooltip:ToolTip;
		private function showToolTipHandler(event:MouseEvent):void
		{
			var image:Image = event.currentTarget as Image;
			//获取当前的提示框单例
			tooltip = ToolTip.getInstance();
			//获取当前的提示框内容信息
			var title:String;
			var len:int = dockData.length;
			for(var i:int = 0; i < len; i++)
			{
				var dockD:Object = dockData[i];
				if(image.source == dockD.image)
					title = dockD.tooltip;
			}
			tooltip.show(image, title);
		}
		
		private function closeDockBarHandler(event:MouseEvent):void
		{
			if(!(event.target is Button))
			{
				if(dockBarState == DockBar.UNFOLD)
				{
					//dataProvider = null;
					unfoldWidth = 5;
					dockBarState = DockBar.FOLD;
				}
			}
				
		}
		
		/**
		 *  @override
		 *  获取当前皮肤状态
		 */
		override protected function getCurrentSkinState():String
		{
			return _dockBarState;
		}

		private function createHandler(event:FlexEvent):void
		{
			if(dockBarState == DockBar.FOLD)
			{
				dockContainer.width = 0;
			}
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
		}
		
		/**
		 *  TODO
		 *  @private
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(dataProviderChange)
			{
				dataProviderChange = false;
				//addDockData();
			}				
		}
		
		/**
		 *  添加DockData的数据集合
		 *  @private
		 */
		public function addDockData():void
		{
			if(dockData)
			{
				for(var i:int = 0; i < dockData.length; i++)
				{
					var obj:Object = dockData[i];
					var img:Image = new Image();
					img.width = img.height = 40;
					img.source = String(obj.image);
					dockContainer.addElement(img);
				}
			}
		}
		
		/**
		 *  移除DockData的数据集合
		 */
		public function removeDockData():void
		{
			//dockContainer.removeAllElements();
		}
	}
}