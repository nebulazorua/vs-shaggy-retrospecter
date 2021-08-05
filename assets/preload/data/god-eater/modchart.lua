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
local modchartPhase=0;

local desiredSpeed = 60;
local speedRampSteps = 32;
local sh_r = desiredSpeed;
local cameraTHROBBING=true;
function beatHit()
	if(cameraTHROBBING)then
		gameCam.zoom = gameCam.zoom + .025;
		HUDCam.zoom = HUDCam.zoom + .025;
	end
end

local modchartPhases = {
	{step=256,phase=1};
	{step=384,phase=0};
	{step=416,phase=1};
	{step=1184,phase=0};
	{step=1472,phase=1.5};
	{step=2240,phase=1};
	{step=2496,phase=2};
	{step=2784,phase=2.5};
	{step=3352,phase=1.5};
	{step=3640,phase=2};
	{step=3808,phase=1};
	{step=3824,phase=1.5};
	{step=3840,phase=3};
	{step=4608,phase=2.5};
	{step=4736,phase=4};
}

table.sort(modchartPhases,function(a,b)
	return a.step<b.step;
end)

function stepHit()
	local prevPhase=0;
	for i = 1, #modchartPhases do
		local v= modchartPhases[i]
		local step = v.step;
		local phase = v.phase;
		if(curStep<step)then
			break;
		end
		prevPhase=phase;
	end
	modchartPhase = prevPhase;

	if(curStep==1184)then
		cameraTHROBBING=false;
	elseif(curStep==1472 or curStep==2496)then
		cameraTHROBBING=true;
	end
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
		cameraTHROBBING=false;
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
	elseif(curStep==3552)then
		cameraTHROBBING=false;
		blackfade:tween({alpha=1},.5,"quadInOut")
        bf:tween({alpha=0},.5,"quadInOut")
        gf:tween({alpha=0},.5,"quadInOut")
		tween(camshit,{zoom=1.1},2,"inOutQuad")
		for _,receptor in next, p1Receptors do
            tween(receptor,{receptorAlpha=0},.5,"inOutQuad");
        end
		for _,receptor in next, p2Receptors do
            tween(receptor,{alpha=0},.5,"inOutQuad");
        end
	elseif(curStep==3632)then
		blackfade:tween({alpha=0},.5,"quadInOut")
        bf:tween({alpha=1},.5,"quadInOut")
        gf:tween({alpha=1},.5,"quadInOut")
		tween(camshit,{zoom=defaultZoom},1,"inOutQuad")
		for _,receptor in next, p1Receptors do
            tween(receptor,{receptorAlpha=1},.5,"inOutQuad");
        end
		for _,receptor in next, p2Receptors do
            tween(receptor,{alpha=1},.5,"inOutQuad");
        end
		cameraTHROBBING=true;
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

local shakeShit = 0;

function dadNoteHit()
	if(curStep>2464)then
		if(shakeShit>0)then
			shakeShit=shakeShit + 1
		else
			shakeShit = 3;
		end
		bf:playAnim("scared");
	end
	if(curStep>=2368 and curStep<=2464 or curStep>=4736 and curStep<=4864)then
		gameCam.zoom = gameCam.zoom + .05;
		HUDCam.zoom = HUDCam.zoom + .05;
		shakeShit = shakeShit + 2
	end
    dad.disabledDance=false;
end

function applyArrowMovement(receptors)
	local currentBeat = (songPosition / 1000)*(bpm/60)
	for i=1,#receptors do
		local xOffset = receptor.xOffset;
		local yOffset = receptor.yOffset;
		local receptor = receptors[i];
		if(modchartPhase==1)then
			xOffset = 15*math.sin(currentBeat)
			yOffset = 20*math.cos(currentBeat/2)+10
		end
		if(modchartPhase==1.5)then
			xOffset = 20*math.sin((currentBeat*3)+i)
			yOffset = 30*math.cos(currentBeat)
		end
		if(modchartPhase==2)then
			if(receptors==p1Receptors)then
				i = i + 9;
			end
			xOffset = 30*math.sin(currentBeat*2) + math.cos(currentBeat*i)*4
			yOffset = (30*math.cos(currentBeat+i/4)) + math.sin(currentBeat*i)*4
		end
		if(modchartPhase==2.5)then
			if(receptors==p1Receptors)then
				i = i + 9;
			end
			xOffset = 30*math.sin((currentBeat*2)+i/2)
			yOffset = 60*math.cos(currentBeat+i)
		end
		if(modchartPhase==3)then
			xOffset = 32*math.sin(currentBeat*.5)
			yOffset = 35*math.cos(currentBeat)+10
		end
		if(modchartPhase==4)then
			xOffset = 32*math.sin(currentBeat+i)
			yOffset = 25*math.cos((currentBeat + i)*math.pi)+10
		end
		if(modchartPhase==0)then
			xOffset = 0
			yOffset = 0
		end

		receptors[i].xOffset = numLerp(receptors[i].xOffset,xOffset,.5)
	end
end

function update(elapsed)
	if(shakeShit>0)then
		shakeShit = shakeShit-.35;
	end
	if(shakeShit<0)then shakeShit=0 end

	HUDCam.angle = math.random(-shakeShit*100,shakeShit*100)/100;
	gameCam.angle = math.random(-shakeShit*100,shakeShit*100)/100;

    for i = #tweens,1,-1 do
        if(tweens[i]:update(elapsed))then
            table.remove(tweens,i)
        end
	end
    setVar("defaultCamZoom",camshit.zoom)

    sh_r = sh_r+(desiredSpeed-sh_r)/speedRampSteps;

    setVar("sh_r",sh_r);

	applyArrowMovement(p1Receptors);
	applyArrowMovement(p2Receptors);
	print'applied'
end