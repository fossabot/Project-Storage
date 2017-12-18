package src
{
	import com.doitflash.consts.Easing;
	import com.doitflash.consts.Orientation;
	import com.doitflash.starling.utils.scroller.Scroller;
	import com.doitflash.utils.scroll.RegSimpleScroll;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.system.Capabilities;	
	import flash.system.TouchscreenType;
	/**
	 * ...
	 * @author ...
	 */
	public class ScrollContent extends MovieClip
	{
		
		private var currentY:int;
		private var currentX:int;
		private var _scroller;
		
		public var container:MovieClip;
		private var orientation:String;
		
		private var displayList:Vector.<DisplayObject>;
		private var _spacing:int = 0;
		private var beginPos:Point;
		
		public var velocity:Number = 1;
		
		public var isSelected:Boolean = false;
		
		public var isZooming:Boolean = false;
		
		public function ScrollContent(stage:Stage, orientation:String=Orientation.VERTICAL) 
		{
			this.orientation = orientation;
			currentY = 0;
			currentX = 0;
			
			container = new MovieClip();
			
			
			if (Capabilities.touchscreenType == TouchscreenType.NONE)
			{
				_scroller = new RegSimpleScroll();
				_scroller.maskContent = container;
				addChild(_scroller);
			}
			else
			{
				this.addChild(container);
				
				_scroller = new Scroller();
				_scroller.content = container;
				_scroller.orientation = orientation;
				_scroller.easeType = Easing.Strong_easeOut;
				_scroller.duration = 1;
				_scroller.holdArea = 2;
				_scroller.isStickTouch = true;
				container.addEventListener(TouchEvent.TOUCH_BEGIN, scrollBegin);
				container.addEventListener(TouchEvent.TOUCH_MOVE, scrollMove);
				stage.addEventListener(TouchEvent.TOUCH_END, handleScrollEnd);
			}
			
			displayList = new Vector.<DisplayObject>();
		}
		
		public function setScrollerBounds(bWidth:int = -1, bHeight:int = -1)
		{
			if (Capabilities.touchscreenType != TouchscreenType.NONE)
			{
				if (bWidth != -1)
				_scroller.boundWidth = bWidth;
				
				if (bHeight != -1)
					_scroller.boundHeight = bHeight;
			}
			else
			{
				if (bWidth != -1)
					_scroller.maskWidth = bWidth;
				
				if (bHeight != -1)
					_scroller.maskHeight = bHeight;
			}
			
		}
		
		private function handleScrollEnd(e:TouchEvent):void 
		{
			if (isZooming == false)
			{
				if (isSelected)
				{
					_scroller.fling();
					isSelected = false;
				} 
			}
			
			//_scroller.xVelocity = _scroller.xVelocity * velocity;
			//_scroller.yVelocity = _scroller.yVelocity * velocity;
		}
		
		private function scrollMove(e:TouchEvent):void 
		{
			if (isZooming == false)
			{
				if (isSelected)
				{
					var pos:Point = new Point(e.stageX * velocity, e.stageY * velocity);
					_scroller.startScroll(pos);
				}
			}
			
			
		}
		
		private function scrollBegin(e:TouchEvent):void 
		{
			if (isZooming == false)
			{
				beginPos = new Point(e.stageX * velocity, e.stageY * velocity);
				_scroller.startScroll(beginPos);
				isSelected = true;
			}
			
		}
		
		public function addItem(displayObject:DisplayObject):void
		{
			if (orientation == Orientation.VERTICAL)
			{
				//Center object.
				//displayObject.x = (this.width - displayObject.width) / 2;
				displayObject.y = currentY;
				
				currentY += displayObject.height + _spacing;				
			}
			else
			{
				//Horizontal.
				displayObject.x = currentX;
				currentX += displayObject.width + _spacing; //only one with spacing so adding a buffer
			}
			displayList.push(displayObject);
			container.addChild(displayObject);
			
			//_scroller.computeXPerc(true);
			//_scroller.computeYPerc(true);
		}
		
		public function removeItems():void
		{
			for each (var obj:DisplayObject in displayList)
			{
				container.removeChild(obj);
				obj = null;
			}
			container.x = 0;
			container.y = 0;
			currentX = 0;
			currentY = 0;
			displayList = new Vector.<DisplayObject>();
		}
		
		public function get spacing():int 
		{
			return _spacing;
		}
		
		public function set spacing(value:int):void 
		{
			_spacing = value;
		}
		
		public function get scroller():* 
		{
			return _scroller;
		}
		
		
	}

}