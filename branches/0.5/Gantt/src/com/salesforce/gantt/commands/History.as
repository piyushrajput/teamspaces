package com.salesforce.gantt.commands
{
	import mx.collections.ArrayCollection;
	
	public class History
	{
		/** the array of commands in memory that could be undone **/
		private var commands : ArrayCollection = new ArrayCollection();
		/** the index in the array pointing to the last command **/
		private var count : int = 0;  
		
		/**
		 * Adds a new command to the array
		 */
		 
		public function addCommand( command : IUndoCommand ) : void
		{
			commands.addItem(command);
			count = commands.length - 1;
		}

		/**
		 * Undo the last command in the array
		 */		
		 
		public function undo() : void
		{
			if(count == commands.length - 1)
			{
				commands.getItemAt(count).undo();
				count --;
			}
		}
		
		/**
		 * Redo the last command in the array
		 * 
		 */
		 
		public function redo() : void
		{
			if(count + 1 == commands.length - 1)
			{
				count ++;
				commands.getItemAt(count).execute();
			}
		}
	}
}