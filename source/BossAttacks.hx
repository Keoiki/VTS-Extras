package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxAngle;
import flixel.math.FlxVelocity;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class BossBulletSmall extends FlxSprite
{
	public function new(x:Float, y:Float)
	{
		super(x, y);
		setup();
	}

	function setup()
	{
		loadGraphic(Paths.image("BossBulletSmall"));
		setSize(15, 15);
		offset.set(13, 1);

		#if FLX_DEBUG
		debugBoundingBoxColor = FlxColor.RED;
		#end
	}

	override public function update(elp:Float)
	{
		super.update(elp);

		if (!BossfightState.projectileAreaLimit.containsPoint(getMidpoint()))
		{
			destroy();
		}

		if (FlxG.collide(this, PlayerPistachio.instance))
		{
			if (!PlayerPistachio.instance.isInvulnerable)
			{
				PlayerPistachio.instance.hurtPlayer();
			}
			destroy();
		}
	}
}

class BossBulletScatter extends FlxSprite
{
	var exploding:Bool = false;
	var bulletCount:Int = 8;

	public function new(x:Float, y:Float)
	{
		super(x, y);
		setup();
	}

	function setup()
	{
		frames = Paths.getSparrowAtlas("BossBulletScatter");
		animation.addByPrefix("idle", "BossBulletScatter0", 24, true);
		animation.addByPrefix("explosion", "BossBulletScatterExplosion", 24, false);
		animation.play("idle");

		setSize(50, 50);
		offset.set(14, 10);

		velocity.set(FlxG.random.int(-500, -300), 0);

		switch (Main.gameDifficulty)
		{
			case Easier:
				bulletCount = 6;
			case Challenging:
				bulletCount = 12;
			case Painful:
				bulletCount = 16; // Has two of these
			default:
				bulletCount = 8;
		}

		for (i in 0...bulletCount)
		{
			if (i > bulletCount / 2 - 1)
				continue;
			var indicator:AttackIndicator = new AttackIndicator(x, y, this);
			indicator.angle = 360 / bulletCount * i;
			BossfightState.instance.add(indicator);
		}

		#if FLX_DEBUG
		debugBoundingBoxColor = FlxColor.RED;
		#end
	}

	override public function update(elp:Float)
	{
		super.update(elp);

		var approachSpeed:Float = 5;
		if (Main.gameDifficulty == Painful)
			approachSpeed = 10;

		velocity.x = Utils.approach(velocity.x, 0, approachSpeed);
		velocity.y = Utils.approach(velocity.y, 0, approachSpeed);

		if (((velocity.x == 0 && velocity.y == 0) || (!BossfightState.projectileAreaLimit.containsPoint(getMidpoint()))) && !exploding)
		{
			exploding = true;
			animation.play("explosion");
			offset.set(20, 20);
			var bulletMaxVelocity:Float;
			switch (Main.gameDifficulty)
			{
				case Easier:
					bulletMaxVelocity = 600;
				case Painful:
					bulletMaxVelocity = 1200;
				default:
					bulletMaxVelocity = 800;
			}
			for (i in 0...bulletCount)
			{
				var bullet = new BossBulletSmall(x + 15, y + 20);
				BossfightState.instance.add(bullet);
				FlxVelocity.accelerateFromAngle(bullet, FlxAngle.asRadians(360 / bulletCount * i), 50e3, bulletMaxVelocity);
				bullet.angle = 360 / bulletCount * i;
			}
		}

		if (animation.curAnim.name == "explosion" && animation.curAnim.finished)
			destroy();

		if (FlxG.collide(this, PlayerPistachio.instance))
		{
			if (!PlayerPistachio.instance.isInvulnerable)
			{
				PlayerPistachio.instance.hurtPlayer();
			}
		}
	}
}

class BossMagicWave extends FlxSprite
{
	public function new(x:Float, y:Float)
	{
		super(x, y);
		setup();
	}

	function setup()
	{
		immovable = true;
		frames = Paths.getSparrowAtlas("BossMagicWave");
		animation.addByPrefix("idle", "BossMagicWave", 24, true);
		animation.play("idle");

		x -= width / 2;
		y -= height / 2;

		velocity.x = 300;

		FlxTween.tween(this, {"scale.y": 0.1, "scale.x": 0.5}, 0.5, {type: BACKWARD, ease: FlxEase.backOut});

		setSize(150, 250);
		offset.set(40, 38);

		#if FLX_DEBUG
		debugBoundingBoxColor = FlxColor.RED;
		#end
	}

	override public function update(elp:Float)
	{
		super.update(elp);

		velocity.x = Utils.approach(velocity.x, -1500, 10 + (10 * (Main.gameDifficulty)));

		if (x <= -1000)
		{
			destroy();
		}

		if (FlxG.overlap(this, PlayerPistachio.instance))
		{
			if (!PlayerPistachio.instance.isInvulnerable)
			{
				PlayerPistachio.instance.hurtPlayer();
			}
		}
	}
}

class AttackIndicator extends FlxSprite
{
	public var parent:FlxObject;
	public var parentDestroyed:Bool = false;
	public var followParentRotation:Bool = false;

	public function new(x:Float, y:Float, parent:FlxObject, ?followParentRotation:Bool = false)
	{
		super(x, y);
		this.parent = parent;
		this.followParentRotation = followParentRotation;
		setup();
	}

	private function setup()
	{
		makeGraphic(3000, 4, 0xFFABFF6C);
		alpha = 0;
		FlxTween.tween(this, {alpha: 0.25}, 1);

		#if FLX_DEBUG
		debugBoundingBoxColor = FlxColor.YELLOW;
		#end
	}

	override function update(elapsed:Float)
	{
		if (!parent.exists)
		{
			destroyThis();
			parentDestroyed = true;
		}

		if (!parentDestroyed)
		{
			x = parent.x + parent.width / 2 - width / 2;
			y = parent.y + parent.height / 2 - height;
			if (followParentRotation)
				angle = parent.angle;
		}

		super.update(elapsed);
	}

	public function spawnAndDestroyLater(?timeToKeepAlive:Float = 1.0)
	{
		new FlxTimer().start(timeToKeepAlive, function(tmr:FlxTimer)
		{
			destroyThis();
			parentDestroyed = true;
		});
	}

	private function destroyThis()
	{
		if (parentDestroyed)
			return;

		FlxTween.tween(this, {alpha: 0}, 0.25, {
			onComplete: function(twn:FlxTween)
			{
				destroy();
			}
		});
	}
}
