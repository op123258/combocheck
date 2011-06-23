/*
* ComboCheck
* v1.4.0
* Arcadio Carballares Martín, 2011
* http://www.arcadiocarballares.com
* Creative Commons - http://creativecommons.org/licenses/by-sa/2.5/es/deed.en_GB
*/
package com.acm {
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import flashx.textLayout.tlf_internal;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.controls.Alert;
	import mx.controls.TextInput;
	import mx.controls.listClasses.ListBase;
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	import mx.core.IVisualElement;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	import mx.events.IndexChangedEvent;
	import mx.events.ItemClickEvent;
	
	import spark.components.CheckBox;
	import spark.components.ComboBox;
	import spark.components.IItemRenderer;
	import spark.components.SkinnableDataContainer;
	import spark.components.supportClasses.DropDownListBase;
	import spark.components.supportClasses.GroupBase;
	import spark.components.supportClasses.ListBase;
	import spark.core.NavigationUnit;
	import spark.events.DropDownEvent;
	import spark.events.IndexChangeEvent;
	import spark.utils.LabelUtil;
	
	[Event("addItem", type="flash.events.Event")]
	[Event("removeItem", type="flash.events.Event")]
	
	public class ComboCheck extends ComboBox {
		private var m_labelField:String = "label";
		
		private var _selectedItems:Vector.<Object>;
		
		[Bindable("change")]
		[Bindable("valueCommit")]
		[Bindable("collectionChange")]
		override public function set selectedItems(value:Vector.<Object>):void {
			_selectedItems = value;
		}
		
		override public function get selectedItems():Vector.<Object> {
			return _selectedItems;
		}
		
		public function ComboCheck() {
			super();
			
			var render:ClassFactory = new ClassFactory(ComboCheckItemRenderer);
			
			super.itemRenderer = render;
			super.dropDownController = new DropController;
			
			addEventListener(DropDownEvent.CLOSE, onDropDownClose);
			addEventListener(ItemClickEvent.ITEM_CLICK, onItemClick);
			addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown_EventHandler);
		}
		
		private function onKeyDown_EventHandler(event:KeyboardEvent):void {
			if (event.keyCode == Keyboard.ENTER && isDropDownOpen && textInput.text.length > 0) {
				var currentItem:Object = getItem(textInput.text);
				
				if (currentItem != null) {
					currentItem.selected = !currentItem.selected;
					onCheck(currentItem);
					invalidateProperties();
				}
			}
		}
		
		private function getItem(text:String):Object {
			for each (var item:Object in dataProvider) {
				if (item.label == text)
					return item;
			}
			
			return null;
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
				if (dataProvider[i].selected == true) {
					selectedItems.push(dataProvider[i]);
				}
			}
		}
		
		override protected function commitProperties():void {
			super.commitProperties();
			
			var render:ClassFactory = new ClassFactory(ComboCheckItemRenderer);
			
			super.itemRenderer = render;
		}
		
		override protected function item_mouseDownHandler(event:MouseEvent):void {
			if (event.target is ComboCheckItemRenderer) {
				var render:ComboCheckItemRenderer = event.target as ComboCheckItemRenderer;
				var check:CheckBox = render.item as CheckBox;
				
				if (check.selected) {
					render.data.selected = false;
					check.selected = false;
				}
				else {
					render.data.selected = true;
					check.selected = true;
				}
				
				onCheck(render.data);
			}
		}
		
		private function onItemClick(event:ItemClickEvent):void {
			onCheck(event.item);
		}
		
		private function onDropDownClose(event:DropDownEvent):void {
			selectedIndex = -1;
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