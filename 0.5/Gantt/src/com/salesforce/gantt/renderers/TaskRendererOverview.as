package  com.salesforce.gantt.renderers
{	
	import com.salesforce.gantt.model.Task;
	import com.salesforce.gantt.model.UiTask;
	import com.salesforce.gantt.model.TaskDate;
	import com.salesforce.gantt.model.UI;
	import com.salesforce.gantt.controller.Components;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.IDataRenderer;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.utils.GraphicsUtil;
	import mx.collections.ArrayCollection;
	import com.salesforce.gantt.model.Dependency;
	import com.salesforce.gantt.controller.Constants;
		
	[Event(name="dataChange", type="mx.events.FlexEvent")]
	
	public class TaskRendererOverview extends UIComponent implements IDataRenderer, IListItemRenderer
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
			//if(height >= 0)
			//{
				super.updateDisplayList(width, height);
				//(altura / cant de tareas) - (el 25 %) 
				height = (150 / Components.instance.tasks.allTasks.length) - ((150 / Components.instance.tasks.allTasks.length)/4);
				
				if(height<0)
				{
					height = 1;
				}
				else if(height>14)
				{
					height = 14;
				}
				var _graphics : Graphics = graphics;		
				_graphics.clear();
				if ( _data != null)
				{
					var scale : Number = this.parentApplication.mainView.barChartOverview.getScaleOverview();
					var uiTask : UiTask = UiTask(_data);
					var task : Task = Task(_data);
	
					if(!uiTask.isHidden)
					{
						/*if(scale == 0)
						{
							scale = 1;
						}*/
						var taskRectangle : Rectangle = null;
						var completedRectangle : Rectangle = null;
						if(uiTask.duration == 0)//milestone
						{
							taskRectangle = getTaskRectangle(height, task);
							
							_graphics.beginFill(Constants.COLOR_TASK_MILESTONE_FONT, 1);
							
							var size : int = 1;
							if(height>1)
							{
								size = height / 2;
							}
							var hypotenuse : Number = size * 2;	
							var x : Number = taskRectangle.x + (scale / 2) - (hypotenuse / 2);
					
							_graphics.moveTo(x + size, taskRectangle.y);
							_graphics.lineTo(x + size, taskRectangle.y);
							_graphics.lineTo(x, taskRectangle.y + size);
							_graphics.lineTo(x + size, taskRectangle.y + (size * 2));
							_graphics.lineTo(x + (size * 2), taskRectangle.y + size);
						}
						else if(uiTask.imageSign() != -1)
						{
							var cut : int = 2;
							var triangle : int = height + 2;
							taskRectangle = getTaskRectangle(height, task);
							
							_graphics.beginFill(Constants.COLOR_TASK_PARENT_INCOMPLETED_FONT, 1);
							if(task.completed > 0)
							{
								_graphics.beginFill(Constants.COLOR_TASK_PARENT_COMPLETED_FONT, 1);
							}
							_graphics.moveTo(taskRectangle.x-triangle,taskRectangle.y);
							_graphics.lineTo(taskRectangle.x-triangle,taskRectangle.y);
							_graphics.lineTo(taskRectangle.x+triangle,taskRectangle.y);
							_graphics.lineTo(taskRectangle.x,taskRectangle.y+triangle);
							
							if(task.completed < 100)
							{
								_graphics.beginFill(Constants.COLOR_TASK_PARENT_INCOMPLETED_FONT, 1);
							}
							_graphics.moveTo(taskRectangle.width+taskRectangle.x-triangle,taskRectangle.y);
							_graphics.lineTo(taskRectangle.width+taskRectangle.x-triangle,taskRectangle.y);
							_graphics.lineTo(taskRectangle.width+taskRectangle.x+triangle,taskRectangle.y);
							_graphics.lineTo(taskRectangle.width+taskRectangle.x,taskRectangle.y+triangle);
							
							_graphics.beginFill(Constants.COLOR_TASK_PARENT_INCOMPLETED_FONT, 1);
							var taskX : int = taskRectangle.x + cut;
							var taskWidth : int = taskRectangle.width - (cut * 2);
							if(taskWidth >= 0)
							{
								GraphicsUtil.drawRoundRectComplex(_graphics, taskX, taskRectangle.y, taskWidth, taskRectangle.height, 0, 0, 0, 0);
							}
							if(task.completed > 0 )
							{
								_graphics.beginFill(Constants.COLOR_TASK_PARENT_COMPLETED_FONT, 1);
								completedRectangle = getCompletedRectangle(height, task);
								taskX = completedRectangle.x + cut;
								taskWidth = completedRectangle.width - (cut * 2);
								if(taskWidth < 0)
								{
									taskWidth = completedRectangle.width;
								}
								GraphicsUtil.drawRoundRectComplex(_graphics, taskX, completedRectangle.y, taskWidth, completedRectangle.height, 0, 0, 0, 0);
							}
						}
						else
						{
							_graphics.beginFill(Constants.COLOR_TASK_NORMAL_COMPLETED_FONT, .4);
							taskRectangle = getTaskRectangle(height, task);
							GraphicsUtil.drawRoundRectComplex(_graphics, taskRectangle.x, taskRectangle.y, taskRectangle.width, taskRectangle.height, 2, 2, 2, 2);
							_graphics.beginFill(Constants.COLOR_TASK_NORMAL_COMPLETED_FONT, 1);
							completedRectangle = getCompletedRectangle(height, task);
							GraphicsUtil.drawRoundRectComplex(_graphics, completedRectangle.x, completedRectangle.y, completedRectangle.width, completedRectangle.height, 0, 0, 0, 0);
						}
					}
				}
			//}
		}
		/**
		 * Retona un rectangulo que reprecenta la barra de una tarea en el overviewPane
		 */
		private function getTaskRectangle(height : Number, task : Task) : Rectangle
		{
			var scale : Number = this.parentApplication.mainView.barChartOverview.getScaleOverview();
			if(scale == 0)
			{
				scale = 1;
			}
			var width : Number = (task.duration * scale);
			return getRectangle(width, height, task);
		}
		/**
		 * Retona un rectangulo que reprecenta el porcentaje de completado de una tarea en el overviewPane
		 */
		private function getCompletedRectangle(height : Number, task : Task) : Rectangle
		{
			var scale : Number = this.parentApplication.mainView.barChartOverview.getScaleOverview();
			/*if(scale == 0)
			{
				scale = 1;
			}*/
			var width : Number = ((task.duration * task.completed/100) * scale);
			return getRectangle(width, height, task);
		}
		/**
		 * Retona un rectangulo
		 */
		private function getRectangle(width : Number, height : Number, task : Task) : Rectangle
		{
			var scale : Number = this.parentApplication.mainView.barChartOverview.getScaleOverview();
			if(scale == 0)
			{
				scale = 1;
			}
			//xCenter = (getStartOverview() * scale) + desfasaje;
			var x : Number = ((task.startDate.toDay() * scale)) + UI.MARGIN;
			var y : int = 0;	
			return new Rectangle(x, y, width, height);
		}
	}
}