package com.salesforce.gantt.controller
{
	import com.salesforce.gantt.model.User;
	import mx.collections.ArrayCollection;
	
	public interface IUsers
	{
		function set users(resources : ArrayCollection) : void;
		function get users() : ArrayCollection;
		
		function getUser(id : String) : User;
	}
}