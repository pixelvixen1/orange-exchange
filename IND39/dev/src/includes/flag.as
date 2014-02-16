////////////////////////////////////////////////////////////////////////////////
// AS2 file includes to animate a flag waving
////////////////////////////////////////////////////////////////////////////////

// variables
var speed = 4; 
var channel = 1;

displace_mc.createEmptyMovieClip("perlin", 1);
var ramp:MovieClip = displace_mc.ramp;
ramp.swapDepths(2); 

// DISPLACEMENT variables
var flapX = 10; 
var flapY = 100; 
var mode = "clamp"; 
var offset = new flash.geom.Point(0, 0); 

var displaceBitmap:flash.display.BitmapData = new flash.display.BitmapData(ramp._width, ramp._height);
var displaceFilter:flash.filters.DisplacementMapFilter = new flash.filters.DisplacementMapFilter(displaceBitmap, offset, channel, channel, flapX, flapY, mode);

// PERLINNOISE variables
var baseX = 60; 
var baseY = 0; 
var octs = 1; 
var seed = Math.floor(Math.random() * 50); 
var stitch = true; 
var fractal = true;
var gray = false; 

var noiseBitmap:flash.display.BitmapData = new flash.display.BitmapData(500, 1);
noiseBitmap.perlinNoise(baseX, baseY, octs, seed, stitch, fractal, channel, gray);
var shift:flash.geom.Matrix = new flash.geom.Matrix();

displace_mc._visible = false;
flag_mc._visible = true;

onEnterFrame = function()
{
	shift.translate(speed, 0);
	
	with (displace_mc.perlin)
	{
		clear();
		beginBitmapFill(noiseBitmap, shift);
		moveTo(0,0);
		lineTo(ramp._width, 0);
		lineTo(ramp._width, ramp._height);
		lineTo(0, ramp._height);
		lineTo(0, 0);
		endFill();
	}
	
	displaceBitmap.draw(displace_mc);
	
	flag_mc.filters = [displaceFilter];
}


