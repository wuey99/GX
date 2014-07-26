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
	public class SoundToggleButtonX extends XLogicObjectCX {
		public var m_sprite:XMovieClip;
		public var x_sprite:XDepthSprite;
		
		public var m_volume:Number;
		public var m_toggleSignal:XSignal;
		
		//------------------------------------------------------------------------------------------
		public function SoundToggleButtonX () {
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);
			
			m_volume = getArg (args, 0);

			createSprites ();
			
			if (CONFIG::flash) {
				m_sprite.mouseEnabled = true;
			}
		}

		//------------------------------------------------------------------------------------------
		public override function setupX ():void {
			super.setupX ();
			
			m_toggleSignal = createXSignal ();
			
			m_sprite.addEventListener (xxx.MOUSE_DOWN, onMouseDown);
		}
		
		//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
			
			m_sprite.removeEventListener (xxx.MOUSE_DOWN, onMouseDown);
		}

		//------------------------------------------------------------------------------------------
		public function onMouseDown (e:MouseEvent):void {
			m_volume ^= 1;
			
			update ();
			
			m_toggleSignal.fireSignal (m_volume);
		}
		
		//------------------------------------------------------------------------------------------
		public function setVolume (__volume:Number):void {
			m_volume = __volume;
			
			update ();
		}

		//------------------------------------------------------------------------------------------
		public function update ():void {
			switch (m_volume) {
				case 0:
					m_sprite.gotoAndStop (1);
					break;
				case 1:
					m_sprite.gotoAndStop (2);
					break;
			}			
		}
		
		//------------------------------------------------------------------------------------------
		public function addToggleListener (__listener:Function):void {
			m_toggleSignal.addListener (__listener);
		}
		
		//------------------------------------------------------------------------------------------
		public function removeToggleListener (__listener:Function):void {
			m_toggleSignal.removeListener (__listener);
		}
		
		//------------------------------------------------------------------------------------------
		// create sprites
		//------------------------------------------------------------------------------------------
		public override function createSprites ():void {
			m_sprite = createXMovieClip (getName ());
			x_sprite = addSpriteAt (m_sprite, m_sprite.dx, m_sprite.dy);
			x_sprite.setDepth (getDepth ());
			
			update ();
			
			show ();
		}

		//------------------------------------------------------------------------------------------
		public function getName ():String {
			return "";
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}