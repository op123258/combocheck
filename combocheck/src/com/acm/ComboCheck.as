/*
* ComboCheck
* v1.6.02
* Arcadio Carballares Martín, 2011
* http://www.arcadiocarballares.es
* Creative Commons - http://creativecommons.org/licenses/by-sa/2.5/es/deed.en_GB
*/
package com.acm
{
	import flash.display.DisplayObject;
	
	import mx.collections.IList;
	import mx.core.UIComponent;
	
	import spark.components.ComboBox;
	import spark.events.IndexChangeEvent;
	
	[Event(name="change", type="spark.events.IndexChangeEvent")]
	
	[Event(name="itemAdded", type="com.acm.ComboCheckEvent")]
	[Event(name="itemRemoved", type="com.acm.ComboCheckEvent")]
	[Event(name="itemSelected", type="com.acm.ComboCheckEvent")]
	[Event(name="itemsSelected", type="com.acm.ComboCheckEvent")]
	[Event(name="selectAll", type="com.acm.ComboCheckEvent")]
	[Event(name="deselectAll", type="com.acm.ComboCheckEvent")]
	
	public class ComboCheck extends UIComponent implements IComboCheck
	{
		private static const DEFAULT_HEIGHT:int = 23;
		private static const DEFAULT_WIDTH:int = 125;
		private static const DEFAULT_TYPE:String = "combobox";
		
		private var _type:String;
		[Bindable]
		[Inspectable(defaultValue="combobox", enumeration="combobox,combolist")] 
		public function set type (value:String):void {
			_type = value;
			if (value != null) {
				createCombo();
			}
		}
		public function get type ():String {
			return _type;
		}
		
		private var _dataProvider:IList;
		public function set dataProvider(value:IList):void {
			_dataProvider = value;
			if (value != null && combo) {
				combo.dataProvider = value;
			}
		}
		public function get dataProvider():IList {
			return _dataProvider as IList;
		}
		
		private var combo:IComboCheckType;
		public function get component ():IComboCheckType {
			return combo;
		}
		
		private var _labelField:String;
		[Bindable]
		public function set labelField (value:String):void {
			_labelField = value;
			if (combo) {
				combo.labelField = value;
			}
		}
		public function get labelField ():String {
			return _labelField;
		}
		
		private var _labelToItemFunction:Function;
		[Bindable]
		public function set labelToItemFunction (value:Function):void {
			_labelToItemFunction = value;
			if (combo && type == 'combobox') {
				ComboBox(combo).labelToItemFunction = value;
			}
		}
		public function get labelToItemFunction ():Function {
			return _labelToItemFunction;
		}
		
		private var _labelFunction:Function;
		[Bindable]
		public function set labelFunction (value:Function):void {
			_labelFunction = value;
			if (combo) {
				combo.labelFunction = value;
			}
		}
		public function get labelFunction ():Function {
			return _labelFunction;
		}
		
		private var _selectedIndex:int;
		[Bindable]
		public function set selectedIndex (value:int):void {
			_selectedIndex = value;
			if (combo) {
				combo.selectedIndex = value;
			}
		}
		public function get selectedIndex ():int {
			return _selectedIndex;
		}
		
		private var _rowCount:int;
		[Bindable]
		public function set rowCount (value:int):void {
			_rowCount = value;
			if (combo) {
				combo.rowCount = value;
			}
		}
		public function get rowCount ():int {
			return _rowCount;
		}
		
		private var _selectedItem:*;
		[Bindable ("itemSelected")]
		public function set selectedItem(value:*):void {
			_selectedItem = value;
		}
		public function get selectedItem():* {
			return combo.getSelectedItem();
		}
		
		private var _selectedItems:Vector.<Object>;
		[Bindable ("itemsSelected")]
		public function set selectedItems (value:Vector.<Object>):void {
			_selectedItems = value;
		}
		public function get selectedItems ():Vector.<Object> {
			var result:Vector.<Object>;
			if (combo) {
				result = combo.getSelectedItems();
			}
			return result;
		}
		
		private var _dropDownHeight:Number;
		[Bindable]
		public function set dropDownHeight (value:Number):void {
			_dropDownHeight = value;
			if (combo) {
				combo.dropDownHeight = value;
			}
		}
		public function get dropDownHeight ():Number {
			return _dropDownHeight;
		}
		
		private var _selectAllLabelField:String;
		[Bindable]
		public function set selectAllLabelField (value:String):void {
			_selectAllLabelField = value;
			if (combo) {
				combo.selectAllLabelField = value;
			}
		}
		public function get selectAllLabelField ():String {
			return _selectAllLabelField;
		}
		
		private var _selectedLabelField:String;
		[Bindable]
		public function set selectedLabelField (value:String):void {
			_selectedLabelField = value;
			if (combo) {
				combo.selectedLabelField = value;
			}
		}
		public function get selectedLabelField ():String {
			return _selectedLabelField;
		}
		
		public function ComboCheck()
		{
			super();
			height = DEFAULT_HEIGHT;
			width = DEFAULT_WIDTH;
			type = DEFAULT_TYPE;
		}
		
		private function createCombo():void {
			switch(type) {
				case "combobox": 
					combo = new ComboCheckBox();
					break;
				case "combolist":
					combo = new ComboCheckList();
					break;
				default:
					combo = new ComboCheckBox();
					break;
			}
			
			UIComponent(combo).addEventListener(ComboCheckEvent.ITEM_SELECTED, onItemSelected);
			UIComponent(combo).addEventListener(ComboCheckEvent.ITEMS_SELECTED, onItemsSelected);
			UIComponent(combo).addEventListener(ComboCheckEvent.ITEM_REMOVED, onItemRemoved);
			UIComponent(combo).addEventListener(ComboCheckEvent.ITEM_ADDED, onItemAdded);
			UIComponent(combo).addEventListener(ComboCheckEvent.SELECT_ALL, onSelectAll);
			UIComponent(combo).addEventListener(ComboCheckEvent.DESELECT_ALL, onDeselectAll);
			
			UIComponent(combo).addEventListener(IndexChangeEvent.CHANGE, onChange);
		}
		
		private function onItemSelected (event:ComboCheckEvent):void {
			dispatchEvent(new ComboCheckEvent(ComboCheckEvent.ITEM_SELECTED));
		}
		
		private function onItemsSelected (event:ComboCheckEvent):void {
			dispatchEvent(new ComboCheckEvent(ComboCheckEvent.ITEMS_SELECTED));
		}
		
		private function onSelectAll (event:ComboCheckEvent):void {
			dispatchEvent(new ComboCheckEvent(ComboCheckEvent.SELECT_ALL));
		}
		
		private function onDeselectAll (event:ComboCheckEvent):void {
			dispatchEvent(new ComboCheckEvent(ComboCheckEvent.DESELECT_ALL));
		}
		
		private function onChange (event:IndexChangeEvent):void {
			dispatchEvent(new IndexChangeEvent(IndexChangeEvent.CHANGE));
		}
		
		private function onItemAdded (event:ComboCheckEvent):void {
			var evt:ComboCheckEvent = new ComboCheckEvent(ComboCheckEvent.ITEM_ADDED);
			evt.data = event.data;
			dispatchEvent(evt);
		}
		
		private function onItemRemoved (event:ComboCheckEvent):void {
			var evt:ComboCheckEvent = new ComboCheckEvent(ComboCheckEvent.ITEM_REMOVED);
			evt.data = event.data;
			dispatchEvent(evt);
		}
		
		override protected function commitProperties():void {
			super.commitProperties();
		}
		
		override protected function createChildren():void {
			super.createChildren();
			if (combo) {
				addChild(combo as DisplayObject)
			}
		}
		
		override protected function measure():void {
			super.measure();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if (combo) {
				UIComponent(combo).setActualSize(width, height);
			}
		}
		
		public function selectAll():void {
			combo.selectAll();
		}
		
		public function deselectAll():void {
			combo.deselectAll();
		}
	}
}