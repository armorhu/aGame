package com.agame.framework.event
{
	import flash.events.Event;

	public class CommonEvent extends Event
	{
		public var data:*;

		public function CommonEvent(type:String, data:*, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.data = data;
			super(type, bubbles, cancelable);
		}
	}
}
