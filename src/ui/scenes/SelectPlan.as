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
	public class SelectPlan extends NavScene 
	{
		
		private var selectplan:String="";
		
		public function SelectPlan() 
		{
			super();
			
			setNavScene(continue_btn, back_btn, Scenes.NOTICE_SCENE, Scenes.BROWSE_SCENE, "Cannot Proceed.", "You need to select a plan first.");
			
			
			if (Capabilities.touchscreenType == TouchscreenType.NONE)
			{
				free_mc.addEventListener(MouseEvent.CLICK, handlePlanSelect);
				xfer_mc.addEventListener(MouseEvent.CLICK, handlePlanSelect);
				scale_mc.addEventListener(MouseEvent.CLICK, handlePlanSelect);
			}
			else
			{
				free_mc.addEventListener(TouchEvent.TOUCH_TAP, handlePlanSelect);
				xfer_mc.addEventListener(TouchEvent.TOUCH_TAP, handlePlanSelect);
				scale_mc.addEventListener(TouchEvent.TOUCH_TAP, handlePlanSelect);
			}
			
			free_mc.mouseChildren = false;
			xfer_mc.mouseChildren = false;
			scale_mc.mouseChildren = false;
			
			free_mc.buttonMode = true;
			xfer_mc.buttonMode = true;
			scale_mc.buttonMode = true;
		}
		
		private function handlePlanSelect(e:Event):void 
		{
			free_mc.bg_mc.alpha = 0.5;
			xfer_mc.bg_mc.alpha = 0.5;
			scale_mc.bg_mc.alpha = 0.5;
			
			e.currentTarget.bg_mc.alpha = 0.9;
			selectplan = e.currentTarget.name.split("_")[0];
			
			if (e.currentTarget == free_mc)
			{
				continueFrame = Scenes.BROWSE_SCENE;
			}
			else
			{
				continueFrame = Scenes.NOTICE_SCENE;
			}
		}
		
		override public function conditional():Boolean 
		{
			if (selectplan == "")
				return false;
			
			(this.parent as Main).planRequest = selectplan;
			removeEventListeners();
			return true;
		}
		
		private function removeEventListeners():void
		{
			free_mc.removeEventListener(TouchEvent.TOUCH_TAP, handlePlanSelect);
			xfer_mc.removeEventListener(TouchEvent.TOUCH_TAP, handlePlanSelect);
			scale_mc.removeEventListener(TouchEvent.TOUCH_TAP, handlePlanSelect);
		}
		
		
		
	}

}