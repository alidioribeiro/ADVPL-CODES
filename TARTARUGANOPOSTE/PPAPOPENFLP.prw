#include "rwmake.ch"        
#INCLUDE "Protheus.ch"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"
#include "shell.ch"

User Function PAPOPEN(cArea)
local cFile := IIF(cArea = "QKK" , M->QKK_FLP , M->QKN_FLP)
local cDir  := Getmv('MV_PATHFLP')
Local lVisualiza := .T.
Local cPar :=""

//

IF Empty(cDir)
   Alert("Informar ao TI o Caminho padrao para as imagens/PDF para o PARAMETRO -> MV_PATHFLP")
   lVisualiza := .F.
ENDIF
IF Empty(cFile)   
   Alert("Informar ao TI o Caminho padrao para as imagens/PDF para o PARAMETRO -> MV_PATHFLP")
   lVisualiza := .F.   
ENDIF   
IF lVisualiza
   ShellExecute("Open", Alltrim(cFile), cPar, cDir, 1)
ENDIF   

Return ''