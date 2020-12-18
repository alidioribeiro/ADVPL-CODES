#include "rwmake.ch" 

User Function PLNSD3()
SetPrvt("CSTRING,_CPERG,CARQTXT,NHDLARQ")
SetPrvt("_CGRAVA,XMODELO,XLINHA,XI,XQTD")



@ 96,42 TO 323,505 DIALOG oDlg5 TITLE "Rotina de Atualização do Plano de Contas."
@ 8,10 TO 84,222
@ 91,168 BMPBUTTON TYPE 1 ACTION OkProc()
@ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg5)
@ 23,14 SAY "Este programa tem como objetivo, atualizar o Plano de contas"
ACTIVATE DIALOG oDlg5

Return nil

Static Function OkProc()
   Close(oDlg5)
   Processa( { || RunProc() }, "Processando...")
Return

Static Function RunProc()

use \DADOSADV\plano02 alias "PLN" EXCLUSIVE NEW
xFora := {}
Index ON ANTIGA to PLN 
dbselectarea("PLN")
dbgotop()
dbSelectArea("SD3")
set filter to DTOS(D3_EMISSAO)>="20040201" .AND. !EMPTY(D3_CONTA)
ProcRegua(RecCount())
DBGOTOP()
While !Eof()


      IncProc("Conta: "+D3_CONTA+"  Data:"+DTOC(D3_EMISSAO))
      dbselectarea("PLN")
      DBSEEK(SD3->D3_CONTA)
      dbSelectArea("SD3")     
      If AllTrim(D3_CONTA) $ AllTrim(PLN->ANTIGA) .and. AllTrim(D3_CONTA)<>""
               RecLock("SD3",.F.)
               SD3->D3_CONTA := PLN->NOVA
               MsUnlock()
      EndIf
      dbSkip()
      
EndDo
dbselectarea("PLN")
dbCloseArea()
If !(Type('ArqNtx') == 'U')
	fErase(cArqNtx)
Endif
Return
