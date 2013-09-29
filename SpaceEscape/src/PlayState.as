package
{
	import org.flixel.*;

	public class PlayState extends FlxState
	{
		public var level:FlxTilemap;
		public var exit:Exit;
		public var documents:FlxGroup;
		public var player:FlxSprite;
		public var score:FlxText;
		public var status:FlxText;
		public var countDown:FlxText;
		private var levelLength:Number = 120;
		public var timer:FlxTimer;
		public var gameTimer:FlxTimer;
		private var flipTime:Number = 10;
		private var currentLevel:Number = 0;
		private var won:Boolean = false;
		
		//Embed Sounds
		[Embed(source = "../assets/sounds/162485__kastenfrosch__space.mp3")] private var StartLevel:Class;
		[Embed(source="../assets/sounds/zoom gravity change.mp3")] private var GravityFlipWarning:Class;
		[Embed(source = "../assets/sounds/save_doc.mp3")] private var SaveDocument:Class;
		[Embed(source = "../assets/sounds/162482__kastenfrosch__achievement.mp3")] private var DoorOpen:Class;
		[Embed(source = "../assets/sounds/warning.mp3")] private var LowTime:Class;
		private var playLowTime:Boolean = true;
		[Embed(source="../assets/sounds/explosion2.mp3")] private var Explosion:Class;
		
		override public function create():void
		{
			timer = new FlxTimer();	
			timer.start((flipTime + 5 * (FlxG.random())), 1, gravityFlip);
			gameTimer = new FlxTimer();
			gameTimer.start(levelLength, 1, explodePlayer);			
			//Set the background color to light gray (0xAARRGGBB)
			FlxG.bgColor = 0xffaaaaaa;
			
			//Design your platformer level with 1s and 0s (at 40x30 to fill 320x240 screen)
			var levelOneData:Array = new Array(
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1,
			1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1,
			1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1,
			1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 );
			
			var levelTwoData:Array = new Array(
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1,
			1, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 );
			
			//Create a new tilemap using our level data
			level = new FlxTilemap();
			level.loadMap(FlxTilemap.arrayToCSV(levelTwoData,40),FlxTilemap.ImgAuto,0,0,FlxTilemap.AUTO);
			add(level);
			
			//Create the level exit, a dark gray box that is hidden at first
			//exit = new Exit(35 * 8 + 1, 27 * 8);
			//level2
			exit = new Exit(19, 27 * 8);
			add(exit);
			
			//Create documents to save
			//documents = addLevelOneDocuments();
			documents = addLevelTwoDocuments();
			
			
			add(documents);
			
			//Create player
			player = new Player()
			add(player);
			
			score = new FlxText(2,2,80);
			score.shadow = 0xff000000;
			score.text = "SCORE: "+(documents.countDead()*100);
			add(score);
			
			status = new FlxText(FlxG.width-160-2,2,160);
			status.shadow = 0xff000000;
			status.alignment = "right";
			
			countDown = new FlxText(FlxG.width-160-2,2,160);
			countDown.shadow = 0xff000000;
			countDown.alignment = "left";
			countDown.text = String(gameTimer.timeLeft);
			
			switch(FlxG.score)
			{
				case 0: status.text = "Grab the docs!"; break;
				case 1: status.text = "Aww, you died!"; break;
			}

			add(status);
			add(countDown);
			FlxG.play(StartLevel);
		}
		
		//creates a new document located on the specified tile
		public function createDocument(X:uint,Y:uint):FlxSprite
		{
			var document:FlxSprite = new FlxSprite(X*8+3,Y*8+2);
			document.makeGraphic(2, 4, 0xffffffff);
			return document;
		}
		
		private function gravityFlip(timer:FlxTimer):void
		{	
			FlxG.play(GravityFlipWarning);
			player.acceleration.y = -player.acceleration.y;
			var whenFlip:Number = flipTime + 5 * (FlxG.random());
			timer.start(whenFlip, 1, gravityFlip);
		}
		
		private function explodePlayer(gameTimer:FlxTimer):void {
			playLowTime = false;
			FlxG.play(Explosion);
			killPlayer();
			FlxG.bgColor = 0xffff0000;
			exit.exists = false;
			status.text = "Time's up! You dead!"			
		}
		
		private function killPlayer():void
		{
			FlxG.score = 1;
			player.kill();
			timer.stop();
		}
		
		override public function update():void
		{
			countDown.text = String(Math.ceil(gameTimer.timeLeft));
			//Play Time Warning at 5 Seconds Left
			if (gameTimer.timeLeft < 5 && playLowTime && gameTimer.timeLeft > 2.5) {
				FlxG.play(LowTime);
			}
			
			//Updates all the objects appropriately
			super.update();

			//Check if player collected a document or documents this frame
			FlxG.overlap(documents,player,getDocument);
		
			//Trigger Player Exit on Door Open
			if (won) {
				FlxG.overlap(exit,player,win);
			}
			
			//Finally, bump the player up against the level
			FlxG.collide(level, player);
			
			//Check for player lose conditions
			if(player.y > FlxG.height)
			{
				FlxG.score = 1; //sets status.text to "Aww, you died!"
				FlxG.resetState();
			}
		}
		
		//Called whenever the player touches a document
		public function getDocument(Document:FlxSprite,Player:FlxSprite):void
		{
			FlxG.play(SaveDocument);
			Document.kill();
			score.text = "SCORE: "+(documents.countDead()*100);
			if(documents.countLiving() == 0)
			{
				FlxG.play(DoorOpen);
				status.text = "Escape the ship!";
				exit.open();
				won = true;
				add(exit);
			}
		}
		
		//Called whenever the player touches the exit
		public function win(Exit:FlxSprite,Player:FlxSprite):void
		{
			gameTimer.stop();
			status.text = "Yay, you won!";
			score.text = "SCORE: 5000";
			Player.kill();
		}
		
/*		private function loadLevelTwo():void
		{
			FlxG.switchState(new LevelEndState);
		}
		*/
		
		//Level One Map and Coins		
		public function addLevelOneDocuments():FlxGroup {
			var docs:FlxGroup = new FlxGroup();
			
			//Top left documents
			docs.add(createDocument(18,4));
			docs.add(createDocument(12,4));
			docs.add(createDocument(9,4));
			docs.add(createDocument(8,11));
			docs.add(createDocument(1,7));
			docs.add(createDocument(3,4));
			docs.add(createDocument(5,2));
			docs.add(createDocument(15,11));
			docs.add(createDocument(16,11));
			
			//Bottom left documents
			docs.add(createDocument(3,16));
			docs.add(createDocument(4,16));
			docs.add(createDocument(1,23));
			docs.add(createDocument(2,23));
			docs.add(createDocument(3,23));
			docs.add(createDocument(4,23));
			docs.add(createDocument(5,23));
			docs.add(createDocument(12,26));
			docs.add(createDocument(13,26));
			docs.add(createDocument(17,20));
			docs.add(createDocument(18,20));
			
			//Top right documents
			docs.add(createDocument(21,4));
			docs.add(createDocument(26,2));
			docs.add(createDocument(29,2));
			docs.add(createDocument(31,5));
			docs.add(createDocument(34,5));
			docs.add(createDocument(36,8));
			docs.add(createDocument(33,11));
			docs.add(createDocument(31,11));
			docs.add(createDocument(29,11));
			docs.add(createDocument(27,11));
			docs.add(createDocument(25,11));
			docs.add(createDocument(36,14));
			
			//Bottom right documents
			docs.add(createDocument(38,17));
			docs.add(createDocument(33,17));
			docs.add(createDocument(28,19));
			docs.add(createDocument(25,20));
			docs.add(createDocument(18,26));
			docs.add(createDocument(22,26));
			docs.add(createDocument(26,26));
			docs.add(createDocument(30,26));
			
			return docs;				
		}
	
		//Level Two Map and Coins
		public function addLevelTwoDocuments():FlxGroup {
			var docs:FlxGroup = new FlxGroup();
			
			//Top left documents
			docs.add(createDocument(12,4));
			docs.add(createDocument(9,4));
			docs.add(createDocument(8,11));
			docs.add(createDocument(1,7));
			docs.add(createDocument(3,2));
			docs.add(createDocument(4, 2));
			docs.add(createDocument(16,9));
			docs.add(createDocument(16,10));
			docs.add(createDocument(16,11));
			
			//Top right documents
			docs.add(createDocument(18,3));
			docs.add(createDocument(21, 3));
			
			docs.add(createDocument(25,2));
			docs.add(createDocument(26,1));
			docs.add(createDocument(26,2));
			docs.add(createDocument(26,3));
			docs.add(createDocument(27,2));
			
			docs.add(createDocument(31,5));
			docs.add(createDocument(32,5));
			docs.add(createDocument(33,5));
			docs.add(createDocument(36,8));
			docs.add(createDocument(26,11));
			docs.add(createDocument(25,11));
			
			docs.add(createDocument(28,12));
			docs.add(createDocument(37,12));
			docs.add(createDocument(38,12));
			
			//Bottom left documents
			docs.add(createDocument(3,16));
			docs.add(createDocument(4,16));
			docs.add(createDocument(1,24));
			docs.add(createDocument(2,24));
			docs.add(createDocument(1,28));
			docs.add(createDocument(5,23));
			docs.add(createDocument(7,21));
			docs.add(createDocument(8,21));
			
			//Bottom Middle Documents
			docs.add(createDocument(17,20));
			docs.add(createDocument(18, 20));

			docs.add(createDocument(10,21));
			docs.add(createDocument(10,24));
			
			docs.add(createDocument(15,28));
			docs.add(createDocument(16,28));
			docs.add(createDocument(17,28));
			docs.add(createDocument(18,28));
			
			//Bottom right documents
			docs.add(createDocument(37,14));
			docs.add(createDocument(38,14));
			docs.add(createDocument(37,15));
			docs.add(createDocument(38,15));
			docs.add(createDocument(38,28));
			docs.add(createDocument(37,28));
			docs.add(createDocument(30,21));
			docs.add(createDocument(33,24));
			docs.add(createDocument(23,21));
			docs.add(createDocument(23,26));
			docs.add(createDocument(25,26));
			
			return docs;				
		}
	}
	
}
