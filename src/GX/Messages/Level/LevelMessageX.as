//------------------------------------------------------------------------------------------
package GX.Messages.Level {
	
	import X.*;
	import X.Geom.*;
	import X.Task.*;
	import X.World.*;
	import X.World.Collision.*;
	import X.World.Logic.*;
	import X.World.Sprite.*;
	import X.XMap.*;
	
	import flash.display.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	
	//------------------------------------------------------------------------------------------
	public class LevelMessageX extends XLogicObject {
		public var m_text:XTextSprite;
		public var x_text:XDepthSprite;
		public var script:XTask;
		public var m_ownerItem:XMapItemModel;
		
		//------------------------------------------------------------------------------------------
		public function LevelMessageX () {
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);
			
			createSprites ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setupX ():void {
			super.setupX ();
			
			m_ownerItem = null;
			
			script = addEmptyTask ();
		}
		
		//------------------------------------------------------------------------------------------
		// create sprites
		//------------------------------------------------------------------------------------------
		public override function createSprites ():void {
			m_text = new XTextSprite ();
			x_text = addSpriteAt (m_text, 0, 0);
			
			show ();
		}

		//------------------------------------------------------------------------------------------
		public function setOwnerItem (__owner:XMapItemModel):void {
			m_ownerItem = __owner;
		}
		
		//------------------------------------------------------------------------------------------
		public function getOwnerItem ():XMapItemModel {
			return m_ownerItem;
		}

		//------------------------------------------------------------------------------------------
		public function fadeOutAndNuke ():void {
			addTask ([
				XTask.LABEL, "loop",
					XTask.WAIT, 0x0100,
					
					XTask.FLAGS, function (__task:XTask):void {
						oAlpha = Math.max (0.0, oAlpha - .05);
						
						__task.ifTrue (oAlpha == 0.0);
					}, XTask.BNE, "loop",
					
					function ():void {
						nukeLater ();
					},
					
				XTask.RETN,
			]);
		}
		
		//------------------------------------------------------------------------------------------
		public function setMessage (
			__message:String,
			__size:Number,
			__color:Number,
			__width:Number,
			__height:Number,
			__alignment:String,
			__spacing:Number,
			__leading:Number):void {
			
			m_text.v.htmlText = __message;	
			m_text.v.selectable = false;
			m_text.v.multiline = true;
			m_text.v.wordWrap = true;
//			m_text.v.embedFonts = true;
	
// !!! todo
//			var __font:Font = new XAssets.ArialFontClass ();
			var __font:Font;
			
			var __format:TextFormat = new TextFormat();
			__format.font = __font.fontName;
			
			__format.color = __color;
			__format.size = __size;
			__format.letterSpacing = __spacing;
			__format.leading = __leading;
			
			__format.align = __getAlignment ();
			
			m_text.v.setTextFormat (__format);
			
			m_text.v.width = __width;
			m_text.v.height = __height;
			
			function __getAlignment ():String {
				if (__alignment == "center") {
					return TextFormatAlign.CENTER;
				}
				
				if (__alignment == "left") {
					return TextFormatAlign.LEFT;
				}
				
				if (__alignment == "right") {
					return TextFormatAlign.RIGHT;
				}
				
				return TextFormatAlign.CENTER;
			}
		}
		
		//------------------------------------------------------------------------------------------
	}
	
	//------------------------------------------------------------------------------------------
}