//------------------------------------------------------------------------------------------
package GX.Mickey {

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
	public class MickeyCursorX extends XLogicObject {
		public var m_spriteCircle:XMovieClip;
		public var x_spriteCircle:XDepthSprite;
		public var m_spriteArrow:XMovieClip;
		public var x_spriteArrow:XDepthSprite;
		public var m_stagePoint:XPoint;
		public var m_worldPoint:XPoint;
		public var m_compassMode:Boolean;
	
//------------------------------------------------------------------------------------------
		public function MickeyCursorX () {
		}
	
//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);
			
			createSprites ();
			
			mouseEnabled = m_spriteCircle.mouseEnabled = x_spriteCircle.mouseEnabled = false;
			
			m_stagePoint = new XPoint ();
			m_worldPoint = new XPoint ();
			
			setPointerMode ();
			
			addTask ([
				XTask.LABEL, "loop",
					function ():void { oAlpha = 0.80; }, XTask.WAIT, 0x0400,
					function ():void { oAlpha = 0.60; }, XTask.WAIT, 0x0300,
					function ():void { oAlpha = 0.40; }, XTask.WAIT, 0x0200,
					function ():void { oAlpha = 0.20; }, XTask.WAIT, 0x0100,
					function ():void { oAlpha = 0.40; }, XTask.WAIT, 0x0200,
					function ():void { oAlpha = 0.60; }, XTask.WAIT, 0x0300,
					
				XTask.GOTO, "loop",
				
				XTask.RETN,
			]);
			
			addTask ([
				XTask.LABEL, "loop",
					function ():void { m_spriteArrow.gotoAndStop (8); }, XTask.WAIT, 0x0100,
					
					/*
					function ():void { m_spriteArrow.gotoAndStop (1); }, XTask.WAIT, 0x0100,
					function ():void { m_spriteArrow.gotoAndStop (2); }, XTask.WAIT, 0x0100,
					function ():void { m_spriteArrow.gotoAndStop (3); }, XTask.WAIT, 0x0100,
					function ():void { m_spriteArrow.gotoAndStop (4); }, XTask.WAIT, 0x0100,
					function ():void { m_spriteArrow.gotoAndStop (5); }, XTask.WAIT, 0x0100,
					function ():void { m_spriteArrow.gotoAndStop (6); }, XTask.WAIT, 0x0100,
					function ():void { m_spriteArrow.gotoAndStop (7); }, XTask.WAIT, 0x0100,
					*/
					
					XTask.GOTO, "loop",
					
				XTask.RETN,
			]);
			
			var __rotation:Number = 0;
			
			addTask ([
				XTask.LABEL, "loop",
					XTask.WAIT, 0x0100,
					
					function ():void {
						__rotation = (__rotation - 2.0) % 360;
							
						m_spriteCircle.rotation = __rotation;
					},
					
					function ():void {
						if (CONFIG::starling) {
							
						}
						else
						{
							m_stagePoint.x = stage.mouseX;
							m_stagePoint.y = stage.mouseY;
						}
						
						xxx.globalToWorld2 (
							getLayer (),
							m_stagePoint,
							m_worldPoint
							);
							
						oX = m_worldPoint.x;
						oY = m_worldPoint.y;	
					},
					
					XTask.GOTO, "loop",
					
				XTask.RETN,
			]);
		}

//------------------------------------------------------------------------------------------
		public override function setupX ():void {
			super.setupX ();
		}

//------------------------------------------------------------------------------------------
// create sprites
//------------------------------------------------------------------------------------------
		public override function createSprites ():void {
			if (CONFIG::starling) {
				m_spriteCircle = createXMovieClip ("MickeyCursor:MickeyCursor");
				x_spriteCircle = addSpriteAt (m_spriteCircle, 0, 0);	
				
				m_spriteArrow = createXMovieClip ("MickeyCursorArrow:MickeyCursorArrow");
				x_spriteArrow = addSpriteAt (m_spriteArrow, 0, 0);
				m_spriteArrow.alpha = 0.60;
			}
			else
			{
				m_spriteCircle = createXMovieClip ("MickeyCursor:MickeyCursor");
				x_spriteCircle = addSpriteAt (m_spriteCircle, 0, 0);	
				
				m_spriteArrow = createXMovieClip ("MickeyCursorArrow:MickeyCursorArrow");
				x_spriteArrow = addSpriteAt (m_spriteArrow, 0, 0);
				m_spriteArrow.alpha = 0.60;
			}
			
			show ();
		}

//------------------------------------------------------------------------------------------
		public function setPointerMode ():void {
			m_compassMode = false;
			
			m_spriteCircle.gotoAndStop (1);
			x_spriteArrow.visible2 = false;
		}
		
//------------------------------------------------------------------------------------------
		public function setCompassMode ():void {
			m_compassMode = true;
			
			m_spriteCircle.gotoAndStop (2);
			x_spriteArrow.visible2 = true;
		}

//------------------------------------------------------------------------------------------
		public function setCompassRotation (__value:Number):void {
			m_spriteArrow.rotation = __value;	
		}
		
//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
}