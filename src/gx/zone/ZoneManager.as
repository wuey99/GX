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
	
	import kx.collections.*;
	import kx.geom.*;
	import kx.pool.*;
	import kx.task.*;
	import kx.type.*;
	import kx.world.*;
	import kx.world.logic.*;
	import kx.*;
	import kx.xmap.*;
	
	//------------------------------------------------------------------------------------------
	public class ZoneManager extends Object {
		private var xxx:XWorld;
		private var m_XApp:XApp;
		
		private var m_starterRingItems:XDict;
		private var m_starterRingItemObjects:XDict;
		
		private var m_zoneItems:XDict;
		private var m_zoneItemObjects:XDict;
		
		private var m_gateItems:XDict;
		private var m_gateItemObjects:XDict;
		
		private var m_currentGateItems:XDict;
		private var m_currentGateItemObjects:XDict;	
		
		private var m_doorItems:XDict;
		private var m_doorItemObjects:XDict;
		
		private var m_zoneKillCount:int;
		
		private var m_playFieldLayer:int;
		private var m_zoneObjectsMap:Object;
		private var m_zoneObjectsMapNoKill:Object;
		private var m_Horz_GateX:Class; // <Dynamic>
		private var m_Vert_GateX:Class; // <Dynamic>
		private var m_Horz_DoorX:Class; // <Dynamic>
		private var m_Vert_DoorX:Class; // <Dynamic>
		private var m_GateArrowX:Class; // <Dynamic>
		private var m_WaterCurrentX:Class; // <Dynamic>
		private var m_StarterRingControllerX:Class; // <Dynamic>
		
		//------------------------------------------------------------------------------------------
		public function ZoneManager () {
			super ();
		}
		
		//------------------------------------------------------------------------------------------
		public function setup (
			__xxx:XWorld,
			__XApp:XApp,
			__playfieldLayer:int,
			__zoneObjectsMap:Object,
			__zoneObjectsMapNoKill:Object,
			__Horz_GateX:Class /* <Dynamic> */,
			__Vert_GateX:Class /* <Dynamic> */,
			__Horz_DoorX:Class /* <Dynamic> */,
			__Vert_DoorX:Class /* <Dynamic> */,
			__GateArrowX:Class /* <Dynamic> */,
			__WaterCurrentX:Class /* <Dynamic> */,
			__StarterRingControllerX:Class  /* <Dynamic> */
		):void {
			xxx = __xxx;
			m_XApp = __XApp;
			
			m_playFieldLayer = __playfieldLayer;
			
			m_zoneObjectsMap = __zoneObjectsMap;
			m_zoneObjectsMapNoKill = __zoneObjectsMapNoKill;
			
			m_Horz_GateX = __Horz_GateX;
			m_Vert_GateX = __Vert_GateX;
			m_Horz_DoorX = __Horz_DoorX;
			m_Vert_DoorX = __Vert_DoorX;
			m_GateArrowX = __GateArrowX;
			m_WaterCurrentX = __WaterCurrentX;
			m_StarterRingControllerX = __StarterRingControllerX;
		}
		
		//------------------------------------------------------------------------------------------
		public function cleanup ():void {
		}
		
		//------------------------------------------------------------------------------------------
		public function setCurrentZone (__zone:Number):void {
			GX.appX.m_currentZone = __zone;
			
			resetZoneKillCount ();
			
			var __layerModel:XMapLayerModel = xxx.getXMapModel ().getLayer (m_playFieldLayer + 0);
			var __currentZoneItemObject:ZoneX = getZoneItemObject (getCurrentZone ());
			var __itemRect:XRect = new XRect ();
			var __list:XDict = new XDict ();
			
			//------------------------------------------------------------------------------------------
			trace (": currentItemZoneObject: ", __currentZoneItemObject, __currentZoneItemObject.boundingRect);
			trace (": itemRect: ", __itemRect);
			
			//------------------------------------------------------------------------------------------
			if (__currentZoneItemObject == null) {
				throw (Error ("no zone item object found!"));	
			}
			
			//------------------------------------------------------------------------------------------
			// find all items that intersect zone's boundingRect
			//------------------------------------------------------------------------------------------
			trace (": zoneRect: ", __currentZoneItemObject.boundingRect);
			
			__layerModel.iterateAllSubmaps (
				function (__XSubmapModel:XSubmapModel, __row:int, __col:int):void {
					__XSubmapModel.iterateAllItems (
						function (x:*):void {
							var __item:XMapItemModel = x as XMapItemModel;
							
							__item.boundingRect.copy2 (__itemRect);
							__itemRect.offset (__item.x, __item.y);
							
							if (
								__currentZoneItemObject.boundingRect.width != 0 && __currentZoneItemObject.boundingRect.height != 0 &&
								__currentZoneItemObject.boundingRect.intersects (__itemRect) &&
								isValidZoneObjectItem (__item.XMapItem)) {
								trace (": itemRect: ", __item.logicClassName, __itemRect);
								
								__list.set (__item.id, __item);
							}
						}
					);
				}
			);
			
			//------------------------------------------------------------------------------------------
			// find killCount for the zone
			//------------------------------------------------------------------------------------------
			__list.forEach (
				function (__id:*):void {
					var __item:XMapItemModel = __list.get (__id) as XMapItemModel;
					// objects are double instantiated here.  normal XMapLayerView instantiates it first sometimes.
					
					var __logicObject:ZoneObjectCX;
					
					if (!__item.inuse) {
						__logicObject = GX.appX.getLevelObject ().addXMapItem (__item, 0) as ZoneObjectCX;
					}
					else
					{
						__logicObject = GX.appX.getLevelObject ().getXLogicObject (__item) as ZoneObjectCX;
					}
					
					trace (": setCurrentZone: item: ", __item.logicClassName, __logicObject);
					
					if (__logicObject != null) {
						__logicObject.setAsPersistedObject (true);
						
						if (!isZoneObjectItemNoKill (__item.XMapItem)) {
							addToZoneKillCount ();
						}
					}
				}	
			);
			
			//----------------------------------------------------------------------------------------
			trace (": zoneKillCount: ", m_zoneKillCount);
			
			m_XApp.getXTaskManager ().addTask ([
				XTask.WAIT, 0x0800,
				
				function ():void {
					if (m_zoneKillCount == 0) {
						GX.appX.fireZoneFinishedSignal ();
					}
				},
				
				XTask.RETN,
			]);
		}
				
		//------------------------------------------------------------------------------------------
		public function getCurrentZone ():Number {
			return GX.appX.m_currentZone;
		}
		
		//------------------------------------------------------------------------------------------
		// m_zoneItems: map of all zone items in the level
		// we iterate through all the zome items and instantiate XLogicObjects for each.
		//      m_zoneItemObjects: map of all the instantiated zoneItemObjects 
		//		
		// m_starterItems: map of all the start items in the level
		// we iterate through all the zone items and instantiate XLogicObjects for each.
		//      m_starterItemObjects: map of all the instantiated startItemObjects
		//
		// m_gateItems: map of all the gate items in the level (horz and vert)
		// we iterate through all the gate items and instantiate XLogicObjects for each.
		//     m_gateItemObjects: map of all the instantiated gateItemObjects
		//------------------------------------------------------------------------------------------
		public function getAllGlobalItems ():void {
			var __layerModel:XMapLayerModel = xxx.getXMapModel ().getLayer (m_playFieldLayer + 0);
					
			//------------------------------------------------------------------------------------------
			m_zoneItems = __layerModel.lookForItem ("Zone_Item");
					
			m_zoneItemObjects = new XDict ();
					
			m_zoneItems.forEach (
				function (__id:*):void {
					var __item:XMapItemModel = m_zoneItems.get (__id);
							
					var __zoneItemObject:ZoneX = xxx.getXLogicManager ().initXLogicObject (
						// parent
						GX.appX.getLevelObject (),
						// logicObject
						new ZoneX () as XLogicObject,
						// item, layer, depth
						__item, m_playFieldLayer + 0, 10000,
						// x, y, z
						__item.x, __item.y, 0,
						// scale, rotation
						1.0, 0
					) as ZoneX;
							
					GX.appX.getLevelObject ().addXLogicObject (__zoneItemObject);
							
					__item.inuse++;
							
					m_zoneItemObjects.set (__zoneItemObject.getZone (), __zoneItemObject);
				}
			);
					
			//------------------------------------------------------------------------------------------
			m_starterRingItems = __layerModel.lookForItem ("StarterRing_Item");
					
			m_starterRingItemObjects = new XDict ();
					
			m_starterRingItems.forEach (
				function (__id:*):void {
					var __item:XMapItemModel = m_starterRingItems.get (__id);
							
					var __starterRingItemObject:StarterRingControllerX = xxx.getXLogicManager ().initXLogicObject (
						// parent
						GX.appX.getLevelObject (),
						// logicObject
						XType.createInstance (m_StarterRingControllerX) as XLogicObject,
						// item, layer, depth
						__item, m_playFieldLayer + 0, 10000,
						// x, y, z
						__item.x, __item.y, 0,
						// scale, rotation
						1.0, 0
					) as StarterRingControllerX;
							
					GX.appX.getLevelObject ().addXLogicObject (__starterRingItemObject);
							
					__item.inuse++;
							
					m_starterRingItemObjects.set (__starterRingItemObject.getZone (), __starterRingItemObject);
				}
			);
					
			//------------------------------------------------------------------------------------------
			m_gateItems = __layerModel.lookForItem ("Horz_Gate_Item");
			m_gateItems = __layerModel.lookForItem ("Vert_Gate_Item", m_gateItems);
					
			m_gateItemObjects = new XDict ();
					
			if (m_Horz_GateX != null && m_Vert_GateX != null) m_gateItems.forEach (
				function (__id:*):void {
					var __item:XMapItemModel = m_gateItems.get (__id);
							
					var __gateItemObject:GateX;
							
					trace (": gateItems: ", __item.id, __item.XMapItem);
							
					if (__item.XMapItem == "Horz_Gate_Item") {
						__gateItemObject = xxx.getXLogicManager ().initXLogicObject (
							// parent
							GX.appX.getLevelObject (),
							// logicObject
							XType.createInstance (m_Horz_GateX) as XLogicObject,
							// item, layer, depth
							__item, m_playFieldLayer + 0, 10000,
							// x, y, z
							__item.x, __item.y, 0,
							// scale, rotation
							1.0, 0,
							[
								m_GateArrowX
							]
						) as GateX;
					}
					else
					{
						__gateItemObject = xxx.getXLogicManager ().initXLogicObject (
							// parent
							GX.appX.getLevelObject (),
							// logicObject
							XType.createInstance (m_Vert_GateX) as XLogicObject,
							// item, layer, depth
							__item, m_playFieldLayer + 0, 10000,
							// x, y, z
							__item.x, __item.y, 0,
							// scale, rotation
							1.0, 0,
							[
								m_GateArrowX
							]
						) as GateX;	
					}
							
					GX.appX.getLevelObject ().addXLogicObject (__gateItemObject);
							
					__item.inuse++;
							
					__gateItemObject.setXMapModel (GX.appX.__getMickeyObject ().getLayer () + 1, xxx.getXMapModel (), GX.appX.getLevelObject ());	
				}
			);
					
			//------------------------------------------------------------------------------------------
			m_doorItems = __layerModel.lookForItem ("Horz_Door_Item");
			m_doorItems = __layerModel.lookForItem ("Vert_Door_Item", m_doorItems);
					
			m_doorItemObjects = new XDict ();
					
			if (m_Horz_DoorX != null && m_Vert_DoorX != null) m_doorItems.forEach (
				function (__id:*):void {
					var __item:XMapItemModel = m_doorItems.get (__id);
							
					var __doorItemObject:DoorX;
							
					trace (": doorItems: ", __item.id, __item.XMapItem);
							
					if (__item.XMapItem == "Horz_Door_Item") {
						__doorItemObject = xxx.getXLogicManager ().initXLogicObject (
							// parent
							GX.appX.getLevelObject (),
							// logicObject
							XType.createInstance (m_Horz_DoorX) as XLogicObject,
							// item, layer, depth
							__item, m_playFieldLayer + 0, 10000,
							// x, y, z
							__item.x, __item.y, 0,
							// scale, rotation
							1.0, 0
						) as DoorX;
					}
					else
					{
						__doorItemObject = xxx.getXLogicManager ().initXLogicObject (
							// parent
							GX.appX.getLevelObject (),
							// logicObject
							XType.createInstance (m_Vert_DoorX) as XLogicObject,
							// item, layer, depth
							__item, m_playFieldLayer + 0, 10000,
							// x, y, z
							__item.x, __item.y, 0,
							// scale, rotation
							1.0, 0
						) as DoorX;	
					}
							
					GX.appX.getLevelObject ().addXLogicObject (__doorItemObject);
							
					__item.inuse++;
							
					__doorItemObject.setXMapModel (GX.appX.__getMickeyObject ().getLayer () + 1, xxx.getXMapModel (), GX.appX.getLevelObject ());	
				}
			);
					
			//------------------------------------------------------------------------------------------
			m_currentGateItems = __layerModel.lookForItem ("Current_Gate_Item");
					
			m_currentGateItemObjects = new XDict ();
					
			m_currentGateItems.forEach (
				function (__id:*):void {
					var __item:XMapItemModel = m_currentGateItems.get (__id);
							
					var __currentGateItemObject:CurrentGateX;
							
					trace (": currentGateItems: ", __item.id, __item.XMapItem);
							
					__currentGateItemObject = xxx.getXLogicManager ().initXLogicObject (
						// parent
						GX.appX.getLevelObject (),
						// logicObject
						new CurrentGateX () as XLogicObject,
						// item, layer, depth
						__item, m_playFieldLayer + 0, 10000,
						// x, y, z
						__item.x, __item.y, 0,
						// scale, rotation
						1.0, 0,
						[
							m_WaterCurrentX
						]
					) as CurrentGateX;
							
					GX.appX.getLevelObject ().addXLogicObject (__currentGateItemObject);
							
					__item.inuse++;
							
					__currentGateItemObject.setXMapModel (GX.appX.__getMickeyObject ().getLayer () + 1, xxx.getXMapModel (), GX.appX.getLevelObject ());	
				}
			);
		}
				
		//------------------------------------------------------------------------------------------
		public function isValidZoneObjectItem (__itemName:String):Boolean {
			return __itemName in m_zoneObjectsMap;
		}
				
		//------------------------------------------------------------------------------------------
		public function isZoneObjectItemNoKill (__itemName:String):Boolean {
			return __itemName in m_zoneObjectsMapNoKill;
		}
				
		//------------------------------------------------------------------------------------------
		public function getZoneItems ():XDict {
			return m_zoneItems;
		}
				
		//------------------------------------------------------------------------------------------
		public function getZoneItemObject (__zone:Number):ZoneX {
			if (m_zoneItemObjects.exists (__zone)) {
				return m_zoneItemObjects.get (__zone) as ZoneX;
			}
					
			return null;
		}
				
		//------------------------------------------------------------------------------------------
		public function getStarterRingItems ():XDict {
			return m_starterRingItems;
		}
				
		//------------------------------------------------------------------------------------------
		public function setMickeyToStartPosition (__zone:Number):void {	
			var __logicObject:StarterRingControllerX = m_starterRingItemObjects.get (__zone) as StarterRingControllerX;
					
			if (__logicObject.getZone () == __zone) {
				GX.appX.__getMickeyObject ().oX = __logicObject.oX
				GX.appX.__getMickeyObject ().oY = __logicObject.oY;
				GX.appX.__getMickeyObject ().oRotation = 0;
			}
		}
				
		//------------------------------------------------------------------------------------------
		public function resetZoneKillCount ():void {
			m_zoneKillCount = 0;
		}
				
		//------------------------------------------------------------------------------------------
		public function addToZoneKillCount ():void {
			m_zoneKillCount++;
					
			trace (": addToZoneKillCount: ", m_zoneKillCount);
		}
				
		//------------------------------------------------------------------------------------------
		public function removeFromZoneKillCount ():void {
			m_zoneKillCount--;
					
			trace (": removeFromZoneKillCount: ", m_zoneKillCount);
					
			xxx.getXTaskManager ().addTask ([
				XTask.WAIT, 0x1000,
						
				function ():void {
					if (m_zoneKillCount == 0) {
						GX.appX.fireZoneFinishedSignal ();
					}
				},
						
				XTask.RETN,
			]);
		}
						
		//------------------------------------------------------------------------------------------
		public function getZoneKillCount ():int {
			return m_zoneKillCount;
		}
					
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
