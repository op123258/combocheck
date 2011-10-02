package com.acm
{
	import mx.collections.IList;

	public interface IComboCheckType
	{
		function set dataProvider(value:IList):void;
		function get dataProvider():IList;
		function set labelField(value:String):void;
		function getSelectedItem():*;
		function getSelectedItems():Vector.<Object>;
		//function refreshDropDown():void;
		
		function selectAll():void;
		function deselectAll():void;
	}
}