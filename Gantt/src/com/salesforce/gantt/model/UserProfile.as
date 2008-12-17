package com.salesforce.gantt.model
{
	[Bindable]
	public class UserProfile
	{
			
		// Vars 		
		public var id : String;
		public var team : String;
		public var ownerId : String;
		
		// Booleans 
		public var canCreate : Boolean = false;
		public var canManage : Boolean = false;
		public var canComment : Boolean = false;
		public var canView : Boolean = false;
				
		
		// Constructor
		public function UserProfile(canCreateParam : Boolean, canManageParam : Boolean)
		{
			this.id = id;
			this.canCreate = canCreateParam; 	
			this.canManage = canManageParam; 
		}

	}
}