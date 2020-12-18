#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VELHA     º Autor ³ Roberto Recife     º Data ³  26/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Jogo da velha										      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LS GUARATO                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function VELHA()

DEFINE FONT oFont1 NAME "Arial" SIZE 13,-24 BOLD
DEFINE FONT oFont2 NAME "Arial" SIZE 53,-60 BOLD
DEFINE FONT oFont3 NAME "Arial" SIZE 7,-10 BOLD

/*
CREATE TABLE VELHA
(JOGADOR SPACE(10),OPC1 VARCHAR(01),OPC2 VARCHAR(01),OPC3 VARCHAR(01),OPC4 VARCHAR(01),OPC5 VARCHAR(01),OPC6 VARCHAR(01),OPC7 VARCHAR(01),OPC8 VARCHAR(01),OPC9 VARCHAR(01))
*/

_cJogador:=Space(10)

If Aviso("Pergunta","Deseja Iniciar Nova Partida?",{"Sim","Nao"},1,"Atencao")=1
	cQuere:=" DELETE FROM VELHA "
	TCSQLEXEC(cQuere)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Jogador														³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlg TITLE "Jogadores" FROM 09,0 TO 15,30 OF oMainWnd
@ 010,005 MsGet _cJogador Valid oDlg:End() size 70,20 Picture "@!" FONT oFont1 PIXEL COLOR CLR_BLACK
@ 100,005 MsGet _cJogador size 70,20 Picture "@!" FONT oFont1 PIXEL COLOR CLR_HRED
ACTIVATE MSDIALOG oDlg CENTERED


cQuery:=" SELECT COUNT(*) QTD FROM VELHA "
TCQUERY cQuery NEW ALIAS "TCQ"
DbSelectArea("TCQ")
_nQtd:=TCQ->QTD
DbCloseArea("TCQ")

If _nQtd>=2
	cQuere:=" DELETE FROM VELHA "
	TCSQLEXEC(cQuere)
Endif

If _nQtd==0
	cQuere:=" INSERT INTO VELHA (JOGADOR,OPC1,OPC2,OPC3,OPC4,OPC5,OPC6,OPC7,OPC8,OPC9,STATUS) VALUES ('"+_cJogador+"','','','','','','','','','','X') "
	TCSQLEXEC(cQuere)
	
	_cFlag:="O"
Else
	cQuere:=" INSERT INTO VELHA (JOGADOR,OPC1,OPC2,OPC3,OPC4,OPC5,OPC6,OPC7,OPC8,OPC9,STATUS) VALUES ('"+_cJogador+"','','','','','','','','','','') "
	TCSQLEXEC(cQuere)
	
	_cFlag:="X"
Endif

_nOpc1:=space(1)
_nOpc2:=space(1)
_nOpc3:=space(1)
_nOpc4:=space(1)
_nOpc5:=space(1)
_nOpc6:=space(1)
_nOpc7:=space(1)
_nOpc8:=space(1)
_nOpc9:=space(1)

For w:=1 to 1000
	cQuery:=" SELECT * FROM VELHA "
	TCQUERY cQuery NEW ALIAS "TCQ"
	DbSelectArea("TCQ")
	Dbgotop()
	While ! Eof()
		If !Empty(TCQ->OPC1);_nOpc1:=TCQ->OPC1;Endif
		If !Empty(TCQ->OPC2);_nOpc2:=TCQ->OPC2;Endif
		If !Empty(TCQ->OPC3);_nOpc3:=TCQ->OPC3;Endif
		If !Empty(TCQ->OPC4);_nOpc4:=TCQ->OPC4;Endif
		If !Empty(TCQ->OPC5);_nOpc5:=TCQ->OPC5;Endif
		If !Empty(TCQ->OPC6);_nOpc6:=TCQ->OPC6;Endif
		If !Empty(TCQ->OPC7);_nOpc7:=TCQ->OPC7;Endif
		If !Empty(TCQ->OPC8);_nOpc8:=TCQ->OPC8;Endif
		If !Empty(TCQ->OPC9);_nOpc9:=TCQ->OPC9;Endif
		DbSkip()
	End
	DbCloseArea("TCQ")
	
	_cJogar()
Next
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Funcao Grava Opcao											³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function _cGrava()

If _nOpc=="1" .and. !Empty(_nOpc1) .and. !_nOpc1 $ (_cFlag);_nOpc1:=Space(1);Return;Endif
If _nOpc=="2" .and. !Empty(_nOpc2) .and. !_nOpc2 $ (_cFlag);_nOpc2:=Space(1);Return;Endif
If _nOpc=="3" .and. !Empty(_nOpc3) .and. !_nOpc3 $ (_cFlag);_nOpc3:=Space(1);Return;Endif
If _nOpc=="4" .and. !Empty(_nOpc4) .and. !_nOpc4 $ (_cFlag);_nOpc4:=Space(1);Return;Endif
If _nOpc=="5" .and. !Empty(_nOpc5) .and. !_nOpc5 $ (_cFlag);_nOpc5:=Space(1);Return;Endif
If _nOpc=="6" .and. !Empty(_nOpc6) .and. !_nOpc6 $ (_cFlag);_nOpc6:=Space(1);Return;Endif
If _nOpc=="7" .and. !Empty(_nOpc7) .and. !_nOpc7 $ (_cFlag);_nOpc7:=Space(1);Return;Endif
If _nOpc=="8" .and. !Empty(_nOpc8) .and. !_nOpc8 $ (_cFlag);_nOpc8:=Space(1);Return;Endif
If _nOpc=="9" .and. !Empty(_nOpc9) .and. !_nOpc9 $ (_cFlag);_nOpc9:=Space(1);Return;Endif

If _nOpc=="1";cQuere:=" UPDATE VELHA SET OPC1='"+_nOpc1+"' WHERE JOGADOR='"+_cJogador+"' ";TCSQLEXEC(cQuere);Endif
If _nOpc=="2";cQuere:=" UPDATE VELHA SET OPC2='"+_nOpc2+"' WHERE JOGADOR='"+_cJogador+"' ";TCSQLEXEC(cQuere);Endif
If _nOpc=="3";cQuere:=" UPDATE VELHA SET OPC3='"+_nOpc3+"' WHERE JOGADOR='"+_cJogador+"' ";TCSQLEXEC(cQuere);Endif
If _nOpc=="4";cQuere:=" UPDATE VELHA SET OPC4='"+_nOpc4+"' WHERE JOGADOR='"+_cJogador+"' ";TCSQLEXEC(cQuere);Endif
If _nOpc=="5";cQuere:=" UPDATE VELHA SET OPC5='"+_nOpc5+"' WHERE JOGADOR='"+_cJogador+"' ";TCSQLEXEC(cQuere);Endif
If _nOpc=="6";cQuere:=" UPDATE VELHA SET OPC6='"+_nOpc6+"' WHERE JOGADOR='"+_cJogador+"' ";TCSQLEXEC(cQuere);Endif
If _nOpc=="7";cQuere:=" UPDATE VELHA SET OPC7='"+_nOpc7+"' WHERE JOGADOR='"+_cJogador+"' ";TCSQLEXEC(cQuere);Endif
If _nOpc=="8";cQuere:=" UPDATE VELHA SET OPC8='"+_nOpc8+"' WHERE JOGADOR='"+_cJogador+"' ";TCSQLEXEC(cQuere);Endif
If _nOpc=="9";cQuere:=" UPDATE VELHA SET OPC9='"+_nOpc9+"' WHERE JOGADOR='"+_cJogador+"' ";TCSQLEXEC(cQuere);Endif

If _nOpc1=="X" .AND. _nOpc2=="X" .AND. _nOpc3=="X"
	Alert("VOCE GANHOU!!!")
	w:=1001
	oDlg:End()
Endif
If _nOpc4=="X" .AND. _nOpc5=="X" .AND. _nOpc6=="X"
	Alert("VOCE GANHOU!!!")
	w:=1001
	oDlg:End()
Endif
If _nOpc7=="X" .AND. _nOpc8=="X" .AND. _nOpc9=="X"
	Alert("VOCE GANHOU!!!")
	w:=1001
	oDlg:End()
Endif
If _nOpc1=="X" .AND. _nOpc4=="X" .AND. _nOpc7=="X"
	Alert("VOCE GANHOU!!!")
	w:=1001
	oDlg:End()
Endif
If _nOpc2=="X" .AND. _nOpc5=="X" .AND. _nOpc8=="X"
	Alert("VOCE GANHOU!!!")
	w:=1001
	oDlg:End()
Endif
If _nOpc3=="X" .AND. _nOpc6=="X" .AND. _nOpc9=="X"
	Alert("VOCE GANHOU!!!")
	w:=1001
	oDlg:End()
Endif
If _nOpc1=="X" .AND. _nOpc5=="X" .AND. _nOpc9=="X"
	Alert("VOCE GANHOU!!!")
	w:=1001
	oDlg:End()
Endif
If _nOpc3=="X" .AND. _nOpc5=="X" .AND. _nOpc7=="X"
	Alert("VOCE GANHOU!!!")
	w:=1001
	oDlg:End()
Endif

If _nOpc1=="O" .AND. _nOpc2=="O" .AND. _nOpc3=="O"
	Alert("VOCE GANHOU!!!")
	w:=1001
	oDlg:End()
Endif
If _nOpc4=="O" .AND. _nOpc5=="O" .AND. _nOpc6=="O"
	Alert("VOCE GANHOU!!!")
	w:=1001
	oDlg:End()
Endif
If _nOpc7=="O" .AND. _nOpc8=="O" .AND. _nOpc9=="O"
	Alert("VOCE GANHOU!!!")
	w:=1001
	oDlg:End()
Endif
If _nOpc1=="O" .AND. _nOpc4=="O" .AND. _nOpc7=="O"
	Alert("VOCE GANHOU!!!")
	w:=1001
	oDlg:End()
Endif
If _nOpc2=="O" .AND. _nOpc5=="O" .AND. _nOpc8=="O"
	Alert("VOCE GANHOU!!!")
	w:=1001
	oDlg:End()
Endif
If _nOpc3=="O" .AND. _nOpc6=="O" .AND. _nOpc9=="O"
	Alert("VOCE GANHOU!!!")
	w:=1001
	oDlg:End()
Endif
If _nOpc1=="O" .AND. _nOpc5=="O" .AND. _nOpc9=="O"
	Alert("VOCE GANHOU!!!")
	w:=1001
	oDlg:End()
Endif
If _nOpc3=="O" .AND. _nOpc5=="O" .AND. _nOpc7=="O"
	Alert("VOCE GANHOU!!!")
	w:=1001
	oDlg:End()
Endif

If !Empty(_nOpc1) .and. !Empty(_nOpc2) .and. !Empty(_nOpc3) .and. !Empty(_nOpc4) .and. !Empty(_nOpc5) .and. !Empty(_nOpc6) .and. !Empty(_nOpc7) .and. !Empty(_nOpc8) .and. !Empty(_nOpc9)
	Alert("DEU VELHA!!!")
	w:=1001
	oDlg:End()
Endif

If _nOpc=="1" .and. Empty(_nOpc1)
	Return
Endif
If _nOpc=="2" .and. Empty(_nOpc2)
	Return
Endif
If _nOpc=="3" .and. Empty(_nOpc3)
	Return
Endif
If _nOpc=="4" .and. Empty(_nOpc4)
	Return
Endif
If _nOpc=="5" .and. Empty(_nOpc5)
	Return
Endif
If _nOpc=="6" .and. Empty(_nOpc6)
	Return
Endif
If _nOpc=="7" .and. Empty(_nOpc7)
	Return
Endif
If _nOpc=="8" .and. Empty(_nOpc8)
	Return
Endif
If _nOpc=="9" .and. Empty(_nOpc9)
	Return
Endif

cQuere:=" UPDATE VELHA SET STATUS='' WHERE JOGADOR='"+_cJogador+"' "
TCSQLEXEC(cQuere)

cQuere:=" UPDATE VELHA SET STATUS='X' WHERE JOGADOR<>'"+_cJogador+"' "
TCSQLEXEC(cQuere)

oDlg:End()
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tela Jogo													³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function _cJogar()

cQuery:=" SELECT COUNT(*) QTD FROM VELHA "
TCQUERY cQuery NEW ALIAS "TCQ"
DbSelectArea("TCQ")
_cQtd:=TCQ->QTD
DbCloseArea("TCQ")

If _cQtd==1
	Alert("Aguarde o Outro Jogador!!!")
	Return
Endif

cQuery:=" SELECT STATUS FROM VELHA WHERE JOGADOR='"+_cJogador+"' "
TCQUERY cQuery NEW ALIAS "TCQ"
DbSelectArea("TCQ")
_cStatus:=TCQ->STATUS
DbCloseArea("TCQ")

nLin:=5
nLin2:=5
_nOpc:=space(1)

If _cStatus=="X"
	
	DEFINE MSDIALOG oDlg TITLE "Jogo da Velha - Jogador "+_cJogador+" Usar "+_cFlag FROM 09,0 TO 30,60 OF oMainWnd
	@ 002,15 SAY "Faca a sua Jogada..." FONT oFont3 PIXEL COLOR CLR_BLACK
	@ 043,05 SAY "______________________________" FONT oFont1 PIXEL COLOR CLR_BLACK
	@ 093,05 SAY "______________________________" FONT oFont1 PIXEL COLOR CLR_BLACK
	
	For w:=1 to 130
		@ nLin,78 SAY "|" FONT oFont1 PIXEL COLOR CLR_BLACK
		nLin:=nLin+1
	Next
	For w:=1 to 130
		@ nLin2,158 SAY "|" FONT oFont1 PIXEL COLOR CLR_BLACK
		nLin2:=nLin2+1
	Next
	
	If ! Empty(_nOpc1)
		@ 010,005 msget _nOpc1  when .f. Picture "@!" Size 70,40 FONT oFont2 PIXEL COLOR CLR_HRED
	Endif
	If Empty(_nOpc1)
		@ 010,005 MsGet _nOpc1 Valid _cGrava(_nOpc:="1") size 70,40 Picture "@!" FONT oFont2 PIXEL COLOR CLR_HRED
	Endif
	If ! Empty(_nOpc2)
		@ 010,085 msget _nOpc2 when .f. Picture "@!" Size 70,40 FONT oFont2 PIXEL COLOR CLR_HRED
	Endif
	If Empty(_nOpc2)
		@ 010,085 MsGet _nOpc2 Valid _cGrava(_nOpc:="2") size 70,40 Picture "@!" FONT oFont2 PIXEL COLOR CLR_HRED
	Endif
	
	If ! Empty(_nOpc3)
		@ 010,165 msget _nOpc3 when .f. Picture "@!" Size 70,40  FONT oFont2 PIXEL COLOR CLR_HRED
	Endif
	If Empty(_nOpc3)
		@ 010,165 MsGet _nOpc3 Valid _cGrava(_nOpc:="3") size 70,40 Picture "@!" FONT oFont2 PIXEL COLOR CLR_HRED
	Endif
	
	If ! Empty(_nOpc4)
		@ 060,005 msget  _nOpc4 when .f. Picture "@!" Size 70,40  FONT oFont2 PIXEL COLOR CLR_HRED
	Endif
	If Empty(_nOpc4)
		@ 060,005 MsGet _nOpc4 Valid _cGrava(_nOpc:="4") size 70,40 Picture "@!" FONT oFont2 PIXEL COLOR CLR_HRED
	Endif
	
	If ! Empty(_nOpc5)
		@ 060,085 msget _nOpc5  when .f. Picture "@!" Size 70,40  FONT oFont2 PIXEL COLOR CLR_HRED
	Endif
	If Empty(_nOpc5)
		@ 060,085 MsGet _nOpc5 Valid _cGrava(_nOpc:="5") size 70,40 Picture "@!" FONT oFont2 PIXEL COLOR CLR_HRED
	Endif
	
	If ! Empty(_nOpc6)
		@ 060,165 msget  _nOpc6 when .f. Picture "@!" Size 70,40  FONT oFont2 PIXEL COLOR CLR_HRED
	Endif
	If Empty(_nOpc6)
		@ 060,165 MsGet _nOpc6 Valid _cGrava(_nOpc:="6") size 70,40 Picture "@!" FONT oFont2 PIXEL COLOR CLR_HRED
	Endif
	
	If ! Empty(_nOpc7)
		@ 110,005 msget _nOpc7  when .f. Picture "@!" Size 70,40  FONT oFont2 PIXEL COLOR CLR_HRED
	Endif
	If Empty(_nOpc7)
		@ 110,005 MsGet _nOpc7 Valid _cGrava(_nOpc:="7") size 70,40 Picture "@!" FONT oFont2 PIXEL COLOR CLR_HRED
	Endif
	
	If ! Empty(_nOpc8)
		@ 110,085 msget _nOpc8 when .f. Picture "@!" Size 70,40  FONT oFont2 PIXEL COLOR CLR_HRED
	Endif
	If Empty(_nOpc8)
		@ 110,085 MsGet _nOpc8 Valid _cGrava(_nOpc:="8") size 70,40 Picture "@!" FONT oFont2 PIXEL COLOR CLR_HRED
	Endif
	
	If ! Empty(_nOpc9)
		@ 110,165 msget _nOpc9  when .f. Picture "@!" Size 70,40  FONT oFont2 PIXEL COLOR CLR_HRED
	Endif
	If Empty(_nOpc9)
		@ 110,165 MsGet _nOpc9 Valid _cGrava(_nOpc:="9") size 70,40 Picture "@!" FONT oFont2 PIXEL COLOR CLR_HRED
	Endif
	@ 200,165 MsGet _nOpc9 size 70,40 Picture "@!" FONT oFont2 PIXEL COLOR CLR_HRED
	ACTIVATE MSDIALOG oDlg CENTERED
Else
	For y:=1 to 10000
		nLin:=5
		nLin2:=5

		DEFINE MSDIALOG oDlg1 TITLE "Jogo da Velha - Jogador "+_cJogador+" Usar "+_cFlag FROM 09,0 TO 30,60 OF oMainWnd
		@ 002,15 SAY "Aguarde a Jogada do seu oponente..." FONT oFont3 PIXEL COLOR CLR_BLACK
		@ 043,05 SAY "______________________________" FONT oFont1 PIXEL COLOR CLR_BLACK
		@ 093,05 SAY "______________________________" FONT oFont1 PIXEL COLOR CLR_BLACK
		For w:=1 to 130
			@ nLin,078 SAY "|" FONT oFont1 PIXEL COLOR CLR_BLACK
			nLin:=nLin+1
		Next
		For w:=1 to 130
			@ nLin2,158 SAY "|" FONT oFont1 PIXEL COLOR CLR_BLACK
			nLin2:=nLin2+1
		Next
		@ 010,005 msget _nOpc1  when .f. Picture "@!" Size 70,40 FONT oFont2 PIXEL COLOR CLR_HRED
		@ 010,085 msget _nOpc2 when .f. Picture "@!" Size 70,40 FONT oFont2 PIXEL COLOR CLR_HRED
		@ 010,165 msget _nOpc3 when .f. Picture "@!" Size 70,40  FONT oFont2 PIXEL COLOR CLR_HRED
		@ 060,005 msget _nOpc4 when .f. Picture "@!" Size 70,40  FONT oFont2 PIXEL COLOR CLR_HRED
		@ 060,085 msget _nOpc5  when .f. Picture "@!" Size 70,40  FONT oFont2 PIXEL COLOR CLR_HRED
		@ 060,165 msget _nOpc6 when .f. Picture "@!" Size 70,40  FONT oFont2 PIXEL COLOR CLR_HRED
		@ 110,005 msget _nOpc7  when .f. Picture "@!" Size 70,40  FONT oFont2 PIXEL COLOR CLR_HRED
		@ 110,085 msget _nOpc8 when .f. Picture "@!" Size 70,40  FONT oFont2 PIXEL COLOR CLR_HRED
		@ 110,165 msget _nOpc9  when .f. Picture "@!" Size 70,40  FONT oFont2 PIXEL COLOR CLR_HRED
		ACTIVATE MSDIALOG oDlg1 CENTERED ON INIT _cLoop()
	Next
Endif
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tela Loop													³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function _cLoop()

Inkey(5)

cQuery:=" SELECT * FROM VELHA "
TCQUERY cQuery NEW ALIAS "TCQ"
DbSelectArea("TCQ")
Dbgotop()
While ! Eof()
	If !Empty(TCQ->OPC1);_nOpc1:=TCQ->OPC1;Endif
	If !Empty(TCQ->OPC2);_nOpc2:=TCQ->OPC2;Endif
	If !Empty(TCQ->OPC3);_nOpc3:=TCQ->OPC3;Endif
	If !Empty(TCQ->OPC4);_nOpc4:=TCQ->OPC4;Endif
	If !Empty(TCQ->OPC5);_nOpc5:=TCQ->OPC5;Endif
	If !Empty(TCQ->OPC6);_nOpc6:=TCQ->OPC6;Endif
	If !Empty(TCQ->OPC7);_nOpc7:=TCQ->OPC7;Endif
	If !Empty(TCQ->OPC8);_nOpc8:=TCQ->OPC8;Endif
	If !Empty(TCQ->OPC9);_nOpc9:=TCQ->OPC9;Endif
	DbSkip()
End
DbCloseArea("TCQ")

If _nOpc1=="X" .AND. _nOpc2=="X" .AND. _nOpc3=="X"
	Alert("VOCE PERDEU!!!")
	w:=1001
	y:=10001
	oDlg1:End()
Endif
If _nOpc4=="X" .AND. _nOpc5=="X" .AND. _nOpc6=="X"
	Alert("VOCE PERDEU!!!")
	w:=1001
	y:=10001
	oDlg1:End()
Endif
If _nOpc7=="X" .AND. _nOpc8=="X" .AND. _nOpc9=="X"
	Alert("VOCE PERDEU!!!")
	w:=1001
	y:=10001
	oDlg1:End()
Endif
If _nOpc1=="X" .AND. _nOpc4=="X" .AND. _nOpc7=="X"
	Alert("VOCE PERDEU!!!")
	w:=1001
	y:=10001
	oDlg1:End()
Endif
If _nOpc2=="X" .AND. _nOpc5=="X" .AND. _nOpc8=="X"
	Alert("VOCE PERDEU!!!")
	w:=1001
	y:=10001
	oDlg1:End()
Endif
If _nOpc3=="X" .AND. _nOpc6=="X" .AND. _nOpc9=="X"
	Alert("VOCE PERDEU!!!")
	w:=1001
	y:=10001
	oDlg1:End()
Endif
If _nOpc1=="X" .AND. _nOpc5=="X" .AND. _nOpc9=="X"
	Alert("VOCE PERDEU!!!")
	w:=1001
	y:=10001
	oDlg1:End()
Endif
If _nOpc3=="X" .AND. _nOpc5=="X" .AND. _nOpc7=="X"
	Alert("VOCE PERDEU!!!")
	w:=1001
	y:=10001
	oDlg1:End()
Endif

If _nOpc1=="O" .AND. _nOpc2=="O" .AND. _nOpc3=="O"
	Alert("VOCE PERDEU!!!")
	w:=1001
	y:=10001
	oDlg1:End()
Endif
If _nOpc4=="O" .AND. _nOpc5=="O" .AND. _nOpc6=="O"
	Alert("VOCE PERDEU!!!")
	w:=1001
	y:=10001
	oDlg1:End()
Endif
If _nOpc7=="O" .AND. _nOpc8=="O" .AND. _nOpc9=="O"
	Alert("VOCE PERDEU!!!")
	w:=1001
	y:=10001
	oDlg1:End()
Endif
If _nOpc1=="O" .AND. _nOpc4=="O" .AND. _nOpc7=="O"
	Alert("VOCE PERDEU!!!")
	w:=1001
	y:=10001
	oDlg1:End()
Endif
If _nOpc2=="O" .AND. _nOpc5=="O" .AND. _nOpc8=="O"
	Alert("VOCE PERDEU!!!")
	w:=1001
	y:=10001
	oDlg1:End()
Endif
If _nOpc3=="O" .AND. _nOpc6=="O" .AND. _nOpc9=="O"
	Alert("VOCE PERDEU!!!")
	w:=1001
	y:=10001
	oDlg1:End()
Endif
If _nOpc1=="O" .AND. _nOpc5=="O" .AND. _nOpc9=="O"
	Alert("VOCE PERDEU!!!")
	w:=1001
	y:=10001
	oDlg1:End()
Endif
If _nOpc3=="O" .AND. _nOpc5=="O" .AND. _nOpc7=="O"
	Alert("VOCE PERDEU!!!")
	w:=1001
	y:=10001
	oDlg1:End()
Endif

If !Empty(_nOpc1) .and. !Empty(_nOpc2) .and. !Empty(_nOpc3) .and. !Empty(_nOpc4) .and. !Empty(_nOpc5) .and. !Empty(_nOpc6) .and. !Empty(_nOpc7) .and. !Empty(_nOpc8) .and. !Empty(_nOpc9)
	Alert("DEU VELHA!!!")
	w:=1001
	y:=10001
	oDlg1:End()
Endif

cQuery:=" SELECT STATUS FROM VELHA WHERE JOGADOR<>'"+_cJogador+"' "
TCQUERY cQuery NEW ALIAS "TCQ"
DbSelectArea("TCQ")
_cStatus:=TCQ->STATUS
DbCloseArea("TCQ")

oDlg1:End()

If Empty(_cStatus)
	Odlg1:End()
	y:=10001
	Return
Endif
Return
