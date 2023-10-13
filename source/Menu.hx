package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.input.mouse.FlxMouseEvent;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class Menu extends FlxState
{
	static public var minigameName:FlxText;
	static public var minigameDescription:FlxText;

	override function create()
	{
		super.create();

		var cursorSprite:FlxSprite = new FlxSprite().loadGraphic(Paths.image('cursor'));
		FlxG.mouse.load(cursorSprite.pixels, 1, -15, 0);

		var background:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('MenuBackground'));
		background.alpha = 0.33;
		add(background);

		var logo:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('ExtrasLogo'));
		logo.scale.set(0.75, 0.75);
		logo.updateHitbox();
		logo.setPosition((FlxG.width / 2 - logo.width) / 2, 24);
		// logo.screenCenter(X);
		add(logo);

		minigameName = new FlxText(640, 480, FlxG.width / 2, '', 36);
		minigameName.setFormat(null, 36, FlxColor.WHITE, CENTER);
		add(minigameName);

		minigameDescription = new FlxText(640, 560, FlxG.width / 2, '', 20);
		minigameDescription.setFormat(null, 20, FlxColor.WHITE, CENTER);
		add(minigameDescription);

		var bossIcon:MenuItem = new MenuItem(750, 280, 'VioV4', 'Space Ambush',
			'After Pistachio has had her day out,\nshe begins her return home.\nHowever it seems Violastro has one more trick up his sleeve.\n(...Does he even have one?)',
			true, () ->
			{
				openSubState(new ScreenTransition(false, () ->
				{
					FlxG.switchState(new BossfightState());
				}));
			});
		add(bossIcon);

		var quizIcon:MenuItem = new MenuItem(1000, 280, 'VioV2', 'Quiz Time',
			'Deep below Sparklestone Shores, one of\nViolastro\'s old inventions awakens.\nRather quickly a quiz show is setup,\nwith Azura as the contestant.\nShe may not like the prize however..',
			false);
		add(quizIcon);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		// if (FlxG.keys.justPressed.ONE)
		// {
		// openSubState(new ScreenTransition(false, () ->
		// {
		// FlxG.switchState(new BossfightState());
		// }));
		// }
	}
}

class DifficultySelect extends FlxSubState
{
	override function create()
	{
		super.create();

		var background:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
		background.alpha = 0.33;
		add(background);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE)
		{
			close();
		}
	}
}

class MenuItem extends FlxSprite
{
	public var onPress:Void->Void;
	public var name:String;
	public var subtitle:String;
	public var _active:Bool;

	public function new(x:Float, y:Float, icon:String, name:String, subtitle:String, active:Bool = false, ?onPress:Void->Void)
	{
		super(x, y);

		this.name = name;
		this.subtitle = subtitle;
		this.onPress = onPress;
		_active = active;

		loadGraphic(Paths.image('Icon$icon'));

		if (!_active)
			alpha = 0.25;

		FlxMouseEvent.add(this, onItemActive, null, onHoverItem, onLeaveItem);
	}

	function onItemActive(icon:FlxSprite)
	{
		if (!_active)
			return;

		if (onPress != null)
		{
			onPress();
		}
	}

	function onHoverItem(icon:FlxSprite)
	{
		if (!_active)
			return;

		Menu.minigameName.text = name;
		Menu.minigameDescription.text = subtitle;

		color = 0xFFA3A3FF;
	}

	function onLeaveItem(icon:FlxSprite)
	{
		if (!_active)
			return;

		color = 0xFFFFFFFF;
	}

	override function destroy()
	{
		onPress = null;
		FlxMouseEvent.remove(this);
	}
}
