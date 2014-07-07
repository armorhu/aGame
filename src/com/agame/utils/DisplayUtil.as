package com.agame.utils
{


	public class DisplayUtil
	{
		public function DisplayUtil()
		{
		}



		public static function alignWith(source:Object, target:Object):void
		{
			source.x=target.x;
			source.y=target.y;
			var parentIndex:int=target.parent.getChildIndex(target);
			source.name=target.name;
			target.parent.addChildAt(source, parentIndex);
			target.name='';
			target.parent.removeChild(target);
		}
	}
}
