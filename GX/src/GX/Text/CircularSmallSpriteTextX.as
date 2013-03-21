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
	public class CircularSmallSpriteTextX extends SmallSpriteTextX {
		private var m_angle:Number;
		private var m_dist:Number;
		private var m_delta:Number;
		private var m_speed:Number;
		
		//------------------------------------------------------------------------------------------
		public function CircularSmallSpriteTextX () {
			super ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setupX ():void {
			super.setupX ();
			
			angle = 45;
			dist = 75
			delta = 25;
			speed = 4.0;

			addTask ([
				XTask.LABEL, "loop",
					XTask.WAIT, 0x0100,
					
					function ():void {
						updateSprites ();
					},
						
					XTask.GOTO, "loop",
				
				XTask.RETN,
			]);
			
			addTask ([
				XTask.LABEL, "loop",
					XTask.WAIT, 0x0100,
					
					function ():void {
						m_angle -= m_speed;
						
						if (m_angle < 0) m_angle += 360;
						if (m_angle > 360) m_angle -= 360;
					},
					
					XTask.GOTO, "loop",
					
				XTask.RETN,
			]);
		}
				
		//------------------------------------------------------------------------------------------
		public function set angle (__value:Number):void {
			m_angle = __value
		}
		
		//------------------------------------------------------------------------------------------
		public function get angle ():Number {
			return m_angle;
		}
		
		//------------------------------------------------------------------------------------------
		public function set dist (__value:Number):void {
			m_dist = __value
		}
		
		//------------------------------------------------------------------------------------------
		public function get dist ():Number {
			return m_dist;
		}
		
		//------------------------------------------------------------------------------------------
		public function set delta (__value:Number):void {
			m_delta = __value
		}
		
		//------------------------------------------------------------------------------------------
		public function get delta ():Number {
			return m_delta;
		}
		
		//------------------------------------------------------------------------------------------
		public function set speed (__value:Number):void {
			m_speed = __value
		}
		
		//------------------------------------------------------------------------------------------
		public function get speed ():Number {
			return m_speed;
		}
		
		//------------------------------------------------------------------------------------------
		public override function updateSprites ():void {
			var __dx:Number = 0;
			var __dy:Number = 0;
			var __radians:Number;
			var __rotation:Number;
			
			var __angle:Number = m_angle;
			
			for (var i:Number=0; i<m_text.length; i++) {
				var __c:Number = m_text.charCodeAt (i) - 32;
				if (__c >= 64) __c -= 32;
//				m_bitmap[i].setRegistration (getWidths ()[__c]/2, 21);
				__rotation = 360 - __angle;  if (__rotation >= 360) __rotation - 360;
				m_bitmap[i].rotation = __rotation - 90;
				__radians = __rotation * Math.PI/180;
				__dx = Math.cos (__radians) * m_dist;
				__dy = Math.sin (__radians) * m_dist;
				x_sprite[i].setRegistration (m_bitmap[i].dx + __dx, m_bitmap[i].dy + __dy);
				__angle -= m_delta * (getWidths ()[__c]/22);
				if (__angle < 0) __angle += 360;
				if (__angle > 360) __angle -= 360;
			}
		}
		
		//------------------------------------------------------------------------------------------
		public override function getWidths ():Array {
			return  [
				10,		// space
				7,		// !
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
				9,		// I
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