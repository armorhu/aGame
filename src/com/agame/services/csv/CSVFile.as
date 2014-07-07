package com.agame.services.csv
{
	import com.adobe.utils.StringUtil;

	import flash.utils.Dictionary;

	/**
	 *csv的reader
	 * @author hufan
	 *
	 */
	public class CSVFile
	{
		public var keys:Array;
		public var types:Array;
		public var valueTables:Vector.<Vector.<String>>;

		private var _data:String;
		public var indexDict:Dictionary;

		public function CSVFile()
		{
		}

		/**
		 * 解析文件
		 * @param indexName 索引key，默认为第一个
		 *
		 */
		public function parse(indexName:String=null):void
		{
			indexDict=new Dictionary();

			while (_data.indexOf('\r\n') != -1)
				_data=_data.replace('\r\n', '\n');
			var linesArr:Array=_data.split("\n");
			keys=String(linesArr[0]).split(",");
			types=String(linesArr[1]).split(",");

			var indexOfIndexName:int=0;
			if (indexName)
			{
				indexOfIndexName=keys.indexOf(indexName);
			}
			if (indexOfIndexName < 0)
				indexOfIndexName=0;

			const keyLen:int=keys.length;
			const lineNums:int=linesArr.length;
			for (i=0; i < keyLen; i++)
			{
				keys[i]=tirmStr(keys[i]);
				types[i]=formatTypeString(tirmStr(types[i]));
			}

			//值的表
			valueTables=new Vector.<Vector.<String>>();
			//			valueTables.length = lineNums - 2;

			var valueLineArr:Array;
			var valueLineStr:String;
			for (var i:int=2; i < lineNums; i++)
			{
				//从第二行开始。
				valueLineStr=linesArr[i];
				if (valueLineStr == '')
					break;
				valueLineArr=String(valueLineStr).split(',');

				var valueTable:Vector.<String>=new Vector.<String>();
				for (var j:int=0; j < keyLen; j++)
					valueTable[j]=valueLineArr[j];

				//索引操作
				var indexValue:String=valueLineArr[indexOfIndexName];
				if (indexValue && indexValue.length > 0 && !(indexValue in indexDict))
				{
					indexDict[indexValue]=i - 2;
				}

				valueTable.fixed=true;
				valueTables[i - 2]=valueTable;

			}
			valueTables.fixed=true;

			_data=null;
		}

		/**
		 * 读进来，不解析
		 * @param data
		 *
		 */
		public function read(data:String):CSVFile
		{
			_data=data;
			return this;
		}

		private function tirmStr(str:String):String
		{
			if (str)
			{
				str=StringUtil.trim(str);
				str=str.replace('"', '');
				str=str.replace('"', '');
			}
			return str;
		}

		/**
		 * 通过key获取索引的目标行数
		 * @param key
		 * @return
		 *
		 */
		public function getRowIndexByIndexKey(key:String):int
		{
			if (!key || key.length <= 0)
				return -1;

			if (!(key in indexDict))
				return -1;

			return indexDict[key];
		}

		public function getValue(row:int, col:int, startRow:int):*
		{
			var resultStr:String='';
			for (var i:int=row; i >= startRow; i--)
			{
				resultStr=valueTables[i][col];
				if (resultStr != '')
					break;
			}

			if (resultStr == '')
				return '';

			if (types[col] == Boolean)
				return resultStr.toLocaleLowerCase() == 'true';
			else
				return tirmStr(resultStr);
		}

		public function dispose():void
		{
			keys=null;
			types=null;
			valueTables=null;
			indexDict=null;
		}
		public static const TYPES:Array=['int', 'Number', 'String', 'Array', 'Boolean'];

		public function formatTypeString(type:String):String
		{
			if (type == null)
				return null;
			const len:int=TYPES.length;
			for (var i:int=0; i < len; i++)
			{
				if (TYPES[i] == null)
					continue;
				if (type.toLocaleLowerCase() == TYPES[i].toLocaleLowerCase())
				{
					type=TYPES[i];
					break;
				}
			}
			return type;
		}
	}
}
