//------------------------------------------------------------------------------------------
package GX.Messages.Level {
	
	import X.*;
	import X.Geom.*;
	import X.Task.*;
	import X.World.*;
	import X.World.Collision.*;
	import X.World.Logic.*;
	import X.World.Sprite.*;
	import X.XML.*;
	
	import flash.display.*;
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
			if (K.app$.getHudMessageObject ().getOwnerItem () == item) {
				K.app$.getHudMessageObject ().setMessage ("", 32.0, 0x000000, 32, 32, "left", 0.0, -12.0);
				
				K.app$.getHudMessageObject ().setOwnerItem (null);
			}
			
			super.cleanup ();
		}

		//------------------------------------------------------------------------------------------
		public override function createMessage ():void {		
		}
	
		//------------------------------------------------------------------------------------------
		public override function setMessage ():void {
			K.app$.getHudMessageObject ().setMessage (
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
			
			K.app$.getHudMessageObject ().oX = m_textX;
			K.app$.getHudMessageObject ().oY = m_textY;
			
			K.app$.getHudMessageObject ().setOwnerItem (item);
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