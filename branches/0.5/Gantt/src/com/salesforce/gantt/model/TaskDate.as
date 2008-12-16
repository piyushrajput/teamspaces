package com.salesforce.gantt.model
{
	import mx.collections.ArrayCollection;
	import mx.utils.ObjectProxy;
	
	public class TaskDate  
	{
		//dateformater
		/** the start date of the first task **/
		public static var startDate : Date = new Date();
		/** the end date of the last task **/
		public static var endDate : Date = new Date();
		/** the start or end date of this task **/
		public var date : Date = new Date();

		/**
		 * Costructor: parses a String into a date object
		 * dateString is a String representation of a date
		 * duration is the duration of the task, 0 if this is a start date which is the default
		 * format is the format of the String representation of the date:
		 * 1. mm/dd/yyyy
	     * 2. mm/dd/yy
	     * 3. database (default) for example: 2007-06-15T16:37:00.000Z
		 */
		 				 
		public function TaskDate(dateString : String = '', duration : int = 0, format : String = "database")
		{
			if(dateString != '')
			{
				date = toDate(dateString, format);
				if(startDate == null)
				{
					startDate.setTime(date.getTime());
				}
				if(endDate == null)
				{
					endDate.setTime(date.getTime());
				}
				if(date.getTime() < startDate.getTime())
				{
					startDate.setTime(date.getTime());
				}
				var durationInMillis : Number = toMillis(duration);
				//trace(date +' '+ durationInMillis);
				if(date.getTime() + durationInMillis > endDate.getTime())
				{
					endDate.setTime(date.getTime() + durationInMillis); 
					//trace('--->'+endDate);
				}
				//if the duration is not 0 that means this is an end date
				if(duration != 0)
				{
					date.setTime(date.getTime() + durationInMillis);
				}
			}
		}
		
		/**
		 * Converts days to milliseconds
		 * days the number  of days to convert to millisecond
		 */
		 
		private function toMillis (days : Number) : Number
	    {
	    	return ( days * 1000 * 60 * 60 * 24 );
	    }
	    
	    /**
	    * Esta funcion donde es usada?
	    * Probaste TaskDate.startDate ?
	    * 
	    */
		private function min() : Date
		{
			return startDate;
		}
		
		/**
		 * formats the date object to a String 
		 * format is the format that the date will be returned as:
		 * 1. mm/dd/yyyy
	     * 2. mm/dd/yy
	     * 3. database (default) for example 2007-06-15T16:37:00.000Z
		 */
		 	     
	     public function toString (format : String = "database") : String
	     {
	     	var month : int = date.getMonth() + 1;
			var concatMonth : String = "";
			if(month<10)
			{
				concatMonth = "0";
			}
			var concatDay : String = "";
			if(date.getDate()<10)
			{
				concatDay = "0";
			}
			if(format == "mm/dd/yyyy")
	 	 	{
				return concatMonth + month.toString() + "/" + concatDay + date.getDate().toString() + "/" + date.getFullYear().toString();
	 	 	}
	 	 	else if(format == "mm/dd/yy")
	 	 	{
				return concatMonth + month.toString() + "/" + concatDay + date.getDate().toString() + "/" + date.getFullYear().toString().substr(2, 2);
	 	 	}
	 	 	else if(format == "database")
	 	 	{
				return date.getFullYear().toString()+"-"+concatMonth+month.toString()+"-"+concatDay+date.getDate().toString()+"T00:00:00.000Z";
	 	 	}
	  	    return '';	
	     } 
	     
	     
	     /**
	     * toDate parses a String into a Date 
	     * The possible formats are:
	     * 1. mm/dd/yyyy
	     * 2. mm/dd/yy
	     * 3. database (default) for example: 2007-06-15T16:37:00.000Z
	     * 
	     */ 
	     private function toDate (stringDate : String, format : String = "database") : Date
		 {
		 	var arrayDate : Array = new Array();
		 	if(format == "mm/dd/yyyy")
	 	 	{
				arrayDate = stringDate.split("/");
				return new Date(arrayDate[2], arrayDate[0]-1, arrayDate[1]);
	 	 	}
	 	 	else if(format == "mm/dd/yy")
	 	 	{
				arrayDate = stringDate.split("/");
				return new Date(arrayDate[2], arrayDate[0]-1, arrayDate[1]);
	 	 	}
	 	 	else if(format == "database")
	 	 	{
				var arrayMinDate : Array = stringDate.split(".");
				stringDate = arrayMinDate[0];
				arrayDate = stringDate.split("T");	
				var arrayYeayMonthDay : Array = arrayDate[0].split("-");
				//var arrayHourMinuteSecong : Array = arrayDate[1].split(":");
				return new Date(arrayYeayMonthDay[0], arrayYeayMonthDay[1]-1, arrayYeayMonthDay[2]);//, arrayHourMinuteSecong[0], arrayHourMinuteSecong[1], arrayHourMinuteSecong[2]);
	 	 	}
	 	 	return null;
	     }
	     
	     /**
	     * toDay returns the number of days from this date 
	     * to the start date of the first task in this schedule
	     */
	     public function toDay() : Number
	     {
	     	return Math.round( (date.getTime() - startDate.getTime() ) / 1000 / 60 / 60 / 24 );
	     }
	}
}