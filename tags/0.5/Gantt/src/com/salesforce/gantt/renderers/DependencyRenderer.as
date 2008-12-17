package com.salesforce.gantt.renderers
{
	import com.salesforce.gantt.model.UI;
	import com.salesforce.gantt.model.Task;
	import com.salesforce.gantt.model.UiTask;
	import com.salesforce.gantt.model.Dependency;
	
	import flash.display.Graphics;
	
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.IDataRenderer;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.utils.GraphicsUtil;
	import com.salesforce.gantt.controller.Components;
	
	[Event(name="dataChange", type="mx.events.FlexEvent")]
	
	/*
	 * Los comentarios de los metodos que dibujan usan estas letras para describir los pasos
	 *      	  ______________________________________
	 *	      _A_|           Parent Task                |
	 *		 |   |______________________________________|    
	 *		B|_____________________________________________
	 *						      C						   |
	 *													   |D
	 * 													 _\/___________________________________
	 *	     											|             Child Task               |
	 *		 											|______________________________________|   
	 * 
	 */
	
	
	public class DependencyRenderer extends UIComponent implements IDataRenderer, IListItemRenderer
	{
		private var _data : Object = null;				
		private var _graphics : Graphics;
		
		private var _x : int = 0;
		private var _y : int = 0;
		private var _width : int = 0;
		private var _height : int = 0;
		
    	//las variables xOffset y yOffset son usadas para centrar las lineas sino quedarian todas contra los bordes, 
    	//y tambien se usa para hacer formar la curva que queda en algunos casos(cuando pega la vuelta por atras)
    	private static var X_OFFSET : int = 5;
    	private static var Y_OFFSET : int = 5;
    	//es el top de la grilla que se suma a todas las medidas y de las lineas
    	private var headerHeight : int = 20;
	    
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
			_graphics.lineStyle(1, 0x000000, 1);
			
			if ( _data != null)
			{
				draw(Task(_data));
			}
			_graphics.endFill();
		}
		
		private function draw(task : Task) : void
		{
			var scale : Number = this.parentApplication.mainView.barChart.getScale();
			
			//me indica el numero de renglon multiplicado por un ROW_HEIGHT (posicion y)
			var row : int = -5;// task.position * ROW_HEIGHT;//row * ROW_HEIGHT;
			for(var j : int = 0; j < task.dependencies.length; j++)
    		{
    			_x = 0;
    			_y = 0;
				_width = 0;
				_height = 0;
			
    			var dependency : Dependency = Dependency(task.dependencies.getItemAt(j));
    			
    			
    			if(dependency.task != null)
    			{
    				dependency.task = Task(Components.instance.tasks.getTask(dependency.task.id));
    				var startValueReduce : int = 0;
    				
	    			
					if(dependency.task != null)
    				{
   					startValueReduce = this.parentApplication.mainView.barChart.startValueReduce(dependency.task.startDate.date);
		    		if(UiTask(dependency.task).isVisible())
		    		{
		    			var sumWidth : int = 0;
		    			var sumHeight : int = 0;
		    			var sumX : int = 0;
		    			var sumY : int = 0;
		    			if(task.isMilestone)
		    			{
		    				sumWidth = 0.5 * scale;
		    			}
		    			else if(dependency.task.isMilestone)
		    			{
		    				sumX = 0.5 * scale;
		    				sumY = 10;
		    			}
		    			
		    			
			    		//dentro de este switch se calculan las variables(x,y,width,height)
			    		//para luego llamar a las funciones que dibujan las lineas y pasarles estos parametros
			    		switch (dependency.lagType)
						{
							case Dependency.SS:
							case Dependency.SF:
								//si la tarea hija esta por de bajo de la padre
								if(dependency.lineHeight(task)>0)
								{
					    			_x = ((dependency.lineX() + startValueReduce) * scale) - X_OFFSET;
					    			
					    			
					    			if(dependency.lagType == Dependency.SF)
					    			{
					    				_width = (dependency.lineWidth(task) * scale) + _x;
					    			}
					    			else if(dependency.lagType == Dependency.SS)
					    			{
					    				_width = (dependency.lineWidth(task) * scale) + _x + (X_OFFSET * 2);
					    			}
					    			
					    			_y = row - (dependency.lineHeight(task) * UI.ROW_HEIGHT) + headerHeight + 2;
					    			_height = (dependency.lineHeight(task) * UI.ROW_HEIGHT) + _y - headerHeight;
		
									_width+=sumWidth;
					    			_x+=sumX;
					    			_y+=sumY;
					    			
									//dibuja la dependencia
					    			if(dependency.lineWidth(task) >= 0)
					    			{
					    				drawSXDownFordward();
					    			}
					    			else
					    			{
					    				drawSXDownBack();
					    			}
					 			}
					 			else//si la tarea padre esta por de bajo de la hija
					 			{
									_x = ((dependency.lineX() + startValueReduce) * scale);
									
									if(dependency.lagType == Dependency.SF)
					    			{
					    				_width = (dependency.lineWidth(task) * scale) + _x - X_OFFSET;
					    			}
					    			else if(dependency.lagType == Dependency.SS)
					    			{
					    				_width = (dependency.lineWidth(task) * scale) + _x + X_OFFSET;
					    			}
					    			
					    			_height = row + headerHeight + Y_OFFSET;
					    			_y = row + (dependency.lineHeight(task) * (-1) * UI.ROW_HEIGHT) + headerHeight - Y_OFFSET;
									
									_width+=sumWidth;
					    			_x+=sumX;
					    			_y+=sumY;
					    			
					    			//dibuja la dependencia
					    			if(dependency.lineWidth(task) >= 0)
					    			{
					    				//_y -= 4;//Corrige que la linea horizontal no quede pegada con la barra cuando pasa por arriba de esta
					    				drawSXUpFordward();
					    			}
					    			else
					    			{
					    				drawSXUpBack();
					    			}
					 			}
								break;
								
							case Dependency.FS:
							case Dependency.FF:
								//si la tarea hija esta por de bajo de la padre
								if(dependency.lineHeight(task)>0)
								{
									_x = ((dependency.lineX() + startValueReduce) * scale);
									
									if(dependency.lagType == Dependency.FS)
					    			{
					    				_width = (dependency.lineWidth(task) * scale) + _x + X_OFFSET;
					    			}
					    			else if(dependency.lagType == Dependency.FF)
					    			{
					    				_width = (dependency.lineWidth(task) * scale) + _x - X_OFFSET;
					    			}
					    			
					    			_y = row - (dependency.lineHeight(task) * UI.ROW_HEIGHT) + headerHeight - Y_OFFSET;
					    			_height = (dependency.lineHeight(task) * UI.ROW_HEIGHT) + _y - Y_OFFSET;
					    			
					    			_width+=sumWidth;
					    			_x+=sumX;
					    			_y+=sumY;
					    			
					    			//dibuja la dependencia
					    			if(dependency.lineWidth(task) > 0)
					    			{
					    				drawFXDownFordward();
					    			}
					    			else
					    			{
					    				//_y += 3;//Corrige que la linea horizontal no quede pegada con la barra cuando pasa por de bajo
					    				drawFXDownBack();
					    			}
					    		}
					 			else//si la tarea padre esta por de bajo de la hija
					 			{
					    			_x = ((dependency.lineX() + startValueReduce) * scale);
					    			
					    			if(dependency.lagType == Dependency.FF)
					    			{
					    				_width = (dependency.lineWidth(task) * scale) + _x;
					    			}
					    			else if(dependency.lagType == Dependency.FS)
					    			{
					    				_width = (dependency.lineWidth(task) * scale) + _x + (X_OFFSET * 2);
					    			}
					    			
					    			_height = row + headerHeight + Y_OFFSET;
					    			_y = row + (dependency.lineHeight(task) * (-1) * UI.ROW_HEIGHT);
									
									_width+=sumWidth;
					    			_x+=sumX;
					    			_y+=sumY;
					    			
									//dibuja la dependencia
					    			if(dependency.lineWidth(task) > 0)
					    			{
					    				drawFXUpFordward();
					    			}
					    			else
					    			{
					    				drawFXUpBack();
					    			}
					 			}
								break;
						}
		    		}
		    		}
		    	}
    		}
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
	     * Dibuja una flecha hacia abajo
	     */
		private function drawDownArrow(x : int, y : int) : void
		{
			var length : int = 3;
			movePoint(x - length, y - length);
			
			_graphics.beginFill(0x000000);
			
			drawPoint(x - length, y - length);
			drawPoint(x, y);
			drawPoint(x + length + 1, y - length);
			drawPoint(x - length, y - length);
			
			_graphics.endFill();
		}
		/*
	     * Dibuja una flecha hacia arriba
	     */
		private function drawUpArrow(x : int, y : int) : void
		{
			var length : int = 3;
			movePoint(x - length, y + length);
			
			_graphics.beginFill(0x000000);
			
			drawPoint(x - length, y + length);
			drawPoint(x, y);
			drawPoint(x + length + 1, y + length);
			drawPoint(x - length, y + length);
			
			_graphics.endFill();
		}
	    /*
	     * Dibuja una linea de SS o SF
	     * Es usada solo para el caso que la flecha va de arriba hacia abajo y adelante
	     */
	    private function drawSXDownFordward () : void
	    {
	    	movePoint(_x + X_OFFSET, _y - Y_OFFSET);
	    	drawHorizontalLine(_y - Y_OFFSET, _x + X_OFFSET, _x);//draw A
	    	//B es creado automaticamente al unirse las verticales A y C
	    	drawHorizontalLine(_height, _x, _width);//draw C
	    	
	    	drawVerticalLine(_width, _height, _height + Y_OFFSET);//draw D
	    	drawDownArrow(_width, _height + Y_OFFSET);
	    	//drawVerticalLine(_width, _height, _height + (Y_OFFSET/2));//draw D
	    	//drawDownArrow(_width, _height + (Y_OFFSET/2));
	    }
	    /*
	     * Dibuja una linea de SS o SF
	     * Es usada solo para el caso que la flecha va de arriba hacia abajo y atras
	     */
	    private function drawSXDownBack () : void
	    {
	    	movePoint(_x + X_OFFSET, _y - Y_OFFSET);
	    	drawHorizontalLine(_y - Y_OFFSET, _x + X_OFFSET, _width);//draw C
	    	drawVerticalLine(_width, _y - Y_OFFSET, _height + Y_OFFSET);//draw D
	    	drawDownArrow(_width, _height + Y_OFFSET);
	    }
	    /*
	     * Dibuja una linea de SS o SF
	     * Es usada solo para el caso que la flecha va de abajo hacia arriba y atras
	     */
//---	     
	    private function drawSXUpBack () : void
	    {
	    	movePoint(_width, _height + Y_OFFSET);
	    	drawVerticalLine(_width, _height + Y_OFFSET, _y + (Y_OFFSET / 2));//draw D
	    	drawHorizontalLine(_y + (Y_OFFSET / 2), _width, _x);//draw C
	    	drawUpArrow(_width, _height + Y_OFFSET);
	    }
	    
	    /*
	     * Dibuja una linea de SS o SF
	     * Es usada solo para el caso que la flecha va de abajo hacia arriba adelante
	     */
//---	     
	    private function drawSXUpFordward () : void
	    {
	    	movePoint(_width, _height + Y_OFFSET);
	    	drawVerticalLine(_width, _height + Y_OFFSET, _y - (Y_OFFSET * 2));//draw D
	    	drawHorizontalLine(_y - (Y_OFFSET * 2), _width, _x - X_OFFSET);//draw C
	    	drawVerticalLine(_x - X_OFFSET, _y, _y + (Y_OFFSET / 2));//draw B
	    	drawHorizontalLine(_y + (Y_OFFSET / 2), _x - X_OFFSET, _x);//draw A
	    	drawUpArrow(_width, _height + Y_OFFSET);
	    }
	    /*
	     * Dibuja una linea de FS o FF
	     * Es usada solo para el caso que la flecha va de abajo hacia arriba y atras
	     */
//--	     
	    private function drawFXUpBack () : void
	    {
	    	movePoint(_x, _y + (Y_OFFSET * 3) + (Y_OFFSET / 2));
	    	drawHorizontalLine(_y + (Y_OFFSET * 3) + (Y_OFFSET / 2), _x, _x + X_OFFSET);//draw A
	    	//B es creado automaticamente al unirse las verticales A y C
	    	drawHorizontalLine(_y + Y_OFFSET, _x + X_OFFSET, _width - X_OFFSET);//draw C
	    	drawVerticalLine(_width - X_OFFSET, _y + Y_OFFSET, _height + Y_OFFSET);//draw D
	    	drawUpArrow(_width - X_OFFSET, _height + Y_OFFSET);
	    }
	    /*
	     * Dibuja una linea de FS o FF
	     * Es usada solo para el caso que la flecha va de abajo hacia arriba y adelante
	     */
//--	     
	    private function drawFXUpFordward () : void
	    {
	    	movePoint(_x, _y + (Y_OFFSET * 3) + (Y_OFFSET / 2));
	    	drawHorizontalLine(_y + (Y_OFFSET * 3) + (Y_OFFSET / 2), _x, _width - X_OFFSET);//draw C
	    	drawVerticalLine(_width - X_OFFSET, _y + (Y_OFFSET * 3) + (Y_OFFSET / 2), _height + Y_OFFSET);//draw D
	    	drawUpArrow(_width - X_OFFSET, _height + Y_OFFSET);
	    }
	    /*
	     * Dibuja una linea de FS o FF
	     * Es usada solo para el caso que la flecha va de arriba hacia abajo y hacia adelante
	     */
	    private function drawFXDownFordward () : void
	    {
	    	movePoint(_x, _y);
	    	drawHorizontalLine(_y, _x, _width);//draw C
	    	drawVerticalLine(_width, _y, _height - Y_OFFSET);//draw D  
	    	drawDownArrow(_width, _height - Y_OFFSET);
	    }
	    /*
	     * Dibuja una linea de FS o FF
	     * Es usada solo para el caso que la flecha va de arriba hacia abajo y hacia atras
	     */
	    private function drawFXDownBack () : void
	    {
	    	movePoint(_x, _y + (Y_OFFSET / 2));
	    	drawHorizontalLine(_y + (Y_OFFSET / 2), _x, _x + X_OFFSET);//draw A
	    	//B es creado automaticamente al unirse las verticales A y C
	    	drawHorizontalLine(_y + (Y_OFFSET * 3), _x + X_OFFSET, _width);//draw C
	    	drawVerticalLine(_width, _y + (Y_OFFSET * 3), _height - Y_OFFSET);//draw D
	    	drawDownArrow(_width, _height - Y_OFFSET);
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
	    
	   	private function print() : void
	    {
	    	//trace('x: '+_x);
	    	//trace('width: '+_width);
	    	//trace('y: '+_y);
	    	//trace('height: '+_height);
	    }

	}
}