//------------------------------------------------------------------------------------------
package GX.External.CPMStar {
	
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
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	
	//------------------------------------------------------------------------------------------
	public class CPMStarAdX extends XLogicObjectCX {
		public var m_sprite:XMovieClip;
		public var x_sprite:XDepthSprite;
		
		public var script:XTask;
		
		public var CPMStarContentSpotID:String = "11176QBBEC2318";
		
		//------------------------------------------------------------------------------------------
		public function CPMStarAdX () {
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);
			
			mouseEnabled = true;
			mouseChildren = true;
			
			createSprites ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setupX ():void {
			super.setupX ();
			
			setCX (-8, +8, -8, +8);
	
			script = addEmptyTask ();
			
			Idle_Script ();
			
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
		// create sprites
		//------------------------------------------------------------------------------------------
		public override function createSprites ():void {
			m_sprite = createXMovieClip ("adBox:adBox");
			x_sprite = addSpriteToHudAt (m_sprite, 0, 0);
			
			var __displayObject:DisplayObject = new AdLoader (CPMStarContentSpotID);
			
			addTask ([
				XTask.WAIT, 0x0100,
				
				function ():void {
					m_sprite.getMovieClip ().addChild (__displayObject);
				},

				XTask.RETN,
			]);
			
			show ();
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
	}
	
//------------------------------------------------------------------------------------------
}