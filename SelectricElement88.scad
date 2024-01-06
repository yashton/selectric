
// Usage: copy this commented code to a separate file, customize as needed for each typeface. Everything below in this file will be common to all projects.

/* --------- START ---------

// enable to skip slow rendering of letters on the ball
PREVIEW_LABEL = true;

// The name of the font, as understood by the system.
// Note: if the system doesn't recognize the font it
// will silently fall back to a default!
TYPEBALL_FONT = "Vogue";

// Labels on the top of the ball, cosmetic
module Labels()
{
    offset(r=0.12)
    {
        translate([-0.1,14,0])
        text("1O", size=2, font=TYPEBALL_FONT, halign="center");

        translate([0,0.6,0])
        text(TYPEBALL_FONT, size=2, font=TYPEBALL_FONT, halign="center");

//        translate([0,-1.6,0])
//        text("Mono", size=2, font=TYPEBALL_FONT, halign="center");
    }
}

// The font height, adjusted for the desired pitch
// (Note that this is multiplied by faceScale=2.25 in LetterText())
LETTER_HEIGHT = 2.75;

// Keyboard layout

LOWER_CASE = str(
    "1234567890-=",
    "qwertyuiop½",
    "asdfghjkl;'",
    "zxcvbnm,./"
);

UPPER_CASE = str(
    "!@#$%¢&*()_+",
    "QWERTYUIOP¼",
    "ASDFGHJKL:\"",
    "ZXCVBNM,.?"
);

// Offset each glyph by this amount, making the characters heavier or lighter
CHARACTER_WEIGHT_ADJUSTMENT = 0;

// balance the vertical smear with extra horizontal weight
HORIZONTAL_WEIGHT_ADJUSTMENT = 0.2;

// If g/j/p/q/y in bottom row extend into the detent teeth area, we'll need to trim them back out
TRIM_DESCENDERS = true;

// Lower-level stuff that should be common to all balls is in a separate file
include <SelectricElement88.scad>


// -------------------
// Render
// -------------------

// preview a single letter
//LetterText(LETTER_HEIGHT, LETTER_ALTITUDE, TYPEBALL_FONT, "8");

// preview text at the given pitch
//TextGauge("This is example text at 12 pitch", 12);

// render the full type ball
difference() {
    TypeBall();
    FontLabel()
       Labels();
}


// ---------- END ----------
*/



// ############################### Selectric_II_typeball.scad ###############################
// Custom typeball ("golfball") type element for IBM Selectric II typewriters

// based on original project by Steve Malikoff
// https://www.thingiverse.com/thing:4126040

// Modifications by Dave Hayden (dave@selectricrescue.org), last update 2023.07.07

// Huge thanks to Sam Ettinger for his feedback and
// for proving that resin-printed Selectric balls
// actually work, to Stephen Cook for his expert
// advice, and of course to Steve Malikoff for
// bringing the dream to life

// Note: STL generation is *much* faster using the command line, with the --enable all flag

// This work is released under the CC BY 4.0 license:
// https://creativecommons.org/licenses/by/4.0/

// You are free to:
// Share — copy and redistribute the material in any medium or format
// Adapt — remix, transform, and build upon the material for any purpose, even commercially.

// Under the following terms:
// Attribution — You must give appropriate credit, provide a link to the license, and indicate if changes were made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.
// No additional restrictions — You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.

// Original project notes:
// ----------------------------------------
//
// NOTE1:   USING A REGULAR FDM PRINTER MAY NOT ACHIEVE THE RESOLUTION REQUIRED, PERHAPS A RESIN PRINT
//          WOULD WORK BETTER
// NOTE2:   THIS IS FOR AMUSEMENT PURPOSES ONLY, NOT INTENDED FOR SERIOUS USE. HAVE FUN!
// NOTE3:   I AM NOT RESPONSIBLE FOR ANY DAMAGE THIS PRINT MAY CAUSE TO YOUR TYPEWRITER, USE AT OWN RISK.
//
// In memory of John Thompson, an Australian IBM OPCE from whom I "inherited" his Selectric CE tool set:
//      http://qccaustralia.org/vale.htm
//
// Copyright (C) Steve Malikoff 2020
// Written in Brisbane, Australia
// LAST UPDATE  20200125


// ---------------------------------------------------
// Font and cosmetic parameters
// ---------------------------------------------------

// See SelectricElementExample.scad for parameters expected to be defined before including this one.

// ---------------------------------------------------
// Typeball dimensions
// ---------------------------------------------------

// How far the type's contact face projects outwards above the ball surface
LETTER_ALTITUDE = 1.8;

// Tweak tilt of characters per row for better descenders/balance. Ordered top to bottom. Amount is backwards rotation: top goes back and bottom goes forward
ROW_TILT_ADJUST = [ 0, 0.5, 1, 2 ];

// amount of curvature on the letter faces. Using a value a bit larger than the actual platen seems to give a better print
PLATEN_DIA = 45;

// Rendering granularity for F5 preview and F6 render. Rendering takes a while.
PREVIEW_FACETS = 22;
RENDER_FACETS = 44;

FACETS = $preview ? PREVIEW_FACETS : RENDER_FACETS;
FONT_FACETS = FACETS;
$fn = FACETS;

// --- probably shouldn't mess with stuff below ---

// Parameters have been tuned for printing on a Creality Halot One resin printer, using Sunlu ABS-Like resin

// angle between the four rows of type
TILT_ANGLE = 16.4;

// top row is just a bit high :-/
TOP_ROW_ADJUSTMENT = -0.3;

// add a slot opposite the alignment notch. What's it for? Who knows?
SLOT = true;

TYPEBALL_RAD = 33.4 / 2;
INSIDE_RAD = 28.15 / 2;
INSIDE_CURVE_START = 2;
TYPEBALL_HEIGHT = 21.5;
TYPEBALL_TOP_ABOVE_CENTRE = 11.4; // Flat top is this far above the sphere centre
TYPEBALL_TOP_THICKNESS = 1.65;

// Label params
DEL_BASE_FROM_CENTRE = 8.2;
DEL_DEPTH = 0.6;

// Detent teeth skirt parameters
TYPEBALL_SKIRT_TOP_RAD = 31.9 / 2;
TYPEBALL_SKIRT_BOTTOM_RAD = 30.5 / 2;
TYPEBALL_SKIRT_TOP_BELOW_CENTRE = -sqrt(TYPEBALL_RAD^2-TYPEBALL_SKIRT_TOP_RAD^2);  // Where the lower latitude of the sphere meets the top of the skirt
SKIRT_HEIGHT = TYPEBALL_HEIGHT - TYPEBALL_TOP_ABOVE_CENTRE+ TYPEBALL_SKIRT_TOP_BELOW_CENTRE;
TOOTH_PEAK_OFFSET_FROM_CENTRE = 6.1; // Lateral offset of the tilt ring detent pawl

// Parameters for the centre boss that goes onto tilt ring spigot (upper ball socket)
BOSS_INNER_RAD = 4.35;
BOSS_OUTER_RAD = 5.8;
BOSS_HEIGHT = 8.07;
NOTCH_ANGLE = 131.8; // Must be exact! If not, ball doesn't detent correctly
NOTCH_WIDTH = 1.1; // Should be no slop here, either
NOTCH_DEPTH = 2;
NOTCH_HEIGHT = 2.2;
SLOT_ANGLE = NOTCH_ANGLE + 180;
SLOT_WIDTH = 1.9;
SLOT_DEPTH = 0.4;

// Inside reinforcement ribs
RIBS = 11;
RIB_LENGTH = 8;
RIB_WIDTH = 2;
RIB_HEIGHT = 2.5;

// Character layout
CHARACTERS_PER_LATITUDE = 22;   // For Selectric I and II. 4 x 22 = 88 characters total.
CHARACTER_LONGITUDE = 360 / CHARACTERS_PER_LATITUDE; // For Selectric I and II

EPSILON = 0.001; // to fix z-fighting in preview


FACE_SCALE = 2.25;

// ---------------------------------------------------
// Rendering
// ---------------------------------------------------

// The entire typeball model proper.
module TypeBall()
{
    if ( is_undef(PREVIEW_LABEL) || !PREVIEW_LABEL )
    {
        difference()
        {
            SelectricLayout88();
            TrimTop();

            if ( !is_undef(TRIM_DESCENDERS) && TRIM_DESCENDERS )
            {
                // trim any bits that extended into the detent teeth
                translate([0,0, TYPEBALL_SKIRT_TOP_BELOW_CENTRE - SKIRT_HEIGHT-EPSILON])
                DetentTeeth();
            }
        }
    }

    difference()
    {
        HollowBall();
        if (SLOT) Slot();
        Notch();
        Del();
    }
}


// Keyboard location of each letter on the ball
charmap88 =
   [ 0,  2,  6,  7,  3, 34,  1,  4,  5,  9,  8,
    35, 18, 25, 36, 31, 16, 39, 14, 30, 28, 38,
    40, 37, 15, 23, 20, 22, 42, 33, 19, 24, 13,
    27, 26, 32, 41, 43, 29, 11, 21, 12, 17, 10 ];

module SelectricLayout88()
{
    ROWCHARS = CHARACTERS_PER_LATITUDE/2;

    for ( l=[0:3] )
    {
        tiltAngle = (2-l) * TILT_ANGLE + (l==0?TOP_ROW_ADJUSTMENT:0);

        for ( p=[0:ROWCHARS-1] )
        {
            GlobalPosition(TYPEBALL_RAD, tiltAngle, (5-p)*CHARACTER_LONGITUDE, ROW_TILT_ADJUST[l])
            LetterText(LETTER_HEIGHT, LETTER_ALTITUDE, TYPEBALL_FONT, LOWER_CASE[charmap88[ROWCHARS*l+p]]);
        }

        for ( p=[0:ROWCHARS-1] )
        {
            GlobalPosition(TYPEBALL_RAD, tiltAngle, (ROWCHARS+5-p)*CHARACTER_LONGITUDE, ROW_TILT_ADJUST[l])
            LetterText(LETTER_HEIGHT, LETTER_ALTITUDE, TYPEBALL_FONT, UPPER_CASE[charmap88[ROWCHARS*l+p]]);
        }
    }
}

// position child (a typeface letter) at global latitude and longitude on sphere of given radius
module GlobalPosition(r, latitude, longitude, rotAdjust)
{
    x = r * cos(latitude);
    y = 0;
    z = r * sin(latitude);

    rotate([0, 0, longitude])
    translate([x, y, z])
    rotate([0, 90 - latitude - rotAdjust, 0])
    children();
}

//// generate reversed embossed text, tapered outwards to ball surface, face curved to match platen
module LetterText(someTypeSize, someHeight, typeballFont, someLetter, platenDiameter=40)
{
    $fn = $preview ? 12 : 24;

    rotate([0,180,90])
    minkowski()
    {
        intersection()
        {
            translate([0,-someTypeSize/2,-someHeight])
            scale([0.5,0.5,2.0])
            linear_extrude(height=1)
            offset(CHARACTER_WEIGHT_ADJUSTMENT)
            minkowski()
            {
                text(size=someTypeSize * FACE_SCALE, font=typeballFont, halign="center", someLetter);
                polygon([[-HORIZONTAL_WEIGHT_ADJUSTMENT/2,0],[HORIZONTAL_WEIGHT_ADJUSTMENT/2,0],[HORIZONTAL_WEIGHT_ADJUSTMENT/2,EPSILON],[-HORIZONTAL_WEIGHT_ADJUSTMENT/2,EPSILON]]);
            }

            translate([0,0,-platenDiameter/2-someHeight/2+0.121])
            rotate([0,90,0])
            difference()
            {
                cylinder(h=100, r=platenDiameter/2+0.01, center=true, $fn=$preview ? 60 : 360);
                cylinder(h=100, r=platenDiameter/2, center=true, $fn=$preview ? 60 : 360);
            }

        }

        cylinder(h=someHeight, r1=0, r2=0.75*someHeight);
    }
}

// The unadorned ball shell with internal ribs
module HollowBall()
{
    difference()
    {
        Ball();
        translate([0,0,-20+INSIDE_CURVE_START])
            cylinder(r=INSIDE_RAD, h=20, $fn=$preview ? 60 : 360); // needs to be smooth!
    }
    Ribs();
}

module Ball()
{
    arbitraryRemovalBlockHeight = 20;

    // Basic ball, trimmed flat top and bottom
    difference()
    {
        sphere(r=TYPEBALL_RAD, $fn=$preview ? 40 : 160);

        translate([-50,-50, TYPEBALL_TOP_ABOVE_CENTRE-EPSILON])
            cube([100,100,arbitraryRemovalBlockHeight]);

        translate([-50,-50, TYPEBALL_SKIRT_TOP_BELOW_CENTRE - arbitraryRemovalBlockHeight])   // ball/skirt fudge factor
            cube([100,100,arbitraryRemovalBlockHeight]);

        intersection()
        {
            sphere(r=sqrt(INSIDE_RAD^2+INSIDE_CURVE_START^2), $fn=$preview ? 60 : 160);
            translate([-20,-20,INSIDE_CURVE_START-EPSILON])
                cube([40,40,20]);
        }
    }

    // Fill top back in
    TopFace();

    // Detent teeth skirt
    DetentTeethSkirt();
    CentreBoss();
}

//////////////////////////////////////////////////////////////////////////
//// Detent teeth around bottom of ball
module DetentTeethSkirt()
{
    // Detent teeth skirt
    difference()
    {
        translate([0,0, TYPEBALL_SKIRT_TOP_BELOW_CENTRE - SKIRT_HEIGHT])
        cylinder(r2=TYPEBALL_SKIRT_TOP_RAD, r1=TYPEBALL_SKIRT_BOTTOM_RAD, h=SKIRT_HEIGHT, $fn=160);

        translate([0,0, TYPEBALL_SKIRT_TOP_BELOW_CENTRE - SKIRT_HEIGHT-EPSILON])
        DetentTeeth();
    }
}

// Ring of detent teeth in skirt
module DetentTeeth()
{
    for (i=[0:CHARACTERS_PER_LATITUDE - 1])
    {
        rotate([0, 0, i * CHARACTER_LONGITUDE])
        Tooth();
    }
}

module Tooth()
{
    translate([0, TOOTH_PEAK_OFFSET_FROM_CENTRE, 0])
    rotate([180, -90, 0])
    {
        // notch between teeth must be big enough to trap detent
        linear_extrude(30)
        polygon(points=[[0,1.9], [2.2,0.4], [3.2,0.14], [3.2, -0.14], [2.2, -0.4], [0,-1.9]]);
    }
}

// Flat top of typeball, punch tilt ring spigot hole through and subtract del triangle
module TopFace()
{
    r = sqrt(TYPEBALL_RAD^2-TYPEBALL_TOP_ABOVE_CENTRE^2);

    // Fill top back in, after the inside sphere was subtracted before this fn was called
    difference()
    {
        translate([0, 0, TYPEBALL_TOP_ABOVE_CENTRE - TYPEBALL_TOP_THICKNESS - RIB_HEIGHT])
        cylinder(r=r, h=TYPEBALL_TOP_THICKNESS+RIB_HEIGHT);

        translate([0, 0, TYPEBALL_TOP_ABOVE_CENTRE - TYPEBALL_TOP_THICKNESS - RIB_HEIGHT - EPSILON])
        cylinder(h=RIB_HEIGHT/2, r1=r, r2=0);

        translate([0, 0, TYPEBALL_TOP_ABOVE_CENTRE - TYPEBALL_TOP_THICKNESS - RIB_HEIGHT - EPSILON])
        cylinder(r=BOSS_INNER_RAD,h=TYPEBALL_TOP_THICKNESS*2+RIB_HEIGHT);

        Del();
    }
}

// Alignment marker triangle on top face
module Del()
{
    translate([DEL_BASE_FROM_CENTRE, 0, TYPEBALL_TOP_ABOVE_CENTRE - DEL_DEPTH + EPSILON])
    color("white")  // TODO red triangle for Composer typeball
    linear_extrude(DEL_DEPTH)
    polygon(points=[[3.4,0],[0.4,1.3],[0.4,-1.3]]);
}

// Emboss a label onto top face
module FontLabel()
{
    translate([-8.5, 0, TYPEBALL_TOP_ABOVE_CENTRE - DEL_DEPTH])
    rotate([0,0,270])
    linear_extrude(DEL_DEPTH+0.01)
        children();
}

// Clean up any base girth bits of T0-ring characters projecting above top face
module TrimTop()
{
    translate([-50,-50, TYPEBALL_TOP_ABOVE_CENTRE])
    cube([100,100,20]);
}

// Tilt ring boss assembly
module CentreBoss()
{
    translate([0,0, TYPEBALL_TOP_ABOVE_CENTRE - BOSS_HEIGHT])
    difference()
    {
        cylinder(r=BOSS_OUTER_RAD, h=BOSS_HEIGHT);

        translate([0,0,-EPSILON])
        cylinder(r=BOSS_INNER_RAD, h=BOSS_HEIGHT+2*EPSILON);
    }
}

// The full-length slot in the tilt ring boss at the (not quite) half past one o'clock position
// XXX - S2 doesn't use this. Which Selectric does? Composer?
module Slot()
{
    rotate([0, 0, SLOT_ANGLE])
    translate([0, -SLOT_WIDTH/2, 0])
    cube([SLOT_DEPTH + BOSS_INNER_RAD, SLOT_WIDTH, 40]);
}

// The partial-length slot in the tilt ring boss at the (not quite) half past seven o'clock position
module Notch()
{
    rotate([0, 0, NOTCH_ANGLE])
    translate([0, -NOTCH_WIDTH/2, TYPEBALL_TOP_ABOVE_CENTRE - BOSS_HEIGHT - EPSILON])
    cube([NOTCH_DEPTH + BOSS_INNER_RAD, NOTCH_WIDTH, NOTCH_HEIGHT + EPSILON]);
}

// The reinforcement spokes on the underside of the top face, from the tilt ring boss
// to the inner sphere wall
module Ribs()
{
    segment = 360 / RIBS;

    for (i=[0:RIBS - 1])
    {
        rotate([0, 5, -360.0/44 + segment * i])
        translate([BOSS_OUTER_RAD - 1.5, -RIB_WIDTH/2, TYPEBALL_TOP_ABOVE_CENTRE - TYPEBALL_TOP_THICKNESS - 0.8 * RIB_HEIGHT])
        cube([RIB_LENGTH, RIB_WIDTH, RIB_HEIGHT]);
    }
}

// tool for determining correct LETTER_HEIGHT
module TextGauge(str, pitch)
{
    for ( i = [0:len(str)] )
    {
        translate([8,8])
        translate([i*22/pitch,-LETTER_HEIGHT/2])
        scale([0.5,0.5,0.1])
        offset(CHARACTER_WEIGHT_ADJUSTMENT)
        text(size=LETTER_HEIGHT * FACE_SCALE, font=TYPEBALL_FONT, halign="center", str[i]);
    }
}
