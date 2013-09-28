//------------------------------------------------------------------------------------------
package GX.Text {
	
	import GX.Assets.*;
	
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
	
	//------------------------------------------------------------------------------------------
	public class SpriteTextX extends XLogicObject {
		public var m_bitmap:Array;
		public var x_sprite:Array;
		public var m_text:String;
	
		//------------------------------------------------------------------------------------------
		public function SpriteTextX () {
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);
			
			m_text = getArg (args, 0);
			
			createSprites ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setupX ():void {
			super.setupX ();
			
			addTask ([
				XTask.LABEL, "loop",
					XTask.WAIT, 0x0100,
					
					function ():void {
					}, 
					
					XTask.GOTO, "loop",
				
				XTask.RETN,
			]);
		}
		
		//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
			
			var i:Number;
			
			for (i=0; i<m_bitmap.length; i++) {
				m_bitmap[i].cleanup ();
			}
		}
		
		//------------------------------------------------------------------------------------------
		// create sprites
		//------------------------------------------------------------------------------------------
		public override function createSprites ():void {
			m_bitmap = new Array (m_text.length);
			x_sprite = new Array (m_text.length);

			for (var i:Number=0; i<m_text.length; i++) {
				var __c:Number = m_text.charCodeAt (i) - 32;
				if (__c >= 64) __c -= 32;
				m_bitmap[i] = new XBitmap ();
				m_bitmap[i].initWithClassName (xxx, null, getFontName ());
				x_sprite[i] = __addSpriteAt (m_bitmap[i], 0, 0);
				x_sprite[i].setDepth (getDepth ());
			}
			
			updateSprites ();
			
			show ();
		}

	//------------------------------------------------------------------------------------------
		public function updateSprites ():void {
			var __x:Number = 0;
			
			for (var i:Number=0; i<m_text.length; i++) {
				var __c:Number = m_text.charCodeAt (i) - 32;
				if (__c >= 64) __c -= 32;
				m_bitmap[i].gotoAndStop (__c + 1);
				x_sprite[i].setRegistration (m_bitmap[i].dx + __x, m_bitmap[i].dy);
				__x -= (getWidths ()[__c] + 2);
			}
		}
		
	//------------------------------------------------------------------------------------------
		public function getFontName ():String {
			return "";
		}
		
	//------------------------------------------------------------------------------------------
		public function getWidths ():Array {
			return [];
		}
		
	//------------------------------------------------------------------------------------------
		public function setText (__text:String):void {
			__removeSprites ();

			m_text = __text;
			
			createSprites ();
		}
		
	//------------------------------------------------------------------------------------------
		public function __removeSprites ():void {
			removeAllWorldSprites ();
			removeAllHudSprites ();
			removeAllXLogicObjects ();
			
			var i:Number;
			
			for (i=0; i<m_bitmap.length; i++) {
				m_bitmap[i].cleanup ();
			}
		}
		
	//------------------------------------------------------------------------------------------
		protected function __addSpriteAt (__sprite:XBitmap, __x:Number, __y:Number):XDepthSprite {
			return addSpriteAt (__sprite, __x, __y);
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}