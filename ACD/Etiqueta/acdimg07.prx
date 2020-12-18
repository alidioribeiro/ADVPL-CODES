/*
Padrao Zebra
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMG07     บAutor  ณRicardo             บ Data ณ  10/07/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada referente a imagem de identificacao do     บฑฑ
ฑฑบ          ณvolume (entrada)                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP5                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Img07   // imagem de etiqueta de volume (entrada)
Local cVolume := paramixb[1]
Local cNota   := paramixb[2]
Local cSerie  := paramixb[3]
Local cForn   := paramixb[4]
Local cLoja   := paramixb[5]
Local cID
Local nX
Local sConteudo
IF UsaCB0("07")
	cID := CBGrvEti('07',{cVolume,cNota,cSerie,cForn,cLoja})
	nX  := 22
Else
	cID := cNota+cSerie+cForn+cLoja
	nX  := 10
EndIf
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
MSCBSAY(05,14,'NOTA :'+cNota+' '+cSerie,"N","0","025,035",.T.)
MSCBSAY(05,17,'FORNECEDOR:'+Posicione('SA2',1,xFilial("SA2")+paramixb[4]+paramixb[5],"A2_NREDUZ"),"N","0","025,035",.T.)
MSCBSAYBAR(nX,22,cId,"N","MB07",8.36,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.T.)
MSCBInfoEti("Volume Entrada","30X100")
sConteudo:=MSCBEND()
Return sConteudo