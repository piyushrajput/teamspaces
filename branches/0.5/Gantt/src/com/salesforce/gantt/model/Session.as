package com.salesforce.gantt.model
{
	import com.salesforce.gantt.model.Schedule;
	public class Session
	{
		public var user : User = new User();
		public var schedule : Schedule = new Schedule();
		
		public function Session()
		{
		}
	}
}