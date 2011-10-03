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
		function set selectedIndex(value:int):void;
		function get selectedIndex():int;
		
		function get labelFunction ():Function;
		function set labelFunction (value:Function):void;
		
		function selectAll():void;
		function deselectAll():void;
	}
}