package src.services.events 
{
	import flash.events.Event;
	import src.definitions.FirebaseFile;
	
	/**
	 * ...
	 * @author Samuel Walker
	 */
	public class ProjectFilestoreEvent extends Event 
	{
		
		public static const NO_DEVICE_NAME:String = "pfnodevicename";
		public static const FILE_ADDED:String = "fileAdded";
		
		public function ProjectFilestoreEvent(type:String, file:FirebaseFile=null, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new ProjectFilestoreEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ProjectFilestoreEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}