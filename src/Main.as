package src
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.system.Capabilities;
	import flash.system.TouchscreenType;
	import net.sfxworks.firebaseREST.Core;
	import net.sfxworks.firebaseREST.events.AuthEvent;
	import src.services.FilestoreP2P;
	import src.services.ProjectFilestore;
	import src.ui.elements.TextAction;
	import src.ui.scenes.ActionSelect;

	/**
	 * ...
	 * @author Samuel Walker
	 */
	public class Main extends MovieClip 
	{
		private var actionSelect:ActionSelect;
		private var filestoreP2p:FilestoreP2P;
		
		public var fbCore:Core;
		public var mainService:ProjectFilestore;
		
		public var planRequest:String = "";
		
		public function Main() 
		{
			trace("Init.");
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stop();
			
			fbCore = new Core();
			fbCore.init(Keys.FB_KEY, Keys.FB_ID);
			
			mainService = new ProjectFilestore(fbCore);
			
			fbCore.auth.addEventListener(AuthEvent.LOGIN_SUCCES, handleLoginSuccess);
		}
		
		private function handleLoginSuccess(e:AuthEvent):void 
		{
			mainService.init();
		}
	}
	
}