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
package com.supermap.framework.managers
{
    import com.supermap.containers.GearContainer;
    import com.supermap.containers.LayoutContainer;
    import com.supermap.framework.components.*;
    import com.supermap.framework.core.*;
    import com.supermap.web.sm_internal;
    
    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;
    
    import inject.utils.ReflectUtil;
    
    import mx.collections.ArrayCollection;
    import mx.core.IVisualElement;
    import mx.core.IVisualElementContainer;
    import mx.core.UIComponent;
    
    import spark.components.supportClasses.SkinnableComponent;

    use namespace sm_internal;

    /**
     *  插件简单工厂类
     *  推荐使用外部配置文件传入插件信息.一般放置在主程序里调用实现.
     *  @see com.supermap.framework.core.IFactory
     *  @private
     */
    public class PluginManager implements IFactory
    {
        /**
         *  容器组件的默认包路径(需要支持动态......)
         */
        public static const QUALIFIEDCLASSNAME:String = "com.supermap.containers";

        public static const DEFALUT_CLASS_PATH:String = "com.supermap.framework";

        private static var pluginManager:PluginManager;

        public var _plugin:IPlugin;

        public function PluginManager(plugin:IPlugin = null)
        {
            _plugin = plugin;
        }

        public static function getInstance():PluginManager
        {
            if (!pluginManager)
            {
                pluginManager = new PluginManager();
            }
            return pluginManager;
        }

        /**
         *  该方法继承自IFactory接口中的函数声明.主要用来根据传入的
         *  插件类型来生成一个插件实例,如果有容器的话会直接添加到容器
         *  当需要动态创建容器组件时候考虑使用
         *  该方法即可生成动态生成容器也可以动态生成插件
         */
        public function createPlugin(value:String = "", parent:Object = null):IPlugin
        {
            var container:IPlugin;
            if (parent)
            {
                var pluginType:String = ConfigManager.getInstance().getKey(parent.type);
                var containerType:String = parent.type;

                if (!value)
                {
                    //如果是baseComponet则返回该类的一个实例
                    var extendsClassList:XMLList = ReflectUtil.getExtendsClass(parent);
                    for each (var xml:XML in extendsClassList)
                    {
                        var classType:String = xml.@type[0];
                        var classAry:Array = classType.split("::");
                        var strClassType:String = classAry[0];
                        //找出符合条件的基类完全限定类名
                        if (!strClassType.indexOf(PluginManager.DEFALUT_CLASS_PATH)&&classAry[1]==pluginType)
                        {
                            var pluginClass:* = getDefinitionByName(classType);
                            pluginClass = new pluginClass();
                            try
                            {
                                container = pluginClass;
                            }
                            catch (e:Error)
                            {
                                //trace(e);
                            }
                            return container;
                        }
                        else
                        {
                            //处理igear与itemplate部分
                            var pluginClassName:String = getPluginClassName(pluginType);
                            var containerCls:Class = getDefinitionByName(pluginClassName+pluginType) as Class;
                            var containerInstance:* = new containerCls();
                            try
                            {
                                container = containerInstance;
                                if (container is BaseComponent)
                                    (container as SkinnableComponent).setStyle("skinClass", BaseComponentSkin);
                                if (container is GearTemplate)
                                {
                                    var module:BaseGear = new BaseGear();
                                    module.addElement(container as IVisualElement);
                                    parent.addElement(module);
                                    return container;
                                }
                                parent.addElement(container);
                            }
                            catch (e:Error)
                            {
                                //trace(e);
                            }
                            return container;
                        }
                    }
                }
                else
                {
                    //TODO:处理外部传入进来的类型......
                }
            }

            //当需要生成容器对象的时候 需要传递一个对应的字符串 反射出该容器类 因此这里被外部调用的时候 没有parent传入
            if (value&&!parent)
            {
                var containerClass:Class = getDefinitionByName(value) as Class;
                var containerClassInstance:* = new containerClass();
                try
                {
                    container = containerClassInstance;
                }
                catch (e:Error)
                {
                    //trace(e);
                }
                return container;
            }

            throw new Error("插件生成失败！");
        }

        /**
         *  创建gear插件
         */
        public function createGear():IGear
        {
            return null;
        }

        /**
         *  创建带有Template统一模板的插件
         */
        public function createTemplate():ITemplate
        {
            return null;
        }

        /**
         *  创建基础组件插件.
         *  这里也可以创建基础容器
         */
        public function createComponent():BaseComponent
        {
            return null;
        }

        /**
         *  添加插件到容器
         */
        public function addPlugin(plugin:*, containerId:String):void
        {
            var container:LayoutComponent = ComponentDelegateManager.getInstance().getComponent(containerId) as LayoutComponent;
            if (container)
            {
                container.addElement(plugin);
                return;
            }
            throw new Error("没有找到该插件！");
        }

        /**
         *  根据插件传入ID获取对应的插件实例
         *  @param id String 要查找的id(必设属性)
         *  @param containerId 要查找的id组件所在的容器id(必设属性)
         */
        public function getPluginById(id:String, containerId:String):IVisualElement
        {
            var container:LayoutComponent = ComponentDelegateManager.getInstance().getComponent(containerId) as LayoutComponent;
            if (container)
            {
				if(container.displayListElements)
                	return container.displayListElements[id];
				else
				{
					//添加遍历显示列表的功能  2112.7.4 
					container.displayListElements = new Dictionary(true);
					container.insertToDictionary(container, container.displayListElements);
					return container.displayListElements[id];
				}				
            }
            throw new Error("没有找到该插件！");
        }

        /**
         *  根据插件本身的引用（非ID标示）
         *  @param id String 要查找的id(必设属性)
         *  @param containerId 要查找的id组件所在的容器id(必设属性)
         */
        public function getPlugin(plugin:*, containerId:String):IVisualElement
        {
            var i:int = 0;
            var container:LayoutComponent = ComponentDelegateManager.getInstance().getComponent(containerId) as LayoutComponent;
            var aryElements:ArrayCollection = container._displayListArray;
            if (container&&aryElements)
            {
                for each (var plug:* in aryElements)
                {
                    if (plug==plugin)
                    {
                        return plug;
                    }
                    i++;
                }
            }
            throw new Error("没有找到该插件！");
        }

        /**
         *  根据插件传入对象来获取索引(插件的索引定义要解释一下 涉及到了显示列表)
         *  暂不开放该方法 索引的操作后期完善
         *  @param id String 要查找的id(必设属性)
         *  @param containerId 要查找的id组件所在的容器id(必设属性)
         */
        public function getPluginIndex(plugin:*, containerId:String):int
        {
            var i:int = 0;
            var container:LayoutComponent = ComponentDelegateManager.getInstance().getComponent(containerId) as LayoutComponent;
            var aryElements:ArrayCollection = container._displayListArray;
            if (container&&aryElements)
            {
                for each (var plug:* in aryElements)
                {
                    if (plug==plugin)
                    {
                        return i;
                    }
                    i++;
                }
            }
            throw new Error("没有找到该插件！");
        }

        /**
         *  根据插件传入对象来移除该插件
         *  注意：这里返回了移除对象的引用 如果要做资源的释放 需要用户根据自己的操作自己做清空或者不做 GC会自行清理
         *  @param id String 要查找的id(必设属性)
         *  @param containerId 要查找的id组件所在的容器id(必设属性)
         */
        public function removePlugin(plugin:*, containerId:String, isDestroy:Boolean = false):Object
        {
            var returPlugin:Object;
            var i:int = 0;
            var container:LayoutComponent = ComponentDelegateManager.getInstance().getComponent(containerId) as LayoutComponent;
            var aryElements:ArrayCollection = container._displayListArray;
            if (container&&container.displayListElements&&aryElements)
            {
                for each (var plug:* in aryElements)
                {
                    if (plug==plugin)
                    {
                        //先移除字典里的对象引用
                        aryElements.removeItemAt(i);
                        delete container.displayListElements[plugin.id];
                        //根据父容器来移除操作
                        var ownerContianer:* = plug;
                        var ownerUI:UIComponent = ownerContianer.owner;
                        if (ownerContianer&&ownerUI&&ownerUI.owns(plugin))
                            (ownerUI as IVisualElementContainer).removeElement(plugin);
                        returPlugin = plugin;
                        return returPlugin;
                    }
                    i++;
                }
            }

            throw new Error("没有找到该插件！");
        }

        /**
         *  根据插件传入对象ID来移除该插件
         *  @param id String 要查找的id(必设属性)
         *  @param containerId 要查找的id组件所在的容器id(必设属性)
         */
        public function removePluginById(id:String, containerId:String, isDestroy:Boolean = false):Object
        {
            var plugin:Object;
            var i:int = 0;
            var container:LayoutComponent = ComponentDelegateManager.getInstance().getComponent(containerId) as LayoutComponent;
            var aryElements:ArrayCollection = container._displayListArray;
            if (container&&container.displayListElements&&aryElements)
            {
                for each (var plug:* in aryElements)
                {
                    if (plug.id==id)
                    {
                        //先移除字典里的对象引用
                        aryElements.removeItemAt(i);
                        delete container.displayListElements[id];
                        //根据父容器来移除操作
                        var ownerContianer:* = plug as IVisualElementContainer;
                        var ownerUI:UIComponent = ownerContianer.owner;
                        if (ownerContianer&&ownerUI&&ownerUI.owns(plug))
                            (ownerUI as IVisualElementContainer).removeElement(plug);
                        plugin = plug;

                        //对象销毁
                        if (isDestroy)
                        {
                            plug.destroy();
                            plug = null;
                            plugin = null;
                        }

                        return plugin;
                    }
                    i++;
                }
            }

            throw new Error("没有找到该插件！");
        }

        /**
         *  获取插件对象的完全限定类名
         */
        public function getPluginClassName(type:String):String
        {
            var pluginClassName:String = ConfigManager.getInstance().getKey(type);
            return ConfigManager.ComponentPackagePath+"::"+pluginClassName;
        }
    }
}
