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
package com.supermap.framework.events
{
	/**
	 *  处理与面板配置组件之间的事件类型
	 */
	public class FloatPanelEvent extends BaseEvent
	{
		/**
		 *  当关闭时候派发
		 */
		public static var FLOATPANEL_REMOVE:String = "floatPanel_remove";
		/**
		 *  当创建一个新的面板时候派发(由drag引起的创建)
		 *  FloatPanel构造函数里派发
		 */
		public static var FLOATPANEL_CREATE:String = "floatPanel_create";
		
		/**
		 *  tab标签页数据发生变化时候派发(数目发生变法,仅有当前索引位置变化不派发该事件类型)
		 */
		public static var FLOATPANEL_CHANGE:String = "floatPanel_change";
		
		public static var FLOATPANEL_DOCKDATA:String = "floatPanel_dockdata";
		
		public static var FLOATPANEL_DOCKOPEM:String = "floatPanel_dock_Open";
		
		public function FloatPanelEvent(type:String="", data:Object=null)
		{
			super(type, data);
		}
	}
}