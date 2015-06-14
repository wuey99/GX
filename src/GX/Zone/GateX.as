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
	public class GateX extends XLogicObjectCX {
		public var m_sprite:XMovieClip;
		public var x_sprite:XDepthSprite;
		public var m_goSprite:XMovieClip;
		public var x_goSprite:XDepthSprite;
		
		public var script:XTask;
		public var gravity:XTask;
		
		public var m_zone:Number;
		public var m_exit:Boolean;
		public var m_gate:Number;
		public var m_direction:String;
		public var m_go:Boolean;
		
		public var m_GateArrowX:Class;
		
		//------------------------------------------------------------------------------------------
		public function GateX () {
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);
			
			if (args.length == 0) {
				m_GateArrowX = null;
			}
			else
			{
				m_GateArrowX = getArg (args, 0);
			}
			
			createSprites ();
			
//			x_sprite.visible2 = false;
		}
		
		//------------------------------------------------------------------------------------------
		public override function setupX ():void {
			super.setupX ();
			
			setCX (-8, +8, -8, +8);
			
			var __xml:XSimpleXMLNode = m_xml = new XSimpleXMLNode ();
			__xml.setupWithXMLString (item.params);
			
			m_zone = __xml.getAttribute ("zone");
			m_exit = __xml.getAttribute ("exit") == "true";
			
			m_direction = "null";
			if (__xml.hasAttribute ("direction")) {
				m_direction = __xml.getAttribute ("direction");
			}
			
			if (!m_exit) {
				m_gate = __xml.getAttribute ("gate");
			}
			
			m_go = false;
			
			trace (": zone, exit: ", m_zone, m_exit, m_gate);
			
			if (!m_exit) {
				if (m_gate == 1) {
					x_sprite.visible2 = false;
				}
				else
				{
					x_sprite.visible2 = true;
				}
			}
			
			GX.appX.addZoneStartedListener (onZoneStarted);
			GX.appX.addZoneFinishedListener (onZoneFinished);
			
			createGoSprite ();
			
			gravity = addEmptyTask ();
			script = addEmptyTask ();
			
			gravity.gotoTask (getPhysicsTaskX (0.25));
			
			Locked_Script ();
			
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
			
			GX.appX.removeZoneStartedListener (onZoneStarted);
			GX.appX.removeZoneFinishedListener (onZoneFinished);
		}

		//------------------------------------------------------------------------------------------
		public function createGoSprite ():void {
			if (m_direction == "null" || m_GateArrowX == null) {
				return;
			}
			
			m_goSprite = createXMovieClip ("GO:GO");
			
			var __r:XRect = boundingRect;
			
			x_goSprite = addSpriteAt (m_goSprite, -(__r.right-__r.left)/2, -(__r.bottom - __r.top)/2);
			
			m_goSprite.gotoAndStop (3);
			x_goSprite.visible2 = false;
			m_go = false;
			
			if (m_direction == "right") {
				m_goSprite.rotation = 0;
			}
			if (m_direction == "up") {
				m_goSprite.rotation = 270;
			}
			if (m_direction == "left") {
				m_goSprite.rotation = 180;
			}
			if (m_direction == "down") {
				m_goSprite.rotation = 90;
			}
			
			addTask ([
				XTask.LABEL, "loop",
					XTask.WAIT, 0x0100,
					
					XTask.FLAGS, function (__task:XTask):void {
						__task.ifTrue (m_go);
					}, XTask.BNE, "loop",
					
					XTask.LOOP, 3,
					
						XTask.WAIT, 0x0900,
						
						function ():void {
							var __logicObject:XLogicObject = xxx.getXLogicManager ().initXLogicObject (
								// parent
								GX.appX.getLevelObject (),
								// logicObject
								new m_GateArrowX () as XLogicObject,
								// item, layer, depth
								null, 0, getDepth () + 1,
								// x, y, z
								getPos ().x + (__r.right - __r.left)/2, getPos ().y + (__r.bottom - __r.top)/2 , 0,
								// scale, rotation
								1.0, 0,
								m_direction
							) as XLogicObject;	
							
							GX.appX.getLevelObject ().addXLogicObject (__logicObject);
						},
					
					XTask.NEXT,
					
					XTask.WAIT, 0x1400,
					
					XTask.GOTO, "loop",
					
					XTask.RETN,
			]);
			
			/*
			xxx.getXLogicManager ().initXLogicObject (
				// parent
				null,
				// logicObject
				new SpriteTextX () as XLogicObject,
				// item, layer, depth
				null, 0, getDepth () + 1,
				// x, y, z
				getPos ().x + (__r.right - __r.left)/2 - 16, getPos ().y + (__r.bottom - __r.top)/2 - 12 , 0,
				// scale, rotation
				1.0, 0,
				"GO!"
			) as SpriteTextX;
			*/
		}
		
		//------------------------------------------------------------------------------------------
		public override function cullObject ():void {	
		}
		
		//------------------------------------------------------------------------------------------
		public override function setXMapModel (__layer:Number, __XMapModel:XMapModel, __XMapView:XMapView=null):void {
			trace (":  GateX: setXMapModel: ", __layer, __XMapModel, __XMapView);
			trace (": xml: ", m_xml.toXMLString ());
			
			super.setXMapModel (__layer, __XMapModel, __XMapView);

			if (!hasItemStorage ()) {
				initItemStorage ({"state": 1});
			}
			
			trace (": getXMapLayerModel: ", getXMapLayerModel ());
			
			if (m_exit) {
				setCXTiles ();
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function getZone ():Number {
			return m_zone;
		}
		
		//------------------------------------------------------------------------------------------
		private function onZoneStarted (__zone:Number):void {		
			if (getZone () != __zone || m_exit) {
				return;
			}
			
			if (m_gate == 1) {				
				Lowering_Script (
					function ():void {}
				);
			}
			else
			{
				eraseCXTiles ();
				
				Opening_Script (Unlocked_Entry_Script);
			}
		}
		
		//------------------------------------------------------------------------------------------
		private function onZoneFinished (__zone:Number):void {
			if (getZone () != __zone || !m_exit) {
				return;
			}
			
			eraseCXTiles ();

			trace (": ---------->: ", getItemStorage ().state);
			
			if (getItemStorage ().state == 2) {
				return;
			}
			
			getItemStorage ().state = 2;
			
			Opening_Script (Unlocked_Exit_Script);
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
		public function getPhysicsTaskX (DECCEL:Number):Array {
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
		public function Locked_Script ():void {
			
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
					function ():void { m_sprite.gotoAndStop (1); }, XTask.WAIT, 0x0300,					
				
				XTask.GOTO, "loop",
				
				XTask.RETN,
				
				//------------------------------------------------------------------------------------------			
			]);
			
			//------------------------------------------------------------------------------------------
		}
		
		//------------------------------------------------------------------------------------------
		public function Opening_Script (__finally:Function):void {

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
						__finally ();
					},
	
//						XTask.GOTO, "loop",
				
				XTask.RETN,
				
				//------------------------------------------------------------------------------------------			
			]);
			
		//------------------------------------------------------------------------------------------
		}
		
		//------------------------------------------------------------------------------------------
		public function Lowering_Script (__finally:Function):void {

			setCXTiles ();
			
			x_sprite.visible2 = true;
			
			m_sprite.gotoAndStop (25);
				
			//------------------------------------------------------------------------------------------
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
					XTask.EXEC, closeGateAnimationX (),
					
					function ():void {
						__finally ();
					},
				
//					XTask.GOTO, "loop",
				
				XTask.RETN,
				
				//------------------------------------------------------------------------------------------			
			]);
			
			//------------------------------------------------------------------------------------------
		}
		
		//------------------------------------------------------------------------------------------
		public function Unlocked_Exit_Script ():void {
//			x_goSprite.visible2 = true;
			m_go = true;
			
			if (x_goSprite == null) {
				return;
			}
			
			var __rp:XPoint = x_goSprite.getRegistration ();
			
			//------------------------------------------------------------------------------------------		
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
					XTask.LOOP, 6,
					function ():void {
						__rp.x -= 4.0;
					}, XTask.WAIT, 0x0100,
					XTask.NEXT,
					
					XTask.LOOP, 12,
					function ():void {
						__rp.x += 4.0;
					}, XTask.WAIT, 0x0100,
					XTask.NEXT,
					
					XTask.LOOP, 6,
					function ():void {
						__rp.x -= 4.0;
					}, XTask.WAIT, 0x0100,
					XTask.NEXT,	
					
					XTask.GOTO, "loop",
				
				XTask.RETN,
				
				//------------------------------------------------------------------------------------------			
			]);
			
			//------------------------------------------------------------------------------------------
		}
		
		//------------------------------------------------------------------------------------------
		public function Unlocked_Entry_Script ():void {

			//------------------------------------------------------------------------------------------		
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
					function ():void {
						eraseCXTiles ();
					},
					
//					XTask.GOTO, "loop",
				
				XTask.RETN,
				
				//------------------------------------------------------------------------------------------			
			]);
			
			//------------------------------------------------------------------------------------------
		}
		
		//------------------------------------------------------------------------------------------
		public function openGateAnimationX ():Array {
			return [				
				XTask.RETN,
			];
		}
		
		//------------------------------------------------------------------------------------------
		public function closeGateAnimationX ():Array {
			return [
				XTask.RETN,
			];
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}