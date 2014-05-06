package GX.External.CPMStar {
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	
	//------------------------------------------------------------------------------------------
	public class AdLoader extends flash.display.Sprite {
		private var cpmstarLoader:Loader;
		private var contentspotid:String;
		
		//------------------------------------------------------------------------------------------
		public function AdLoader(contentspotid:String) {
			this.contentspotid = contentspotid;
			
			addEventListener(Event.ADDED, addedHandler);
		}
		
		//------------------------------------------------------------------------------------------
		private function addedHandler(event:Event):void {
			removeEventListener (Event.ADDED, addedHandler);	
			
			Security.allowDomain ("server.cpmstar.com");
			
			var cpmstarViewSWFUrl:String = "http://server.cpmstar.com/adviewas3.swf";
			
			try {
				cpmstarLoader = new Loader();
				cpmstarLoader.contentLoaderInfo.addEventListener (Event.INIT, onInit);
				cpmstarLoader.contentLoaderInfo.addEventListener (Event.COMPLETE, onComplete);
				cpmstarLoader.contentLoaderInfo.addEventListener (IOErrorEvent.IO_ERROR, onError);
				cpmstarLoader.load (new URLRequest (cpmstarViewSWFUrl + "?contentspotid="+contentspotid));
				
				addChild (cpmstarLoader);
			}
			catch(e:Error) {
				trace (": loading Error: ", e);
			}
		}
		
		//------------------------------------------------------------------------------------------
		private function onInit(event:Event):void {
			trace (": onInit: ", event);
		}
		
		//------------------------------------------------------------------------------------------
		private function onComplete(event:Event):void {
			trace (": onComplete: ", event);
		}
		
		//------------------------------------------------------------------------------------------
		private function onError(event:Event):void {
			trace (": onLoadingError: ", event);	
		}

	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}