//------------------------------------------------------------------------------------------
package GX.Zone {
	
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
	public class ZoneX extends XLogicObjectCX {
		public var script:XTask;
		
		public var m_zone:Number;
		
		//------------------------------------------------------------------------------------------
		public function ZoneX () {
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);
			
			createSprites ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setupX ():void {
			super.setupX ();
			
			setCX (+0, +96, +0, +96);
		
			__setupItemParamsXML ();
		}

		//------------------------------------------------------------------------------------------
		public override function cullObject ():void {	
		}
		
		//------------------------------------------------------------------------------------------
		// create sprites
		//------------------------------------------------------------------------------------------
		public override function createSprites ():void {
		}
		
		//------------------------------------------------------------------------------------------
		public function getZone ():Number {
			return m_zone;
		}

		//------------------------------------------------------------------------------------------
		private function __setupItemParamsXML ():void {
			setupItemParamsXML ();
			
			if (itemHasAttribute ("x") && itemHasAttribute ("y") && itemHasAttribute ("width") && itemHasAttribute ("height")) {
				boundingRect.setRect (itemGetAttribute ("x"), itemGetAttribute ("y"), itemGetAttribute ("width"), itemGetAttribute ("height"));
			}
			else
			{
				boundingRect.setRect (0, 0, 0, 0);
			}
			
			m_zone = itemGetAttribute ("zone");
			
			script = addEmptyTask ();
			
			var __mickeyRect:XRect = new XRect ();
			var __zoneRect:XRect = new XRect ();
			
			getCX ().copy2 (__zoneRect);
			__zoneRect.offset (oX, oY);
			
			addTask ([
				XTask.LABEL, "loop",
					XTask.WAIT, 0x0100,
					
					XTask.FLAGS, function (__task:XTask):void {
						if (!K.app$.getLevelComplete ()) {
							K.app$.getMickeyObject ().getCX ().copy2 (__mickeyRect);
							__mickeyRect.offsetPoint (K.app$.getMickeyObject ().getPos ());
							
							__task.ifTrue (__zoneRect.intersects (__mickeyRect));
						}
						else
						{
							__task.ifTrue (false);
						}
						
//						trace (": zone: ", __zoneRect.intersects (__mickeyRect));
						
					}, XTask.BNE, "loop",
					
					function ():void {
						if (K.app$.getCurrentZone () != m_zone) {
							K.app$.setCurrentZone (m_zone);	
							
							K.app$.fireZoneStartedSignal ();
						}
					},
				
				XTask.RETN,
			]);			
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}