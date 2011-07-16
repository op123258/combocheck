/*
* ComboCheck
* v1.2.6
* Arcadio Carballares Martín, 2009
* http://www.carballares.es/arcadio
*/
package com.arcadiocarballares {
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.ComboBox;
	import mx.controls.listClasses.ListBase;
	import mx.core.ClassFactory;
	import mx.events.CollectionEvent;
	import mx.events.FlexEvent;
	
	[Event(name="addItem", type="flash.events.Event")]
	[Event(name="itemsCreated", type="flash.events.Event")]
	[Event(name="selectAll", type="flash.events.Event")]
	[Event(name="deSelectAll", type="flash.events.Event")]
	
	public class ComboCheck extends ComboBox {
		public var itemAllValue:int=-1;
		private const ITEM_ALL_POSITION_DEFAULT:int=-1000;
		private var itemAllPosition:int=ITEM_ALL_POSITION_DEFAULT;
		
		private var _selectedItems:ArrayCollection;
		
		[Bindable("change")]
		[Bindable("valueCommit")]
		[Bindable("collectionChange")]
		public function set selectedItems(value:ArrayCollection):void {
			_selectedItems=value;
		}
		
		public function get selectedItems():ArrayCollection {
			return _selectedItems;
		}
		
		public function ComboCheck() {
			super();
			addEventListener("comboChecked", onComboChecked);
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			addEventListener(Event.CLOSE, onDropDownInit);
		}
		
		private function onCreationComplete(event:Event):void {
			dropdown.addEventListener(FlexEvent.CREATION_COMPLETE, onDropDownComplete);
		}
		
		override public function set dataProvider(value:Object):void {
			super.dataProvider = value;
			// Set selecAll position
			for (var i:int;i<dataProvider.length;i++) {
				if (dataProvider[i].value == itemAllValue) {
					itemAllPosition=i;
					break;
				}
			}
		}
		
		override protected function commitProperties():void {
			super.commitProperties();
			
			var render:ClassFactory = new ClassFactory(ComboCheckItemRenderer);
			super.itemRenderer=render;
			var myDropDownFactory:ClassFactory = new ClassFactory(ComboCheckDropDownFactory);
			super.dropdownFactory=myDropDownFactory;
			
			selectedItems=new ArrayCollection();
			for each (var item:Object in dataProvider) {
				var index:int=selectedItems.getItemIndex(item);
				if (item.assigned==true) {
					if (index==-1) {
						selectedItems.addItem(item);
					}
				} else {
					if (index!=-1) {
						selectedItems.removeItemAt(index);
					}
				}
			}
			
			setText()
			
			dispatchEvent(new Event("itemsCreated"));
			trace ("commit properties!");
		}
		
		private function onDropDownInit(event:Event):void {
			invalidateProperties();
		} 
		
		private function onDropDownComplete(event:Event):void {
			trace ("dropdown complete!");
		} 
		
		private function onComboChecked(event:ComboCheckEvent):void {
			var obj:Object=event.obj;
			var index:int=selectedItems.getItemIndex(obj);
			if (index==-1) {
				selectedItems.addItem(obj);
				if (obj.value == itemAllValue) {
					dispatchEvent(new Event("selectAll"));    
				} else {
					if (selectedItems.length == dataProvider.length - 1) {
						selecCheckboxAll(true);
					}
				}
			} else {
				selectedItems.removeItemAt(index);
				if (obj.value == itemAllValue) {
					dispatchEvent(new Event("deSelectAll"));    
				} else {
					selecCheckboxAll(false);
				}
			}
			
			setText();
			
			
			dispatchEvent(new Event("valueCommit"));
			dispatchEvent(new Event("addItem"));
		}
		
		private function setText():void {
			if (selectedItems.length>1) {
				textInput.text='multiple'
			}
			if (selectedItems.length==1) {
				textInput.text=selectedItems.getItemAt(0)[labelField];
			}
			if (selectedItems.length<1) {
				textInput.text='';
			}
		}
		
		private function selecCheckboxAll(value:Boolean):void {
			var item:ComboCheckItemRenderer;
			if (itemAllPosition!=ITEM_ALL_POSITION_DEFAULT) {
				item=ComboCheckItemRenderer(ListBase(dropdown).indexToItemRenderer(itemAllPosition));
			
				if (value) {
					item.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				} else {
					var index:int=selectedItems.getItemIndex(item.data);
					if (index!=-1) {
						selectedItems.removeItemAt(index);
					}
					item.selected = false;
					item.data.assigned = false;
				}
			}
		}
	}
}