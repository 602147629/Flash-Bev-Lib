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
package com.supermap.framework
{
	import flash.net.LocalConnection;
	import flash.net.SharedObject;
	import flash.system.System;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	/**
	 *  垃圾回收
	 *  @private
	 */
	public class GCPlus
	{
		public static function clear(isTraceTM : Boolean = false) : void 
		{
			var time : int = 2;
			var interval : int = setInterval(loop, 50);
			function loop() : void 
			{
				if(!(time--)) 
				{
					isTraceTM && trace(System.totalMemory);
					clearInterval(interval);
					//return;
				}
				SharedObject.getLocal("FLEXBEV", "/");//处理当使用共享对象时候的内存处理 这里会异常				
			}
			
			//强制回收
			try{
				new LocalConnection().connect("foo");
				new LocalConnection().connect("foo");
			}
			catch(e:Error)
			{
				//trace(System.totalMemory);				
			}
		}
	}
}