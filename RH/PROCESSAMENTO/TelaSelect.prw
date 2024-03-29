#include "protheus.ch"
#INCLUDE "rwmake.ch" 
#Include "TOPCONN.CH"
#include "ap5mail.ch" 
#include 'fivewin.ch'
#include 'tbiconn.ch' 
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'


User Function TelaSelect

/*컴컴컴컴컴컴컨컴컴컴컴좔컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇 Declara豫o de cVariable dos componentes                                 굇
袂굼컴컴컴컴컴컴컴좔컴컴컴컨컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�*/
Private nCbTipo

/*컴컴컴컴컴컴컨컴컴컴컴좔컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇 Declara豫o de Variaveis Private dos Objetos                             굇
袂굼컴컴컴컴컴컴컴좔컴컴컴컨컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�*/
SetPrvt("oDlg1","oGrp1","oSay1","oCbTipoSol","oSBtn1","oSBtn2")

/*컴컴컴컴컴컴컨컴컴컴컴좔컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇 Definicao do Dialog e todos os seus componentes.                        굇
袂굼컴컴컴컴컴컴컴좔컴컴컴컨컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�*/
oDlgEnt      := MSDialog():New( 230,394,448,847,"Sistema de Controle de Portaria da NSB",,,.F.,,,,,,.T.,,,.T. )
oGrp1      := TGroup():New( 008,008,092,216,"Sistema de Controle de Portaria",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 028,020,{||"Selecione A Rotina:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
oCbTipoSol := TComboBox():New( 036,020,{|u| If(PCount()>0,nCbTipo:=u,nCbTipo)},{"","1- SOLICITACAO DE VISITA","2- SOLICITACAO DE ENTRADA E SAIDA DO FUNCIONARIO","3- SOLICITACAO DE ENTRADA E SAIDA DO VEICULO","4- SOLICITACAO DE SAIDA DE MATERIAIS"},180,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nCbTipo )
oSBtn1     := SButton():New( 060,060,1,{||LinkRot(nCbTipo)},oGrp1,,"", )
oSBtn2     := SButton():New( 060,120,2,{||oDlgEnt:end()},oGrp1,,"", )

oDlgEnt:Activate(,,,.T.)

Return                     
 
/*컴컴컴컴컴컴컨컴컴컴컴좔컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇 Direciona a Rotinas Desejadas.                        굇
袂굼컴컴컴컴컴컴컴좔컴컴컴컨컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�*/ 
Static function LinkRot(nCbTipo)

if nCbTipo =="1- SOLICITACAO DE VISITA"
  U_ES_VITAS()
ElseIf nCbTipo =="2- SOLICITACAO DE ENTRADA E SAIDA DO FUNCIONARIO"
 U_ES_FUNC() 
ElseIf nCbTipo =="3- SOLICITACAO DE ENTRADA E SAIDA DO VEICULO"
 U_Cesv()
ElseIf nCbTipo =="4- SOLICITACAO DE SAIDA DE MATERIAIS"
 U_CESM()
EndIF 
 
return

