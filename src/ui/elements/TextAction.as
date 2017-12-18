package src.ui.elements 
{
	import flash.display.MovieClip;
	import flash.text.TextFieldType;
	
	/**
	 * ...
	 * @author Samuel Walker
	 */
	public class TextAction extends MovieClip 
	{
		
		public function TextAction(text:String, input:Boolean = false) 
		{
			super();
			
			text_txt.text = text;
			
			
			if (input)
			{
				text_txt.type = TextFieldType.INPUT;
				text_txt.selectable = true;
			}
			else
			{
				mouseChildren = false;
				
			}
			
		}
		
	}

}