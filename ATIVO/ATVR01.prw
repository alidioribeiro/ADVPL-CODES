#include "rwmake.ch"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณATVR01    บAutor  ณJefferson Moreira   บ Data ณ  03/15/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Esse programa tem o objetivo de imprimir as plaquetas com  บฑฑ
ฑฑบ          ณ o codigo de barra dos ativos fixos conforme parametros     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Sigaatf                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function ATVR01()

Private oDlg := Nil

Pergunte("ATVR01",.F.)

// Do Codigo              mv_par01
// Ate o Codigo           mv_par02
// Do Grupo               mv_par03
// Ate o Grupo            mv_par04
// Porta da Impressora    mv_par05
// Da Aquisicao           mv_par06
// Ate a Aquisicao        mv_par07
// De Local. Fisica       mv_par08
// Ate Local. Fisica      mv_par09


@ 96,42 TO 323,505 DIALOG oDlg TITLE "Etiquetas de Ativos"
@ 8,10 TO 84,222
@ 94,133 BMPBUTTON TYPE 5 ACTION Pergunte("ATVR01")
@ 94,163 BMPBUTTON TYPE 1 ACTION ImpEtq()
@ 94,193 BMPBUTTON TYPE 2 ACTION Close(oDlg)
@ 23,14 SAY "Este programa tem como objetivo, imprimir as etiquetas com o"
@ 33,14 SAY "c๓digo de barras do itens do Ativo Fixo, conforme Paramentro"
@ 43,14 SAY "especificado pelo usuแrio."
@ 53,14 SAY ""
ACTIVATE DIALOG oDlg

Return nil

Static Function ImpEtq()  

If mv_par05==1
	cPorta := "COM1:9600,n,8,2"
ElseIf  mv_par05==2
	cPorta := "LPT1"
ElseIF  mv_par05==3  
	cPorta := "USB001"
EndIf

xCON := 0
XCON_:= 1

MSCBPRINTER("ELTRON",cPorta,,,.F.,,,,) 
//MSCBPRINTER("Zebra","USB001",,,.F.,,,,)
MSCBCHKStatus(.F.)
dbSelectArea("SN1")
dbSetOrder(1)
dbSeek(xFilial("SN1")+mv_par01,.T.)
While !Eof() .and. N1_CBASE <= mv_par02
	  
	  If N1_GRUPO < mv_par03 .or. N1_GRUPO > mv_par04 
		 dbSkip()
		 Loop
	  EndIf
	  
	  If N1_AQUISIC < mv_par06 .or. N1_AQUISIC > mv_par07
	   	 dbSkip()
		 Loop
	  EndIf
	  
	  If N1_local < MV_PAR08 .or. N1_local > MV_PAR09
	   	 dbSkip()
		 Loop
	  EndIf
	  
	     xCON_:= 0
	  
	  IF N1_IMPRETQ == "S"
	  
//	     MSCBBEGIN(1,8)
//	     MSCBSAYBAR(033,006,Alltrim(N1_CODBAR),"N","1",7,.F.,.F.,,,3,6,.T.,,,)
//	     MSCBEND() 

         MSCBBEGIN(1,15)
	     MSCBSAYBAR(039,005,Alltrim(N1_CODBAR),"L","1",6,.T.,.T.,,,2,0,.T.,,,)
	     MSCBEND()
	     
	     xCON := 1
      ENDIF
	  dbSkip()
EndDo    

xCON_ += xCON

IF xCON_ == 0  
   MSGSTOP (" TODOS OS ATIVOS ESTAM COM O CAMPO IMPRETQ = *N* ...FAVOR ESCOLHA OUTRO RANGE ") 
   RETURN
ENDIF

IF xCON == 0   
   MSGSTOP (" NรO Hม ATIVOS NO PARAMENTRO ESPECIFICADO... FAVOR INSIRA OUTRO PARAMETRO !!! ") 
   RETURN
ENDIF

MSCBCLOSEPRINTER()
Return

/*MSCBPRINTER("ELTRON",cPorta,,,.F.,,,,)
MSCBCHKStatus(.F.)
MSCBBEGIN(1,6)
MSCBBOX(008,008,106,155)
MSCBLineV(038,008,032)
MSCBSAY(010,011,"KRM"                                  ,"N","5" ,"2,3")
MSCBSAY(039,012,"HP0582002A0C003"                      ,"N","2" ,"2,2")
MSCBSAY(083,012,"001/01"                               ,"N","2" ,"1,2")
MSCBSAY(039,019,"CJ. CARCACA SUP"  ,"N","2" ,"2,2")
MSCBSAY(039,025,"               "               ,"N","2" ,"2,2")
MSCBSAY(083,025,SubStr(Time(),1,5)                     ,"N","2" ,"1,2")
MSCBLineH(08,32,98,4)
For I:=1 TO 3 //While !Eof() .And. cOP+cCar==ZA_OPNUM+ZA_KAMBAN
/*	IF (ALLTRIM(ZA_CCUSTO)$"INJECAO/INJETORA")
DBskip()
Loop
EndIf/*
MSCBSAY(010,034+xPos,"OP: 1109050500101","N","1","2,3")
MSCBSAY(010,039+xPos,"221     "                                    ,"N","1","2,2")
MSCBLineV(066,032     ,055+xPos)
MSCBLineH(066,040+xPos,98,3,"B")
MSCBLineH(066,048+xPos,98,3,"B")
//	IF !(ALLTRIM(ZA_CCUSTO)$"ACABAMENTO")
MSCBSAY(042,039+xPos,"  /  /  "                ,"N","1" ,"2,2")
MSCBSAYBAR(010,044+xPos,'1109050500101',"N","1",10,.F.,.F.,,,3,2,,,,)
MSCBSAY(067,034+xPos,"OK:"                     ,"N","2" ,"2,2")
MSCBSAY(067,042+xPos,"NC:"                     ,"N","2" ,"2,2")
MSCBSAY(067,050+xPos,"RET:"                    ,"N","2" ,"2,2")
MSCBLineH( 008,055+xPos,98,3,"B")
/*	ELSE
MSCBSAY(042,039+xPos,DTOC(ZA_DATA)             ,"N","1" ,"2,2")
MSCBSAY(067,034+xPos,"KB:"+STRZERO(_nQuant,3)  ,"N","2" ,"2,2")
If !lAcab
MSCBSAYBAR(010,044+xPos,ZA_OPNUM+ZA_ITEM+ZA_SEQUEN+Substr(ZA_KAMBAN,2,3),"N","1",10,.F.,.F.,,,3,2,,,,)
EndIf
ENDIF /*	''
MSCBLineH( 008,055+xPos,98,3,"B")
xPos:=xPos+23
//DBskip()
Next //ENDDO

MSCBSAY(010,126,"ACAB    USIN    PINT    MONT "      ,"N","2" ,"2,2")
MSCBSAY(010,134,"1 2 3   1 2 3   1 2 3   1 2 3"      ,"N","2" ,"2,2")
MSCBSAY(010,142,"_____   _____   _____   _____"      ,"N","2" ,"2,2")
MSCBEND()
MSCBCLOSEPRINTER()
Return
/*/
