package src.ui.scenes 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Samuel Walker
	 */
	public class CoreScene extends MovieClip 
	{
		
		public function CoreScene() 
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
		}
		
		private function handleAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			init();
		}
		
		public function init():void 
		{
			
		}
		
	}

}