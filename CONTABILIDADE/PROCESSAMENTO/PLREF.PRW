#INCLUDE "rwmake.ch"
#Include "TOPCONN.CH"


User Function PlRef()
Private cPerg := "PLREF"
Private oLeTxt
Private aPC := {}
lEnd      := .F.

Pergunte(cPerg)

@ 200,1 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Leitura de Arquivo Texto")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa tem o objetivo de ler o conteudo do arquivo texto"
@ 18,018 Say " e preparar o arquivo para importar o plano de referencia "
//@ 26,018 Say " Relatorio conforme parametros do usuario"

@ 60,088 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg)
@ 60,118 BMPBUTTON TYPE 01 ACTION OkProc()
@ 60,148 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)
//@ 70,188 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oLeTxt Centered
Return


Static Function OkProc()
//Private cType   := "Acesso Portão | *.TXT"
//Private cArqTxt := cGetFile(cType, OemToAnsi("Selecione arquivo "+Subs(cType,1,13)))

If Empty(mv_par01) .or. Empty(mv_par02) .or. substr(mv_par01,2,2) <> ":\"
   msgstop("Parametros 01 ou 02 inválidos, favor conferir!")
   Return(.F.)
Endif                                                                    

If Empty(mv_par03) .or. Empty(mv_par04) .or. Len(Alltrim(mv_par03)) <> 4 .or. Len(Alltrim(mv_par04))<>2
   msgstop("Parametros 03 ou 04 inválidos, favor conferir!")
   Return(.F.)
Endif

//
cArqTxt := Alltrim(mv_par01)
cArqTxt += iif(Right(cArqTxt,1)<>"\","\","")
cArqTxt += Alltrim(mv_par02)
//
Processa({|| RunProc() },"Lendo...") 
//
Return



Static Function RunProc()
Local nTamFile, nTamLin, cBuffer, nBtLidos
//
//CVN_FILIAL;CVN_CODPLA;CVN_DSCPLA;CVN_DTVIGI;CVN_DTVIGF;CVN_ENTREF;CVN_LINHA;CVN_CTAREF;CVN_DSCCTA;CVN_TPUTIL
aCampos := {}
AADD(aCampos,{"CAMPO1","C",250,0 } )
AADD(aCampos,{"CAMPO2","C",250,0 } )

/*
AADD(aCampos,{"CVN_CTAREF","C",030,0 } )
AADD(aCampos,{"CVN_DSCCTA","C",250,0 } )
AADD(aCampos,{"CVN_DTVIGI","C",008,0 } )
AADD(aCampos,{"CVN_DTVIGF","C",008,0 } )
AADD(aCampos,{"CVN_CLASSE","C",001,0 } )
AADD(aCampos,{"CVN_CTASUP","C",030,0 } )
AADD(aCampos,{"CVN_TIPO1" ,"C",001,0 } )
AADD(aCampos,{"CVN_TIPO2" ,"C",001,0 } )
AADD(aCampos,{"CVN_TPUTIL","C",001,0 } )
AADD(aCampos,{"CVN_FILIAL","C",002,0 } )
AADD(aCampos,{"CVN_CODPLA","C",006,0 } )
AADD(aCampos,{"CVN_DSCPLA","C",040,0 } )
AADD(aCampos,{"CVN_ENTREF","C",002,0 } )
AADD(aCampos,{"CVN_LINHA" ,"C",006,0 } )
*/

cArqTmp := CriaTrab(aCampos)
dbUseArea( .T.,, cArqTmp, "TMP",.T., .F. )
dbselectarea("TMP") 
APPEND FROM &cArqTxt SDF //DELIMITED WITH ";"
//
cArqTxt := STRTRAN(Alltrim(cArqTxt), ".txt", ".cve")
nHdlArq := FCreate(cArqTxt)

/*/
nTamFile := fSeek(nHdl,0,2)
fSeek(nHdl,0,0)
nTamLin  := 500 //2+Len(cEOL)//2+40//2+Len(cEOL)
cBuffer  := Space(nTamLin) // Variavel para criacao da linha do registro para leitura
nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto
/*/

TMP->(dbgoTop())
ProcRegua(TMP->(Recc())) // Numero de registros a processar
TMP->(dbgoTop())
aRegs := {}
Do While TMP->(!Eof())

    IncProc()

	nPosI   := 1    
    nPosF   := 0
    nUltPos := 0    
    lFim    := .F.
    cLinha  := Alltrim(TMP->CAMPO1)+Alltrim(TMP->CAMPO2)
    //
    aCampos := {}
	Do While !lFim 
		nPosF := AT(";", cLinha)	    
	    If nPosF == 0
	    	lFim := .T.
			aadd(aCampos, Substr(cLinha, nPosI, Len(cLinha)))
	    	Exit
	    Endif

		aadd(aCampos, Substr(cLinha, nPosI, nPosF-1))
		cLinha  := Substr(cLinha, nPosF + 1, Len(cLinha) - nPosF)	    
		nUltPos := nPosF
    Enddo
    //    
    If Len(aCampos) > 0
	    aadd(aRegs, aCampos)
    Endif
    //
	TMP->(dbskip())
Enddo 
//
x:=1    
cGrava := "CVN_FILIAL;CVN_CODPLA;CVN_DSCPLA;CVN_DTVIGI;CVN_DTVIGF;CVN_ENTREF;CVN_LINHA;CVN_CTAREF;CVN_DSCCTA;CVN_TPUTIL"
cGrava += Chr(13) + Chr(10)
FWrite(nHdlArq, cGrava, Len(cGrava))	    
cGrava := ""
//
For nX := 1 to Len(aRegs)
	//CVN_FILIAL;CVN_CODPLA;CVN_DSCPLA;CVN_DTVIGI;CVN_DTVIGF;CVN_ENTREF;CVN_LINHA;CVN_CTAREF;CVN_DSCCTA;CVN_TPUTIL
	//          ;11        ;PLANO REFERENCIAL 2011                  ;20071210;20121231;10;006;1.01.01.03.00                 ;Recursos no Exterior Decorrentes de Expo;A
    If Len(aRegs[nX]) >= 9
		cGrava := ""
		cGrava += PadR(xFilial("CVN_FILIAL")         ,02)+";"
		cGrava += PadR(Substr(mv_par03,3,2)          ,06)+";"
		cGrava += PadR("PLANO REFERENCIAL "+mv_par03 ,40)+";"
		cGrava += PadR(Right(aRegs[nX,3],4)+Substr(aRegs[nX,3],3,2)+Left(aRegs[nX,3],2) ,08)+";"
		cGrava += PadR(Right(aRegs[nX,4],4)+Substr(aRegs[nX,4],3,2)+Left(aRegs[nX,4],2) ,08)+";"
		cGrava += PadR(mv_par04       ,02)+";"
		cGrava += PadR(StrZero(nX,3)  ,03)+";"
		cGrava += PadR(aRegs[nX,1]    ,30)+";"	
		cGrava += PadR(aRegs[nX,2]    ,40)+";"		
		//cGrava += PadR(aRegs[nX,9]    ,01)
		cGrava += PadR(aRegs[nX,5]    ,01)		
		cGrava += Chr(13) + Chr(10)
    	//
	    FWrite(nHdlArq, cGrava, Len(cGrava))	    
    Endif
Next               
//
FClose(nHdlArq)   
//
MSGINFO("O arquivo "+cArqTxt+" foi gerado com sucesso!")
//
Return