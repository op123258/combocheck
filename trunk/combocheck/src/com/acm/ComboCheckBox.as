/*
* ComboCheck
* v1.6.03
* Arcadio Carballares Martín, 2011
* http://www.arcadiocarballares.es
* Creative Commons - http://creativecommons.org/licenses/by-sa/2.5/es/deed.en_GB
*/
package com.acm
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	import mx.events.ItemClickEvent;
	
	import spark.components.ComboBox;
	import spark.components.supportClasses.DropDownListBase;
	
	use namespace mx_internal;
	
	[Event(name="itemAdded", type="com.acm.ComboCheckEvent")]
	[Event(name="itemRemoved", type="com.acm.ComboCheckEvent")]
	[Event(name="selectAll", type="com.acm.ComboCheckEvent")]
	[Event(name="deselectAll", type="com.acm.ComboCheckEvent")]
	
	public class ComboCheckBox extends ComboBox implements IComboCheckType
	{
		//private static const SELECT_ALL:String = "selectAll";
		private static const ROW_HEIHGT:Number = 18.0;
		private static const GAP_HEIHGT:int = 3.0;
		private static const DEFAULT_ROWCOUNT:int = 10;
		
		[Bindable]
		public var dropDownHeight:Number;
		[Bindable]
		public var rowCount:int;
		[Bindable]
		public var selectAllLabelField:String;
		[Bindable]
		public var selectedLabelField:String;
		
		private var selectedAllItems:ArrayCollection;
		private var _selectedItems:Vector.<Object>;
		override public function set selectedItems(value:Vector.<Object>):void {
			super.selectedItems = value;
			_selectedItems = value;
		}
		override public function get selectedItems():Vector.<Object> {
			dispatchEvent(new ComboCheckEvent(ComboCheckEvent.ITEMS_SELECTED));
			return _selectedItems;
		}
		public function getSelectedItems():Vector.<Object> {
			return _selectedItems;
		}
		
		override public function get selectedItem():* {
			dispatchEvent(new ComboCheckEvent(ComboCheckEvent.ITEM_SELECTED));
			return super.selectedItem;
		}
		
		public function getSelectedItem():* {
			return super.selectedItem;
		}
		
		public function ComboCheckBox()
		{
			super();
			setStyle("skinClass", ComboCheckBoxSkin);
			addEventListener(ItemClickEvent.ITEM_CLICK, onItemClick);
			addEventListener(FlexEvent.UPDATE_COMPLETE, onUpdateComplete);
			
			// Initialize object
			selectedItems = new Vector.<Object>();
			rowCount = DEFAULT_ROWCOUNT;
			selectAllLabelField = "selectAll";
			selectedLabelField = "selected";
		}
		
		private function onUpdateComplete(event:FlexEvent):void {
			if (dataProvider != null) {
				removeEventListener(FlexEvent.UPDATE_COMPLETE, onUpdateComplete);
				selectedAllItems = new ArrayCollection();
				for each (var item:Object in dataProvider) {
					if (item.hasOwnProperty(selectAllLabelField) && item[selectAllLabelField] == true) {
						selectedAllItems.addItem(item);
					}
					
					if (item.selected) {
						selectedItems.push(item);
					}
				}
				if (selectedAllItems.length > 0) {
					selectAll();
					dispatchEvent(new ComboCheckEvent(ComboCheckEvent.SELECT_ALL));
				}
				
				// Redim dropdown menu
				if (isNaN(dropDownHeight) || dropDownHeight == 0) {
					if (rowCount > dataProvider.length) {
						dropDownHeight = (dataProvider.length * ROW_HEIHGT) + GAP_HEIHGT;
					} else {
						dropDownHeight = (rowCount * ROW_HEIHGT) + GAP_HEIHGT;
					}
				}
			}
		}
		
		override protected function keyDownHandler(event:KeyboardEvent):void {
			super.keyDownHandler(event);
			if (event.keyCode == Keyboard.ENTER && isDropDownOpen) {
				
				var currentItem:Object = getItem(textInput.text);
				
				if (currentItem != null) {
					currentItem.selected = !currentItem.selected;
					var e:ItemClickEvent = new ItemClickEvent(ItemClickEvent.ITEM_CLICK, true);
					e.item = currentItem;
					dispatchEvent(e);
					
					// Update items
					dataGroup.dataProvider.itemUpdated(currentItem,null,currentItem,e.item);
				}
				
			}
		}
		
		override protected function capture_keyDownHandler(event:KeyboardEvent):void {
			if (event.keyCode == Keyboard.ENTER) {
				return;
			}
			super.capture_keyDownHandler(event);
		}
		
		override protected function item_mouseDownHandler(event:MouseEvent):void {
		}
		
		private function getItem(text:String):Object {
			for each (var item:Object in dataProvider) {
				if (item[labelField] == text)
					return item;
			}
			
			return null;
		}
		
		private function onItemClick(event:ItemClickEvent):void {
			trace("item checked!");
			var evt:ComboCheckEvent;
			
			if (event.item.selected)  {
				if (event.item.hasOwnProperty(selectAllLabelField) && event.item[selectAllLabelField] == true) {
					selectAll();
					dispatchEvent(new ComboCheckEvent(ComboCheckEvent.SELECT_ALL));
				} else {
					selectedItems.push(event.item);
					
					// AddItem
					evt = new ComboCheckEvent(ComboCheckEvent.ITEM_ADDED);
					evt.data = event.item;
					dispatchEvent(evt);
					
					if (selectedItems.length == dataProvider.length - selectedAllItems.length) {
						updateItemsAll(true);
					}
				}
			} else {
				if (event.item.hasOwnProperty(selectAllLabelField) && event.item[selectAllLabelField]==true) {
					deselectAll();
					dispatchEvent(new ComboCheckEvent(ComboCheckEvent.DESELECT_ALL));
				} else {
					var index:int = selectedItems.indexOf(event.item);
					selectedItems.splice(index, 1);
					
					updateItemsAll(false);
					
					// RemoveItem
					evt = new ComboCheckEvent(ComboCheckEvent.ITEM_REMOVED)
					evt.data = event.item;
					dispatchEvent(evt);
				}
			}
			
			dispatchEvent(new ComboCheckEvent(ComboCheckEvent.ITEM_SELECTED));
			dispatchEvent(new Event("valueCommit"));
		}
		
		// Display 'allItem' selected or not selected
		private function updateItemsAll (value:Boolean):void {
			for each (var item:* in selectedAllItems) {
				item.selected = value;
				dataProvider.itemUpdated(item,'selected',!value,value);
			}
		}
		
		public function selectAll():void {
			selectedItems = new Vector.<Object>();
			for each (var item:* in dataProvider) {
				item.selected = true;
				if (item.hasOwnProperty(selectAllLabelField)) {
				} else {
					selectedItems.push(item);
				}
			}
			refreshDropDown();
		}
		
		public function deselectAll():void {
			selectedItems = new Vector.<Object>();
			for each (var item:* in dataProvider) {
				item.selected = false;
			}
			refreshDropDown();
		}
		
		private function refreshDropDown():void {
			for each(var obj:Object in dataProvider){
				dataProvider.itemUpdated(obj);
			}
			// 'ArrayCollection(dataProvider).refresh();' Refresh collection but force scroll to top
		}
	}
}