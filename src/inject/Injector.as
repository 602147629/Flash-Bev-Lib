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
package inject
{
	import com.supermap.framework.components.ComponentDelegateManager;
	import com.supermap.framework.core.IPlugin;
	
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;

	/**
	 *  @private
	 */
	public class Injector extends Object
	{
		public static var _instance:Injector;
		
		public static var defaultType:String = "*";
		public static var defaultInject:String = "Inject";
		
		public var xml:XML;
		public var methods:Array;
		public var propertys:Array;
		public var propertysAccess:Object;
		public var propertysType:Object;
		public var metaDatas:Object;
		
		public var injects:Object; 
		private var dictionary:Dictionary;
		
		private static var describeTypeCache:Dictionary = new Dictionary(true);
		
		/**
		 *        注入器 
		 *  @author zengming
		 *  @time   2012.3.29
		 *  @private
		 */
		public function Injector()
		{
			
		}
		
		public static function getInstance() : Injector
		{
			if(!_instance)
				return new Injector();
			return _instance;				
		}
		
		//给基础组件注入
		//对事件类的注入一定要有type传入 否则报错
		public function injectToPlugin(plugin:* = null) : void
		{
			var injects:Object = reflectUtil(plugin);
			var injectType:Class;
			var newType:*;
			
			for(var key:* in injects)//输出键
			{
				if(String(key).indexOf("&") != -1)
				{
					var attribute:String = (String(key).split("&") as Array)[0];
					var eventTp:String = (String(key).split("&") as Array)[1];
					if(plugin.hasOwnProperty(attribute))
					{						
						if(injects[key])
						{
							injectType = injects[key] as Class;						
							newType = new injectType(eventTp);
							plugin[attribute] = newType;
						}
					}
				}
				else
				{
					if(plugin.hasOwnProperty(key))
					{
						injectType = injects[key] as Class;						
						newType = new injectType();
						plugin[key] = newType;
					}
				}
				
			}
//			for each(var value:* in injects)
//			{
//				trace(value);
//			}
		}
		
		//给事件命令注入
		public function injectToCommand(command:Class = null) : *
		{
			var commandToExecute : * = new command();//command实例化
			var injects:Object = reflectUtil(commandToExecute);
			for(var key:* in injects)
			{
				if(commandToExecute.hasOwnProperty(key))//判断是否含有注入属性
				{
					var injectType:Class = injects[key] as Class;
					var newType:*;
					var component:* = ComponentDelegateManager.getInstance().getComponent(key);
					
					if(component)
						newType = component;
					else
						newType = new injectType();
					
					commandToExecute[key] = newType;					
				}
			}
			return commandToExecute;
		}
		
		public function getMetaData(plugin:*) : Object
		{
			var metaData:Object;
			
			var xml:XML = describeType(plugin);
			var metaDataList:XMLList = xml.metadata;
			var length:int = metaDataList.length();
			for(var i:int = 0; i < length; i++)
			{
				var child:XML = metaDataList[i] as XML;
				var name:String = child.@name[0];
				if(name == "Event" || name == defaultInject)//按照key-value的方式存取数据
				{					
					var eventType:String = child.arg[0].@value[0];
					var eventInstance:String = child.arg[1].@value[0];
					metaData = 
						{
							eventType:eventInstance
						}
				}				
			}
			return metaData;
		}
		
		public function reflectUtil(obj:*) : Object
		{
			obj = getClass(obj);
			describeTypeCache[obj] = this;
			
			//类定义
			this.xml = describeType(obj);
			this.metaDatas = {};
			
			var meta:Object;
			meta = parseMetaData(xml.factory[0].metadata);
			if (meta)
				this.metaDatas["this"] = meta;
			
			//方法列表
			this.methods = [];
			
			for each(var child:XML in xml..method)
			{
				var name:String = child.@name.toString();
				methods.push(name);
			}
			
			//属性列表
			this.propertys = [];
			this.propertysAccess = {};
			this.propertysType = {};
			
			injects = {};
			
			for each(child in xml..accessor)
			{
				name = child.@name.toString();
				//trace(name);
				propertys.push(name);
				propertysAccess[name] = child.@access.toString();
				var typeStr:String = child.@type;
				if(typeStr == defaultType)
					propertysType[name] = defaultType;
				else
					propertysType[name] = getDefinitionByName(child.@type);
				
				meta = parseMetaData(child.metadata);
				if (meta)
					metaDatas[name] = meta;
			}
			
			for each(child in xml..variable)
			{
				name = child.@name.toString();
				
				propertys.push(name);
				propertysType[name] = getDefinitionByName(child.@type);
				if(child.metadata[0].@name == defaultInject)//这里需要判断inject标签是都使用了type
				{
					var eventType:String;
					if(child.metadata[0].arg[0])
						eventType = child.metadata[0].arg[0].@value[0];
					if(eventType)
					{
						injects[name + "&" + eventType] = propertysType[name];
					}
					else
						injects[name] = propertysType[name];
				}				
				
				meta = parseMetaData(child.metadata);
				if (meta)
					metaDatas[name] = meta;
			}
			
			return injects;
		}
		
		private function parseMetaData(xmlList:XMLList) : Object
		{
			var result:Object;
			for each (var m:XML in xmlList)
			{
				if (!result)
					result = {};
				
				var o:Object = {}; 
				for each (var child:XML in m.*)
				{
					o[child.@key.toString()] = child.@value.toString();
				}
				result[m.@name.toString()] = o;
			}
			return result;
		}		

		public static function getClass(obj:*) : Class
		{	
			if (obj == null)
				return null;
			else if (obj is String)
				return getDefinitionByName(obj) as Class
			else if (obj is Class)
				return obj;
			else	
				return obj["constructor"] as Class;
		}
		
	}
}