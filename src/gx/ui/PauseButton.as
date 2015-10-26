//------------------------------------------------------------------------------------------
package gx.ui {

// X classes
	import kx.*;
	import kx.signals.*;
	import kx.task.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.ui.*;
	import kx.world.sprite.*;
	
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;

//------------------------------------------------------------------------------------------
	public class PauseButton extends XButton {
		public var m_highlightTask:XTask;
				
//------------------------------------------------------------------------------------------
		public function PauseButton () {
			super ();
		}

//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array  /* <Dynamic> */):void {
			super.setup (__xxx, args);
		}

//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
			
			xxx.getXTaskManager  ().removeTask (m_highlightTask);
		}

//------------------------------------------------------------------------------------------
		public override function createHighlightTask ():void {
			m_highlightTask = xxx.getXTaskManager ().addTask ([
				XTask.LABEL, "__loop",
					XTask.WAIT, 0x0100,
					
					function ():void {
						m_sprite.gotoAndStop (m_label);
					},
									
				XTask.GOTO, "__loop",
			]);
		}
		
//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
}
