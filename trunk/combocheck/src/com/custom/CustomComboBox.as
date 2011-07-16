package com.custom {
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import mx.core.ClassFactory;
	import mx.utils.StringUtil;
	
	import skins.CustomComboBoxSkin;
	
	import spark.components.ComboBox;
	import spark.components.List;
	
	public class CustomComboBox extends ComboBox {
		public function CustomComboBox() {
			super();
			
			// This skin enables the combobox to autosize depending on the width
			// of the combobox.
			super.setStyle("skinClass", CustomComboBoxSkin);
			
			addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown_EventHandler);
			addEventListener(KeyboardEvent.KEY_UP, onKeyUp_EventHandler);
		}
		
		// This whole function is a work in progress.
		// It's purpose is to fix the Adobe bug that won't let the first item
		// in comboboxes to be selected by keyboard.
		// See: http://bugs.adobe.com/jira/browse/SDK-26878
		// or
		// http://bugs.adobe.com/jira/browse/SDK-28900
		private function onKeyDown_EventHandler(event:KeyboardEvent):void {
			if(event.keyCode == Keyboard.DOWN && selectedIndex == -1) {
				//super.keyDownHandler(event);
				super.selectedIndex = 0;
				super.commitProperties();
				
				trace("selIdx: " + selectedIndex);
			}
			
			if (event.keyCode == Keyboard.UP && selectedIndex == 1) {
				//super.keyDownHandler(event);
				super.selectedIndex = 0;
				super.commitProperties();
				
				trace("selIdx: " + selectedIndex);
			}
		}
		
		// This fixes the Adobe bug where a space is inserted every time you press escape when the dropdown i open.
		private function onKeyUp_EventHandler(event:KeyboardEvent):void {
			if (event.keyCode == Keyboard.ESCAPE && !isDropDownOpen && StringUtil.trim(textInput.text).length == 0) {
				textInput.text = "";
				trace("escape: " + textInput.text.length.toString());
			}
		}
	}
}