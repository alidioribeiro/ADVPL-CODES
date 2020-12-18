#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/07/00
//#include "protheu2.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ SOLIGRAF -> SOLICITACAO DE COMPRA   MODELO GRAFICO                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Autor   ³ JOSE MACEDO               !          Data   06/09/2005      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

//************************************
User Function SOLIGRAF()
//************************************

cDesc1 := "Este programa ira  imprimir SOLIC DE COMPRA"
cDesc2 := ""
cDesc3 := ""
cString:="SC1"
cFilial:=SM0->M0_CODFIL
nChar:=18

#IFNDEF WINDOWS
	cSavCor:=SetColor()
#ENDIF

titulo  :="SOLICITACAO DE COMPRA"
aReturn := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 4, 2, 1, "",1 }
nomeprog:="SOLIGRAF"
nLastKey:= 0
cPerg    :="SOLGRF"
li       :=1

IF !(PERGUNTE(cPerg,.T.))
	RETURN
ENDIF


dbSelectArea("SC1")
DBSETORDER(1)
DBSEEK(xFILIAL()+MV_PAR01)
IF !FOUND()
	ALERT("SOLICITACAO NAO ENCONTRADA ...")
	RETURN
ENDIF

_SIGLA:="DIV  "
_SETOR:="DIVERSOS                               "
_PRAZO:="15 DIAS                                "
_APLIC:=C1_OBS
@ 1,1 to  600,600 DIALOG oJan3 TITLE "Dados Complementares da Solicitacao"
@ 20,  20 SAY "Setor :"
@ 20,  70 GET _SETOR
@ 20,  110 GET _SIGLA

@ 40,  20 SAY "Prazo Ent :"
@ 40,  70 GET _PRAZO

@ 60,  20 SAY "Aplicacao :"
@ 60,  70 GET _APLIC


@ 85, 199 BMPBUTTON TYPE 1 ACTION Close(oJan3)        // CONFIRMA
@ 85, 228 BMPBUTTON TYPE 2 ACTION Close(oJan3)         // RETORNA
ACTIVATE DIALOG oJan3 CENTERED

RECLOCK("SC1",.F.)
SC1->C1_OBS:=_APLIC
MSUNLOCK()






bOk 	:= {|| nOpc := 1, oDlg1:End()}
nOpc	:= 0

wnrel := "SOLIGRAF"            //Nome Default do relatorio em Disco

If nLastKey==27
	Return
Endif


nFIRST:=0

cExtenso := ""
nContador:=0

nTipo   :=IIF(aReturn[4]==1,15,18)


//wNFS:=MV_PAR01
//wSER:=MV_PAR08

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Localiza o 1.Cheque a ser impresso                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

fa490Cabec(nTipo)

#IFNDEF WINDOWS
	Inkey()
	If LastKey()==K_ALT_A
		lEnd := .t.
	End
#ENDIF

If lEnd
	@Prow()+1,1 PSAY "Cancelado pelo operador"
//	Exit
EndIF




nContador:=NCONTADOR+1
IF nContador>2;nContador:=1;li:=1;EndIF
__LogPages()

//****************************************************************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pegar e gravar o proximo numero da Copia do Cheque       ³
//³ Posicionar no sx6 utilizando GetMv. N„o Utilize Seek !!! ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


//                             Tam  Bold   Under
oFont := TFont():New( "Arial",,12,,.T.,,,,,.F. )
oFont1:= TFont():New( "Arial",,10,,.T.,,,,,.F. )
oFont7:= TFont():New( "Arial",,08,,.F.,,,,,.F. )



oFont2:= TFont():New( "Baker Signet BT",,12,,.f.,,,,,.f. )
oFont3:= TFont():New( "MicrogrammaDBolExt",,18,,.t.,,,,,.f. )
oFont4:= TFont():New( "MicrogrammaDMedExt",,14,,.t.,,,,,.f. )
oFont5:= TFont():New( "Baker Signet BT",,10,,.t.,,,,,.f. )
oFont6:= TFont():New( "Baker Signet BT",,12,,.t.,,,,,.f. )

oPrn := TMSPrinter():New()
oPrn:Setup()

Private npag := 1



wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,"M","",.T.)


_CONT:=1

dbSelectArea("SC1")
DBSETORDER(1)
DBSEEK(xFILIAL()+MV_PAR01)

linha := 50
nLi   := 60



oPrn:Say( Linha:=Linha+10,300,"..", oFont4)

oPrn:Box( Linha:=Linha     ,150 ,Linha+200,1800)
oPrn:Box( Linha:=Linha     ,1799,Linha+200,2300)
X:=LINHA
Z:=LINHA+200

oPrn:Say( Linha:=Linha+40,300 ,"SOLICITACAO PARA COTACAO-MARBORGES", oFont)
oPrn:Say( Linha:=Linha   ,2000,"AGR", oFont7)
oPrn:Say( Linha:=Linha   ,2180,"SOCOM", oFont7)
oPrn:line( LINHA+40, 1800,LINHA+40, 2300)     // Linha HORIZONTAL


oPrn:Say( Linha:=Linha+60   ,1810,"No.", oFont1)
oPrn:Say( Linha:=Linha   ,2000,_SIGLA, oFont1)
oPrn:Say( Linha:=Linha   ,2180,SC1->C1_NUM, oFont1)

oPrn:Say( Linha:=Linha+40,400,_SETOR, oFont)

oPrn:line( LINHA, 1800,LINHA, 2300)     // Linha HORIZONTAL
oPrn:Say( Linha:=Linha+10   ,1810,"Data", oFont1)
oPrn:Say( Linha:=Linha      ,2000,DTOC(SC1->C1_EMISSAO), oFont1)

oPrn:line( X,1900,Z,1900)     // Linha VERTICAL
oPrn:line( X,2170,Z,2170)     // Linha VERTICAL


oPrn:Box( LINHA+60,150,LINHA+140,2300)     
oPrn:Say( Linha+70 ,200 ,"ITEM", oFont)
oPrn:Say( Linha+70     ,350 ,"ESPECIFICACAO DO MATERIAL", oFont)
oPrn:Say( Linha+70     ,1860,"QUANTD", oFont)
oPrn:Say( Linha+70     ,2190,"UNID", oFont)

oPrn:Box( Linha:=Linha+140,150,2400,2300)     // BORDA GERAL DO FORMULARIO
X:=LINHA
LINHA:=LINHA+30

While !Eof() .AND. C1_NUM==MV_PAR01
   oPrn:Say( Linha:=Linha ,200 ,C1_ITEM, oFont)
   oPrn:Say( Linha:=Linha     ,350 ,LEFT(C1_DESCRI,54), oFont)
   oPrn:Say( Linha:=Linha     ,1810,TRANSFORM(C1_QUANT,"@EZ 99,999,999.9"), oFont)
   oPrn:Say( Linha:=Linha     ,2200,C1_UM, oFont)
   _ITEM:=VAL(C1_ITEM)	
   IF _ITEM<14
      oPrn:line( LINHA+42, 150,LINHA+42, 2300)     // Linha HORIZONTAL
   ENDIF   
   LINHA:=LINHA+nLI	
	
	SC1->(DBSKIP())
ENDDO

IF _ITEM<14
   FOR I:=_ITEM TO 14
        oPrn:Say( Linha:=Linha ,200 ,STRZERO(I,2,0), oFont)
        IF I<14
           oPrn:line( LINHA+42, 150,LINHA+42, 2300)     // Linha HORIZONTAL
        ENDIF   
        LINHA:=LINHA+nLI	
   NEXT I
ENDIF   


Z:=LINHA
oPrn:line( X,320,Z,320)     // Linha VERTICAL
oPrn:line( X,1800,Z,1800)     // Linha VERTICAL
oPrn:line( X,2170,Z,2170)     // Linha VERTICAL
oPrn:line( LINHA, 150,LINHA, 2300)     // Linha HORIZONTAL
oPrn:Say( Linha:=Linha+30     ,350 ,"APLICACAO : "+_APLIC, oFont)
oPrn:Say( Linha:=Linha+50     ,350 ,"PRAZO ENT : "+_PRAZO, oFont)
oPrn:Say( Linha:=Linha+50     ,550 ,"DATA                                 ASSINATURA", oFont)

LINHA:=LINHA+50
oPrn:Box( Linha:=Linha     ,150 ,Linha+60,2300)
oPrn:Say( Linha:=Linha+10  ,1100 ,"C O T A Ç Ã O " , oFont)

LINHA:=LINHA+50
oPrn:Box( Linha:=Linha     ,150 ,Linha+60,800)
oPrn:Box( Linha:=Linha     ,800 ,Linha+60,1300)
oPrn:Box( Linha:=Linha     ,1300 ,Linha+60,1800)
oPrn:Box( Linha:=Linha     ,1800 ,Linha+60,2300)
oPrn:Say( Linha:=Linha+10  ,155 ,"Nome Forn->", oFont7)

LINHA:=LINHA+50
oPrn:Box( Linha:=Linha     ,150 ,Linha+60,800)
oPrn:Box( Linha:=Linha     ,800 ,Linha+60,1300)
oPrn:Box( Linha:=Linha     ,1300 ,Linha+60,1800)
oPrn:Box( Linha:=Linha     ,1800 ,Linha+60,2300)

oPrn:Say( Linha:=Linha  ,500 ,"A", oFont)
oPrn:Say( Linha:=Linha  ,1050 ,"B", oFont)
oPrn:Say( Linha:=Linha  ,1550 ,"C", oFont)
oPrn:Say( Linha:=Linha  ,2050 ,"D", oFont)


LINHA:=LINHA+50
oPrn:Box( Linha:=Linha     ,150 ,Linha+60,235)
oPrn:Box( Linha:=Linha     ,235 ,Linha+60,800)
oPrn:Box( Linha:=Linha     ,800 ,Linha+60,1300)
oPrn:Box( Linha:=Linha     ,1300 ,Linha+60,1800)
oPrn:Box( Linha:=Linha     ,1800 ,Linha+60,2300)
oPrn:Say( Linha:=Linha+10  ,155 ,"Item", oFont7)


oPrn:Say( Linha,240 ,"APR", oFont7)
oPrn:Say( Linha,345 ,"P.UNIT", oFont7)
oPrn:Say( Linha,545 ,"P.TOTAL", oFont7)


oPrn:Say( Linha,805 ,"APR", oFont7)
oPrn:Say( Linha,910 ,"P.UNIT", oFont7)
oPrn:Say( Linha,1110,"P.TOTAL", oFont7)

oPrn:Say( Linha,1305,"APR", oFont7)
oPrn:Say( Linha,1410,"P.UNIT", oFont7)
oPrn:Say( Linha,1610,"P.TOTAL", oFont7)


oPrn:Say( Linha,1805,"APR", oFont7)
oPrn:Say( Linha,1910,"P.UNIT", oFont7)
oPrn:Say( Linha,2110,"P.TOTAL", oFont7)




LINHA:=LINHA+50
oPrn:line( LINHA, 235,2400, 235)     // Linha VERTICAL

oPrn:line( LINHA, 335,2400, 335)     // Linha VERTICAL
oPrn:line( LINHA, 535,2400, 535)     // Linha VERTICAL
oPrn:line( LINHA, 800,2400, 800)     // Linha VERTICAL


oPrn:line( LINHA, 900,2400, 900)     // Linha VERTICAL
oPrn:line( LINHA,1050,2400,1050)     // Linha VERTICAL
oPrn:line( LINHA,1300,2400,1300)     // Linha VERTICAL

oPrn:line( LINHA,1400,2400,1400)     // Linha VERTICAL
oPrn:line( LINHA,1550,2400,1550)     // Linha VERTICAL
oPrn:line( LINHA,1800,2400,1800)     // Linha VERTICAL

oPrn:line( LINHA,1900,2400,1900)     // Linha VERTICAL
oPrn:line( LINHA,2050,2400,2050)     // Linha VERTICAL


LINHA:=LINHA+15

FOR I:=1 TO 14
   oPrn:Say( Linha:=Linha ,160 ,STRZERO(I,2,0), oFont)
   IF I<14
      oPrn:line( LINHA+42, 150,LINHA+42, 2300)     // Linha HORIZONTAL
   ENDIF
   LINHA:=LINHA+53


NEXT I






Linha:=2400

oPrn:Box( Linha:=Linha     ,150,Linha+75,2300)
oPrn:Say( Linha+10  , 160,"Total de Contas", oFont7)
x:=Linha

oPrn:Box( Linha:=Linha+75     ,150,Linha+75,2300)
oPrn:Say( Linha+10  , 160,"Condição", oFont7)
oPrn:Box( Linha:=Linha+75     ,150,Linha+75,2300)
oPrn:Say( Linha+10  , 160,"Vendedor", oFont7)
oPrn:Box( Linha:=Linha+75     ,150,Linha+75,2300)
oPrn:Say( Linha+10  , 160,"Telefone", oFont7)
Z:=LINHA+75
oPrn:line( X, 800,Z, 800)     // Linha VERTICAL
oPrn:line( X,1300,Z,1300)     // Linha VERTICAL
oPrn:line( X,1800,Z,1800)     // Linha VERTICAL





oPrn:EndPage()





oPrn:Preview()
MS_FLUSH()





RETURN Nil



//*****************
Static Function Fa490cabec()
//*****************

cTamanho := "P"
aDriver := ReadDriver()

If !( "DEFAULT" $ Upper( __DRIVER ) )
	SetPrc(000,000)
Endif
if nChar == NIL
	@ pRow(),pCol() PSAY &(if(cTamanho=="P",aDriver[1],if(cTamanho=="G",aDriver[5],aDriver[3])))
else
	if nChar == 15
		@ pRow(),pCol() PSAY &(if(cTamanho=="P",aDriver[1],if(cTamanho=="G",aDriver[5],aDriver[3])))
	else
		AA:=(if(cTamanho=="P",aDriver[2],if(cTamanho=="G",aDriver[6],aDriver[4])))
		@ pRow(),pCol() PSAY &AA
	endif
endif
Return(.T.)

