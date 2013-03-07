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
	/**
	 *  @private 内部工具类 暂不开放
	 */
	public class DockUtil
	{
		public var plugins:Array;
		public var panels:Array;
		
		private static var _dockUtil:DockUtil;
		
		public function DockUtil()
		{
		}
		
		public static function getInstance():DockUtil
		{
			return _dockUtil ||= new DockUtil();
		}
		
		/**
		 *  带有标签页面板的id遍历
		 */
		public function getDockDataByID(navigatorContentID:String):Object
		{
			var obj:Object;
			if(plugins)
			{
				var len:int = plugins.length;
				for(var i:int = 0; i < len; i++)
				{
					var pObj:Object = plugins[i];
					if(navigatorContentID == pObj.pluginID)
					{
						obj = pObj;
						return obj;
					}
				}
			}
			return null;
		}
		
		/**
		 *  没有标签页面板的id遍历
		 */
		public function getDockDataByPanelID(panelID:String):Object
		{
			var obj:Object;
			if(panels)
			{
				var num:int = panels.length;
				for(var j:int = 0; j < num; j++)
				{
					var psObj:Object = panels[j];
					if(panelID == psObj.pluginID)
					{
						obj = psObj;
						return obj;
					}
				}
			}
			return null;
		}
	}
}