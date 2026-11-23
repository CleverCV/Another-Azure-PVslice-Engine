
package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;

class MainMenuState extends FlxState
{
    private var bg:FlxSprite;

    public function new()
    {
        super();
    }

    override public function create():Void
    {
        super.create();

        bg = new FlxSprite();

        bg.loadGraphic("assets/shared/images/mainmenu/menuBG.png");
        bg.setGraphicSize(FlxG.width, FlxG.height);
        bg.updateHitbox();
        bg.screenCenter();

        add(bg);
    }
}
