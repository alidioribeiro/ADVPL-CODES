#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 08/03/02
#include "topconn.ch"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
//--MA410MNU
User Function MTA200MNU
Local aBotao:={}

Pos := len(ARotina)

AAdd( aRotina, {"PSMT","U_PSMT", 0, Pos, 0, nil})

Return
//************************************************************************************************/
//Rotina Principal de Cópia de Prés-Estrutura*****************************************************/
//Desenvolvedor:Aglair Brito Ishii    ************************************************************/
//************************************************************************************************/

User Function TransfPre ()

Private cCodEst
Private Estru:={}
SetPrvt("oDlg1","oSay1","oGet1","oSBtn1")

nEstru  := 0
_aPSMT := {'HP0804001K0CX0Z','HP0922003K0CX00','HP0985001N0CE04','HP0985001N0CE0Z','HP0985002N0CE04','HP0985002N0CE0Z','HP1005001N0CE03','HP1005001N0CE0Z',;
'HP1022001N0CD0Z','HP1022001N0CE08','HP1022002N0CD0Z','HP1022002N0CE08','HP1022003N0CD0Z','HP1022003N0CE00','HP1077001N0CD0Z','HP1077001N0CE02',;
'HP1080001N0CD0Z','HP1080001N0CE07','HP1080002N0CD0Z','HP1080002N0CE07','HP1080003N0CD0Z','HP1080003N0CE07','HP1081101N0CE00','HP1083001N0CD0Z',;
'HP1083001N0CE02','HP1087001N0CE03','HP1089001N0CD0Z','HP1089011N0CE00','HP1114001N0CE00','HP1132001N0CE02','HP1163001N0CE0A','YA1098001K0CX04',;
'YA1098001K0CX0Z','YA1098011K0CX00','YA1098111K0CX00','YA1098121K0CX00','YA1145001K0CE02','YA1148001K0CE02','YA1149001K0CE02','YA1149002K0CE00',;
'YA1153001K0CE02','YA1167001K0CE01','YA1172001K0CE02','YA1193001K0CE01'}

For i:=1 To Len(_aPSMT)
	cCodEst := _aPSMT[i]
	ConfCop()
Next

REturn
//
//
//
Static Function ValidEst

Local lRet:=.T.

PosE:=Posicione("SG1",1,xFilial("SG1")+cCodEst,"G1_COD")
PosPre:=Posicione("SGG",1,xFilial("SGG")+cCodEst,"GG_COD")

If Len(Alltrim(PosE))=0
	Alert("Esse produto não possui Estrutura")
	lRet:=.F.
End
If Len(Alltrim(PosPre))>0
	Alert("Já existe na Pré-Estrutura essa Estrutura")
	lRet:=.F.
EndIf

Return lRet
//
//
//
Static Function ConfCop()
Local AuxEst
If ValidEst()
	cNomeArq := Estrut2(cCodEst,1,,,.T.)
	dbSelectArea('ESTRUT')
	ESTRUT->(dbGotop())
	While !ESTRUT->(Eof())
		Aadd(Estru,{CODIGO,COMP,QUANT,TRT,GROPC,OPC})
		DbSkip()
	EndDo
	FimEstrut2(Nil,cNomeArq)
	GerSGG()
Endif
Return
//
//
//
Static Function GerSGG()
DbSelectArea("SGG")
DbSetOrder(1)
DbSelectArea("SG1")
DbSetOrder(1)
ProcRegua(len(Estru))
For i:=1 to len(Estru)
	IncProc()
	DbSelectArea("SGG")
	if !DbSeek(xFilial("SGG")+Estru[i][1]+Estru[i][2]+Estru[i][4])
		
		DbSelectArea("SG1")
		if DbSeek(xFilial("SG1")+Estru[i][1]+Estru[i][2]+Estru[i][4])
			RecLock("SGG",.T.)
			SGG->GG_FILIAL	:=SG1->G1_FILIAL
			SGG->GG_COD	:=SG1->	G1_COD
			SGG->GG_COMP	:=SG1->	G1_COMP
			SGG->GG_TRT	:=SG1->	G1_TRT
			SGG->GG_QUANT	:=SG1->	G1_QUANT
			SGG->GG_PERDA	:=SG1->	G1_PERDA
			SGG->GG_INI	:=SG1->	G1_INI
			SGG->GG_FIM	:=SG1->	G1_FIM
			SGG->GG_NIV	:=SG1->	G1_NIV
			SGG->GG_OBSERV	:=SG1->	G1_OBSERV
			SGG->GG_FIXVAR	:=SG1->	G1_FIXVAR
			SGG->GG_NIVINV	:=SG1->	G1_NIVINV
			SGG->GG_GROPC	:=SG1->	G1_GROPC
			SGG->GG_REVINI	:=SG1->	G1_REVINI
			SGG->GG_OPC	:=SG1->	G1_OPC
			SGG->GG_REVFIM	:=SG1->	G1_REVFIM
			SGG->GG_POTENCI	:=SG1->	G1_POTENCI
			SGG->GG_OK  	:=SG1->	G1_OK
			SGG->GG_USUARIO	:="COP. ESTR"
			SGG->GG_STATUS  :="1"
			MsUnlock()
		EndIf
	Endif
Next

Return
/****************************************************************************/
/****************************************************************************/
