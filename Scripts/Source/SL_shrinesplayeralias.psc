Scriptname SL_shrinesplayeralias extends ReferenceAlias 

Event OnInit()
	Maintenance()
EndEvent

Event OnPlayerLoadGame()
	Maintenance()
EndEvent

Function Maintenance()
	string File = "/SL_Shrines/config.json"
	if JsonUtil.GetErrors(File) != ""
		Debug.Notification("/SL_Shrines/config.json has errors, mod wont work")
	endif
EndFunction

Function SpellCheck(Form ActorRef, Form Shrine)
	;Debug.Notification("SL_Shrines ALTAR USAGE: " + Shrine.getName())
	quest SL_Shrines = Quest.GetQuest("SL_Shrines")
	if ActorRef == game.GetPlayer()
		;Debug.Notification(" player alias")
		SL_shrinesalias AliasRef = (SL_Shrines.GetAlias(0) as SL_shrinesalias)
		AliasRef.SpellCheck(ActorRef, Shrine)
	else
		int AliasCount = SL_Shrines.GetNumAliases()
		int i = 1
		
		while i < AliasCount
			Actor AliasRef = (SL_Shrines.GetAlias(i) as ReferenceAlias).GetActorRef()
			if AliasRef as actor == ActorRef
				;Debug.Notification(" existing alias")
				SL_shrinesalias SL_AliasRef = (SL_Shrines.GetAlias(i) as SL_shrinesalias)
				SL_AliasRef.SpellCheck(ActorRef, Shrine)
				return
			endif
			i += 1
		endwhile
		
		i = 1
		while i < AliasCount
			Actor AliasRef = (SL_Shrines.GetAlias(i) as ReferenceAlias).GetActorRef()
			if AliasRef == none
				;Debug.Notification(" new alias")
				(SL_Shrines.GetAlias(i) as ReferenceAlias).ForceRefTo(ActorRef as actor)
				SL_shrinesalias SL_AliasRef = (SL_Shrines.GetAlias(i) as SL_shrinesalias)
				SL_AliasRef.SpellCheck(ActorRef, Shrine)
				return
			endif
			i += 1
		endwhile
	endif
EndFunction