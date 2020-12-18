#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02
#INCLUDE "Protheus.ch"
#include "ap5mail.ch"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"

//**** Tela que mostra os valores calculos ***/
User Function MTA410()
Local lRet := .T.
Local aLog := {}
Local cQuery:=""
Local NumPed := M->C5_NUM
Local nItens, i


If Alltrim(M->C5_CLIENTE) $ "001/002" .Or. ChkCliente(M->C5_CLIENTE, "HONDA")
	
	For nItens := 1 to Len(aCols)
		If !(aCols[n, ascan(aHeader, {|x| Alltrim(x[2]) == "C6_TES"}) ] $ "510/512/596/599/509")
			
			If Empty(aCols[n, ascan(aHeader, {|x| Alltrim(x[2]) == "C6_LINHA"}) ])
				aadd(aLog, "ITEM: "+aCols[nItens,1]+ " CODIGO: "+aCols[n,2]+ " -> Nao foi informado o campo LINHA.")
			Endif
			If Empty(aCols[n, ascan(aHeader, {|x| Alltrim(x[2]) == "C6_ENTREG"}) ])
				aadd(aLog, "ITEM: "+aCols[nItens,1]+ " CODIGO: "+aCols[n,2]+ " -> Nao foi informado o campo DATA DA ENTREGA.")
			Endif
			If Empty(aCols[n, ascan(aHeader, {|x| Alltrim(x[2]) == "C6_HORA"}) ])
				aadd(aLog, "ITEM: "+aCols[nItens,1]+ " CODIGO: "+aCols[n,2]+ " -> Nao foi informado o campo HORA DA ENTREGA.")
			Endif
			If Empty(aCols[n, ascan(aHeader, {|x| Alltrim(x[2]) == "C6_PEDCLI"}) ])
				aadd(aLog, "ITEM: "+aCols[nItens,1]+ " CODIGO: "+aCols[n,2]+ " -> Nao foi informado o campo PEDIDO DO CLIENTE.")
			Endif
			If Empty(aCols[n, ascan(aHeader, {|x| Alltrim(x[2]) == "C6_TPEDIDO"}) ])
				aadd(aLog, "ITEM: "+aCols[nItens,1]+ " CODIGO: "+aCols[n,2]+ " -> Nao foi informado o campo TIPO DO PEDIDO.")
			Endif
			If Empty(aCols[n, ascan(aHeader, {|x| Alltrim(x[2]) == "C6_SETOR"}) ])
				aadd(aLog, "ITEM: "+aCols[nItens,1]+ " CODIGO: "+aCols[n,2]+ " -> Nao foi informado o campo SETOR.")
			Endif
			If Empty(aCols[n, ascan(aHeader, {|x| Alltrim(x[2]) == "C6_ENTREGA"}) ])
				aadd(aLog, "ITEM: "+aCols[nItens,1]+ " CODIGO: "+aCols[n,2]+ " -> Nao foi informado o campo LOCAL DA ENTREGA.")
			Endif
			If Empty(aCols[n, ascan(aHeader, {|x| Alltrim(x[2]) == "C6_FILIALP"}) ])
				aadd(aLog, "ITEM: "+aCols[nItens,1]+ " CODIGO: "+aCols[n,2]+ " -> Nao foi informado o campo FILIAL DA ENTREGA.")
			Endif
			
		Endif
		
	Next
	
	
	//
ElseIf Alltrim(M->C5_CLIENTE) $ "028/072" .Or. ChkCliente(M->C5_CLIENTE, "YAMAHA")
	
	dbselectarea("SA7")
	dbsetorder(1)
	nPosCod := ascan(aHeader, {|x| Alltrim(x[2]) == "C6_PRODUTO"})
	For nItens := 1 to Len(aCols)  
		If (aCols[n, ascan(aHeader, {|x| Alltrim(x[2]) == "C6_TES"}) ] $ "511") //Incluido por Rodovaldo 28.10.14
    		If !dbSeek(xFilial("SA7")+ M->C5_CLIENTE+ M->C5_LOJACLI+ aCols[nItens, nPosCod])
    			aadd(aLog, "ITEM: "+aCols[nItens,1]+ " CODIGO: "+aCols[n,2]+ " -> Codigo Nippon nao está cadastrado na amarração PRODUTO x CLIENTE!")
    		Else
    			If Empty(A7_CODCLI)
    				aadd(aLog, "ITEM: "+aCols[nItens,1]+ " CODIGO: "+aCols[n,2]+ " -> Codigo do cliente não cadastrado na amarração PRODUTO x CLIENTE!")
    			Endif
    		Endif
    	Endif	
	Next
Endif
//
//
If Len(aLog) > 0
	
	MsgStop("O pedido não será gravado pois existem informações obrigatorias para o cliente que não foram informadas!","MTA410")
	
	cArqTxt := "C:\TEMP\"+Alltrim(M->C5_NUM)+"_Log.txt"
	nHdl:= msfCreate(cArqTxt,0)
	IF nHdl == -1
		Help(" ",1,"","NAOARQUIVO","Não foi possivel criar arquivo",1,0)
	Else
		cLinha := " " + CHR(13)+CHR(10)
		cLinha += "Log de Pedidos"           +" " + CHR(13)+CHR(10)
		cLinha += "Data:    "+dToc(dDatabase)+" " + CHR(13)+CHR(10)
		cLinha += "Hora:    "+Time()         +" " + CHR(13)+CHR(10)
		cLinha += "Usuario: "+cUserName      +" " + CHR(13)+CHR(10)
		cLinha += "========================================================================"+ CHR(13)+CHR(10)
		//
		FWrite(nHdl,cLinha)
		//
		For nItens := 1 to Len(aLog)
			cLinha := aLog[nItens] + CHR(13)+CHR(10)
			FWrite(nHdl,cLinha)
		Next
		fClose(nHdl)
		//
		If File("C:\WINDOWS\NOTEPAD.EXE")
			//MSGINFO("C:\WINDOWS\NOTEPAD.EXE "+cArqTxt)
			WinExec("C:\WINDOWS\NOTEPAD.EXE "+cArqTxt)
			
		ElseIf File("D:\WINDOWS\NOTEPAD.EXE")
			WinExec("D:\WINDOWS\NOTEPAD.EXE "+cArqTxt)
			
		ElseIf File("D:\WINDOWS\NOTEPAD.EXE")
			WinExec("D:\WINDOWS\NOTEPAD.EXE "+cArqTxt)
			
		Endif
	Endif
	lRet := .F.
Else
	//
	// ******************** IMPLEMENTAÇÃO P/ OBRIGATORIEDADE DO FIFO ******************************
	// EM: 19/08/2013 BY ALEX ALMEIDA
	// ********************************************************************************************
	//
	cQuery  :=  " UPDATE " + RETSQLNAME("ZZ3") + " "
	cQuery  +=  " SET D_E_L_E_T_ = '*' "
	cQuery  +=  " WHERE ZZ3_FILIAL = '"+ xFilial("ZZ3") +"' "
	cQuery  +=  "   AND D_E_L_E_T_ <> '*' "
	cQuery  +=  "   AND ZZ3_ETIQ   = '"+ NumPed +"'"
	cQuery  +=  "   AND ZZ3_ORIGEM = 'SC6' "
	cQuery  +=  "   AND ZZ3_DTAUT  = '' "
	cQuery  +=  "   AND ZZ3_HRAUT  = '' "
	cQuery  +=  "   AND ZZ3_CODAUT = '' "
	TcSqlExec(cQuery)
	//
	//
	lQbFifo := .F.
	For i := 1 to Len(aCols)
		If !(aCols[i][len(aHeader)+1])
			cProduto  := aCols[i,ASCAN(aHeader, {|x| Alltrim(x[2]) == "C6_PRODUTO" })]
			cLocalOri := aCols[i,ASCAN(aHeader, {|x| Alltrim(x[2]) == "C6_LOCAL"   })]
			cLocaliz  := aCols[i,ASCAN(aHeader, {|x| Alltrim(x[2]) == "C6_LOCALIZ" })]
			cLotectl  := aCols[i,ASCAN(aHeader, {|x| Alltrim(x[2]) == "C6_LOTECTL" })]
			cNumLote  := aCols[i,ASCAN(aHeader, {|x| Alltrim(x[2]) == "C6_NUMLOTE" })]
			nQuant    := aCols[i,ASCAN(aHeader, {|x| Alltrim(x[2]) == "C6_QTDVEN"  })]
			cQbFifoM  := aCols[i,ASCAN(aHeader, {|x| Alltrim(x[2]) == "C6_QBFIFOM" })]
			cQbObser  := aCols[i,ASCAN(aHeader, {|x| Alltrim(x[2]) == "C6_QBOBSER" })]
			//
			If aCols[i][ASCAN(aHeader, {|x| Alltrim(x[2]) == "C6_QBFIFO" })]  == "S"
				U_LogQuebraFifo(cProduto, cLocalOri, cLocaliz, cLotectl, cNumLote, nQuant, M->C5_NUM, "", "", cQbFifoM, "SC6",    "", cQbObser)
				lQbFifo := .T.
			Endif
		Endif
	Next
	//
	If lQbFifo
		msginfo("Ocorrencia de quebra de FIFO foram atualizadas!","Atenção!")
	Endif
	//
	// ******************** IMPLEMENTAÇÃO P/ OBRIGATORIEDADE DO FIFO ******************************
	// EM: 19/08/2013 BY ALEX ALMEIDA
	// ********************************************************************************************
	//
Endif
//
//NrPedVen:=SC6->C6_NUM  //COMENTADO POR ALEX EM 01/08/13
NrPedVen:=M->C5_NUM
cQuery:=" select SUM(C6_VALOR) AS VALPED,SUM(C6_IPIDEV)  AS IPIDEV,SUM(C6_PICMRET)  AS ICMRET ,"
cQuery+=" SUM(C6_ABATISS) AS ABATISS,SUM(C6_VLDED) AS VALDED,SUM(C6_VALDESC)AS VALDES "
cQuery+=" FROM "+RetSqlName("SC6")
cQuery+=" where D_E_L_E_T_=''"
cQuery+=" AND C6_NUM='"+NrPedVen+"'"
TcQuery cQuery Alias "TRB" NEW
dbSelectArea("TRB")
//
If !Eof()
	DadosCalc:=" Valor do Pedido      :"+Transform(VALPED,"@R 999,999,999.99")+Chr(13)
	DadosCalc+=" Valor IPI Devolução  :"+Transform(IPIDEV,"@R 999,999,999.99")+Chr(13)
	DadosCalc+=" Valor ICMS Retido    :"+Transform(ICMRET,"@R 999,999,999.99")+Chr(13)
	DadosCalc+=" Valor ISS Abatimento :"+Transform(ABATISS,"@R 999,999,999.99")+Chr(13)
	DadosCalc+=" Valor da DeduçõeS    :"+Transform(VALDED,"@R 999,999,999.99")+Chr(13)
	DadosCalc+=" Valor dos Descontos  :"+Transform(VALDES,"@R 999,999,999.99")+Chr(13)
	Alert(DadosCalc)
EndIf
//
dbSelectArea("TRB")
TRB->(dbCloseArea())
//
dbselectarea("SC6")
//
Return(lRet)

//
//
//
Static Function ChkCliente(_cCliente, _cNome)
Local lRet := .F.

cQuery := " SELECT A1_NOME "
cQuery += " FROM "+RetSqlName("SA1")+" "
cQuery += " WHERE D_E_L_E_T_<>'*' "
cQuery += " AND A1_COD = '"+_cCliente+"'"
cQuery += " AND UPPER(A1_NOME) LIKE '%"+Alltrim(_cNome)+"%' "
TCQuery cQuery Alias "TMP" NEW
dbSelectArea("TMP")
dbgotop()
nRegs := 0
Do While !Eof()
	nRegs ++
	dbSkip()
Enddo
TMP->(dbClosearea())
If nRegs > 0
	lRet := .T.
Endif
Return(lRet)
