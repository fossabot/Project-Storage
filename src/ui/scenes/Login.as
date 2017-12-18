package src.ui.scenes 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.system.Capabilities;
	import flash.system.TouchscreenType;
	import net.sfxworks.firebaseREST.Core;
	import net.sfxworks.firebaseREST.events.AuthEvent;
	import src.Main;
	import src.definitions.Scenes;
	import src.ui.elements.CustomAlert;
	/**
	 * ...
	 * @author Samuel Walker
	 */
	public class Login extends CoreScene 
	{
		
		public var fbCore:Core;
		
		public function Login() 
		{
			super();
			
			
			
		}
		
		
		override public function init():void
		{
			
			if (Capabilities.touchscreenType == TouchscreenType.NONE)
			{
				login_btn.addEventListener(MouseEvent.CLICK, handleLoginHit);
				signUp_btn.addEventListener(MouseEvent.CLICK, handleSignupHit);
				passwordReset_btn.addEventListener(MouseEvent.CLICK, handlePasswordResetHit);
			}
			else
			{
				login_btn.addEventListener(TouchEvent.TOUCH_TAP, handleLoginHit);
				signUp_btn.addEventListener(TouchEvent.TOUCH_TAP, handleSignupHit);
				passwordReset_btn.addEventListener(TouchEvent.TOUCH_TAP, handlePasswordResetHit);
			}
		}
		
		private function handlePasswordResetHit(e:Event):void 
		{
			removeEventListeners();
			(this.parent as Main).gotoAndStop(Scenes.PASSWORD_RESET_SCENE);
		}
		
		private function handleSignupHit(e:Event):void 
		{
			removeEventListeners();
			(this.parent as Main).gotoAndStop(Scenes.SIGNUP_SCENE);
		}
		
		private function handleLoginHit(e:Event):void 
		{
			fbCore = (this.parent as Main).fbCore;
			
			fbCore.auth.email_login(email_txt.text.split(" ").join(""), password_txt.text);
			fbCore.auth.addEventListener(AuthEvent.LOGIN_SUCCES, handleLoginSuccess);
			fbCore.auth.addEventListener(IOErrorEvent.IO_ERROR, handleLoginIOError);
		}
		
		private function handleLoginSuccess(e:AuthEvent):void 
		{
			fbCore.auth.removeEventListener(AuthEvent.LOGIN_SUCCES, handleLoginSuccess);
			fbCore.auth.removeEventListener(IOErrorEvent.IO_ERROR, handleLoginIOError);
			
			loginSuccess();
		}
		
		private function handleLoginIOError(e:IOErrorEvent):void 
		{
			fbCore.auth.removeEventListener(AuthEvent.LOGIN_SUCCES, handleLoginSuccess);
			fbCore.auth.removeEventListener(IOErrorEvent.IO_ERROR, handleLoginIOError);
			
			parent.addChild(new CustomAlert("Cannot login", "Either your connection or your credentials are invalid."));
		}
		
		private function loginSuccess():void
		{
			removeEventListeners();
			(this.parent as Main).gotoAndStop(Scenes.BROWSE_SCENE);
		}
		
		private function removeEventListeners():void
		{
			
			if (Capabilities.touchscreenType == TouchscreenType.NONE)
			{
				login_btn.removeEventListener(MouseEvent.CLICK, handleLoginHit);
				signUp_btn.removeEventListener(MouseEvent.CLICK, handleSignupHit);
				passwordReset_btn.removeEventListener(MouseEvent.CLICK, handlePasswordResetHit);
			}
			else
			{
				login_btn.removeEventListener(TouchEvent.TOUCH_TAP, handleLoginHit);
				signUp_btn.removeEventListener(TouchEvent.TOUCH_TAP, handleSignupHit);
				passwordReset_btn.removeEventListener(TouchEvent.TOUCH_TAP, handlePasswordResetHit);
			}
		}
		
	}

}