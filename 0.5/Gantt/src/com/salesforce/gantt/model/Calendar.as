package com.salesforce.gantt.model
{
	import com.salesforce.gantt.model.TaskDate;
	import mx.collections.ArrayCollection;
	import mx.formatters.DateFormatter;
	import mx.core.Application;
	import com.salesforce.gantt.controller.Constants;
	[Bindable]
	public class Calendar
	{
		//[Bindable]
		public var dates : Array = new Array();	
		
		public function Calendar () : void 
		{
		}
		/**
		 * Suma una cantidad de dias(dada como parametro), a una fecha dada
		 */
		public function add(date : Date, days : Number): Date 
		{
			return new Date(date.getTime() + days * 24 * 60 * 60 * 1000);
		}
		/**
		 * Suma una cantidad de horas(dada como parametro), a una fecha dada
		 */
		public function addHours(date : Date, hours : Number): Date 
		{
			return new Date(date.getTime() + hours * 60 * 60 * 1000);
		}
		/**
		 * Convierte una fecha a un valor, el cual multiplicado por la escala reprecenta la posicion left en el gantt
		 */
		 public function toDay(date : Date) : Number
	     {
	     	return Math.round( (date.getTime() - TaskDate.startDate.getTime() ) / 1000 / 60 / 60 / 24 );
	     }
	     /**
		 * Converts days to milliseconds
		 * days the number  of days to convert to millisecond
		 */
	     public function toMillis (days : Number) : Number
	     {
	    	return ( days * 1000 * 60 * 60 * 24 );
	     }
	     /**
		 * formats the date object to a String 
		 * format is the format that the date will be returned as:
		 * 1. mm/dd/yyyy
	     * 2. mm/dd/yy
	     * 3. database (default) for example 2007-06-15T16:37:00.000Z
		 */
		 	     
	     public function toString (date : Date, format : String = "database") : String
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
	     * Retorna true si la fecha es un fin de semana
	     */
	     public function isWeekend(date : Date) : Boolean
	     {
	     	return (date.getDay() == 0 || date.getDay() == 6);
	     }
	     /**
	     * Retorna true si la fecha es un primer dia de mes
	     */
	     public function isFirstDayOfTheMonth(date : Date) : Boolean
	     {
	     	var dateTemp : Date = add(date, -1);
	     	return (dateTemp.getMonth() != date.getMonth());
	     }
	}
}