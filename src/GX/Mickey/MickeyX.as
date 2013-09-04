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
	public class MickeyX extends EnemyCollidableX {
		protected var m_dead:Boolean;
		protected var m_mouseDownSignal:XSignal;
		protected var m_waitingSignal:XSignal;
		protected var m_playingSignal:XSignal;
		protected var m_ready:Boolean;
		protected var m_invincible:Number;
		protected var m_levelCompleteSignal:XSignal;
		
//------------------------------------------------------------------------------------------
		public function MickeyX () {
		}
								
//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
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
		private function fireLevelCompleteSignal ():void {
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