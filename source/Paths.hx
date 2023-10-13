package;

import flixel.graphics.frames.FlxAtlasFrames;

@:build(flixel.system.FlxAssets.buildFileReferences("assets", true))
class Paths
{
	inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;

	inline static public function image(key:String)
	{
		return 'assets/images/$key.png';
	}

	inline static public function intro(song:String)
	{
		return 'assets/music/$song-intro.$SOUND_EXT';
	}

	inline static public function loop(song:String)
	{
		return 'assets/music/$song-loop.$SOUND_EXT';
	}

	inline static public function file(file:String)
	{
		return 'assets/$file';
	}

	inline static public function locale(language:String)
	{
		return 'assets/locale/$language.json';
	}

	inline static public function getSparrowAtlas(key:String)
	{
		return FlxAtlasFrames.fromSparrow(image(key), file('images/$key.xml'));
	}
}
