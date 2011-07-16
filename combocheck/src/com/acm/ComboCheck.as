/*
* ComboCheck
* v1.3.0
* Arcadio Carballares Martín, 2010
* http://www.carballares.es/arcadio
* Creative Commons - http://creativecommons.org/licenses/by-sa/2.5/es/deed.en_GB
*/
package com.acm
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.controls.Alert;
	import mx.controls.listClasses.ListBase;
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	import mx.core.IVisualElement;
	import mx.events.FlexEvent;
	import mx.events.IndexChangedEvent;
	import mx.events.ItemClickEvent;
	
	import spark.components.CheckBox;
	import spark.components.DropDownList;
	import spark.components.IItemRenderer;
	import spark.components.supportClasses.DropDownListBase;
	import spark.components.supportClasses.ListBase;
	import spark.events.DropDownEvent;
	import spark.events.IndexChangeEvent;
	
	[Event(name="addItem", type="flash.events.Event")]
	[Event(name="removeItem", type="flash.events.Event")]
	[Event(name="selectAll", type="flash.events.Event")]
	[Event(name="deSelectAll", type="flash.events.Event")]
	
	public class ComboCheck extends DropDownList {
		public var itemAllValue:String="all";
		public var itemAllPosition:int = 0;
		public var labelFieldMultiple:String = "multiple";
		
		private var actualIndex:int;
		private var _selectedItems:Vector.<Object>;
		
		[Bindable("change")]
		[Bindable("valueCommit")]
		[Bindable("collectionChange")]
		override public function set selectedItems(value:Vector.<Object>):void {
			_selectedItems=value;
		}
		
		override public function get selectedItems():Vector.<Object> {
			return _selectedItems;
		}
		
		public function ComboCheck() {
			super();
			
			var render:ClassFactory = new ClassFactory(ComboCheckItemRenderer);
			super.itemRenderer = render;
			addEventListener (DropDownEvent.CLOSE, onDropDown);
			addEventListener(ItemClickEvent.ITEM_CLICK, onItemClick);
		}
		
		override public function set dataProvider(value:IList):void {
			super.dataProvider = value;
			// Load initial selected items
			selectedItems = new Vector.<Object>;
			for (var i:int;i<dataProvider.length;i++) {
				if (dataProvider[i].assigned==true) {
					selectedItems.push(dataProvider[i]);
				}
				if (dataProvider[i].value == itemAllValue) {
					itemAllPosition=i;
				}
			}
		}
		
		override protected function commitProperties():void {
			super.commitProperties();
			var render:ClassFactory = new ClassFactory(ComboCheckItemRenderer);
			super.itemRenderer = render;
			setText();
		}
		
		override protected function item_mouseDownHandler(event:MouseEvent):void {
			if (event.target is ComboCheckItemRenderer) {
				var render:ComboCheckItemRenderer = event.target as ComboCheckItemRenderer;
				var check:CheckBox = render.item as CheckBox;
				if (check.selected) {
					render.data.assigned = false;
					check.selected = false;
				} else {
					render.data.assigned = true;
					check.selected = true;
				}
				onCheck(render.data);
			}
		}
		
		private function onItemClick(event:ItemClickEvent):void {
			onCheck(event.item);
		}
		
		private function onDropDown(event:DropDownEvent):void {
			selectedIndex=-1;
			setText();
		}
		
		private function onCheck(obj:Object):void {
			trace ("check");
			if (selectedItems == null || selectedItems.indexOf(obj) == -1) {
				if (selectedItems == null) {
					selectedItems = new Vector.<Object>();
				}
				selectedItems.push(obj);
				if (obj.value == itemAllValue) {
					dispatchEvent(new Event("selectAll"));   
					selectAllCheckBox(true);
				} else {
					if (selectedItems.length == dataProvider.length - 1) {
						selectAllItem (true);
					}
				}
				dispatchEvent(new Event("addItem"));
			} else {
				var index:int=selectedItems.indexOf(obj);
				selectedItems.splice(index,1);
				if (obj.value == itemAllValue) {
					dispatchEvent(new Event("deSelectAll"));    
					selectAllCheckBox(false);
				} else {
					if (selectedItems.length == dataProvider.length - 1) {
						selectAllItem (false);
					}
				}
				dispatchEvent(new Event("removeItem"));
			}
			setText();
			
			dispatchEvent(new Event("valueCommit"));
		}
		
		private function setText():void {
			if (selectedItems != null && selectedItems.length > 0) {
				if (selectedItems.length>1) {
					labelDisplay.text=labelFieldMultiple;
				} else {
					labelDisplay.text=selectedItems[0].label;
				}
			} else {
				labelDisplay.text=prompt;
			}
		}
		
		private function selectAllCheckBox (value:Boolean):void {
			trace ("select all");
			selectedItems = new Vector.<Object>();
			for each (var obj:Object in dataProvider) {
				obj.assigned = value;
				if (value == true) {
					selectedItems.push(obj);
				}
			}
			invalidateProperties();
		}
		
		private function selectAllItem (value:Boolean):void {
			var item:Object = dataProvider.getItemAt(itemAllPosition);
			item.assigned=value;
			if (value) {
				selectedItems.push(item);
			} else {
				var index:int=selectedItems.indexOf(item);
				selectedItems.splice(index,1);
			}
			invalidateProperties();
		}
	}
}