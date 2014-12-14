//------------------------------------------------------------------------------------------
// <$begin$/>
// <$end$/>
//------------------------------------------------------------------------------------------
package GX.Zone {
	import GX.Messages.*;
	import GX.Text.*;
	
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
	public class DoorX extends XLogicObjectCX {
		public var m_sprite:XMovieClip;
		public var x_sprite:XDepthSprite;

		public var script:XTask;
		public var gravity:XTask;
		
		public var m_trigger:Number;
		
		public var m_opened:Boolean = false;
		
		//------------------------------------------------------------------------------------------
		public function DoorX () {
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
			
			var __xml:XSimpleXMLNode = m_xml = new XSimpleXMLNode ();
			__xml.setupWithXMLString (item.params);

			m_trigger = -1;
			if (__xml.hasAttribute ("trigger")) {
				m_trigger = __xml.getAttribute ("trigger");
			}

			gravity = addEmptyTask ();
			script = addEmptyTask ();
			
			gravity.gotoTask (getPhysicsTask$ (0.25));
			
			Idle_Script ();
			
			GX.app$.addTriggerListener (triggerDoor);
			
			m_opened = false;
			
			addTask ([
				XTask.LABEL, "loop",
					XTask.WAIT, 0x0100,
					
					function ():void {
					}, 
					
					XTask.GOTO, "loop",
				
				XTask.RETN,
			]);
		}

		//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
			
			GX.app$.removeTriggerListener (triggerDoor);
		}
		
		//------------------------------------------------------------------------------------------
		public override function cullObject ():void {	
		}
		
		//------------------------------------------------------------------------------------------
		public override function setXMapModel (__layer:Number, __XMapModel:XMapModel, __XMapView:XMapView=null):void {
			trace (":  GateX: setXMapModel: ", __layer, __XMapModel, __XMapView);
			trace (": xml: ", m_xml.toXMLString ());
			
			super.setXMapModel (__layer, __XMapModel, __XMapView);
			
			trace (": getXMapLayerModel: ", getXMapLayerModel ());

			setCXTiles ();
		}

		//------------------------------------------------------------------------------------------
		public function triggerDoor (__trigger:Number):void {
			if (m_opened) {
				return;
			}
			
			if (__trigger == m_trigger) {
				m_opened = true;
				
				Open_Script (
					function ():void {
					}
				);
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function eraseCXTiles ():void {
			var c1:int, r1:int, c2:int, r2:int;
			
			var __r:XRect = xxx.getXRectPoolManager ().borrowObject () as XRect;		
			getBoundingRect ().copy2 (__r);
			__r.offsetPoint (getPos ());
	
			c1 = Math.floor (__r.left/XSubmapModel.CX_TILE_WIDTH);
			r1 = Math.floor (__r.top/XSubmapModel.CX_TILE_HEIGHT);
			c2 = Math.floor (__r.right/XSubmapModel.CX_TILE_WIDTH);
			r2 = Math.floor (__r.bottom/XSubmapModel.CX_TILE_HEIGHT);
			
			var __length:Number = (c2-c1) * (r2-r1);
			
			var __tiles:Array = new Array (__length)
	
			var i:Number;
			
			for (i=0; i<__length; i++) {
				__tiles[i] = XSubmapModel.CX_EMPTY;
			}
			
			trace (": xml: ", m_xml.toXMLString ());
			trace (": c1, r1, c2, r2: ", c1, r1, c2, r2);
			trace (": layerModel: ", getXMapLayerModel ());
			
			if (getXMapLayerModel () != null) {
				getXMapLayerModel ().setCXTiles (__tiles, c1, r1, c2-1, r2-1);
			}
			
			xxx.getXRectPoolManager ().returnObject (__r);
		}
		
		//------------------------------------------------------------------------------------------
		public function setCXTiles ():void {
			var c1:int, r1:int, c2:int, r2:int;
			
			var __r:XRect = xxx.getXRectPoolManager ().borrowObject () as XRect;
			getBoundingRect ().copy2 (__r);
			__r.offsetPoint (getPos ());
			
			c1 = Math.floor (__r.left/XSubmapModel.CX_TILE_WIDTH);
			r1 = Math.floor (__r.top/XSubmapModel.CX_TILE_HEIGHT);
			c2 = Math.floor (__r.right/XSubmapModel.CX_TILE_WIDTH);
			r2 = Math.floor (__r.bottom/XSubmapModel.CX_TILE_HEIGHT);
			
			var __length:Number = (c2-c1) * (r2-r1);
			
			var __tiles:Array = new Array (__length)
			
			var i:Number;
			
			for (i=0; i<__length; i++) {
				__tiles[i] = XSubmapModel.CX_SOLID;
			}

			trace (": ----------------------------------------------: ");
			trace (": xml: ", m_xml.toXMLString ());
			trace (": c1, r1, c2, r2: ", c1, r1, c2, r2);
			trace (": layerModel: ", getXMapLayerModel ());

			if (getXMapLayerModel () != null) {
				getXMapLayerModel ().setCXTiles (__tiles, c1, r1, c2-1, r2-1);
			}
			
			xxx.getXRectPoolManager ().returnObject (__r);
		}
		
		//------------------------------------------------------------------------------------------
		public function getPhysicsTask$ (DECCEL:Number):Array {
			return [
				XTask.LABEL, "loop",
					XTask.WAIT, 0x0100,
					updatePhysics,	
					XTask.GOTO, "loop",
				
				XTask.RETN,
			];
		}
		
		//------------------------------------------------------------------------------------------
		public override function updatePhysics ():void {
		}

		//------------------------------------------------------------------------------------------
		public function getBoundingRect ():XRect {
			return new XRect (0, 0, 128, 128);	
		}
		
		//------------------------------------------------------------------------------------------
		public function Idle_Script ():void {
			
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
					
					XTask.GOTO, "loop",
				
				XTask.RETN,
				
				//------------------------------------------------------------------------------------------			
			]);
			
			//------------------------------------------------------------------------------------------
		}
		
		
		//------------------------------------------------------------------------------------------
		public function Open_Script (__finally:Function):void {
// #TODO figure out where to add SFX later
			/*
			var __guid:Number = G.app$.getEnvironmentSoundManager ().playSoundFromClass (
				_Assets.SFX_Door_Sliding_Loop,
				2.0,
				999
			);
			*/
			
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
					XTask.EXEC, openGateAnimation$ (),
					
					function ():void {
// #TODO pass function to call SFX
/*
						G.app$.getEnvironmentSoundManager ().stopSound (__guid);
						
						G.app$.getEnvironmentSoundManager ().playSoundFromClass (
							_Assets.SFX_Door_Open_Only
						);
*/						
						__finally ();
					},
	
				XTask.LABEL, "wait",
					XTask.WAIT, 0x0100,
					
					XTask.GOTO, "wait",
				
				XTask.RETN,
				
				//------------------------------------------------------------------------------------------			
			]);
			
		//------------------------------------------------------------------------------------------
		}
		
		//------------------------------------------------------------------------------------------
		public function openGateAnimation$ ():Array {
			return [				
				XTask.RETN,
			];
		}
		
		//------------------------------------------------------------------------------------------
		public function closeGateAnimation$ ():Array {
			return [
				XTask.RETN,
			];
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}