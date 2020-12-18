#include "rwmake.ch"        
#INCLUDE "Protheus.ch"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"
#include "shell.ch"

User Function MA110BUT()
Local aButtons := {}
//aadd(aButtons, {'Adiciona Anexo' , {||U_OPFILESC1()}, 'Adiciona Anexo'})
aadd(aButtons, {'Visualiza Anexo', {||U_OPENANEXO()}, 'Visualiza Anexo'})
Return (aButtons)



USER Function OPENANEXO()
local cDir  := Getmv('MV_PATHSC1')
local cFile := cDir+"\"+aCols[n][41]
Local cPar :="" 
Local lVisualiza := .T.
//

IF Empty(cDir)
   Alert("Solicitar ao TI  que o local dos Anexos falta definir MV_PATHSC1!")
   lVisualiza := .F.
ENDIF
IF Empty(cFile)   
   Alert("Este item nao possui anexo para visualiar!")
   lVisualiza := .F.   
ENDIF   
IF lVisualiza
   ShellExecute("Open", Alltrim(cFile), cPar, cDir, 1)
ENDIF   
Return   