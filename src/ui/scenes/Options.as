package src.ui.scenes 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.system.Capabilities;
	import flash.system.TouchscreenType;
	import net.sfxworks.firebaseREST.Core;
	import src.Main;
	import src.definitions.Scenes;
	/**
	 * ...
	 * @author Samuel Walker
	 */
	public class Options extends CoreScene 
	{
		var fbCore:Core;
		
		
		public function Options() 
		{
			super();
		}
		
		override public function init():void
		{
			fbCore = (this.parent as Main).fbCore;
			
			if (Capabilities.touchscreenType == TouchscreenType.NONE)
			{
				topUp_btn.addEventListener(MouseEvent.CLICK, handleTopUp);
				switchPlan_btn.addEventListener(MouseEvent.CLICK, handleSwitchPlan);
				logout_btn.addEventListener(MouseEvent.CLICK, handleLogout);
				back_btn.addEventListener(MouseEvent.CLICK, handleBack);
			}
			else
			{
				topUp_btn.addEventListener(TouchEvent.TOUCH_TAP, handleTopUp);
				switchPlan_btn.addEventListener(TouchEvent.TOUCH_TAP, handleSwitchPlan);
				logout_btn.addEventListener(TouchEvent.TOUCH_TAP, handleLogout);
				back_btn.addEventListener(TouchEvent.TOUCH_TAP, handleBack);
			}
		}
		
		private function handleBack(e:Event):void 
		{
			removeEventListeners();
			(parent as Main).gotoAndStop(Scenes.BROWSE_SCENE);
		}
		
		private function handleLogout(e:Event):void 
		{
			
			removeEventListeners();
			(parent as Main).gotoAndStop(Scenes.LOGIN_SCENE);
			
		}
		
		private function handleSwitchPlan(e:Event):void 
		{
			removeEventListeners();
			(parent as Main).gotoAndStop(Scenes.SELECT_PLAN_SCENE);
		}
		
		private function handleTopUp(e:Event):void 
		{
			removeEventListeners();
			(parent as Main).gotoAndStop(Scenes.TOP_UP_SCENE);
		}
		
		private function removeEventListeners():void
		{
			if (Capabilities.touchscreenType == TouchscreenType.NONE)
			{
				topUp_btn.removeEventListener(MouseEvent.CLICK, handleTopUp);
				switchPlan_btn.removeEventListener(MouseEvent.CLICK, handleSwitchPlan);
				logout_btn.removeEventListener(MouseEvent.CLICK, handleLogout);
				back_btn.removeEventListener(MouseEvent.CLICK, handleBack);
			}
			else
			{
				topUp_btn.removeEventListener(TouchEvent.TOUCH_TAP, handleTopUp);
				switchPlan_btn.removeEventListener(TouchEvent.TOUCH_TAP, handleSwitchPlan);
				logout_btn.removeEventListener(TouchEvent.TOUCH_TAP, handleLogout);
				back_btn.removeEventListener(TouchEvent.TOUCH_TAP, handleBack);
			}
		}
		
	}

}