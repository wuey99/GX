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
package GX.Mickey {

	import X.*;
	import X.Geom.*;
	import X.Signals.XSignal;
	import X.Task.*;
	import X.World.*;
	import X.World.Collision.*;
	import X.World.Logic.*;
	import X.World.Sprite.*;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
		
//------------------------------------------------------------------------------------------
	public class _MickeyX extends EnemyCollidableX {
		protected var m_dead:Boolean;
		protected var m_mouseDownSignal:XSignal;
		protected var m_waitingSignal:XSignal;
		protected var m_playingSignal:XSignal;
		protected var m_ready:Boolean;
		protected var m_invincible:Number;
		protected var m_levelCompleteSignal:XSignal;
		protected var m_extraDX:Number;
		protected var m_extraDY:Number;
		
//------------------------------------------------------------------------------------------
		public function _MickeyX () {
		}
								
//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
		}

//------------------------------------------------------------------------------------------
		public function get extraDX ():Number {
			return m_extraDX;
		}
		
		public function set extraDX (__value:Number):void {
			m_extraDX = __value;
		}
		
//------------------------------------------------------------------------------------------
		public function get extraDY ():Number {
			return m_extraDY;
		}
		
		public function set extraDY (__value:Number):void {
			m_extraDY = __value;
		}
		
//------------------------------------------------------------------------------------------
		public function addLevelCompleteListener (__listener:Function):void {
			m_levelCompleteSignal.addListener (__listener);
		}
		
//------------------------------------------------------------------------------------------
		public function removeLevelCompleteListener (__listener:Function):void {
			m_levelCompleteSignal.removeListener (__listener);
		}
		
//------------------------------------------------------------------------------------------
		public function fireLevelCompleteSignal ():void {
			m_levelCompleteSignal.fireSignal ();
		}
				
//------------------------------------------------------------------------------------------
		public function isReady ():Boolean {
			return m_ready;
		}

//------------------------------------------------------------------------------------------
		public function addWaitingListener (__callback:Function):void {
			m_waitingSignal.addListener (__callback);
		}
		
//------------------------------------------------------------------------------------------
		public function removeWaitingListener (__callback:Function):void {
			m_waitingSignal.removeListener (__callback);
		}
		
//------------------------------------------------------------------------------------------
		public function fireWaitingSignal ():void {
			m_waitingSignal.fireSignal ();
		}

//------------------------------------------------------------------------------------------
		public function addPlayingListener (__callback:Function):void {
			m_playingSignal.addListener (__callback);
		}
		
//------------------------------------------------------------------------------------------
		public function removePlayingListener (__callback:Function):void {
			m_playingSignal.removeListener (__callback);
		}
		
//------------------------------------------------------------------------------------------
		public function firePlayingSignal ():void {
			m_playingSignal.fireSignal ();
		}

	//------------------------------------------------------------------------------------------
		public function setMessage (__message:String):void {	
		}
		
	//------------------------------------------------------------------------------------------
		public function getMessage ():String {
			return null;
		}
		
	//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
}