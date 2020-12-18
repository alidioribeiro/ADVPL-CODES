#include "rwmake.ch"


User Function BPrcVenda()
Local PrecTab:=0

DbSelectArea("DA1")
DbSetOrder(1)
If DbSeek(xFilial("DA1")+C5_TABELA+aCols[n][2]) 
	PrecTab:=DA1->DA1_PRCVEN 
EndIf

Return PrecTab
