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
	import mx.formatters.DateFormatter;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import com.salesforce.gantt.model.Task;
	
	[Event(name="dataChange", type="mx.events.FlexEvent")]
	
	public class DatesLineRendererPrint extends UIComponent implements IDataRenderer, IListItemRenderer
	{
		private var _graphics : Graphics;
		private var _data : Object = null;
		private var dateFormatter : DateFormatter = new DateFormatter();
		
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
			_graphics = graphics;		
			_graphics.clear();
			
			if ( _data != null )
			{
				var date : Date = new Date(_data);
				var scale : int = this.parentApplication.mainView.barChart.getScale();
				var startValueReduce : int = this.parentApplication.mainView.barChart.startValueReduce(date);
				
				var x : int = (Components.instance.calendar.toDay(date) + startValueReduce) * scale;
				var top : int = this.parentApplication.mainView.barChart.getDatesPrintPosition(date) * (-1) -2;
				var bottom : int = top + 16;
				_graphics.lineStyle(1, 0x333333, 1);
				
				if(this.parentApplication.mainView.barChart.isMoreOfAMonth())
				{
					createLabelMonth(date, x + 10);
				}
				else
				{
					createLabelDays(date, x);
				}
				
				movePoint(x, top);
				drawPoint(x, top);
				drawPoint(x, bottom);
				drawPoint(x, top);
			}
			_graphics.endFill();
		}
		/**
   		 * Dada  una fecha crea la etiqueta que indica el mes
   		 */
		private function createLabelMonth(date : Date, x : int) : void
		{
			var widthTextField : int = 60;
			dateFormatter.formatString = 'MMMM';
			if(parent.getChildByName(date.getTime().toString()))
			{
				parent.removeChild(parent.getChildByName(date.getTime().toString()));
			}
			var spriteMonth : Sprite = createSpriteMonth(date);
			spriteMonth.addChild(createTextFieldMonth(Components.instance.calendar.add(date,-1), x - widthTextField - 10, widthTextField, 'right'));
			spriteMonth.addChild(createTextFieldMonth(date, x + 10, widthTextField, 'left'));
			parent.addChild(spriteMonth);
		}
		/**
   		 * Dada  una fecha crea la etiqueta que indica el dia
   		 */
		private function createLabelDays(date : Date, x : int) : void
		{
			var widthTextField : int = 60;
			dateFormatter.formatString = 'MMM DD';
			if(parent.getChildByName(date.getTime().toString()))
			{
				parent.removeChild(parent.getChildByName(date.getTime().toString()));
			}				
			var spriteDay : Sprite = createSpriteMonth(date);
			spriteDay.addChild(createTextFieldMonth(date, x, widthTextField, 'center'));
			parent.addChild(spriteDay);
		}
		/**
   		 * Retorna el formato de una etiqueta
   		 */
		private function createTextFormater(align : String) : TextFormat
		{
			var textFormat : TextFormat = new TextFormat();
			textFormat.font = "verdana";
			textFormat.size = 9;
			textFormat.align = align;
			return textFormat;
		}		
		/**
   		 * Retorna un sprite object
   		 */	
		private function createSpriteMonth(date : Date) : Sprite
		{
			var sprite : Sprite = new Sprite();
			sprite.name = date.getTime().toString();
			sprite.y = 4;
			return sprite;
		}
		/**
   		 * Retorna la etiqueta que indica el mes
   		 */					
		private function createTextFieldMonth(date : Date, x : int, width : int, align : String) : TextField
		{
			var textField : TextField = new TextField();
			textField.text = dateFormatter.format(date);
			textField.width = width;
			textField.x = x;
			textField.setTextFormat(createTextFormater(align),-1,-1);
			return textField;
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
	    	_graphics.lineTo(x + UI.MARGIN, y);
	    }
	    /*
	    * Mueve el puntero que dibuja en la grafica  
	    * Esta funcion es para correr todo 10 pixeles a la izquierda
	    */
	    private function movePoint(x : int, y : int) : void
	    {
	    	_graphics.moveTo(x + UI.MARGIN, y);
	    }
	}
}