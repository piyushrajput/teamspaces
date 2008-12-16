package com.salesforce.gantt.model
{
	public class Resource
	{
		public var id : String;
		public var name : String;
		/*
		 * Costructor
		 */	
		public function Resource(name : String, id : String = '')
		{
			this.id = id;
			this.name = name;
		}
		
		public function toString() : String
		{
			return this.name ;
		}		
	}
}