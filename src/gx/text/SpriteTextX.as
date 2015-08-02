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
package gx.text {
	
	import gx.assets.*;
	
	import x.*;
	import x.geom.*;
	import x.task.*;
	import x.world.*;
	import x.world.collision.*;
	import x.world.logic.*;
	import x.world.sprite.*;
	
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	
	//------------------------------------------------------------------------------------------
	public class SpriteTextX extends XLogicObject {
		public var m_bitmap:Array;
		public var x_sprite:Array;
		public var m_text:String;
		public var m_totalWidth:Number;
	
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
			
			var i:int;
			
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

			for (var i:int=0; i<m_text.length; i++) {
				var __c:int = m_text.charCodeAt (i) - 32;
				if (__c >= 64) __c -= 32;
				m_bitmap[i] = new XBitmap ();
				m_bitmap[i].setup ();
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
			
			for (var i:int=0; i<m_text.length; i++) {
				var __c:int = m_text.charCodeAt (i) - 32;
				if (__c >= 64) __c -= 32;
				m_bitmap[i].gotoAndStop (__c + 1);
				x_sprite[i].setRegistration (m_bitmap[i].dx + __x, m_bitmap[i].dy);
				__x -= (getWidths ()[__c] + 2);
			}
			
			m_totalWidth = -__x;
		}

	//------------------------------------------------------------------------------------------
		public function getTotalWidth ():Number {
			return m_totalWidth;
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
			
			var i:int;
			
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