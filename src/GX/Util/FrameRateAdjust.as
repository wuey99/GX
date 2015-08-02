//------------------------------------------------------------------------------------------
// <$begin$/>
// The MIT License (MIT)
//
// The "GX-Engine"
//
// Copyright (c) 2014 Jimmy Huey (wuey99@gmail.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
// <$end$/>
//------------------------------------------------------------------------------------------
package GX.Util  {
	
	import x.*;
	import x.task.*;
	import x.text.*;
	import x.world.*;
	import x.world.collision.*;
	import x.world.logic.*;
	import x.world.sprite.*;
	
	import flash.display.Stage;
	
	import mx.charts.chartClasses.NumericAxis;
	
//------------------------------------------------------------------------------------------
	public class FrameRateAdjust extends XTextLogicObject {
		public var m_stage:Stage;
		public var m_frameSamples:Array;
		public var m_maxSamples:int;
		public var m_adjustedFrameRate:Number;
		
//------------------------------------------------------------------------------------------
		public function FrameRateAdjust () {
			super ();
		}
		
//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);
		}
		
//------------------------------------------------------------------------------------------
		public override function setupX ():void {
			m_stage = stage;
			
			m_maxSamples = 16;
			
			m_frameSamples = new Array (m_maxSamples);
			
			for (var i:int = 0; i < m_maxSamples; i++) {
				m_frameSamples.push (xxx.getIdealFPS ());
			}
			
			m_adjustedFrameRate = xxx.getIdealFPS ();
			
			super.setupX ();
									
			oX = 96;
			oY = 8;
			
			return;
			
			xxx.addTimer1000Listener (
				function ():void {
					setupText (
						// width
						700,
						// height
						32,
						// text
						"Target FPS: " + m_adjustedFrameRate + ", FPS: " + xxx.getFPS (),
						// font name
						"Aller",
						// font size
						16,
						// color
						0xe0e0e0,
						// bold
						true
					);
				}
			);
		}

//------------------------------------------------------------------------------------------
		protected override function __removeSprite (__sprite:XDepthSprite):void {
			removeSpriteFromHud (__sprite);
		}
		
//------------------------------------------------------------------------------------------
		protected override function __addSpriteAt (__sprite:XTextSprite, __dx:Number=0, __dy:Number=0):XDepthSprite {
			return addSpriteToHudAt (__sprite, __dx, __dy);	
		}
		
//------------------------------------------------------------------------------------------
		public override function Idle_Script ():void {
			
			script.gotoTask ([
				
				//------------------------------------------------------------------------------------------
				// control
				//------------------------------------------------------------------------------------------
				function ():void {
					script.addTask ([
						XTask.LABEL, "loop",
							XTask.WAIT, 0x0800,
							
							function ():void {
								m_frameSamples.shift (); m_frameSamples.push (xxx.getFPS ());

								var __averageFrameRate:Number = 0;
								
								for (var i:int=0; i < m_maxSamples; i++) {
									__averageFrameRate += m_frameSamples[i];	
								}
								
								m_adjustedFrameRate = Math.floor (Math.min (xxx.getIdealFPS (), __averageFrameRate / m_maxSamples + 3));
							},
							
							XTask.GOTO, "loop",
						
						XTask.RETN,
					]);
					
					script.addTask ([
						XTask.LABEL, "loop",
							XTask.WAIT, 0x1000,
							
							function ():void {
								m_stage.frameRate = m_adjustedFrameRate;
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
