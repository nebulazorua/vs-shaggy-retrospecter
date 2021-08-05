dad:changeCharacter("ui_shaggy")
dad:changeCharacter("shaggypowerup")
dad:changeCharacter("shaggy")

function stepHit()
	if(curStep==4)then
		dad:changeCharacter("shaggypowerup")
		dad:playAnim("YOUREFUCKED",true)
		dad.disabledDance=true;
	elseif(curStep==5)then
		dad.y = dad.y - 200;
	elseif(curStep==64)then
		dad.disabledDance=false;
		dad:changeCharacter("ui_shaggy")
	end
end