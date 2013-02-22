package
{
	
	import citrus.core.starling.StarlingCitrusEngine;	
	
	
	[SWF(width="800", height="480",frameRate="60",backgroundColor="#aaCCCC")]
	public class RubentxuDreams extends StarlingCitrusEngine
	{
		public function RubentxuDreams()
		{
						
			setUpStarling();			
			state = new GameState();		
		}
	}
}