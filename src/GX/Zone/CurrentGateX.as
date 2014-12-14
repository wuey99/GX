//------------------------------------------------------------------------------------------
// <$begin$/>
// <$end$/>
//------------------------------------------------------------------------------------------
package GX.Zone {
	import GX.Messages.*;

	import X.*;
	import X.Geom.*;
	import X.Task.*;
	import X.World.*;
	import X.World.Collision.*;
	import X.World.Logic.*;
	import X.World.Sprite.*;
	import X.XML.*;
	import X.XMap.*;
	
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	
	//------------------------------------------------------------------------------------------
	public class CurrentGateX extends XLogicObjectCX {
		public var script:XTask;
		
		public var m_WaterCurrentX:Class;
		
		public var m_direction:String;
		public var m_currentX:Number;
		public var m_currentY:Number;
		
		public var m_zone:Number;
		public var m_message:String;
		
		//------------------------------------------------------------------------------------------
		public function CurrentGateX () {
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);
		
			m_WaterCurrentX = getArg (args, 0);
			
			createSprites ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setupX ():void {
			super.setupX ();
			
			setCX (-64, +64, -64, +64);
	
			GX.app$.addZoneStartedListener (onZoneStarted);
			GX.app$.addZoneFinishedListener (onZoneFinished);
			
			__setupItemParamsXML ();
			__setupSpawnScript ();
			__setupDetectionScript ();
			
			oVisible = true;
		}

		//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
			
			GX.app$.removeZoneStartedListener (onZoneStarted);
			GX.app$.removeZoneFinishedListener (onZoneFinished);
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
		public override function setXMapModel (__layer:Number, __XMapModel:XMapModel, __XMapView:XMapView=null):void {
			super.setXMapModel (__layer, __XMapModel, __XMapView);
			
			if (!hasItemStorage ()) {
				initItemStorage ({"state": 1});
			}
			
			__setState ();
		}
		
		//------------------------------------------------------------------------------------------
		private function __setState ():void {
			if (getItemStorage ().state == 2) {
				m_currentX *= -1.0;
				m_currentY *= -1.0;
				
				switch (m_direction) {
					case "left":
						m_direction = "right";
						break;
					case "right":
						m_direction = "left";
						break;
					case "up":
						m_direction = "down";
						break;
					case "down":
						m_direction = "up";
						break;
				}
			}
		}
		
		//------------------------------------------------------------------------------------------
		private function __setupItemParamsXML ():void {
			setupItemParamsXML ();
			
			m_currentX = m_currentY = 0.0;
			
			m_zone = -1;
			if (itemHasAttribute ("zone")) {
				m_zone = itemGetAttribute ("zone");
			}
			
			m_message = "";
			if (itemHasAttribute ("message")) {
				m_message = itemGetAttribute ("message");	
			}
			
			if (itemHasAttribute ("direction")) {
				m_direction = itemGetAttribute ("direction");
				
				switch (m_direction) {
					case "left":
						m_currentX = -1.0;
						break;
					case "right":
						m_currentX = +1.0;
						break;
					case "up":
						m_currentY = -1.0;
						break;
					case "down":
						m_currentY = +1.0;
						break;
				}
			}
		}
		
		//------------------------------------------------------------------------------------------
		private function __setupSpawnScript ():void {
			var __dx:Number, __dy:Number;
			
			addTask ([
				XTask.LABEL, "loop",
					XTask.WAIT, 0x0600,
					
					function ():void {
						__dx = Math.abs (GX.app$.__getMickeyObject ().oX - oX);
						__dy = Math.abs (GX.app$.__getMickeyObject ().oY - oY);
						
						if (__dx < 512 && __dy < 512) {
							__spawnWaterCurrent ();	
						}
					},
					
					XTask.GOTO, "loop",
				
				XTask.RETN,
			]);
		}
		
		//------------------------------------------------------------------------------------------
		private function __spawnWaterCurrent ():void {	
			var __logicObject:XLogicObjectCX = xxx.getXLogicManager ().initXLogicObject (
				// parent
				this,
				// logicObject
				new m_WaterCurrentX () as XLogicObject,
				// item, layer, depth
				null, getLayer (), getDepth (),
				// x, y, z
				0, 0, 0,
				// scale, rotation
				1.0, 0
			) as XLogicObjectCX;
			
			switch (m_direction) {
				case "left":
					__logicObject.oDX = -6.0;
					__logicObject.oX += Math.random () * 32 - 16;
					__logicObject.oY += Math.random () * 96 - 48;
					__logicObject.oRotation = 90.0;
					break;
				case "right":
					__logicObject.oDX = +6.0;
					__logicObject.oX += Math.random () * 32 - 16;
					__logicObject.oY += Math.random () * 96 - 48;
					__logicObject.oRotation = 270.0;
					break;
				case "up":
					__logicObject.oDY = -6.0;
					__logicObject.oX += Math.random () * 96 - 48;
					__logicObject.oY += Math.random () * 32 - 16;
					__logicObject.oRotation = 0.0;
					break;
				case "down":
					__logicObject.oDY = +6.0;
					__logicObject.oX += Math.random () * 96 - 48;
					__logicObject.oX += Math.random () * 32 - 16;
					__logicObject.oRotation = 180.0;
					break;				
			}
			
			addXLogicObject (__logicObject);
		}
		
		//------------------------------------------------------------------------------------------
		private function __setupDetectionScript ():void {
			var __mickeyRect:XRect = new XRect ();
			var __currentRect:XRect = new XRect ();
			
			getCX ().copy2 (__currentRect);
			__currentRect.offset (oX, oY);
			__currentRect.inflate (16, 16);
			
			addTask ([
				XTask.LABEL, "loop",
					XTask.WAIT, 0x0100,
					
					XTask.FLAGS, function (__task:XTask):void {
						if (!GX.app$.getLevelComplete ()) {
							GX.app$.__getMickeyObject ().getCX ().copy2 (__mickeyRect);
							__mickeyRect.offsetPoint (GX.app$.__getMickeyObject ().getPos ());
							
							__task.ifTrue (__currentRect.intersects (__mickeyRect));
						}
						else
						{
							__task.ifTrue (false);
						}
							
						}, XTask.BNE, "loop",
						
						function ():void {
							var __dx:Number;
							var __dy:Number;
							
							__dx = GX.app$.__getMickeyObject ().extraDX;
							if (m_currentX < 0) {
								__dx = Math.max (-16, __dx + m_currentX);
							}
							else
							{
								__dx = Math.min (+16, __dx + m_currentX);
							}
							GX.app$.__getMickeyObject ().extraDX = __dx;
							
							__dy = GX.app$.__getMickeyObject ().extraDY;
							if (m_currentY < 0) {
								__dy = Math.max (-16, __dy + m_currentY);
							}
							else
							{
								__dy = Math.min (+16, __dy + m_currentY);
							}
							GX.app$.__getMickeyObject ().extraDY = __dy;
						},
						
						XTask.GOTO, "loop",
					
					XTask.RETN,
			]);		
		}
		
		//------------------------------------------------------------------------------------------
		public function getZone ():Number {
			return m_zone;
		}
					
		//------------------------------------------------------------------------------------------
		private function onZoneStarted (__zone:Number):void {
		}
					
		//------------------------------------------------------------------------------------------
		private function onZoneFinished (__zone:Number):void {
			if (getZone () != __zone) {
				return;
			}
						
			if (getZone () == 1) {
				return;
			}
						
			if (getItemStorage ().state == 2) {
				return;
			}
			
			getItemStorage ().state = 2;
			
			__setState ();
			

			if (m_message == "__zone") {
// #TODO should be added as a param
				/*
				var __logicObject:XLogicObject = xxx.getXLogicManager ().initXLogicObject (
					// parent
					G.app$.getHudObject (),
					// logicObject
					new ZoneClearedX () as XLogicObject,
					// item, layer, depth
					null, -1, 0,
					// x, y, z
					192, 224, 0,
					// scale, rotation
					1.0, 0
				) as ZoneClearedX;	
		
				G.app$.getHudObject ().addXLogicObject (__logicObject);
				*/
			}
		}
					
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}