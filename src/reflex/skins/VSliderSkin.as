package reflex.skins
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import reflex.layouts.BasicLayout;
	import reflex.text.Label;
	import reflex.text.TextFieldDisplay;

	public class VSliderSkin extends GraphicSkin
	{
		
		public var thumb:Sprite;
		public var track:Sprite;
		
		public function VSliderSkin()
		{
			super();
			unscaledWidth = 14;
			track = new Sprite();
			renderTrack(track.graphics, unscaledWidth, unscaledHeight);
			thumb = new Sprite();
			renderThumb(thumb.graphics, unscaledWidth, unscaledHeight);
			//layout = new BasicLayout();
			content = [track, thumb];
			measured.width = 14;
			measured.height = 170;
		}
		
		override public function setSize(width:Number, height:Number):void
		{
			// Render track before setSize called - invalidation process causes heightChanged and widthChanged events to be dispatched before child is updated. Meaning anything that accesses children directly will retrieve the old size.
			renderTrack( track.graphics, width, height );
			super.setSize( width, height );
		}
		
		private function renderThumb(g:Graphics, width:Number, height:Number):void {
			g.clear();
			g.beginFill(0xFFFFFF, 1);
			g.drawRect(0, 0, width, height);
			g.endFill();
		}
		
		private function renderTrack(g:Graphics, width:Number, height:Number):void {
			g.clear();
			g.beginFill(0x363636, 1);
			g.drawRect(0, 0, width, height);
			g.endFill();
		}
		
	}
}