package com.arcadiocarballares {
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.controls.CheckBox;
	import mx.events.FlexEvent;
	
	public class ComboCheckItemRenderer extends CheckBox {
		
		public function ComboCheckItemRenderer() {
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			addEventListener(MouseEvent.CLICK,onClick);
		}

		override public function set data(value:Object):void {
			if (value != null) {
				super.data = value;
				if (value.tooltip!=null) {
					toolTip = value.tooltip;
				}
			}
		}
		
		private function onCreationComplete(event:Event=null):void {
			if (data!= null && data.assigned==true) {
				selected=true;
			}
		}
		
		private function onClick(event:MouseEvent):void {
			data.assigned=selected;
			var myComboCheckEvent:ComboCheckEvent=new ComboCheckEvent(ComboCheckEvent.COMBO_CHECKED);
			myComboCheckEvent.obj=data;
			owner.dispatchEvent(myComboCheckEvent);
		}
		
	}
}