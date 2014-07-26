//------------------------------------------------------------------------------------------
// <$begin$/>
// <$end$/>
//------------------------------------------------------------------------------------------
package GX.Music {
	
	import X.*;
	import X.Geom.*;
	import X.Signals.*;
	import X.Task.*;
	import X.World.*;
	import X.World.Collision.*;
	import X.World.Logic.*;
	import X.World.Sprite.*;
	import X.World.UI.*;
	
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	
	//------------------------------------------------------------------------------------------
	public class SoundToggleButtonsX extends XLogicObjectCX {
		private var m_BGMToggleButton:BGMToggleButtonX;
		private var m_SFXToggleButton:SFXToggleButtonX;
		
		//------------------------------------------------------------------------------------------
		public function SoundToggleButtonsX () {
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);
			
			createSprites ();
		}

		//------------------------------------------------------------------------------------------
		public override function setupX ():void {
			super.setupX ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
			
			m_BGMToggleButton.nukeLater ();
			m_SFXToggleButton.nukeLater ();
		}
		
		//------------------------------------------------------------------------------------------
		// create sprites
		//------------------------------------------------------------------------------------------
		public override function createSprites ():void {
			addTask ([
				XTask.WAIT, 0x0100,
				
				function ():void {
					m_BGMToggleButton = xxx.getXLogicManager ().initXLogicObject (
						// parent
						GX.app$.getLevelObject (),
						// logicObject
						new BGMToggleButtonX () as XLogicObject,
						// item, layer, depth
						null, GX.app$.PLAYFIELD_LAYER, 100000,
						// x, y, z
						oX, oY, 0,
						// scale, rotation
						1.0, 0,
						GX.app$.getBGMVolume ()
					) as BGMToggleButtonX;
					
					GX.app$.getLevelObject ().addXLogicObject (m_BGMToggleButton);
					
					m_BGMToggleButton.addToggleListener (
						function (__volume:Number):void {	
							GX.app$.setBGMVolume (__volume);
						}
					);
					
					m_SFXToggleButton = xxx.getXLogicManager ().initXLogicObject (
						// parent
						GX.app$.getLevelObject (),
						// logicObject
						new SFXToggleButtonX () as XLogicObject,
						// item, layer, depth
						null, GX.app$.PLAYFIELD_LAYER, 100000,
						// x, y, z
						oX + 52, oY, 0,
						// scale, rotation
						1.0, 0,
						GX.app$.getSFXVolume ()
					) as SFXToggleButtonX;
					
					GX.app$.getLevelObject ().addXLogicObject (m_SFXToggleButton);
					
					m_SFXToggleButton.addToggleListener (
						function (__volume:Number):void {
							GX.app$.setSFXVolume (__volume);
						}
					);
				},
				
				XTask.RETN,
			]);
			
			show ();
		}

	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}