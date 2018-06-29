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

Function SpellCheck(Form ActorRef, Form Shrine)
	Debug.Notification("shrine " + Shrine.getName())
	;Debug.Notification("SL_Shrines ALTAR USAGE")
	if ActorRef == game.GetPlayer()
		if GetCurrentDay() > 0
			StatChange(self.GetActorRef())
		endif
	endif
EndFunction

; can possibly extended to npcs by editing TempleBlessingScript to cast StatChange and adding storageutil array of actors to check if they had blessing this day, would need daily reset
Function StatChange(Actor ActorRef)
    sslActorStats Stats = SexLab.Stats
	;Debug.Notification("SL_Shrines day >0")
	if sslActorStats.IsSkilled(ActorRef)
		Debug.Notification("Lewd float" + Stats.GetFloat(ActorRef, "Lewd"))
		if Stats.GetFloat(ActorRef, "Lewd") >= JsonUtil.GetIntValue(File, "lewd") as float
			Stats.SetFloat(ActorRef, "Lewd", Stats.GetFloat(ActorRef, "Lewd") - JsonUtil.GetIntValue(File, "lewd") as float)
		endif
		Stats.SetFloat(ActorRef, "Pure", Stats.GetFloat(ActorRef, "Pure") + JsonUtil.GetIntValue(File, "pure") as float)
		Debug.Notification("Lewd float" + Stats.GetFloat(ActorRef, "Lewd"))
	endif
EndFunction