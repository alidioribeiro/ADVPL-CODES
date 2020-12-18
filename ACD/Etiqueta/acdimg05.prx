/*
Padrao Zebra
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMG05     ºAutor  ³Sandro Valex        º Data ³  19/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada referente a imagem de identificacao do     º±±
±±º          ³volume temporario                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Img05   // imagem de etiqueta de volume temporaria
Local cVolume := paramixb[1]
Local cPedido := paramixb[2]
Local cNota   := IF(len(paramixb)>=3,paramixb[3],nil)
Local cSerie  := IF(len(paramixb)>=4,paramixb[4],nil)
Local cID := CBGrvEti('05',{cVolume,cPedido,cNota,cSerie})
Local sConteudo

MSCBLOADGRF("SIGA.GRF")
MSCBBEGIN(1,6)
MSCBBOX(30,05,76,05)
MSCBBOX(02,12.7,76,12.7)
MSCBBOX(02,21,76,21)
MSCBBOX(30,01,30,12.7,3)
MSCBGRAFIC(2,3,"SIGA")
MSCBSAY(33,02,"VOLUME","N","0","025,035")
MSCBSAY(33,06,"CODIGO","N","A","012,008")
MSCBSAY(33,08, cVolume, "N", "0", "032,035")
If cNota==NIL
	MSCBSAY(05,14,"PEDIDO","N","A","012,008")
	MSCBSAY(05,17,cPedido,"N", "0", "020,030")
Else
	MSCBSAY(05,14,"NOTA","N","A","012,008")
	MSCBSAY(05,17,cNota+' '+cSerie,"N", "0", "020,030")
EndIf
MSCBSAYBAR(23,22,cId,"N","MB07",8.36,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.T.)
MSCBInfoEti("Volume Temp.","30X100")
sConteudo:=MSCBEND()
Return sConteudo

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMG05OFI  ºAutor  ³Sandro Valex        º Data ³  19/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada referente a imagem de identificacao do     º±±
±±º          ³volume permanente."Oficial"                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Img05OFI // imagem de etiqueta de volume permanente (OFICIAL)
Local cId     := CBGrvEti('05',{CB6->CB6_VOLUME,CB6->CB6_PEDIDO})
Local nTotEti := paramixb[1]
Local nAtu    := paramixb[2]
MSCBBEGIN(1,6)
MSCBBOX(06,00,06,76)
MSCBBOX(19,00,19,76)
MSCBBOX(27,00,27,76)
MSCBBOX(35,00,35,76)
MSCBSAY(03,24,"VOLUME","B","0","025,035")
MSCBSAYBAR(07,02,AllTrim(cId),"B","MB07",8.36,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.T.)
MSCBSAY(20,30,"PEDIDO","B","A","012,008")
MSCBSAY(23,25,CB6->CB6_PEDIDO,"B", "0", "032,035")
MSCBSAY(28,30,"CODIGO","B","A","012,008")
MSCBSAY(31,17,CB6->CB6_VOLUME,"B", "0", "032,035")
MSCBSAY(55,07,StrZero(nAtu,2)+"/"+StrZero(nTotEti,2),"B","0","040,055")
MSCBInfoEti("Volume Oficial","30X100")
MSCBEND()
Return .f.