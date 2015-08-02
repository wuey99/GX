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
package GX.Assets {
	
	import x.*;
	import x.resource.manager.*;
	
	//------------------------------------------------------------------------------------------	
	public class XAssets extends Object {

		[Embed(source="Aller_Rg.ttf",
			fontName="Aller",  
			mimeType="application/x-font"
		)]
		public static const ArialClass:Class;
		
		[Embed(source="Aller_Rg.ttf",
			fontName="Aller",  
			mimeType="application/x-font"
		)]
		public static const ArialFontClass:Class;
		
		//------------------------------------------------------------------------------------------
		public var m_XApp:XApp;
		
		//------------------------------------------------------------------------------------------
		public function XAssets (__XApp:XApp, __parent:*) {
			m_XApp = __XApp;
		}
		
		//------------------------------------------------------------------------------------------
		public function load ():Boolean {			
			return false;	
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}