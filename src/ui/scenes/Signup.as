package src.ui.scenes 
{
	import flash.events.IOErrorEvent;
	import net.sfxworks.firebaseREST.Core;
	import net.sfxworks.firebaseREST.events.AuthEvent;
	import src.Main;
	import src.definitions.Scenes;
	import src.ui.elements.CustomAlert;
	/**
	 * ...
	 * @author Samuel Walker
	 */
	public class Signup extends NavScene 
	{
		private var fbCore:Core;
		
		public function Signup() 
		{
			super();
			
			fbCore = (this.parent as Main).fbCore;
			
			setNavScene(continue_btn, back_btn, Scenes.SELECT_PLAN_SCENE, Scenes.LOGIN_SCENE, ".", ".", false);
		}
		
		override public function conditional():Boolean
		{
			attemptLoginWithUserPass();
			return false;
		}
		
		private function attemptLoginWithUserPass():void 
		{
			fbCore.auth.register(email_txt.text, password_txt.text);
			fbCore.auth.addEventListener(AuthEvent.REGISTER_SUCCESS, handleRegisterSuccess);
			fbCore.auth.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
		}
		
		private function handleIOError(e:IOErrorEvent):void 
		{
			parent.addChild(new CustomAlert("Cannot Regiser.", "Either the password isn't secure enough, or the email is formatted incorrectly or taken already."));
		}
		
		private function handleRegisterFailure(e:AuthEvent):void 
		{
			parent.addChild(new CustomAlert("Cannot Regiser.", e.message)); //Gotta see what it makes.
			
			
		}
		
		private function handleRegisterSuccess(e:AuthEvent):void 
		{
			proceed(Scenes.SELECT_PLAN_SCENE);
		}
		
		
		
		
		
	}

}