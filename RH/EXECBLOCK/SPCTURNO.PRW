
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

User Function SPCTURNO


PosTurno   :=aScan(aHeader,{|x| AllTrim(x[2])=="PC_TURNO"})
If Empty(aCols[n][Posturno])//TRATAR O ACOLS
    aCols[n][Posturno]:=Posicione("SRA",1,xFilial('SRA')+SPC->PC_MAT,"RA_TNOTRAB" )
EndIf 
 
Return .T.