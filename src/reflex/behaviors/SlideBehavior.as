package reflex.behaviors
{
	
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import reflex.binding.DataChange;
	import reflex.data.IPagingPosition;
	import reflex.data.IPosition;
	
	public class SlideBehavior extends Behavior// extends StepBehavior
	{
		
		static public const HORIZONTAL:String = "horizontal";
		static public const VERTICAL:String = "vertical";
		
		private var _track:Object;
		private var _thumb:Object;
		private var _position:IPosition;
		private var _clickPoint:Point = new Point();
		
		public var page:Boolean = false;
		public var layoutChildren:Boolean = true;
		public var direction:String = HORIZONTAL;
		
		[Bindable]
		[Binding(target="target.skin.track")]
		public function get track():Object { return _track; }
		public function set track(value:Object):void {
			DataChange.change(this, "track", _track, _track = value);
		}
		
		[Bindable]
		[Binding(target="target.skin.thumb")]
		public function get thumb():Object { return _thumb; }
		public function set thumb(value:Object):void {
			DataChange.change(this, "thumb", _thumb, _thumb = value);
		}
		
		[Bindable]
		[Binding(target="target.position")]
		public function get position():IPosition { return _position; }
		public function set position(value:IPosition):void {
			DataChange.change(this, "position", _position, _position = value);
		}
		
		public function SlideBehavior(target:IEventDispatcher = null, direction:String = "horizontal", page:Boolean = false) {
			super(target);
			this.direction = direction;
			this.page = page;
			//updateUILayout();
		}
		
		// behavior
		
		[EventListener(event="mouseDown", target="track")]
		public function onTrackPress(event:MouseEvent):void
		{
			var t:Object = target as Object;
			if(page) {
				if(direction == HORIZONTAL) {
					pagePosition(t.mouseX - track.x, track.width);
				} else if(direction == VERTICAL) {
					pagePosition(t.mouseY - track.y, track.height);
				}
			} else {
				if(direction == HORIZONTAL) {
					jumpToPosition(t.mouseX - track.x, track.width);
				} else if(direction == VERTICAL) {
					jumpToPosition(t.mouseY - track.y, track.height);
				}
			}
			updateUIPosition();
		}
		
		[EventListener(event="mouseDown", target="thumb")]
		public function onThumbDown(event:MouseEvent):void
		{
			var target:Object = target as Object;
			_clickPoint = new Point( target.mouseX - thumb.x, target.mouseY - thumb.y );
			target.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			target.stage.addEventListener(MouseEvent.MOUSE_UP, onThumbUp, false, 0, true);
			target.stage.addEventListener(Event.MOUSE_LEAVE, onThumbUp, false, 0, true);
		}
		
		private function onThumbUp(event:MouseEvent):void {
			var target:Object = target as Object;
			_clickPoint = new Point();
			target.removeEventListener(Event.ENTER_FRAME, onEnterFrame, false);
			target.stage.removeEventListener(MouseEvent.MOUSE_UP, onThumbUp, false);
			target.stage.removeEventListener(Event.MOUSE_LEAVE, onThumbUp, false);
		}
		
		private function onEnterFrame(event:Event):void {
			var percent:Number = 0;
			var t:Object = target as Object;
			
			if(direction == HORIZONTAL) {
				percent = (thumb.x - track.x)/(track.width-thumb.width);
				thumb.x = Math.max(track.x, Math.min(track.x+track.width-thumb.width, t.mouseX - _clickPoint.x));
			} else if(direction == VERTICAL) {
				percent = (thumb.y - track.y)/(track.height-thumb.height);
				thumb.y = Math.max(track.y, Math.min(track.y+track.height-thumb.height, t.mouseY - _clickPoint.y));
			}
			
			var value:Number = (position.maximum-position.minimum)*percent + position.minimum;
			position.value = Math.max(position.minimum, Math.min(position.maximum, value));
		}
		
		// skinpart positioning
		
		//[CommitProperties(properties="position.min, position.max, position.position, position.pageSize")]
		[EventListener(event="valueChange", target="position")]
		public function onPositionChange(event:Event):void {
			updateUIPosition();
		}
		
		[EventListener(event="heightChange", target="target")]
		public function onSizeChange(event:Event):void {
			updateUILayout();
			updateUIPosition();
		}
		
		private function pagePosition(v:Number, length:Number):void {
			var scroll:IPagingPosition = position as IPagingPosition;
			if(scroll) {
				var center:Number = length/2;
				if(v < center) {
					scroll.value -= scroll.pageSize;
				} else {
					scroll.value += scroll.pageSize;
				}
			}
		}
		
		private function jumpToPosition(v:Number, length:Number):void {
			var percent:Number = v/length;
			position.value = (position.maximum-position.minimum)*percent + position.minimum;
		}
		
		private function updateUIPosition():void {
			var percent:Number = (position.value-position.minimum)/(position.maximum-position.minimum);
			if(target && track && thumb) {
				if(direction == HORIZONTAL) {
					thumb.x = track.x + (track.width-thumb.width) * percent;
				} else if(direction == VERTICAL) {
					thumb.y = track.y + (track.height-thumb.height) * percent;
					//thumb.y = ( (track.y-_clickPoint.y) + (track.height) * percent );
				}
			}
		}
		
		private function updateUILayout():void {
			if(target && track && thumb) {
				if(direction == HORIZONTAL) {
					var w2:Number = (target as Object).width/2;
					track.x = w2 - track.width/2;
					thumb.x = w2 - thumb.width/2;
				} else {
					var h2:Number = (target as Object).height/2;
					/*track.y = h2 - track.height/2;*/
					thumb.y = h2 - thumb.height/2;
				}
			}
		}
	}
}
