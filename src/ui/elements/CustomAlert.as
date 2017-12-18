package src.ui.elements 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.system.Capabilities;
	import flash.system.TouchscreenType;
	
	/**
	 * ...
	 * @author Samuel Walker
	 */
	public class CustomAlert extends MovieClip 
	{
		
		public function CustomAlert(title:String, message:String) 
		{
			super();
			
			title_txt.text = title;
			message_txt.text = message;
			
			if (Capabilities.touchscreenType == TouchscreenType.NONE)
			{
				addEventListener(MouseEvent.CLICK, handleSelect);
			}
			else
			{
				addEventListener(TouchEvent.TOUCH_TAP, handleSelect);
			}
		}
		
		private function handleSelect(e:Event):void 
		{
			
			if (Capabilities.touchscreenType == TouchscreenType.NONE)
			{
				removeEventListener(MouseEvent.CLICK, handleSelect);
			}
			else
			{
				removeEventListener(TouchEvent.TOUCH_TAP, handleSelect);
			}
			
			this.parent.removeChild(this);		
		}
		
	}

}