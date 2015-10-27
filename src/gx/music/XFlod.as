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
	
// X
	import kx.*;
	import kx.task.*;
	import kx.world.*;
	import kx.world.logic.*;
	
	import flash.utils.*;
	
	// <HAXE>
	// </HAXE>
	// <AS3>
	import neoart.flod.FileLoader;
	import neoart.flod.core.CorePlayer;
	// </AS3>
		
	//------------------------------------------------------------------------------------------
	public class XFlod extends XLogicObject {
		public var m_player:CorePlayer;
		public var m_source:Class; // <Dynamic>
		public var m_volume:Number;
		
		//------------------------------------------------------------------------------------------
		public function XFlod () {	
			super ();
		}

		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array  /* <Dynamic> */):void {
			super.setup (__xxx, args);
			
			m_volume = 1.0;
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
		
			m_source = __source;
			
			if (getVolume () == 0.0) {
				m_player = null;
				
				return;
			}
			
			// <HAXE>
			// </HAXE>
			// <AS3>
			var __stream:ByteArray;
			
			var loader:FileLoader = new FileLoader ();
			__stream = new __source as ByteArray;
			
			m_player = loader.load (__stream);
//			m_player.loop = true;
			m_player.play ();
			m_player.volume = getVolume ();
			// </AS3>
		}

		//------------------------------------------------------------------------------------------
		public function setVolume (__volume:Number):void {
			m_volume = __volume;

			if (m_player) {
				m_player.volume = m_volume;
			}

			if (!m_player && m_source && m_volume) {
				playSong (m_source);
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function getVolume ():Number {
			return m_volume;
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
				m_source = null;
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
	// <HAXE>
	/* --
	class CorePlayer {
		public var volume:Int;
		
		public function new () {
			
		}
		
		public function play ():Void {
			
		}
		
		public function pause ():Void {
			
		}
		
		public function stop ():Void {
			
		}
	}
	-- */
	// <AS3>
	// </AS3>
	
//------------------------------------------------------------------------------------------
}