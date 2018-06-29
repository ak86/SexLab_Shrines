Scriptname DLC2TempleShrineScript extends ObjectReference  

Spell Property TempleBlessing  Auto  

Event OnActivate(ObjectReference akActionRef)

	TempleBlessing.Cast(akActionRef, akActionRef)
	if akActionRef == Game.GetPlayer()
		AltarRemoveMsg.Show()
		BlessingMessage.Show()
	endif
		
	;JsonUtil.FormListAdd("/SL_Shrines/config.json", "shrine_of_talos", TempleBlessing)
	;JsonUtil.Save("/SL_Shrines/config.json", false)
	;SL_Shrines
	quest SL_Shrines = Quest.GetQuest("SL_Shrines")
	SL_shrinesplayeralias AliasRef = (SL_Shrines.GetAlias(0) as SL_shrinesplayeralias)
	AliasRef.SpellCheck(akActionRef as form, self.GetBaseObject() as form)

EndEvent

Message Property BlessingMessage  Auto  

Message Property AltarRemoveMsg  Auto  