package;

class Utils
{
	public static function approach(from:Float, to:Float, byAmount:Float):Float
	{
		if (from < to)
		{
			from += byAmount;
			if (from > to)
				return to;
		}
		else
		{
			from -= byAmount;
			if (from < to)
				return to;
		}
		return from;
	}

	inline public static function clamp(value:Float, min:Float, max:Float):Float
	{
		return Math.max(min, Math.min(max, value));
	}
}
