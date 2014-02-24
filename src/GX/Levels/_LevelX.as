//------------------------------------------------------------------------------------------
package GX.Levels {
	
	import GX.Assets.*;
	
	import X.*;
	import X.Collections.*;
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
	public class _LevelX extends XMapView {
		protected var m_XApp:XApp;
		
		protected var m_layerView1X:XMapLayerView;
		protected var m_layerView0:XMapLayerView;
		protected var m_layerView1:XMapLayerCachedView;
		
		public var script:XTask;
		
		public var m_layer0Pos:XPoint;
		public var m_layer0Shake:XPoint;
		public var m_layer0Scroll:XPoint;
		
		public var m_layer1Pos:XPoint;
		public var m_layer1Shake:XPoint;
		public var m_layer1Scroll:XPoint;
		
//------------------------------------------------------------------------------------------
		public function _LevelX () {
		}
	
//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);
			
			var __xml:XSimpleXMLNode = getArg (args, 0);
			m_XApp = getArg (args, 1);
			
			createModelFromXMLReadOnly (__xml, true);
			
			xxx.setXMapModel (getModel ());
			
			initSubmapPoolManager ();
				
			createSprites9 ();
			
			m_layer0Pos = new XPoint (0, 0);
			m_layer0Shake = new XPoint (0, 0);
			m_layer0Scroll = new XPoint (0, 0);
			m_layer1Pos = new XPoint (0, 0);
			m_layer1Shake = new XPoint (0, 0);
			m_layer1Scroll = new XPoint (0, 0);
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
		public override function createSprites ():void {
			m_layerView1X = xxx.getXLogicManager ().initXLogicObject (
				// parent
					this,
				// logicObject
					new XMapLayerView () as XLogicObject,
				// item, layer, depth
					null, 0, 1000,
				// x, y, z
					0, 0, 0,
				// scale, rotation
					1.0, 0,
					// XMapView
					this,
					// XMapModel
					m_XMapModel,
					// layer
					GX.app$.PLAYFIELD_LAYER + 1,
					// logicClassNameToClass
					GX.app$.logicClassNameToClass
				) as XMapLayerView;
			
			addXLogicObject (m_layerView1X);
					
			show ();
		}

//------------------------------------------------------------------------------------------
// create sprites
//------------------------------------------------------------------------------------------
		public function createSprites9 ():void {
			m_layerView0 = xxx.getXLogicManager ().initXLogicObject (
				// parent
				this,
				// logicObject
				new XMapLayerView () as XLogicObject,
				// item, layer, depth
				null, 0, 1000,
				// x, y, z
				0, 0, 0,
				// scale, rotation
				1.0, 0,
				// XMapView
				this,
				// XMapModel
				m_XMapModel,
				// layer
				GX.app$.PLAYFIELD_LAYER + 0,
				// logicClassNameToClass
				GX.app$.logicClassNameToClass
			) as XMapLayerView;
			
			addXLogicObject (m_layerView0);
			
			m_layerView1 = xxx.getXLogicManager ().initXLogicObject (
				// parent
					this,
				// logicObject
					new XMapLayerCachedView () as XLogicObject,
				// item, layer, depth
					null, 0, 1000,
				// x, y, z
					0, 0, 0,
				// scale, rotation
					1.0, 0,
					// XMapView
					this,
					// XMapModel
					m_XMapModel,
					// layer
					GX.app$.PLAYFIELD_LAYER + 1
				) as XMapLayerCachedView;
			
			addXLogicObject (m_layerView1);
					
			show ();
		}

//------------------------------------------------------------------------------------------
		public function addXMapItem (__item:XMapItemModel, __depth:Number):XLogicObject {
			return m_layerView0.addXMapItem (__item, __depth);
		}

//------------------------------------------------------------------------------------------
		public function getXLogicObject (__item:XMapItemModel):XLogicObject {
			return m_layerView0.getXLogicObject (__item);
		}
		
//------------------------------------------------------------------------------------------
		public override function scrollTo (__layer:Number, __x:Number, __y:Number):void {
			switch (__layer) {
				case 0:
					m_layer0Pos.x = __x;
					m_layer0Pos.y = __y;
					
					break;
				
				case 1:
					m_layer1Pos.x = __x;
					m_layer1Pos.y = __y;
					
					break;
			}
		}

//------------------------------------------------------------------------------------------
		public override function updateScroll ():void {	
			m_layer0Pos.copy2 (m_layer0Scroll);
			m_layer1Pos.copy2 (m_layer1Scroll);
			
			m_layer0Scroll.x += m_layer0Shake.x;
			m_layer0Scroll.y += m_layer0Shake.y;
			
			m_layer1Scroll.x += m_layer1Shake.x;
			m_layer1Scroll.y += m_layer1Shake.y;			
			
			xxx.getXWorldLayer (0).setPos (m_layer0Scroll);
			xxx.getXWorldLayer (1).setPos (m_layer1Scroll);
		}
		
//------------------------------------------------------------------------------------------
		public override function updateFromXMapModel ():void {
			m_layerView0.updateFromXMapModel ();	
			m_layerView1.updateFromXMapModel ();	
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
			GX.app$.setMaskAlpha (__alpha);
		}

//------------------------------------------------------------------------------------------
		public function addXShake (__count:Number=15, __delayValue:Number=0x0100):void {
			var __delay:XNumber = new XNumber (0);
			__delay.value = __delayValue;
			
			addTask ([
				XTask.LABEL, "loop",
				function ():void {__setX (-__count) }, XTask.WAIT, __delay,
				function ():void {__setX (+__count) }, XTask.WAIT, __delay,
				
				XTask.FLAGS, function (__task:XTask):void {
					__count--;
					
					__task.ifTrue (__count == 0);
				}, XTask.BNE, "loop",
				
				function ():void {
					__setX (0);
				},
				
				XTask.RETN,
			]);
			
			function __setX (__dy:Number):void {
				m_layer0Shake.x = __dy;
				m_layer1Shake.x = __dy;
				
				updateScroll ();
			}
		}
		
//------------------------------------------------------------------------------------------
		public function addYShake (__count:Number=15, __delayValue:Number=0x0100):void {
			var __delay:XNumber = new XNumber (0);
			__delay.value = __delayValue;
			
			addTask ([
				XTask.LABEL, "loop",
					function ():void {__setY (-__count) }, XTask.WAIT, __delay,
					function ():void {__setY (+__count) }, XTask.WAIT, __delay,
				
					XTask.FLAGS, function (__task:XTask):void {
						__count--;
						
						__task.ifTrue (__count == 0);
					}, XTask.BNE, "loop",
					
					function ():void {
						__setY (0);
					},
					
				XTask.RETN,
			]);
			
			function __setY (__dy:Number):void {
				m_layer0Shake.y = __dy;
				m_layer1Shake.y = __dy;
				
				updateScroll ();
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function FadeOut_Script ():void {
			
			script.gotoTask ([
				
				//------------------------------------------------------------------------------------------
				// control
				//------------------------------------------------------------------------------------------
				function ():void {
					script.addTask ([
						XTask.LABEL, "loop",
							XTask.WAIT, 0x0100,
							
							function ():void {
								setLevelAlpha (Math.max (0.0, GX.app$.getMaskAlpha () - 0.025));
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
								setLevelAlpha (Math.min (1.0, GX.app$.getMaskAlpha () + 0.05));
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
	}

//------------------------------------------------------------------------------------------
}