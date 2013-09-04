//------------------------------------------------------------------------------------------
package GX.Text {
	
	import Assets.*;
	
	import Objects.*;
	import Objects.Mickey.*;
	
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
	public class SmallSpriteTextX extends SpriteTextX {
		private static var g_fontName:String = "SmallHiresFont:SmallHiresFont";
		
		//------------------------------------------------------------------------------------------
		public static function init (__XApp:XApp):void {
			__XApp.getBitmapDataAnimManager ().add (g_fontName);
		}
		
		//------------------------------------------------------------------------------------------
		public function SmallSpriteTextX () {
			super ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function getFontName ():String {
			return "SmallHiresFont:SmallHiresFont";
		}
		
		//------------------------------------------------------------------------------------------
		public override function getWidths ():Array {
			return  [
				10,		// space
				6,		// !
				14,		// "
				17,		// #
				17,		// $
				22,		// %
				18,		// &
				6,		// '
				10,		// (
				10,		// }
				10,		// .
				14,		// +
				10,		// ,
				11,		// -
				6,		// .
				10,		// /
				14,		// 0
				10,		// 1
				14,		// 2
				14,		// 3
				14,		// 4
				14,		// 5
				14,		// 6
				14,		// 7
				14,		// 8
				14,		// 9
				6,		// :
				10,		// ;
				10,		// <
				11,		// =
				10,		// >
				13,		// ?
				21,		// @
				18,		// A
				18,		// B
				18,		// C
				18,		// D
				16,		// E
				16,		// F
				18,		// G
				18,		// H
				6,		// I
				14,		// J
				18,		// K
				16,		// L
				22,		// M
				18,		// N
				18,		// O
				18,		// P
				18,		// Q
				18,		// R
				18,		// S
				14,		// T
				18,		// U
				14,		// V
				22,		// W
				22,		// X
				22,		// Y
				14,		// Z
				10,		// [
				10,		// \
				10,		// ]
				14,		// ^
			];
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}