/*
 * ComboCheck
 * v1.4.1
 * Arcadio Carballares Martín, 2010
 * Göran Karlsson, 2010
 * http://www.carballares.es/arcadio
 * Creative Commons - http://creativecommons.org/licenses/by-sa/2.5/es/deed.en_GB
 */
package com.acm {
	import com.custom.CustomComboBox;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.collections.IList;
	import mx.core.ClassFactory;
	import mx.events.ItemClickEvent;
	
	import spark.components.CheckBox;
	import spark.components.ComboBox;
	import spark.events.DropDownEvent;
	
	[Event("addItem", type="flash.events.Event")]
	[Event("removeItem", type="flash.events.Event")]
	
	public class ComboCheck extends CustomComboBox {
		private var m_labelField:String = "label";
		private var m_selectedItems:Vector.<Object>;
		
		public function ComboCheck() {
			super();
			
			var render:ClassFactory = new ClassFactory(ComboCheckItemRenderer);
			super.itemRenderer = render;
			
			super.dropDownController = new DropController;
			
//			addEventListener(DropDownEvent.OPEN, onDropDownOpen);
			addEventListener(DropDownEvent.CLOSE, onDropDownClose);
			addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			addEventListener(ItemClickEvent.ITEM_CLICK, onItemClick);
			addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown_EventHandler);
		}
		
		[Bindable("change")]
		[Bindable("valueCommit")]
		[Bindable("collectionChange")]
		override public function set selectedItems(value:Vector.<Object>):void {
			m_selectedItems = value;
			
			for each (var obj:Object in value) {
				getItem(obj.label).assigned = true;
			}
		}
		
		override public function get selectedItems():Vector.<Object> {
			return m_selectedItems;
		}
		
		override public function set labelField(value:String):void {
			m_labelField = value;
		}
		
		override public function get labelField():String {
			return m_labelField;
		}
		
		override public function set dataProvider(value:IList):void {
			super.dataProvider = value;
			
			// Load initial selected items
			selectedItems = new Vector.<Object>;
			
			for (var i:int; i < dataProvider.length; i++) {
				if (dataProvider[i].assigned == true) {
					selectedItems.push(dataProvider[i]);
				}
			}
		}
		
		protected function onKeyDown_EventHandler(event:KeyboardEvent):void {
			if (event.keyCode == Keyboard.ENTER && isDropDownOpen && textInput.text.length > 0) {
				var currentItem:Object = getItem(textInput.text);
				
				if (currentItem != null) {
					currentItem.assigned = !currentItem.assigned;
					onCheck(currentItem);
					invalidateProperties();
				}
			}
//			// This Adobe bug is fixed in CustomComboBox (which we extend).
//			if (event.keyCode == Keyboard.ESCAPE && isDropDownOpen && textInput.text.length > 0) {
//				textInput.text = "";
//			}
		}
		
		protected function onItemClick(event:ItemClickEvent):void {
			onCheck(event.item);
		}
		
		protected function onDropDownClose(event:DropDownEvent):void {
			selectedIndex = -1;
			openButton.setFocus();
			selections(false);
		}
		
//		// This doesn't work. The idea was to clear the textInput every
//		// time we open the dropDown. But it also come with a lot of
//		// other side effects. For now it works pretty ok without this.
//		protected function onDropDownOpen(event:DropDownEvent):void {
//			selections();
//		}
		
		protected function textInput_ClickHandler(event:MouseEvent):void {
			selections(false);
			textInput.setFocus();
		}
		
		protected function onFocusIn(event:FocusEvent):void {
			selections();
		}
		
		protected function onFocusOut(event:FocusEvent):void {
			selections(false);
		}
		
		override protected function item_mouseDownHandler(event:MouseEvent):void {
			if (event.target is ComboCheckItemRenderer) {
				var render:ComboCheckItemRenderer = event.target as ComboCheckItemRenderer;
				var check:CheckBox = render.item as CheckBox;
				
				if (check.selected) {
					render.data.assigned = false;
					check.selected = false;
				}
				else {
					render.data.assigned = true;
					check.selected = true;
				}
				
				onCheck(render.data);
			}
		}
		
		override protected function commitProperties():void {
			super.commitProperties();
			
			var render:ClassFactory = new ClassFactory(ComboCheckItemRenderer);
			super.itemRenderer = render;
		}
		
		public function clearSelections():void {
			if (selectedItems.length > 0)
				selectedItems.splice(0, selectedItems.length);
			
			for each (var obj:Object in dataProvider) {
				obj.assigned = false;
			}
			
			selectedIndex = -1;
			
			selections();
		}
		
		private function getItem(text:String):Object {
			for each (var item:Object in dataProvider) {
				if (item.label == text)
					return item;
			}
			
			return null;
		}
		
		private function selections(reset:Boolean = true):void {
			var obj:Object;
			
			textInput.text = "";
			
			if (!reset) {
				for each (obj in selectedItems) {
					textInput.text += obj.label + ", ";
				}
				
				textInput.text = textInput.text.substr(0, textInput.text.length - 2);
			}
			
			toolTip = textInput.text;
		}
		
		private function onCheck(obj:Object):void {
			trace("check");
			
			if (selectedItems == null || selectedItems.indexOf(obj) == -1) {
				if (selectedItems == null) {
					selectedItems = new Vector.<Object>();
				}
				selectedItems.push(obj);
				
				dispatchEvent(new Event("addItem"));
			}
			else {
				var index:int = selectedItems.indexOf(obj);
				
				selectedItems.splice(index, 1);
				dispatchEvent(new Event("removeItem"));
			}
			
			dispatchEvent(new Event("valueCommit"));
		}
	}
}