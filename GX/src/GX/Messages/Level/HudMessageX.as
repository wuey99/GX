//------------------------------------------------------------------------------------------
package GX.Messages.Level {

	import X.*;
	import X.Geom.*;
	import X.Task.*;
	import X.World.*;
	import X.World.Collision.*;
	import X.World.Logic.*;
	import X.World.Sprite.*;
	
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	import flash.filters.*;
	
	//------------------------------------------------------------------------------------------
	public class HudMessageX extends LevelMessageX {

		//------------------------------------------------------------------------------------------
		public function HudMessageX () {
		}
	
		//------------------------------------------------------------------------------------------
		// create sprites
		//------------------------------------------------------------------------------------------
		public override function createSprites ():void {
			m_text = createXTextSprite ();
			x_text = addSpriteToHudAt (m_text, 0, 0);
			
			m_text.filters = [new DropShadowFilter (
				// distance
				4.0,
				// angle
				45,
				// color
				0x000000,
				// alpha
				1.0
			)];
			
			show ();
		}

	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}