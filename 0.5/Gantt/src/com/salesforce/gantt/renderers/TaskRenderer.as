package  com.salesforce.gantt.renderers
{	
	import com.salesforce.gantt.model.Task;
	import com.salesforce.gantt.model.UiTask;
	import com.salesforce.gantt.model.UI;
	import com.salesforce.gantt.controller.Components;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.IDataRenderer;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.utils.GraphicsUtil;
	import flash.events.MouseEvent;
	import mx.collections.ArrayCollection;
	import flash.text.TextFormat;
	import mx.states.SetStyle;
	import mx.controls.Label;
	import flash.ui.Mouse;
	import mx.collections.IViewCursor;
	import mx.managers.CursorManager;
	
	import com.salesforce.gantt.model.Dependency;
	import mx.rpc.events.AbstractEvent;
	import com.salesforce.gantt.controller.Constants;
		
	
        
	[Event(name="dataChange", type="mx.events.FlexEvent")]
	
	public class TaskRenderer extends UIComponent implements IDataRenderer, IListItemRenderer
	{
		private var moveSelect : String = '';
		private var _data : Object = null;
		private var scale : Number = 0;
		
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
			
			height -= 2;
			
			if ( _data != null)
			{
				var uiTask : UiTask = UiTask(_data);
				var task : Task = Task(_data);
				
				var _graphics : Graphics = graphics;
				_graphics.clear();
				
				if(task.id!='')
				{
				//	if(uiTask.isDeleted || this.parentApplication.mainView.barChart.isReDrawed(task))
				//	{
				//		clearChildrenOfTaskDeleted(task);//borra los sprite de la tarea uqe fue borrada
				//	}
				
					//si la tarea debe ser dibujada dibujada
					if(!uiTask.isHidden)//this.parentApplication.mainView.barChart.isReDrawed(task) && this.parentApplication.mainView.barChart.taskDeleted==null && !uiTask.isHidden)
					{
				//		this.parentApplication.mainView.barChart.addRedrawed(task);
						
						if(task.position==1)
						{
							clearChildren();//borra todos
						}
						
						if(!parentApplication.mainView.barChart.hasDeleteLastTask)
						{
							scale = this.parentApplication.mainView.barChart.getScale();
							
					//		if(this.parentApplication.mainView.barChart.redrawAll)
					//		{
					//			clearChildren(height, task);//borra todos
					//		}
							
							var taskRectangle : Rectangle = null;
							var completedRectangle : Rectangle = null;
							if(uiTask.duration == 0)//milestone
							{
								taskRectangle = getTaskRectangle(height, task);
								
								var size : int = 12;
								//var hypotenuse : Number = Math.sqrt((size * size) * 2);//pitagorian theoreen
								var hypotenuse : Number = size * 2;	
								var x : Number = taskRectangle.x + (scale / 2) - (hypotenuse / 2);
								
								
								if(uiTask.alphaCut==1)
								{
									_graphics.beginFill(Constants.COLOR_TASK_MILESTONE_CUT_FONT, 1);
								}
								else
								{
									_graphics.beginFill(Constants.COLOR_TASK_MILESTONE_FONT, 1);
								}
								_graphics.moveTo(x + size, taskRectangle.y);
								_graphics.lineTo(x + size, taskRectangle.y);
								_graphics.lineTo(x, taskRectangle.y + size);
								_graphics.lineTo(x + size, taskRectangle.y + (size * 2));
								_graphics.lineTo(x + (size * 2), taskRectangle.y + size);
								
								_graphics.endFill();
								
								
								
								var y : int = taskRectangle.y;
								_graphics.lineStyle(2, Constants.COLOR_TASK_MILESTONE_BORDER_RIGHT, 1);
								_graphics.moveTo(x + size, y);
								_graphics.lineTo(x + size, y);
								_graphics.lineStyle(2, Constants.COLOR_TASK_MILESTONE_BORDER_LEFT, 1);
								_graphics.lineTo(x, y + size);
								_graphics.lineTo(x + size, y + (size * 2));
								_graphics.lineStyle(2, Constants.COLOR_TASK_MILESTONE_BORDER_RIGHT, 1);
								_graphics.lineTo(x + (size * 2), y + size);
								_graphics.lineTo(x + size, y);
								
								var label : Sprite = getLabel(task, taskRectangle, null);
								parent.addChild(label);
								
							}
							else if(!uiTask.isEditable())
							{
								taskRectangle = getTaskRectangle(height, task);
								completedRectangle = getCompletedRectangle(height, task);
								
								var heightReduce : int = 4;
								var triangle : int = 19;
								var cut : int = 5;
								if(this.parentApplication.mainView.barChart.hasPrinting)
								{
									cut = 3;
									triangle = height + 2;
								}
								
								taskRectangle.height -= heightReduce;
								
								if(uiTask.alphaCut==1)
								{
									_graphics.beginFill(Constants.COLOR_TASK_PARENT_INCOMPLETED_CUT_FONT, 1);
								}
								else
								{
									_graphics.beginFill(Constants.COLOR_TASK_PARENT_INCOMPLETED_FONT, 1);
								}
								if(task.completed > 0)
								{
									if(uiTask.alphaCut==1)
									{
										_graphics.beginFill(Constants.COLOR_TASK_PARENT_COMPLETED_CUT_FONT, 1);
									}
									else
									{
										_graphics.beginFill(Constants.COLOR_TASK_PARENT_COMPLETED_FONT, 1);
									}
								}
								_graphics.moveTo(taskRectangle.x-triangle,taskRectangle.y);
								_graphics.lineTo(taskRectangle.x-triangle,taskRectangle.y);
								_graphics.lineTo(taskRectangle.x+triangle,taskRectangle.y);
								_graphics.lineTo(taskRectangle.x,taskRectangle.y+triangle+5);
								
								if(task.completed < 100)
								{
									if(uiTask.alphaCut==1)
									{
										_graphics.beginFill(Constants.COLOR_TASK_PARENT_INCOMPLETED_CUT_FONT, 1);
									}
									else
									{
										_graphics.beginFill(Constants.COLOR_TASK_PARENT_INCOMPLETED_FONT, 1);
									}
								}
								_graphics.moveTo(taskRectangle.width+taskRectangle.x-triangle,taskRectangle.y);
								_graphics.lineTo(taskRectangle.width+taskRectangle.x-triangle,taskRectangle.y);
								_graphics.lineTo(taskRectangle.width+taskRectangle.x+triangle,taskRectangle.y);
								_graphics.lineTo(taskRectangle.width+taskRectangle.x,taskRectangle.y+triangle+5);
								
								if(uiTask.alphaCut==1)
								{
									_graphics.beginFill(Constants.COLOR_TASK_PARENT_INCOMPLETED_CUT_FONT, 1);
								}
								else
								{
									_graphics.beginFill(Constants.COLOR_TASK_PARENT_INCOMPLETED_FONT, 1);
								}
								var taskX : int = taskRectangle.x + cut;
								var taskWidth : int = taskRectangle.width - (cut * 2);
								if(taskWidth >= 0)
								{
									GraphicsUtil.drawRoundRectComplex(_graphics, taskX, taskRectangle.y, taskWidth, taskRectangle.height, 0, 0, 0, 0);
								}
								if(task.completed > 0 )
								{
									if(uiTask.alphaCut==1)
									{
										_graphics.beginFill(Constants.COLOR_TASK_PARENT_INCOMPLETED_CUT_FONT, 1);
									}
									else
									{
										_graphics.beginFill(Constants.COLOR_TASK_PARENT_COMPLETED_FONT, 1);
									}
									
									completedRectangle.height -= heightReduce;
									
									taskX = completedRectangle.x + cut;
									taskWidth = completedRectangle.width - (cut * 2);
									if(taskWidth < 0)
									{
										taskWidth = completedRectangle.width;
									}
									GraphicsUtil.drawRoundRectComplex(_graphics, taskX, completedRectangle.y, taskWidth, completedRectangle.height, 0, 0, 0, 0);
								}
								parent.addChild(getLabel(task, taskRectangle, completedRectangle));
							}
							else
							{
								taskRectangle = getTaskRectangle(height, task);
								completedRectangle = getCompletedRectangle(height, task);
								
								if(uiTask.alphaCut==1)
								{
									_graphics.beginFill(Constants.COLOR_TASK_NORMAL_INCOMPLETED_CUT_FONT, .4);
								}
								else
								{
									_graphics.beginFill(Constants.COLOR_TASK_NORMAL_COMPLETED_FONT, .4);
								}
								GraphicsUtil.drawRoundRectComplex(_graphics, taskRectangle.x, taskRectangle.y, taskRectangle.width, taskRectangle.height, 3, 3, 3, 3);
								if(uiTask.alphaCut==1)
								{
									_graphics.beginFill(Constants.COLOR_TASK_NORMAL_COMPLETED_CUT_FONT, 1);
								}
								else
								{
									_graphics.beginFill(Constants.COLOR_TASK_NORMAL_COMPLETED_FONT, 1);
								}
								if(task.completed < 100)
								{
									GraphicsUtil.drawRoundRectComplex(_graphics, completedRectangle.x, completedRectangle.y, completedRectangle.width, completedRectangle.height, 3, 0, 3, 0);
								}
								else
								{
									GraphicsUtil.drawRoundRectComplex(_graphics, completedRectangle.x, completedRectangle.y, completedRectangle.width, completedRectangle.height, 3, 3, 3, 3);
								}
								
								parent.addChild(getLabel(task, taskRectangle, completedRectangle));
							}
						}
					}
				}
			}
		}
		/**
   		 * Retorna un rectangulo que reprecenta una tarea en el gantt
   		 */
		private function getTaskRectangle(height : Number, task : Task) : Rectangle
		{
			var width : Number = 0;
			//var scale : int = this.parentApplication.mainView.barChart.getScale();
			if(task.duration == 0)
			{
				width = (1 * scale);
				if(width < 200)
				{
					width = 200;
				}
			}
			else
			{
				var durationT : Number = (task.duration+1);
				width = (durationT * scale);
			}
			return getRectangle(width, height, task);
		}
		/**
   		 * Retorna un rectangulo que reprecenta el porcentaje de completado de una tarea en el gantt
   		 */
		private function getCompletedRectangle(height : Number, task : Task) : Rectangle
		{
			//var scale : int = this.parentApplication.mainView.barChart.getScale();
			var durationT : Number = (task.duration+1);
			var width : Number = ((durationT * task.completed/100) * scale);
			
			return getRectangle(width, height, task);
		}
		/**
   		 * Retorna un rectangulo
   		 */
		private function getRectangle(width : Number, height : Number, task : Task) : Rectangle
		{
			var startValueReduce : int = this.parentApplication.mainView.barChart.startValueReduce(task.startDate.date);
			//var scale : int = this.parentApplication.mainView.barChart.getScale();
			var x : int = (((task.startDate.toDay() + startValueReduce) * scale)) + UI.MARGIN;
			var y : int = 2;	
			height = height - 4;
			return new Rectangle(x, y, width, height);
		}
		/**
   		 * Retorna una Label(con formato y eventos asignados) que contiene una barra en el gantt
   		 */
		private function getLabel(task : Task, taskRectangle : Rectangle, completedRectangle : Rectangle = null) : Sprite
		{	
			var id : String = task.id;
			//trace (task.id);
			var text : String = task.name;
			var completed : String = task.completed.toString()+'%';
			
			var x : int = taskRectangle.x;
			var y : int = (task.positionVisible * 30) - 30;//taskRectangle.y;
			var width : int = taskRectangle.width;
			var height : int = 25;
			
			var labelSprite : Sprite = new Sprite();
			labelSprite.name = 'BarSprite'+id;
			//labelSprite.opaqueBackground = 0xeeeeee;
			
			var textFormat : TextFormat = new TextFormat();
			textFormat.font = "verdana";
			if(task.duration != 0)
			{
				textFormat.color = 0xffffff;
			}
			else
			{
				if(UiTask(task).alphaCut==1)
				{
					textFormat.color = 0xaaaaaa;
				}
				else
				{
					textFormat.color = 0x000000;
				}
			}
			textFormat.bold = "bold";
			textFormat.size = 11;
			
			var textFieldName : TextField = new TextField();
			textFieldName.name = id; 
			textFieldName.text = text;
			textFieldName.selectable = false;
			if(task.duration != 0)
			{
				textFieldName.width = width;
				textFieldName.x = x;
			}
			else
			{
				//var scale : int = this.parentApplication.mainView.barChart.getScale();
				textFieldName.width = width;
				textFieldName.x = x;// + (scale / 2) + 12;
				var nbps : String = '';
				var nbpsScale : int = scale / 8;
				for(var i : int = 0; i < nbpsScale; i++)
				{
					nbps += ' ';
				}
				textFieldName.text = '    '+nbps+text;
			}
			textFieldName.setTextFormat(textFormat,-1,-1);
			textFieldName.y = y + 5;
			
			textFieldName.doubleClickEnabled = true;
			textFieldName.addEventListener(MouseEvent.DOUBLE_CLICK, doubleClick);
			labelSprite.addChild(textFieldName);
			
			
			if(completedRectangle != null && task.name!='')
			{
				var textFormatCompleted : TextFormat = new TextFormat();
				textFormatCompleted.font = "verdana";
				if(UiTask(task).alphaCut==1)
				{
					textFormatCompleted.color = 0xaaaaaa;
				}
				else
				{
					if(UiTask(task).isEditable())
					{
						// old color: 0xff0000
						textFormatCompleted.color = 0x5398AD;
					}
					else
					{
						textFormatCompleted.color = 0x77b900;
					}
				}
				textFormatCompleted.size = 9;
				textFormatCompleted.bold = "bold";
				
				var textFieldCompleted : TextField = new TextField();
				textFieldCompleted.text = completed;
				textFieldCompleted.name = id;
				textFieldCompleted.width = 30;
				textFieldCompleted.setTextFormat(textFormatCompleted,-1,-1);
				textFieldCompleted.x = x + completedRectangle.width - 5;
				textFieldCompleted.y = y + 20;
				textFieldCompleted.selectable = false;
				labelSprite.addChild(textFieldCompleted);
			}
			labelSprite.addEventListener(MouseEvent.CLICK, clickBar);
			if(parentApplication.mainView.barChart.daysFilter()!='year')
			{
				labelSprite.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
				//labelSprite.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
				labelSprite.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
				labelSprite.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			}
			return labelSprite;
		}
		/**
		 * Evento doble click de una barra en el gantt
		 */
		private function doubleClick(event : MouseEvent) : void
		{
			if(this.parentApplication.mainView.barChart.mouseIsOverTask(Task(Components.instance.tasks.getTask(event.target.name)), event, 'y'))
	    	{
	    		if(this.parentApplication.mainView.userProfilePermissions.canManage){
	    			this.parentApplication.mainView.editTaskOverlay();
	    		}
	    	}
		}
		/**
		 * Evento click de una barra en el gantt
		 */
		private function clickBar(event : MouseEvent) : void
		{
			if(this.parentApplication.mainView.barChart.mouseIsOverTask(Task(Components.instance.tasks.getTask(event.target.name)), event, 'y'))
	    	{
				this.parentApplication.mainView.barChart.selectTask(event.currentTarget.name.toString().substr(9,18));
				parentApplication.mainView.barChart.taskIdClicked = '';
	    	}
		}
		/*
		 * Se usa para crear o borrar una dependencia mediante el drag and drop 
		 */
		/*private function mouseUp(event : MouseEvent) : void
		{
			var taskIdChild : String = parentApplication.mainView.barChart.taskIdClicked;
			var taskIdParent : String = '';//event.target.name;
			
			var name : String = 'name'+taskIdChild;
			
			//var positionTask : int = Math.round((event.stageY - this.parentApplication.mainView.barChart.barChartCanvas.y - 30) / UI.ROW_HEIGHT);
			var positionTask : int = Math.round((Sprite(this.parentApplication.mainView.barChart.bars.getChildByName(name)).y - this.parentApplication.mainView.barChart.barChartCanvas.y - 30) / UI.ROW_HEIGHT);
			
			if(positionTask - 1 > -1 && positionTask - 1 < Components.instance.tasks.allTasks.length)
			{
				parentTask = Task(Components.instance.tasks.allTasks.getItemAt(positionTask - 1));
				taskIdParent = parentTask.id;
			}
			if(taskIdChild != '' && taskIdParent != '' && (taskIdChild != taskIdParent))
			{
				var parentTask : Task = Components.instance.tasks.getTask(taskIdParent);
				var childTask : Task = Components.instance.tasks.getTask(taskIdChild);
				//si el raton esta por encima (area exacta) de la tarea.
				if(this.parentApplication.mainView.barChart.mouseIsOverTask(parentTask, event))
				{
					if(!childTask.isParent(parentTask))
					{
						if(Components.instance.dependencies.validateDependency(parentTask, childTask))
						{
							//se crea una dependencia
							var dependency : Dependency = new Dependency(parentTask, 2, 0, 1);
							Components.instance.controller.addDependency(dependency, childTask);
							for(var i : int = 0 ; i<Components.instance.tasks.allTasks.length; i++)
							{
								var t : Task = Task(Components.instance.tasks.allTasks.getItemAt(i));
							}
							parentApplication.mainView.filter();
							this.parentApplication.mainView.barChart.selectTask(childTask.id);
						}
					}
					else
					{
						//se borra una dependencia
						var dependency : Dependency = Components.instance.dependencies.getDependency(parentTask, childTask);
						Components.instance.controller.deleteDependency(dependency,Components.instance.tasks.selectedTask);
					}
				}
			}
		}*/
		/*
		 * Llamada cuando se va el cursor de encima de la tarea
		 */
		private function mouseOut(event : MouseEvent) : void
		{
			this.parentApplication.mainView.statusTaskPreview(null, 0, 0, false);
			if(!this.parentApplication.mainView.barChart.isDraging)
			{
				this.parentApplication.mainView.barChart.setCursor('cursorHandUp');
			}
		}
		/*
		 * Llamada cuando se pone el cursor de encima de la tarea para cambiar el raton
		 */
		private function mouseMove(event : MouseEvent) : void
		{	    
			var cursorNone : Boolean = true;
			if(!this.parentApplication.mainView.barChart.isDraging)
			{
				var task : Task = Components.instance.tasks.getTask(event.currentTarget.name.toString().substr(9,18));
				if(task != null)
				{
					//add 1 day for the duration to display task correctly 
					var duration : int = (task.duration + 1);

					//var scale : int = this.parentApplication.mainView.barChart.getScale();
					var taskWidth : int = duration * scale;
					var taskX : int = (task.startDate.toDay() * scale) + this.parentApplication.mainView.barChart.barChartCanvas.x;
					var taskY : int = (task.positionVisible * UI.ROW_HEIGHT) + 30 + (this.parentApplication.mainView.barChart.barChartCanvas.y);
					var taskHeight : int = UI.ROW_HEIGHT;
					
					//si el raton esta sobre la tarea
					if( ((event.stageX - 10) > taskX) && ((event.stageX - 10) <= (taskX + taskWidth)) && 
						( event.stageY > taskY ) && ( event.stageY < (taskY + taskHeight) ) )
					{
						if(UiTask(task).isEditable())
						{
							this.parentApplication.mainView.statusTaskPreview(task, event.stageX, taskY, true);
							if(task.duration!=0)
							{
								if(event.localX > 0 && event.localX <= 10)//start
								//if(event.localX < 0 && event.localX >= -10)//start
								{
									this.parentApplication.mainView.barChart.setCursor('cursorLeftUp');
									moveSelect = 'left';
									cursorNone = false;
								}
								else if(event.localX >= (taskWidth - 10) && event.localX <= taskWidth)//end
								{
									this.parentApplication.mainView.barChart.setCursor('cursorRightUp');
									moveSelect = 'right';
									cursorNone = false;
								}
								else if(event.localX > 10 && event.localX < (taskWidth - 10))//center
								{
									this.parentApplication.mainView.barChart.setCursor('cursorCenterUp');
									moveSelect = 'center';
									cursorNone = false;
								}
							}
							else
							{
								this.parentApplication.mainView.barChart.setCursor('cursorCenterUp');
								moveSelect = 'center';
								cursorNone = false;
							}
						}
					}
				}
			}
			if(cursorNone)
			{
				this.parentApplication.mainView.statusTaskPreview(null, 0, 0, false);
				moveSelect = '';
			}
		}
		/**
		 * Evento mouseDown de una barra en el gantt
		 */
		private function mouseDown(event : MouseEvent) : void 
		{
			var task : Task = Components.instance.tasks.getTask(event.currentTarget.name.toString().substr(9,18));
			if(task != null)
			{
				//si el raton esta sobre la tarea
				if(this.parentApplication.mainView.barChart.mouseIsOverTask(task, event, 'y'))
				{
					parentApplication.mainView.barChart.dragAndDropBar(event.currentTarget.name.toString().substr(9,18), moveSelect);
				}
				else
				{
					parentApplication.mainView.barChart.dragAndDropBar('', '');
				}		    	
			}
			else
			{
				parentApplication.mainView.barChart.dragAndDropBar('', '');
			}
		}
		
		
		/*private function clearChildrenOfTaskDeleted(taskDeleted : Task) : void
		{
			if(parent != null)
			{
				var child : int = parent.numChildren;
				for (var i : int = 0; i < child; i++)
				{	
					var task : Task = Task(Components.instance.tasks.getTask(parent.getChildAt(i).name));
					if(task != null)
					{
						if(taskDeleted.id==task.id)
						{
							parent.removeChildAt(i);
							child--; i--;
						}
					}
				}
			}
   		}*/
		/*
		 * Borra todos los child
		 */
		
		/**
		 * Borra los sprite objecct de la grilla cuyo nombre comience con BarSprite
		 */
		private function clearChildren() : void
		{
			if(parent != null)
			{
				var child : int = parent.numChildren;
				for (var i : int = 0; i < child; i++)
				{	
					if(parent.getChildAt(i).name.toString().substr(0,9)=='BarSprite')
					{
						var task : Task = Task(Components.instance.tasks.getTask(parent.getChildAt(i).name.toString().substr(9,18)));
						parent.removeChildAt(i);
						child--; i--;
					}
				}
			}
   		}
		/*private function clearChildren(height : int, taskDraw : Task) : void
		{
			var id : String = taskDraw.id;
			var position : int = taskDraw.position;
			//if((position - 1) == Components.instance.tasks.allTasks.length)
			//{
				if(parent != null)
				{
					var child : int = parent.numChildren;
					for (var i : int = 0; i < child; i++)
					{	
						var task : Task = Task(Components.instance.tasks.getTask(parent.getChildAt(i).name));
						if(task != null)
						{
							if(task.id == id || taskDraw.position==1)
							{
								parent.removeChildAt(i);
								child--; i--;
							}
						}
					}
				}
			//}
   		}*/
	}
}