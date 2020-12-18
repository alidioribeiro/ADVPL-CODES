/*
Padrao Zebra
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMG08     ºAutor  ³Anderson Rodrigues  º Data ³  07/11/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Ponto de entrada referente a imagem de identificacao do     º±±
±±º          ³Recurso                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³AP6                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Img08  // imagem da etiqueta do recurso
Local cCodigo := Alltrim(SH1->H1_CODIGO)
Local nCopias := Val(paramixb[1])

MSCBLOADGRF("SIGA.GRF")
MSCBBEGIN(nCopias,6)
MSCBBOX(30,05,76,05)
MSCBBOX(02,12.7,76,12.7)
MSCBBOX(02,21,76,21)
MSCBBOX(30,01,30,12.7,3)
MSCBGRAFIC(2,3,"SIGA")
MSCBSAY(33,02,'RECURSO',"N","0","025,035",,,,,.t.)
MSCBSAY(33,06,"CODIGO","N","A","012,008")
MSCBSAY(33,08, cCodigo, "N", "0", "032,035")
MSCBSAY(05,14,"DESCRICAO","N","A","012,008")
MSCBSAY(05,17,SH1->H1_DESCRI,"N", "0", "020,030")
MSCBSAYBAR(23,22,cCodigo,"N","MB07",8.36,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.T.)
MSCBInfoEti("Recurso","30X100")
MSCBEND()
Return .F.