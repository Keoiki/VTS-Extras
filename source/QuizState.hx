package;

import flixel.FlxState;

class QuizState extends FlxState
{
	// Question, Answers, Correct Answer
	private var questions:Array<Dynamic> = [
		[
			"Which of these characters is green?",
			["Cardinal", "Pistachio", "Banana"],
			"Pistachio"
		],
		[
			"When was Vibrant Venture released on Steam?",
			["18th of March, 2019", "24th of July, 2020", "31st of August, 2021"],
			"24th of July, 2020"
		],
		[
			"What was this minigame called?",
			["Quiz Time", "Vio-V2.0's Big Dumb Quiz", "Space Ambush"],
			"Quiz Time"
		],
		[
			"Who is the boss of Sparklestone Shores?",
			["Violastro", "Adult Pokeprey", "ViolastroBot"],
			"ViolastroBot"
		],
		[
			"In which level does the player fight The Conductor?",
			["4-3", "3-2", "1-1"],
			"3-2"
		],
		["What is Pistachio's sister's name?", ["Olive", "Scarlet", "Mocha"], "Olive"],
		["What's the moon's name?", ["Stygian", "Violand", "Lunaria"], "Lunaria"],
		[
			"What operating system does your laptop run on?",
			["AstralOS", "VibrantOS", "Vio-OS"],
			"VibrantOS"
		],
		[
			"What did Violastro trap you in during 1-4?",
			["Cube", "Ball", "Pyramid"],
			"Ball"
		],
		["What does Scarlet love doing?", ["Cooking", "Sleeping", "Reading"], "Reading"],
		["How many upgrades are available in Hickory's shop?", ["7", "9", "12"], "9"],
		["How many Power Crystals are there?", ["5", "7", "8"], "5"],
		["Is the clocktower in Cornucopia Town haunted?", ["Yes", "No", "Maybe?"], "Yes"],
		["???", ["???", "???", "??"], "???"],
		["", ["", "", ""], ""],
		["", ["", "", ""], ""],
		["", ["", "", ""], ""]
	];
}
