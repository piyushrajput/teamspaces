package com.salesforce.gantt.view.components
{ 
   import mx.managers.DragManager;
	import mx.core.DragSource;
	import mx.events.DragEvent;
	import flash.events.MouseEvent;
	import mx.containers.Canvas;
	import mx.containers.Panel;
	import com.salesforce.gantt.view.components.DragPanel;
	import mx.managers.ISystemManager;
	import flash.ui.Mouse;
	
   public class DragHorizontal
   {
	    private var rbComp : RubberBandComp;
	    public const MOVE_LEFT:String = "move_left";
		public const MOVE_RIGHT:String = "move_right";
	    private var canvasContentAll : Canvas;
	    private var dragPanel : DragPanel;
		private var systemManager : ISystemManager;
		
		public var resizingPanel : Panel;
		private var initX:Number;
		private var initY:Number;
			
		public var memoryWidth : int=0;
		/*
		 * Valores: left or right
		 * Indica para donde se va agrandar la ventana
		 */
		public var type : String;
		
       public function DragHorizontal(canvasContentAll : Canvas, dragPanel : DragPanel, rbComp : RubberBandComp, systemManager : ISystemManager, type : String)
       {
       		this.canvasContentAll 	= canvasContentAll;
       		this.dragPanel			= dragPanel;
       		this.rbComp				= rbComp;
       		this.systemManager		= systemManager;
       		this.type				= type;
       		
       		dragPanel.dragHorizontal = this;
       		dragPanel.setType(type);
       		//dragPanel.setResizizePanel(Panel(dragPanel));
       }

		public function resizeHandler(event:MouseEvent):void
		{			
			if(event.type=='move_left')
			{
				//reemplaze event.target por dragPanel
				resizingPanel = Panel(dragPanel);
				initX = event.localX;
				initY = event.localY;
				
				rbComp.x = dragPanel.x;
				rbComp.y = 0;//dragPanel.y;
				rbComp.height = 1000;//dragPanel.height;
				rbComp.width = dragPanel.width;			
					
				rbComp.setType('left');
				
				/*
				* cambie el z index del rbComp para que aparezca el resize.
				*/
				//canvasContentAll.setChildIndex(rbComp, dragPanelTasks.numChildren);
				canvasContentAll.setChildIndex(rbComp, canvasContentAll.numChildren-1);
				rbComp.visible=true;
				
				systemManager.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, true);
				systemManager.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, true);
				//systemManager.addEventListener(MouseEvent.CLICK, mouseClickHandler	);
			}
		}
		public function resizeHandler2(event:MouseEvent):void
		{
			if(event.type=='move_right')
			{
				//reemplaze event.target por dragPanel
				resizingPanel = Panel(dragPanel);
				initX = event.localX;
				initY = event.localY;
				
				rbComp.x = dragPanel.x;
				rbComp.y = 0;//dragPanel.y;
				rbComp.height = 1000;//dragPanel.height;
				rbComp.width = dragPanel.width;			
					
					rbComp.setType('right');
					
				/*
				* cambie el z index del rbComp para que aparezca el resize.
				*/
				//canvasContentAll.setChildIndex(rbComp, dragPanelTasks.numChildren);
				canvasContentAll.setChildIndex(rbComp, canvasContentAll.numChildren-1);
				rbComp.visible=true;
				
				systemManager.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler2, true);
				systemManager.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler2, true);
			}
		}
		public function mouseMoveHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			rbComp.width = rbComp.width + event.stageX - initX;
			initX = event.stageX;
		}
		
		public function mouseUpHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();		
			if (rbComp.width <= 18)//10
			{
				resizingPanel.width = 18;				
			}
			else
			{
				resizingPanel.width = rbComp.width;
				memoryWidth = resizingPanel.width;	
			}				
			
			
			/*
			* comente esto para que no esconda el dependency dialog 
			*/
			//canvasContentAll.setChildIndex(resizingPanel, canvasContentAll.numChildren-1);

			rbComp.x = 0;
			rbComp.y = 0;
			rbComp.height = 0;
			rbComp.width = 0;
			rbComp.visible = false;
			systemManager.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, true);
			systemManager.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, true	);
			//systemManager.removeEventListener(MouseEvent.CLICK, mouseClickHandler, true	);
		}
		public function mouseMoveHandler2(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			rbComp.width = rbComp.width + (initX - event.stageX);
			rbComp.x = event.stageX - 30;
			initX = event.stageX;
		}
		public function mouseUpHandler2(event:MouseEvent):void
		{
			event.stopImmediatePropagation();		
			resizingPanel.width = rbComp.width;	
			resizingPanel.x = rbComp.x;				
			if (rbComp.width > 10)
			{
				memoryWidth = resizingPanel.width;
			}
			
			/*
			* comente esto para que no esconda el dependency dialog 
			*/
			//canvasContentAll.setChildIndex(resizingPanel, canvasContentAll.numChildren-1);

			rbComp.x = 0;
			rbComp.y = 0;
			rbComp.height = 0;
			rbComp.width = 0;
			rbComp.visible = false;
			systemManager.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler2, true);
			systemManager.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler2, true	);
			//systemManager.removeEventListener(MouseEvent.CLICK, mouseClickHandler, true	);
		}
   }
}
 
