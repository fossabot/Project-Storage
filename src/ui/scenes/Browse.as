package src.ui.scenes 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.system.Capabilities;
	import flash.system.TouchscreenType;
	import src.Main;
	import src.definitions.Scenes;
	/**
	 * ...
	 * @author Samuel Walker
	 */
	public class Browse extends CoreScene 
	{
		
		public function Browse() 
		{
			super();
		}
		
		override public function init():void
		{
			if (Capabilities.touchscreenType == TouchscreenType.NONE)
			{
				options_btn.addEventListener(MouseEvent.CLICK, handleOptionsHit);
				add_btn.addEventListener(MouseEvent.CLICK, handleAddHit);
			}
			else
			{
				options_btn.addEventListener(TouchEvent.TOUCH_TAP, handleOptionsHit);
				add_btn.addEventListener(TouchEvent.TOUCH_TAP, handleAddHit);
			}
		}
		
		private function handleOptionsHit(e:Event):void 
		{
			removeEventListeners();
			(this.parent as Main).gotoAndStop(Scenes.OPTIONS_SCENE);
			
		}
		
		private function handleAddHit(e:Event):void 
		{
			//var f:File = new File();
			//f.browse();
		}
		
		
		private function removeEventListeners():void
		{
			if (Capabilities.touchscreenType == TouchscreenType.NONE)
			{
				options_btn.removeEventListener(MouseEvent.CLICK, handleOptionsHit);
				add_btn.removeEventListener(MouseEvent.CLICK, handleAddHit);
			}
			else
			{
				options_btn.removeEventListener(TouchEvent.TOUCH_TAP, handleOptionsHit);
				add_btn.removeEventListener(TouchEvent.TOUCH_TAP, handleAddHit);
			}
		}
		
		
	}

}