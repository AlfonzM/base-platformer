package;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.util.FlxPoint;

class Player extends FlxSprite
{
    // Physics stuff
    private var maxSpeedX:Int = 100; // actual movespeed. change this if you want player to move faster/slower
    private var maxSpeedY:Int = 220;

    private var movespeed:Float = 5000; // used to set velocity when pressing move keys. normally 10-50 times the maxSpeedX, depending on if you want friction
    private var jumpForce:Float = 220 * 0.8; // normally 0.8 of maxSpeedY
    private var jumpHoldDuration:Float = 2; // higher amount means you can hold jump longer. normally 2-3. 1 means no variable jump

    // Jump stuff
    private var canJump:Bool;

    public function new(X:Int, Y:Int)
    {
        super(X,Y);

        makeGraphic(Reg.T_WIDTH, Reg.T_HEIGHT, 0xFFFFFFFF);

        // Physics and movement stuff
        acceleration.y = Reg.GRAVITY;
        maxVelocity.set(maxSpeedX, maxSpeedY);
        drag.x = movespeed;

        // Move stuff
        canJump = true;

        setFacingFlip(FlxObject.LEFT, true, false);
        setFacingFlip(FlxObject.RIGHT, false, false);
    }

    override public function update():Void
    {
        forDebug();
        checkIfCanJump();

        movementControls();
        jumpControls();

        super.update();
    }

    override public function destroy():Void
    {
        super.destroy();
    }

    public function forDebug():Void
    {
        // debugging stuff
    }

    public function movementControls():Void 
    {      
        if(FlxG.keys.pressed.LEFT){
            acceleration.x = -drag.x;
        } else if(FlxG.keys.pressed.RIGHT){
            acceleration.x = drag.x;
        } else {
            acceleration.x = 0;
        }
    }

    public function jumpControls():Void{
        // Jump Down
        if(isTouching(FlxObject.FLOOR) && canJumpDown() && FlxG.keys.pressed.DOWN){
            y += 5;
            canJump = false;
        }
        // Jump up
        else {
            if(FlxG.keys.pressed.Z){
                if(canJump){
                    jump();
                }
                else {
                    acceleration.y = maxSpeedY * Reg.GRAVITY/jumpHoldDuration;
                }
            } else{
                acceleration.y = maxSpeedY * Reg.GRAVITY;
            }
        }
    }

    public function jump():Void
    {
        velocity.y = -jumpForce;
        canJump = false;
    }

    public function getTileBelow(X:Float):Int{
        return PlayState.level.level.getTile(Math.round(X/Reg.T_WIDTH),Math.round(y/Reg.T_HEIGHT + 1));
    }

    public function canJumpDown():Bool{
        for(i in 31...35){
            if((getTileBelow(x-Reg.T_WIDTH) == i || getTileBelow(x) == i || getTileBelow(x+Reg.T_WIDTH) == i)){
                return true;
            }            
        }

        return false;
    }

    private function checkIfCanJump(){
        if(isTouching(FlxObject.FLOOR)){
            if(!canJump){
                canJump = true;
            }
        }
    }
}