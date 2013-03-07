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
	import com.supermap.framework.dock.supportClasses.DockBar;
	import com.supermap.framework.dock.supportClasses.DockBarMananger;
	import com.supermap.framework.dock.supportClasses.DockBarSkin;
	import com.supermap.framework.dock.supportClasses.DockUtil;
	import com.supermap.framework.events.BaseEventDispatcher;
	import com.supermap.framework.events.FloatPanelEvent;
	import com.supermap.framework.skins.ItemComponentSkin;
	import com.supermap.framework.skins.ToolTipBarSkin;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.containers.TabNavigator;
	import mx.controls.Image;
	import mx.core.*;
	import mx.events.*;
	import mx.managers.CursorManager;
	import mx.managers.PopUpManager;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.NavigatorContent;
	import spark.components.TitleWindow;
	import spark.components.VGroup;
	import spark.effects.Move;
	import spark.effects.Resize;
	import spark.events.ElementExistenceEvent;

	/**
	 * 浮动面板类
	 * @author gis
	 */
	public class FloatPanel extends spark.components.TitleWindow
	{

		[SkinPart(required = "false")]
		/**
		 *
		 * @default
		 */
		public var resize:Image;

		[SkinPart(required = "false")]
		/**
		 *
		 * @default
		 */
		public var dockButton:Button;

		[SkinPart(required = "false")]
		/**
		 *
		 * @default
		 */
		public var minButton:Button;

		[SkinPart(required = "false")]
		/**
		 *
		 * @default
		 */
		public var dockbar:VGroup;

		[SkinPart(required = "false")]
		/**
		 *
		 * @default
		 */
		public var titleImg:Image;

		[SkinPart(required = "false")]
		/**
		 *
		 * @default
		 */
		public var lockButton:Button;

		[SkinState("open")]
		[SkinState("minimized")]
		[SkinState("closed")]
		[SkinState("dock")]

		/**
		 *
		 * @default
		 */
		public static const MINIMIZED:String = "minimized";

		/**
		 *
		 * @default
		 */
		public static const OPEN:String = "open";

		/**
		 *
		 * @default
		 */
		public static const CLOSED:String = "closed";

		/**
		 *
		 * @default
		 */
		public static const DOCK:String = "dock";

		private var currentStateChanged:Boolean = false;

		private var _titileWindowState:String = "normal";

		private var titleWindowHeight:int = 127;

		private var titleWindowWidth:int = 131;

		[Embed(source = "assets/w_resizecursor.png")]
		/**
		 *
		 * @default
		 */
		public var resizeCursor:Class;

		private var _cursorID:int = 0;

		/**
		 *
		 * @default
		 */
		public var minBtnClass:String = "assets/panel_min.png";

		/**
		 *
		 * @default
		 */
		public var minBtnOverClass:String = "assets/images/panel_max.png";

		/**
		 * 浮动面板右下角的resize默认显示图标
		 * @default
		 */
		[Bindable]
		[Embed("assets/resize.png")]
		public var resizeClass:Class;

		private var defaultIcon:String = "assets/default.png";

		private var _isShowIcon:Boolean = false;

		[Bindable]
		/**
		 *
		 * @default
		 */
		public var icon:String;

		[Bindable]
		/**
		 *
		 * @default
		 */
		public var stageWidth:Number;

		[Bindable]
		/**
		 *
		 * @default
		 */
		public var stageHeight:Number;

		/**
		 *
		 * @default
		 */
		public var isDragable:Boolean = true;

		/**
		 *
		 * @default
		 */
		public var isResizable:Boolean = true;

		/**
		 *
		 * @default
		 */
		public var tabLimitNum:int = 5;

		/**
		 *  用一个字典来存储DockBarDataGroup与本身的对应关系
		 */
		private var dictionary:Dictionary;
		private var dockDictionary:Dictionary;
		/**
		 *
		 * @default
		 */
		protected var dockContainer:IDockableContainer = null;

		/**
		 *
		 * @default
		 */
		public var lockPanel:Boolean = false;
		
		public var mouseClickHandler:Function;

		/**
		 *
		 * @param param1
		 */
		public function FloatPanel(param1:INavigatorContent = null)
		{
			var tabNavigator:DockableTabNavigator = null;
			var dockableTabNavigator:DockableTabNavigator = null;
			addEventListener(CloseEvent.CLOSE, handleClose);
			if (param1!=null)
			{
				if (param1 is IDockableContainer)
				{
					addChild(param1 as DisplayObject);
					if (param1 is DockableTabNavigator&&DockableTabNavigator(param1).selectedChild)
					{
						DockableTabNavigator(param1).selectedChild = DockableTabNavigator(param1).selectedChild;
					}
				}
				else
				{
					var previousIndex:int;
					var parentTabNavigator:DockableTabNavigator;
					tabNavigator = new DockableTabNavigator();
					addChild(tabNavigator);
					if (param1.parent!=null&&param1.parent is DockableTabNavigator)
					{
						//先获取拖拽出去的tab在之前的面板里的索引位置
						parentTabNavigator = (param1.parent as DockableTabNavigator);
						var previousNum:int = parentTabNavigator.numElements;
						for(var i:int = 0; i < previousNum; i++)
						{
							if(param1 == parentTabNavigator.getElementAt(i))
								previousIndex = i;
						}
							
						dockableTabNavigator = DockableTabNavigator(param1.parent);
						tabNavigator.dockId = dockableTabNavigator.dockId;
						tabNavigator.autoCreatePanelEnabled = dockableTabNavigator.autoCreatePanelEnabled;
						tabNavigator.floatEnabled = dockableTabNavigator.floatEnabled;
						tabNavigator.multiTabEnabled = dockableTabNavigator.multiTabEnabled;
					}
					addChild(param1 as DisplayObject);
					
					//当创建一个新的面板时候派发(由drag引起的创建)FLOATPANEL_CREATE
					var panelObj:Object = {
						panel:this,
						navigatorContent:param1
						//plugin:parentTabNavigator.getElementAt(previousIndex)
					}
					BaseEventDispatcher.getInstance().dispatchEvent(new FloatPanelEvent(FloatPanelEvent.FLOATPANEL_CREATE, panelObj));
				}
			}

			if (!dictionary)
				dictionary = new Dictionary();
			if(!dockDictionary)
				dockDictionary = new Dictionary();
			
			this.addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removeHandler);
			this.addEventListener(Event.ADDED_TO_STAGE, addStageListenerHandler);
		}
		
		private function fixFloatSize():void
		{
			var myWidth:Number = NaN;
			var myHeight:Number = NaN;
			if (initialized)
			{
				myWidth = minWidth;
				myHeight = minHeight;
				if (width<myWidth&&width<myWidth*2&&height<myHeight&&height<myHeight*2)
				{
					width = width;
					height = height;
				}
				else
				{
					width = width;
					height = height;
				}
			}
			else
			{
				callLater(fixFloatSize);
			}
		}

		override protected function createChildren():void
		{
			super.createChildren();
			callLater(fixFloatSize);
		}

		/**
		 *  默认不显示左侧的图标
		 */
		public function get isShowIcon():Boolean
		{
			return _isShowIcon;
		}

		/**
		 * @private
		 */
		public function set isShowIcon(value:Boolean):void
		{
			//titlewindow的默认图标设置
			if (value)
			{
				if (icon==null)
					icon = defaultIcon;
			}
		}

		/**
		 *  处理拖拽鼠标超出stage导致鼠标失去焦点的问题
		 */
		private function addStageListenerHandler(event:Event):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, moveArea_mouseUpHandler);
			stage.addEventListener(Event.MOUSE_LEAVE, moveArea_mouseUpHandler);
		}

		/**
		 *  当直接通过拖拽只包含有一个tab标签页的窗口时 也要做停靠栏里的处理
		 */
		private function removeHandler(event:Event):void
		{
			var dataGroup:DockBarDataGroup = getDockGroupByWindow(event.target as FloatPanel);
			if (dataGroup)
			{
				removeDataGroupByWindow(dataGroup);
			}
		}

		public var tabNavigator:TabNavigator;

		/**
		 *  创建完成回调函数
		 */
		private function creationCompleteHandler(event:FlexEvent):void
		{
			if(mouseClickHandler != null)
				addEventListener(MouseEvent.CLICK, mouseClickHandler);
			
			minHeight = titleWindowHeight;
			minWidth = titleWindowWidth;

			titleWindowHeight = height;
			titleWindowWidth = width;

			stageWidth = FlexGlobals.topLevelApplication.width;
			stageHeight = FlexGlobals.topLevelApplication.height;

			if (this.numElements)
				tabNavigator = this.getElementAt(0) as DockableTabNavigator;

			if (tabNavigator && tabNavigator.selectedChild)
			{
				titleDisplayFalse();
				
				//tabNavigator基本属性设置
				tabNavigator.width = titleWindowWidth - 18;
				tabNavigator.height = titleWindowHeight - 45;
				tabNavigator.top = "-30";
				tabNavigator.bottom = "0";

				//title = tabNavigator.selectedChild.label;

				tabNavigator.addEventListener(ChildChangeEvent.CHILD_CHANGE, childChangeHandler);

				//写入键值对信息
				var dockBarDataGroup:DockBarDataGroup = new DockBarDataGroup();
				var dockData:DockData = new DockData();
				dockData.name = this.title;
				dockData.icon = this.defaultIcon;
				var arrayC:ArrayCollection = new ArrayCollection();
				arrayC.addItem(dockData);
				dockBarDataGroup.dataProvider = arrayC;
				dockBarDataGroup.verticalCenter = 0;

				//保持键值关系
				dictionary[dockBarDataGroup] = this;

				if (this.titleWindowState!=DOCK)
					this.titleWindowState = OPEN;
			}
			else
			{
				//针对没有使用标签页的titlewindow的简要处理				
				var dataGroup:DockBarDataGroup = new DockBarDataGroup();
				var data:DockData = new DockData();
				data.name = this.title;
				data.icon = this.defaultIcon;
				var ary:ArrayCollection = new ArrayCollection();
				ary.addItem(data);
				dataGroup.dataProvider = ary;
				dataGroup.verticalCenter = 0;

				//保持键值关系
				dictionary[dataGroup] = this;

				if (this.titleWindowState!=DOCK)
					this.titleWindowState = OPEN;
			}
			dockDictionary[id] = this;
		}

		private function childChangeHandler(event:ChildChangeEvent):void
		{
			//title = event.newTitle;
		}

		/**
		 *
		 * @return
		 */
		public function get titleWindowState():String
		{
			return _titileWindowState;
		}

		/**
		 *
		 * @param value
		 */
		public function set titleWindowState(value:String):void
		{
			if(_titileWindowState != value)
			{
//				preTitleWindowState = _titileWindowState;
				_titileWindowState = value;			
				invalidateSkinState();
			}
		}

		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if (instance==resize)
			{
				resize.addEventListener(MouseEvent.MOUSE_OVER, resizeOverHandler);
				resize.addEventListener(MouseEvent.MOUSE_OUT, resizeOutHandler);
				resize.addEventListener(MouseEvent.MOUSE_DOWN, resizeStartHandler);
			}
			if (instance==minButton)
			{
				minButton.addEventListener(MouseEvent.CLICK, minBtnClickHandler);
				minButton.addEventListener(MouseEvent.MOUSE_OVER, minBtnOverHandler);
			}
			if (instance==closeButton)
			{
				closeButton.addEventListener(MouseEvent.MOUSE_OVER, closeBtnOverHandler);
				closeButton.addEventListener(MouseEvent.MOUSE_OUT, closeBtnOutHandler);
			}
			if (instance==dockButton)
			{
				dockButton.addEventListener(MouseEvent.CLICK, dockBtnClickHandler);
				dockButton.addEventListener(MouseEvent.MOUSE_OVER, dockBtnOverHandler);
			}
			if (instance==lockButton)
			{
				lockButton.addEventListener(MouseEvent.CLICK, lockBtnClickHandler);
				lockButton.addEventListener(MouseEvent.MOUSE_OVER, lockBtnOverHandler);
			}
			if (instance==titleImg)
			{
			}
			addEventListener(ElementExistenceEvent.ELEMENT_ADD, elementAddHandler);
		}

		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			if (instance==resize)
			{
				resize.removeEventListener(MouseEvent.MOUSE_DOWN, resizeStartHandler);
			}
			if (instance==minButton)
			{
				minButton.removeEventListener(MouseEvent.CLICK, minBtnClickHandler);
				minButton.removeEventListener(MouseEvent.MOUSE_OVER, minBtnOverHandler);
			}
			if (instance==closeButton)
			{
				closeButton.removeEventListener(MouseEvent.MOUSE_OVER, closeBtnOverHandler);
				closeButton.removeEventListener(MouseEvent.MOUSE_OUT, closeBtnOutHandler);
			}
			if (instance==dockButton)
			{
				dockButton.removeEventListener(MouseEvent.CLICK, dockBtnClickHandler);
				dockButton.removeEventListener(MouseEvent.MOUSE_OVER, dockBtnOverHandler);
			}
			if (instance==lockButton)
			{
				lockButton.removeEventListener(MouseEvent.CLICK, lockBtnClickHandler);
				lockButton.removeEventListener(MouseEvent.MOUSE_OVER, lockBtnOverHandler);
			}
			removeEventListener(ElementExistenceEvent.ELEMENT_ADD, elementAddHandler);
		}

		private function resizeStartHandler(event:MouseEvent):void
		{
			if (this.isResizable)
			{
				stage.addEventListener(MouseEvent.MOUSE_MOVE, resizeHandler);
				stage.addEventListener(MouseEvent.MOUSE_UP, resizeEndHandler);
			}
		}

		private function resizeOverHandler(event:MouseEvent):void
		{
			_cursorID = CursorManager.setCursor(resizeCursor, 2, -10, -10);
		}

		private function resizeOutHandler(event:MouseEvent):void
		{
			CursorManager.removeCursor(_cursorID);
		}

		/**
		 *  锁定或者解锁功能
		 */
		private function lockBtnClickHandler(event:MouseEvent):void
		{
			if (this.isDragable)
			{
				(event.target as Button).skin["lockButton"].source = "assets/panel_lock.png";
				this.isDragable = false;
				this.isResizable = false;
			}
			else
			{
				(event.target as Button).skin["lockButton"].source = "assets/panel_unlock.png";
				this.isDragable = true;
				this.isResizable = true;
			}
		}

		private function lockBtnOverHandler(event:MouseEvent):void
		{
			if (this.isDragable)
				(event.target as Button).toolTip = "锁定";
			else
				(event.target as Button).toolTip = "解锁";
		}

		/**
		 *  停靠
		 */
		private function dockBtnClickHandler(event:MouseEvent):void
		{
			preTitleWindowState = this.titleWindowState;
			this.titleWindowState = FloatPanel.DOCK;
		}

		/**
		 *  停靠对象
		 */
		private var dockComponent:DockBarComponent;
		private var dockBarManager:DockBarMananger;

		private var moveDockBar:Move;

		/**
		 *  显示停靠
		 */
		public function showDockBarHandler():void
		{
			dockBarManager = DockBarMananger.getInstance();
			dockBarManager.right = 0;
			dockBarManager.top = 100;
			if (!FlexGlobals.topLevelApplication.contains(dockBarManager as DisplayObject))
			{
				FlexGlobals.topLevelApplication.addElement(dockBarManager);
			}
			
			addDockBar();
		}

		private function showEffectHandler(event:EffectEvent):void
		{
			//动画结束
			moveDockBar.end();
		}

		/**
		 *  添加停靠条
		 */
		private var num:int;
		private var dockDatas:Array;
		private function addDockBar():void
		{
			dockDatas = [];
			//针对有tab标签页的情况
			if(this.numElements)
			{
				var dockTabNavigator:DockableTabNavigator = this.getElementAt(0) as DockableTabNavigator;
				if(dockTabNavigator){
					num = dockTabNavigator.numChildren;
					for(var i:int = 0; i < num; i++)
					{
						var navigatorContent:NavigatorContent = dockTabNavigator.getChildAt(i) as NavigatorContent;
						dockDatas.push(DockUtil.getInstance().getDockDataByID(navigatorContent.id));
					}
				}
				else 
				{
					num = 1;//一个面板 里面没有标签页
					dockDatas.push(DockUtil.getInstance().getDockDataByPanelID(id));
				}
			}
			else
			{
				num = 1;//一个面板 里面没有标签页
				dockDatas.push(DockUtil.getInstance().getDockDataByPanelID(id));
			}
			
			//添加一个停靠条
			var dockBar:DockBar = new DockBar();
			dockBar.setStyle("skinClass", DockBarSkin);
			dockBar.addEventListener(FlexEvent.CREATION_COMPLETE, dockBarCompleteHandler);
			dockBar.addEventListener(FloatPanelEvent.FLOATPANEL_DOCKOPEM, dockToOpenHandler);
			dockBarManager.addData(dockBar);
		}
		
		private function dockBarCompleteHandler(event:FlexEvent):void
		{
			var dockBar:DockBar = event.currentTarget as DockBar;
			//dockBar.dockBtn.label = num.toString();
			var caption:String = title;
			if(caption == "" || !caption)
			{
				var dockTabNavigator:DockableTabNavigator = this.getElementAt(0) as DockableTabNavigator;
				if(dockTabNavigator){
					var navigatorContent:NavigatorContent = dockTabNavigator.getChildAt(0) as NavigatorContent;
					caption = navigatorContent.label;
				}
			}
			dockBar.dockBtn.label = caption.split("").join("\n");
			//添加数据
			var dataAry:Array = [];
			for(var i:int = 0; i < dockDatas.length; i++)
			{
				dataAry.push({id:id, image:dockDatas[i].iconBar, tooltip:dockDatas[i].tooltip});
			}
			
			dockBar.dispatchEvent(new FloatPanelEvent(FloatPanelEvent.FLOATPANEL_DOCKDATA, dataAry));
		}
		
		//这里还有问题  
		//.对没有标签页的面板的处理 已经处理!
		//.对带有标签页拖拽出去的面板处理
		private function dockToOpenHandler(event:FloatPanelEvent):void
		{
			//根据panel的id来打开面板
			var obj:Object = event.data;
			var panelID:String = obj.panelID;
			if(!panelID) panelID = "null";//暂时处理为null(panelid)
			for(var panel:String in dockDictionary)
			{
				var fp:FloatPanel = dockDictionary[panel] as FloatPanel;
				var tabNavigator:TabNavigator
				if(fp.numElements && fp.getElementAt(0) is TabNavigator)
					tabNavigator = fp.getElementAt(0) as TabNavigator;
				if(obj.index)
					tabNavigator.selectedIndex = obj.index;
				if(panelID == panel && fp.titleWindowState == FloatPanel.DOCK)
					fp.titleWindowState = FloatPanel.OPEN;
			}
			//清理停靠栏里的对应项
			var currentDockBar:DockBar = event.target as DockBar;
			if(dockBarManager.contains(currentDockBar as DisplayObject))
				dockBarManager.removeData(currentDockBar);
		}
		
		private var toolTipContainer:ToolTipContainer;

		/**
		 *  显示提示框
		 */
		private function dockItemMouseOverHandler(event:Event):void
		{
			event.stopImmediatePropagation();

			var navigators:Array;
			var dackBarData:DockBarDataGroup = event.currentTarget as DockBarDataGroup;
			var currentWindow:spark.components.TitleWindow = getWindowByDockGroup(dackBarData);
			if(currentWindow.numElements)
			{
				var currentTabNavigator:TabNavigator = currentWindow.getElementAt(0) as TabNavigator;
				if (currentTabNavigator&&currentTabNavigator.numChildren)
				{
					navigators = [];
					var i:int = currentTabNavigator.numChildren;
					for (var j:int = 0; j<i; j++)
					{
						var navigatorContent:NavigatorContent = currentTabNavigator.getChildAt(j) as NavigatorContent;
						navigators.push(IconUtil.getSource(navigatorContent));
						//navigators.push("assets/school.png" + "&" + navigatorContent.label);
					}
				}
				else
				{
					navigators = [];
					navigators.push(this.icon+IconUtil.connector+this.title);
				}
			}
			else
			{
				//处理 没有使用标签页的情况 
				navigators = [];
				navigators.push(this.icon+IconUtil.connector+this.title);
			}
			
			//先获取图片的左侧面的中心位置 这个点坐标确定了提示框的箭头位置
			var currentMouseOverCenter:Point = dockComponent.mouseOverImageCenter;
			toolTipContainer = ToolTipContainer.getInstance();
			if (currentMouseOverCenter)
			{
				toolTipContainer.currentItems = navigators;
				//这里要给skin或者在构造函数里 但是放在css里定义时候 有问题。。。最好考虑放在default的样式表里 
				toolTipContainer.setStyle("skinClass", ToolTipBarSkin);
				toolTipContainer.addEventListener(FlexEvent.CREATION_COMPLETE, createCompleteHandler);
				//为了避免闪烁 这里先设置为false 当外边框绘制完毕时候 再设置为true
				toolTipContainer.visible = false;
				FlexGlobals.topLevelApplication.addElement(toolTipContainer);
			}
		}

		private function createCompleteHandler(event:FlexEvent):void
		{
			var items:Array = toolTipContainer.currentItems;
			var vgroup:VGroup = new VGroup();
			vgroup.addEventListener(FlexEvent.CREATION_COMPLETE, showtoolTipContainerHandler);
			//样式设置部分
			vgroup.horizontalCenter = 0;
			vgroup.verticalCenter = 0;
			vgroup.gap = 0;
			if(items)
			{
				var itemsLen:int = items.length;
				for (var j:int = 0; j<itemsLen; j++)
				{
					var item:String = items[j];
					if(item)
					{
						var itemAry:Array = item.split(IconUtil.connector);
						var itemComponent:ItemComponent = new ItemComponent();
						//默认高度值
						itemComponent.height = 20;
						itemComponent.setStyle("skinClass", ItemComponentSkin);
						itemComponent.imgSource = itemAry[0];
						itemComponent.text = itemAry[1];
						vgroup.addElement(itemComponent);
					}
				}
			}
			toolTipContainer.addElement(vgroup);
		}

		private var arrowOffsetX:Number = 4.5;

		private var arrowOffsetY:Number = 4.5;

		private function showtoolTipContainerHandler(event:FlexEvent):void
		{
			var target:Group = event.target as Group;
			var groupHeight:int = target.height;
			var groupWidth:int = target.width;
			var currentMouseOverCenter:Point = dockComponent.mouseOverImageCenter;
			if (currentMouseOverCenter)
			{
				toolTipContainer.visible = true;
				//如果提示框内容的高度的一半大于中心点的y值,那么不把中心点的y值作为提示框边缘线的中心位置 
				//注意:这里的坐标都是舞台坐标 全局的坐标 
				if (groupHeight*0.5>=currentMouseOverCenter.y)
				{
					toolTipContainer.x = this.dockComponent.x-groupWidth-35;
					toolTipContainer.y = dockComponent.y;
					toolTipContainer.path.data = "M"+(groupWidth+30)+" "+currentMouseOverCenter.y+"L"+(groupWidth+25)+" "+(currentMouseOverCenter.y+4.5)+"L"+(groupWidth+25)+" "+(currentMouseOverCenter.y+groupHeight*0.5)+"L"+"0"+" "+(currentMouseOverCenter.y+groupHeight*0.5)+"L"+"0"+" "+(currentMouseOverCenter.y-groupHeight*0.5)+"L"+(groupWidth+25)+" "+(currentMouseOverCenter.y-groupHeight*0.5)+"L"+(groupWidth+25)+" "+(currentMouseOverCenter.y-4.5)+"L"+(groupWidth+30)+" "+currentMouseOverCenter.y+"Z";
				}
				else
				{
					toolTipContainer.x = this.dockComponent.x-groupWidth-35;
					toolTipContainer.y = (currentMouseOverCenter.y-groupHeight*0.5);
					toolTipContainer.path.data = "M"+(groupWidth+30)+" "+currentMouseOverCenter.y+"L"+(groupWidth+25)+" "+(currentMouseOverCenter.y+4.5)+"L"+(groupWidth+25)+" "+(currentMouseOverCenter.y+groupHeight*0.5)+"L"+"0"+" "+(currentMouseOverCenter.y+groupHeight*0.5)+"L"+"0"+" "+(currentMouseOverCenter.y-groupHeight*0.5)+"L"+(groupWidth+25)+" "+(currentMouseOverCenter.y-groupHeight*0.5)+"L"+(groupWidth+25)+" "+(currentMouseOverCenter.y-4.5)+"L"+(groupWidth+30)+" "+currentMouseOverCenter.y+"Z";
				}
			}
		}

		private function dockItemClickHandler(event:Event):void
		{
			if (event.currentTarget&&event.currentTarget is DockBarDataGroup)
			{
				if (dictionary[event.currentTarget])
				{
					if (preTitleWindowState)
					{
						(dictionary[event.currentTarget] as FloatPanel).titleWindowState = preTitleWindowState;
						if (dockComponent.dockBar.contains(event.currentTarget as DisplayObject))
						{
							dockComponent.dockBar.removeElement(event.currentTarget as DockBarDataGroup);
							if (dockComponent.dockBar.numElements==0)
							{
								//当停靠条里没有子项的时候 隐藏该停靠条
								var move:Move = new Move(dockComponent);
								move.xFrom = FlexGlobals.topLevelApplication.width-42;
								move.xTo = FlexGlobals.topLevelApplication.width;
								move.duration = 300;
								move.play();
							}
						}
					}
					if(titleWindowState == FloatPanel.DOCK)
					{
						(dictionary[event.currentTarget] as FloatPanel).titleWindowState = FloatPanel.OPEN;
					}
						//(dictionary[event.currentTarget] as FloatPanel).titleWindowState = FloatPanel.OPEN;					
				}
			}
		}

		private function dockItemMouseOutHandler(event:Event):void
		{
			if (FlexGlobals.topLevelApplication.contains(toolTipContainer as DisplayObject))
				FlexGlobals.topLevelApplication.removeElement(toolTipContainer);
		}

		private function dockBtnOverHandler(event:MouseEvent):void
		{
			(event.target as Button).toolTip = "停靠";
		}

		/**
		 *  移动到关闭按钮上
		 */
		private function closeBtnOverHandler(event:MouseEvent):void
		{
			(event.target as Button).toolTip = "关闭";
			(event.target as Button).skin["closeButton"].source = "assets/panel_close_over.png";
		}

		/**
		 *  移出关闭按钮
		 */
		private function closeBtnOutHandler(event:MouseEvent):void
		{
			(event.target as Button).skin["closeButton"].source = "assets/panel_close.png";
		}

		private function minBtnOverHandler(event:MouseEvent):void
		{
			var target:Button = event.target as Button;
			if (this.titleWindowState==FloatPanel.MINIMIZED)
			{
				target.toolTip = "展开";
			}
			else
			{
				target.toolTip = "最小化";
			}
		}

		
		private function resizeHandler(event:MouseEvent):void
		{
			width = Math.max(mouseX+resize.width/2, minWidth);
			height = Math.max(mouseY+resize.height/2, minHeight);
			//这里的设置一定要注意
			if (tabNavigator)
			{
				tabNavigator.width = width-18;
				tabNavigator.height = height-45;
				tabNavigator.invalidateSize();
				tabNavigator.invalidateDisplayList();
			}
		}

		private function resizeEndHandler(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, resizeEndHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, resizeHandler);

			this.titleWindowHeight = height;
			this.titleWindowWidth = width;
		}

		private function elementAddHandler(event:ElementExistenceEvent):void
		{
			if (event.element is TabNavigator)
			{
				var tabNavigator:TabNavigator = (event.element as TabNavigator);
				tabNavigator.width = titleWindowWidth-20;
				tabNavigator.height = titleWindowHeight-45;
			}
			if (event.element is DockBarComponent)
			{
//				(event.element as DockBarComponent).dockBar;
				//addDockBar(null);
			}
		}

		/**
		 *  处理拖拽 
		 *  TODO:性能问题
		 */
		override protected function moveArea_mouseDownHandler(event:MouseEvent):void
		{
			super.moveArea_mouseDownHandler(event);
			addEventListener(MouseEvent.MOUSE_UP, moveArea_mouseUpHandler);
			if (isDragable)
			{
				var rect:Rectangle = new Rectangle(FlexGlobals.topLevelApplication.x, FlexGlobals.topLevelApplication.y, FlexGlobals.topLevelApplication.width - this.width, FlexGlobals.topLevelApplication.height - this.height);
				startDrag(false, rect);
			}
			
			setStyle("backgroundAlpha", 0.7);	
			setStyle("contentBackgroundAlpha", 0.7);
			var tabNavigator:TabNavigator;
			if(this.numElements)
				tabNavigator = (this.getElementAt(0) as TabNavigator);
			if(tabNavigator){
				tabNavigator.setStyle("backgroundAlpha", 0.7);	
				tabNavigator.setStyle("contentBackgroundAlpha", 0.7);
			}
		}

		/**
		 *  结束拖拽
		 *  TODO:性能问题
		 */
		override protected function moveArea_mouseUpHandler(event:Event):void
		{
			super.moveArea_mouseUpHandler(event);
			stopDrag();
			removeEventListener(MouseEvent.MOUSE_UP, moveArea_mouseUpHandler);
			
			setStyle("backgroundAlpha", 1);	
			setStyle("contentBackgroundAlpha", 1);
			
			var tabNavigator:TabNavigator;
			if(this.numElements)
				tabNavigator = (this.getElementAt(0) as TabNavigator);
			if(tabNavigator){
				tabNavigator.setStyle("backgroundAlpha", 1);	
				tabNavigator.setStyle("contentBackgroundAlpha", 1);
			}
		}

		override protected function closeButton_clickHandler(event:MouseEvent):void
		{
			super.closeButton_clickHandler(event);
			var tabNavigator:TabNavigator;
			if(this.numElements)
			 	tabNavigator = (this.getElementAt(0) as TabNavigator);
			if (tabNavigator&&tabNavigator.numChildren>1)
			{
				PopUpManager.addPopUp(ClosePanel.getInstance(), DisplayObject(FlexGlobals.topLevelApplication), true);
				ClosePanel.getInstance().closeHandler = CloseAllHandler;
				ClosePanel.getInstance().cancelHandler = CloseAllHandler;
				
			}
			else
			{
				removeFromParent();
			}
		}

		//TODO：当全部关闭的时候 停靠里也做相应的清除处理。。。。。。
		private function CloseAllHandler(event:Event):void
		{
			if (event.target.label == ClosePanel.closeLabel)
			{
				removeFromParent();
			}
			else if (event.target.label == ClosePanel.cancelLabel)
			{
				//nothing
			}
			PopUpManager.removePopUp(ClosePanel.getInstance());  
		}


		/**
		 *  从父容器里移除本身
		 */
		private function removeFromParent():void
		{
			if (this.parent&&this.parent.contains(this)&&(this.parent is IVisualElementContainer))
			{
				(this.parent as IVisualElementContainer).removeElement(this);
				//删除完毕后 派发事件 该事件会在面板管理条PanConfigBar里进行监听处理
				BaseEventDispatcher.getInstance().dispatchEvent(new FloatPanelEvent(FloatPanelEvent.FLOATPANEL_REMOVE, this));
				
				var dataGroup:DockBarDataGroup = getDockGroupByWindow(this);
				if (dataGroup)
				{
					removeDataGroupByWindow(dataGroup);
				}
			}
		}

		/**
		 *  根据传入的窗口来获取对应的数据
		 */
		private function getDockGroupByWindow(titleWindow:spark.components.TitleWindow):DockBarDataGroup
		{
			for (var dataGroup:* in dictionary)
			{
				if (dictionary[dataGroup]==titleWindow&&dockComponent&&dockComponent.dockBar&&dockComponent.dockBar.contains(dataGroup as DisplayObject))
				{
					return dataGroup;
				}
			}
			return null;
		}

		/**
		 *  根据传入的数据来获取对应的窗口
		 */
		private function getWindowByDockGroup(dockGroup:DockBarDataGroup):spark.components.TitleWindow
		{
			for (var dataGroup:* in dictionary)
			{
				if (dataGroup==dockGroup)
				{
					return dictionary[dataGroup];
				}
			}
			return null;
		}

		/**
		 *  根据要移除的titlewindow来同步在dockbar里对datagroup的移除
		 */
		private function removeDataGroupByWindow(dockGroup:DockBarDataGroup):void
		{
			delete dictionary[dockGroup];
			dockComponent.dockBar.removeElement(dockGroup);
		}

		private var preTitleWindowState:String;

		/**
		 *  最小化
		 *  当最小化的状态下 该图标显示为最大化 点击可切换到最大化状态 同时停靠可用
		 */
		private function minBtnClickHandler(event:MouseEvent):void
		{
			var resizeAnimation:Resize = new Resize(this);

			//从最小化到打开状态
			if (titleWindowState==FloatPanel.MINIMIZED)
			{
				resizeAnimation.heightTo = titleWindowHeight;
				resizeAnimation.duration = 300;
				titleWindowState = FloatPanel.OPEN;
				preTitleWindowState = FloatPanel.MINIMIZED;
				if (event.target.skin)
				{
					event.target.skin["minButton"].source = minBtnClass;
				}
			}
			else
			{
				//从打开到最小化状态
				resizeAnimation.heightTo = 30;
				resizeAnimation.duration = 300;
				if(this.numElements)
					(this.getElementAt(0) as TabNavigator).visible = false;
				titleWindowState = FloatPanel.MINIMIZED;
				if (event.target.skin)
				{
					event.target.skin["minButton"].source = minBtnOverClass;
				}
			}

			resizeAnimation.addEventListener(EffectEvent.EFFECT_END, minWindowHandler);
			resizeAnimation.play();

		}

		private function minWindowHandler(event:EffectEvent):void
		{
			var tabNavigator:TabNavigator;
			if(this.numElements)
				tabNavigator = (this.getElementAt(0) as TabNavigator);
			
			if (this.titleWindowState==FloatPanel.MINIMIZED)
			{
				if (tabNavigator && tabNavigator.numChildren)
				{
					var i:int = tabNavigator.numChildren;
					for (var j:int = 0; j<i; j++)
					{
						var label:Label = new Label();
						//最小化时候标题文字的颜色
						label.setStyle("color", 0xffffff);
						label.text = (tabNavigator.getChildAt(j) as NavigatorContent).label;
							//this.headerTitleBar.addElement(label);
					}
				}
				titleDisplayFalse();
			}
			else
			{
				titleDisplayTrue();
				if(tabNavigator)
					tabNavigator.visible = true;
			}
		}
		
		public function titleDisplayFalse():void
		{
			(titleDisplay as DisplayObject).visible = false;
		}

		public function titleDisplayTrue():void
		{
			(titleDisplay as DisplayObject).visible = true;
		}
		
		override protected function getCurrentSkinState():String
		{
			return titleWindowState;
		}

		private function onCurrentStateChange(event:StateChangeEvent):void
		{
			invalidateSkinState();
		}

//		override public function addElement(element:IVisualElement):IVisualElement
//		{
//			return addElementAt(element, 0);
//		}

		override public function addChild(param1:DisplayObject):DisplayObject
		{
			return addChildAt(param1, -1);
		}

		private function handleChangeChild(event:ChildChangeEvent):void
		{
			//title = event.newTitle;
			//showCloseButton = event.useCloseButton;
		}

		/**
		 *
		 * @return
		 */
		public function get multiTabEnabled():Boolean
		{
			if (dockContainer!=null&&dockContainer is DockableTabNavigator)
			{
				return (dockContainer as DockableTabNavigator).multiTabEnabled;
			}
			return false;
		}

		/**
		 *
		 * @return
		 */
		public function get autoCreatePanelEnabled():Boolean
		{
			if (dockContainer!=null&&dockContainer is DockableTabNavigator)
			{
				return (dockContainer as DockableTabNavigator).autoCreatePanelEnabled;
			}
			return false;
		}

		/**
		 *
		 * @return
		 */
		public function get floatEnabled():Boolean
		{
			if (dockContainer!=null)
			{
				return dockContainer.floatEnabled;
			}
			return false;
		}

		override public function addChildAt(param1:DisplayObject, param2:int):DisplayObject
		{
			if (dockContainer!=null)
			{
				if (param2==-1)
				{
					return dockContainer.addChild(param1);
				}
				return dockContainer.addChildAt(param1, param2);
			}
			else
			{
				if (param1 is IDockableContainer)
				{
					dockContainer = IDockableContainer(param1);
					//super.addChildAt(dockContainer as DisplayObject, 0);
					addElementAt(dockContainer as IVisualElement, 0);
				}
				else
				{
					dockContainer = new DockableTabNavigator();
					super.addChildAt(dockContainer as DisplayObject, 0);
					dockContainer.addChildAt(param1, 0);
					title = Container(param1).label;
				}
				dockContainer.percentWidth = 100;
				dockContainer.percentHeight = 100;
				dockContainer.addEventListener(ChildChangeEvent.CHILD_CHANGE, handleChangeChild);
				return param1;
			}
		}

		override public function addElementAt(element:IVisualElement, index:int):IVisualElement
		{
			var elementChild:IVisualElement;
			elementChild = super.addElementAt(element, index);
			return elementChild;
		}

		override public function get explicitMinWidth():Number
		{
			var minWidth:* = super.explicitMinWidth;
			if (!isNaN(minWidth))
			{
				return minWidth;
			}
			if (dockContainer!=null)
			{
				return dockContainer.explicitMinWidth+getStyle("paddingLeft")+getStyle("paddingRight")+getStyle("borderThicknessLeft")+getStyle("borderThicknessRight");
			}
			return getStyle("paddingLeft")+getStyle("paddingRight")+getStyle("borderThicknessLeft")+getStyle("borderThicknessRight");
		}

		private function handleClose(event:Event):void
		{
			if (dockContainer!=null)
			{
				dockContainer.closeChild();
			}
			return;
		}

		override public function get explicitMinHeight():Number
		{
			var minHeight:* = super.explicitMinHeight;
			if (!isNaN(minHeight))
			{
				return minHeight;
			}
			if (dockContainer!=null)
			{
				return dockContainer.explicitMinHeight+getStyle("headerHeight")+getStyle("paddingTop")+getStyle("paddingBottom")+getStyle("borderThicknessTop")+getStyle("borderThicknessBottom");
			}
			return getStyle("headerHeight")+getStyle("paddingTop")+getStyle("paddingBottom")+getStyle("borderThicknessTop")+getStyle("borderThicknessBottom");
		}

		override public function removeChild(param1:DisplayObject):DisplayObject
		{
			if (lockPanel&&param1==dockContainer)
			{
				return param1;
			}
			var displayObject:* = super.removeChild(param1);
			if (numChildren==0)
			{
				parent.removeChild(this);
			}
			return displayObject;
		}

		override public function removeElement(element:IVisualElement):IVisualElement
		{
			if (lockPanel&&element==dockContainer)
			{
				return element;
			}
			var visualElement:* = super.removeElement(element);
			if (numElements==0)
			{
				(parent as IVisualElementContainer).removeElement(this);
			}
			return visualElement;
		}
	}
}
