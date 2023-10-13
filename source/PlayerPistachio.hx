package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.math.FlxAngle;
import flixel.math.FlxVelocity;
import flixel.util.FlxColor;

class PlayerPistachio extends FlxSprite
{
	static public var instance:PlayerPistachio;

	public var hitpoints(default, null):Float = 10;
	public var isInvulnerable(default, null):Bool = false;
	public var attackCooldown(default, null):Float = 0;

	public function new()
	{
		super();

		setup();

		maxVelocity.set(450, 450);
	}

	function setup()
	{
		PlayerPistachio.instance = this;
		immovable = true;
		frames = Paths.getSparrowAtlas("Pistachio");
		animation.addByPrefix("idle", "PistachioIdle", 24, true);
		animation.play("idle");

		switch (Main.gameDifficulty)
		{
			case Challenging:
				hitpoints = 8;
			case Painful:
				hitpoints = 6;
			default:
				hitpoints = 10;
		}

		setSize(70, 50);
		offset.set(25, 25);

		#if FLX_DEBUG
		debugBoundingBoxColor = FlxColor.CYAN;
		#end
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (attackCooldown > 0)
		{
			attackCooldown -= elapsed;
		}
		checkForAttack();
		updateMovement();
	}

	private function updateMovement()
	{
		var movementX:Int = ((FlxG.keys.anyPressed([RIGHT, D]) ? 1 : 0) - (FlxG.keys.anyPressed([LEFT, A]) ? 1 : 0));
		var movementY:Int = ((FlxG.keys.anyPressed([DOWN, S]) ? 1 : 0) - (FlxG.keys.anyPressed([UP, W]) ? 1 : 0));

		acceleration.x = 1600 * movementX;
		acceleration.y = 1600 * movementY;

		// Slow down because acceleration at 0 does literally nothing
		if (movementX == 0)
			velocity.x = Utils.approach(velocity.x, 0, 30);
		if (movementY == 0)
			velocity.y = Utils.approach(velocity.y, 0, 30);

		// Make sure the player doesn't escape the boundaries of the screen (more or less)
		if (x < BossfightState.instance.camMain.minScrollX)
			x = BossfightState.instance.camMain.minScrollX;
		if (x + width > BossfightState.instance.camMain.maxScrollX)
			x = BossfightState.instance.camMain.maxScrollX - width;
		if (y < BossfightState.instance.camMain.minScrollY)
			y = BossfightState.instance.camMain.minScrollY;
		if (y + height > BossfightState.instance.camMain.maxScrollY)
			y = BossfightState.instance.camMain.maxScrollY - height;
	}

	private function checkForAttack()
	{
		if (attackCooldown > 0)
		{
			return;
		}
		else
		{
			if (FlxG.mouse.pressed && FlxG.mouse.pressedRight) // Fires three projectiles, each at a 3/4 of their max speed
			{
				for (i in 0...3)
				{
					var projc:PlayerProjectile = new PlayerProjectile();
					projc.setPosition(x + 20, y + 50);
					FlxVelocity.accelerateFromAngle(projc, FlxAngle.angleBetweenMouse(projc) - (FlxAngle.asRadians(10 - (10 * i))), 50e3, 650);
					projc.angle = FlxAngle.angleBetweenMouse(projc, true) - (10 - (10 * i));
					projc.damage = 1.5;
					projc.scale.set(1.5, 1.5);
					BossfightState.instance.add(projc);
					attackCooldown = 0.60;
				}
			}
			else if (FlxG.mouse.pressed) // Fires one projectile at max speed
			{
				var projc:PlayerProjectile = new PlayerProjectile();
				projc.setPosition(x + 20, y + 50);
				FlxVelocity.accelerateFromAngle(projc, FlxAngle.angleBetweenMouse(projc), 50e3, 1200);
				projc.angle = FlxAngle.angleBetweenMouse(projc, true);
				BossfightState.instance.add(projc);
				attackCooldown = 0.25;
			}
			else if (FlxG.mouse.pressedRight) {}
		}
	}

	public function hurtPlayer(?damage:Int = 1)
	{
		hitpoints -= damage;
		isInvulnerable = true;
		BossfightState.instance.camMain.shake(0.005, 0.15);
		if (Main.gameDifficulty == Painful)
		{
			FlxFlicker.flicker(this, 1.45, 0.05, true, true, function(flk:FlxFlicker)
			{
				isInvulnerable = false;
			});
		}
		else
		{
			FlxFlicker.flicker(this, 2, 0.05, true, true, function(flk:FlxFlicker)
			{
				isInvulnerable = false;
			});
		}
		trace('Damage taken, health left: $hitpoints');
	}
}
