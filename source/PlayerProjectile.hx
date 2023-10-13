package;

import flixel.FlxG;
import flixel.FlxSprite;

class PlayerProjectile extends FlxSprite
{
	public var damage:Float = 2;

	public function new()
	{
		super();
		setup();
	}

	function setup()
	{
		frames = Paths.getSparrowAtlas("PlayerProjectile");
		animation.addByPrefix("idle", "StarProjectile", 24, true);
		animation.play("idle");
	}

	override public function update(elp:Float)
	{
		super.update(elp);

		if (!BossfightState.projectileAreaLimit.containsPoint(getMidpoint()))
		{
			destroy();
		}

		if (FlxG.collide(this, BossEnemy.instance))
		{
			if (!BossEnemy.instance.isInvulnerable)
			{
				BossEnemy.instance.hitpoints -= damage;
			}
			destroy();
		}
	}
}
