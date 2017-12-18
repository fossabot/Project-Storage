package src.ui.scenes 
{
	import src.definitions.Scenes;
	/**
	 * ...
	 * @author Samuel Walker
	 */
	public class Notice extends NavScene 
	{
		
		public function Notice() 
		{
			super();
			
			setNavScene(continue_btn, back_btn, Scenes.TOP_UP_SCENE, Scenes.SELECT_PLAN_SCENE, ".", ".");
		}
		
	}

}