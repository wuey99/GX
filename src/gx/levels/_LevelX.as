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
package gx.levels {
	
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	
	import gx.*;
	import gx.assets.*;
	
	import kx.*;
	import kx.collections.*;
	import kx.geom.*;
	import kx.signals.*;
	import kx.task.*;
	import kx.world.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	import kx.xmap.*;
	import kx.xml.*;
		
//------------------------------------------------------------------------------------------
	public class _LevelX extends XMapView {
		protected var m_XApp:XApp;
		
		public var script:XTask;
		
		protected var m_layerView:Array; // <XMapLayerView>
		protected var m_layerPos:Array; // <XPoint>
		protected var m_layerShake:Array; // <XPoint>
		protected var m_layerScroll:Array; // <XPoint>
		
		protected var m_maxLayers:int;
		
		protected var m_levelSelectSignal:XSignal;
		protected var m_gameStateChangedSignal:XSignal;
		
		protected var m_levelData:*;
		
		protected var m_viewRect:XRect;
		
//------------------------------------------------------------------------------------------
		public function _LevelX () {
			super ();
		}
	
//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array /* <Dynamic> */):void {
			super.setup (__xxx, args);
			
			var __xml:XSimpleXMLNode = getArg (args, 0);
			m_XApp = getArg (args, 1);
			
			createModelFromXMLReadOnly (__xml, true);
			
			xxx.setXMapModel (getModel ());
			
			initSubmapPoolManager ();

			m_maxLayers = xxx.MAX_LAYERS;
			
			m_layerPos = new Array (); // <XPoint>
			m_layerShake = new Array (); // <XPoint>
			m_layerScroll = new Array (); // <XPoint>
			m_layerView = new Array (); // <XMapLayerView>
			
			m_viewRect = new XRect ();
			
			var i:int;
			
			for (i=0; i < m_maxLayers; i++) {
				m_layerPos.push (new XPoint (0, 0));
				m_layerShake.push (new XPoint (0, 0));
				m_layerScroll.push (new XPoint (0, 0));
				m_layerView.push (null);
			}
			
			createSprites9 ();

			m_levelSelectSignal = createXSignal ();
			m_gameStateChangedSignal = createXSignal ();
		}

//------------------------------------------------------------------------------------------
		public override function setupX ():void {
			super.setupX ();
			
			script = addEmptyTask ();
		}

//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
		}
		
//------------------------------------------------------------------------------------------
// create sprites
//------------------------------------------------------------------------------------------
		public function createSprites9 ():void {			
			var i:int = 0;
			
			while (i < m_maxLayers) {
				m_layerView[i+0] = xxx.getXLogicManager ().initXLogicObject (
					// parent
					this,
					// logicObject
					/* @:cast */ new XMapLayerView () as XLogicObject,
					// item, layer, depth
					null, 0, 1000,
					// x, y, z
					0, 0, 0,
					// scale, rotation
					1.0, 0,
					[
						// XMapView
						this,
						// XMapModel
						m_XMapModel,
						// layer
						i + 0,
						// logicClassNameToClass
						GX.appX.logicClassNameToClass
					]
				) as XMapLayerView;
				
				addXLogicObject (m_layerView[i+0]);
				
				m_layerView[i+1] = xxx.getXLogicManager ().initXLogicObject (
					// parent
					this,
					// logicObject
					/* @:cast */ new XMapLayerCachedView () as XLogicObject,
					// item, layer, depth
					null, 0, 1000,
					// x, y, z
					0, 0, 0,
					// scale, rotation
					1.0, 0,
					[
						// XMapView
						this,
						// XMapModel
						m_XMapModel,
						// layer
						i + 1
					]
				) as XMapLayerCachedView;
				
				addXLogicObject (m_layerView[i+1]);	
				
				i += 2;
			}
			
			show ();
		}

//------------------------------------------------------------------------------------------
		public function addXMapItem (__item:XMapItemModel, __depth:Number):XLogicObject {	
			return m_layerView[0].addXMapItem (__item, __depth);
		}

//------------------------------------------------------------------------------------------
		public function getXLogicObject (__item:XMapItemModel):XLogicObject {		
			return m_layerView[0].getXLogicObject (__item);
		}
		
//------------------------------------------------------------------------------------------
		public override function scrollTo (__layer:int, __x:Number, __y:Number):void {
			m_layerPos[__layer].x = __x;
			m_layerPos[__layer].y = __y;
		}

//------------------------------------------------------------------------------------------
		public override function updateScroll ():void {
			var i:int;
			
			for (i=0; i < m_maxLayers; i++) {
				m_layerPos[i].copy2 (m_layerScroll[i]);
				
				m_layerScroll[i].x += m_layerShake[i].x;
				m_layerScroll[i].y += m_layerShake[i].y;
				
				xxx.getXWorldLayer (i).setPos (m_layerScroll[i]);
			}
		}
		
//------------------------------------------------------------------------------------------
		public override function updateFromXMapModel ():void {
			var i:int;
			
			for (i=0; i < m_maxLayers; i++) {
				m_layerView[i].updateFromXMapModel ();
			}
		}
		
//------------------------------------------------------------------------------------------
		public override function prepareUpdateScroll ():void {
			var i:int;
			
			for (i=0; i < m_maxLayers; i++) {
				m_layerPos[i].copy2 (m_layerScroll[i]);
				
				m_layerScroll[i].x += m_layerShake[i].x;
				m_layerScroll[i].y += m_layerShake[i].y;
			}

			for (i=0; i < m_maxLayers; i++) {
				m_viewRect.x = -m_layerScroll[i].x;
				m_viewRect.y = -m_layerScroll[i].y;
				m_viewRect.width = xxx.getViewRect ().width;
				m_viewRect.height = xxx.getViewRect ().height;
				
				m_layerView[i].updateFromXMapModelAtRect (m_viewRect);
			}
		}
		
//------------------------------------------------------------------------------------------
		public override function finishUpdateScroll ():void {
			var i:int;
			
			for (i=0; i < m_maxLayers; i++) {
				xxx.getXWorldLayer (i).setPos (m_layerScroll[i]);
			}			
		}

//------------------------------------------------------------------------------------------
		public function onEntry ():void {
			FadeIn_Script ();
		}
		
//------------------------------------------------------------------------------------------
		public function onExit ():void {
		}
		
//------------------------------------------------------------------------------------------
		public function setLevelAlpha (__alpha:Number):void {
			GX.appX.setMaskAlpha (__alpha);
		}

//------------------------------------------------------------------------------------------
		public function addXShake (__count:int=15, __delayValue:Number=0x0100):void {
			function __setX (__dy:Number):void {
				var i:int;
				
				for (i=0; i < m_maxLayers; i++) {
					m_layerShake[i].x = __dy;
					m_layerShake[i].y = __dy;
				}
				
				updateScroll ();
			}
			
			var __delay:XNumber = new XNumber (0);
			__delay.value = __delayValue;
			
			addTask ([
				XTask.LABEL, "loop",
				function ():void {__setX (-__count); }, XTask.WAIT, __delay,
				function ():void {__setX ( __count); }, XTask.WAIT, __delay,
				
				XTask.FLAGS, function (__task:XTask):void {
					__count--;
					
					__task.ifTrue (__count == 0);
				}, XTask.BNE, "loop",
				
				function ():void {
					__setX (0);
				},
				
				XTask.RETN,
			]);
		}
		
//------------------------------------------------------------------------------------------
		public function addYShake (__count:int=15, __delayValue:Number=0x0100):void {
			function __setY (__dy:Number):void {
				var i:int;
				
				for (i=0; i < m_maxLayers; i++) {
					m_layerShake[i].x = __dy;
					m_layerShake[i].y = __dy;
				}
				
				updateScroll ();
			}
			
			var __delay:XNumber = new XNumber (0);
			__delay.value = __delayValue;
			
			addTask ([
				XTask.LABEL, "loop",
					function ():void {__setY (-__count); }, XTask.WAIT, __delay,
					function ():void {__setY ( __count); }, XTask.WAIT, __delay,
				
					XTask.FLAGS, function (__task:XTask):void {
						__count--;
						
						__task.ifTrue (__count == 0);
					}, XTask.BNE, "loop",
					
					function ():void {
						__setY (0);
					},
					
				XTask.RETN,
			]);
		}
		
		//------------------------------------------------------------------------------------------
		public function FadeOut_Script (__levelId:String=""):void {
			
			script.gotoTask ([
				
				//------------------------------------------------------------------------------------------
				// control
				//------------------------------------------------------------------------------------------
				function ():void {
					script.addTask ([
						XTask.LABEL, "loop",
							XTask.WAIT, 0x0100,
							
							XTask.FLAGS, function (__task:XTask):void {
								setLevelAlpha (Math.max (0.0, GX.appX.getMaskAlpha () - 0.025));
								
								__task.ifTrue (GX.appX.getMaskAlpha () == 0.0 && __levelId != "");
							}, XTask.BNE, "loop",
							
							function ():void {
								fireLevelSelectSignal (__levelId);
								
								nukeLater ();
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
		public function FadeOutAlpha_Script (__levelId:String=""):void {
			
			script.gotoTask ([
				
				//------------------------------------------------------------------------------------------
				// control
				//------------------------------------------------------------------------------------------
				function ():void {
					script.addTask ([
						XTask.LABEL, "loop",
							XTask.WAIT, 0x0100,
							
							XTask.FLAGS, function (__task:XTask):void {
								oAlpha = Math.max (0.0, oAlpha - 0.025);
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
		public function FadeIn_Script ():void {
			
			script.gotoTask ([
				
				//------------------------------------------------------------------------------------------
				// control
				//------------------------------------------------------------------------------------------
				function ():void {
					script.addTask ([
						XTask.LABEL, "loop",
							XTask.WAIT, 0x0100,
							
							function ():void {
								setLevelAlpha (Math.min (1.0, GX.appX.getMaskAlpha () + 0.05));
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
		public function getLevelData ():* {
			return m_levelData;
		}
		
		//------------------------------------------------------------------------------------------
		public function setLevelData (__levelData:*):void {
			m_levelData = __levelData;
		}
		
		//------------------------------------------------------------------------------------------
		public function addLevelSelectListener (__listener:Function):void {
			m_levelSelectSignal.addListener (__listener);
		}
		
		//------------------------------------------------------------------------------------------
		public function fireLevelSelectSignal (__levelId:String):void {
			m_levelSelectSignal.fireSignal (__levelId);
		}
		
		//------------------------------------------------------------------------------------------
		public function addGameStateChangedListener (__listener:Function):void {
			m_gameStateChangedSignal.addListener (__listener);
		}
		
		//------------------------------------------------------------------------------------------
		public function fireGameStateChangedSignal (__gameState:int):void {
			m_gameStateChangedSignal.fireSignal (__gameState);
		}
		
	//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
}