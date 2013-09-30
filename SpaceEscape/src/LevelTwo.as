package
{
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxTimer;
	
	public class LevelTwo extends FlxState
	{
		public var level:FlxTilemap;
		public var exit:FlxSprite;
		public var documents:FlxGroup;
		public var player:Player;
		public var score:FlxText;
		public var status:FlxText;
		public var countDown:FlxText;
		public var gravTimer:FlxTimer;
		public var gameTimer:FlxTimer;
		private var flipTime:Number = 9;
		private var pauseShade:FlxSprite;
		private var pauseText:FlxText;
		[Embed(source="../assets/space.png")]
		private var Background:Class;
		private var gameOverText:FlxText;
		private var restartText:FlxText;
		private var instruct:Boolean = false;
		private var instructText:FlxText;
		private var escapeText:FlxText;
		private var winner:Boolean = false;
		private var winnerText:FlxText;
		private var menuText:FlxText;
		private var credits:FlxText;
		
				
		//Embed Sounds
		[Embed(source = "../assets/sounds/162485__kastenfrosch__space.mp3")] private var StartLevel:Class;
		[Embed(source="../assets/sounds/zoom gravity change.mp3")] private var GravityFlipWarning:Class;
		[Embed(source = "../assets/sounds/save_doc.mp3")] private var SaveDocument:Class;
		[Embed(source = "../assets/sounds/162482__kastenfrosch__achievement.mp3")] private var DoorOpen:Class;
		[Embed(source = "../assets/sounds/warning.mp3")] private var LowTime:Class;
		private var playLowTime:Boolean = true;
		[Embed(source = "../assets/sounds/explosion2.mp3")] private var Explosion:Class;
		[Embed(source="../assets/sounds/jump.mp3")] private var JumpSound:Class;
		
		override public function create():void
		{
			FlxG.play(StartLevel);
			gravTimer = new FlxTimer();
			gravTimer.start((flipTime + 6 * (FlxG.random())), 1, gravityFlip);
			gravTimer.paused = true;
			gameTimer = new FlxTimer();
			gameTimer.start(120, 1, killPlayer);
			gameTimer.paused = true;
			//Set the background color to light gray (0xAARRGGBB)
			var background:FlxSprite = new FlxSprite(0,0,Background);
			add(background);
			
			//Design your platformer level with 1s and 0s (at 40x30 to fill 320x240 screen)
			var data:Array = new Array(
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
			level.loadMap(FlxTilemap.arrayToCSV(data,40),FlxTilemap.ImgAuto,0,0,FlxTilemap.AUTO);
			add(level);
			
			//Create the level exit, a dark gray box that is hidden at first
			exit = new FlxSprite(19, 27 * 8);
			exit.makeGraphic(14,16,0xeebbbbbb);
			exit.exists = false;
			add(exit);
			
			//Create documents to collect (see createDocument() function below for more info)
			documents = new FlxGroup();
			//Top left documents
			createDocument(12,4);
			createDocument(9,4);
			createDocument(8,11);
			createDocument(1,7);
			createDocument(3,2);
			createDocument(4, 2);
			createDocument(16,9);
			createDocument(16,10);
			createDocument(16,11);
			
			//Top right documents
			createDocument(18,3);
			createDocument(21, 3);
			
			createDocument(25,2);
			createDocument(26,1);
			createDocument(26,2);
			createDocument(26,3);
			createDocument(27,2);
			
			createDocument(31,5);
			createDocument(32,5);
			createDocument(33,5);
			createDocument(36,8);
			createDocument(26,11);
			createDocument(25,11);
			
			createDocument(28,12);
			createDocument(37,12);
			createDocument(38,12);
			
			//Bottom left documents
			createDocument(3,16);
			createDocument(4,16);
			createDocument(1,24);
			createDocument(2,24);
			createDocument(1,28);
			createDocument(5,23);
			createDocument(7,21);
			createDocument(8,21);
			
			//Bottom Middle Documents
			createDocument(17,20);
			createDocument(18, 20);
			createDocument(10,21);
			createDocument(10,24);
			
			createDocument(15,28);
			createDocument(16,28);
			createDocument(17,28);
			createDocument(18,28);
			
			//Bottom right documents
			createDocument(37,14);
			createDocument(38,14);
			createDocument(37,15);
			createDocument(38,15);
			createDocument(38,28);
			createDocument(37,28);
			createDocument(30,21);
			createDocument(33,24);
			createDocument(23,21);
			createDocument(23,26);
			createDocument(25,26);
			
			add(documents);
			
			//Create player (a red box)
			
			player = new Player(FlxG.width/2 - 5,10);
			player.maxVelocity.x = 80;
			player.maxVelocity.y = 260;
			player.acceleration.y = 200;
			player.drag.x = player.maxVelocity.x*4;
			add(player);
			
			//Initialize pause screen
			pauseShade = new FlxSprite(0,0);
			pauseShade.makeGraphic(FlxG.width, FlxG.height, 0x44000000);
			
			pauseText = new FlxText(0.5*(FlxG.width - 120), 0.5*FlxG.height - 10, 120, "PAUSED");
			pauseText.setFormat(null, 20, 0xFFFFFF, "center");
			
			//Initialize Game over screen
			gameOverText = new FlxText(0.5*(FlxG.width - 180), 0.5*FlxG.height - 50, 180, "GAME OVER");
			gameOverText.setFormat(null, 30, 0xFFFFFF, "center");
			
			restartText = new FlxText(0.5*(FlxG.width - 200), 160, 200, "press [R] to restart level");
			restartText.setFormat(null, 10, 0xFF0000, "center");
			
			//Instructions
			instructText = new FlxText(0.5*(FlxG.width - 220), 40, 220, "Your ship, the SS Newton, has taken damage from an asteroid" +
				"collision. The artificial gravity is going awry, but you must collect the valuable research docs before using the escape pod. " +
				"The fate of humanity lies in your arrow keys (and space bar).");
			instructText.setFormat(null, 9, 0xFFFFFF, "center");

			
			escapeText = new FlxText(0.5*(FlxG.width - 220), 140, 220, "press [ESC] to start your mission");
			escapeText.setFormat(null, 10, 0xFF0000, "center");
			
			//winner text
			winnerText = new FlxText(0.5*(FlxG.width - 220), 40, 220, "You won!");
			winnerText.setFormat(null, 15, 0xFFFFFF, "center");
			
			//credits
			credits = new FlxText(0.3*(FlxG.width - 220), 60, 150, "Credits: Pedro Cattori, Tom Roberts, Arturo Gonzalez, and Ben Shaibu. Sounds from Kastenfrosch and as3sfxr.");
			credits.setFormat(null, 15, 0xFFFFFF, "center");			
			
			//menu text
			menuText = new FlxText(1.7*(FlxG.width - 220), 140, 140, "press [SPACE] and [ESC] to return to menu");
			menuText.setFormat(null, 10, 0xFF0000, "center");
			
			
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
		}
		
		//creates a new document located on the specified tile
		public function createDocument(X:uint,Y:uint):void
		{
			var document:FlxSprite = new FlxSprite(X*8+3,Y*8+2);
			document.makeGraphic(3,5,0xffe6dd93);
			documents.add(document);
		}
		
		private function gravityFlip(gravTimer:FlxTimer):void
		{	
			FlxG.play(GravityFlipWarning);
			player.acceleration.y = -player.acceleration.y;
			gravTimer.start(flipTime+5*(FlxG.random()), 1, gravityFlip);
			player.angle = (180 + player.angle)%360;
			player.gravityNormal = !player.gravityNormal;
		}
		
		private function killPlayer(gameTimer:FlxTimer):void
		{
			FlxG.play(Explosion);
			add(gameOverText);
			add(restartText);
			FlxG.score = 1;
			player.kill();
			status.text = "Time's up! You dead!"
		}
		
		override public function update():void
		{
			if (winner) {
				if (FlxG.keys.SPACE && FlxG.keys.ESCAPE) {
					FlxG.switchState(new MenuState());
				}
			}
			if(instruct)
			{
				if(FlxG.keys.ESCAPE)
				{
					remove(instructText);
					remove(escapeText);
					gravTimer.paused = false;
					gameTimer.paused = false;
					instruct = false;
					
				}
			}
			else
			{
				this.checkPause();
				if(!FlxG.paused)
				{
					remove(pauseShade);
					remove(pauseText);
					gameTimer.paused = false;
					gravTimer.paused = false;
					countDown.text = String(Math.ceil(gameTimer.timeLeft));
					//Player movement and controls
					player.acceleration.x = 0;
					this.controls();
					
					//Updates all the objects appropriately
					super.update();
					
					//Check if player collected a document or documents this frame
					FlxG.overlap(documents,player,getDocument);
					
					//Check to see if the player touched the exit door this frame
					FlxG.overlap(exit,player,win);
					
					//Finally, bump the player up against the level
					FlxG.collide(level,player);
					
					//Check for player lose conditions
				}else {
					add(pauseShade);
					add(pauseText);
					gameTimer.paused = true;
					gravTimer.paused = true;
				}
			}
		}
		
		private function checkPause():void
		{
			if(FlxG.keys.justPressed("P"))
			{
				FlxG.paused = !FlxG.paused;
			}
		}
		
		private function controls():void
		{
			if(FlxG.keys.LEFT)
			{
				player.acceleration.x = -player.maxVelocity.x*4;
				if (player.gravityNormal)
				{
					player.facing = FlxObject.LEFT;
				}
				else
				{
					player.facing = FlxObject.RIGHT;
				}
			}
			if(FlxG.keys.RIGHT)
			{
				player.acceleration.x = player.maxVelocity.x*4;
				if (player.gravityNormal)
				{
					player.facing = FlxObject.RIGHT;
				}
				else
				{
					player.facing = FlxObject.LEFT;
				}
			}
			if(FlxG.keys.justPressed("R"))
			{
				if(gameOverText.exists)
					remove(gameOverText);
				if(restartText.exists)
					remove(restartText);
				FlxG.switchState(new LevelTwo());
			}
			if (player.isTouching(FlxObject.FLOOR) && player.acceleration.y > 0)
			{
				if (FlxG.keys.justPressed("SPACE")||FlxG.keys.justPressed("UP")) {
					player.velocity.y = -player.maxVelocity.y / 2;
					FlxG.play(JumpSound);
				}
			}
			else if (player.isTouching(FlxObject.CEILING) && player.acceleration.y < 0)
			{
				if (FlxG.keys.justPressed("SPACE") || FlxG.keys.justPressed("DOWN")) {
					player.velocity.y = player.maxVelocity.y / 2;
					FlxG.play(JumpSound);
				}
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
				exit.exists = true;
			}
		}
		
		//Called whenever the player touches the exit
		public function win(Exit:FlxSprite,Player:FlxSprite):void
		{
			winner = true;
			add(winnerText);
			add(credits);
			add(menuText);
			gameTimer.paused = true;
		}
	}
}