package src.ui.scenes 
{
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.system.Capabilities;
	import flash.system.TouchscreenType;
	import src.Main;
	import src.ui.elements.CustomAlert;
	/**
	 * ...
	 * @author Samuel Walker
	 */
	public class NavScene extends CoreScene 
	{
		private var continue_btn:SimpleButton;
		private var back_btn:SimpleButton;
		
		internal var continueFrame:int;
		internal var backFrame:int;
		
		internal var alertTitle:String;
		internal var alertMessage:String;
		
		internal var showAlert:Boolean;
		
		public function NavScene() 
		{
			super();
		}
		
		//Must call upon extension.
		public function setNavScene(continue_btn:SimpleButton, back_btn:SimpleButton, cFrame:int = -1, bFrame:int = -1, aTitle:String = "Error.", aMessaage:String = "Cannot Proceed.", showAlertByDefault = true)
		{
			this.back_btn = back_btn;
			this.continue_btn = continue_btn;
			
			if (Capabilities.touchscreenType == TouchscreenType.NONE)
			{
				continue_btn.addEventListener(MouseEvent.CLICK, handleContinue);
				back_btn.addEventListener(MouseEvent.CLICK, handleBack);
			}
			else
			{
				continue_btn.addEventListener(TouchEvent.TOUCH_TAP, handleContinue);
				back_btn.addEventListener(TouchEvent.TOUCH_TAP, handleBack);
			}
			
			continueFrame = cFrame;
			backFrame = bFrame;
			
			if (continueFrame == -1)
				continueFrame = (this.parent as Main).currentFrame +1;
				
			if (backFrame == -1)
				backFrame = (this.parent as Main).currentFrame -1;
			
			this.alertTitle = aTitle;
			this.alertMessage = aMessaage;
			
			showAlert = showAlertByDefault;
		}
		
		private function handleBack(e:Event):void 
		{
			proceed(backFrame);
		}
		
		private function handleContinue(e:Event):void 
		{
			if (conditional())
				proceed(continueFrame);
			else
				if (showAlert)
					parent.addChild(new CustomAlert(alertTitle, alertMessage));
		}
		
		public function conditional():Boolean
		{
			return true; //If async override as false. Wait for serfer response. Call proceed.
		}
		
		public function proceed(targetFrame:int):void //For Async
		{
			removeEventListeners();
			
			var par:Main = this.parent as Main;
			par.gotoAndStop(targetFrame);
		}
		
		private function removeEventListeners():void
		{
			if (Capabilities.touchscreenType == TouchscreenType.NONE)
			{
				continue_btn.removeEventListener(MouseEvent.CLICK, handleContinue);
				back_btn.removeEventListener(MouseEvent.CLICK, handleBack);
			}
			else
			{
				continue_btn.removeEventListener(TouchEvent.TOUCH_TAP, handleContinue);
				back_btn.removeEventListener(TouchEvent.TOUCH_TAP, handleBack);
			}
		}
		
		
		
		
		
	}

}