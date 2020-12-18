/*
Padrao Zebra
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMG03     ºAutor  ³Sandro Valex        º Data ³  19/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada referente a imagem de dispositivo de movi- º±±
±±º          ³mentacao.(carrinho)                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Img03 // imagem de etiqueta de dispositivo de movimentacao
Local cCodigo
Local nID := paramixb[1]
IF nID # NIL
	cCodigo := nID
ElseIf Empty(CB2->CB2_IDETIQ)
	IF UsaCB0("03")
		cCodigo := CBGrvEti('03',{CB2->CB2_DISPID})
		RecLock("CB2",.F.)
		CB2->CB2_IDETIQ := cCodigo
		MsUnlock()
	Else
		cCodigo := CB2->CB2_DISPID
	EndIf
Else
	IF UsaCB0("03")
		cCodigo := CB2->CB2_IDETIQ
	Else
		cCodigo := CB2->CB2_DISPID
	EndIf
Endif
cCodigo := Alltrim(cCodigo)
MSCBLOADGRF("SIGA.GRF")
MSCBBEGIN(1,6)
MSCBBOX(30,05,76,05)
MSCBBOX(02,12.7,76,12.7)
MSCBBOX(02,21,76,21)
MSCBBOX(30,01,30,12.7,3)
MSCBGRAFIC(2,3,"SIGA")
MSCBSAY(33,02,'DISP.MOVIMENT',"N","0","025,035",,,,,.t.)
MSCBSAY(33,06,"CODIGO","N","A","012,008")
MSCBSAY(33,08, CB2->CB2_DISPID, "N", "0", "032,035")
MSCBSAY(05,14,"DESCRICAO","N","A","012,008")
MSCBSAY(05,17,Tabela('J0',CB2->CB2_TIPO),"N", "0", "020,030")
MSCBSAYBAR(23,22,cCodigo,"N","MB07",8.36,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.T.) 
MSCBInfoEti("Disp.Moviment.","30X100")
MSCBEND()
Return .F.