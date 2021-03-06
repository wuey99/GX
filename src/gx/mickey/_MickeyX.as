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
package gx.mickey {

	import kx.*;
	import kx.geom.*;
	import kx.signals.XSignal;
	import kx.task.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	
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
		protected var m_invincible:int;
		protected var m_levelCompleteSignal:XSignal;
		protected var m_extraDX:Number;
		protected var m_extraDY:Number;
		
//------------------------------------------------------------------------------------------
		public function _MickeyX () {
			super ();
		}
								
//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
		}

//------------------------------------------------------------------------------------------
		/* @:get, set extraDX Float */
		
		public function get extraDX ():Number {
			return m_extraDX;
		}
		
		public function set extraDX (__val:Number): /* @:set_type */ void {
			m_extraDX = __val;
			
			/* @:set_return 0; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set extraDY Float */
		
		public function get extraDY ():Number {
			return m_extraDY;
		}
		
		public function set extraDY (__val:Number): /* @:set_type */ void {
			m_extraDY = __val;
			
			/* @:set_return 0; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public function addLevelCompleteListener (__listener:Function):int {
			return m_levelCompleteSignal.addListener (__listener);
		}
		
//------------------------------------------------------------------------------------------
		public function removeLevelCompleteListener (__id:int):void {
			m_levelCompleteSignal.removeListener (__id);
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
		public function addWaitingListener (__listener:Function):int {
			return m_waitingSignal.addListener (__listener);
		}
		
//------------------------------------------------------------------------------------------
		public function removeWaitingListener (__id:int):void {
			m_waitingSignal.removeListener (__id);
		}
		
//------------------------------------------------------------------------------------------
		public function fireWaitingSignal ():void {
			m_waitingSignal.fireSignal ();
		}

//------------------------------------------------------------------------------------------
		public function addPlayingListener (__listener:Function):int {
			return m_playingSignal.addListener (__listener);
		}
		
//------------------------------------------------------------------------------------------
		public function removePlayingListener (__id:int):void {
			m_playingSignal.removeListener (__id);
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