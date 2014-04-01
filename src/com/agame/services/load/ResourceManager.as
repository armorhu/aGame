package com.agame.services.load
{
	import com.agame.services.load.events.LoaderEvent;
	import com.agame.services.load.resource.Resource;

	public class ResourceManager
	{
		private static var _instance:ResourceManager;

		/**
		 *加载器
		 */
		public static var loadManager:LoadManager;

		public static function get gi():ResourceManager
		{
			if (_instance == null)
				_instance=new ResourceManager;

			return _instance;
		}

		public function ResourceManager()
		{
			initLoaderManager();
		}

		private function initLoaderManager():void
		{
			if (loadManager != null)
				return;
			loadManager=new LoadManager;
			loadManager.maxThreadCount=4;
		}

		/**
		 * 异步加载资源，并回调
		 * @param url 资源url
		 * @param onCompleted 成功回调：可以把对应该的resouce作为参数，也可以不带参数
		 * @param onError 失败的回调，无参数
		 * @param params 自定的一些参数，只透传不处理，会动态附加在resource实例中
		 * @param type 是否指定加载的类型，默认不指定
		 */
		public function loadResource(url:String, onCompleted:Function=null, onError:Function=null, params:Object=null, resourceType:String=null):void
		{
//			var targetResource:Resource=findResource(url);
//			if (targetResource && targetResource.data && (resourceType ? (targetResource.type == resourceType) : true))
//			{
//				if (onCompleted != null)
//				{
//					(!onCompleted.length) ? onCompleted() : onCompleted(targetResource);
//				}
//				return;
//			}
//			if (!loadManager)
//			{
//				loadManager=new LoadManager();
//				loadManager.maxThreadCount=500;
//			}
			var succes:Function;
			var fault:Function;

			loadManager.addEventListener(LoaderEvent.COMPLETE, succes=function(e:LoaderEvent):void
			{
//				trace('success',e.item.url);
				if (e.item.url == url)
				{
					loadManager.removeEventListener(LoaderEvent.COMPLETE, arguments.callee);
					var temp:Resource; //=findResource(url);
					//正常情况下应该是相等的，但如果第一次加载发生了错误，第二次重试加载的Reasource实例会不相同，要重新添加
//					if (temp != e.item)
//					{
//						delete _dataList[url];
//						addResource(e.item);
//					}
					if (fault != null)
					{
						loadManager.removeEventListener(LoaderEvent.ERROR, fault);
					}
					if (onCompleted != null)
					{
						(!onCompleted.length) ? onCompleted() : onCompleted(e.item);
					}
				}
			});

			//			if(onError != null)
			//			{
			loadManager.addEventListener(LoaderEvent.ERROR, fault=function(e:LoaderEvent):void
			{
				if (e.item && e.item.url == url)
				{
					loadManager.removeEventListener(LoaderEvent.ERROR, arguments.callee);
					if (succes != null)
					{
						loadManager.removeEventListener(LoaderEvent.COMPLETE, succes);
					}
					if (onError != null)
						onError();
					else if (onCompleted != null)
					{
						e.item.data=null;
						(!onCompleted.length) ? onCompleted() : onCompleted(e.item);
					}
				}
			});
			//			}
			var newResource:Resource=loadManager.add(url, params);
			if (newResource)
			{
				if (resourceType)
				{
					newResource.type=resourceType;
				}
//				addResource(newResource);
				loadManager.start();
			}
		}
	}
}
