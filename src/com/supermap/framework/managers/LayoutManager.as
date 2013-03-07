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
    import com.supermap.framework.components.LayoutComponent;
    import com.supermap.framework.core.BaseLayout;
    import com.supermap.framework.core.ILayout;

    import mx.core.IVisualElement;

    import spark.components.supportClasses.SkinnableComponent;
    import spark.layouts.BasicLayout;
    import spark.layouts.HorizontalLayout;
    import spark.layouts.TileLayout;
    import spark.layouts.VerticalLayout;

    /**
     *  布局管理类.该类主要用来管理容器组件内部布局方式.
     *  @private
     */
    public class LayoutManager implements ILayout
    {
        private var _container:SkinnableComponent;

        private var layout:String = BaseLayout.ABSOLUTE;

        private static var _instance:LayoutManager;

        /**
         *  构造函数
         */
        public function LayoutManager(container:SkinnableComponent = null)
        {

        }

        public static function getInstance():LayoutManager
        {
            return _instance ||= new LayoutManager(null);
        }

        /**
         *  传入的组件容器.这里使用组件容器的共同基类SkinnableComponent.
         */
        public function get container():SkinnableComponent
        {
            return _container;
        }

        /**
         * @private
         */
        public function set container(value:SkinnableComponent):void
        {
            _container = value;
        }

        /**
         *  设置Layout
         *  elementVector这个变量要设置为静态 否则两次进来的对象不是同一个 导致布局失效......
         */
        public static var elementVector:Vector.<Object> = new Vector.<Object>();

        public function setLayout(baseLayout:String = BaseLayout.ABSOLUTE, preLayout:String = BaseLayout.ABSOLUTE, parent:LayoutComponent = null):String
        {
            var _baseLayout:String;

            var i:int = parent.contentGroup.numElements;

            if (_baseLayout==BaseLayout.ABSOLUTE||preLayout==BaseLayout.ABSOLUTE)
            {
                for (var j:int = 0; j<i; j++)
                {
                    var elementChild:IVisualElement = parent.contentGroup.getElementAt(j);
                    var elementVect:Object = { element: elementChild, elementX: elementChild.x, elementY: elementChild.y };
                    elementVector[j] = elementVect;
                }
            }

            switch (baseLayout)
            {
                case BaseLayout.HORIZONTAL||"HORIZONTAL": //水平布局

                    var horizontalLayout:HorizontalLayout = new HorizontalLayout();
                    parent.contentGroup.layout = horizontalLayout;
                    break;

                case BaseLayout.VERTICAL||"VERTICAL": //垂直布局

                    var verticalLayout:VerticalLayout = new VerticalLayout();
                    parent.contentGroup.layout = verticalLayout;
                    break;

                case BaseLayout.TILE||"TILE": //瓦片布局

                    var tileLayout:TileLayout = new TileLayout();
                    parent.contentGroup.layout = tileLayout;
                    break;

                case BaseLayout.ABSOLUTE:

                    var basicLayout:BasicLayout = new BasicLayout();
                    parent.contentGroup.layout = basicLayout;
                    for (var k:int = 0; k<i; k++)
                    {
                        var child:IVisualElement = parent.contentGroup.getElementAt(k);
                        for each (var element:* in elementVector)
                        {
                            if (element["element"]==child)
                            {
                                child.x = element.elementX;
                                child.y = element.elementY;
                            }
                        }
                    }
                    break;
            }

            _baseLayout = baseLayout;
            layout = _baseLayout;
            return _baseLayout;
        }

        /**
         *  获取layout
         */
        public function getLayout():String
        {
            return layout;
        }
    }
}
