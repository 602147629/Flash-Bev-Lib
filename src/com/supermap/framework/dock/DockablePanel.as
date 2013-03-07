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
    import flash.display.DisplayObject;
    import flash.events.*;
    
    import mx.core.*;
    
    import org.osmf.utils.Version;
    
    import spark.components.Label;

    /**
     *  停靠面板
     *  @private
     */
    public class DockablePanel extends FloatPanel
    {
        private var dragStarter:DragStarter = null;

        public function DockablePanel(param1:INavigatorContent = null)
        {
            super(param1);
        }

        override public function get floatEnabled():Boolean
        {
            if (dockContainer!=null)
            {
                return !lockPanel&&dockContainer.floatEnabled;
            }
            return false;
        }

        private function startDragDockPanel(event:MouseEvent):void
        {
            var dockableTabNavigator:DockableTabNavigator = null;
            var dockid:String = "";
            if (dockContainer is DockableTabNavigator)
            {
                dockableTabNavigator = dockContainer as DockableTabNavigator;
                dockid = dockableTabNavigator.dockId;
            }
            var dockSource:DockSource = new DockSource(DockManager.DRAGPANNEL, dockableTabNavigator, dockid);
            new DockSource(DockManager.DRAGPANNEL, dockableTabNavigator, dockid).targetPanel = this;
            dockSource.multiTabEnabled = multiTabEnabled;
            dockSource.floatEnabled = floatEnabled;
            dockSource.autoCreatePanelEnabled = autoCreatePanelEnabled;
            dockSource.lockPanel = lockPanel;
            DockManager.doDock(this, dockSource, event);
        }

        override protected function createChildren():void
        {
            super.createChildren();
            if (dragStarter==null)
            {
				dragStarterHandler(dragStarter);
            }
            dragStarter.startListen(startDragDockPanel);
        }
		
		public function dragStarterHandler(dragStarter:DragStarter):void
		{
			dragStarter = new DragStarter(titleDisplay as DisplayObject);
		}
		
        public function dockAsk(param1:DockSource, param2:UIComponent, param3:String):Boolean
        {
            if ((param2!=this || param1.targetPanel != this) 
				&&(dockContainer.numChildren != 1 || param1.targetTabNav != dockContainer))
            {
                return true;
            }
            return false;
        }
    }
}
