
package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.tweens.FlxTween;
import openfl.utils.Assets;
import utils.Alphabet;

class TitleState extends FlxState
{
    private var gfDance:FlxSprite;
    private var logoBump:FlxSprite;
    private var titleEnter:FlxSprite;

    private var danceLeft:Bool = false;

    // INTRO TEXT
    private var displayedLines:Array<String> = [];
    private var activeIntroLabels:Array<Alphabet> = [];

    private var randomLines:Array<String> = [];
    private var randomPhrase:Array<String> = [];

    private var sequenceTimer:FlxTimer;
    private var enterTimer:FlxTimer;

    // TITLE ENTER COLOR ANIMATION
    private var idleColorTween:FlxTween;

    private var bpm:Float = 102;
    private var beatTimer:Float = 0;
    private var beatDuration:Float = 0;

    private var sequenceFinished:Bool = false;
    private var transitioning:Bool = false;

    private static inline var INTRO_TEXT_SIZE:Float = 1;
    private static inline var INTRO_LINE_HEIGHT:Float = 60;

    override public function create():Void
    {
        super.create();

        FlxG.camera.bgColor = 0xFF000000;

        beatDuration = 60 / bpm;

        // GF TITLE
        gfDance = new FlxSprite(512, 40);

        gfDance.frames = FlxAtlasFrames.fromSparrow(
            "assets/shared/images/gfDanceTitle.png",
            "assets/shared/images/gfDanceTitle.xml"
        );

        gfDance.animation.addByIndices(
            "danceLeft",
            "gfDance",
            [
                15, 16, 17, 18, 19,
                20, 21, 22, 23, 24,
                25, 26, 27, 28, 29
            ],
            "",
            24,
            false
        );

        gfDance.animation.addByIndices(
            "danceRight",
            "gfDance",
            [
                30, 0, 1, 2, 3,
                4, 5, 6, 7, 8,
                9, 10, 11, 12, 13, 14
            ],
            "",
            24,
            false
        );

        gfDance.animation.play("danceRight");
        gfDance.antialiasing = true;
        gfDance.visible = false;

        add(gfDance);

        // LOGO BUMPIN
        logoBump = new FlxSprite();

        logoBump.frames = FlxAtlasFrames.fromSparrow(
            "assets/shared/images/logoBumpin.png",
            "assets/shared/images/logoBumpin.xml"
        );

        logoBump.animation.addByPrefix(
            "bump",
            "logo bumpin",
            24,
            false
        );

        logoBump.antialiasing = true;

        logoBump.scale.set(1, 1);
        logoBump.updateHitbox();

        // MANUAL POSITION
        logoBump.x = -150;
        logoBump.y = -120;

        logoBump.visible = false;

        add(logoBump);

        // TITLE ENTER
        titleEnter = new FlxSprite();

        titleEnter.frames = FlxAtlasFrames.fromSparrow(
            "assets/shared/images/titleEnter.png",
            "assets/shared/images/titleEnter.xml"
        );

        titleEnter.animation.addByPrefix(
            "idle",
            "ENTER IDLE",
            24,
            true
        );

        titleEnter.animation.addByPrefix(
            "pressed",
            "ENTER PRESSED",
            24,
            true
        );

        titleEnter.animation.addByPrefix(
            "freeze",
            "ENTER FREEZE",
            24,
            false
        );

        titleEnter.animation.play("idle");

        titleEnter.antialiasing = true;
        titleEnter.scale.set(1, 1);
        titleEnter.updateHitbox();

        titleEnter.x = 50;
        titleEnter.y = FlxG.height - titleEnter.height - 45;
        titleEnter.visible = false;

        add(titleEnter);

        // RANDOM TEXT
        loadRandomText();

        sequenceTimer = new FlxTimer();
        enterTimer = new FlxTimer();

        // FIRST INTRO SEQUENCE
        runSequence(
            ["Created", "by", "AzureSLMX"],
            0,
            startNewgroundsSequence
        );
    }

    // LOAD RANDOM PHRASES
    private function loadRandomText():Void
    {
        randomLines = [];

        if (!Assets.exists("assets/data/randomtext.txt"))
            return;

        var content:String = Assets.getText(
            "assets/data/randomtext.txt"
        );

        for (line in content.split("\n"))
        {
            var cleaned:String = StringTools.trim(line);

            if (cleaned.length > 0 && !StringTools.startsWith(cleaned, "#"))
                randomLines.push(cleaned);
        }
    }

    // DISPLAY A SEQUENCE ONE LINE AT A TIME
    private function runSequence(
        lines:Array<String>,
        index:Int,
        onComplete:Void->Void
    ):Void
    {
        if (index >= lines.length)
        {
            sequenceTimer.start(1, function(timer:FlxTimer):Void
            {
                onComplete();
            });

            return;
        }

        sequenceTimer.start(1, function(timer:FlxTimer):Void
        {
            displayedLines.push(lines[index]);

            addIntroLine(lines[index]);

            runSequence(lines, index + 1, onComplete);
        });
    }

    // ADD ONE INTRO LINE
    private function addIntroLine(line:String):Void
    {
        var label:Alphabet = new Alphabet(
            0,
            0,
            line,
            true,
            INTRO_TEXT_SIZE
        );

        label.visible = true;

        activeIntroLabels.push(label);

        add(label);

        centerIntroLines();
    }

    // CENTER EACH LINE INDEPENDENTLY
    private function centerIntroLines():Void
    {
        var totalHeight:Float =
            activeIntroLabels.length * INTRO_LINE_HEIGHT;

        var currentY:Float =
            (FlxG.height - totalHeight) / 2;

        for (label in activeIntroLabels)
        {
            label.x = (FlxG.width - label.textWidth) / 2;
            label.y = currentY;

            currentY += INTRO_LINE_HEIGHT;
        }
    }

    // HIDE PREVIOUS INTRO LINES
    private function clearIntroLines():Void
    {
        for (label in activeIntroLabels)
        {
            label.visible = false;
            label.active = false;
        }

        activeIntroLabels = [];
        displayedLines = [];
    }

    // NEWGROUNDS SEQUENCE
    private function startNewgroundsSequence():Void
    {
        clearIntroLines();

        runSequence(
            ["Not associated", "with", "Newgrounds"],
            0,
            startRandomSequence
        );
    }

    // RANDOM PHRASE SEQUENCE
    private function startRandomSequence():Void
    {
        clearIntroLines();

        if (randomLines.length == 0)
        {
            startFridaySequence();
            return;
        }

        var selectedPhrase:String = FlxG.random.getObject(randomLines);

        randomPhrase = [];

        for (word in selectedPhrase.split(","))
        {
            var cleaned:String = StringTools.trim(word);

            if (cleaned.length > 0)
                randomPhrase.push(cleaned);
        }

        runSequence(
            randomPhrase,
            0,
            startFridaySequence
        );
    }

    // FRIDAY NIGHT FUNKIN
    private function startFridaySequence():Void
    {
        clearIntroLines();

        runSequence(
            ["Friday", "Night", "Funkin"],
            0,
            finishSequence
        );
    }

    // START TITLE SCREEN
    private function finishSequence():Void
    {
        clearIntroLines();

        gfDance.visible = true;

        logoBump.visible = true;
        logoBump.animation.play("bump", true);

        titleEnter.visible = true;
        titleEnter.animation.play("idle");

        // CYAN TO DARK BLUE COLOR CYCLE
        titleEnter.color = FlxColor.CYAN;

       idleColorTween = FlxTween.color(
    titleEnter,
    0.8,
    FlxColor.CYAN,
    FlxColor.fromRGB(0, 0, 100),
    {
        type: PINGPONG
    }
);

        sequenceFinished = true;
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (transitioning)
            return;

        // BEAT SYSTEM
        beatTimer += elapsed;

        while (beatTimer >= beatDuration)
        {
            beatTimer -= beatDuration;
            beatHit();
        }

        // ENTER
        if (sequenceFinished && FlxG.keys.justPressed.ENTER)
            startGame();
    }

    // BEAT HIT
    private function beatHit():Void
    {
        if (!gfDance.visible)
            return;

        danceLeft = !danceLeft;

        if (danceLeft)
            gfDance.animation.play("danceLeft", true);
        else
            gfDance.animation.play("danceRight", true);

        logoBump.animation.play("bump", true);
    }

    // START MAIN MENU
    private function startGame():Void
    {
        if (transitioning)
            return;

        transitioning = true;

        // STOP COLOR CYCLE
        if (idleColorTween != null)
        {
            idleColorTween.cancel();
            idleColorTween = null;
        }

        titleEnter.color = FlxColor.WHITE;

        // PLAY ENTER PRESSED
        titleEnter.animation.play("pressed", true);

        // WAIT ONE SECOND
        enterTimer.start(1, function(timer:FlxTimer):Void
        {
            FlxG.camera.flash(0xFFFFFFFF, 0.5);

            FlxG.switchState(
                () -> new states.MainMenuState()
            );
        });
    }

    override public function destroy():Void
    {
        if (sequenceTimer != null)
        {
            sequenceTimer.cancel();
            sequenceTimer.destroy();
            sequenceTimer = null;
        }

        if (enterTimer != null)
        {
            enterTimer.cancel();
            enterTimer.destroy();
            enterTimer = null;
        }

        if (idleColorTween != null)
        {
            idleColorTween.cancel();
            idleColorTween = null;
        }

        super.destroy();
    }
}
