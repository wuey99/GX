//------------------------------------------------------------------------------------------
package GX.Text {
	
	import X.*;
	import X.Geom.*;
	import X.Task.*;
	import X.World.*;
	import X.World.Collision.*;
	import X.World.Logic.*;
	import X.World.Sprite.*;
	
	import flash.display.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	
	//------------------------------------------------------------------------------------------
	public class HudCircularSmallSpriteTextX extends CircularSmallSpriteTextX {

		//------------------------------------------------------------------------------------------
		public function HudCircularSmallSpriteTextX () {
			super ();
		}
		
		//------------------------------------------------------------------------------------------
		protected override function __addSpriteAt (__sprite:DisplayObject, __x:Number, __y:Number):XDepthSprite {
			return addSpriteToHudAt (__sprite, __x, __y);
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}