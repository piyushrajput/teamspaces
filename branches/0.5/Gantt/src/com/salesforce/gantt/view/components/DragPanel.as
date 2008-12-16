package com.salesforce.gantt.view.components
{
	import mx.containers.Panel;
	import mx.core.UIComponent;
	import mx.core.SpriteAsset;
	import mx.events.FlexEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import mx.utils.GraphicsUtil;
	import mx.managers.CursorManager;
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.controller.Constants;

	public class DragPanel extends Panel
	{
		private var type : String = '';
		//private var resizingPanel : Panel;
		
		public var dragHorizontal : DragHorizontal;
		
		// Add the creationCOmplete event handler.
		public function DragPanel()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
		}
		
		// Expose the title bar property for draggin and dropping.
		[Bindable]
		public var myTitleBar:UIComponent;
					
		private function creationCompleteHandler(event:Event):void
		{
			myTitleBar = titleBar;			
			// Add the resizing event handler.	
			addEventListener(MouseEvent.MOUSE_OVER, over);
			addEventListener(MouseEvent.MOUSE_DOWN, resizeHandler);
			addEventListener(MouseEvent.CLICK, mouseClickHandler);
		}
		private function over(event : MouseEvent) : void
		{
			CursorManager.removeCursor(CursorManager.currentCursorID);
		}
		private function isClickedInRecteangle(event : MouseEvent) : Boolean
		{
			var panelRelX:Number = event.localX + x;
			var panelRelY:Number = event.localY + y;
			
			var lowerLeftY : Number = 0; 
			var upperLeftY : Number = 0;
			
			var defaultleft : int = 20;
			if(id=='dragPanelTasks')
			{
				if(event.stageX >= width-defaultleft-20)
				{
					if(event.stageX <= width-defaultleft)
					{
						return true;
					}
				}
			}
			else if(id == 'editPanel')
			{
				if(event.stageX >= x+defaultleft-10)
				{
					if(event.stageX <= x+defaultleft-2)
					{
						return true;
					}
				}
			}
			return false;
		}
		public function mouseClickHandler(event : MouseEvent):void
		{
			if(isClickedInRecteangle(event))
			{
				if(dragHorizontal != null)
				{
					var resizingPanel : Panel = Panel(dragHorizontal.resizingPanel);
					//if(resizingPanel.width == 10)
					//{
					//trace(dragHorizontal.memoryWidth);
						//if(dragHorizontal.memoryWidth == 0)
						//{
							if(id=='dragPanelTasks')
							{
								if(resizingPanel.width==Constants.GRID_PANEL_MAX_WIDTH)
								{
									resizingPanel.width = Constants.GRID_PANEL_MIN_WIDTH;
								}	
								else
								{
									resizingPanel.width = Constants.GRID_PANEL_MAX_WIDTH;
								}
							}
							else
							{
								if(resizingPanel.width==Constants.DETAILS_PANEL_MAX_WIDTH)
								{
									resizingPanel.width = Constants.DETAILS_PANEL_MIN_WIDTH;
								}	
								else
								{
									resizingPanel.width = Constants.DETAILS_PANEL_MAX_WIDTH;
								}
							}
						//}
						//else
						//{
						//	resizingPanel.width = dragHorizontal.memoryWidth;	
						//}
					//}
					//else
					//{
					//	resizingPanel.width = 10;
					//}	
				}				
			}
		}
		
//		public function setResizizePanel(resizingPanel : Panel) : void
//		{
//			this.resizingPanel = resizingPanel;
//		}
		
		override protected function createChildren():void
		{
				super.createChildren();
		}	
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			// Draw resize graphics if not minimzed.
			drawGraphics(type);		
		}
		public function setType(type : String) : void
		{
			this.type = type;
			drawGraphics(type);
		}
		
		private function drawGraphics(type : String) : void
		{
			var topImage : int = 50;
			if(type == 'right')
			{
				graphics.clear()
				
				/*var leftSumImage : int = 0;
				
				graphics.lineStyle(1, 0x000000, 1);
				graphics.beginFill(0x000000, 1);
				graphics.moveTo(unscaledWidth + leftSumImage, 0 + topImage);
				graphics.lineTo(unscaledWidth + leftSumImage, 0 + topImage);
				graphics.lineTo(unscaledWidth + leftSumImage - 5, 5 + topImage);
				graphics.lineTo(unscaledWidth + leftSumImage, 10 + topImage);
				graphics.lineTo(unscaledWidth + leftSumImage, 0 + topImage);*/
				
				/*graphics.lineStyle(1, 0x666666, 1);
				
				graphics.beginFill(0xd6d3ce, 1);
				GraphicsUtil.drawRoundRectComplex(graphics, unscaledWidth-11, 5, 8, 20, 0, 0, 0, 0);
				
				graphics.moveTo(unscaledWidth-10, 0);
				graphics.lineTo(unscaledWidth-10, 5);
				
				graphics.moveTo(unscaledWidth-10, 25);
				graphics.lineTo(unscaledWidth-10, 1000);
				
				graphics.moveTo(unscaledWidth-8, 8);
				graphics.lineTo(unscaledWidth-8, 8);
				graphics.lineTo(unscaledWidth-8, 22);
				
				graphics.moveTo(unscaledWidth-6, 8);
				graphics.lineTo(unscaledWidth-6, 8);
				graphics.lineTo(unscaledWidth-6, 22);*/
			}
			else if(type == 'left')
			{
				graphics.clear()
				graphics.lineStyle(1, 0x666666, 1);
				
				/*graphics.beginFill(0xd6d3ce, 1);
				GraphicsUtil.drawRoundRectComplex(graphics, 2, 5, 8, 20, 0, 0, 0, 0);
				
				graphics.moveTo(9, 0);
				graphics.lineTo(9, 5);
				
				graphics.moveTo(9, 25);
				graphics.lineTo(9, 1000);
				
				graphics.moveTo(5, 8);
				graphics.lineTo(5, 8);
				graphics.lineTo(5, 22);
				
				graphics.moveTo(7, 8);
				graphics.lineTo(7, 8);
				graphics.lineTo(7, 22);*/
			}
		}
		// Define static constant for event type.
		public static const MOVE_LEFT:String = "move_left";
		public static const MOVE_RIGHT:String = "move_right";

		// Resize panel event handler.
		public  function resizeHandler(event:MouseEvent):void
		{
			if(isClickedInRecteangle(event))
			{	
				event.stopPropagation();
				var rbEvent : MouseEvent = null;
				if(id=='dragPanelTasks')
				{
					rbEvent = new MouseEvent(MOVE_LEFT, true);
				}
				else if(id=='editPanel')
				{
					rbEvent = new MouseEvent(MOVE_RIGHT, true);
				}
				// Pass stage coords to so all calculations using global coordinates.
				rbEvent.localX = event.stageX;
				rbEvent.localY = event.stageY;
				dispatchEvent(rbEvent);	
			}
		}	
	}
}