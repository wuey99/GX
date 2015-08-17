//------------------------------------------------------------------------------------------
package gx.triggers {
	
	import kx.*;
	import kx.geom.*;
	import kx.task.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	import kx.xml.*;
	
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	
	//------------------------------------------------------------------------------------------
	public class TriggerX extends XLogicObjectCX {
		public var script:XTask;
		public var gravity:XTask;
		
		public var x_dx:Number;
		public var x_dy:Number;
		
		public var m_direction:String;
		public var m_trigger:Number;
		public var m_distance:Number;
		
		//------------------------------------------------------------------------------------------
		public function TriggerX () {
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);

			createSprites ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setupX ():void {
			super.setupX ();

			__setupItemParamsXML ();
			
			setCX (-32, +32, -32, +32);
			
			gravity = addEmptyTask ();
			script = addEmptyTask ();
			
			x_dx = 999;
			x_dy = 999;
			
			Check_Script ();
		}

		//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
		}
		
		//------------------------------------------------------------------------------------------
		// <params
		//		trigger = "1001";
		//		direction = "vert/horz";
		//		distance = "32";
		// />
		//------------------------------------------------------------------------------------------
		private function __setupItemParamsXML ():void {
			setupItemParamsXML ();
			
			m_trigger = -1;			
			if (itemHasAttribute ("trigger")) {
				m_trigger = itemGetAttribute ("trigger");
			}
			
			m_direction = null;
			if (itemHasAttribute ("direction")) {
				m_direction = itemGetAttribute ("direction");	
			}
			
			m_distance = 0;
			if (itemHasAttribute ("distance")) {
				m_distance = itemGetAttribute ("distance");	
			}
		}
		
		//------------------------------------------------------------------------------------------
		// create sprites
		//------------------------------------------------------------------------------------------
		public override function createSprites ():void {
		}
		
		//------------------------------------------------------------------------------------------
		public function Check_Script ():void {

			script.gotoTask ([
				
				//------------------------------------------------------------------------------------------
				// control
				//------------------------------------------------------------------------------------------
				function ():void {
					script.addTask ([
						XTask.LABEL, "loop",
							XTask.WAIT, 0x0100,
							
							function ():void {
								x_dx = oX - GX.appX.__getMickeyObject ().getPos ().x;
								x_dy = oY - GX.appX.__getMickeyObject ().getPos ().y;
								
								x_dx = Math.abs (x_dx);  x_dy = Math.abs (x_dy);
									
								if (m_direction == null && xxx.approxDistance (x_dx, x_dy) < m_distance) {	
									GX.appX.fireTriggerSignal (m_trigger);
									
									return;									
								}
								
								if ((m_direction == "horz" || m_direction == "both") && x_dy < 32 && x_dx < m_distance) {
									GX.appX.fireTriggerSignal (m_trigger);
									
									return;
								}
								
								if ((m_direction == "vert" || m_direction == "both") && x_dx < 32 && x_dy < m_distance) {
									GX.appX.fireTriggerSignal (m_trigger);
									
									return;
								}
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