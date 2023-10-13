package;

import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class ScreenTransition extends FlxSubState
{
	// static public var onComplete:Void->Void;
	static public var inCamera:FlxCamera;

	private var transitionTween:FlxTween;
	private var transitionTop:FlxSprite;
	private var transitionBot:FlxSprite;

	public function new(isTransIn:Bool = false, ?onComplete:Void->Void, ?duration:Float = 0.7)
	{
		super();

		transitionTop = new FlxSprite(-10, -740);
		transitionTop.frames = Paths.getSparrowAtlas("screenTransition");
		transitionTop.animation.addByPrefix("go", "screenTransition", 24, true);
		transitionTop.animation.play("go");
		add(transitionTop);

		transitionBot = new FlxSprite(-10, 720);
		transitionBot.frames = Paths.getSparrowAtlas("screenTransition");
		transitionBot.animation.addByPrefix("go", "screenTransition", 24, true);
		transitionBot.animation.play("go");
		add(transitionBot);

		if (isTransIn)
		{
			transitionTop.y = -370;
			transitionBot.y = 350;
			FlxTween.tween(transitionBot, {y: 720}, duration, {ease: FlxEase.cubeIn});
			FlxTween.tween(transitionTop, {y: -740}, duration, {
				onComplete: function(twn:FlxTween)
				{
					if (onComplete != null)
					{
						onComplete();
					}
					close();
				},
				ease: FlxEase.cubeIn
			});
		}
		else
		{
			FlxTween.tween(transitionBot, {y: 350}, duration, {ease: FlxEase.cubeOut});
			transitionTween = FlxTween.tween(transitionTop, {y: -370}, duration, {
				onComplete: function(twn:FlxTween)
				{
					if (onComplete != null)
					{
						onComplete();
					}
				},
				ease: FlxEase.cubeOut
			});
		}

		if (inCamera != null)
		{
			transitionTop.cameras = [inCamera];
			transitionBot.cameras = [inCamera];
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	override function destroy()
	{
		inCamera = null;
		super.destroy();
	}
}
