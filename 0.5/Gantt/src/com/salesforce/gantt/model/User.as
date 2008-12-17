package com.salesforce.gantt.model
{
	[Bindable]
	public class User
	{
		public var id : String = '';
		public var name : String = '';
		public var idAuthenticate : String = '';
		
	//	public var email : String = 'marquinio@gmail.com';
		//public var password : String = 'p@ss4141';
	//	public var password : String = 'passw0rd';
		
		//public var email : String = 'dev2@gmail.com';
		//public var password : String = 'fabritzio1';
		
		//public var email : String = 'ngunther@teamforce.com';
		//public var password : String = 'nico0107';
		
		public var email : String = 'bfagundez@teamforce.com';
		public var password : String = 'limp.565';
		
		function User(id : String = '')
		{
			if(id != '')
			{
				this.id = id;
			}
		}
	}
}