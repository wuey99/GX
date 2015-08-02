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
package GX.Ads {
	
	import GX.External.*;
	import GX.External.CPMStar.*;
	import GX.External.FGL.*;

	import x.*;
	import x.geom.*;
	import x.signals.*;
	import x.task.*;
	import x.world.*;
	import x.world.collision.*;
	import x.world.logic.*;
	import x.world.sprite.*;
	import x.world.ui.*;
	
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	
	//------------------------------------------------------------------------------------------
	public class AdXLogicObject extends XLogicObjectCX {
		private var m_cpmStarAdObject:CPMStarAdX;
		private var m_fglAdObject:FGLAdX;
		
		private var m_continueSignal:XSignal;
		
		public const AdType_CPMStar:String = "CPMStar";
		public const AdType_FGLAds:String = "FGLAds";
		
		//------------------------------------------------------------------------------------------
		public function AdXLogicObject () {
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);
			
			m_continueSignal = createXSignal ();
		}
	
		//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
			
			killAdObject ();
		}
	
		//------------------------------------------------------------------------------------------
		public function killAdObject ():void {
			if (getAdObject () != null) {
				getAdObject ().nukeLater ();
				
				m_cpmStarAdObject = null;
				m_fglAdObject = null;
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function addContinueListener (__listener:Function):void {
			m_continueSignal.addListener (__listener);
		}

		//------------------------------------------------------------------------------------------
		public function fireContinueSignal ():void {
			m_continueSignal.fireSignal ();
		}
		
		//------------------------------------------------------------------------------------------
		public function createAd ():void {
			m_fglAdObject = null;
			m_cpmStarAdObject = null;
			
			if (getAdType () != AdType_CPMStar) {
				m_fglAdObject = xxx.getXLogicManager ().initXLogicObject (
					// parent
					null,
					// logicObject
					new FGLAdX () as XLogicObject,
					// item, layer, depth
					null, -1, 2000000,
					// x, y, z
					0, 0, 0,
					// scale, rotation
					1.0, 0,
					[
						getAdID ()
					]
				) as FGLAdX;
			}
			else
			{
				m_cpmStarAdObject = xxx.getXLogicManager ().initXLogicObject (
					// parent
					null,
					// logicObject
					new CPMStarAdX () as XLogicObject,
					// item, layer, depth
					null, -1, 2000000,
					// x, y, z
					700/2 - 300/2, 550/2 - 250/2, 0,
					// scale, rotation
					1.0, 0,
					[
						getAdID ()
					]
				) as CPMStarAdX;
			}
		}

		//------------------------------------------------------------------------------------------
		public function getAdType ():String {
			return AdType_CPMStar;
		}
		
		//------------------------------------------------------------------------------------------
		public function getAdID ():String {
			return "";
		}
		
		//------------------------------------------------------------------------------------------
		public function hideAds ():void {
			if (getAdObject ()) {
				getAdObject ().hide ();		
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function getAdObject ():AdX {
			if (m_fglAdObject) {
				return m_fglAdObject;
			}
			else
			{
				return m_cpmStarAdObject;
			}
		}
				
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}