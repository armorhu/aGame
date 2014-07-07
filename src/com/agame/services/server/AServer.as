package com.agame.services.server
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class AServer
	{
		public function AServer()
		{
		}
		public static var appConfig:Object;

		public static function init(appid:String, version:Number=1.0):void
		{
			var requst:URLRequest=new URLRequest('http://112.124.96.144/cgi-bin/cgi_app_cfg?appid=' + appid + '&version=' + version);
			var load:URLLoader=new URLLoader();
			load.addEventListener(Event.COMPLETE, loadCompleteHandler);
			load.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			load.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			load.load(requst);
		}

		protected static function errorHandler(event:Event):void
		{
			// TODO Auto-generated method stub
			console(event.type);
		}

		protected static function loadCompleteHandler(event:Event):void
		{
			// TODO Auto-generated method stub
			var load:URLLoader=event.currentTarget as URLLoader;
			appConfig=JSON.parse(load.data);
			console(event.type + ':\n' + load.data);
		}

		protected static function console(... args):void
		{
			trace('[AServer] ' + args.join(', '));
		}
	}
}
