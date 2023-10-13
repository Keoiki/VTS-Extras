package;

import BossAttacks.BossBulletScatter;
import BossAttacks.BossBulletSmall;
import BossAttacks.BossMagicWave;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.math.FlxAngle;
import flixel.math.FlxVelocity;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import haxe.Constraints.Function;

enum BossState
{
	Idle;
	Stunned;
	MovingToAttack;
	InAttack;
	InShield;
	Dead;
}

enum BossPhase
{
	FirstPhase;
	SecondPhase;
}

enum abstract MovingDirection(Int) to Int
{
	var Up = -1;
	var Down = 1;
}

enum AttackList
{
	None;
	ScatterBomb;
	MagicWave;
}

class BossEnemy extends FlxSprite
{
	static public var instance:BossEnemy;
	static public var state:BossState = Idle;
	static public var phase:BossPhase = FirstPhase;
	static public var movedir:MovingDirection = Up;

	// static public var currentAttack:AttackList = None;
	static public var previousAttack:Int;

	public var hitpoints:Float = 1000;
	public var isInvulnerable:Bool = false;
	public var isBehindPlayer:Bool = false;
	public var isPlayerBehindBoss:Bool = false;
	public var cheeseShootTimer:Float = 0;

	public var idleTillAttack:Float = 3;
	public var idleTimer:Float = 0;

	public var followPlayerY:Bool = false;

	public function new()
	{
		super();
		BossEnemy.instance = this;
		setup();
	}

	function setup()
	{
		immovable = true;
		frames = Paths.getSparrowAtlas("VioV4");
		animation.addByPrefix("idle", "BossIdle", 24, true);
		animation.play("idle");

		// 900 on Easier
		// 1000 on Regular
		// 1100 on Challenging
		// 1200 on Painful
		// nah
		// hitpoints += (100 * (Main.gameDifficulty - 1));
		if (Main.gameDifficulty == 0)
			hitpoints == 800;

		setIdleTimerLength();

		#if FLX_DEBUG
		debugBoundingBoxColor = FlxColor.CYAN;
		#end
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (PlayerPistachio.instance.getMidpoint().x > getMidpoint().x && !isBehindPlayer)
		{
			isPlayerBehindBoss = true;
		}
		else
		{
			isPlayerBehindBoss = false;
		}

		if (cheeseShootTimer > 0)
		{
			cheeseShootTimer -= elapsed;
		}

		if (state == Dead)
		{
			return;
		}
		if (state == Idle || state == InShield)
		{
			updateIdleMovement();
			idleTimer += elapsed;
			if (isPlayerBehindBoss)
			{
				shootPlayerIfBehindBossWhenNotMeantTo();
			}
			else if (idleTimer >= idleTillAttack && state != InShield && !isPlayerBehindBoss)
			{
				pickAttack();
				idleTimer = 0;
				// trace("Idle timer reached");
			}
		}

		if (followPlayerY)
		{
			y = Utils.approach(y, PlayerPistachio.instance.y - 112, 10);
			if (y + height > 750)
				y = 750 - height;
			if (y < 0)
				y = 0;
		}

		if (FlxG.overlap(this, PlayerPistachio.instance))
		{
			if (!PlayerPistachio.instance.isInvulnerable)
			{
				PlayerPistachio.instance.hurtPlayer();
			}
		}
	}

	private function updateIdleMovement()
	{
		if (followPlayerY)
			return;

		x += Math.sin(idleTimer * 4) * 0.5;
		y += movedir * FlxG.elapsed * 200;
		if (y + height > 750 || y < 0)
		{
			movedir = ((movedir == MovingDirection.Up) ? MovingDirection.Down : MovingDirection.Up);
		}

		// x position correction
		if (x + width >= 1200)
			velocity.x = -200;

		velocity.x = Utils.approach(velocity.x, 0, 5);
	}

	public function setState(toState:BossState)
	{
		BossEnemy.state = toState;
	}

	private function setIdleTimerLength()
	{
		// How many seconds to idle before attacking (seconds)
		switch (Main.gameDifficulty)
		{
			case Challenging:
				idleTillAttack = 2.45;
			case Painful:
				idleTillAttack = 1.85;
			default:
				idleTillAttack = 3;
		}
	}

	private function getAttackSpeedMultiplier():Float
	{
		switch (Main.gameDifficulty)
		{
			case Challenging:
				return 0.85;
			case Painful:
				return 0.675;
			default:
				return 1;
		}
	}

	private function shootPlayerIfBehindBossWhenNotMeantTo()
	{
		if (cheeseShootTimer > 0)
			return;

		var bullet:BossBulletSmall = new BossBulletSmall(getMidpoint().x, getMidpoint().y);
		FlxVelocity.accelerateFromAngle(bullet, FlxAngle.angleBetweenPoint(bullet, PlayerPistachio.instance.getMidpoint()), 50e3, 1000);
		bullet.angle = FlxAngle.angleBetweenPoint(bullet, PlayerPistachio.instance.getMidpoint(), true);
		BossfightState.instance.add(bullet);
		cheeseShootTimer = 0.075;
	}

	private function pickAttack()
	{
		var randomNum:Int = FlxG.random.int(1, 2);
		switch (randomNum)
		{
			case 1:
				scatterBullet();
			case 2:
				magicWave();
		}
		previousAttack = randomNum;
	}

	private function scatterBullet()
	{
		setState(InAttack);
		var timerMult:Float = getAttackSpeedMultiplier();
		new FlxTimer().start(0.7 * timerMult, function(tmr:FlxTimer)
		{
			if (Main.gameDifficulty != Painful)
			{
				var scatter:BossBulletScatter = new BossBulletScatter(getMidpoint().x, getMidpoint().y);
				BossfightState.instance.add(scatter);
			}
			else
			{
				var scatter1:BossBulletScatter = new BossBulletScatter(getMidpoint().x, getMidpoint().y);
				scatter1.velocity.y = (FlxG.random.float(-400, -200));
				BossfightState.instance.add(scatter1);

				var scatter2:BossBulletScatter = new BossBulletScatter(getMidpoint().x, getMidpoint().y);
				scatter2.velocity.y = (FlxG.random.float(200, 400));
				BossfightState.instance.add(scatter2);
			}
		});
		new FlxTimer().start(1 * timerMult, function(tmr:FlxTimer)
		{
			setState(Idle);
		});
	}

	private function magicWave()
	{
		setState(InAttack);
		followPlayerY = true;
		var timerMult:Float = getAttackSpeedMultiplier();
		new FlxTimer().start(1 * timerMult, function(tmr:FlxTimer)
		{
			var wave:BossMagicWave = new BossMagicWave(getMidpoint().x, getMidpoint().y);
			BossfightState.instance.add(wave);
			followPlayerY = false;
		});
		new FlxTimer().start(1.3 * timerMult, function(tmr:FlxTimer)
		{
			setState(Idle);
		});
	}

	// 40% health
	private function activateSecondPhase()
	{
		phase = SecondPhase;
		setState(InShield);
		// Play second phase music
	}
}
