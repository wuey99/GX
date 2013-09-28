//------------------------------------------------------------------------------------------
package GX.Messages.Level {
	
	import GX.Assets.*;
	import GX.Text.*;
	
	import X.*;
	import X.Geom.*;
	import X.Task.*;
	import X.World.*;
	import X.World.Collision.*;
	import X.World.Logic.*;
	import X.World.Sprite.*;
	
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	
	//------------------------------------------------------------------------------------------
	public class ClickHereMessageX extends XLogicObject {
		public var script:XTask;
		public var gravity:XTask;
		
		//------------------------------------------------------------------------------------------
		public function ClickHereMessageX () {
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);
			
			createSprites ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setupX ():void {
			super.setupX ();
			
			gravity = addEmptyTask ();
			script = addEmptyTask ();
			
			gravity.gotoTask (getPhysicsTask$ (0.25));

			Idle_Script ();
		}
		
		//------------------------------------------------------------------------------------------
		// create sprites
		//------------------------------------------------------------------------------------------
		public override function createSprites ():void {
			var __logicObject:CircularSmallSpriteTextX = xxx.getXLogicManager ().initXLogicObject (
				// parent
				this,
				// logicObject
				new CircularSmallSpriteTextX () as XLogicObject,
				// item, layer, depth
				null, 0, 0,
				// x, y, z
				0, 0, 0,
				// scale, rotation
				1.0, 0,
				"CLICK HERE"
			) as CircularSmallSpriteTextX;
			
			addXLogicObject (__logicObject);

			__logicObject.dist = 80;
			
			show ();
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
		public function Idle_Script ():void {
			
			//------------------------------------------------------------------------------------------
			script.gotoTask ([
				
				//------------------------------------------------------------------------------------------
				// control
				//------------------------------------------------------------------------------------------
				function ():void {
					script.addTask ([
						XTask.LABEL, "loop",
							XTask.WAIT, 0x0100,
							
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