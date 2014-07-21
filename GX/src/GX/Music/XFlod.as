//------------------------------------------------------------------------------------------
package GX.Music {
	
// X
	import X.*;
	import X.Task.*;
	import X.World.*;
	import X.World.Logic.*;
	
	import flash.utils.*;
	
	import neoart.flod.FileLoader;
	import neoart.flod.core.CorePlayer;
	
	//------------------------------------------------------------------------------------------
	public class XFlod extends XLogicObject {
		public var m_player:CorePlayer;
		
		//------------------------------------------------------------------------------------------
		public function XFlod () {	
			super ();
		}

		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);
		}
		
		//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
		}
		
		//------------------------------------------------------------------------------------------
		public function playSong (__source:Class):void {
			if (m_player != null) {
				stopSong ();
			}
			
			var __stream:ByteArray;
			
			var loader:FileLoader = new FileLoader ();
			__stream = new __source as ByteArray;
			
			m_player = loader.load (__stream);
			m_player.loop = true;
			m_player.play ();
		}

		//------------------------------------------------------------------------------------------
		public function fadeOutAndStopSong ():void {
			var __volume:Number = 1.0;
			
			if (isPlaying ()) {
				addTask ([
					XTask.LABEL, "loop",
						XTask.WAIT, 0x0100,
						
						XTask.FLAGS, function (__task:XTask):void {
							__volume = Math.max (0.0, __volume - 0.10);
							
							m_player.volume = __volume;
							
							__task.ifTrue (__volume == 0.0);
						}, XTask.BNE, "loop",
					
					function ():void {
						stopSong ();	
					},
					
					XTask.RETN,
				]);
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function stopSong ():void {
			if (isPlaying ()) {
				m_player.stop ();
			
				m_player = null;
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function pauseSong ():void {
			if (isPlaying ()) {
				m_player.pause ();
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function resumeSong ():void {
			if (isPlaying ()) {
				m_player.play ();
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function isPlaying ():Boolean {
			if (m_player) {
				return true;
			}
			else
			{
				return false;
			}
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
	