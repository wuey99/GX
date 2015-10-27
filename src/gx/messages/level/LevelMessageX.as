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
package gx.messages.level {
	
	import gx.assets.*;	
	import gx.text.*;
	
	import kx.*;
	import kx.geom.*;
	import kx.task.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	import kx.xmap.*;
	
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	
	//------------------------------------------------------------------------------------------
	public class LevelMessageX extends XLogicObject {
		public var m_text:XTextSprite;
		public var x_text:XDepthSprite;
		public var script:XTask;
		public var m_ownerItem:XMapItemModel;
		
		//------------------------------------------------------------------------------------------
		public function LevelMessageX () {
			super ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array /* <Dynamic> */):void {
			super.setup (__xxx, args);
			
			createSprites ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setupX ():void {
			super.setupX ();
			
			m_ownerItem = null;
			
			script = addEmptyTask ();
		}
		
		//------------------------------------------------------------------------------------------
		// create sprites
		//------------------------------------------------------------------------------------------
		public override function createSprites ():void {
			m_text = createXTextSprite (128, 32, "");
			x_text = addSpriteAt (m_text, 0, 0);
			
			show ();
		}

		//------------------------------------------------------------------------------------------
		public function setOwnerItem (__owner:XMapItemModel):void {
			m_ownerItem = __owner;
		}
		
		//------------------------------------------------------------------------------------------
		public function getOwnerItem ():XMapItemModel {
			return m_ownerItem;
		}

		//------------------------------------------------------------------------------------------
		public function fadeOutAndNuke ():void {
			addTask ([
				XTask.LABEL, "loop",
					XTask.WAIT, 0x0100,
					
					XTask.FLAGS, function (__task:XTask):void {
						oAlpha = Math.max (0.0, oAlpha - .05);
						
						__task.ifTrue (oAlpha == 0.0);
					}, XTask.BNE, "loop",
					
					function ():void {
						nukeLater ();
					},
					
				XTask.RETN,
			]);
		}
		
		//------------------------------------------------------------------------------------------
		public function setMessage (
			__message:String,
			__size:int,
			__color:int,
			__width:Number,
			__height:Number,
			__alignment:String,
			__spacing:Number,
			__leading:int,
			__fontName:String
		):void {
			
			m_text.text = __message;	
			m_text.selectable = false;
			m_text.multiline = true;
			m_text.wordWrap = true;
//			m_text.embedFonts = true;
			
//			var __font:Font = new XAssets.ArialFontClass ();	
//			m_text.font = __font.fontName;
			
			m_text.font = __fontName;
			
			m_text.color = __color;
			m_text.size = __size;
			m_text.letterSpacing = __spacing;
			m_text.leading = __leading;
			m_text.align = __alignment;
			
			m_text.width = __width;
			m_text.height = __height;
		}
		
		//------------------------------------------------------------------------------------------
	}
	
	//------------------------------------------------------------------------------------------
}