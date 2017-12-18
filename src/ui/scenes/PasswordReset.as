package src.ui.scenes 
{
	import net.sfxworks.firebaseREST.Core;
	import src.Main;
	import src.definitions.Scenes;
	import src.ui.elements.CustomAlert;
	/**
	 * ...
	 * @author Samuel Walker
	 */
	public class PasswordReset extends NavScene 
	{
		
		private var fbCore:Core;
		
		public function PasswordReset() 
		{
			super();
			
			setNavScene(continue_btn, back_btn, Scenes.PASSWORD_RESET_SCENE, Scenes.LOGIN_SCENE, "Invalid", "Please enter a valid email address.");
			fbCore = (this.parent as Main).fbCore;
		}
		
		override public function conditional():Boolean
		{
			if (email_txt.text.indexOf("@") != -1)
			{
				fbCore.auth.resetPassword(email_txt.text);
				parent.addChild(new CustomAlert("Reset: Conditional", "If an email is associated with the one provided, a password reset link will be sent momentarily."));
				return true;
			}
			
			return false;
		}
		
	}

}