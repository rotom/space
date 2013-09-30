package
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	public class MenuState extends FlxState
	{
		[Embed(source="../assets/space.png")]
		private var Background:Class;
		
		private var logoWidth:Number = 100;
		private var instructWidth:Number = 200;
		
		public function MenuState()
		{
			super();
		}
		
		override public function create():void
		{
			var background:FlxSprite = new FlxSprite(0,0,Background);
			add(background);
			
			var logo:FlxText = new FlxText(0.5*(FlxG.width - logoWidth), 60, logoWidth, "Space Escape");
			logo.setFormat(null, 20, 0xFFFFFF, "center");
			add(logo);
			
			var instruct:FlxText = new FlxText(0.5*(FlxG.width - instructWidth), 150, instructWidth, "press [SPACE] to start");
			instruct.setFormat(null, 10, 0xFF0000, "center");
			add(instruct);
		}
		
		override public function update():void 
		{
			if(FlxG.keys.SPACE) 
			{
				FlxG.switchState(new LevelOne());
			}
		}
	}
}