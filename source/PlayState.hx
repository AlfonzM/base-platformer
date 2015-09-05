package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxCamera;
import flixel.group.FlxGroup;

class PlayState extends FlxState
{
	public var player:Player;
	public static var level:Level;
	
	private var levelCollidable:FlxGroup;

	override public function create():Void
	{
		super.create();

		setupPlayer();
		setupCamera();
		setupLevel();

		levelCollidable = new FlxGroup();
		levelCollidable.add(player);

		add(player);
		add(level.level);

		FlxG.mouse.visible = false;
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{
		forDebug();

		super.update();
		collisionUpdate();
	}	

	private function forDebug(){
		if(FlxG.keys.pressed.R){
			FlxG.resetState();
		}
	}

	private function collisionUpdate():Void
	{
		FlxG.collide(levelCollidable, level.level);
	}

	/**
	 *	SETUP FUNCTIONS
	 */

	public function setupPlayer():Void
	{
		player = new Player(0,0);
	}

	public function setupLevel():Void
	{
		level = new Level(player);
		FlxG.worldBounds.width = (level.level.widthInTiles + 1) * Reg.T_WIDTH;
		FlxG.worldBounds.height = (level.level.heightInTiles + 1) * Reg.T_HEIGHT;
	}

	public function setupCamera():Void
	{
		FlxG.camera.follow(player, FlxCamera.STYLE_LOCKON, 10);
	}
}