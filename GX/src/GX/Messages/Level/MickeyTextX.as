//------------------------------------------------------------------------------------------
package GX.Messages.Level {
	
	import GX.Assets.*;
	import GX.Text.*;
	
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
	public class MickeyTextX extends XLogicObjectCX {
		public var m_message:String;

		//------------------------------------------------------------------------------------------
		public function MickeyTextX () {
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
		}

		//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
		}
		
		//------------------------------------------------------------------------------------------
		// <params
		//   message=""
		// />
		//------------------------------------------------------------------------------------------
		public function setupParams ():void {
			m_xml = new XSimpleXMLNode ();
			m_xml.setupWithXMLString (item.params);
			
			m_message = "None";
			if (m_xml.hasAttribute ("message")) {
				m_message = m_xml.getAttribute ("message");
			}
			
			GX.app$.setMickeyMessage (m_message);
		}
		
		//------------------------------------------------------------------------------------------
		// create sprites
		//------------------------------------------------------------------------------------------
		public override function createSprites ():void {
			show ();
		}

		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}