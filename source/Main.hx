package;

import flixel.FlxGame;
import flixel.FlxSprite;
import openfl.display.Sprite;

enum abstract Difficulty(Int) to Int
{
	var Easier = 0;
	var Regular = 1;
	var Challenging = 2;
	var Painful = 3;
}

class Main extends Sprite
{
	static public var gameDifficulty:Difficulty = Regular;
	static public var skipIntro:Bool = false;
	static public var showHealthNumber:Bool = true;

	public function new()
	{
		super();
		FlxSprite.defaultAntialiasing = true;
		addChild(new FlxGame(0, 0, Menu, 60, 60, true));
	}
}
