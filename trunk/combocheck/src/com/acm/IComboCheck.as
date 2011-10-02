package com.acm
{
	import mx.collections.IList;

	public interface IComboCheck
	{
		function get component():IComboCheckType;
		function get selectedItem():*;
		function get selectedItems():Vector.<Object>;
		
		function selectAll():void;
		function deselectAll():void;
	}
}