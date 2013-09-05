//------------------------------------------------------------------------------------------
package GX.Levels {
	
	import X.*;
	import X.Geom.*;
	import X.Collections.*;
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
	public class LevelX extends XMapView {
		protected var m_XApp:XApp;
		protected var m_layerView:XMapLayerView;
		protected var m_layerView0:XMapLayerView;
		protected var m_layerView1:XMapLayerCachedView;
		public var script:XTask;
				
//------------------------------------------------------------------------------------------
		public function LevelX () {
		}
	
//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);
			
			var __xml:XSimpleXMLNode = getArg (args, 0);
			m_XApp = getArg (args, 1);
			
			createModelFromXMLReadOnly (__xml);
			
			xxx.setXMapModel (getModel ());
			
			initSubmapBitmapPoolManager (512, 512);
				
			createSprites9 ();
		}

//------------------------------------------------------------------------------------------
		public override function setupX ():void {
			super.setupX ();
			
			script = addEmptyTask ();
			
			addTask ([
				XTask.WAIT, 0x0100,
				
				function ():void {
					GX.app$.getGameHudObject ().oVisible = false;
				},
				
				XTask.RETN
			]);
			
			GX.app$.addMickeyPlayingListener (__onMickeyPlaying);
		}

//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
			
			GX.app$.removeMickeyPlayingListener (__onMickeyPlaying);
		}
		
//------------------------------------------------------------------------------------------
// create sprites
//------------------------------------------------------------------------------------------
		public override function createSprites ():void {
			m_layerView = xxx.getXLogicManager ().initXLogicObject (
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
			
			addXLogicObject (m_layerView);
					
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
		protected function __onMickeyPlaying ():void {
			GX.app$.getGameHudObject ().oVisible = true;			
		}
		
//------------------------------------------------------------------------------------------
		public function addXMapItem (__item:XMapItemModel, __depth:Number):XLogicObject {
			return m_layerView0.addXMapItem (__item, __depth);
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