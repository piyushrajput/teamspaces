package com.salesforce.gantt.controller
{
	import com.salesforce.gantt.model.User;
	import mx.collections.ArrayCollection;
	
	public class Users implements IUsers
	
	{
	    					
		[Bindable]
		public var users : ArrayCollection = new ArrayCollection();
		
		/*
		 * Constructor
		 */
		public function Users() : void
		{
			
		}
		/**
		 * Busca un usuario por id y lo retorna
		 */
		public function getUser(id : String) : User
		{
			var user : User;
			for(var i : int = 0; i < users.length; i++)
			{
				var idUser : String = User(users.getItemAt(i)).id;
				if(idUser.substr(0,id.length)==id)
				{
					user = User(users.getItemAt(i));
					break;
				}
			}
			return user;
		}
		
	}
}