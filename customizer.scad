include <SelectricElement88.scad>
/* [Debug] */
// enable to skip slow rendering of letters on the ball
PREVIEW_LABEL = true;
// enable to render sample text
FONT_DEMO = false;

DEMO_12_HEIGHT = 2.3; // .001

DEMO_10_HEIGHT = 2.75; // .001

/* [Font] */
// The name of the font, as understood by the system. Note: if the system doesn't recognize the font it will silently fall back to a default!
TYPEBALL_FONT = "Courier";

// Font to be used on labels, defaults to TYPEBALL_FONT if not specified.
TYPEBALL_FACE = "";

// The font height (in mm), adjusted for the desired pitch (Note that this is multiplied by faceScale=2.25 in LetterText())
LETTER_HEIGHT = 2.75; // 0.001

LETTER_ALTITUDE = 0.72;

// Label on top of ball
TYPEBALL_LABEL = "Courier";
// Second label line
TYPEBALL_LABEL2 = "";

// Top pitch label
TYPEBALL_PITCH = "10";

// Size in points of labels
TYPEBALL_LABEL_SIZE = 2; // .1
// Label spacing
TYPEBALL_LABEL_SPACING = 1; // .1
TYPEBALL_LABEL_OFFSET_FIRST = -0.6; // .1
TYPEBALL_LABEL_OFFSET_SECOND = 1.8; // .1
TYPEBALL_LABEL_OFFSET = 0.6; // .1

// Offset each glyph by this amount, making the characters heavier or lighter
CHARACTER_WEIGHT_ADJUSTMENT = 0.0; // .01

// balance the vertical smear with extra horizontal weight
HORIZONTAL_WEIGHT_ADJUSTMENT = 0.2; // .01

// If g/j/p/q/y in bottom row extend into the detent teeth area, we'll need to trim them back out
TRIM_DESCENDERS = true;

// How far the type's contact face projects outwards above the ball surface
LETTER_ALTITUDE = 0.72;

// Tweak tilt of characters per row for better descenders/balance. Ordered top to bottom. Amount is backwards rotation: top goes back and bottom goes forward
ROW_TILT_ADJUST = [ 0, 0.5, 1, 2 ]; // .1

/* [Resolution] */
LETTER_FN = 12;
PLATEN_FN = 30;
FACETS_FN = 30;
HOLLOW_FN = 30;
BALL_FN = 30;
BALL_INTERIOR_FN = 30;
LOFT_FN = 4;

LOWER_CASE = str(
    "1234567890-=",
    "qwertyuiop[",
    "asdfghjkl;'",
    "zxcvbnm,./"
);

UPPER_CASE = str(
    "!@#$%^&*()_+",
    "QWERTYUIOP]",
    "ASDFGHJKL:\"",
    "ZXCVBNM<>?"
);

// Labels on the top of the ball, cosmetic
module Labels()
{
    face = len(TYPEBALL_FACE) > 0 ? TYPEBALL_FACE : TYPEBALL_FONT;
    offset(r=0.12)
    {
        translate([-0.1,14,0])
            text(TYPEBALL_PITCH, size=TYPEBALL_LABEL_SIZE, spacing=TYPEBALL_LABEL_SPACING, font=face, halign="center");
        if (len(TYPEBALL_LABEL2) > 0) {
            translate([0,TYPEBALL_LABEL_OFFSET_SECOND,0])
            text(TYPEBALL_LABEL, size=TYPEBALL_LABEL_SIZE, spacing=TYPEBALL_LABEL_SPACING, font=face, halign="center");
            translate([0,TYPEBALL_LABEL_OFFSET_FIRST,0])
            text(TYPEBALL_LABEL2, size=TYPEBALL_LABEL_SIZE, spacing=TYPEBALL_LABEL_SPACING, font=face, halign="center");
        } else {
            translate([0,TYPEBALL_LABEL_OFFSET,0])
            text(TYPEBALL_LABEL, size=TYPEBALL_LABEL_SIZE, spacing=TYPEBALL_LABEL_SPACING, font=face, halign="center");
        }
    }
}


if (FONT_DEMO) {
    for (pitch = [10,12]) {
        shift = pitch == 10 ? 0 : -40;
        height = pitch == 10 ? DEMO_10_HEIGHT : DEMO_12_HEIGHT;
        translate([8,30+shift,0])
            DebugTextGauge("ABCDEFGHIJKLMNOPQRSTUVWXYZ",height,pitch);
        translate([8,25+shift,0])
            DebugTextGauge("abcdefghijklmnopqrstuvwxyz",height,pitch);
        translate([8,20+shift,0])
            DebugTextGauge("|The quick brown fox jumps over the lazy dog|",height,pitch);
        translate([8,15+shift,0])
            DebugTextGauge(UPPER_CASE, height, pitch);
        translate([8,10+shift,0])
            DebugTextGauge(LOWER_CASE, height, pitch);
    }


} else {
    // render the full type ball
    difference() {
        TypeBall();
        FontLabel()
            Labels();
    }
}
