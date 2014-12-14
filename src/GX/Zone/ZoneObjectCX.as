//------------------------------------------------------------------------------------------
// <$begin$/>
// <$end$/>
//------------------------------------------------------------------------------------------
package GX.Zone {	
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
	
	//------------------------------------------------------------------------------------------
	public class ZoneObjectCX extends XLogicObjectCX {
		public var m_persistedObject:Boolean;
		public var m_removed:Boolean;
		
		//------------------------------------------------------------------------------------------
		public function ZoneObjectCX () {
		}

		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);
			
			m_persistedObject = false;
			
			m_removed = false;
		}
		
		//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
				
			if (!m_removed) {
				trace (": ZoneObjectCX: cleanup: ", this, m_persistedObject);
				
				if (m_persistedObject) {
					GX.app$.removeFromZoneKillCount ();
				}
				
				m_removed = true;
			}
		}

		//------------------------------------------------------------------------------------------
		public function setAsPersistedObject (__flag:Boolean):void {
			m_persistedObject = __flag
		}
		
		//------------------------------------------------------------------------------------------
		public override function cullObject ():void {
			if (m_persistedObject) {
				return;
			}
			
			super.cullObject ();	
		}

	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}