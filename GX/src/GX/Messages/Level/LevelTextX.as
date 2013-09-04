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
	public class LevelTextX extends XLogicObjectCX {
		public var script:XTask;
		public var m_levelMessageObject:LevelMessageX;
		
		public var m_message:String;
		public var m_textSize:Number;
		public var m_textWidth:Number;
		public var m_textHeight:Number;
		public var m_textColor:uint;
		public var m_alignment:String;
		public var m_textX:Number;
		public var m_textY:Number;
		public var m_spacing:Number;
		public var m_leading:Number;

		//------------------------------------------------------------------------------------------
		public function LevelTextX () {
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);
		}
		
		//------------------------------------------------------------------------------------------
		public override function setupX ():void {
			super.setupX ();
			
			setupParams ();
		
			createSprites ();
			
			script = addEmptyTask ();
		}

		//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
		}
		
		//------------------------------------------------------------------------------------------
		// <params
		//   message=""
		//   x=""
		//   y=""
		//   size=""
		//   color=""
		//   width=""
		//   height=""
		//   alignment=""
		// />
		//------------------------------------------------------------------------------------------
		public function setupParams ():void {
			m_xml = new XSimpleXMLNode ();
			m_xml.setupWithXMLString (item.params);
			
			m_message = "None";
			if (m_xml.hasAttribute ("message")) {
				m_message = m_xml.getAttribute ("message");
			}
			
			m_textSize = getDefaultSize ();
			if (m_xml.hasAttribute ("size")) {
				m_textSize = m_xml.getAttribute ("size");
			}
			
			m_textColor = getDefaultColor ();
			if (m_xml.hasAttribute ("color")) {
				m_textColor = m_xml.getAttribute ("color");
			}
			
			m_textWidth = getDefaultWidth ();
			if (m_xml.hasAttribute ("width")) {
				m_textWidth = m_xml.getAttribute ("width");
			}
			
			m_textHeight = getDefaultHeight ();
			if (m_xml.hasAttribute ("height")) {
				m_textHeight = m_xml.getAttribute ("height");
			}
		
			m_alignment = "left";
			if (m_xml.hasAttribute ("align")) {
				m_alignment = m_xml.getAttribute ("align");
			}
			
			m_textX = getDefaultX ();
			if (m_xml.hasAttribute ("x")) {
				m_textX = m_xml.getAttribute ("x");
			}
			
			m_textY = getDefaultY ();
			if (m_xml.hasAttribute ("y")) {
				m_textY = m_xml.getAttribute ("y");
			}
			
			m_spacing = getDefaultSpacing ();
			if (m_xml.hasAttribute ("spacing")) {
				m_spacing = m_xml.getAttribute ("spacing");
			}
			
			m_leading = getDefaultLeading ();
			if (m_xml.hasAttribute ("leading")) {
				m_leading = m_xml.getAttribute ("leading");
			}
		}
		
		//------------------------------------------------------------------------------------------
		// create sprites
		//------------------------------------------------------------------------------------------
		public override function createSprites ():void {
			createMessage ();
			
			setMessage ();
			
			show ();
		}

		//------------------------------------------------------------------------------------------
		public function createMessage ():void {
			var __dx:Number;
			
			switch (m_alignment) {
				case "left":
					__dx = 0;
					break;
				case "right":
					__dx = -m_textWidth;
					break;
				case "center":
					__dx = -m_textWidth/2;
					break;
			}
			
			m_levelMessageObject = xxx.getXLogicManager ().initXLogicObject (
				// parent
				this,
				// logicObject
				new LevelMessageX () as XLogicObject,
				// item, layer, depth
				null, getLayer (), 1000,
				// x, y, z
				__dx, 0, 0,
				// scale, rotation
				1.0, 0
			) as LevelMessageX;
			
			addXLogicObject (m_levelMessageObject);			
		}
		
		//------------------------------------------------------------------------------------------
		public function setMessage ():void {
			m_levelMessageObject.setMessage (
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
		}

		//------------------------------------------------------------------------------------------
		public function getDefaultColor ():uint {
			return 0x60e060;
		}
		
		//------------------------------------------------------------------------------------------
		public function getDefaultSize ():Number {
			return 32.0;
		}

		//------------------------------------------------------------------------------------------
		public function getDefaultWidth ():Number {
			return 256.0;
		}
		
		//------------------------------------------------------------------------------------------
		public function getDefaultHeight ():Number {
			return 64.0;
		}

		//------------------------------------------------------------------------------------------
		public function getDefaultX ():Number {
			return 0;
		}
		
		//------------------------------------------------------------------------------------------
		public function getDefaultY ():Number {
			return 0;
		}
		
		//------------------------------------------------------------------------------------------
		public function getDefaultSpacing ():Number {
			return 0.0;
		}
		
		//------------------------------------------------------------------------------------------
		public function getDefaultLeading ():Number {
			return -12.0;
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}