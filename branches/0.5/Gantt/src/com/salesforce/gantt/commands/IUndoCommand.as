package com.salesforce.gantt.commands
{	
	public interface IUndoCommand extends ICommand
	{
		function undo () : void;
	}
}