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
    import com.supermap.framework.components.LayoutComponent;
    import com.supermap.framework.core.ILayout;
    import com.supermap.framework.dock.FloatPanel;
    import com.supermap.web.mapping.Map;

    /**
     *  基础容器.
     *  用来管理基础组件的容器.主要用来读取外部基础组件配置信息 并实现自身的初始化.
     *  @see com.supermap.framework.components.BaseComponent
     */
    public class LayoutContainer extends LayoutComponent
    {
        private var _isShowBar:Boolean = false;

        private var _isDrag:Boolean = false;
		
		private var _iconBar:String = "";
		
		private var _describe:String = "";

		private var _map:Map;
		
		/**
		 *  与插件本身关联的面板对象(注意该对象目前仅针对配置文件里的结构起作用)
		 */
		private var _panel:FloatPanel;
		
		public function get panel():FloatPanel
		{
			return _panel;
		}

		[Bindable]
		public function set panel(value:FloatPanel):void
		{
			_panel = value;
		}

		public function get map():Map
		{
			return _map;
		}
		
		public function set map(value:Map):void
		{
			_map = value;
		}
		
        /**
         *  构造函数
         */
        public function LayoutContainer()
        {
            super();
            this.id = id;
        }

		public function get describe():String
		{
			return _describe;
		}

		public function set describe(value:String):void
		{
			_describe = value;
		}

		public function get iconBar():String
		{
			return _iconBar;
		}

		public function set iconBar(value:String):void
		{
			_iconBar = value;
		}

        override public function get type():String
        {
            return this.className;
        }

        public function get isDrag():Boolean
        {
            return _isDrag;
        }

        public function set isDrag(value:Boolean):void
        {
            _isDrag = value;
        }

        /**
         *  是否显示拖拽条
         */
        public function get isShowBar():Boolean
        {
            return _isShowBar;
        }

        /**
         * @private
         */
        public function set isShowBar(value:Boolean):void
        {
            _isShowBar = value;
        }

        /**
         *  获取容器里的布局管理器
         */
        public function getLayourManager():ILayout
        {
            return null;
        }

        /**
         *  设置容器内部布局管理器
         */
        public function setLayoutMananger(layoutManager:ILayout):void
        {

        }
    }
}
