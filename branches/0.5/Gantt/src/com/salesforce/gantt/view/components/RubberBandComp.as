package com.salesforce.gantt.view.components
{ 
	import mx.core.UIComponent;

	public class RubberBandComp extends UIComponent
	{
		import flash.events.MouseEvent;
		import mx.containers.Panel;
		public function RubberBandComp()
		{
			super();
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			// Draw rubber band with a 1 pixel border, and a grey fill. 				
			graphics.clear();
			graphics.lineStyle(1);
			
			if(type=='left')
			{
				graphics.lineTo(unscaledWidth-10, 0);
				graphics.lineTo(unscaledWidth-10, unscaledHeight);
				graphics.lineTo(0, unscaledHeight);
			}
			else if(type=='right')
			{
				graphics.moveTo(30, 0);
				graphics.lineTo(30, 0);
				graphics.lineTo(30, unscaledHeight);
			}
			graphics.lineStyle(1, 0x333333);
		}
		public var type : String = '';
		public function setType(type : String) : void
		{
			this.type = type;
		}	
	}
}