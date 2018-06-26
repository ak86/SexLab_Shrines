Scriptname SL_shrinesplayeralias extends ReferenceAlias  

SexLabFramework property SexLab auto

Float LastTimePrayed = 0.0
String File

Event OnInit()
	Maintenance()
EndEvent

Event OnPlayerLoadGame()
	Maintenance()
EndEvent

;for some reason cant detect spells cast by scripts
;Event OnSpellCast(Form akSpell)
;    Debug.Notification("We cast something, but we don't know what it is")
;endEvent

;for some reason cant detect spells cast by scripts
;Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
; 
; 	Debug.Notification("player hit")
;	if (akSource as spell) == Game.GetFormFromFile(0xFB988, "Skyrim.esm") as spell \
;	|| (akSource as spell) == Game.GetFormFromFile(0xFB994, "Skyrim.esm") as spell \
;	|| (akSource as spell) == Game.GetFormFromFile(0xFB995, "Skyrim.esm") as spell \
;	|| (akSource as spell) == Game.GetFormFromFile(0xFB996, "Skyrim.esm") as spell \
;	|| (akSource as spell) == Game.GetFormFromFile(0xFB997, "Skyrim.esm") as spell \
;	|| (akSource as spell) == Game.GetFormFromFile(0xFB998, "Skyrim.esm") as spell \
;	|| (akSource as spell) == Game.GetFormFromFile(0xFB999, "Skyrim.esm") as spell \
;	|| (akSource as spell) == Game.GetFormFromFile(0xFB99A, "Skyrim.esm") as spell \
;	|| (akSource as spell) == Game.GetFormFromFile(0xFB99B, "Skyrim.esm") as spell
;	else
;		return
;	endif

;	SpellCheck(ActorRef) 
;EndEvent

int Function GetCurrentDay()
	float Time = Utility.GetCurrentGameTime() 	; skyrim days spend in game

	int scriptupdatetimes = ((Math.Floor(Time)) - (Math.Floor(LastTimePrayed)))
	if scriptupdatetimes >= 1 
		LastTimePrayed = Time
	endif
	
	;Debug.Notification("scriptupdatetimes " + scriptupdatetimes)
	return scriptupdatetimes
EndFunction

Function Maintenance()
	File = "/SL_Shrines/config.json"
	if JsonUtil.GetErrors(File) != ""
		Debug.Notification("SL_Shrines.Json has errors")
	endif
EndFunction

Function SpellCheck(Form ActorRef)
	;Debug.Notification("SL_Shrines ALTAR USAGE")
	if GetCurrentDay() > 0
		StatChange(self.GetActorRef())
	endif
EndFunction

; can possibly extended to npcs by editing TempleBlessingScript to cast StatChange and adding storageutil array of actors to check if they had blessing this day, would need daily reset
Function StatChange(Actor ActorRef)
    sslActorStats Stats = SexLab.Stats
	;Debug.Notification("SL_Shrines day >0")
	if sslActorStats.IsSkilled(ActorRef)
		if Stats.GetInt(ActorRef, "Lewd") >= JsonUtil.GetIntValue(File, "lewd")
			Stats.SetInt(ActorRef, "Lewd", Stats.GetInt(ActorRef, "Lewd") - JsonUtil.GetIntValue(File, "lewd"))
		endif
		Stats.SetInt(ActorRef, "Pure", Stats.GetInt(ActorRef, "Pure") + JsonUtil.GetIntValue(File, "pure"))
	endif
EndFunction