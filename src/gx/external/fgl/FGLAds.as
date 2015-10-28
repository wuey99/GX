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
package gx.external.fgl {
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	
	//------------------------------------------------------------------------------------------
	/**
	 * <p>The FGLAds object is used to show ads! It's very simple.</p> 
	 * 
	 * <ul>
	 * <li> Copy <a href="http://flashgamedistribution.com/fglads/FGLAds.as">the FGLAds actionscript file</a> into your project. </li>
	 * <li> Call the constructor and pass it the stage and your game ID. You can find your FGL Ads ID on the FGD or FGL website.</li>	  
	 * <li> Add an event listener for the EVT_API_READY event. This fires when 
	 * everything's ready to go. It should take less than a second.</li> 
	 * <li> In the event handler, call FGLAds.api.showAdPopup(). By default, 
	 * it will show a 300x250 ad popup in the center of the game. The user 
	 * can close it after 3s.</li> 
	 * </ul>
	 * 
	 * <p><b>Example:</b></p>
	 * <p><code><pre>
	 * function myInitFunction():void {
	 *     FGLAds(stage, "FGL-EXAMPLE");
	 *     FGLAds.api.addEventListener(EVT_API_READY, onAdsReady);
	 * }
	 * 
	 * function onAdsReady(e:Event):void {
	 *     FGLAds.api.showAdPopup();
	 * }
	 * </pre></code></p>
	 * 
	 * <p>That's it for now. We'll have more ad formats and more ways to load them soon!</p>
	 * 
	 */
	//------------------------------------------------------------------------------------------
	
	//------------------------------------------------------------------------------------------
	public class FGLAds extends Sprite {
		public static const version:String = "01";
		
		//singleton var
		/**@private*/protected static var _instance:FGLAds;
		
		//status vars
		private var _status:String = "Loading";
		private var _loaded:Boolean = false;
		private var _stageWidth:Number = 550;
		private var _stageHeight:Number = 400;
		private var _inUse:Boolean = false;
		
		//swf loading vars
		private var _referer:String = "";
		private var _loader:Loader = new Loader();
		private var _context:LoaderContext = new LoaderContext(true);
		private var _tmpSkin:Object = new Object();
		
		//live URL
		private var _request:URLRequest = new URLRequest("http://ads.fgl.com/swf/FGLAds." + version + ".swf");
		
		//event handlers
		private var _evt_NetworkingError:Function = null;
		private var _evt_ApiReady:Function = null;
		private var _evt_AdLoaded:Function = null;
		private var _evt_AdShown:Function = null;
		private var _evt_AdClicked:Function = null;
		private var _evt_AdClosed:Function = null;
		private var _evt_AdUnavailable:Function = null;
		private var _evt_AdLoadingError:Function = null;
		
		//event types
		public static const EVT_NETWORKING_ERROR:String = "networking_error";
		public static const EVT_API_READY:String = "api_ready";
		public static const EVT_AD_LOADED:String = "ad_loaded";
		public static const EVT_AD_SHOWN:String = "ad_shown";
		public static const EVT_AD_CLOSED:String = "ad_closed";
		public static const EVT_AD_CLICKED:String = "ad_clicked";
		public static const EVT_AD_UNAVAILABLE:String = "ad_unavailable";
		public static const EVT_AD_LOADING_ERROR:String = "ad_loading_error";
		
		//ad formats
		public static const FORMAT_AUTO:String = "format_auto";
		public static const FORMAT_640x440:String = "640x440";
		public static const FORMAT_300x250:String = "300x250";
		public static const FORMAT_90x90:String = "90x90";
		
		//display objects
		private var _fglAds:Object;
		private var _stage:Stage;
		
		//------------------------------------------------------------------------------------------
		/**
		 * FGLAds constructor.<br />
		 * Important Note: You must only create one instance of the FGLAds object in your project.
		 * If you try to create a second instance, it will not initiate properly and a message will be
		 * logged to the output console (trace())
		 * 
		 * @param parent It is imperative that the parent object that you pass to the FGLAds constructor
		 * is either Sprite, MovieClip or Stage.
		 * @param gameID The game's ID, as issued on the FGL or FGD website.
		 */
		//------------------------------------------------------------------------------------------
		public function FGLAds (parent:*, gameID:String):void {
			super ();
			
			if(_instance == null) {
				_instance = this;
			} else {
				trace("FGLAds: Instance Error: The FGLAds class is a singleton and should only be constructed once. Use FGLAds.api to access it after it has been constructed.");
				return;
			}
			
			_storedGameID = gameID;
			
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			_context.applicationDomain = ApplicationDomain.currentDomain;
			
			//download client library
			_status = "Downloading";
			try {
				_loader.load(_request, _context);
				_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadingError);
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadingComplete);
			} catch(e:Error) {
				_status = "Failed";
				trace("FGLAds: SecurityError: cannot load client library");
				_loader = null;
			}
			
			addEventListener(Event.ADDED_TO_STAGE, setupStage);
			if(parent is Sprite || parent is MovieClip || parent is Stage)
			{
				parent.addChild(this);
			} else {
				trace("FGLAds: Incompatible parent! Parent must be a Sprite, MovieClip, or Stage");
			}				
		}
		
		//------------------------------------------------------------------------------------------
		/**
		 * The api variable allows you to access your instance of FGL Ads from anywhere in your code.<br />
		 * After constructing the FGLAds object, one of the easiest ways of accessing the API functionality
		 * is by using FGLAds.api.
		 * 
		 * You can access all of the functions that you need by using FGLAds.api, and because it
		 * is static, it can be accessed anywhere from within your code.
		 * 
		 * You MUST initiate one instance of the FGLAds class using the code provided from the website
		 * before trying to access this api variable. If the FGLAds object has not been initiated then
		 * this variable will return null.
		 */	
		//------------------------------------------------------------------------------------------
		/* @:get, set api FGLAds */
		
		public static function get api ():FGLAds {
			if(_instance == null) {
				trace("FGLAds: Instance Error: Attempted to get instance before construction.");
				return null;
			}
			return _instance;
		}
		
		public function set api (__val:FGLAds): /* @:set_type */ void {
			/* @:set_return null; */			
		}
		
		/* @:end */
		/**
		 * Displays an ad popup that appears over the current swf and lowers the lights.
		 * @param format the format of the ad to request, use one of the FORMAT_ constants.
		 * @param delay how long before they can close the ad
		 * @param timeout how long before the ad closes itself
		 */
		//------------------------------------------------------------------------------------------
		public function showAdPopup (format:String = FGLAds.FORMAT_AUTO, delay:Number = 3000, timeout:Number = 0):void {
			if(_loaded == false) return;
			_fglAds.showAdPopup(format, delay, timeout);
		}
		
		//------------------------------------------------------------------------------------------
		/**
		 * The status variable allows you to determine the current
		 * status of the API. This can be any of the following:
		 * <ul>
		 * <li>Loading</li>
		 * <li>Downloading</li>
		 * <li>Ready</li>
		 * <li>Failed</li>
		 * </ul>
		 */
		//------------------------------------------------------------------------------------------
		/* @:get, set status String */
		
		public function get status ():String {
			return _status;
		}		
		
		public function set status (__val:String): /* @:set_type */ void {
			/* @:set_return ""; */			
		}
		/* @:end */	
		
		//------------------------------------------------------------------------------------------
		/**
		 * Returns true if the API has been initialised by the constructor. If this returns false, you need to
		 * call new FGLAds(stage) - passing the stage or root displayobject in. 
		 */
		//------------------------------------------------------------------------------------------
		/* @:get, set apiLoaded Bool */
		
		public static function get apiLoaded ():Boolean {
			return _instance != null;
		}
		
		public static function set apiLoaded (__val:Boolean): /* @:set_type */ void {
			/* @:set_return true; */			
		}
		/* @:end */
		
		//------------------------------------------------------------------------------------------
		/**
		 * Disable the API. This will stop FGLAds from processing any requests. Use enable() to re-enable the API.
		 */
		//------------------------------------------------------------------------------------------
		public function disable ():void {
			if(_status == "Ready"){
				_status = "Disabled";
				_loaded = false;
			}
		}		
		
		//------------------------------------------------------------------------------------------
		/**
		 * Re-enables the API if it's been disabled using the disable() function.
		 */
		//------------------------------------------------------------------------------------------
		public function enable ():void {
			if(_status == "Disabled"){
				_status = "Ready";
				_loaded = true;
			}
		}
		
		//------------------------------------------------------------------------------------------
		/**
		 * setStyle should be used to set the global theme settings. The acceptable values for <b>name</b> are:
		 * <ul>
		 * 	<li>backgroundColor</li>
		 * 	<li>backgroundAlpha</li>
		 * 	<li>borderColor</li>
		 *	<li>borderWidth</li>
		 * 	<li>cornerRadius</li>
		 * 	<li>foregroundColor</li>
		 * 	<li>foregroundAlpha</li>
		 * 	<li>middlegroundColor</li>
		 * 	<li>middlegroundAlpha</li>
		 *  <li>dropShadowColor</li>
		 *  <li>dropShadowAlpha</li>
		 * 	<li>fadeColor</li>
		 *  <li>fadeAlpha</li>
		 * </ul> 
		 */
		//------------------------------------------------------------------------------------------
		public function setStyle (name:String, value:*):void {
			if(_loaded == false){
				_tmpSkin[name] = value;
				return;
			}
			var o:Object = new Object ();
			o[name] = value;
			_fglAds.setSkin(o);
		}
		
		//------------------------------------------------------------------------------------------
		// Event handling...
		//------------------------------------------------------------------------------------------
		
		//------------------------------------------------------------------------------------------
		/* @:get, set a Float */
		
		public function get onNetworkingError ():Function {
			return _evt_NetworkingError;
		}
		
		public function set onNetworkingError (func:Function): /* @:set_type */ void {
			_evt_NetworkingError = func; 
			
			/* @:set_return null; */			
		}
		/* @:end */
		
		//------------------------------------------------------------------------------------------
		private function e_onNetworkingError (e:Event):void {
			if(_evt_NetworkingError != null) _evt_NetworkingError();
			dispatchEvent(e);
		}
		
		//------------------------------------------------------------------------------------------
		/* @:get, set onApiReady Function */
		
		public function get onApiReady ():Function {
			return _evt_ApiReady;
		}
		
		public function set onApiReady (func:Function): /* @:set_type */ void {
			_evt_ApiReady = func;
			
			/* @:set_return null; */			
		}
		/* @:end */
		
		//------------------------------------------------------------------------------------------
		private function e_onApiReady (e:Event):void {
			if(_evt_ApiReady != null) _evt_ApiReady();
			dispatchEvent(e);
		}
		
		//------------------------------------------------------------------------------------------
		/* @:get, set onAdLoaded Function */
		
		public function get onAdLoaded ():Function {
			return _evt_AdLoaded;
		}
		
		public function set onAdLoaded (func:Function): /* @:set_type */ void {
			_evt_AdLoaded = func;
			
			/* @:set_return null; */			
		}
		/* @:end */
		
		//------------------------------------------------------------------------------------------
		private function e_onAdLoaded (e:Event):void {
			if(_evt_AdLoaded != null) _evt_AdLoaded();
			dispatchEvent(e);
		}
		
		//------------------------------------------------------------------------------------------
		/* @:get, set onAdShown Function */
		
		public function get onAdShown ():Function {
			return _evt_AdShown;
		}
		
		public function set onAdShown (func:Function): /* @:set_type */ void {
			_evt_AdShown = func;
			
			/* @:set_return null; */			
		}
		/* @:end */
		
		//------------------------------------------------------------------------------------------
		private function e_onAdShown (e:Event):void {
			if(_evt_AdShown != null) _evt_AdShown();
			dispatchEvent(e);
		}
		
		//------------------------------------------------------------------------------------------
		/* @:get, set onAdClicked Function */
		
		public function get onAdClicked ():Function {
			return _evt_AdClicked;
		}
		
		public function set onAdClicked (func:Function): /* @:set_type */ void {
			_evt_AdClicked = func;
			
			/* @:set_return null; */			
		}
		/* @:end */
		
		//------------------------------------------------------------------------------------------
		private function e_onAdClicked (e:Event):void {
			if(_evt_AdClicked != null) _evt_AdClicked();
			dispatchEvent(e);
		}
		
		//------------------------------------------------------------------------------------------
		/* @:get, set onAdClosed Function */
		
		public function get onAdClosed ():Function {
			return _evt_AdClosed;
		}
		
		public function set onAdClosed (func:Function): /* @:set_type */ void {
			_evt_AdClosed = func;
			
			/* @:set_return null; */			
		}
		/* @:end */
		
		//------------------------------------------------------------------------------------------
		private function e_onAdClosed (e:Event):void {
			if(_evt_AdClosed != null) _evt_AdClosed();
			dispatchEvent(e);
		}
		
		//------------------------------------------------------------------------------------------
		/* @:get, set onAdUnavailable Function */
		
		public function get onAdUnavailable ():Function {
			return _evt_AdUnavailable;
		}
		
		public function set onAdUnavailable (func:Function): /* @:set_type */ void {
			_evt_AdUnavailable = func;
			
			/* @:set_return null; */			
		}
		/* @:end */
		
		//------------------------------------------------------------------------------------------
		private function e_onAdUnavailable (e:Event):void {
			if(_evt_AdUnavailable != null) _evt_AdUnavailable();
			dispatchEvent(e);
		}
		
		//------------------------------------------------------------------------------------------
		/* @:get, set onAdLoadingError Function */
		
		public function get onAdLoadingError ():Function {
			return _evt_AdLoadingError;
		}
		
		public function set onAdLoadingError (func:Function): /* @:set_type */ void {
			_evt_AdLoadingError = func;
			
			/* @:set_return null; */			
		}
		/* @:end */
		
		//------------------------------------------------------------------------------------------
		private function e_onAdLoadingError (e:Event):void {
			if(_evt_AdLoadingError != null) _evt_AdLoadingError();
			dispatchEvent(e);
		}
		
		//------------------------------------------------------------------------------------------
		/* Internal Functions */
		//------------------------------------------------------------------------------------------
		
		//------------------------------------------------------------------------------------------
		private function resizeStage (e:Event):void {
			if(_loaded == false) return;
			_stageWidth = _stage.stageWidth;
			_stageHeight = _stage.stageHeight;
			_fglAds.componentWidth = _stageWidth;
			_fglAds.componentHeight = _stageHeight;
		}
		
		//------------------------------------------------------------------------------------------
		private function setupStage (e:Event):void {
			if(stage == null) return;
			_stage = stage;
			_stage.addEventListener(Event.RESIZE, resizeStage);
			_stageWidth = stage.stageWidth;
			_stageHeight = stage.stageHeight;
			if(root != null) {
				_referer = root.loaderInfo.loaderURL;
			}
			if(_loaded){
				_fglAds.componentWidth = _stageWidth;
				_fglAds.componentHeight = _stageHeight;
				_stage.addChild(_fglAds as Sprite);
			}
		}
		
		//------------------------------------------------------------------------------------------
		private function onLoadingComplete (e:Event):void {
			_status = "Ready";
			_loaded = true;
			_fglAds = _loader.content as Object;
			_fglAds.componentWidth = _stageWidth;
			_fglAds.componentHeight = _stageHeight;
			_fglAds.setSkin(_tmpSkin);
			
			_fglAds.addEventListener(EVT_NETWORKING_ERROR, e_onNetworkingError);
			_fglAds.addEventListener(EVT_API_READY, e_onApiReady);
			_fglAds.addEventListener(EVT_AD_LOADED, e_onAdLoaded);
			_fglAds.addEventListener(EVT_AD_SHOWN, e_onAdShown);
			_fglAds.addEventListener(EVT_AD_CLICKED, e_onAdClicked);
			_fglAds.addEventListener(EVT_AD_CLOSED, e_onAdClosed);
			_fglAds.addEventListener(EVT_AD_UNAVAILABLE, e_onAdUnavailable);			
			_fglAds.addEventListener(EVT_AD_LOADING_ERROR, e_onAdLoadingError);
			
			if(_stage != null){
				_stage.addChild(_fglAds as Sprite);
			}
			
			if(root != null){
				_referer = root.loaderInfo.loaderURL
			}
			
			_fglAds.init(_stage, _referer, _storedGameID);
		}
		
		//------------------------------------------------------------------------------------------
		private function onLoadingError (e:IOErrorEvent):void {
			_loaded = false;
			_status = "Failed";
			trace("FGLAds: Failed to load client SWF");				
		}

		//------------------------------------------------------------------------------------------
		private var _storedGameID:String = "";
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}