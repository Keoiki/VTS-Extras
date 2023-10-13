package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.math.FlxRect;
import flixel.ui.FlxBar;
import flixel.util.FlxTimer;

class BossfightState extends FlxState
{
	public var boss:BossEnemy;
	public var player:PlayerPistachio;
	public var armtop:ArmEnemy;
	public var armbot:ArmEnemy;

	static public var projectileAreaLimit:FlxRect;
	static public var instance:BossfightState;

	public var camMain:FlxCamera;
	public var camHUD:FlxCamera;

	public static var healthbarBoss:FlxBar;
	public static var healthbarBossBor:FlxSprite;

	override public function create()
	{
		projectileAreaLimit = new FlxRect(-100, -100, FlxG.width + 200, FlxG.height + 200);

		BossfightState.instance = this;

		camMain = new FlxCamera();
		camHUD = new FlxCamera();
		FlxG.cameras.reset(camMain);
		FlxG.cameras.add(camHUD);
		camHUD.bgColor.alpha = 0;
		FlxCamera.defaultCameras = [camMain];

		camMain.zoom = 0.95;
		camMain.setScrollBounds(-50, 1280, -40, 720);

		initializeBackground();

		// var movementArea:FlxSprite = new FlxSprite(projectileAreaLimit.x,
		// projectileAreaLimit.y).makeGraphic(Std.int(projectileAreaLimit.width), Std.int(projectileAreaLimit.height), 0xFFFF0000);
		// movementArea.alpha = 0.15;
		// add(movementArea);

		boss = new BossEnemy();
		add(boss);
		boss.setPosition(920, 200);

		player = new PlayerPistachio();
		add(player);
		player.setPosition(100, 300);

		// armtop = new ArmEnemy(1120, 0);
		// add(armtop);

		// armbot = new ArmEnemy(1120, 620);
		// add(armbot);

		healthbarBoss = new FlxBar(440, 77, LEFT_TO_RIGHT, 400, 25, boss, "hitpoints", 0, boss.hitpoints);
		healthbarBoss.numDivisions = Std.int(boss.hitpoints);
		healthbarBoss.createFilledBar(0xFF292929, 0xFFF5138F);
		healthbarBoss.cameras = [camHUD];

		healthbarBossBor = new FlxSprite(0, 30).loadGraphic(Paths.image("BossHPBar"));
		healthbarBossBor.cameras = [camHUD];
		healthbarBossBor.screenCenter(X);

		ScreenTransition.inCamera = camHUD;
		openSubState(new ScreenTransition(true, () ->
		{
			startMusic();
		}));

		trace("Hello!");

		/*
			if (armtop.exists)
			{
				new FlxTimer().start(1.25, function(tmr:FlxTimer)
				{
					armtop.shootOneBullet(0.75);
				}, 0);
			}

			if (armbot.exists)
			{
				new FlxTimer().start(1.25, function(tmr:FlxTimer)
				{
					armbot.shootOneBullet(0.75);
				}, 0);
			}
		 */

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	private function startMusic()
	{
		FlxG.sound.playMusic(Paths.loop('the-end'), 0, true);
		FlxG.sound.music.fadeIn(1, 0, 1);

		add(healthbarBoss);
		add(healthbarBossBor);
	}

	private function initializeBackground()
	{
		var space:FlxSprite = new FlxSprite(-50, -50).loadGraphic(Paths.image("Space"));
		add(space);

		var home:FlxSprite = new FlxSprite(-25, 0).loadGraphic(Paths.image("Planet"));
		home.scale.set(0.55, 0.55);
		home.updateHitbox();
		home.screenCenter(X);
		home.y = 100;
		add(home);

		#if !FLX_DEBUG
		var mountains:FlxBackdrop = new FlxBackdrop(Paths.image("Mountains"), X);
		mountains.y = 136;
		mountains.velocity.x = -200;
		add(mountains);

		var buildings:FlxBackdrop = new FlxBackdrop(Paths.image("Buildings"), X, 3840);
		buildings.y = 209;
		buildings.velocity.x = -465;
		add(buildings);

		var surface:FlxBackdrop = new FlxBackdrop(Paths.image("Surface"), X);
		surface.y = 423;
		surface.velocity.x = -920;
		add(surface);
		#end
	}
}
