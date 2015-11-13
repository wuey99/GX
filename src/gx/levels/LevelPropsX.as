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
package gx.levels {
		
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	
	import gx.*;
	import gx.assets.*;
	
	import kx.*;
	import kx.collections.*;
	import kx.geom.*;
	import kx.signals.*;
	import kx.task.*;
	import kx.world.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	import kx.xmap.*;
	import kx.xml.*;
	
	//------------------------------------------------------------------------------------------
	public class LevelPropsX extends Object {
		public var m_props:XDict; // <String, Dynamic>
		
		//------------------------------------------------------------------------------------------
		public function LevelPropsX () {
			super ();
		}
		
		//------------------------------------------------------------------------------------------
		public function setup (args:Array /* <Dynamic> */):LevelPropsX {
			m_props = new XDict (); // <String, Dynamic>
			
			var i:int = 0;

			while (i < args.length) {
				setProperty (args[i+0], args[i+1]);
				
				i += 2;
			}
			
			return this;
		}

		//------------------------------------------------------------------------------------------
		public function getProperty (__key:String):* {
			return m_props.get (__key);
		}
		
		//------------------------------------------------------------------------------------------
		public function setProperty (__key:String, __val:*):void {
			m_props.set (__key, __val);
		}
		
		//------------------------------------------------------------------------------------------
	}
	
	//------------------------------------------------------------------------------------------
}