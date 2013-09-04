//------------------------------------------------------------------------------------------
package GX.Zone {
	
	import Assets.*;
	
	import Objects.*;
	import Objects.Mickey.*;
	
	import X.*;
	import X.Geom.*;
	import X.Task.*;
	import X.World.*;
	import X.World.Collision.*;
	import X.World.Logic.*;
	import X.World.Sprite.*;
	
	import flash.display.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	
	//------------------------------------------------------------------------------------------
	public class StarterRingX extends XLogicObjectCX {
		public var m_sprite:MovieClip;
		public var x_sprite:XDepthSprite;
		public var script:XTask;
		
		//------------------------------------------------------------------------------------------
		public function StarterRingX () {
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
			
			script = addEmptyTask ();
			
			Ring_Script ();
			
			addTask ([
				XTask.LABEL, "loop",
					XTask.LOOP, 10,
						function ():void {
							oAlpha -= 0.08;	
						}, XTask.WAIT, 0x0100,
					XTask.NEXT,
					
					function ():void {
						nukeLater ();
					},
				
				XTask.RETN,
			]);
		}
		
		//------------------------------------------------------------------------------------------
		// create sprites
		//------------------------------------------------------------------------------------------
		public override function createSprites ():void {
			m_sprite = new (xxx.getClass ("StarterRing:StarterRing")) ();
// !STARLING!
//			x_sprite = addSpriteAt (m_sprite, 0, 0);
			
			show ();
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