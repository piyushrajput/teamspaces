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
	import flash.geom.Rectangle;
	
	[Event(name="dataChange", type="mx.events.FlexEvent")]
	
	public class DatesLineRendererOverview extends UIComponent implements IDataRenderer, IListItemRenderer
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
				var scaleOverview : Number = this.parentApplication.mainView.barChartOverview.getScaleOverview();
				
				if(scaleOverview == 0)
				{
					scaleOverview = 1;
				}
				
				var x : int = Components.instance.calendar.toDay(date) * scaleOverview;
				//var top : int = Components.instance.calendar.toDay(date) / this.parentApplication.mainView.barChartOverview.rangeDates.length * (-10);
				var top : int = this.parentApplication.mainView.barChartOverview.positionDate(date) * (-1);
				var bottom : int = 150;
				_graphics.lineStyle(1, 0xCBCBCB, 1);
				
				if(top==0)
				{
					clearChildren();//borra todos
				}
				
				createLabelMonth(date, x + 10, scaleOverview);
				movePoint(x, top);
				drawPoint(x, top);
				drawPoint(x, bottom);
				drawPoint(x, top);
			}
			//_graphics.endFill();
		}
		/*private function clearChildren(date : Date) : void
		{
			if(parent != null)
			{
				var child : int = parent.numChildren;
				for (var i : int = 0; i < child; i++)
				{	
					var time : Number = Number(parent.getChildAt(i).name);
					if(time == date.getTime())
					{
						parent.removeChildAt(i);
						child--; i--;
					}
				}
			}
   		}*/
   		/**
   		 * Elimina todos los Sprite object que estan en la rilla del overview
   		 * cuyo nombre sea numerico
   		 */
   		private function clearChildren() : void
		{
			if(parent != null)
			{
				var child : int = parent.numChildren;
				for (var i : int = 0; i < child; i++)
				{	
					var time : Number = Number(parent.getChildAt(i).name);
					if(time.toString()!='NaN')
					{
						parent.removeChildAt(i);
						child--; i--;
					}
				}
			}
   		}
   		/**
   		 * Dada  una fecha crea la etiqueta que indica el mes
   		 */
		private function createLabelMonth(date : Date, x : int, scaleOverview : int) : void
		{
			var widthTextField : int = 60;
			dateFormatter.formatString = 'MMMM';
			//clearChildren(date);
			if(parent.getChildByName(date.getTime().toString()))
			{
				parent.removeChild(parent.getChildByName(date.getTime().toString()));
			}		
			var spriteMonth : Sprite = createSpriteMonth(date);
			
			if(scaleOverview*30 > widthTextField * 2)//si entran dos etiquetas de mes
			{
				spriteMonth.addChild(createTextFieldMonth(Components.instance.calendar.add(date,-1), x - widthTextField - 10, widthTextField, 'right'));
				spriteMonth.addChild(createTextFieldMonth(date, x + 10, widthTextField, 'left'));
			}
			else
			{
				spriteMonth.addChild(createTextFieldMonth(date, x, (scaleOverview * 30), 'center'));
			}
			
			parent.addChild(spriteMonth);
			// Add background to the months
			//	_graphics.beginFill(0x628B9B,1);
			//	var backgroundMonths : Rectangle = new Rectangle();
			//	backgroundMonths.x = x;
			//	backgroundMonths.y = 125;
			//	backgroundMonths.width = 900;
			//	backgroundMonths.height = 30;						
			 // parent.addChild(backgroundMonths);
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
			textFormat.bold = true;
			textFormat.color = 0xFFFFFF;			
			return textFormat;
		}
		/**
   		 * Retorna un sprite object
   		 */		
		private function createSpriteMonth(date : Date) : Sprite
		{
			var sprite : Sprite = new Sprite();
			sprite.name = date.getTime().toString();
			// sprite.opaqueBackground=false;		
			sprite.y = 125;
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
			textField.backgroundColor=0x628B9B;
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