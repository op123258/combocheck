package com.acm {
	import flash.events.MouseEvent;
	
	import mx.events.ItemClickEvent;
	
	import spark.components.CheckBox;
	import spark.components.supportClasses.ItemRenderer;
	
	[Event("check", type="com.acm.ComboCheckEvent")]
	
	public class ComboCheckItemRenderer extends ItemRenderer {
		public var item:CheckBox;
		
		private var _data:Object;
		
		public function ComboCheckItemRenderer() {
			super();
			
			item = new CheckBox();
			item.x = 5;
			addElement(item);
			item.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		[Bindable] override public function set data(value:Object):void {
			if (value != null) {
				_data = value;
				item.label = value.label;
				item.selected = value.assigned;
			}
		}
		
		override public function get data():Object {
			return _data;
		}
		
		public function onClick(event:MouseEvent):void {
			var e:ItemClickEvent = new ItemClickEvent(ItemClickEvent.ITEM_CLICK, true);
			data.assigned = item.selected;
			e.item = data;
			ComboCheck(owner).dispatchEvent(e);
		}
	}
}