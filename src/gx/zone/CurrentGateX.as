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

	import kx.*;
	import kx.geom.*;
	import kx.task.*;
	import kx.type.*;
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
	public class CurrentGateX extends XLogicObjectCX {
		public var script:XTask;
		
		public var m_WaterCurrentX:Class; // <Dynamic>
		
		public var m_direction:String;
		public var m_currentX:Number;
		public var m_currentY:Number;
		
		public var m_zone:Number;
		public var m_message:String;
		
		public var m_zoneStartedListenerID:int;
		public var m_zoneFinishedListenerID:int;
		
		//------------------------------------------------------------------------------------------
		public function CurrentGateX () {
			super ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array  /* <Dynamic> */):void {
			super.setup (__xxx, args);
		
			m_WaterCurrentX = getArg (args, 0);
			
			createSprites ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setupX ():void {
			super.setupX ();
			
			setCX (-64, +64, -64, +64);
	
			m_zoneStartedListenerID = GX.appX.addZoneStartedListener (onZoneStarted);
			m_zoneFinishedListenerID = GX.appX.addZoneFinishedListener (onZoneFinished);
			
			__setupItemParamsXML ();
			__setupSpawnScript ();
			__setupDetectionScript ();
			
			oVisible = true;
		}

		//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
			
			GX.appX.removeZoneStartedListener (m_zoneStartedListenerID);
			GX.appX.removeZoneFinishedListener (m_zoneFinishedListenerID);
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
		public override function setXMapModel (__layer:int, __XMapModel:XMapModel, __XMapView:XMapView=null):void {
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
				m_zone = itemGetAttributeInt ("zone");
			}
			
			m_message = "";
			if (itemHasAttribute ("message")) {
				m_message = itemGetAttributeString ("message");	
			}
			
			if (itemHasAttribute ("direction")) {
				m_direction = itemGetAttributeString ("direction");
				
				switch (m_direction) {
					case "left":
						m_currentX = -1.0;
						break;
					case "right":
						m_currentX = 1.0;
						break;
					case "up":
						m_currentY = -1.0;
						break;
					case "down":
						m_currentY = 1.0;
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
						__dx = Math.abs (GX.appX.__getMickeyObject ().oX - oX);
						__dy = Math.abs (GX.appX.__getMickeyObject ().oY - oY);
						
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
				/* @:cast */ XType.createInstance (m_WaterCurrentX) as XLogicObject,
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
					__logicObject.oDX = 6.0;
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
					__logicObject.oDY = 6.0;
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
						if (!GX.appX.getLevelComplete ()) {
							GX.appX.__getMickeyObject ().getCX ().copy2 (__mickeyRect);
							__mickeyRect.offsetPoint (GX.appX.__getMickeyObject ().getPos ());
							
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
							
							__dx = GX.appX.__getMickeyObject ().extraDX;
							if (m_currentX < 0) {
								__dx = Math.max (-16, __dx + m_currentX);
							}
							else
							{
								__dx = Math.min ( 16, __dx + m_currentX);
							}
							GX.appX.__getMickeyObject ().extraDX = __dx;
							
							__dy = GX.appX.__getMickeyObject ().extraDY;
							if (m_currentY < 0) {
								__dy = Math.max (-16, __dy + m_currentY);
							}
							else
							{
								__dy = Math.min ( 16, __dy + m_currentY);
							}
							GX.appX.__getMickeyObject ().extraDY = __dy;
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
		}
					
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}