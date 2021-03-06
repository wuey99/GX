//------------------------------------------------------------------------------------------
// <$begin$/>
// The MIT License (MIT)
//
// The "GX-Engine"
//
// Copyright (c) 2014 Jimmy Huey (wuey99@gmail.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
// <$end$/>
//------------------------------------------------------------------------------------------
package gx.zone {
	
	import gx.*;
	import gx.messages.*;
	import gx.text.*;
	
	import kx.*;
	import kx.geom.*;
	import kx.task.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	import kx.xml.*;
	import kx.xmap.*;
	
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	
	//------------------------------------------------------------------------------------------
	public class DoorX extends XLogicObjectCX {
		public var m_sprite:XMovieClip;
		public var x_sprite:XDepthSprite;

		public var script:XTask;
		public var gravity:XTask;
		
		public var m_trigger:int;
		
		public var m_opened:Boolean = false;
		
		public var m_triggerListener:int;
		
		//------------------------------------------------------------------------------------------
		public function DoorX () {
			super ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array  /* <Dynamic> */):void {
			super.setup (__xxx, args);
			
			createSprites ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setupX ():void {
			super.setupX ();
			
			setCX (-8, 8, -8, 8);
			
			var __xml:XSimpleXMLNode = m_xml = new XSimpleXMLNode ();
			__xml.setupWithXMLString (item.params);

			m_trigger = -1;
			if (__xml.hasAttribute ("trigger")) {
				m_trigger = __xml.getAttribute ("trigger");
			}

			gravity = addEmptyTask ();
			script = addEmptyTask ();
			
			gravity.gotoTask (getPhysicsTaskX (0.25));
			
			Idle_Script ();
			
			m_triggerListener = GX.appX.addTriggerListener (triggerDoor);
			
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
			
			GX.appX.removeTriggerListener (m_triggerListener);
		}
		
		//------------------------------------------------------------------------------------------
		public override function cullObject ():void {	
		}
		
		//------------------------------------------------------------------------------------------
		public override function setXMapModel (__layer:int, __XMapModel:XMapModel, __XMapView:XMapView=null):void {
			trace (":  GateX: setXMapModel: ", __layer, __XMapModel, __XMapView);
			trace (": xml: ", m_xml.toXMLString ());
			
			super.setXMapModel (__layer, __XMapModel, __XMapView);
			
			trace (": getXMapLayerModel: ", getXMapLayerModel ());

			setCXTiles ();
		}

		//------------------------------------------------------------------------------------------
		public function triggerDoor (__trigger:int):void {
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
	
			c1 = int (__r.left/XSubmapModel.CX_TILE_WIDTH);
			r1 = int (__r.top/XSubmapModel.CX_TILE_HEIGHT);
			c2 = int (__r.right/XSubmapModel.CX_TILE_WIDTH);
			r2 = int (__r.bottom/XSubmapModel.CX_TILE_HEIGHT);
			
			var __length:int = (c2-c1) * (r2-r1);
			
			var __tiles:Array /* <Int> */ = new Array (); /* <Int> */
	
			var i:int;
			
			for (i=0; i<__length; i++) {
				__tiles.push (XSubmapModel.CX_EMPTY);
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
			
			c1 = int (__r.left/XSubmapModel.CX_TILE_WIDTH);
			r1 = int (__r.top/XSubmapModel.CX_TILE_HEIGHT);
			c2 = int (__r.right/XSubmapModel.CX_TILE_WIDTH);
			r2 = int (__r.bottom/XSubmapModel.CX_TILE_HEIGHT);
			
			var __length:int = (c2-c1) * (r2-r1);
			
			var __tiles:Array /* <Int> */ = new Array (); /* <Int> */
			
			var i:int;
			
			for (i=0; i<__length; i++) {
				__tiles.push (XSubmapModel.CX_SOLID);
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
		public function getPhysicsTaskX (DECCEL:Number):Array /* <Dynamic> */ {
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
		public function Open_Script (__finallyCallback:Function):void {
			
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
					XTask.EXEC, openGateAnimationX (),
					
					function ():void {
						__finallyCallback ();
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
		public function openGateAnimationX ():Array /* <Dynamic> */ {
			return [				
				XTask.RETN,
			];
		}
		
		//------------------------------------------------------------------------------------------
		public function closeGateAnimationX ():Array /* <Dynamic> */ {
			return [
				XTask.RETN,
			];
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}