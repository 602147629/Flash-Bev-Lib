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
    import mx.controls.Image;

    import spark.components.Label;
    import spark.components.supportClasses.SkinnableComponent;

    /**
     * @private
     * @author gis
     */
    public class ItemComponent extends SkinnableComponent
    {

        [SkinPart(required = "false")]
        /**
         *
         * @default
         */
        public var itemImg:Image;

        [SkinPart(required = "false")]
        /**
         *
         * @default
         */
        public var itemLabel:Label;

        [Bindable]
        /**
         *
         * @default
         */
        public var imgSource:String;

        [Bindable]
        /**
         *
         * @default
         */
        public var text:String;

        /**
         *
         */
        public function ItemComponent()
        {
            super();
        }

        override protected function partAdded(partName:String, instance:Object):void
        {
            super.partAdded(partName, instance);
        }

        override protected function partRemoved(partName:String, instance:Object):void
        {
            super.partRemoved(partName, instance);
        }
    }
}
