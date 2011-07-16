package com.acm
{
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import spark.components.supportClasses.DropDownController;
	
	public class DropController extends DropDownController
	{
		public function DropController()
		{
			super();
		}
		
		override public function processKeyDown(event:KeyboardEvent):Boolean
		{
			if (event.isDefaultPrevented())
				return true;
			
			if (event.ctrlKey && event.keyCode == Keyboard.DOWN)
			{
				openDropDown();
				event.preventDefault();
			}
			else if (event.ctrlKey && event.keyCode == Keyboard.UP)
			{
				closeDropDown(true);
				event.preventDefault();
			}    
			else if (event.keyCode == Keyboard.ENTER)
			{
				// Close the dropDown and eat the event if appropriate.
				event.preventDefault();
			}
			else if (event.keyCode == Keyboard.ESCAPE)
			{
				// Close the dropDown and eat the event if appropriate.
				if (isOpen)
				{
					closeDropDown(false);
					event.preventDefault();
				}
			}
			else
			{
				return false;
			}   
			
			return true;        
		}
	}
}