////////////////////////////////////////////////////////////////////////////////
// Sun rays includes AS2 file
////////////////////////////////////////////////////////////////////////////////

function sunRays():Void 
{
	// Sun Ray Amount 	
	var sunRayNumber:Number = 36;
	var sunRayMaxTallness:Number = 100;
	var sunRayMinTallness:Number = 80;
	var sunRayMaxWidth:Number = 200;
	var sunRayMinWidth:Number = 100;
	var sunRayRotateSpeed:Number = 0.3;
	var sunRayWaveSpeed:Number = 2;
	var sunRayRotateRandomly:Boolean = true;
	
	// Duplicate Sun Rays
	for (var i:Number = 0; i < sunRayNumber; i++) 
	{
		var sunRay:MovieClip = this.attachMovie("ray", "ray"+i, i);
		sunRay._x = 0;
		sunRay._y = 0;
		sunRay._alpha = Math.floor(Math.random()*70)+30;
		sunRay._yscale = Math.floor(Math.random()*sunRayMaxWidth)+sunRayMinWidth;
		sunRay._xscale = Math.floor(Math.random()*sunRayMaxTallness)+sunRayMinTallness;
		sunRay._rotation = Math.floor(360/sunRayNumber)*i;
		sunRay.rotateSpeed = (Math.random()*(sunRayRotateSpeed*2))-sunRayRotateSpeed;
		sunRay.sunRayWaveSpeed = ((Math.random()*(sunRayWaveSpeed*2))-sunRayWaveSpeed)+1;
		sunRay.maxScale = sunRayMaxTallness+sunRayMinTallness;
		sunRay.minScale = sunRayMinTallness;
		sunRay.sunRayMinTallness = sunRayMinTallness;
		sunRay.onEnterFrame = rotateSunRays;
	}
	
	function rotateSunRays():Void 
	{
		var ray:MovieClip = this;

		if (ray._xscale<ray.minScale || ray._xscale>ray.maxScale) 
		{ 
			ray.sunRayWaveSpeed *= -1;
		}

		ray._xscale += ray.sunRayWaveSpeed; 

		if (sunRayRotateRandomly) 
		{
			ray._rotation += ray.rotateSpeed;
		} 
		else 
		{
			ray._rotation += sunRayRotateSpeed;
		}
	}
}

sunRays();
