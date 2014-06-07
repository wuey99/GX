//------------------------------------------------------------------------------------------
package GX.Music {
	
	import neoart.flod.FileLoader;
	import neoart.flod.core.CorePlayer;
	
	import flash.utils.*;
	
	//------------------------------------------------------------------------------------------
	public class XFlod {
		public var m_player:CorePlayer;
		
		//------------------------------------------------------------------------------------------
		public function XFlod () {	
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
			
			m_player.play ();
		}
	
		//------------------------------------------------------------------------------------------
		public function stopSong ():void {
			m_player.stop ();
			
			m_player = null;
		}
		
		//------------------------------------------------------------------------------------------
		public function pauseSong ():void {
			m_player.pause ();
		}
		
		//------------------------------------------------------------------------------------------
		public function resumeSong ():void {
			m_player.play ();
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
	