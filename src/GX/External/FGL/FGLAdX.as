//------------------------------------------------------------------------------------------
package GX.External.FGL {
	
	import GX.External.*;
	
	import X.*;
	import X.Geom.*;
	import X.Task.*;
	import X.World.*;
	import X.World.Collision.*;
	import X.World.Logic.*;
	import X.World.Sprite.*;
	
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	
	//------------------------------------------------------------------------------------------
	public class FGLAdX extends AdX {
		public var m_sprite:Sprite;
		public var x_sprite:XDepthSprite;
		
		public static var m_ads:FGLAds;
		
		//------------------------------------------------------------------------------------------
		public function FGLAdX () {
		}
		
		//------------------------------------------------------------------------------------------
		// create sprites
		//------------------------------------------------------------------------------------------
		public override function createSprites ():void {
			m_sprite = new Sprite ();
			x_sprite = addSpriteToHudAt (m_sprite, 0, 0);
			
			if (m_ads == null) {
				m_ads = new FGLAds (stage, adID);
			
				// When the API is ready, show the ad!
				m_ads.addEventListener(FGLAds.EVT_API_READY, showStartupAd);
			
				function showStartupAd(e:Event):void {
					m_ads.showAdPopup();
				}
			}
			else
			{
				m_ads.showAdPopup();
			}
			
			show ();
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}