//------------------------------------------------------------------------------------------
package
{
	
// app
	import GX.Assets.*;
	import GX.Levels.*;
	import GX.Text.*;
	import GX.Mickey.*;
	import GX.Messages.*;
	import GX.Messages.Level.*;
	
// X classes
	import X.*;
	import X.Bitmap.XBitmapDataAnim;
	import X.Collections.*;
	import X.Game.*;
	import X.Geom.*;
	import X.Keyboard.*;
	import X.Resource.*;
	import X.Signals.XSignal;
	import X.Task.*;
	import X.World.*;
	import X.World.Logic.*;
	import X.XML.*;
	import X.XMap.*;

// flash classes
	include "flash.h";
	import flash.ui.Mouse;
	 
//------------------------------------------------------------------------------------------
	public class GApp extends Sprite {
		public var m_XApp:XApp;
		public var xxx:XWorld;
		public var m_app:GApp;
		public var m_assets:XAssets;
		public var m_mickeyObject:MickeyX;
		public var m_mickeyCursorObject:MickeyCursorX;;
		public var m_levelObject:LevelX;
//		public var m_gameHudObject:HudX;
		public var m_hudObject:XLogicObject;
		public var m_hudMessageObject:HudMessageX;
		public var PLAYFIELD_LAYER:Number = 0;
		public var m_gameState:Number;
		public var m_levelData:*;
		public var m_levelComplete:Boolean;	
		public var m_currentZone:Number;
		
		public var m_setMickeyToStartSignal:XSignal;
		public var m_zoneStartedSignal:XSignal;
		public var m_zoneFinishedSignal:XSignal;
		public var m_mickeyDeathSignal:XSignal;
		
		//------------------------------------------------------------------------------------------
		public function GApp () {	
			trace (": starting: ");
		}
		
		//------------------------------------------------------------------------------------------
		public function setup (__assetsClass:Class, __mickeyClass:Class, __parent:*):void {	
			m_app = this;
			
			m_XApp = new XApp ();
			m_XApp.setup (m_XApp.getDefaultPoolSettings ());
			
			xxx = new XWorld (__parent, m_XApp);
			addChild (xxx);
			
			setupMask ();
			
			xxx.setViewRect (704, 576);
			
			xxx.grabFocus ();
			
			m_assets = new __assetsClass (m_XApp, __parent);
			m_assets.load ();
			
			K.setup (this, m_XApp);
		}
		
		//------------------------------------------------------------------------------------------
		public function setupSignals ():void {
			m_setMickeyToStartSignal = new XSignal ();
			m_zoneStartedSignal = new XSignal ();
			m_zoneFinishedSignal = new XSignal ();
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
//			return m_gameHudObject;
			return null;
		}
		
		//------------------------------------------------------------------------------------------
		public function getHudMessageObject ():HudMessageX {
			return m_hudMessageObject;
		}
		
		//------------------------------------------------------------------------------------------
		public function getLevelObject ():LevelX {
			return m_levelObject;
		}
		
		//------------------------------------------------------------------------------------------
		public function getLevelLayer (__layer:Number):XMapView { // XMapLayerView
			return m_levelObject;
		}
		
		//------------------------------------------------------------------------------------------
		public function setupMickey (__mickey:MickeyX):void {
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
			) as MickeyX;
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
				new MickeyCursorX () as XLogicObject,
				// item, layer, depth
				null, PLAYFIELD_LAYER, 10000,
				// x, y, z
				__x, __y, 0,
				// scale, rotation
				1.0, 0
			) as MickeyCursorX;
		}
		
		
		//------------------------------------------------------------------------------------------
		public function getMickeyCursorObject ():MickeyCursorX {
			return m_mickeyCursorObject;	
		}
		
		//------------------------------------------------------------------------------------------
		public function getMickeyObject ():MickeyX {
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
			K.app$.getMickeyObject ().addPlayingListener (__listener);
		}
		
		//------------------------------------------------------------------------------------------
		public function removeMickeyPlayingListener (__listener:Function):void {
			K.app$.getMickeyObject ().removePlayingListener (__listener);
		}

	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}