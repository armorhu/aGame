package com.agame.framework.module
{
	import com.qzone.qfa.control.module.IModule;
	import com.qzone.qfa.managers.resource.Resource;

	public class ModuleManager
	{
		//当前模块
		protected var _modules:Vector.<Module>;
		//模块的配置
		protected var _moduleConfig:Object;

		public function ModuleManager()
		{
			_modules=new Vector.<Module>;
			_moduleConfig={};
		}

		/**
		 * 注册模块
		 * @param moduleName 模块的唯一的名字
		 * @param moduleClass 模块的类，可以是具体的类对象，也可以是类的完全限定名
		 * @param moduleLayer 模块的层级，可以是任意显示对象，包括starling类型。
		 * @param url 动态加载模块时的url。
		 */
		public function registeModule(moduleName:String, moduleClass:*, moduleLayer:*, url:String=''):void
		{
			if (_moduleConfig[moduleName] != undefined) //关键字已经被注册
				throw new Error(moduleName + "已经被注册了!");

			//注册配置
			moduleLayer.name=moduleName;
			_moduleConfig[moduleName]={name: moduleName, c: moduleClass, view: moduleLayer, swf: url, loaded: false};
		}

		public function loadModule(name:String, completeHandler:Function=null, errorHandler:Function=null):void
		{
			if (_moduleConfig[name] == undefined || _moduleConfig[name]["loaded"] == true) //模块未注册或者已经启动
			{
				if (errorHandler != null)
					errorHandler();
				return;
			}
			var moduleConfig:Object = _moduleConfig[name];
			if (moduleConfig["swf"] != null) //是否注册了模块素材
				loadResource(moduleConfig["swf"], startupModule);
			else
				startupModule(null);
			
			function startupModule(resource:Resource):void
			{
				if (resource != null && resource.data == null)
				{
					if (errorHandler != null)
						errorHandler();
				}
				else
				{
					moduleConfig["loaded"] = true;
					var theClass:Class = moduleConfig["c"] as Class;
					var module:IModule = new theClass(moduleConfig["name"]) as IModule;
					_modules.push(module);
					module.startup(app, moduleConfig["view"], resource);
					if (completeHandler != null)
						completeHandler();
				}
			}
		}

		/**
		 * 卸载module
		 * @param name 模块名
		 * @return
		 */
		public function unloadModule(name:String):void
		{
			var moduleConfig:Object=_moduleConfig[name];
			if (moduleConfig == null || moduleConfig["loaded"] == false)
				return;

			const len:int=_modules.length;
			for (var i:int=0; i < len; i++)
				if (_modules[i].name == name)
				{
					trace("[Module " + name + "]: unload...");
					_modules[i].dispose();
					_modules.splice(i, 1);
					moduleConfig["loaded"]=false;
					//					_moduleConfig[name] = null;
					//					delete _moduleConfig[name];
					break;
				}
		}
	}
}
