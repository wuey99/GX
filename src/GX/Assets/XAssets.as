//------------------------------------------------------------------------------------------
package GX.Assets {
	
	import X.*;
	import X.Resource.Manager.*;
	
	//------------------------------------------------------------------------------------------	
	public class XAssets extends Object {

		[Embed(source="Aller_Rg.ttf",
			fontName="Aller",  
			mimeType="application/x-font"
		)]
		public static const ArialClass:Class;
		
		[Embed(source="Aller_Rg.ttf",
			fontName="Aller",  
			mimeType="application/x-font"
		)]
		public static const ArialFontClass:Class;
		
		//------------------------------------------------------------------------------------------
		public var m_XApp:XApp;
		
		//------------------------------------------------------------------------------------------
		public function XAssets (__XApp:XApp, __parent:*) {
			m_XApp = __XApp;
		}
		
		//------------------------------------------------------------------------------------------
		public function load ():Boolean {			
			return false;	
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}