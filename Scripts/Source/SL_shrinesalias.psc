Scriptname SL_shrinesalias extends ReferenceAlias 

Float LastTimePrayed = 0.0
String File

Event OnInit()
	Maintenance()
EndEvent

Event OnPlayerLoadGame()
	Maintenance()
EndEvent

int Function GetCurrentDay()
	float Time = Utility.GetCurrentGameTime() 	; skyrim days spend in game

	int scriptupdatetimes = ((Math.Floor(Time)) - (Math.Floor(LastTimePrayed)))
	if scriptupdatetimes >= 1 
		LastTimePrayed = Time
	endif
	
	;Debug.Notification("scriptupdatetimes " + scriptupdatetimes)
	RegisterForSingleUpdateGameTime(24)
	
	return scriptupdatetimes
EndFunction

Function Maintenance()
	File = "/SL_Shrines/config.json"
	RegisterForSingleUpdateGameTime(24)
EndFunction

Event OnUpdateGameTime()
	if self.GetActorRef() != game.GetPlayer() && self.GetActorRef() != none
		self.Clear()
		;Debug.Notification(self.GetID() + " shrine alias cleared")
	endif
endEvent

Function SpellCheck(Form ActorRef, Form Shrine)
	if GetCurrentDay() > 0
		;Debug.Notification(self.GetActorRef().GetDisplayName() + " Changing stats...")
		StatChange(self.GetActorRef(), Shrine)
	else
		Debug.Notification(self.GetActorRef().GetDisplayName() + " Already used shrine today")
	endif
EndFunction

Function StatChange(Actor ActorRef, Form Shrine)
	SexLabFramework SexLab = Quest.GetQuest("SexLabQuestFramework") as SexLabFramework
	sslActorStats Stats = SexLab.Stats
	;Debug.Notification("SL_Shrines day >0")
	if sslActorStats.IsSkilled(ActorRef)
		string keyname = ""
				
		;Dawnguard DLC1
		if Shrine == Game.GetFormFromFile(0xC86B, "Dawnguard.esm")
			keyname	= "shrine_of_auriel"
			
		;Dragonborn DLC2
		elseif Shrine == Game.GetFormFromFile(0x3A484, "Dragonborn.esm")
			keyname	= "shrine_of_azura"
		elseif Shrine == Game.GetFormFromFile(0x39E34, "Dragonborn.esm")
			keyname	= "shrine_of_boethiah"
		elseif Shrine == Game.GetFormFromFile(0x3A481, "Dragonborn.esm")
			keyname	= "shrine_of_mephala"
			
		;Skyrim
		elseif Shrine == Game.GetFormFromFile(0xD9883, "Skyrim.esm")
			keyname	= "shrine_of_akatosh"
		elseif Shrine == Game.GetFormFromFile(0x71854, "Skyrim.esm")
			keyname	= "shrine_of_arkay"
		elseif Shrine == Game.GetFormFromFile(0xD9881, "Skyrim.esm")
			keyname	= "shrine_of_dibella"
		elseif Shrine == Game.GetFormFromFile(0xD9885, "Skyrim.esm")
			keyname	= "shrine_of_julianos"
		elseif Shrine == Game.GetFormFromFile(0xD987F, "Skyrim.esm")
			keyname	= "shrine_of_kynareth"
		elseif Shrine == Game.GetFormFromFile(0xD9887, "Skyrim.esm")
			keyname	= "shrine_of_mara"
		elseif Shrine == Game.GetFormFromFile(0x10E8B0, "Skyrim.esm")
			keyname	= "shrine_of_nocturnal"
		elseif Shrine == Game.GetFormFromFile(0xD987D, "Skyrim.esm")
			keyname	= "shrine_of_stendarr"
		elseif Shrine == Game.GetFormFromFile(0x100780, "Skyrim.esm")
			keyname	= "shrine_of_talos"
		elseif Shrine == Game.GetFormFromFile(0xD987B, "Skyrim.esm")
			keyname	= "shrine_of_zenithar"
		else
			Debug.Notification("Not supported shrine " + Shrine.getName())
			return
		endif
		
		float pure = JsonUtil.IntListGet(File, keyname, 0) as float
		float lewd = JsonUtil.IntListGet(File, keyname, 1) as float
		spell spelltocast = JsonUtil.FormListGet(File, keyname, Utility.RandomInt(0, JsonUtil.FormListCount(File, keyname) - 1)) as spell
		string texttoshow = JsonUtil.StringListGet(File, keyname, Utility.RandomInt(0, JsonUtil.StringListCount(File, keyname) - 1)) as string
		
;		Debug.Notification("Pure float before " + keyname + " " + Stats.GetFloat(ActorRef, "Pure") + " adjust " + Pure)
		if Stats.GetFloat(ActorRef, "Pure") >= -pure
			Stats.AdjustFloat(ActorRef, "Pure", pure)
		endif
;		Debug.Notification("Pure float after " + Stats.GetFloat(ActorRef, "Pure"))

;		Debug.Notification("Lewd float before " + keyname + " " + Stats.GetFloat(ActorRef, "Lewd") + " adjust " + lewd)
		if Stats.GetFloat(ActorRef, "Lewd") >= lewd
			Stats.AdjustFloat(ActorRef, "Lewd", -lewd)
		endif
;		Debug.Notification("Lewd float after " + Stats.GetFloat(ActorRef, "Lewd"))
		
		if texttoshow != "" && ActorRef == Game.GetPlayer()
			Debug.Notification(texttoshow)
;		else
;			Debug.Notification("no text")
		endif
		
		if spelltocast != none
			spelltocast.cast(ActorRef)
;		else
;			Debug.Notification("no spell")
		endif
		
	endif
EndFunction