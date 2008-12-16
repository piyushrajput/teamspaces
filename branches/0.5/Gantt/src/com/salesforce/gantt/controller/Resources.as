package com.salesforce.gantt.controller
{
	import com.salesforce.gantt.model.Resource;
	import com.salesforce.gantt.model.Task;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	public class Resources implements IResources
	{
		[Bindable]
		public var resources : ArrayCollection = new ArrayCollection();
		/*
		 * Constructor
		 */
		public function Resources() : void
		{
			Components.instance.salesforceService.ganttStateOperation.addEventListener(Components.instance.salesforceService.ganttStateOperation.ACTION, actionAuthenticateHandler);
		}
        /*
		 * Captura el evento luego de que se hace el login
		 */
        public function actionAuthenticateHandler(event : Event) : void 
		{
            Components.instance.salesforceService.resourceOperation.loadProyectResources(resources);
        }
		/*
		 * Recibe el id de un recurso lo busca y retorn el recurso
		 */
		public function getResource(resourceId : String) : Resource
		{
	     	var resource : Resource = null;
	     	for(var j : int = 0; j < this.resources.length; j++)
	     	{
	     		resource = Resource(this.resources.getItemAt(j));
	     		if(resource.id == resourceId)
	     		{
	     			return resource;
	     		} 
	     	}
	     	return null;
	    }
	    /**
	    * Retorna todos los resources que NO estan asignados a una tarea
	    */
	    public function getAvailabreResources(task : Task) : ArrayCollection
	    {
	    	var availableResources : ArrayCollection = new ArrayCollection();
	    	for(var i : int = 0; i < Components.instance.resources.resources.length ; i++)
	    	{
	    		var resource : Resource = Resource(Components.instance.resources.resources.getItemAt(i));
		    	
		    	availableResources.addItem(resource);
		    	/*
		    	 Commented to include a task resource name that are already assigned.
		    	if(!task.hasResource(resource))
		    	{
		    		availableResources.addItem(resource);
		    	}
		    	*/
	    	}
	    	return availableResources;
	    }
	}
}