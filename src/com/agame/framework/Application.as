package com.agame.framework
{
	import com.agame.framework.module.IModule;
	import com.agame.framework.module.IModuleAPI;
	import com.agame.services.load.ResourceManager;
	import com.agame.services.load.resource.Resource;

	import flash.display.Sprite;

	public class Application extends Sprite
	{
		//modules
		protected var _modules:Vector.<IModule>;
		//模块的配置
		protected var _moduleConfig:Object;

		public function Application()
		{
			super();
			initliaze();
		}

		public function startup():void
		{
		}

		private function initliaze():void
		{
			_moduleConfig={};
			_modules=new Vector.<IModule>;
		}

		/**
		 * 根据模块名字获取模块实例
		 * @param name
		 * 注意：getModule方法可能会返回null
		 * @return
		 */
		public function getModule(name:String):IModule
		{
			const len:int=_modules.length;
			for (var i:int=0; i < len; i++)
			{
				if (_modules[i].name == name)
					return _modules[i];
			}
			return null;
		}


		/**
		 * 根据名字获取ModuleAPI
		 * 注意：getModuleAPI方法可能会返回null
		 * **/
		public function getModuleAPI(name:String):IModuleAPI
		{
			var iModule:IModule=getModule(name);
			if (iModule)
				return iModule.mouduleAPI;
			else
				return null;
		}

		/**
		 * 加载module
		 * @param name 模块名
		 * 模块未注册，或模块已启动都会触发errorhandler
		 */
		public function loadModule(name:String, completeHandler:Function=null, errorHandler:Function=null):void
		{
			if (_moduleConfig[name] == undefined || _moduleConfig[name]["loaded"] == true) //模块未注册或者已经启动
			{
				if (errorHandler != null)
					errorHandler();
				return;
			}
			var moduleConfig:Object=_moduleConfig[name];
			if (moduleConfig["swf"] != null) //是否注册了模块素材
				loadResource(moduleConfig["swf"], startupModule);
			else
				startupModule(null);

			var ins:Application=this;
			function startupModule(resource:Resource):void
			{
				if (resource != null && resource.data == null)
				{
					if (errorHandler != null)
						errorHandler();
				}
				else
				{
					moduleConfig["loaded"]=true;
					var theClass:Class=moduleConfig["c"] as Class;
					var module:IModule=new theClass(moduleConfig["name"]) as IModule;
					_modules.push(module);
					module.startup(ins, moduleConfig["view"], resource);
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
					_modules[i].destroy();
					_modules.splice(i, 1);
					moduleConfig["loaded"]=false;
					//					_moduleConfig[name] = null;
					//					delete _moduleConfig[name];
					break;
				}
		}

		/**
		 * 需求：1 注册模块和buildlayer的代码在一处，这样方便理解整个程序的架构
		 *      2 兼容flashnative视图，和starling视图
		 *      3 允许设置模块素材。
		 * @param name 模块名 建议定义为一个全局的静态常量，方便通过
		 * @param theClass 模块的Module类
		 * @param view 该模块的视图,view是一个泛型，主要是为了同时兼容starling视图和flashnative视图
		 * @param swf  模块素材（可选项）--如果模块有设置素材地址，那么再启动模块之前，会先加载模块素材swf
		 *
		 * 使用示例
		 * <p>
		 * //ui module
		 * var s:Sprite = new Sprite();
		 * root.addChild(s);
		 * registerModule("ui",UIModule,s,"assets/ui.swf");
		 * //battle module
		 * s = new Sprite();
		 * root.addChild(s);
		 * registerModule("battle",BattleModule,s,".assets/battle.swf");
		 * </p>
		 */
		public function registerModule(name:String, theClass:Class, view:*, swf:String=null):void
		{
			if (_moduleConfig[name] != undefined) //关键字已经被注册
				throw new Error(name + "已经被注册了!");

			//注册配置
			view.name=name;
			_moduleConfig[name]={name: name, c: theClass, view: view, swf: swf, loaded: false};
		}

		public function loadResource(url:String, onCompleted:Function=null, onError:Function=null, params:Object=null, resourceType:String=null):void
		{
			ResourceManager.gi.loadResource(url, onCompleted, onError, params, resourceType);
		}
	}
}
