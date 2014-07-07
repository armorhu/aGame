package com.agame.framework.module
{
	import com.agame.framework.Application;
	import com.agame.services.load.resource.Resource;
	
	import flash.events.EventDispatcher;

	public class Module extends EventDispatcher implements IModule
	{
		protected var _name:String; //模块名

		protected var _app:Application;

		protected var _container:*; //显示对象

		/**
		 * 模块api的注册表
		 */
		protected var _registerAPI:Object;
		
		public var res:Resource;

		public function Module(name:String)
		{
			_name=name;
		}

		/**
		 * 模块启动
		 * @param app
		 * @param container
		 */
		public function startup(app:Application, container:*, resource:Resource=null):void
		{
			trace("[Module:" + _name + "]::startup...");
			_app=app;
			_container=container;
			res = resource;
			initController();
		}

		/**
		 * 初始化Controller
		 * 交给子类来完成
		 */
		protected function initController():void
		{
			//implements by sub class
			throw new Error("pls implements by sub class");
		}

		public function executeWithProtocol(protocol:ModuleAPIProtocol):void
		{
			if (protocol.moduleName != this.name || !_registerAPI)
			{
				return;
			}

			for (var i:String in _registerAPI)
			{
				if (i == protocol.apiName)
				{
					var f:Function=_registerAPI[i] as Function;
					f.apply(this, protocol.params);

					break;
				}
			}
		}

		/**
		 * 注册API
		 * @param apiName api的名称
		 * @param handler 真正执行的函数
		 *
		 */
		protected function registerAPI(apiName:String, handler:Function):void
		{
			if (!_registerAPI)
			{
				_registerAPI={};
			}

			_registerAPI[apiName]=handler;
		}

		/**
		 * 销毁模块
		 */
		public function destroy():void
		{
			_app=null;
			_container=null;
			_registerAPI=null;
		}

		public function onGameLoop(elapsed:Number):void
		{
		}

		public function sleep():void
		{

		}

		public function revoke():void
		{

		}

		public function get name():String
		{
			return _name;
		}

		public function get container():*
		{
			return _container;
		}

		public function get mouduleAPI():IModuleAPI
		{
			return null;
		}
	}
}
