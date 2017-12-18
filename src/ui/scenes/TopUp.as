package src.ui.scenes 
{
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.navigateToURL;
	import net.sfxworks.firebaseREST.Core;
	import src.Main;
	import src.definitions.Scenes;
	/**
	 * ...
	 * @author Samuel Walker
	 */
	public class TopUp extends NavScene 
	{
		private static const FIREBASE_TOPUP_URL:String = "https://us-central1-projectfilestore.cloudfunctions.net/generatePaypalURL";
		
		private var fbCore:Core;
		
		public function TopUp() 
		{
			super();
			
			fbCore = (this.parent as Main).fbCore;
			setNavScene(continue_btn, back_btn, Scenes.BROWSE_SCENE, Scenes.NOTICE_SCENE, "Not a number!", "Please enter a properly formatted numerical value to continue.");
			
		}
		
		
		override public function conditional():Boolean
		{
			
			topupAmount_txt.text = topupAmount_txt.text.split(" ").join("");
			
			if (isNaN(Number(topupAmount_txt.text.split(" ").join(""))))
			{
				trace("ISNAN");
				return false;
			}
			
			var rq:URLRequest = new URLRequest(FIREBASE_TOPUP_URL + "?uid=" + fbCore.auth.session.userID + "&email=" + fbCore.auth.session.email + "&amount=" + topupAmount_txt.text)
			
			trace("Navigating../");
			navigateToURL(rq,"_blank");
			
			return true;
		}
		
	}

}