package
{
	import org.flixel.*;

	public class PlayState extends FlxState
	{
		public var level:FlxTilemap;
		public var exit:FlxSprite;
		public var documents:FlxGroup;
		public var player:FlxSprite;
		public var score:FlxText;
		public var status:FlxText;
		public var countDown:FlxText;
		public var timer:FlxTimer;
		public var gameTimer:FlxTimer;
		private var flipTime:Number = 5;
		
		override public function create():void
		{
			timer = new FlxTimer();
			timer.start((flipTime + 5 * (FlxG.random())), 1, gravityFlip);
			gameTimer = new FlxTimer();
			gameTimer.start(10, 1, killPlayer);
			//Set the background color to light gray (0xAARRGGBB)
			FlxG.bgColor = 0xffaaaaaa;
			
			//Design your platformer level with 1s and 0s (at 40x30 to fill 320x240 screen)
			var data:Array = new Array(
				1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
				1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				1, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1,
				1, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1,
				1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1,
				1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1,
				1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1,
				1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1,
				1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1,
				1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1,
				1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1,
				1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1,
				1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 1,
				1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
				1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
				1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 1,
				1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1,
				1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 );
			
			//Create a new tilemap using our level data
			level = new FlxTilemap();
			level.loadMap(FlxTilemap.arrayToCSV(data,40),FlxTilemap.ImgAuto,0,0,FlxTilemap.AUTO);
			add(level);
			
			//Create the level exit, a dark gray box that is hidden at first
			exit = new FlxSprite(35*8+1,25*8);
			exit.makeGraphic(14,16,0xff3f3f3f);
			exit.exists = false;
			add(exit);
			
			//Create documents to collect (see createDocument() function below for more info)
			documents = new FlxGroup();
			//Top left documents
			createDocument(18,4);
			createDocument(12,4);
			createDocument(9,4);
			createDocument(8,11);
			createDocument(1,7);
			createDocument(3,4);
			createDocument(5,2);
			createDocument(15,11);
			createDocument(16,11);
			
			//Bottom left documents
			createDocument(3,16);
			createDocument(4,16);
			createDocument(1,23);
			createDocument(2,23);
			createDocument(3,23);
			createDocument(4,23);
			createDocument(5,23);
			createDocument(12,26);
			createDocument(13,26);
			createDocument(17,20);
			createDocument(18,20);
			
			//Top right documents
			createDocument(21,4);
			createDocument(26,2);
			createDocument(29,2);
			createDocument(31,5);
			createDocument(34,5);
			createDocument(36,8);
			createDocument(33,11);
			createDocument(31,11);
			createDocument(29,11);
			createDocument(27,11);
			createDocument(25,11);
			createDocument(36,14);
			
			//Bottom right documents
			createDocument(38,17);
			createDocument(33,17);
			createDocument(28,19);
			createDocument(25,20);
			createDocument(18,26);
			createDocument(22,26);
			createDocument(26,26);
			createDocument(30,26);

			add(documents);
			
			//Create player (a red box)
			player = new FlxSprite(FlxG.width/2 - 5);
			player.makeGraphic(10,12,0xff7FFF00);
			player.maxVelocity.x = 80;
			player.maxVelocity.y = 200;
			player.acceleration.y = 200;
			player.drag.x = player.maxVelocity.x*4;
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
		}
		
		//creates a new document located on the specified tile
		public function createDocument(X:uint,Y:uint):void
		{
			var document:FlxSprite = new FlxSprite(X*8+3,Y*8+2);
			document.makeGraphic(2,4,0xffffffff);
			documents.add(document);
		}
		
		private function gravityFlip(timer:FlxTimer):void
		{		
			player.acceleration.y = -player.acceleration.y;
			timer.start(flipTime+5*(FlxG.random()), 1, gravityFlip);
		}
		
		private function killPlayer(gameTimer:FlxTimer):void
		{
			FlxG.score = 1;
			player.kill();
			status.text = "Time's up! You dead!"
		}
		
		override public function update():void
		{
			countDown.text = String(Math.ceil(gameTimer.timeLeft));
			//Player movement and controls
			player.acceleration.x = 0;
			if(FlxG.keys.LEFT)
				player.acceleration.x = -player.maxVelocity.x*4;
			if(FlxG.keys.RIGHT)
				player.acceleration.x = player.maxVelocity.x*4;
			if (FlxG.keys.justPressed("SPACE"))
				if (player.isTouching(FlxObject.FLOOR) && player.acceleration.y > 0)
				{
					player.velocity.y = -player.maxVelocity.y / 2;
				}
				else if (player.isTouching(FlxObject.CEILING) && player.acceleration.y < 0)
				{
					player.velocity.y = player.maxVelocity.y / 2;
				}
			//if(FlxG.keys.justPressed("DOWN"))
			//	player.acceleration.y = -player.acceleration.y;
				
			
			//Updates all the objects appropriately
			super.update();

			//Check if player collected a document or documents this frame
			FlxG.overlap(documents,player,getDocument);
			
			//Check to see if the player touched the exit door this frame
			FlxG.overlap(exit,player,win);
			
			//Finally, bump the player up against the level
			FlxG.collide(level,player);
			
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
			Document.kill();
			score.text = "SCORE: "+(documents.countDead()*100);
			if(documents.countLiving() == 0)
			{
				status.text = "Escape the ship!";
				exit.exists = true;
			}
		}
		
		//Called whenever the player touches the exit
		public function win(Exit:FlxSprite,Player:FlxSprite):void
		{
			status.text = "Yay, you won!";
			score.text = "SCORE: 5000";
			Player.kill();
		}
	}
}
