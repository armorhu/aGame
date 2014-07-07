package com.agame.framework.module
{
	/**
	 * 模块API调用协议 
	 * @author youyee
	 * 
	 */	
	public class ModuleAPIProtocol
	{
		/**
		 * 模块名称 
		 */		
		public var moduleName:String;
		
		/**
		 * 对应参数 
		 */		
		public var params:Array;
		
		/**
		 * API名称 
		 */		
		public var apiName:String;
		
		/**
		 * 如果模块没有加载，是否自动加载模块 
		 */		
		public var loadModuleAutomatic:Boolean;
		
		/**
		 * 构造函数 
		 * @param moduleName 模块名称
		 * @param apiName 方法名
		 * @param autoLoadModule 是否自动读取未加载的模块
		 * @param restParam 调用API的参数
		 * 
		 */		
		public function ModuleAPIProtocol(apiName:String, autoLoadModule:Boolean, ...restParam)
		{
			var len:int = restParam.length;
			this.params = [];
			
			for (var i:int=0; i<len; ++i)
			{
				params.push(restParam[i]);
			}
			
			this.apiName = apiName;
			this.loadModuleAutomatic = autoLoadModule;
		}
	}
}