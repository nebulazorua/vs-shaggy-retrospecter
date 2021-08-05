local function require(module)
	local file = debug.getinfo(1).source
	local directory = file:sub(2,#file-12)
	-- TODO: _FILEDIRECTORY
	return getfenv().require(directory .. module)
end
local tweenObj = require("tween")
local tweens = {}

function tween(obj,properties,time,style)
    table.insert(tweens,tweenObj.new(time,obj,properties,style))
end
function numLerp(a,b,c)
    return a+(b-a)*c
end
local x = dad.x;
dad.visible=false;
dad.x = -25000;
dad:changeCharacter("ui_shaggy")
dad:changeCharacter("shaggypowerup")
dad:changeCharacter("shaggy")
dad.visible=true;
dad.x=x;

local blackfade = newSprite(-800,-2000, true)
blackfade:loadGraphic('BlackFade')
blackfade.alpha = 0
blackfade:setScale(8)

local p1Receptors = {
    leftPlrNote,
    downPlrNote,
    upPlrNote,
    rightPlrNote,
    midPlrNote,
    left2PlrNote,
    down2PlrNote,
    up2PlrNote,
    right2PlrNote,
}

local p2Receptors = {
    leftDadNote,
    downDadNote,
    upDadNote,
    rightDadNote,
    midDadNote,
    left2DadNote,
    down2DadNote,
    up2DadNote,
    right2DadNote,
}

local camshit = {zoom = getVar("defaultCamZoom")} -- work around for tweening camera zoom
local defaultZoom = getVar("defaultCamZoom");

local desiredSpeed = 60;
local speedRampSteps = 32;
local sh_r = desiredSpeed;

function stepHit()
    if(curStep==2240)then
        blackfade:tween({alpha=1},2,"quadInOut")
        bf:tween({alpha=0},2,"quadInOut")
        gf:tween({alpha=0},2,"quadInOut")
        dad:changeCharacter("shaggypowerup")
        -- WORKAROUND:
        -- since receptors dont have tweens yet, did it with a lua method
        -- gotta add receptor:tween but for now, use tween() for receptors/targets/strums
        for _,receptor in next, p2Receptors do
            tween(receptor,{receptorAlpha=0},2,"inOutQuad");
        end
        tween(camshit,{zoom=1.1},2,"inOutQuad")
        dad.disabledDance=true;
        dad:playAnim("YOUREFUCKED")
    elseif(curStep==2330)then
        dad.disabledDance=false;
        blackfade:tween({alpha=0},.5,"quadInOut")
        bf:tween({alpha=1},.5,"quadInOut")
        gf:tween({alpha=1},.5,"quadInOut")
        tween(camshit,{zoom=defaultZoom},1,"inOutQuad")
        for _,receptor in next, p2Receptors do
            tween(receptor,{receptorAlpha=1},.5,"inOutQuad");
        end
        dad:changeCharacter("ui_shaggy")
    elseif(curStep>=128 and curStep<256)then
        desiredSpeed = 120
    elseif(curStep>=256 and curStep<1344)then
        desiredSpeed = 600
    elseif(curStep>=1344 and curStep<1440)then
        desiredSpeed = 600
    elseif(curStep>=1440 and curStep<1472)then
        desiredSpeed = 60
    elseif(curStep>=1472 and curStep<2224)then
        desiredSpeed = 600;
    elseif(curStep>=2224 and curStep<2496)then
        desiredSpeed = 60;
    elseif(curStep>=2496 and curStep<3840)then
        desiredSpeed = 800;
    elseif(curStep>=3840 and curStep<4608)then
        desiredSpeed = 1900;
    elseif(curStep>=4608)then
        desiredSpeed = 60;
    end
	
	if(curStep==240)then
		tween(camshit,{zoom=1.1},0.2,"inOutQuad")
    elseif(curStep>=256 and curStep<1000)then
        tween(camshit,{zoom=defaultZoom},0.5,"inOutQuad")
	end
	
	if not swayingsmall and (curStep>=256 and curStep<2240)then
		swayingsmall = true;
	elseif swayingsmall and (curStep>=2240) then
		swayingsmall = false;
	end
	
	if not swayingmed and (curStep>=2240 and curStep<2496)then
		swayingmed = true;
		for i=1,#p1Receptors do	
			p1Receptors[i].xOffset = 0
		end
		for i=1,#p2Receptors do	
			p2Receptors[i].xOffset = 0
		end
	elseif swayingmed and (curStep>=2496) then
		swayingmed = false;
	end

	if not swayinglarge and (curStep>=2496 and curStep<3840)then
		swayinglarge = true;
	elseif swayinglarge and (curStep>=3840) then
		swayinglarge = false;
	end

	if not swayingepic and (curStep>=3840 and curStep<4608)then
		swayingepic = true;
	elseif swayingepic and (curStep>=4608) then
		swayingepic = false;
	end
	
	if(curStep>=4608)then
	    leftPlrNote.yOffset = -40
		downPlrNote.yOffset = 40
		upPlrNote.yOffset = -40
		rightPlrNote.yOffset = 40
		midPlrNote.yOffset = -40
		left2PlrNote.yOffset = 40
		down2PlrNote.yOffset = -40
		up2PlrNote.yOffset = 40
		right2PlrNote.yOffset = -40
	
	    leftDadNote.yOffset = -40
		downDadNote.yOffset = 40
		upDadNote.yOffset = -40
		rightDadNote.yOffset = 40
		midDadNote.yOffset = -40
		left2DadNote.yOffset = 40
		down2DadNote.yOffset = -40
		up2DadNote.yOffset = 40
		right2DadNote.yOffset = -40
		
		for i=1,#p1Receptors do	
			p1Receptors[i].xOffset = 0
		end
		for i=1,#p2Receptors do	
			p2Receptors[i].xOffset = 0
		end
	end
end

function dadNoteHit()
    dad.disabledDance=false;
end

function update(elapsed)
    for i = #tweens,1,-1 do
        tweens[i]:update(elapsed)
        if(tweens[i].clock>=tweens[i].duration)then
            table.remove(tweens,i)
        end
	end
    setVar("defaultCamZoom",camshit.zoom)

    sh_r = sh_r+(desiredSpeed-sh_r)/speedRampSteps;

    setVar("sh_r",sh_r);
	
	local currentBeat = (songPosition / 1000)*(bpm/60)
	
	if(swayingsmall or swayingmed or swayinglarge or swayingepic)then
		for i=1,#p1Receptors do
			if(swayingsmall)then
				p1Receptors[i].xOffset = 15*math.sin(currentBeat)
				p1Receptors[i].yOffset = 20*math.cos(currentBeat/2)+10
			end
			if(swayingmed)then
				p1Receptors[i].yOffset = 30*math.cos(currentBeat/2)+10
			end
			if(swayinglarge)then
				p1Receptors[i].xOffset = 32*math.sin(currentBeat*.5)
				p1Receptors[i].yOffset = 35*math.cos(currentBeat)+10
			end
			if(swayingepic)then
				p1Receptors[i].xOffset = 32*math.sin(currentBeat)
				p1Receptors[i].yOffset = 25*math.cos((currentBeat + i)*math.pi)+10
			end
		end
		for i=1,#p2Receptors do
			if(swayingsmall)then
				p2Receptors[i].xOffset = 15*math.sin(currentBeat)
				p2Receptors[i].yOffset = 20*math.cos(currentBeat/2)+10
			end
			if(swayingmed)then
				p2Receptors[i].yOffset = 30*math.cos(currentBeat/2)+10
			end
			if(swayinglarge)then
				p2Receptors[i].xOffset = 32*math.sin(currentBeat*.5)
				p2Receptors[i].yOffset = 35*math.cos(currentBeat)+10
			end
			if(swayingepic)then
				p2Receptors[i].xOffset = 32*math.sin(currentBeat)
				p2Receptors[i].yOffset = 25*math.cos((currentBeat + i)*math.pi)+10
			end
		end
	end
end