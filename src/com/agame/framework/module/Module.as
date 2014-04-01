package com.agame.framework.module
{
	import com.agame.framework.Application;

	public class Module
	{
		public var app:Application;
		public var name:String;
		public var layer:*;

		public function Module()
		{
		}

		public function startup(name:String, app:Application, layer:*):void
		{
			this.name=name;
			this.layer=layer;
			this.app=app;
			initliaze();
		}

		protected function initliaze():void
		{
		}

		public function dispose():void
		{
		}
	}
}
