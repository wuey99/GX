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
	
	import gx.*;
	import gx.text.*;
	
	import kx.*;
	import kx.geom.*;
	import kx.task.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	import kx.xml.*;
	
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	
	//------------------------------------------------------------------------------------------
	public class HudTextX extends LevelTextX {

		//------------------------------------------------------------------------------------------
		public function HudTextX () {
		}

		//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			if (GX.appX.getHudMessageObject ().getOwnerItem () == item) {
				GX.appX.getHudMessageObject ().setMessage ("", 32.0, 0x000000, 32, 32, "left", 0.0, -12.0, "Aller");
				
				GX.appX.getHudMessageObject ().setOwnerItem (null);
			}
			
			super.cleanup ();
		}

		//------------------------------------------------------------------------------------------
		public override function createMessage ():void {		
		}
	
		//------------------------------------------------------------------------------------------
		public override function setMessage ():void {
			GX.appX.getHudMessageObject ().setMessage (
				// message
				m_message,
				// size
				m_textSize, 
				// color
				m_textColor,
				// width, height
				m_textWidth, m_textHeight,
				// alignment
				m_alignment,
				// spacing
				m_spacing,
				// leading
				m_leading,
				// fontName
				m_fontName
			);
			
			GX.appX.getHudMessageObject ().oX = m_textX;
			GX.appX.getHudMessageObject ().oY = m_textY;
			
			GX.appX.getHudMessageObject ().setOwnerItem (item);
		}
		
		//------------------------------------------------------------------------------------------
		public override function getDefaultWidth ():Number {
			return 668;
		}
		
		//------------------------------------------------------------------------------------------
		public override function getDefaultHeight ():Number {
			return 128;
		}
		
		//------------------------------------------------------------------------------------------
		public override function getDefaultX ():Number {
			return 16;
		}
		
		//------------------------------------------------------------------------------------------
		public override function getDefaultY ():Number {
			return 472;
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}