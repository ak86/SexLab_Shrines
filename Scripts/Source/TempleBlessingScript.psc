Scriptname TempleBlessingScript extends ObjectReference Conditional  

Spell Property TempleBlessing  Auto  

Event OnActivate(ObjectReference akActionRef)

	TempleBlessing.Cast(akActionRef, akActionRef)
	if akActionRef == Game.GetPlayer()
		AltarRemoveMsg.Show()
		BlessingMessage.Show()
		
		;SL_Shrines
		quest SL_Shrines = Quest.GetQuest("SL_Shrines")
		SL_shrinesplayeralias AliasRef = (SL_Shrines.GetAlias(0) as SL_shrinesplayeralias)
		AliasRef.SpellCheck(akActionRef)
	endif

EndEvent

Message Property BlessingMessage  Auto  

Message Property AltarRemoveMsg  Auto  
