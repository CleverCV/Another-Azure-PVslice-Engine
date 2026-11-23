// DONT USE THIS FILE IS NOT FOR RELEASE IS ONLY A TEST OF ALPHABET UTILITY, PLEASE USE TitleState.hx INSTEAD
package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.util.FlxTimer;
import utils.Alphabet;

class IntroState extends FlxState
{
    private var introText:Alphabet;
    private var messageTimer:FlxTimer;

    private var messages:Array<String> = [
        "AZURESLMX PRESENTA",
        "UN ENGINE TODO FEO HECHO PARA FNF",
        "BYE BYE DISFRUTEN"
    ];

    private var messageIndex:Int = 0;

    override public function create():Void
    {
        super.create();

        trace("INTRO: CREATE");

        FlxG.camera.bgColor = 0xFF000000;

        trace("INTRO: CREATING ALPHABET");

        introText = new Alphabet(0, 0, "", true, 0.8);
        add(introText);

        trace("INTRO: ALPHABET CREATED");

        showMessage(messages[messageIndex]);

        trace("INTRO: MESSAGE SHOWN");

        startMessageTimer();
    }

    private function startMessageTimer():Void
    {
        messageTimer = new FlxTimer();

        messageTimer.start(3, function(timer:FlxTimer):Void
        {
            trace("INTRO: TIMER FIRED");

            messageIndex++;

            if (messageIndex < messages.length)
            {
                showMessage(messages[messageIndex]);
                startMessageTimer();
            }
            else
            {
                trace("INTRO: SWITCHING TO MENU");
                FlxG.switchState(() -> new states.MainMenuState());
            }
        });
    }

    private function showMessage(message:String):Void
    {
        trace("INTRO: SETTING TEXT: " + message);

        introText.setText(message);

        introText.x = (FlxG.width - introText.textWidth) / 2;
        introText.y = (FlxG.height - introText.textHeight) / 2;
    }

    override public function destroy():Void
    {
        if (messageTimer != null)
        {
            messageTimer.cancel();
            messageTimer.destroy();
        }

        super.destroy();
    }
}
