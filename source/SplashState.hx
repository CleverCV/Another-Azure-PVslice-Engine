
package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.util.FlxTimer;

class SplashState extends FlxState
{
    private var splashTimer:FlxTimer;

    override public function create():Void
    {
        super.create();

        var splash:FlxSprite = new FlxSprite();

        splash.loadGraphic("assets/shared/images/app/launch.png");
        splash.screenCenter();

        add(splash);

        splashTimer = new FlxTimer();

        splashTimer.start(3, function(timer:FlxTimer):Void
        {
            FlxG.switchState(() -> new states.TitleState());
        });
    }

    override public function destroy():Void
    {
        if (splashTimer != null)
        {
            splashTimer.cancel();
            splashTimer.destroy();
            splashTimer = null;
        }

        super.destroy();
    }
}
