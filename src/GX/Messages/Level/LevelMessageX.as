//------------------------------------------------------------------------------------------
package GX.Messages.Level {
	
	import Assets.*;	
	import GX.Text.*;
	
	import X.*;
	import X.Geom.*;
	import X.Task.*;
	import X.World.*;
	import X.World.Collision.*;
	import X.World.Logic.*;
	import X.World.Sprite.*;
	import X.XMap.*;
	
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
			m_text = new XTextSprite (128, 32, "");
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
			
			m_text.text = __message;	
			m_text.selectable = false;
			m_text.multiline = true;
			m_text.wordWrap = true;
//			m_text.1embedFonts = true;
			
//			var __font:Font = new XAssets.ArialFontClass ();	
//			m_text.font = __font.fontName;
			
			m_text.color = __color;
			m_text.size = __size;
			m_text.letterSpacing = __spacing;
			m_text.leading = __leading;
			m_text.align = __alignment
			
			m_text.width = __width;
			m_text.height = __height;
		}
		
		//------------------------------------------------------------------------------------------
	}
	
	//------------------------------------------------------------------------------------------
}