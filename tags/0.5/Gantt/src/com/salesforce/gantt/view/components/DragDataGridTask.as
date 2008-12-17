package com.salesforce.gantt.view.components
{
	
	import flash.display.Graphics;
    import mx.skins.ProgrammaticSkin;
    import mx.managers.CursorManager;
    import mx.states.AddChild;
    import mx.core.BitmapAsset;

 
	public class DragDataGridTask extends ProgrammaticSkin
	{
		 	// Constructor.		 
	        public function DragDataGridTask()
	        {
	            super();
	        }
	 
	         //  @private	        
	        override protected function updateDisplayList(w:Number, h:Number):void
	        {	
	            super.updateDisplayList(w, h);
	 
	            var g:Graphics = graphics;
	 			
	 			// Draw the "ghost" row
	            g.clear();
	            g.lineStyle(1, 0x0D4E6B,0.8,false);
	            g.drawRect( 33,12,w - 33 ,30);
	            
	            // Draw the row limit inside
	            var l:Graphics = graphics;
	            l.lineStyle(1, 0x000000,1,false);
	            l.drawRect(33,26,w-33,3);
	  
	            CursorManager.removeAllCursors();
	           	
	            
	        }
		
	}

 
	
	
}