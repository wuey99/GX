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
package
{
	
// GX
	import GX.Assets.*;
	import GX.Hud.*;
	import GX.Levels.*;
	import GX.Messages.*;
	import GX.Messages.Level.*;
	import GX.Mickey.*;
	import GX.Music.*;
	import GX.Text.*;
	import GX.Zone.*;
// X
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
// flash
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
		
		protected var m_lives:Number;
		protected var m_livesChangedSignal:XSignal;
		
		private var m_zoneManager:ZoneManager;
		
		protected var m_paused:Boolean;
		protected var m_pausedObject:XLogicObject;
		
		public var m_XTaskSubManager:XTaskSubManager;
		
		public var script:XTask;
		
		//------------------------------------------------------------------------------------------
		public function GApp () {	
			trace (": starting: ");
		}
		
		//------------------------------------------------------------------------------------------
		public function setup (__assetsClass:Class, __mickeyClass:Class, __parent:*, __timerInterval:Number=32, __layers:Number=4):void {	
			m_app = this;
			
			m_XApp = new XApp ();
			m_XApp.setup (m_XApp.getDefaultPoolSettings ());
			
			xxx = new XWorld (__parent, m_XApp, __layers, __timerInterval);
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
			
			m_livesChangedSignal = new XSignal ();
			
			m_zoneManager = new ZoneManager ();
			
			m_XTaskSubManager = new XTaskSubManager (m_XApp.getXTaskManager ());
			
			script = addEmptyTask ();
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
		public function addTask (
			__taskList:Array,
			__findLabelsFlag:Boolean = true
		):XTask {
			
			var __task:XTask = m_XTaskSubManager.addTask (__taskList, __findLabelsFlag);
			
			__task.setParent (this);
			
			return __task;
		}
		
		//------------------------------------------------------------------------------------------
		public function changeTask (
			__task:XTask,
			__taskList:Array,
			__findLabelsFlag:Boolean = true
		):XTask {
			
			return m_XTaskSubManager.changeTask (__task, __taskList, __findLabelsFlag);
		}
		
		//------------------------------------------------------------------------------------------
		public function isTask (__task:XTask):Boolean {
			return m_XTaskSubManager.isTask (__task);
		}		
		
		//------------------------------------------------------------------------------------------
		public function removeTask (__task:XTask):void {
			m_XTaskSubManager.removeTask (__task);	
		}
		
		//------------------------------------------------------------------------------------------
		public function removeAllTasks ():void {
			m_XTaskSubManager.removeAllTasks ();
		}
		
		//------------------------------------------------------------------------------------------
		public function addEmptyTask ():XTask {
			return m_XTaskSubManager.addEmptyTask ();
		}
		
		//------------------------------------------------------------------------------------------
		public function getEmptyTask$ ():Array {
			return m_XTaskSubManager.getEmptyTask$ ();
		}	
		
		//------------------------------------------------------------------------------------------
		public function gotoLogic (__logic:Function):void {
			m_XTaskSubManager.gotoLogic (__logic);
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
		public function togglePauseGame ():void {	
		}
		
		//------------------------------------------------------------------------------------------
		public function pauseGame ():void {		
		}
		
		//------------------------------------------------------------------------------------------
		public function unpauseGame ():void {			
		}
		
		//------------------------------------------------------------------------------------------
		public function quitGame ():void {	
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
		public function setMickeyObject (__mickeyObject:_MickeyX):void {
			m_mickeyObject = __mickeyObject;
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
		public function getZoneManager ():ZoneManager {
			return m_zoneManager;
		}
		
		//------------------------------------------------------------------------------------------
		public function getCurrentZone ():Number {
			return m_currentZone;
		}

		//------------------------------------------------------------------------------------------
		public function setCurrentZone (__zone:Number):void {
			getZoneManager ().setCurrentZone (__zone);
		}
		
		//------------------------------------------------------------------------------------------
		public function getAllGlobalItems ():void {
			getZoneManager ().getAllGlobalItems ();
		}
		
		//------------------------------------------------------------------------------------------
		public function isValidZoneObjectItem (__itemName:String):Boolean {
			return getZoneManager ().isValidZoneObjectItem (__itemName);
		}
		
		//------------------------------------------------------------------------------------------
		public function isZoneObjectItemNoKill (__itemName:String):Boolean {
			return getZoneManager ().isZoneObjectItemNoKill (__itemName);
		}
		
		//------------------------------------------------------------------------------------------
		public function getZoneItems ():XDict {
			return getZoneManager ().getZoneItems ();
		}
		
		//------------------------------------------------------------------------------------------
		public function getZoneItemObject (__zone:Number):ZoneX {
			return getZoneManager ().getZoneItemObject (__zone);
		}
		
		//------------------------------------------------------------------------------------------
		public function getStarterRingItems ():XDict {
			return getZoneManager ().getStarterRingItems ();
		}
		
		//------------------------------------------------------------------------------------------
		public function setMickeyToStartPosition (__zone:Number):void {	
			getZoneManager ().setMickeyToStartPosition (__zone);
		}
		
		//------------------------------------------------------------------------------------------
		public function setMickeyToLevelStartPosition ():void {
			getAllGlobalItems ();
			
			setCurrentZone (m_levelData.zone);
			
			m_levelObject.onEntry ();
			
			setMickeyToStartPosition (m_currentZone);
			
			m_mickeyObject.setXMapModel (m_mickeyObject.getLayer () + 1, xxx.getXMapModel (), m_levelObject);
		}
		
		//------------------------------------------------------------------------------------------
		public function resetZoneKillCount ():void {
			getZoneManager ().resetZoneKillCount ();
		}
		
		//------------------------------------------------------------------------------------------
		public function addToZoneKillCount ():void {
			getZoneManager ().addToZoneKillCount ();
		}
		
		//------------------------------------------------------------------------------------------
		public function removeFromZoneKillCount ():void {
			getZoneManager ().removeFromZoneKillCount ();
		}
		
		//------------------------------------------------------------------------------------------
		public function getZoneKillCount ():Number {
			return getZoneManager ().getZoneKillCount ();
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
		public function get lives ():Number {
			return  m_lives;
		}
		
		//------------------------------------------------------------------------------------------
		public function set lives (__value:Number):void {
			m_lives = __value;
			
			m_livesChangedSignal.fireSignal ();
		}
		
		//------------------------------------------------------------------------------------------
		public function addLivesChangedListener (__listener:Function):void {
			m_livesChangedSignal.addListener (__listener);
		}
		
		//------------------------------------------------------------------------------------------
		public function removeLivesChangedListener (__listener:Function):void {
			m_livesChangedSignal.removeListener (__listener);
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
		// https://www.facebook.com/dialog/feed
		// ?app_id=1437483596500878
		// &caption=Octo-Tron%20Circus
		// &description=Building%20a%20better%20tomorrow%20by%20lending%20today!
		// &display=popup
		// &e2e=%7B%7D
		// &link=http%3A%2F%2Fwww.kablooey.com%2Fapps%2FOcto-Tron-Circus
		// &locale=en_US
		// &name=Play%20Octo-Tron%20Circus!
		// &next=http%3A%2F%2Fstatic.ak.facebook.com%2Fconnect%2Fxd_arbiter%2FoDB-fAAStWy.js%3Fversion%3D41%23cb%3Df7a5bb56%26domain%3Dwww.kablooey.com%26origin%3Dhttp%253A%252F%252Fwww.kablooey.com%252Ff1cb06720%26relation%3Dopener%26frame%3Df3b90fbe68%26result%3D%2522xxRESULTTOKENxx%2522
		// &picture=http%3A%2F%2Fwww.kablooey.com%3A8080%2Fapps%2FOcto-Tron-Circus%2Fimages%2FOcto-Tron-Circus-Facebook-Feed-Large.png
		// &sdk=joey
		//------------------------------------------------------------------------------------------
		public function generateFacebookShareLink (
			__app_id:String,
			__caption:String,
			__description:String,
			__link:String,
			__name:String,
			__picture:String
		):String {
			
			var __variables:URLVariables = new URLVariables();
			__variables.caption = __caption;
			__variables.description = __description;
			__variables.display = "popup";
			__variables.e2e = "{}";
			__variables.link = __link;
			__variables.local = "en_US";
			__variables.name = __name;
			__variables.next = "http://static.ak.facebook.com/connect/xd_arbiter/oDB-fAAStWy.js?version=41#cb=f7a5bb56&domain=www.kablooey.com&origin=http%3A%2F%2Fwww.kablooey.com%2Ff1cb06720&relation=opener&frame=f3b90fbe68&result=%22xxRESULTTOKENxx%22";
			__variables.picture = __picture;
			__variables.sdk = "joey";
			
			var __urlString:String = "http://www.facebook.com/dialog/feed?app_id=" + __app_id + "&" + __variables.toString ();
			
			trace (": ", __urlString);
			
			return __urlString;
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}