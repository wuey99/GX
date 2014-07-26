//------------------------------------------------------------------------------------------
package
{
	
// app
	import GX.Assets.*;
	import GX.Hud.*;
	import GX.Levels.*;
	import GX.Messages.*;
	import GX.Messages.Level.*;
	import GX.Mickey.*;
	import GX.Music.*;
	import GX.Text.*;
	
	import X.*;
	import X.Bitmap.XBitmapDataAnim;
	import X.Collections.*;
	import X.Game.*;
	import X.Geom.*;
	import X.Keyboard.*;
	import X.Resource.*;
	import X.Signals.XSignal;
	import X.Task.*;
	import X.Texture.*;
	import X.World.*;
	import X.World.Logic.*;
	import X.XML.*;
	import X.XMap.*;
	
	import flash.external.*;
	import flash.net.*;
	import flash.ui.*;
	import flash.utils.*;
	
	include "flash.h";
	
//------------------------------------------------------------------------------------------
	public class GApp extends Sprite {
		public var m_XApp:XApp;
		public var xxx:XWorld;
		public var m_app:GApp;
		public var m_assets:XAssets;
		public var m_mickeyObject:_MickeyX;
		public var m_mickeyCursorObject:_MickeyCursorX;;
		public var m_levelObject:_LevelX;
		public var m_gameHudObject:_HudX;
		public var m_hudObject:XLogicObject;
		public var m_hudMessageObject:HudMessageX;
		public var PLAYFIELD_LAYER:Number = 0;
		public var m_gameState:Number;
		public var m_levelData:*;
		public var m_levelName:String;
		public var m_levelComplete:Boolean;	
		public var m_currentZone:Number;
		
		public var m_setMickeyToStartSignal:XSignal;
		public var m_zoneStartedSignal:XSignal;
		public var m_zoneFinishedSignal:XSignal;
		public var m_mickeyDeathSignal:XSignal;
		public var m_triggerSignal:XSignal;
		public var m_trigger$Signal:XSignal;
		public var m_pingSignal:XSignal;
		
		public var m_player:XFlod;
		
		private var m_globalTextureManager:XSubTextureManager;
		
		//------------------------------------------------------------------------------------------
		public function GApp () {	
			trace (": starting: ");
		}
		
		//------------------------------------------------------------------------------------------
		public function setup (__assetsClass:Class, __mickeyClass:Class, __parent:*, __timerInterval:Number=32):void {	
			m_app = this;
			
			m_XApp = new XApp ();
			m_XApp.setup (m_XApp.getDefaultPoolSettings ());
			
			xxx = new XWorld (__parent, m_XApp, 4, __timerInterval);
			addChild (xxx);
			
			setupMask ();
			
			xxx.setViewRect (704, 576);
			
			xxx.grabFocus ();
			
			m_assets = new __assetsClass (m_XApp, __parent);
			m_assets.load ();
		
			GX.setup (this, m_XApp);
			
			m_player = xxx.getXLogicManager ().initXLogicObject (
				// parent
				null,
				// logicObject
				new XFlod () as XLogicObject,
				// item, layer, depth
				null, 0, 0,
				// x, y, z
				0, 0, 0,
				// scale, rotation
				1.0, 0
			) as XFlod;
		}
		
		//------------------------------------------------------------------------------------------
		public function getWorld ():XWorld {
			return xxx;
		}
		
		//------------------------------------------------------------------------------------------
		public function setupSignals ():void {
			m_setMickeyToStartSignal = new XSignal ();
			m_zoneStartedSignal = new XSignal ();
			m_zoneFinishedSignal = new XSignal ();
			m_triggerSignal = new XSignal ();
			m_trigger$Signal = new XSignal ();
			m_pingSignal = new XSignal ();
		}

		//------------------------------------------------------------------------------------------
		public function initGame ():void {
		}
		
		//------------------------------------------------------------------------------------------
		public function initLevel (__levelName:String):void {
		}
		
		//------------------------------------------------------------------------------------------
		public var m_mask:Sprite;
		
		//------------------------------------------------------------------------------------------
		public function setupMask ():void {
			if (CONFIG::starling) {
			}
			else
			{
				m_mask = new flash.display.Sprite ();
				m_mask.mouseEnabled = false;
				m_mask.mouseChildren = false;
				
				m_mask.graphics.beginFill (0x000000);
				m_mask.graphics.drawRect (0, 0, 700, 550);
				
				addChild (m_mask);
				
				setMaskAlpha (1.0);
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function getMaskAlpha ():Number {
			if (CONFIG::starling) {
				return 1.0;
			}
			else
			{
				return 1.0 - m_mask.alpha;
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function setMaskAlpha (__alpha:Number):void {
			if (CONFIG::starling) {
			}
			else
			{
				m_mask.alpha = 1.0 - Math.min (1.0, __alpha);
			}
		}

		//------------------------------------------------------------------------------------------
		public function cacheAllMovieClips ():void {
			if (CONFIG::flash) {
				return;
			}
			
			var t:XSubTextureManager = m_globalTextureManager = xxx.getTextureManager ().createSubManager ("__global__");
			
			t.start ();
			
			m_XApp.getAllClassNames ().forEach (
				function (x:*):void {
					t.add (x as String);					
				}
			);
			
			t.finish ();
		}
		
		//------------------------------------------------------------------------------------------
		public function addXShake (__count:Number=15, __delayValue:Number=0x0100):void {
			m_levelObject.addXShake (__count, __delayValue);
		}
		
		//------------------------------------------------------------------------------------------
		public function addYShake (__count:Number=15, __delayValue:Number=0x0100):void {
			m_levelObject.addYShake (__count, __delayValue);
		}
		
		//------------------------------------------------------------------------------------------
		public function get player ():XFlod {
			return m_player;
		}
		
		//------------------------------------------------------------------------------------------
		public function Null_HndlrX ():XLogicObject {
			return null;
		}
		
		//------------------------------------------------------------------------------------------
		public function logicClassNameToClass (__logicClassName:String):* {
			return null;
		}
		
		//------------------------------------------------------------------------------------------
		public function getLevelComplete ():Boolean {
			return m_levelComplete;
		}
		
		//------------------------------------------------------------------------------------------
		public function getLevelData (__levelName:String):* {
			return null;
		}
		
		//------------------------------------------------------------------------------------------
		public function initHudLayerObject ():void {		
			m_hudObject = xxx.getXLogicManager ().initXLogicObject (
				// parent
				null,
				// logicObject
				new XLogicObject () as XLogicObject,
				// item, layer, depth
				null, -1, 25000,
				// x, y, z
				0, 0, 0,
				// scale, rotation
				1.0, 0
			) as XLogicObject;
			
			m_hudObject.show ();
		}
		
		//------------------------------------------------------------------------------------------
		public function getHudObject ():XLogicObject {
			return m_hudObject;
		}
		
		//------------------------------------------------------------------------------------------
		public function getGameHudObject ():XLogicObject {
			return m_gameHudObject;
		}
		
		//------------------------------------------------------------------------------------------
		public function getHudMessageObject ():HudMessageX {
			return m_hudMessageObject;
		}
		
		//------------------------------------------------------------------------------------------
		public function getLevelObject ():_LevelX {
			return m_levelObject;
		}
		
		//------------------------------------------------------------------------------------------
		public function getLevelLayer (__layer:Number):XMapView { // XMapLayerView
			return m_levelObject;
		}

		//------------------------------------------------------------------------------------------
		public function setBGMVolume (__volume:Number):void {
			m_player.setVolume (__volume);
		}

		//------------------------------------------------------------------------------------------
		public function getBGMVolume ():Number {
			return m_player.getVolume ();
		}
		
		//------------------------------------------------------------------------------------------
		public function setSFXVolume (__volume:Number):void {
			xxx.getSoundManager ().setSFXVolume (__volume);
		}
		
		//------------------------------------------------------------------------------------------
		public function getSFXVolume ():Number {
			return xxx.getSoundManager ().getSFXVolume ();
		}
		
		//------------------------------------------------------------------------------------------
		public function setupMickey (__mickey:_MickeyX):void {
			var __x:Number = 2536-256;
			var __y:Number = 2536+256;
			
			m_mickeyObject = xxx.getXLogicManager ().initXLogicObject (
				// parent
				null,
				// logicObject
				__mickey as XLogicObject,
				// item, layer, depth
				null, PLAYFIELD_LAYER, 10000,
				// x, y, z
				__x, __y, 0,
				// scale, rotation
				1.0, 0,
				m_mickeyCursorObject
			) as _MickeyX;
		}
		
		//------------------------------------------------------------------------------------------
		public function initCursor ():void {
			var __x:Number;
			var __y:Number;
			
			__x = 0;
			__y = 0;
			
			m_mickeyCursorObject = xxx.getXLogicManager ().initXLogicObject (
				// parent
				null,
				// logicObject
				new _MickeyCursorX () as XLogicObject,
				// item, layer, depth
				null, PLAYFIELD_LAYER, 10000,
				// x, y, z
				__x, __y, 0,
				// scale, rotation
				1.0, 0
			) as _MickeyCursorX;
		}
		
		//------------------------------------------------------------------------------------------
		public function __getMickeyCursorObject ():_MickeyCursorX {
			return m_mickeyCursorObject;	
		}
		
		//------------------------------------------------------------------------------------------
		public function __getMickeyObject ():_MickeyX {
			return m_mickeyObject;
		}
		
		//------------------------------------------------------------------------------------------
		public function setMickeyMessage (__message:String):void {
			m_mickeyObject.setMessage (__message);
		}
		
		//------------------------------------------------------------------------------------------
		public function setCurrentZone (__zone:Number):void {
		}
		
		//------------------------------------------------------------------------------------------
		public function getCurrentZone ():Number {
			return m_currentZone;
		}

		//------------------------------------------------------------------------------------------
		public function addZoneStartedListener (__function:Function):void {
			m_zoneStartedSignal.addListener (__function);
		}
		
		//------------------------------------------------------------------------------------------
		public function removeZoneStartedListener (__function:Function):void {
			m_zoneStartedSignal.removeListener (__function);
		}
		
		//------------------------------------------------------------------------------------------
		public function fireZoneStartedSignal ():void {
			m_zoneStartedSignal.fireSignal (getCurrentZone ());
		}
		
		//------------------------------------------------------------------------------------------
		public function addZoneFinishedListener (__function:Function):void {
			m_zoneFinishedSignal.addListener (__function);
		}
		
		//------------------------------------------------------------------------------------------
		public function removeZoneFinishedListener (__function:Function):void {
			m_zoneFinishedSignal.removeListener (__function);
		}
		
		//------------------------------------------------------------------------------------------
		public function fireZoneFinishedSignal ():void {
			m_zoneFinishedSignal.fireSignal (getCurrentZone ());
		}
		
		//------------------------------------------------------------------------------------------
		public function fireMickeyDeathSignal (__trigger:Number):void {
			m_mickeyDeathSignal.fireSignal (__trigger);
		}
		
		//------------------------------------------------------------------------------------------
		public function addMickeyDeathListener (__listener:Function):void {
			m_mickeyDeathSignal.addListener (__listener);
		}
		
		//------------------------------------------------------------------------------------------
		public function removeMickeyDeathListener (__listener:Function):void {
			m_mickeyDeathSignal.removeListener (__listener);
		}
		
		//------------------------------------------------------------------------------------------
		public function addMickeyPlayingListener (__listener:Function):void {
			GX.app$.__getMickeyObject ().addPlayingListener (__listener);
		}
		
		//------------------------------------------------------------------------------------------
		public function removeMickeyPlayingListener (__listener:Function):void {
			GX.app$.__getMickeyObject ().removePlayingListener (__listener);
		}

		//------------------------------------------------------------------------------------------
		public function fireTriggerSignal (__trigger:Number):void {
			m_triggerSignal.fireSignal (__trigger);
		}
		
		//------------------------------------------------------------------------------------------
		public function addTriggerListener (__listener:Function):void {
			m_triggerSignal.addListener (__listener);
		}
		
		//------------------------------------------------------------------------------------------
		public function removeTriggerListener (__listener:Function):void {
			m_triggerSignal.removeListener (__listener);
		}
		
		//------------------------------------------------------------------------------------------
		public function fireTrigger$Signal (__trigger:String):void {
			m_trigger$Signal.fireSignal (__trigger);
		}
		
		//------------------------------------------------------------------------------------------
		public function addTrigger$Listener (__listener:Function):void {
			m_trigger$Signal.addListener (__listener);
		}
		
		//------------------------------------------------------------------------------------------
		public function removeTrigger$Listener (__listener:Function):void {
			m_trigger$Signal.removeListener (__listener);
		}
		
		//------------------------------------------------------------------------------------------
		public function addPingListener (__listener:Function):void {
			m_pingSignal.addListener (__listener);
		}
		
		//------------------------------------------------------------------------------------------
		public function removePingListener (__listener:Function):void {
			m_pingSignal.removeListener (__listener);
		}

		//------------------------------------------------------------------------------------------
		public function firePingSignal (
			__id:Number,
			__type:String,
			__logicObject:XLogicObject,
			__callback:Function
		):void {
			m_pingSignal.fireSignal (__id, __type, __logicObject, __callback);
		}
		
		//------------------------------------------------------------------------------------------
		public function getSmallFontName ():String {
			return "SmallHiresFont:SmallHiresFont";	
		}
		
		//------------------------------------------------------------------------------------------
		public function openURLInBrowser (__url:String):void {
			var __request:URLRequest = new URLRequest (__url);
			
			__request.method = URLRequestMethod.POST;
			
			navigateToURL (__request, "_blank");	
		}
		
		//------------------------------------------------------------------------------------------
		public  function openURLInBrowserWithJavascript (url:*, window:String = "_blank", specs:String=""):void {
			var req:URLRequest = url is String ? new URLRequest(url) : url;
			if (!ExternalInterface.available) {
				navigateToURL(req, window);
			} else {
				var strUserAgent:String = String(ExternalInterface.call("function() {return navigator.userAgent;}")).toLowerCase();
				if (strUserAgent.indexOf("firefox") != -1 || (strUserAgent.indexOf("msie") != -1 && uint(strUserAgent.substr(strUserAgent.indexOf("msie") + 5, 3)) >= 7)) {
					ExternalInterface.call("window.open", req.url, window, specs);
				} else {
					navigateToURL(req, window);
				}
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function getNetworkingRestriction():String {
			
			var result:String = "all"; // default level
			
			try {
				// first try SharedObject.  If it throws a SecurityError, then allowNetworking="none"
				SharedObject.getLocal("test"); 
				
				try {
					// SharedObject didn't throw a SecurityError. 
					//If ExternalInterface.call() throws a SecurityError then allowNetworking="internal"
					ExternalInterface.call(""); 
				}
				catch (e:SecurityError) {
					result = "internal";
				}
				
			}
			catch (e:SecurityError) {
				result = "none";        
			}
			
			return result;
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}