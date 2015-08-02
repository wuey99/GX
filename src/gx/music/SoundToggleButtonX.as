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