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
package com.supermap.framework.dock
{
	import com.supermap.framework.components.BaseComponent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import mx.controls.Image;
	import mx.events.FlexEvent;
	import spark.components.Group;

	/**
	 * 停靠条组件
	 * @author gis
	 */
	public class DockBarComponent extends BaseComponent
	{

		/**
		 *
		 * @default
		 */
		public static var _instance:DockBarComponent;

		/**
		 *
		 * @return
		 */
		public static function getInstance():DockBarComponent
		{
			return _instance ||= new DockBarComponent();
		}

		/**
		 *
		 */
		public function DockBarComponent()
		{
			super();
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
		}

		[SkinPart(required = "false")]
		/**
		 *
		 * @default
		 */
		public var dockBar:Group;

		private var _mouseOverImageCenter:Point;

		private var toolTipContainer:ToolTipContainer;

		/**
		 *
		 * @param img
		 * @return
		 */
		public function getImageCenter(img:Image):Point
		{
			//6是距左侧的距离 (偏移量) 10是img高度 的一半
			_mouseOverImageCenter = img.contentToGlobal(new Point(img.x-6, img.y+img.height/2));
			return _mouseOverImageCenter;
		}

		/**
		 *  鼠标移动到某个image对象的时候 这样就简化了datagroup的多层判断读取
		 */
		public function get mouseOverImageCenter():Point
		{
			return _mouseOverImageCenter;
		}

		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance==dockBar)
			{
				dockBar.addEventListener(MouseEvent.MOUSE_OVER, showToolTipHandler);
			}
		}

		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			if(instance==dockBar)
			{
				dockBar.removeEventListener(MouseEvent.MOUSE_OVER, showToolTipHandler);
			}
		}

		private function createCompleteHandler(event:FlexEvent):void
		{
			//toolTipContainer.height;
		}

		/**
		 *  鼠标离开 后 透明度设置为0.3
		 */
		private function mouseOutHandler(event:MouseEvent):void
		{
			this.alpha = 0.3;
		}

		/**
		 *  鼠标移动上去 透明度为1
		 */
		private function mouseOverHandler(event:MouseEvent):void
		{
			this.alpha = 1;
		}

		private function showToolTipHandler(event:MouseEvent):void
		{

		}
	}
}
