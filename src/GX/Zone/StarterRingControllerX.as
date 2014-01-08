//------------------------------------------------------------------------------------------
package GX.Zone {
	
	import GX.Messages.*;
	import GX.Messages.Level.*;
	
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
	public class StarterRingControllerX extends XLogicObjectCX {
		public var m_sprite:XMovieClip;
		public var x_sprite:XDepthSprite;
		public var script:XTask;
		public var m_zone:Number;
		
		//------------------------------------------------------------------------------------------
		public function StarterRingControllerX () {
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);
			
			createSprites ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setupX ():void {
			super.setupX ();
			
			setCX (-8, +8, -8, +8);
			
			var __xml:XSimpleXMLNode = new XSimpleXMLNode ();
			__xml.setupWithXMLString (item.params);
			
			m_zone = __xml.getAttribute ("zone");

			__createClickHereSprite ();
			
			script = addEmptyTask ();
			
			Ring_Script ();
			
			GX.app$.__getMickeyObject ().addWaitingListener (
				function ():void {
					trace (": waiting: ");
					
					oVisible = true;
				}
			);
			
			GX.app$.__getMickeyObject ().addPlayingListener (
				function ():void {
					trace (": playing: ");
					
					oVisible = false;
				}
			);
			
			addTask ([
				XTask.LABEL, "loop",
					function ():void { __spawnStarterRing (0.20); }, XTask.WAIT, 0x0200,
					function ():void { __spawnStarterRing (0.40); }, XTask.WAIT, 0x0200,
					function ():void { __spawnStarterRing (0.80); }, XTask.WAIT, 0x0200,
					function ():void { __spawnStarterRing (1.20); }, XTask.WAIT, 0x0200,
					function ():void { __spawnStarterRing (1.60); }, XTask.WAIT, 0x0200,
					
					XTask.WAIT, 0x0400,
					
					XTask.GOTO, "loop",
				
				XTask.RETN,
			]);
			
			/*
			addTask ([
				XTask.LABEL, "loop",
					function ():void { m_sprite.rotation += 2.5; }, XTask.WAIT, 0x0100,

				XTask.GOTO, "loop",
				
				XTask.RETN,
			]);
			*/
		}

		//------------------------------------------------------------------------------------------
		public override function cullObject ():void {	
		}

		//------------------------------------------------------------------------------------------
		private function __createClickHereSprite ():void {
			var __logicObject:XLogicObject = xxx.getXLogicManager ().initXLogicObject (
				// parent
				this,
				// logicObject
				new ClickHereMessageX () as XLogicObject,
				// item, layer, depth
				null, 0, 0,
				// x, y, z
				0, 0, 0,
				// scale, rotation
				1.0, 0
			) as ClickHereMessageX;
			
			addXLogicObject (__logicObject);
		}
		
		//------------------------------------------------------------------------------------------
		private function __spawnStarterRing (__scale:Number):void {
			var __logicObject:StarterRingX = xxx.getXLogicManager ().initXLogicObject (
				// parent
				this,
				// logicObject
				new StarterRingX as XLogicObject,
				// item, layer, depth
				null, getLayer (), getDepth (),
				// x, y, z
				0, 0, 0,
				// scale, rotation
				__scale, 0
			) as StarterRingX;
			
			addXLogicObject (__logicObject);
		}
		
		//------------------------------------------------------------------------------------------
		// create sprites
		//------------------------------------------------------------------------------------------
		public override function createSprites ():void {
			/*
			m_sprite = new (xxx.getClass ("ClickHere:ClickHere")) ();
			x_sprite = addSpriteAt (m_sprite, 0, 0);
			x_sprite.setDepth (10000);
			
			m_sprite.gotoAndStop (1);
			m_sprite.scaleX = m_sprite.scaleY = 1.75;
			*/
			
			show ();
		}
		
		//------------------------------------------------------------------------------------------
		public function getZone ():Number {
			return m_zone;
		}
		
		//------------------------------------------------------------------------------------------
		public override function updatePhysics ():void {
			super.updatePhysics ();
		}
		
		//------------------------------------------------------------------------------------------
		public function Ring_Script ():void {
			
			script.gotoTask ([
				
				//------------------------------------------------------------------------------------------
				// control
				//------------------------------------------------------------------------------------------
				function ():void {
					script.addTask ([
						XTask.LABEL, "loop",
							XTask.WAIT, 0x0100,
							
							function ():void {
							},
							
							XTask.GOTO, "loop",
						
						XTask.RETN,
					]);
					
				},
				
				//------------------------------------------------------------------------------------------
				// animation
				//------------------------------------------------------------------------------------------	
				XTask.LABEL, "loop",
					XTask.WAIT, 0x0100,
					
					/*
					function ():void { m_sprite.gotoAndStop (1); }, XTask.WAIT, 0x0800,
					function ():void { m_sprite.gotoAndStop (2); }, XTask.WAIT, 0x0800,
					*/
					
					XTask.GOTO, "loop",
				
				XTask.RETN,
				
			//------------------------------------------------------------------------------------------			
			]);
			
		//------------------------------------------------------------------------------------------
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}