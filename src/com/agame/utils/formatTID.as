package com.agame.utils
{
	public function formatTID(source:String, allowNumber:Boolean):String
	{
		// TODO Auto Generated method stub
		var arr:String='abcdefghigklmnopqrstuvwxyz';
		arr=arr.toUpperCase() + arr;
		arr=arr + '_';
		if (allowNumber)
			arr=arr + '1234567890';
		var len:int=source.length;
		for (var i:int=0; i < len; i++)
			if (arr.indexOf(source.charAt(i)) == -1)
				source=source.substr(0, i) + '_' + source.substr(i + 1);

		while (source.charAt(0) == '_')
			source=source.substr(1);
		while (source.charAt(source.length - 1) == '_')
			source=source.substr(0, source.length - 1);

		return source;
	}
}
