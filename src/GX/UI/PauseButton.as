//------------------------------------------------------------------------------------------
package GX.UI {

// X classes
	import X.*;
	import X.Signals.*;
	import X.Task.*;
	import X.World.*;
	import X.World.Collision.*;
	import X.World.Logic.*;
	import X.World.UI.*;
	import X.World.Sprite.*;
	
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;

//------------------------------------------------------------------------------------------
	public class PauseButton extends XButton {
		public var m_highlightTask:XTask;
				
//------------------------------------------------------------------------------------------
		public function PauseButton () {
		}

//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array):void {
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
