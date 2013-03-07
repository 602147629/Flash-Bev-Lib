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
package com.supermap.framework.components
{
    import com.supermap.framework.core.BaseLayout;
    import com.supermap.framework.core.IPlugin;
    import com.supermap.framework.events.LayoutEvent;
    import com.supermap.framework.managers.LayoutManager;
    import com.supermap.web.sm_internal;
    
    import flash.display.Sprite;
    import flash.events.ContextMenuEvent;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import flash.net.FileReference;
    import flash.ui.ContextMenu;
    import flash.ui.ContextMenuItem;
    import flash.utils.Dictionary;
    import flash.utils.getQualifiedClassName;
    
    import mx.collections.ArrayCollection;
    import mx.core.ContainerCreationPolicy;
    import mx.core.IDeferredContentOwner;
    import mx.core.IDeferredInstance;
    import mx.core.IFlexModuleFactory;
    import mx.core.IVisualElement;
    import mx.core.IVisualElementContainer;
    import mx.core.UIComponent;
    import mx.core.mx_internal;
    import mx.events.FlexEvent;
    import mx.managers.DragManager;
    import mx.utils.BitFlagUtil;
    
    import spark.components.Group;
    import spark.events.ElementExistenceEvent;
    import spark.layouts.supportClasses.LayoutBase;
    import spark.primitives.Rect;

    use namespace mx_internal;
    use namespace sm_internal;

    [Event(name = "contentCreationComplete", type = "mx.events.FlexEvent")]
    [Event(name = "elementAdd", type = "spark.events.ElementExistenceEvent")]
    [Event(name = "elementRemove", type = "spark.events.ElementExistenceEvent")]
    [Event(name = "layoutChanged", type = "com.supermap.framework.events.LayoutEvent")]
    [Event(name = "layoutComplete", type = "com.supermap.framework.events.LayoutEvent")]
    [Style(name = "accentColor", type = "uint", format = "Color", inherit = "yes", theme = "spark")]
    [Style(name = "alternatingItemColors", type = "Array", arrayType = "uint", format = "Color", inherit = "yes", theme = "spark")]
    [Style(name = "backgroundAlpha", type = "Number", inherit = "no", theme = "spark")]
    [Style(name = "backgroundColor", type = "uint", format = "Color", inherit = "no", theme = "spark")]
    [Style(name = "contentBackgroundAlpha", type = "Number", inherit = "yes", theme = "spark")]
    [Style(name = "contentBackgroundColor", type = "uint", format = "Color", inherit = "yes", theme = "spark")]
    [Style(name = "focusColor", type = "uint", format = "Color", inherit = "yes", theme = "spark")]
    [Style(name = "rollOverColor", type = "uint", format = "Color", inherit = "yes", theme = "spark")]
    [Style(name = "symbolColor", type = "uint", format = "Color", inherit = "yes", theme = "spark")]
    [Style(name = "alignmentBaseline", type = "String", enumeration = "useDominantBaseline,roman,ascent,descent,ideographicTop,ideographicCenter,ideographicBottom", inherit = "yes")]
    [Style(name = "baselineShift", type = "Object", inherit = "yes")]
    [Style(name = "cffHinting", type = "String", enumeration = "horizontalStem,none", inherit = "yes")]
    [Style(name = "color", type = "uint", format = "Color", inherit = "yes")]
    [Style(name = "digitCase", type = "String", enumeration = "default,lining,oldStyle", inherit = "yes")]
    [Style(name = "digitWidth", type = "String", enumeration = "default,proportional,tabular", inherit = "yes")]
    [Style(name = "direction", type = "String", enumeration = "ltr,rtl", inherit = "yes")]
    [Style(name = "dominantBaseline", type = "String", enumeration = "auto,roman,ascent,descent,ideographicTop,ideographicCenter,ideographicBottom", inherit = "yes")]
    [Style(name = "fontFamily", type = "String", inherit = "yes")]
    [Style(name = "fontLookup", type = "String", enumeration = "auto,device,embeddedCFF", inherit = "yes")]
    [Style(name = "fontSize", type = "Number", format = "Length", inherit = "yes", minValue = "1.0", maxValue = "720.0")]
    [Style(name = "fontStyle", type = "String", enumeration = "normal,italic", inherit = "yes")]
    [Style(name = "fontWeight", type = "String", enumeration = "normal,bold", inherit = "yes")]
    [Style(name = "justificationRule", type = "String", enumeration = "auto,space,eastAsian", inherit = "yes")]
    [Style(name = "justificationStyle", type = "String", enumeration = "auto,prioritizeLeastAdjustment,pushInKinsoku,pushOutOnly", inherit = "yes")]
    [Style(name = "kerning", type = "String", enumeration = "auto,on,off", inherit = "yes")]
    [Style(name = "ligatureLevel", type = "String", enumeration = "common,minimum,uncommon,exotic", inherit = "yes")]
    [Style(name = "lineHeight", type = "Object", inherit = "yes")]
    [Style(name = "lineThrough", type = "Boolean", inherit = "yes")]
    [Style(name = "locale", type = "String", inherit = "yes")]
    [Style(name = "renderingMode", type = "String", enumeration = "cff,normal", inherit = "yes")]
    [Style(name = "textAlign", type = "String", enumeration = "start,end,left,right,center,justify", inherit = "yes")]
    [Style(name = "textAlignLast", type = "String", enumeration = "start,end,left,right,center,justify", inherit = "yes")]
    [Style(name = "textAlpha", type = "Number", inherit = "yes", minValue = "0.0", maxValue = "1.0")]
    [Style(name = "textDecoration", type = "String", enumeration = "none,underline", inherit = "yes")]
    [Style(name = "textJustify", type = "String", enumeration = "interWord,distribute", inherit = "yes")]
    [Style(name = "trackingLeft", type = "Object", inherit = "yes")]
    [Style(name = "trackingRight", type = "Object", inherit = "yes")]
    [Style(name = "typographicCase", type = "String", enumeration = "default,capsToSmallCaps,uppercase,lowercase,lowercaseToSmallCaps", inherit = "yes")]
    [Style(name = "blockProgression", type = "String", enumeration = "tb,rl", inherit = "yes")]
    [Style(name = "breakOpportunity", type = "String", enumeration = "auto,all,any,none", inherit = "yes")]
    [Style(name = "firstBaselineOffset", type = "Object", inherit = "yes")]
    [Style(name = "leadingModel", type = "String", enumeration = "auto,romanUp,ideographicTopUp,ideographicCenterUp,ideographicTopDown,ideographicCenterDown,ascentDescentUp", inherit = "yes")]
    [Style(name = "paragraphEndIndent", type = "Number", format = "length", inherit = "yes", minValue = "0.0")]
    [Style(name = "paragraphSpaceAfter", type = "Number", format = "length", inherit = "yes", minValue = "0.0")]
    [Style(name = "paragraphSpaceBefore", type = "Number", format = "length", inherit = "yes", minValue = "0.0")]
    [Style(name = "paragraphStartIndent", type = "Number", format = "length", inherit = "yes")]
    [Style(name = "tabStops", type = "String", inherit = "yes")]
    [Style(name = "textIndent", type = "Number", format = "Length", inherit = "yes", minValue = "0.0")]
    [Style(name = "textRotation", type = "String", enumeration = "auto,rotate0,rotate90,rotate180,rotate270", inherit = "yes")]
    [Style(name = "whiteSpaceCollapse", type = "String", enumeration = "collapse,preserve", inherit = "yes")]
    [Style(name = "focusedTextSelectionColor", type = "uint", format = "Color", inherit = "yes")]
    [Style(name = "inactiveTextSelectionColor", type = "uint", format = "Color", inherit = "yes")]
    [Style(name = "unfocusedTextSelectionColor", type = "uint", format = "Color", inherit = "yes")]
    [DefaultProperty("mxmlContentFactory")]
    /**
     *  布局基础组件.
     *  该组件主要基于BaseComponent基础组件增加了布局管理的功能,布局这方面使用LayoutManager进行管理.
     *  默认使用内置的布局管理器.
     *  @see com.supermap.framework.core.ILayout
     */
    public class LayoutComponent extends BaseComponent implements IDeferredContentOwner, IVisualElementContainer
    {

        private static const AUTO_LAYOUT_PROPERTY_FLAG:uint = 1<<0;

        private static const LAYOUT_PROPERTY_FLAG:uint = 1<<1;

        /**
         *  构造函数
         */
        public function LayoutComponent()
        {
            super();

            setStyle("skinClass", com.supermap.framework.components.SkinnableContainerSkin);

            addEventListener(Event.ADDED_TO_STAGE, stageHandler);
            addEventListener(FlexEvent.CREATION_COMPLETE, createCompleteHandler);
			addEventListener(ElementExistenceEvent.ELEMENT_ADD, elementAddHandler);

            if (this.type=="LayoutContainer")
            {
                addEventListener(MouseEvent.MOUSE_DOWN, layoutMouseDownHandler, true);

                //TODO:设置右键保存菜单
                setContextMenu();
                if (hasEventListener("rightClick")) //当前版本支持fp11.2时候 可右键定制菜单
                {
                    addEventListener("rightClick", setRightClickHandler);
                }
            }
			
			_displayListArray = new ArrayCollection();
			displayListElements = new Dictionary(true);

        }

        /**
         *  默认皮肤
         */
        [SkinPart(required = "false")]
        /**
         *
         * @default
         */
        public var background:Rect;

        [SkinPart(required = "false")]
        /**
         *
         * @default
         */
        public var contentGroup:Group;

        sm_internal var _displayListArray:ArrayCollection; //保存子项

        sm_internal var _displayListElements:Dictionary; //字典类

        //-----------------------------------------------------------------
        //	布局管理（通过layoutMananger来具体管理布局信息）
        //-----------------------------------------------------------------
        private var _baseLayout:String = BaseLayout.ABSOLUTE;

        /**
         *  获取布局管理方式,调用布局管理器里相应的方法.
         */
//		public function getLayout():String
//		{
//			return layoutManager.getLayout();
//		}

        private var _borderColor:uint;

        private var _contentModified:Boolean = false;

        private var _deferredContentCreated:Boolean;

        //-----------------------------------------------------------------
        //	拖拽管理（在该容器里暂时不做处理）
        //-----------------------------------------------------------------
        /**
         *  是否可拖拽
         *  @private
         */
        private var _draggable:Boolean = true;

        private var _mxmlContent:Array;

        private var _mxmlContentFactory:IDeferredInstance;

        private var _placeHolderGroup:Group;

        private var borderColorChanged:Boolean = false;

        private var contentGroupProperties:Object = {};

        private var creationPolicyNone:Boolean = false;

        /**
         *  遍历显示列表默认级别(如果该值过大将会影响程序的性能)
         */
        private var displayListLevel:int = 3;

        private var isDragging:Boolean = false;

        private var isElementMove:Boolean = false;

        private var layoutChanged:Boolean = false;


        //-----------------------------------------------------------------
        //	右键保存方案（11.2FP及其以后版本会正式开放右键功能 ）
        //-----------------------------------------------------------------
        private var layoutMsg:String;

        private var mxmlContentCreated:Boolean = false;

        //递归
        private var t:int = 0;

        /**
         *
         * @param element
         * @return
         */
        public function addElement(element:IVisualElement):IVisualElement
        {
            _contentModified = true;
            return currentContentGroup.addElement(element);
        }

        /**
         *
         * @param element
         * @param index
         * @return
         */
        public function addElementAt(element:IVisualElement, index:int):IVisualElement
        {
            _contentModified = true;
            return currentContentGroup.addElementAt(element, index);
        }

        /**
         *  添加插件
         *  主要用在对移除舞台但是仍然可以取到对象引用的插件
         *
         */
        public function addPlugin(plugin:*):void
        {
            return pluginManager.addPlugin(plugin, this.id);
        }

        [Inspectable(defaultValue = "true")]
        /**
         *
         * @return
         */
        public function get autoLayout():Boolean
        {
            if (contentGroup)
                return contentGroup.autoLayout;
            else
            {
                // want the default to be true
                var v:* = contentGroupProperties.autoLayout;
                return (v===undefined)?true:v;
            }
        }

        /**
         *  @private
         */
        public function set autoLayout(value:Boolean):void
        {
            if (contentGroup)
            {
                contentGroup.autoLayout = value;
                contentGroupProperties = BitFlagUtil.update(contentGroupProperties as uint, AUTO_LAYOUT_PROPERTY_FLAG, true);
            }
            else
                contentGroupProperties.autoLayout = value;
        }

        [Bindable]
        override public function get borderColor():uint
        {
            return _borderColor;
        }

        /**
         *  设置默认边框颜色样式
         */
        public function set borderColor(value:uint):void
        {
            if (_borderColor!=value)
            {
                _borderColor = value;
                borderColorChanged = true;
                invalidateProperties();
            }
        }

        /**
         *
         */
        public function createDeferredContent():void
        {
            if (!mxmlContentCreated)
            {
                mxmlContentCreated = true;

                if (_mxmlContentFactory)
                {
                    var deferredContent:Object = _mxmlContentFactory.getInstance(); //这里得到的是内部子项的实例
                    mxmlContent = deferredContent as Array;
                    _deferredContentCreated = true;
                    dispatchEvent(new FlexEvent(FlexEvent.CONTENT_CREATION_COMPLETE));
                }
            }
        }

        /**
         *  根据容器动态生成插件
         */
        public function createPlugin(value:String = ""):IPlugin
        {
            return pluginManager.createPlugin(value, this);
        }

        [Inspectable(enumeration = "auto,all,none", defaultValue = "auto")]

        /**
         *
         * @return
         */
        public function get creationPolicy():String
        {
            //Do not set it from CSS.
            var result:String = getStyle("_creationPolicy");

            if (result==null)
                result = ContainerCreationPolicy.AUTO;

            if (creationPolicyNone)
                result = ContainerCreationPolicy.NONE;

            return result;
        }

        /**
         *
         * @param value
         */
        public function set creationPolicy(value:String):void
        {
            if (value==ContainerCreationPolicy.NONE)
            {
                // creationPolicy of none is not inherited by descendants.
                // In this case, set the style to "auto" and set a local
                // flag for subsequent access to the creationPolicy property.
                creationPolicyNone = true;
                value = ContainerCreationPolicy.AUTO;
            }
            else
            {
                creationPolicyNone = false;
            }

            setStyle("_creationPolicy", value);
        }

        /**
         *
         * @return
         */
        public function get deferredContentCreated():Boolean
        {
            return _deferredContentCreated;
        }

        /**
         *  @private
         */
        public function get draggable():Boolean
        {
            return _draggable;
        }

        /**
         *  @private
         */
        public function set draggable(value:Boolean):void
        {
            _draggable = value;
        }

        /**
         *
         * @param index
         * @return
         */
        public function getElementAt(index:int):IVisualElement
        {
            return currentContentGroup.getElementAt(index);
        }

        /**
         *
         * @param element
         * @return
         */
        public function getElementIndex(element:IVisualElement):int
        {
            return currentContentGroup.getElementIndex(element);
        }

        /**
         *
         * @return
         */
        public function getLayout():String
        {
            return _baseLayout;
        }

        /**
         *
         * @param plugin
         * @return
         */
        public function getPlugin(plugin:*):Object
        {
            return pluginManager.getPlugin(plugin, this.id);
        }

        //------------------------------------------------
        //
        //       插件操作部分
        //
        //------------------------------------------------
        /**
         *  根据插件传入ID获取对应的插件实例
         *  @param String id
         */
        public function getPluginById(id:String):Object
        {
            return pluginManager.getPluginById(id, this.id);
        }

        /**
         *  获取插件对象的完全限定类名
         */
        public function getPluginClassName():String
        {
            return pluginManager.getPluginClassName(this.type);
        }

        /**
         *  根据插件传入对象来获取索引
         *  暂不开放
         *  @param IPlugin
         */
        public function getPluginIndex(plugin:*):int
        {
            return pluginManager.getPluginIndex(plugin, this.id);
        }

        /**
         *
         * @return
         */
        public function get layout():LayoutBase
        {
            return (contentGroup)?contentGroup.layout:contentGroupProperties.layout;
        }

        /**
         *
         * @param value
         */
        public function set layout(value:LayoutBase):void
        {
            if (contentGroup)
            {
                contentGroup.layout = value;
                contentGroupProperties = BitFlagUtil.update(contentGroupProperties as uint, LAYOUT_PROPERTY_FLAG, true);
            }
            else
                contentGroupProperties.layout = value;

        }

        override public function set moduleFactory(moduleFactory:IFlexModuleFactory):void
        {
            super.moduleFactory = moduleFactory;

            // Register the _creationPolicy style as inheriting. See the creationPolicy
            // getter for details on usage of this style.
            styleManager.registerInheritingStyle("_creationPolicy");
        }

        [ArrayElementType("mx.core.IVisualElement")]
        /**
         *
         * @param value
         */
        public function set mxmlContent(value:Array):void
        {
            if (contentGroup)
                contentGroup.mxmlContent = value;
            else if (_placeHolderGroup)
                _placeHolderGroup.mxmlContent = value;
            else
                _mxmlContent = value;

            if (value!=null)
                _contentModified = true;
        }

        [InstanceType("Array")]
        [ArrayElementType("mx.core.IVisualElement")]
        /**
         *
         * @param value
         */
        public function set mxmlContentFactory(value:IDeferredInstance):void
        {
            if (value==_mxmlContentFactory)
                return;

            _mxmlContentFactory = value;
            mxmlContentCreated = false;
        }

        /**
         *
         * @return
         */
        public function get numElements():int
        {
            return currentContentGroup.numElements;
        }

        /**
         *
         */
        public function removeAllElements():void
        {
            _contentModified = true;
            currentContentGroup.removeAllElements();
        }

        /**
         *
         * @param element
         * @return
         */
        public function removeElement(element:IVisualElement):IVisualElement
        {
            _contentModified = true;
            return currentContentGroup.removeElement(element);
        }

        /**
         *
         * @param index
         * @return
         */
        public function removeElementAt(index:int):IVisualElement
        {
            _contentModified = true;
            return currentContentGroup.removeElementAt(index);
        }

        /**
         *  根据插件传入对象来移除该插件
         *  @param * plugin
         *  @param Boolean isDestroy 是否销毁 默认为false
         */
        public function removePlugin(plugin:*, isDestroy:Boolean = false):Object
        {
            return pluginManager.removePlugin(plugin, this.id, isDestroy);
        }

        /**
         *  根据插件传入对象ID来移除该插件
         *  @param String id
         *  @param Boolean isDestroy 是否销毁 默认为false
         */
        public function removePluginById(id:String, isDestroy:Boolean = false):Object
        {
            return pluginManager.removePluginById(id, this.id, isDestroy);
        }

        /**
         *  TODO:设置容器里单个容器可拖拽
         *  @param object 传入一个对象
         *
         */
        public function setDragComponent(component:Object):void
        {

        }

        /**
         *  TODO:设置容器里单个容器可拖拽, 根据对象的ID来设置
         *  @param object 传入一个对象的ID
         *  @private
         */
        public function setDragComponentById(Id:String):void
        {

        }

        /**
         *
         * @param element
         * @param index
         */
        public function setElementIndex(element:IVisualElement, index:int):void
        {
            _contentModified = true;
            currentContentGroup.setElementIndex(element, index);
        }

        /**
         *  设置布局管理方式,调用布局管理器里相应的方法.
         */
        public function setLayout(baseLayout:String):String
        {
            if (baseLayout!=_baseLayout)
            {
                layoutChanged = true;
				if(!this.contentGroup){
					callLater(LayoutManager.getInstance().setLayout, [baseLayout, _baseLayout, this]);
					_baseLayout = LayoutManager.getInstance().getLayout();
				}
				else
                	_baseLayout = LayoutManager.getInstance().setLayout(baseLayout, _baseLayout, this);
                dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT_CHANGED));
            }
            return _baseLayout;
        }

        /**
         *
         * @param element1
         * @param element2
         */
        public function swapElements(element1:IVisualElement, element2:IVisualElement):void
        {
            _contentModified = true;
            currentContentGroup.swapElements(element1, element2);
        }

        /**
         *
         * @param index1
         * @param index2
         */
        public function swapElementsAt(index1:int, index2:int):void
        {
            _contentModified = true;
            currentContentGroup.swapElementsAt(index1, index2);
        }

        override protected function commitProperties():void
        {
            super.commitProperties();
            if (borderColorChanged)
            {
                borderColorChanged = false;
            }
            if (layoutChanged)
            {
                layoutChanged = false;
            }
        }

        override protected function createChildren():void
        {
            super.createChildren();
            createContentIfNeeded();
        }

        override protected function partAdded(partName:String, instance:Object):void
        {
            super.partAdded(partName, instance);

            if (instance==contentGroup)
            {
                if (_contentModified)
                {
                    if (_placeHolderGroup!=null)
                    {
                        var sourceContent:Array = _placeHolderGroup.getMXMLContent();

                        for (var i:int = _placeHolderGroup.numElements; i>0; i--)
                        {
                            _placeHolderGroup.removeElementAt(0);
                        }

                        contentGroup.mxmlContent = sourceContent?sourceContent.slice():null;

                    }
                    else if (_mxmlContent!=null)
                    {
                        contentGroup.mxmlContent = _mxmlContent;
                        _mxmlContent = null;
                    }
                }

                var newContentGroupProperties:uint = 0;

                if (contentGroupProperties.autoLayout!==undefined)
                {
                    contentGroup.autoLayout = contentGroupProperties.autoLayout;
                    newContentGroupProperties = BitFlagUtil.update(newContentGroupProperties, AUTO_LAYOUT_PROPERTY_FLAG, true);
                }

                if (contentGroupProperties.layout!==undefined)
                {
                    contentGroup.layout = contentGroupProperties.layout;
                    newContentGroupProperties = BitFlagUtil.update(newContentGroupProperties, LAYOUT_PROPERTY_FLAG, true);
                }

                contentGroupProperties = newContentGroupProperties;

                contentGroup.addEventListener(ElementExistenceEvent.ELEMENT_ADD, contentGroup_elementAddedHandler);
                contentGroup.addEventListener(ElementExistenceEvent.ELEMENT_REMOVE, contentGroup_elementRemovedHandler);

                if (_placeHolderGroup)
                {
                    _placeHolderGroup.removeEventListener(ElementExistenceEvent.ELEMENT_ADD, contentGroup_elementAddedHandler);
                    _placeHolderGroup.removeEventListener(ElementExistenceEvent.ELEMENT_REMOVE, contentGroup_elementRemovedHandler);

                    _placeHolderGroup = null;
                }

//				if(this.type == "LayoutContainer")
//				{
//					contentGroup.addEventListener(MouseEvent.MOUSE_DOWN, layoutMouseDownHandler);
//					contentGroup.addEventListener(MouseEvent.MOUSE_UP, layoutMouseUpHandler);
//				}
            }
            if (instance==background)
            {

            }
        }

        override protected function partRemoved(partName:String, instance:Object):void
        {
            super.partRemoved(partName, instance);

            if (instance==contentGroup)
            {
                contentGroup.removeEventListener(ElementExistenceEvent.ELEMENT_ADD, contentGroup_elementAddedHandler);
                contentGroup.removeEventListener(ElementExistenceEvent.ELEMENT_REMOVE, contentGroup_elementRemovedHandler);

                var newContentGroupProperties:Object = {};

                if (BitFlagUtil.isSet(contentGroupProperties as uint, AUTO_LAYOUT_PROPERTY_FLAG))
                    newContentGroupProperties.autoLayout = contentGroup.autoLayout;

                if (BitFlagUtil.isSet(contentGroupProperties as uint, LAYOUT_PROPERTY_FLAG))
                    newContentGroupProperties.layout = contentGroup.layout;

                contentGroupProperties = newContentGroupProperties;

                var myMxmlContent:Array = contentGroup.getMXMLContent();

                if (_contentModified&&myMxmlContent)
                {
                    _placeHolderGroup = new Group();

                    _placeHolderGroup.mxmlContent = myMxmlContent;

                    _placeHolderGroup.addEventListener(ElementExistenceEvent.ELEMENT_ADD, contentGroup_elementAddedHandler);
                    _placeHolderGroup.addEventListener(ElementExistenceEvent.ELEMENT_REMOVE, contentGroup_elementRemovedHandler);
                }

                contentGroup.mxmlContent = null;
                contentGroup.layout = null;

//				if(this.type == "LayoutContainer")
//				{
//					contentGroup.removeEventListener(MouseEvent.MOUSE_DOWN, layoutMouseDownHandler);
//					contentGroup.removeEventListener(MouseEvent.MOUSE_UP, layoutMouseUpHandler);
//				}
            }
        }

        /**
         *  资源释放
         *  建议在覆写该方法里清理自己外部使用的引用,节省内部资源.
         */
        override protected function removeFromStageHandler(event:Event):void
        {
            super.removeFromStageHandler(event);

            //清空键值
            if (_displayListElements)
            {
                for each (var component:* in displayListElements)
                {
                    if (component)
                        delete displayListElements[component.id];
                }
                _displayListElements = null;
            }

            //清空引用
            if (_displayListArray)
            {
                for each (var component2:* in _displayListArray)
                {
                    if (component2)
                        component2 = null;
                }
                _displayListArray = null;
            }
        }

        mx_internal function get currentContentGroup():Group
        {
            createContentIfNeeded();

            if (!contentGroup)
            {
                if (!_placeHolderGroup)
                {
                    _placeHolderGroup = new Group();

                    if (_mxmlContent)
                    {
                        _placeHolderGroup.mxmlContent = _mxmlContent;
                        _mxmlContent = null;
                    }

                    _placeHolderGroup.addEventListener(ElementExistenceEvent.ELEMENT_ADD, contentGroup_elementAddedHandler);
                    _placeHolderGroup.addEventListener(ElementExistenceEvent.ELEMENT_REMOVE, contentGroup_elementRemovedHandler);
                }
                return _placeHolderGroup;
            }
            else
            {
                return contentGroup;
            }
        }

        //sm_internal var _displayListIndex:ArrayCollection;//保存子项引用

        sm_internal function get displayListElements():Dictionary
        {
            return _displayListElements;
        }

        sm_internal function set displayListElements(value:Dictionary):void
        {
            _displayListElements = value;
        }

        //TODO:允许用户根据显示列表某一个级别的容器id来控制其内部的布局
        sm_internal function setLayoutById(id:String):void
        {

        }

        /**
         *  当contentGroup里添加元素后派发事件
         */
        private function contentGroup_elementAddedHandler(event:ElementExistenceEvent):void
        {
            event.element.owner = this

            // Re-dispatch the event
            dispatchEvent(event);
        }

        /**
         *  当contentGroup里移除元素后派发事件
         */
        private function contentGroup_elementRemovedHandler(event:ElementExistenceEvent):void
        {
            event.element.owner = null;

            // Re-dispatch the event
            dispatchEvent(event);
        }

        private function createCompleteHandler(event:FlexEvent):void
        {
            //根据id遍历显示列表
            if (displayListLevel)
            {
                insertToDictionary(this, displayListElements);
            }
            //addEventListener(ElementExistenceEvent.ELEMENT_ADD, elementAddHandler);
        }

        /**
         *  @private
         */
        private function createContentIfNeeded():void
        {
            if (!mxmlContentCreated&&creationPolicy!=ContainerCreationPolicy.NONE)
                createDeferredContent();
        }

        //处理异步加载内部元素的问题（本身添加到舞台的时候，module并没有addElement进来 因此这里要处理一步加载问题）
        private function elementAddHandler(event:ElementExistenceEvent):void
        {
            var element:Object = event.element;

            if (_displayListArray.length==this.numElements)
                return;

            if (element&&element.id&&!displayListElements[element.id]&&_displayListArray.getItemIndex(element)<0)
            {
                displayListElements[element.id] = element;
                _displayListArray.addItem(element);
            }
        }

        private function fileCancelHandler(event:Event):void
        {
            //点击"取消"
        }

        private function fileCompleteHandler(event:Event):void
        {
            //点击"保存"
        }

        /**
         *
         * @param container
         * @param dictionary
         */
        sm_internal function insertToDictionary(container:*, dictionary:Dictionary):void
        {
            var num:int;
            if (container.hasOwnProperty("numElements")&&container.numElements)
            {
                num = container.numElements;
            }
            if (num)
            {
                for (var j:int = 0; j<num; j++)
                {
                    var ui:* = container.getElementAt(j);
                    if (ui&&ui.id)
                    {
                        dictionary[ui.id] = ui;
						if(_displayListArray)
                       	 	_displayListArray.addItem(ui);
                        //trace("t:" + t);
                        t++;

                    }
                    if (ui&&ui.hasOwnProperty("numElements")&&ui.numElements)
                    {
                        insertToDictionary(ui, dictionary);
                    }
                }
            }
        }

        private function isContains(element:IVisualElement):Boolean
        {
            var bol:Boolean = false;
            if (contentGroup)
            {
                var num:int = contentGroup.numElements;
                for (var i:int = 0; i<num; i++)
                {
                    if (element==contentGroup.getElementAt(i))
                    {
                        bol = true;
                    }
                }
            }
            return bol;
        }

        //这里先处理layoutContainer内部拖拽 mapContianer内部暂时不定拖拽 gear内部拖拽在自己congtainer里实现 
        private function layoutMouseDownHandler(event:MouseEvent):void
        {
            //当当前布局为绝对布局的时候才允许可拖拽 保存拖拽后的方案
            if (_baseLayout==BaseLayout.ABSOLUTE)
            {
                if (this.type=="LayoutContainer")
                {
                    if (_draggable) //如果当前允许拖拽
                    {
                        if (event.target&&event.target.hasOwnProperty("hostComponent")&&event.target.hostComponent==this)
                        {
                            addEventListener(MouseEvent.MOUSE_MOVE, layoutMouseMoveHandler);
                            addEventListener(MouseEvent.MOUSE_UP, layoutMouseUpHandler);
                        }
                        else
                        {
                            Sprite(event.target).addEventListener(MouseEvent.MOUSE_MOVE, layoutMouseMoveHandler);
                            Sprite(event.target).addEventListener(MouseEvent.MOUSE_UP, layoutMouseUpHandler);
                                //event.stopPropagation();
                        }
                    }
                }
            }
        }

        //拖拽要支持在容器之间进行......
        private function layoutMouseMoveHandler(event:MouseEvent):void
        {
            if (this.type=="LayoutContainer")
            {
                if (!DragManager.isDragging)
                {
                    if (event.target&&event.target.hasOwnProperty("hostComponent")&&event.target.hostComponent==this) //当点击的是容器本身的时候 这里拖拽对象是整个容器
                    {
                        startDrag();
                    }
                    else
                    {
                        //isElementMove = true;
                        //如果点击的对象本身不是contentGroup 而是内部的一个子项的时候 这个时候禁用容器的拖拽
                        var dragTarget:Object = event.target;
                        try
                        {
                            var spt:Sprite = Sprite(dragTarget);
                            if (spt&&contentGroup)
                            {
                                spt.startDrag(false, new Rectangle(contentGroup.x, contentGroup.y, contentGroup.width-spt.width, contentGroup.height-spt.height));
                                    //event.stopPropagation();
                            }
                        }
                        catch (e:Event)
                        {
                            //该对象不支持拖拽操作!
                        }
                    }
                }
            }
        }

        private function layoutMouseUpHandler(event:MouseEvent):void
        {
            if (this.type=="LayoutContainer")
            {
                if (event.target&&event.target.hasOwnProperty("hostComponent")&&event.target.hostComponent==this)
                {
                    removeEventListener(MouseEvent.MOUSE_MOVE, layoutMouseMoveHandler);
                    removeEventListener(MouseEvent.MOUSE_UP, layoutMouseUpHandler);
                    stopDrag();
                }
                else
                {
                    Sprite(event.target).removeEventListener(MouseEvent.MOUSE_MOVE, layoutMouseMoveHandler);
                    Sprite(event.target).stopDrag();
                        //event.stopPropagation();
                }
            }
        }

        /**
         *  右键保存布局为本地的xml文件
         */
        private function setContextMenu():void
        {
            var contextMenuText:String = "保存布局信息......";
            var menuItem:ContextMenuItem = new ContextMenuItem(contextMenuText, true, true);
            menuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function(event:ContextMenuEvent):void
            {
                //save
                layoutMsg = _baseLayout;
                var elementNum:int = contentGroup.numElements;
                var header:String = "<?xml version='1.0'?>\n";
                if (layoutMsg==BaseLayout.ABSOLUTE) //绝对布局保存xy信息
                {
                    //container
                    var containerHeader:String = "<"+"LayoutComponent"+" "+"Type="+"\""+type+"\""+" "+"Layout="+"\""+layoutMsg+"\""+">\n";
                    var elementMsg:String = "";
                    for (var i:int = 0; i<elementNum; i++)
                    {
                        var element:IVisualElement = contentGroup.getElementAt(i);
                        var elementX:int = element.x;
                        var elementY:int = element.y;

                        var className:String = (getQualifiedClassName(element) as String).split("::")[1];

                        elementMsg += "  <"+className+" "+"id"+"="+"\""+(element as UIComponent).id+"\""+" "+"x"+"="+"\""+elementX+"\""+" "+"y"+"="+"\""+elementY+"\""+"/>\n";
                    }
                    var end:String = "</LayoutComponent>";
                }
                var content:String = header+containerHeader+elementMsg+end;

                var fileReference:FileReference = new FileReference();
                fileReference.addEventListener(Event.CANCEL, fileCancelHandler);
                fileReference.addEventListener(Event.COMPLETE, fileCompleteHandler);
                fileReference.save(content, "layout.xml");
            });

            //添加到当前右键菜单里面去
            if (!this.contextMenu)
            {
                this.contextMenu = new ContextMenu();
                this.contextMenu.hideBuiltInItems();
                if (this.contextMenu.customItems)
                {
                    this.contextMenu.customItems.push(menuItem);
                }
            }
        }

        private function setRightClickHandler(event:MouseEvent):void
        {
            //trace("支持右键了！");
        }

        /**
         *  加载至舞台回调函数
         */
        private function stageHandler(event:Event):void
        {
            //对子项的拖拽目前支持基础布局容器
            if (this.type=="LayoutContainer")
            {
                stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseOutHandler);
                stage.addEventListener(Event.MOUSE_LEAVE, stageMouseOutHandler);
            }

            //2012.4.19 注释掉。。。			
//			//根据id遍历显示列表
//			if(displayListLevel)
//			{
//				_displayListArray = new ArrayCollection();
//				displayListElements = new Dictionary(true);
//				insertToDictionary(this, displayListElements);	
//			}
//			addEventListener(ElementExistenceEvent.ELEMENT_ADD, elementAddHandler);
        }

        private function stageMouseOutHandler(event:Event):void
        {
            if (this.hasEventListener(MouseEvent.MOUSE_MOVE))
                removeEventListener(MouseEvent.MOUSE_MOVE, layoutMouseMoveHandler);
            this.stopDrag();
        }
    }
}
