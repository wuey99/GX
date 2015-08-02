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
package gx.music {
	
	import x.*;
	import x.geom.*;
	import x.signals.*;
	import x.task.*;
	import x.world.*;
	import x.world.collision.*;
	import x.world.logic.*;
	import x.world.sprite.*;
	import x.world.ui.*;
	
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
						GX.appX.getLevelObject (),
						// logicObject
						new BGMToggleButtonX () as XLogicObject,
						// item, layer, depth
						null, GX.appX.PLAYFIELD_LAYER, 100000,
						// x, y, z
						oX, oY, 0,
						// scale, rotation
						1.0, 0,
						[
							GX.appX.getBGMVolume ()
						]
					) as BGMToggleButtonX;
					
					GX.appX.getLevelObject ().addXLogicObject (m_BGMToggleButton);
					
					m_BGMToggleButton.addToggleListener (
						function (__volume:Number):void {	
							GX.appX.setBGMVolume (__volume);
						}
					);
					
					m_SFXToggleButton = xxx.getXLogicManager ().initXLogicObject (
						// parent
						GX.appX.getLevelObject (),
						// logicObject
						new SFXToggleButtonX () as XLogicObject,
						// item, layer, depth
						null, GX.appX.PLAYFIELD_LAYER, 100000,
						// x, y, z
						oX + 52, oY, 0,
						// scale, rotation
						1.0, 0,
						[
							GX.appX.getSFXVolume ()
						]
					) as SFXToggleButtonX;
					
					GX.appX.getLevelObject ().addXLogicObject (m_SFXToggleButton);
					
					m_SFXToggleButton.addToggleListener (
						function (__volume:Number):void {
							GX.appX.setSFXVolume (__volume);
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