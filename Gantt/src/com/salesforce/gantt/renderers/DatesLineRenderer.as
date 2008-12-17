package com.salesforce.gantt.renderers
{
	import com.salesforce.gantt.model.UI;
	import com.salesforce.gantt.model.Calendar;
	import com.salesforce.gantt.controller.Components;
	import flash.display.Graphics;
	
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.IDataRenderer;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.utils.GraphicsUtil;
	
	[Event(name="dataChange", type="mx.events.FlexEvent")]
	
	public class DatesLineRenderer extends UIComponent implements IDataRenderer, IListItemRenderer
	{
		private var _data : Object = null;
		   	
	    [Bindable("dataChange")]
		public function get data():Object
		{
			return _data;	
		}
		public function set data(value : Object):void
		{
			this._data = value;
			this.invalidateProperties();			
			dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
		}
		override protected function updateDisplayList(width : Number, height : Number) : void
		{
			super.updateDisplayList(width, height);
			graphics.clear();
			
			if ( _data != null )
			{
				var zoom : int = this.parentApplication.mainView.barChart.zoom;
				
				var today : Date = new Date();
				var date : Date = new Date(_data);
				
				var scale : int = this.parentApplication.mainView.barChart.getScale();
				var x : int = Components.instance.calendar.toDay(date) * scale;
				var bottom : int = this.parentApplication.mainView.taskList.visibleTask.length * UI.ROW_HEIGHT + 1000;//3000;// - (Components.instance.calendar.toDay(date) * UI.ROW_HEIGHT);
				var top : int = 0;//-3000;
				
				//si la fecha es fin de semana
				if(Components.instance.calendar.isWeekend(date) && zoom != 365)
				{
					if(Components.instance.calendar.isFirstDayOfTheMonth(date))
					{
						graphics.lineStyle(1, 0x333333, 1);
					}
					else
					{
						graphics.lineStyle(1, 0xC0C0Bf, 1);
					}
					graphics.beginFill(0xF3F3EC, 1);
					
					movePoint(x, top);
					drawPoint(x, top);
					drawPoint(x, bottom);
					drawPoint(x + scale, bottom);
					drawPoint(x + scale, top);
					drawPoint(x, top);
				}
				//si la fecha es hoy
				else if(equals(today, date) && zoom != 365)// || equals(tomorrow, date))
				{
					if(Components.instance.calendar.isFirstDayOfTheMonth(date))
					{
						graphics.lineStyle(1, 0x333333, 1);
					}
					else
					{
						graphics.lineStyle(1, 0x999999, 1);
					}
					graphics.beginFill(0xC0C0Bf, 1);
					
					movePoint(x, top);
					drawPoint(x, top);
					drawPoint(x, bottom);
					drawPoint(x + scale, bottom);
					drawPoint(x + scale, top);
					drawPoint(x, top);
				}
				//si la fecha NO es ni fin de semana ni hoy
				else
				{
					if(Components.instance.calendar.isFirstDayOfTheMonth(date))
					{
						graphics.lineStyle(1, 0x333333, 1);
					}
					else
					{
						graphics.lineStyle(1, 0xC0C0Bf, 1);
					}
					movePoint(x, top);
					drawVerticalLine(x, top, bottom);
				}
			}
			graphics.endFill();
		}
		/**
		 * Retorna true si dos fechas son iguales
		 */
		private function equals(dateOne : Date, dateTwo : Date): Boolean
		{
			return (dateOne.getDate() == dateTwo.getDate() && dateOne.getMonth() == dateTwo.getMonth() && dateOne.getFullYear() == dateTwo.getFullYear());
		}
	    /*
	     * Dibuja una linea vertical
	     */
		private function drawVerticalLine(x : int, top : int, bottom : int) : void 
		{
			drawPoint(x, top);
			drawPoint(x, bottom);
		}
		/*
	     * Dibuja una linea horizontal
	     */
		private function drawHorizontalLine(y : int, left : int, right : int) : void 
		{
			drawPoint(left, y);
			drawPoint(right, y);
		}
		/*
	    * Asigna un punto en la grafica para hacer las lineas  
	    * Esta funcion es para correr todo 10 pixeles a la izquierda
	    */
	    private function drawPoint(x : int, y : int) : void
	    {
	    	graphics.lineTo(x + UI.MARGIN, y);
	    }
	    /*
	    * Mueve el puntero que dibuja en la grafica  
	    * Esta funcion es para correr todo 10 pixeles a la izquierda
	    */
	    private function movePoint(x : int, y : int) : void
	    {
	    	graphics.moveTo(x + UI.MARGIN, y);
	    }
	}
}