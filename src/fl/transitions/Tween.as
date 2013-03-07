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
package fl.transitions
{
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
	/**
	 *  @private
	 */
    public class Tween extends EventDispatcher
    {
        private var _position:Number = NaN;
        public var prevTime:Number = NaN;
        public var prevPos:Number = NaN;
        public var isPlaying:Boolean = false;
        public var begin:Number = NaN;
        private var _fps:Number = NaN;
        private var _time:Number = NaN;
        public var change:Number = NaN;
        private var _finish:Number = NaN;
        public var looping:Boolean = false;
        private var _intervalID:uint = 0;
        public var func:Function;
        private var _timer:Timer = null;
        private var _startTime:Number = NaN;
        public var prop:String = "";
        private var _duration:Number = NaN;
        public var obj:Object = null;
        public var useSeconds:Boolean = false;
        public static var _mc:MovieClip = new MovieClip();

        public function Tween(param1:Object, param2:String, param3:Function, param4:Number, param5:Number, param6:Number, param7:Boolean = false)
        {
            isPlaying = false;
            obj = null;
            prop = "";
            func = function (param1:Number, param2:Number, param3:Number, param4:Number) : Number
            {
                return param3 * param1 / param4 + param2;
            }
            ;
            begin = NaN;
            change = NaN;
            useSeconds = false;
            prevTime = NaN;
            prevPos = NaN;
            looping = false;
            _duration = NaN;
            _time = NaN;
            _fps = NaN;
            _position = NaN;
            _startTime = NaN;
            _intervalID = 0;
            _finish = NaN;
            _timer = null;
            if (!arguments.length)
            {
                return;
            }
            this.obj = param1;
            this.prop = param2;
            this.begin = param4;
            this.position = param4;
            this.duration = param6;
            this.useSeconds = param7;
            if (param3 is Function)
            {
                this.func = param3;
            }
            this.finish = param5;
            this._timer = new Timer(100);
            this.start();
            return;
        }

        public function continueTo(param1:Number, param2:Number) : void
        {
            this.begin = this.position;
            this.finish = param1;
            if (!isNaN(param2))
            {
                this.duration = param2;
            }
            this.start();
        }

        public function stop() : void
        {
            this.stopEnterFrame();
            this.dispatchEvent(new TweenEvent(TweenEvent.MOTION_STOP, this._time, this._position));
        }

        private function fixTime() : void
        {
            if (this.useSeconds)
            {
                this._startTime = getTimer() - this._time * 1000;
            }
        }

        public function set FPS(param1:Number) : void
        {
            var _loc_2:Boolean = false;
            _loc_2 = this.isPlaying;
            this.stopEnterFrame();
            this._fps = param1;
            if (_loc_2)
            {
                this.startEnterFrame();
            }
        }

        public function get finish() : Number
        {
            return this.begin + this.change;
        }

        public function get duration() : Number
        {
            return this._duration;
        }

        protected function startEnterFrame() : void
        {
            var _loc_1:Number = NaN;
            if (isNaN(this._fps))
            {
                _mc.addEventListener(Event.ENTER_FRAME, this.onEnterFrame, false, 0, true);
            }
            else
            {
                _loc_1 = 1000 / this._fps;
                this._timer.delay = _loc_1;
                this._timer.addEventListener(TimerEvent.TIMER, this.timerHandler, false, 0, true);
                this._timer.start();
            }
            this.isPlaying = true;
        }

        public function set time(param1:Number) : void
        {
            this.prevTime = this._time;
            if (param1 > this.duration)
            {
                if (this.looping)
                {
                    this.rewind(param1 - this._duration);
                    this.update();
                    this.dispatchEvent(new TweenEvent(TweenEvent.MOTION_LOOP, this._time, this._position));
                }
                else
                {
                    if (this.useSeconds)
                    {
                        this._time = this._duration;
                        this.update();
                    }
                    this.stop();
                    this.dispatchEvent(new TweenEvent(TweenEvent.MOTION_FINISH, this._time, this._position));
                }
            }
            else if (param1 < 0)
            {
                this.rewind();
                this.update();
            }
            else
            {
                this._time = param1;
                this.update();
            }
        }

        protected function stopEnterFrame() : void
        {
            if (isNaN(this._fps))
            {
                _mc.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
            }
            else
            {
                this._timer.stop();
            }
            this.isPlaying = false;
        }

        public function getPosition(param1:Number = NaN) : Number
        {
            if (isNaN(param1))
            {
                param1 = this._time;
            }
            return this.func(param1, this.begin, this.change, this._duration);
        }

        public function set finish(param1:Number) : void
        {
            this.change = param1 - this.begin;
        }

        public function set duration(param1:Number) : void
        {
            this._duration = param1 <= 0 ? (Infinity) : (param1);
        }

        public function setPosition(param1:Number) : void
        {
            this.prevPos = this._position;
            if (this.prop.length)
            {
                var _loc_2:* = param1;
                this._position = param1;
                this.obj[this.prop] = _loc_2;
            }
            this.dispatchEvent(new TweenEvent(TweenEvent.MOTION_CHANGE, this._time, this._position));
        }

        public function resume() : void
        {
            this.fixTime();
            this.startEnterFrame();
            this.dispatchEvent(new TweenEvent(TweenEvent.MOTION_RESUME, this._time, this._position));
        }

        public function fforward() : void
        {
            this.time = this._duration;
            this.fixTime();
        }

        protected function onEnterFrame(event:Event) : void
        {
            this.nextFrame();
        }

        public function get position() : Number
        {
            return this.getPosition(this._time);
        }

        public function yoyo() : void
        {
            this.continueTo(this.begin, this.time);
        }

        public function nextFrame() : void
        {
            if (this.useSeconds)
            {
                this.time = (getTimer() - this._startTime) / 1000;
            }
            else
            {
                this.time = this._time + 1;
            }
        }

        protected function timerHandler(event:TimerEvent) : void
        {
            this.nextFrame();
            event.updateAfterEvent();
        }

        public function get FPS() : Number
        {
            return this._fps;
        }

        public function rewind(param1:Number = 0) : void
        {
            this._time = param1;
            this.fixTime();
            this.update();
        }

        public function set position(param1:Number) : void
        {
            this.setPosition(param1);
        }

        public function get time() : Number
        {
            return this._time;
        }

        private function update() : void
        {
            this.setPosition(this.getPosition(this._time));
        }

        public function start() : void
        {
            this.rewind();
            this.startEnterFrame();
            this.dispatchEvent(new TweenEvent(TweenEvent.MOTION_START, this._time, this._position));
        }

        public function prevFrame() : void
        {
            if (!this.useSeconds)
            {
                this.time = this._time - 1;
            }
        }
    }
}
