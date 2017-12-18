package src.ui.scenes 
{
	import com.doitflash.consts.Orientation;
	import com.doitflash.utils.scroll.RegSimpleScroll;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.system.Capabilities;
	import flash.system.TouchscreenType;
	import flash.text.TextFieldType;
	import src.ScrollContent;
	import src.ui.elements.TextAction;
	
	/**
	 * ...
	 * @author Samuel Walker
	 */
	public class ActionSelect extends MovieClip 
	{
		private var stagee:Stage;
		
		private var scroller:ScrollContent;
		
		public function ActionSelect(stagee:Stage) 
		{
			super();
			this.stagee = stagee;
			
			scroller = new ScrollContent(stagee, Orientation.VERTICAL);
			scroller.spacing = 30;
			addChild(scroller);
			
			
			scroller.y = 110; //Menu height
			
		}
		
		public function displayActions(actions:Vector.<String>):Vector.<TextAction>
		{
			var returnVec:Vector.<TextAction> = new Vector.<TextAction>();
			
			for each (var action:String in actions)
			{
				var textAct:TextAction = new TextAction(action);
				textAct.x = (stagee.stageWidth - textAct.width) / 2;
				
				returnVec.push(textAct);
				scroller.addItem(textAct);
			}
			
			if (scroller.height < stagee.stageHeight)
				scroller.y = (stagee.stageHeight - scroller.height) / 2;
			
			scroller.setScrollerBounds(stagee.stageWidth, stage.stageHeight - 110);
			
			return returnVec;
		}
		
		public function displayInput(actions:Vector.<String>):Vector.<TextAction>
		{
			var returnVec:Vector.<TextAction> = new Vector.<TextAction>();
			
			for each (var action:String in actions)
			{
				var textAct:TextAction = new TextAction(action, true);
				textAct.x = (stagee.stageWidth - textAct.width) / 2;
				
				returnVec.push(textAct);
				scroller.addItem(textAct);
			}
			
			if (scroller.height < stagee.stageHeight)
				scroller.y = (stagee.stageHeight - scroller.height) / 2;
			
			scroller.setScrollerBounds(stagee.stageWidth, stage.stageHeight - 110);
			
			return returnVec;
		}
		
		
	}

}