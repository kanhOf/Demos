﻿package
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	
	import starling.core.Starling;

	[SWF(width = "800", height = "600", frameRate = "60", backgroundColor = "#cccccc")]
	public class Example_Warrior_MultiResolution extends flash.display.Sprite
	{
		public var myStage: Stage;
		public function Example_Warrior_MultiResolution()
		{
			starlingInit();
			stage.addEventListener(MouseEvent.CLICK, mouseHandler);
		}

		private function mouseHandler(e: MouseEvent): void
		{
			switch(e.type)
			{
				case MouseEvent.CLICK:
					StarlingGame.instance.changeAnimation();
					break;
			}
		}

		private function starlingInit(): void
		{
			var starling: Starling = new Starling(StarlingGame, stage);
			starling.showStats = true;
			starling.start();
		}
	}
}

import dragonBones.Armature;
import dragonBones.animation.WorldClock;
import dragonBones.factories.StarlingFactory;
import dragonBones.objects.DragonBonesData;
import dragonBones.objects.XMLDataParser;
import dragonBones.textures.StarlingTextureAtlas;

import starling.display.Sprite;
import starling.events.EnterFrameEvent;
import starling.text.TextField;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

class StarlingGame extends Sprite
{
	[Embed(source = "../assets/Warrior_output/skeleton.xml", mimeType = "application/octet-stream")]
	public static const WarriorSkeletonXMLData: Class;

	[Embed(source = "../assets/Warrior_output/texture@2x.xml", mimeType = "application/octet-stream")]
	public static const WarriorTextureHDXMLData: Class;

	[Embed(source = "../assets/Warrior_output/texture.xml", mimeType = "application/octet-stream")]
	public static const WarriorTextureSDXMLData: Class;

	[Embed(source = "../assets/Warrior_output/texture@0.3x.xml", mimeType = "application/octet-stream")]
	public static const WarriorTextureSD2XMLData: Class;

	[Embed(source = "../assets/Warrior_output/texture@2x.png")]
	public static const WarriorTextureHDData: Class;

	[Embed(source = "../assets/Warrior_output/texture.png")]
	public static const WarriorTextureSDData: Class;

	[Embed(source = "../assets/Warrior_output/texture@0.5x.png")]
	public static const WarriorTextureSD1Data: Class;

	[Embed(source = "../assets/Warrior_output/texture@0.3x.png")]
	public static const WarriorTextureSD2Data: Class;

	public static var instance: StarlingGame;

	private var _factory: StarlingFactory;
	private var _armatures: Vector.<Armature>;
	private var _currentAnimationIndex: int = 0;
	private var _textField: TextField;

	public function StarlingGame()
	{
		instance = this;

		_armatures = new Vector.<Armature> ;

		_factory = new StarlingFactory();

		//skeletonData
		var skeletonData:DragonBonesData = XMLDataParser.parseDragonBonesData(XML(new WarriorSkeletonXMLData()));
		_factory.addSkeletonData(skeletonData, "warrior");

		var textureAtlas: TextureAtlas;

		//contentScaleFactor == 2
		//HD 2x(use different textureXML 2x)
		//高清贴图，由面板导出时设置scale为2输出，textureXML与texture对应
		textureAtlas = new StarlingTextureAtlas(
			Texture.fromBitmapData(new WarriorTextureHDData().bitmapData, false, false, 2),
			XML(new WarriorTextureHDXMLData()),
			true
		);
		/*
		textureAtlas = new TextureAtlas(
			Texture.fromBitmapData(new WarriorTextureHDData().bitmapData, false, false, 2), 
			XML(new WarriorTextureHDXMLData())
		);
		*/
		_factory.addTextureAtlas(textureAtlas, "warriorHD");

		//contentScaleFactor == 1
		//SD 1x
		//标准贴图，由面板导出时设置scale为1输出，textureXML与texture对应
		textureAtlas = new StarlingTextureAtlas(
			Texture.fromBitmapData(new WarriorTextureSDData().bitmapData, false, false, 1),
			XML(new WarriorTextureSDXMLData()),
			false
		);
		_factory.addTextureAtlas(textureAtlas, "warriorSD");

		//contentScaleFactor == 0.5
		//SD1 0.5x(use same textureXML 1x)
		//缩放为0.5的贴图，由1x的texture缩放直接缩放得到，使用1x的textureXML
		textureAtlas = new StarlingTextureAtlas(
			Texture.fromBitmapData(new WarriorTextureSD1Data().bitmapData, false, false, 0.5),
			XML(new WarriorTextureSDXMLData()),
			false
		);
		_factory.addTextureAtlas(textureAtlas, "warriorSD1");

		//contentScaleFactor == 0.3
		//SD2 0.3x(use different textureXML 0.3x)
		//缩放为0.3的贴图，由面板导出时设置scale为0.3输出，textureXML与texture对应

		/*textureAtlas = new StarlingTextureAtlas(
			Texture.fromBitmapData(new WarriorTextureSD2Data().bitmapData, false, false, 0.3), 
			XML(new WarriorTextureSD2XMLData()),
			true
		);*/
		textureAtlas = new TextureAtlas(
			Texture.fromBitmapData(new WarriorTextureSD2Data().bitmapData, false, false, 0.3),
			XML(new WarriorTextureSD2XMLData())
		);

		_factory.addTextureAtlas(textureAtlas, "warriorSD2");

		//
		var armature: Armature;

		armature = _factory.buildArmature("warrior", null, "warrior", "warriorHD");
		armature.display.x = 150;
		armature.display.y = 300;
		//armature.display.scaleX = armature.display.scaleY = 0.3;
		this.addChild(armature.display as Sprite);
		WorldClock.clock.add(armature);
		_armatures.push(armature);

		armature = _factory.buildArmature("warrior", null, "warrior", "warriorSD");
		armature.display.x = 300;
		armature.display.y = 300;
		//armature.display.scaleX = armature.display.scaleY = 0.3;
		this.addChild(armature.display as Sprite);
		WorldClock.clock.add(armature);
		_armatures.push(armature);

		armature = _factory.buildArmature("warrior", null, "warrior", "warriorSD1");
		armature.display.x = 450;
		armature.display.y = 300;
		//armature.display.scaleX = armature.display.scaleY = 0.5;
		this.addChild(armature.display as Sprite);
		WorldClock.clock.add(armature);
		_armatures.push(armature);

		armature = _factory.buildArmature("warrior", null, "warrior", "warriorSD2");
		armature.display.x = 600;
		armature.display.y = 300;
		this.addChild(armature.display as Sprite);
		WorldClock.clock.add(armature);
		_armatures.push(armature);

		changeAnimation();

		this.addEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameHandler);

		_textField = new TextField(700, 50, "Multi-Resolution support. Click mouse to switch animation\nHD  SD  SD1  SD2", "Verdana", 16, 0, true);
		_textField.x = 75;
		_textField.y = 5;
		this.addChild(_textField);
	}

	public function changeAnimation(): void
	{
		var armature: Armature = _armatures[0];
		var animationName: String = armature.animation.animationList[_currentAnimationIndex % armature.animation.animationList.length];
		for each(armature in _armatures)
		{
			armature.animation.gotoAndPlay(animationName);
		}
		_currentAnimationIndex++;
	}

	private function enterFrameHandler(e: EnterFrameEvent): void
	{

		WorldClock.clock.advanceTime(-1);
	}
}