#INCLUDE "Protheus.ch"   
#INCLUDE "rwmake.ch"  


User Function MA651GRV 
	DbSelectArea("SC2")	
//	If (SC2->C2_CC='221' .and. SC2->C2_RECURSO='RT-IMP' .and. SC2->C2_TPOP='F')
	If (Substr(SC2->C2_RECURSO,1,2)=='RT' .and. SC2->C2_TPOP=='F')
		Reclock('SC2',.F.)
		SC2->C2_TPOP := "R"
		SC2->(MsunLock())
	EndIf
Return 