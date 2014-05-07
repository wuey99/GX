//------------------------------------------------------------------------------------------
package GX.External.CPMStar {
	
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
	public class CPMStarAdX extends AdX {
		public var m_sprite:XMovieClip;
		public var x_sprite:XDepthSprite;

		public var m_adLoaderObject:AdLoader;
		
		//------------------------------------------------------------------------------------------
		public function CPMStarAdX () {
		}
		
		//------------------------------------------------------------------------------------------
		// create sprites
		//------------------------------------------------------------------------------------------
		public override function createSprites ():void {
			m_sprite = createXMovieClip ("adBox:adBox");
			x_sprite = addSpriteToHudAt (m_sprite, 0, 0);
				
			m_adLoaderObject = new AdLoader (adID);
			
			m_adLoaderObject.addEventListener (
				Event.COMPLETE,
				
				function ():void {
					fireCompleteSignal ();
				}
			);
			
			m_adLoaderObject.addEventListener (
				IOErrorEvent.IO_ERROR,
				
				function (e:Event):void {
					fireErrorSignal (e);
				}
			);
			
			m_sprite.getMovieClip ().addChild (m_adLoaderObject);
			
			show ();
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}