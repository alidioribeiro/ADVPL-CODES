#include "rwmake.ch" 

/*BEGINDOC
//���������������������������������������������������������D�
//�Ponto de Entrada Executado antes da exclus�o da Nota    �
//�Fiscal de entrada.                                      �
//�A customiza��o exclui as etiquetas geradas para o lote. �
//���������������������������������������������������������D�
ENDDOC*/

User Function SF1100E
Local Chave:=""
dbSelectArea("SF1")
Chave:=xFilial("SF1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA

dbSelectArea("CB0")
dbSetOrder(6)

If DbSeek(Chave)
	While Chave==CB0->CB0_FILIAL+CB0->CB0_NFENT+CB0->CB0_SERIEE+CB0->CB0_FORNEC+CB0->CB0_LOJAFO
		dbSelectArea("CB0")
		RecLock("CB0",.T.)
		dbDelete()
        MsUnlock()   
        dbSkip()
	End
End
Return
