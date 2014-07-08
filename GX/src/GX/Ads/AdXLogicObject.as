//------------------------------------------------------------------------------------------
// <$begin$/>
// <$end$/>
//------------------------------------------------------------------------------------------
package GX.Ads {
	
	import GX.External.*;
	import GX.External.CPMStar.*;
	import GX.External.FGL.*;

	import X.*;
	import X.Geom.*;
	import X.Signals.*;
	import X.Task.*;
	import X.World.*;
	import X.World.Collision.*;
	import X.World.Logic.*;
	import X.World.Sprite.*;
	import X.World.UI.*;
	
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	
	//------------------------------------------------------------------------------------------
	public class AdXLogicObject extends XLogicObjectCX {
		private var m_cpmStarAdObject:CPMStarAdX;
		private var m_fglAdObject:FGLAdX;
		
		private var m_continueSignal:XSignal;
		
		public const AdType_CPMStar = "CPMStar";
		public const AdType_FGLAds = "FGLAds";
		
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
			
			if (getAdType () != "CPMStar") {
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
					getAdID ()
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
					getAdID ()
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