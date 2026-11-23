
package utils;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;

class Alphabet extends FlxSpriteGroup
{
    public var text(default, set):String = "";

    public var textWidth(default, null):Float = 0;
    public var textHeight(default, null):Float = 0;

    private var atlas:FlxAtlasFrames;
    private var textSize:Float;
    private var isBold:Bool;

    private static inline var SPACE_WIDTH:Float = 28;
    private static inline var LINE_HEIGHT:Float = 70;
    private static inline var LETTER_SPACING:Float = 4;

    public function new(
        x:Float,
        y:Float,
        text:String = "",
        isBold:Bool = false,
        textSize:Float = 1.0
    )
    {
        super(x, y);

        this.isBold = isBold;
        this.textSize = textSize;

        atlas = FlxAtlasFrames.fromSparrow(
            "assets/shared/images/utils/alphabet.png",
            "assets/shared/images/utils/alphabet.xml"
        );

        this.text = text;
    }

    public function setText(value:String):Void
    {
        this.text = value;
    }

    private function set_text(value:String):String
    {
        if (text == value && members.length > 0)
            return value;

        text = value;

        clearAlphabet();

        var cursorX:Float = 0;
        var cursorY:Float = 0;
        var maxWidth:Float = 0;
        var lineCount:Int = 1;

        for (i in 0...value.length)
        {
            var character:String = value.charAt(i);

            if (character == "\n")
            {
                maxWidth = Math.max(maxWidth, cursorX);
                cursorX = 0;
                cursorY += LINE_HEIGHT * textSize;
                lineCount++;
                continue;
            }

            if (character == " ")
            {
                cursorX += SPACE_WIDTH * textSize;
                continue;
            }

            var letter = new AlphaCharacter(
                cursorX,
                cursorY,
                character,
                atlas,
                isBold
            );

            letter.scale.set(textSize, textSize);
            letter.updateHitbox();

            add(letter);

            cursorX += letter.width + LETTER_SPACING * textSize;
        }

        maxWidth = Math.max(maxWidth, cursorX);

        textWidth = maxWidth;
        textHeight = lineCount * LINE_HEIGHT * textSize;

        return value;
    }

    private function clearAlphabet():Void
    {
        while (members.length > 0)
        {
            var sprite = members.pop();

            if (sprite != null)
            {
                sprite.kill();
                sprite.visible = false;
                sprite.active = false;
            }
        }
    }

    override public function destroy():Void
    {
        clearAlphabet();
        atlas = null;

        super.destroy();
    }
}

class AlphaCharacter extends FlxSprite
{
    public function new(
        x:Float,
        y:Float,
        character:String,
        atlas:FlxAtlasFrames,
        isBold:Bool = false
    )
    {
        super(x, y);

        frames = atlas;

        var lower:String = character.toLowerCase();
        var upper:String = character.toUpperCase();

        var style:String;

        if (isBold)
            style = "bold";
        else if (lower != upper)
            style = character == lower ? "lowercase" : "uppercase";
        else
            style = "normal";

        animation.addByPrefix(
            "idle",
            lower + " " + style + " instance",
            24,
            true
        );

        animation.play("idle");
    }
}
