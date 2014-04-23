﻿package  
{
	import flash.display.Sprite;

	import starling.core.Starling;

    [SWF(width="800", height="600", frameRate="60", backgroundColor="#cccccc")]
	public class Example_Motorcycle_NestingSkeleton extends flash.display.Sprite 
	{

		public function Example_Motorcycle_NestingSkeleton() 
		{
			starlingInit();
		}

		private function starlingInit():void 
		{
			var _starling:Starling = new Starling(StarlingGame, stage);
			_starling.showStats = true;
			_starling.start();
		}
	}
}

import flash.events.Event;
import flash.ui.Keyboard;

import starling.display.Sprite;
import starling.events.EnterFrameEvent;
import starling.events.KeyboardEvent;
import starling.text.TextField;

import dragonBones.Armature;
import dragonBones.animation.WorldClock;
import dragonBones.factorys.StarlingFactory;
import dragonBones.events.AnimationEvent;

class StarlingGame extends Sprite 
{
	[Embed(source = "../assets/Motorcycle_output.png", mimeType = "application/octet-stream")]
	private static const ResourcesData:Class;

	private var _factory:StarlingFactory;
	private var _armature:Armature;
	private var _armatureDisplay:Sprite;
	private var _textField:TextField;

	public function StarlingGame() 
	{
		_factory = new StarlingFactory();
		_factory.parseData(new ResourcesData());
		_factory.addEventListener(Event.COMPLETE, textureCompleteHandler);
	}

	private function textureCompleteHandler(e:Event):void 
	{
		_armature = _factory.buildArmature("motorcycleMan");
		_armatureDisplay = _armature.display as Sprite;
		_armatureDisplay.x = 400;
		_armatureDisplay.y = 400;
		
		updateMovement();
		
		WorldClock.clock.add(_armature);
		
		this.addChild(_armatureDisplay);
		this.addEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameHandler);
		
		_textField = new TextField(700, 30, "Press A/D to lean forward/backward.", "Verdana", 16, 0, true)
		_textField.x = 60;
		_textField.y = 5;
		this.addChild(_textField);
		
		this.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
		this.stage.addEventListener(KeyboardEvent.KEY_UP, keyHandler);
	}

	private function keyHandler(e:KeyboardEvent):void 
	{
		switch (e.keyCode) 
		{
			case Keyboard.LEFT:
			case Keyboard.A:
				_left = e.type == KeyboardEvent.KEY_DOWN;
				updateMove(-1);
				break;
			
			case Keyboard.RIGHT:
			case Keyboard.D:
				_right = e.type == KeyboardEvent.KEY_DOWN;
				updateMove(1);
				break;
		}
	}

	private function enterFrameHandler(_e:EnterFrameEvent):void 
	{
		WorldClock.clock.advanceTime(-1);
	}
	
	private var _left:Boolean;
	private var _right:Boolean;
	
	private function updateMove(_dir:int):void 
	{
		if (_left && _right) 
		{
			move(_dir);
		}
		else if (_left)
		{
			move(-1);
		}
		else if (_right)
		{
			move(1);
		}
		else 
		{
			move(0);
		}
	}
	
	private var _moveDir:int;
	private function move(_dir:int):void 
	{
		if (_moveDir == _dir) 
		{
			return;
		}
		_moveDir = _dir;
		updateMovement();
	}

	private function updateMovement():void 
	{
		if (_moveDir == 0) 
		{
			_armature.animation.gotoAndPlay("stay");
		}
		else 
		{
			if (_moveDir > 0)
			{
				_armature.animation.gotoAndPlay("right");
			}
			else
			{
				_armature.animation.gotoAndPlay("left");
			}
		}
	}
}