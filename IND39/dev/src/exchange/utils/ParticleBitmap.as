////////////////////////////////////////////////////////////////////////////////
// FileName: ParticleBitmap.as
// Created by: Angel 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// IMPORTS
////////////////////////////////////////////////////////////////////////////////
import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.geom.Point;

import com.greensock.TweenMax;
import com.greensock.easing.*;

////////////////////////////////////////////////////////////////////////////////
// CLASS: ParticleBitmap 
////////////////////////////////////////////////////////////////////////////////
class exchange.utils.ParticleBitmap extends MovieClip 
{
	////////////////////////////////////////////////////////////////////////////
	// Properties
	////////////////////////////////////////////////////////////////////////////	
	private var bmpData				: BitmapData;
	private var container_mc		: MovieClip;
	private var particleSize		: Number;
	private var particle_arr		: Array;
	
	////////////////////////////////////////////////////////////////////////////
	// Constructor
	////////////////////////////////////////////////////////////////////////////
	public function ParticleBitmap(pBitmap:String, pCont:MovieClip, pSize:Number) 
	{
		particle_arr = new Array();
		
		bmpData = BitmapData.loadBitmap(pBitmap);
		container_mc = pCont;
		particleSize = pSize;
		
		var totalRows:Number = Math.ceil(bmpData.height / pSize);
		var totalCols:Number = Math.ceil(bmpData.width / pSize);
		
		for (var i:Number = 0; i < totalRows; i++) 
		{
			for (var j:Number = 0; j < totalCols; j++) 
			{
				var xParticle:Number = j * pSize;
				var yParticle:Number = i * pSize;
				
				//trace("(" + xParticle + ", " + yParticle + ") -size- (" + pSize + ", " + pSize + ")");
				
				var particleData:BitmapData = new BitmapData(pSize, pSize, true, 0x00FFFFFF);
				
				var lvlParticle:Number = container_mc.getNextHighestDepth();
				var mcParticle:MovieClip = container_mc.createEmptyMovieClip("mcParticle" + lvlParticle, lvlParticle);
				mcParticle.attachBitmap(particleData, 0);
				
				particleData.copyPixels(bmpData, new Rectangle(xParticle, yParticle, pSize, pSize), new Point(0, 0));
				
				mcParticle._alpha = 0;
				
				particle_arr.push({_name:"mcParticle" + lvlParticle, _x:xParticle, _y:yParticle});
			}
		}
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Move bitmap to a position
	////////////////////////////////////////////////////////////////////////////	
	public function moveBitmap(pX:Number, pY:Number):Void 
	{

		for (var i:Number = 0; i < particle_arr.length; i++) 
		{
			var mcParticle:MovieClip = container_mc[particle_arr[i]._name];
			
			mcParticle._x = particle_arr[i]._x + pX;
			mcParticle._y = particle_arr[i]._y + pY;
			
			mcParticle._alpha = 100;
		}
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Tween bitmap particles to a position
	////////////////////////////////////////////////////////////////////////////
	public function tweenBitmap(pX:Number, pY:Number, pTime:Number, pDelay:Number):Void 
	{
		var aryTemp:Array = particle_arr;
		
		for (var i:Number = 0; i < aryTemp.length; i++) 
		{
			var mcParticle:MovieClip = container_mc[aryTemp[i]._name];
			
			aryTemp[i]._hyp = Math.sqrt(Math.pow(mcParticle._x - pX, 2) + Math.pow(mcParticle._y - pY, 2));
		}
		
		aryTemp.sortOn("_hyp", Array.NUMERIC);
			
		for (var i:Number = 0; i < aryTemp.length; i++) 
		{
			var mcParticle:MovieClip = container_mc[aryTemp[i]._name];
			var xNew:Number = aryTemp[i]._x + pX;
			var yNew:Number = aryTemp[i]._y + pY;
			var dNew:Number = i * pDelay;

			TweenMax.killTweensOf(mcParticle);
			TweenMax.to(mcParticle, pTime,  { _x:xNew, _y:yNew, delay:dNew, ease:Linear.easeOut });
		}
	}

	////////////////////////////////////////////////////////////////////////////
	// Draw rectangle
	////////////////////////////////////////////////////////////////////////////
	public function drawRect(pMc:MovieClip, pW:Number, pH:Number, pClr:Number, pA:Number):Void 
	{
		pMc.beginFill(pClr, pA);
		pMc.moveTo(0,0);
		pMc.lineTo(pW,0);
		pMc.lineTo(pW,pH);
		pMc.lineTo(0,pH);
		pMc.lineTo(0,0);
		pMc.endFill();
	}
}

