//------------------------------------------------------------------------------------------
// <$begin$/>
// The MIT License (MIT)
//
// The "GX-Engine"
//
// Copyright (c) 2014 Jimmy Huey (wuey99@gmail.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
// <$end$/>
//------------------------------------------------------------------------------------------
package gx.external.cmpstar {
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	
	//------------------------------------------------------------------------------------------
	public class AdLoader extends flash.display.Sprite {
		private var cpmstarLoader:Loader;
		private var contentspotid:String;
		
		//------------------------------------------------------------------------------------------
		public function AdLoader (contentspotid:String) {
			super ();
			
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
			
			dispatchEvent (event);
		}
		
		//------------------------------------------------------------------------------------------
		private function onComplete(event:Event):void {
			trace (": onComplete: ", event);
			
			dispatchEvent (event);
		}
		
		//------------------------------------------------------------------------------------------
		private function onError(event:Event):void {
			trace (": onLoadingError: ", event);	
			
			dispatchEvent (event);
		}

	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}