//------------------------------------------------------------------------------------------
// <$begin$/>
// <$end$/>
//------------------------------------------------------------------------------------------
package gx.game {
		
	import gx.*;
	
	import kx.*;
	import kx.geom.*;
	import kx.task.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	
	import flash.filters.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	
	//------------------------------------------------------------------------------------------
	public class Gamestate extends XLogicObjectCX {
		protected var script:XTask;
		
		//------------------------------------------------------------------------------------------
		public function Gamestate () {
			super ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array /* <Dynamic> */):void {
			super.setup (__xxx, args);
			
			createSprites ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setupX ():void {
			super.setupX ();
			
			script = addEmptyTask ();
		}

		//------------------------------------------------------------------------------------------
		public function gotoState (__name:String, __params:Array /* <Dynamic> */ = null, __layer:int = 0, __depth:Number = 0.0):Gamestate {
			return GX.appX.gotoState (__name, __params, __layer, __depth);	
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}