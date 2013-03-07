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
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.Timer;
	
	/**
	 *  悬停提示ToolTip组件类.
	 *  该类主要用在停靠栏组件上,当鼠标滑过停靠栏里的图标时会显示该组件.
	 */
	public class ToolTip extends Sprite 
	{
		private var _stage:Stage;
		private var _parentObject:DisplayObject;
		private var _tf:TextField;  
		private var _cf:TextField;  
		private var _tween:Tween;
		private var _titleFormat:TextFormat;
		private var _contentFormat:TextFormat;
		
		private var _titleOverride:Boolean = false;
		private var _contentOverride:Boolean = false;
		
		private var _defaultWidth:Number = 200;
		private var _buffer:Number = 10;
		private var _align:String = "center"
		private var _cornerRadius:Number = 12;
		//private var _bgColors:Array = [0x569656, 0x3A663B];
		private var _bgColors:Array = [0x54995a, 0x54995a];
		private var _autoSize:Boolean = false;
		private var _hookEnabled:Boolean = false;
		private var _delay:Number = 0;  
		private var _hookSize:Number = 10;
		
		private var _offSet:Number;
		private var _hookOffSet:Number;
		
		private var _timer:Timer;
		
		private var _currentTitle:String;
		private var currentTitleChanged:Boolean = false;
		
		private static var _instance:ToolTip;
		
		/**
		 *  获取当前显示内容文本
		 *  @return String 返回内容
		 */
		public function get currentTitle():String
		{
			return _currentTitle;
		}
		
		public function ToolTip():void 
		{
			this.mouseEnabled = false;
			this.buttonMode = false;
			this.mouseChildren = false;
			_timer = new Timer(this._delay, 1);
            _timer.addEventListener("timer", timerHandler);
		}
		
		/**
		 *  获取当前单一实例
		 *  @return ToolTip 当前实例
		 */
		public static function getInstance():ToolTip
		{
			return _instance ||= new ToolTip();
		}
		
		/**
		 * 显示该组件
		 * @param DisplayObject 要显示该提示信息的组件
		 * @param String 显示内容
		 * @param String 默认不设置 为null
		 */
		public function show( p:DisplayObject, title:String, content:String=null ):void 
		{
				this._stage = p.stage;
				this._parentObject = p;
				for(var i:int = 0; i < this._stage.numChildren; i++)
				{
					if(this._stage.getChildAt(i) is ToolTip)
					{
						//当当前已经 有一个 tooltip的实例的时候 不需要新建一个 实例  只需要显示出来即可 这里需要修改 title与 content
						//2012.6.8
						if(this._tf.htmlText)
							this._tf.htmlText = "";
						
						if( ! this._titleOverride ){
							this.initTitleFormat();
						}
						
						var titleIsDevice:Boolean = this.isDeviceFont(  _titleFormat );
						
						this._tf.htmlText = title;
						this._tf.setTextFormat( this._titleFormat, 0, title.length );
						if( this._autoSize ){
							this._defaultWidth = this._tf.textWidth + 4 + ( _buffer * 2 );
						}else{
							this._tf.width = this._defaultWidth - ( _buffer * 2 );
						}
						
						this._tf.x = this._buffer;
						this._tf.y = 0;
						this.textGlow( this._tf );						
					
						//添加对内容自适应显示
						this.graphics.clear();
						this.setOffset();
						this.drawBG();
						this.bgGlow();
						//position
						var parentCoords2:Point = new Point( _parentObject.mouseX, _parentObject.mouseY );
						var globalPoint2:Point = p.localToGlobal(parentCoords2);
						this.x = globalPoint2.x + this._offSet;
						this.y = globalPoint2.y - this.height - 10;
						this.alpha = 1;
						
						this._parentObject.addEventListener( MouseEvent.MOUSE_OUT, this.onMouseOut );
						this.follow( true );
						_timer.start();
						return;
					}
				}
				this.addCopy( title, content );
				this.setOffset();
				this.drawBG();
				this.bgGlow();
				
				var parentCoords:Point = new Point( _parentObject.mouseX, _parentObject.mouseY );
				var globalPoint:Point = p.localToGlobal(parentCoords);
				this.x = globalPoint.x + this._offSet;
				this.y = globalPoint.y - this.height - 10;
				this.alpha = 0;
				
				this._stage.addChild( this );
				this._parentObject.addEventListener( MouseEvent.MOUSE_OUT, this.onMouseOut );
				this.follow( true );
				_timer.start();
		}
		
		/**
		 *  隐藏该组件
		 */
		public function hide():void {
			this.animate( false );
		}
		
		private function timerHandler( event:TimerEvent ):void {
			this.animate(true);
		}

		private function onMouseOut( event:MouseEvent ):void {
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			this.hide();
		}
		
		private function follow( value:Boolean ):void {
			if( value ){
				addEventListener( Event.ENTER_FRAME, this.eof );
			}else{
				removeEventListener( Event.ENTER_FRAME, this.eof );
			}
		}
		
		private function eof( event:Event ):void {
			this.position();
		}
		
		private function position():void {
			var speed:Number = 3;
			var parentCoords:Point = new Point( _parentObject.mouseX, _parentObject.mouseY );
			var globalPoint:Point = _parentObject.localToGlobal(parentCoords);
			var xp:Number = globalPoint.x + this._offSet;
			var yp:Number = globalPoint.y - this.height - 10;
			
			var overhangRight:Number = this._defaultWidth + xp;
			if( overhangRight > stage.stageWidth ){
				xp =  stage.stageWidth -  this._defaultWidth;
			}
			if( xp < 0 ) {
				xp = 0;
			}
			if( (yp) < 0 ){
				yp = 0;
			}
			this.x += ( xp - this.x ) / speed;
			this.y += ( yp - this.y ) / speed;
		}
		
		private function addCopy( title:String, content:String ):void {
			if( ! this._titleOverride ){
				this.initTitleFormat();
			}
			var titleIsDevice:Boolean = this.isDeviceFont(  _titleFormat );
			
			this._tf = this.createField( titleIsDevice ); 
			this._tf.htmlText = title;
			this._tf.setTextFormat( this._titleFormat, 0, title.length );
			if( this._autoSize ){
				this._defaultWidth = this._tf.textWidth + 4 + ( _buffer * 2 );
			}else{
				this._tf.width = this._defaultWidth - ( _buffer * 2 );
			}
			
			this._tf.x = this._buffer;
			this._tf.y = 0;
			this.textGlow( this._tf );
			addChild( this._tf );
			
		}
		
		private function createField( deviceFont:Boolean ):TextField {
			var tf:TextField = new TextField();
			tf.embedFonts = ! deviceFont;
			tf.gridFitType = "pixel";
			//tf.border = true;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.selectable = false;
			if( ! this._autoSize ){
				tf.multiline = true;
				tf.wordWrap = true;
			}
			return tf;
		}
		
		private function drawBG():void {
			var bounds:Rectangle = this.getBounds( this );
			var fillType:String = GradientType.LINEAR;
		   	//var colors:Array = [0xFFFFFF, 0x9C9C9C];
		   	//var alphas:Array = [0.6, 0.4];
			var alphas:Array = [0.8, 0.8];
		   	var ratios:Array = [0x00, 0xFF];
		   	var matr:Matrix = new Matrix();
			var radians:Number = 90 * Math.PI / 180;
		  	matr.createGradientBox(this._defaultWidth, bounds.height + ( this._buffer * 2 ), radians, 0, 0);
		  	var spreadMethod:String = SpreadMethod.PAD;
		  	this.graphics.beginGradientFill(fillType, this._bgColors, alphas, ratios, matr, spreadMethod); 
			if( this._hookEnabled ){
				var xp:Number = 0; 
				var yp:Number = 0; 
				var w:Number = this._defaultWidth; 
				//var h:Number = bounds.height + ( this._buffer * 2 );
				var h:Number =  ( this._buffer * 2 );
				this.graphics.moveTo ( xp + this._cornerRadius, yp );
				this.graphics.lineTo ( xp + w - this._cornerRadius, yp );
				this.graphics.curveTo ( xp + w, yp, xp + w, yp + this._cornerRadius );
				this.graphics.lineTo ( xp + w, yp + h - this._cornerRadius );
				this.graphics.curveTo ( xp + w, yp + h, xp + w - this._cornerRadius, yp + h );
				
				//hook
				this.graphics.lineTo ( xp + this._hookOffSet + this._hookSize, yp + h );
				this.graphics.lineTo ( xp + this._hookOffSet , yp + h + this._hookSize );
				this.graphics.lineTo ( xp + this._hookOffSet - this._hookSize, yp + h );
				this.graphics.lineTo ( xp + this._cornerRadius, yp + h );
				
				this.graphics.curveTo ( xp, yp + h, xp, yp + h - this._cornerRadius );
				this.graphics.lineTo ( xp, yp + this._cornerRadius );
				this.graphics.curveTo ( xp, yp, xp + this._cornerRadius, yp );
				this.graphics.endFill();
			}else{
				this.graphics.drawRoundRect( 0, 0, this._defaultWidth, bounds.height + ( this._buffer * 2 ), this._cornerRadius );
			}
		}
		
		private function animate( show:Boolean ):void {
			var end:int = show == true ? 1 : 0;
		    _tween = new Tween( this, "alpha", Strong.easeOut, this.alpha, end, .5, true );
			if( ! show ){
				_tween.addEventListener( TweenEvent.MOTION_FINISH, onComplete );
				_timer.reset();
			}
		}
		
		private function onComplete( event:TweenEvent ):void {
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			//当前有一个实例的时候不进行移除 保证在快速移动的时候 能正常浏览
			for(var i:int = 0; i < this._stage.numChildren; i++)
			{
				if(this._stage.getChildAt(i) is ToolTip)
					return;
			}
			this.cleanUp();
		}

		/**
		 *  @private
		 */
		public function set tipWidth( value:Number ):void {
			this._defaultWidth = value;
		}
		
		/**
		 *  设置文本样式
		 *  @param TextFormat
		 */
		public function set titleFormat( tf:TextFormat ):void {
			this._titleFormat = tf;
			if( this._titleFormat.font == null ){
				this._titleFormat.font = "_sans";
			}
			this._titleOverride = true;
		}
		
		/**
		 *  @private
		 */
		public function set contentFormat( tf:TextFormat ):void {
			this._contentFormat = tf;
			if( this._contentFormat.font == null ){
				this._contentFormat.font = "_sans";
			}
			this._contentOverride = true;
		}
		
		/**
		 *  @private
		 */
		public function set align( value:String ):void {
			var a:String = value.toLowerCase();
			var values:String = "right left center";
			if( values.indexOf( value ) == -1 ){
				throw new Error( this + " : Invalid Align Property, options are: 'right', 'left' & 'center'" );
			}else{
				this._align = a;
			}
		}
		
		/**
		 *  @private
		 */
		public function set delay( value:Number ):void {
			this._delay = value;
			this._timer.delay = value;
		}
		
		/**
		 *  设置是否显示下方的小箭头
		 *  @param Boolean
		 */
		public function set hook( value:Boolean ):void {
			this._hookEnabled = value;
		}
		
		/**
		 *  @private
		 */
		public function set hookSize( value:Number ):void {
			this._hookSize = value;
		}
		
		/**
		 *  @private
		 */
		public function set cornerRadius( value:Number ):void {
			this._cornerRadius = value;
		}
		
		/**
		 *  设置背景色
		 */
		public function set colors( colArray:Array ):void {
			this._bgColors = colArray;
		}
		
		/**
		 *  @private
		 */
		public function set autoSize( value:Boolean ):void {
			this._autoSize = value;
		}
		
		private function textGlow( field:TextField ):void {
			var color:Number = 0x000000;
            var alpha:Number = 0.35;
            var blurX:Number = 2;
            var blurY:Number = 2;
            var strength:Number = 1;
            var inner:Boolean = false;
            var knockout:Boolean = false;
            var quality:Number = BitmapFilterQuality.HIGH;

           var filter:GlowFilter = new GlowFilter(color,
                                  alpha,
                                  blurX,
                                  blurY,
                                  strength,
                                  quality,
                                  inner,
                                  knockout);
            var myFilters:Array = new Array();
            myFilters.push(filter);
        	field.filters = myFilters;
		}
		
		private function bgGlow():void {
			var color:Number = 0x000000;
            var alpha:Number = 0.20;
            var blurX:Number = 5;
            var blurY:Number = 5;
            var strength:Number = 1;
            var inner:Boolean = false;
            var knockout:Boolean = false;
            var quality:Number = BitmapFilterQuality.HIGH;

           var filter:GlowFilter = new GlowFilter(color,
                                  alpha,
                                  blurX,
                                  blurY,
                                  strength,
                                  quality,
                                  inner,
                                  knockout);
            var myFilters:Array = new Array();
            myFilters.push(filter);
            filters = myFilters;
		}
		
		private function initTitleFormat():void {
			_titleFormat = new TextFormat();
			_titleFormat.font = "_sans";
			_titleFormat.bold = true;
			_titleFormat.size = 12;
			_titleFormat.color = 0xFFFFFF;
		}
		
		private function initContentFormat():void {
			_contentFormat = new TextFormat();
			_contentFormat.font = "_sans";
			_contentFormat.bold = false;
			_contentFormat.size = 14;
			_contentFormat.color = 0x333333;
		}
		
		private function isDeviceFont( format:TextFormat ):Boolean {
			var font:String = format.font;
			var device:String = "_sans _serif _typewriter";
			return device.indexOf( font ) > -1;
		}
		
		private function setOffset():void {
			switch( this._align ){
				case "left":
					this._offSet = - _defaultWidth +  ( _buffer * 3 ) + this._hookSize; 
					this._hookOffSet = this._defaultWidth - ( _buffer * 3 ) - this._hookSize; 
				break;
				
				case "right":
					this._offSet = 0 - ( _buffer * 3 ) - this._hookSize;
					this._hookOffSet =  _buffer * 3 + this._hookSize;
				break;
				
				case "center":
					this._offSet = - ( _defaultWidth / 2 );
					this._hookOffSet =  ( _defaultWidth / 2 );
				break;
				
				default:
					this._offSet = - ( _defaultWidth / 2 );
					this._hookOffSet =  ( _defaultWidth / 2 );;
				break;
			}
		}
		
		private function cleanUp():void {
			this._parentObject.removeEventListener( MouseEvent.MOUSE_OUT, this.onMouseOut );
			//this._parentObject.removeEventListener( MouseEvent.MOUSE_MOVE, this.onMouseMovement );
			this.follow( false );
			if(this._tf)
			{
				this._tf.filters = [];
				this.filters = [];
				removeChild( this._tf );
				this._tf.htmlText = "";
				this._tf = null;
			}
			
			this.graphics.clear();
			if(parent)
			 	parent.removeChild( this );
		}
	}
}
