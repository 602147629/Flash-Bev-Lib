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
	import com.supermap.framework.skins.scrollBarSkins.Scroller_skin;
	
	import mx.collections.ArrayCollection;
	import mx.events.FlexEvent;
	
	import spark.components.Group;
	import spark.components.Scroller;
	import spark.components.SkinnableContainer;
	import spark.layouts.HorizontalAlign;
	import spark.layouts.VerticalLayout;
	
	/**
	 *  停靠条容器类.
	 *  该类是停靠条的容器类.
	 */
	public class DockBarMananger extends SkinnableContainer
	{
		private var _dataProvider:ArrayCollection;
		private var dataProviderChange:Boolean = false;
		private static var instance:DockBarMananger;
		
		public function DockBarMananger()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, createHandler);
		}
		
		/**
		 *  获取停靠条容器类的单一实例.
		 */
		public static function getInstance():DockBarMananger
		{
			return instance ||= new DockBarMananger();
		}
		
		private var group:Group;
		private function createHandler(event:FlexEvent):void
		{
			
		}
		
		/**
		 *  @override
		 *  添加滚动条等子组件
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			var scroller:Scroller = new Scroller();
			scroller.setStyle("skinClass", com.supermap.framework.skins.scrollBarSkins.Scroller_skin);
			this.addElement(scroller);
			scroller.height = 300;
			
			group = new Group();
			var layout:VerticalLayout = new VerticalLayout();
			layout.horizontalAlign = HorizontalAlign.RIGHT;
			group.layout = layout;
			scroller.viewport = group;
		}
		
		/**
		 *  @private
		 */
		public function get dataProvider():ArrayCollection
		{
			return _dataProvider;
		}
		
		/**
		 *  @private
		 */
		public function set dataProvider(value:ArrayCollection):void
		{
			if(value && value.length && _dataProvider != value)
			{
				_dataProvider = value;
				dataProviderChange = true;
				invalidateProperties();
			}
		}
		
		/**
		 *  @private
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(dataProviderChange)
			{
				dataProviderChange = false;
				addDockData();
			}	
		}
		
		private function addDockData():void
		{
			for(var i:int = 0; i < dataProvider.length; i++)
			{
				var dockbar:DockBar = dataProvider.getItemAt(i) as DockBar;
				group.addElement(dockbar);
			}
		}
		
		/**
		 *  添加一个停靠条到该容器.
		 *  @param DockBar 停靠条类. 
		 *  @see com.supermap.framework.dock.supportClasses.DockBar
		 */
		public function addData(dockBar:DockBar):void
		{
			group.addElement(dockBar);
		}
		
		/**
		 *  从该容器移除一个停靠条.
		 *  @param DockBar 停靠条类. 
		 *  @see com.supermap.framework.dock.supportClasses.DockBar
		 */
		public function removeData(dockBar:DockBar):void
		{
			group.removeElement(dockBar);
		}
	}
}