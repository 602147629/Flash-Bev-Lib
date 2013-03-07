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
    import flash.display.*;
    import flash.events.*;
    import mx.controls.*;
    import mx.managers.*;

    /**
     * @private
     * @author gis
     */
    public class DragStarter extends EventDispatcher
    {
        private var listener:Function;

        private var target:DisplayObject;

        private var _distance:Number;

        private var downEvent:MouseEvent;

        private var listening:Boolean = false;

        private var dragState:int = 0;

        function DragStarter(param1:DisplayObject, param2:Number = 5)
        {
            super(null);
            this.target = param1;
            _distance = param2;
        }

        private function handleMouseOver(event:MouseEvent):void
        {
            dragState = 1;
        }

        /**
         *
         */
        public function stopListen():void
        {
            listening = false;
            target.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
            target.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
            target.removeEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);
            target.removeEventListener(MouseEvent.MOUSE_OUT, handleMouseOut);
            target.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
        }

        private function runListener(event:MouseEvent):void
        {
            if (DragManager.isDragging)
            {
                return;
            }
            target.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
            dragState = 0;
            listener(downEvent);
        }

        private function handleMouseUp(event:MouseEvent):void
        {
            dragState = 1;
            target.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
        }

        /**
         *
         * @param param1
         */
        public function startListen(param1:Function):void
        {
            this.listener = param1;
            if (!listening)
            {
                listening = true;
                dragState = 0;
                target.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
                target.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
                target.addEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);
                target.addEventListener(MouseEvent.MOUSE_OUT, handleMouseOut);
            }
        }

        private function handleMouseMove(event:MouseEvent):void
        {
            if (Math.abs(event.localX-downEvent.localX) > _distance || Math.abs(event.localY-downEvent.localY) > _distance)
            {
                runListener(event);
            }
        }

        private function handleMouseOut(event:MouseEvent):void
        {
            if (dragState == 2)
            {
                runListener(event);
            }
            target.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
            dragState = 0;
        }

        private function handleMouseDown(event:MouseEvent):void
        {
            if (event.target is Button && !Button(event.target).selected)
            {
                return;
            }
            dragState = 2;
            downEvent = event;
            target.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
        }
    }
}
