//------------------------------------------------------------------------------------------
package GX.External {
	
	import X.*;
	import X.Geom.*;
	import X.Signals.*;
	import X.Task.*;
	import X.World.*;
	import X.World.Collision.*;
	import X.World.Logic.*;
	import X.World.Sprite.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.system.*;
	import flash.text.*;
	import flash.utils.*;
	
	//------------------------------------------------------------------------------------------
	public class AdX extends XLogicObjectCX {
		public var m_completeSignal:XSignal;
		public var m_errorSignal:XSignal;
		
		public var script:XTask;
		
		public var adID:String;
		
		//------------------------------------------------------------------------------------------
		public function AdX () {
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);
		
			adID = getArg (args, 0);
			
			m_completeSignal = createXSignal ();
			m_errorSignal = createXSignal ();
			
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
		public function addCompleteListener (__listener:Function):void {
			m_completeSignal.addListener (__listener);
		}
		
		//------------------------------------------------------------------------------------------
		public function fireCompleteSignal ():void {
			m_completeSignal.fireSignal ();
		}
		
		//------------------------------------------------------------------------------------------
		public function addErrorListener (__listener:Function):void {
			m_errorSignal.addListener (__listener);
		}
		
		//------------------------------------------------------------------------------------------
		public function fireErrorSignal (e:Event):void {
			m_errorSignal.fireSignal (e);
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