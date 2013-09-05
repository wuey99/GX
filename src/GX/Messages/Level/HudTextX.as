//------------------------------------------------------------------------------------------
package GX.Messages.Level {
	
	import Assets.*;
	
	import Objects.*;
	import Objects.Enemies.*;
	import Objects.Explosions.*;
	
	import Text.*;
	
	import X.*;
	import X.Geom.*;
	import X.Task.*;
	import X.World.*;
	import X.World.Collision.*;
	import X.World.Logic.*;
	import X.World.Sprite.*;
	import X.XML.*;
	
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	
	//------------------------------------------------------------------------------------------
	public class HudTextX extends LevelTextX {

		//------------------------------------------------------------------------------------------
		public function HudTextX () {
		}

		//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			if (GX.app$.getHudMessageObject ().getOwnerItem () == item) {
				GX.app$.getHudMessageObject ().setMessage ("", 32.0, 0x000000, 32, 32, "left", 0.0, -12.0);
				
				GX.app$.getHudMessageObject ().setOwnerItem (null);
			}
			
			super.cleanup ();
		}

		//------------------------------------------------------------------------------------------
		public override function createMessage ():void {		
		}
	
		//------------------------------------------------------------------------------------------
		public override function setMessage ():void {
			GX.app$.getHudMessageObject ().setMessage (
				// message
				m_message,
				// size
				m_textSize, 
				// color
				m_textColor,
				// width, height
				m_textWidth, m_textHeight,
				// alignment
				m_alignment,
				// spacing
				m_spacing,
				// leading
				m_leading
			);
			
			GX.app$.getHudMessageObject ().oX = m_textX;
			GX.app$.getHudMessageObject ().oY = m_textY;
			
			GX.app$.getHudMessageObject ().setOwnerItem (item);
		}
		
		//------------------------------------------------------------------------------------------
		public override function getDefaultWidth ():Number {
			return 668;
		}
		
		//------------------------------------------------------------------------------------------
		public override function getDefaultHeight ():Number {
			return 128;
		}
		
		//------------------------------------------------------------------------------------------
		public override function getDefaultX ():Number {
			return 16;
		}
		
		//------------------------------------------------------------------------------------------
		public override function getDefaultY ():Number {
			return 472;
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}