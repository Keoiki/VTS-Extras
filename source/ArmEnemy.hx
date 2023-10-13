package;

import BossAttacks;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxAngle;
import flixel.math.FlxVelocity;
import flixel.util.FlxTimer;

class ArmEnemy extends FlxSprite
{
	public var rotateToPlayer:Bool = true;

	public function new(x:Float, y:Float)
	{
		super(x, y);
		setup();
	}

	function setup()
	{
		immovable = true;
		frames = Paths.getSparrowAtlas("ArmEnemy");
		animation.addByPrefix("idle", "BossHandSeparate", 24, true);
		animation.play("idle");
		// flipX = true;
		setSize(80, 50);
		offset.set(30, 10);

		#if FLX_DEBUG
		debugBoundingBoxColor = FlxColor.CYAN;
		#end
	}

	override public function update(elp:Float)
	{
		super.update(elp);

		if (rotateToPlayer)
		{
			this.angle = FlxAngle.angleBetweenPoint(this, PlayerPistachio.instance.getGraphicMidpoint(), true);
		}

		if (this.angle > 90 || this.angle < -90)
		{
			flipY = true;
		}
		else
		{
			flipY = false;
		}

		if (FlxG.collide(this, PlayerPistachio.instance))
		{
			if (!PlayerPistachio.instance.isInvulnerable)
			{
				PlayerPistachio.instance.hurtPlayer();
			}
		}
	}

	public function shootOneBullet(?shootWaitTime:Float = 1.5)
	{
		var indicator:AttackIndicator = new AttackIndicator(x, y, this, true);
		indicator.angle = this.angle;
		BossfightState.instance.add(indicator);
		indicator.spawnAndDestroyLater(shootWaitTime);

		new FlxTimer().start(shootWaitTime, function(tmr:FlxTimer)
		{
			var bullet = new BossBulletSmall(x + 15, y + 20);
			BossfightState.instance.add(bullet);
			FlxVelocity.accelerateFromAngle(bullet, FlxAngle.asRadians(this.angle), 50e3, 1000);
			bullet.angle = this.angle;
		});
	}
}
