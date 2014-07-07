package com.agame.utils
{

	public function Beautify(what:Number, floats:int=0):String
	{
		var n:Number=Math.floor(what);
		if (n > 100000000)
		{
			if (n % 10000000 == 0)
				return int(n / 10000000) / 10 + "亿";
			else
				return (n / 100000000).toFixed(2) + "亿";
		}
		else if (n > 10000)
		{
			if (n % 1000 == 0)
				return int(n / 1000) / 10 + "万";
			else
				return (n / 10000).toFixed(2) + "万";
		}
		return String(n);
	}

//	public function Beautify(what:Number, floats:int=0):String //turns 9999999 into 9,999,999
//	{
//		if (floats > 0)
//			return what.toFixed(floats);
//		else
//			return Math.floor(what).toString();
//
//		var whatInt:Number=Math.floor(what);
//		if (whatInt >= 0)
//		{
//			var whatStr:String=whatInt + '';
//		}
//		else
//		{
//			whatStr=-whatInt + '';
//		}
//		var result:String='';
//		var len:int=whatStr.length;
//		if (len > 3)
//		{
//			for (var i:int=0; i < len; i++)
//			{
//				result=whatStr.charAt(len - i - 1) + result;
//				if (i > 0 && i < len - 1 && (i + 1) % 3 == 0)
//				{
//					result=',' + result;
//				}
//			}
//		}
//		else
//		{
//			result=whatStr;
//		}
//
//		if (whatInt < 0)
//			result='-' + result;
//
//
//		return result;
//
//
//		if (floats > 0)
//		{
//			var floatsNum:Number=what - whatInt;
////			if(floatsNum>0)
//		}
//	}
}
