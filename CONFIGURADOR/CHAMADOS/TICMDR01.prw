/*/{Protheus.doc} SSIREL
//TODO Relatório de SSI
@author Wagner Corrêa
@since 06/03/2017
@version 1.0

@type function
/*/
#INCLUDE "rwmake.ch"
#include "ap5mail.ch"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"

User Function TICMDR01


	Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2       := "de acordo com os parametros informados pelo usuario."
	Local cDesc3       := "Solicitação de Serviços de Informativa ( SSI )"
	Local cPict        := ""
	Local titulo       := "Solicitação de Serviços de Informativa ( SSI )"
	Local nLin         := 80
	Local Cabec1       := "SEQ.  SSI     DESCRIÇÃO                                          TIPO                 EMISSÃO  STATUS     CC  SOLICITANTE          APROVADOR            DT APROV  DT ENTRE  TECNICO             DT ENCER CLASSEFICAÇÃO  TG"
	Local Cabec2       := ""
	//                     9999  999999  AAAAAAAAAABBBBBBBBBBCCCCCCCCCCDDDDDDDDDDEEEEEEEEEE AAAAAAAAAABBBBBBBBBB 22/22/22 AAAAAAAAAA 123 AAAAAAAAAABBBBBBBBBB AAAAAAAAAABBBBBBBBBB 22/22/22  22/22/22  AAAAAAAAAABBBBBBBBB 22/22/22 AAAAAAAAAABBBB HH:MM
	//                     01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789  
	//                     0         1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21        22
	Local imprime      := .T.
	Local aOrd         := {"Sintético","Analítico"}

	Private lEnd       := .F.
	Private lAbortPrint:= .F.
	Private CbTxt      := ""
	Private limite     := 220
	Private tamanho    := "G"
	Private nomeprog   := "TICMDR01"
	Private nTipo      := 18
	Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey   := 0
	Private cbtxt      := Space(10)
	Private cbcont     := 00
	Private CONTFL     := 01
	Private m_pag      := 01
	Private wnrel      := "TICMDR01"
	Private CPERG      := "SSIREL"
	Private cString    := "SZH"

	dbSelectArea("SZH")
	dbSetOrder(1)

	wnrel := SetPrint(cString,NomeProg,CPERG,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif                           

	nOrdem := aReturn[8]
	nTipo := If(aReturn[4]==1,15,18)
	titulo += "   "+ aOrd[nOrdem]

	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return
//
//
//
//
//
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
	Private	aAberOcor	:= {},;
	aComentar	:= {},;
	aSolucao	:= {}

	dbSelectArea("SZH")


	SetRegua(RecCount())

	dbGoTop()
	Item:=0
	TotSSI:={}
	While !EOF()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif 

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Filtra parametros do usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If ZH_NUMCHAM < Mv_Par01 .Or. ZH_NUMCHAM > Mv_Par02
			dbSkip()
			Loop
		End

		If MV_PAR14=1   //tipo de filtro emissao ou abertura
			If ZH_DTABERT < Mv_Par03 .Or. ZH_DTABERT > Mv_Par04
				dbSkip()
				Loop
			End
		Else
			If ZH_DTENTRE< Mv_Par03 .Or. ZH_DTENTRE > Mv_Par04
				dbSkip()
				Loop
			End
		EndIf 	


		If ZH_SOLCHAM < Mv_Par05 .Or. ZH_SOLCHAM > Mv_Par06
			dbSkip()
			Loop
		End

		If ZH_TIPO < Mv_Par07 .Or. ZH_TIPO > Mv_Par08
			dbSkip()
			Loop
		End

		If ZH_CC < Mv_Par09 .Or. ZH_CC > Mv_Par10
			dbSkip()
			Loop
		End

		If ZH_TECNICO < Mv_Par11 .Or. ZH_TECNICO > Mv_Par12
			dbSkip()
			Loop
		End 
		Do case 
			case ZH_STATUS == "0"
			//           xStatus := "Aberto    "
			xStatus := "Aguar. Aprovação "
			case ZH_STATUS == "1"
			xStatus := "Andamento "
			case ZH_STATUS == "2"
			xStatus := "Aprovado  "
			case ZH_STATUS == "8"
			xStatus := "Cancelado "
			case ZH_STATUS == "9"
			xStatus := "Encerrado "
		Endcase        

		//   If (Mv_Par13 == 1 .AND. ZH_STATUS <> "0") .OR. (Mv_Par13 == 2 .AND. ZH_STATUS <> "2"  ).OR. (Mv_Par13 ==3 .AND. ZH_STATUS <> "9") .OR. (Mv_Par13 == 4 .AND. ZH_STATUS <> "1") 
		If (Mv_Par13 == 1 .AND. ZH_STATUS <> "0") .OR. (Mv_Par13 == 2 .AND. ZH_STATUS <> "2"  ).OR. (Mv_Par13 ==3 .AND. ZH_STATUS <> "9") .OR. (Mv_Par13 == 4 .AND. ZH_STATUS <> "1") 
			dbSkip()
			Loop                                                     
		End
		PosAt:=AScan(TotSSI,{|x|Alltrim(x[1])=ZH_STATUS})
		If PosAt#0 
			TotSSI[PosAt][3]:=TotSSI[PosAt][3]+1
		Else
			AAdd(TotSSI,{Alltrim(ZH_STATUS),xStatus,1})
		EndIf
		//TESTE
		//FIM TESTE


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		item++
		dbSelectArea("SX5")
		dbSeek(xFilial("SX5")+"ZF"+SZH->ZH_TIPO)
		xTipo := Subs(X5_DESCRI,1,20)
		dbSeek(xFilial("SX5")+"ZH"+SZH->ZH_CLASSIF)
		xClass := Subs(X5_DESCRI,1,14)


		dbSelectArea("SZH")
		xSolici	:= Left( IIF(!Empty(ZH_SOLCHAM), Upper(UsrFullName(ZH_SOLCHAM)),Space(20)), 20)
		xAprova	:= Left( IIf(!Empty(ZH_APROVA) , Upper(UsrFullName(ZH_APROVA)) ,Space(20)), 20)
		xTecnico := Left( IIF(!Empty(ZH_TECNICO), Upper(Posicione( "SX5", 1, xFilial("SX5")+"ZU"+SZH->ZH_TECNICO,"")),Space(20)), 20)
		xEmissao := IIF(!Empty(ZH_DTABERT),Subs(DtoS(ZH_DTABERT),7,2) + "/" + Subs(DtoS(ZH_DTABERT),5,2)+ "/" + Subs(DtoS(ZH_DTABERT),3,2),Space(8))
		xDtAprov := IIF(!Empty(ZH_DTAPROV),Subs(DtoS(ZH_DTAPROV),7,2) + "/" + Subs(DtoS(ZH_DTAPROV),5,2)+ "/" + Subs(DtoS(ZH_DTAPROV),3,2),Space(8))
		xDtentre := IIF(!Empty(ZH_DTENTRE),Subs(DtoS(ZH_DTENTRE),7,2) + "/" + Subs(DtoS(ZH_DTENTRE),5,2)+ "/" + Subs(DtoS(ZH_DTENTRE),3,2),Space(8))
		xDtEncer := IIF(!Empty(ZH_DTFECHA),Subs(DtoS(ZH_DTFECHA),7,2) + "/" + Subs(DtoS(ZH_DTFECHA),5,2)+ "/" + Subs(DtoS(ZH_DTFECHA),3,2),Space(8))



		// Coloque aqui a logica da impressao do seu programa...
		// Utilize PSAY para saida na impressora. Por exemplo:
		@nlin, 000 PSAY StrZero(item,4)
		@nLin, 006 PSAY SUBSTR(ZH_NUMCHAM,3,6)
		@nLin, 014 PSAY SUBSTR(ZH_DESC,1,50)
		@nLin, 065 PSAY xTipo
		@nLin, 086 PSAY xEmissao
		@nLin, 095 PSAY xStatus
		@nLin, 106 PSAY SUBSTR(ZH_CC,1,3)
		@nLin, 110 PSAY SUBSTR(xSolici,1,20)
		@nLin, 131 PSAY SUBSTR(xAprova,1,20)
		@nLin, 152 PSAY xDtAprov
		@nLin, 162 PSAY xDtentre
		@nLin, 172 PSAY SUBSTR(xTecnico,1,20)
		@nLin, 192 PSAY xDtEncer
		@nLin, 201 PSAY SUBSTR(xClass,1,14)
		@nLin, 216 PSAY ZH_TMPEXEC

		if nOrdem == 2

			nLin++
			@nLin,000 PSAY "Ocorrência: " 
			nLin++
			If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif  
			cMemo1  := ZH_OCORREN
			//cMemAux := ""
			nLinhas := MlCount( cMemo1,200) 
			For nCntFor := 1 to nLinhas 
				cMemo1 += MemoLine( ZH_OCORREN, nCntFor )
			Next nCntFor

			// For nCntFor:=1 to nLinhas
			//   @ nLin+nCntFor-1,001 PSAY memoline(AllTrim(cMemo1),220,nCntFor)
			// Next 

			@nLin,000 PSAY cMemo1
			nLin++
			If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
			@nLin,000 PSAY "Solução: " 
			nLin++

			cMemo2  := ZH_SOLUCAO
			cMemAux := ""
			nLinhas := MlCount( cMemAux,200) 
			For nCntFor := 1 to nLinhas 
				cMemo2 += MemoLine( cMemAux, 100, nCntFor )
			Next nCntFor 

			@nLin,000 PSAY cMemo2

		endif
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		nLin++ // Avanca a linha de impressao
		@ nLin,000 PSAY Replicate("-",Limite)
		nLin++ // Avanca a linha de impressao
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		dbSkip() // Avanca o ponteiro do registro no arquivo
	EndDo
	nlin+=2
	If nLin+5> 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif 


	@nLin,000      PSAY "TOTAIS DE ATENDIMENTO POR PERÍODO"
	nlin++ 
	@nLin,000 PSAY Replicate("-",40)
	If nLin> 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif 
	nlin++
	@nLin,000      PSAY "STATUS"
	@nLin,030      PSAY "|QUANTIDADE"
	nlin++
	//@nLin,000 PSAY Replicate("-",40)
	//nlin++ 
	If nLin > 60 // Salto de Página. Neste caso o formulario tem 60 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	EndIf
	 
	TotSSI := aSort(TotSSI,,,{ |x,y| x[1] < x[2] })
	TotGer := 0
	
	For i:=1 to len (TotSSI)
		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		TotGer+=TotSSI[i][3]
		@nLin,000      PSAY TotSSI[i][2]
		@nLin,030      PSAY "|"+Strzero(TotSSI[i][3],4)
		nlin++ 

	Next

	If nLin > 60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif

	@nLin,000      PSAY "Geral"
	@nLin,030      PSAY "|"+Strzero(TotGer,4)

	SET DEVICE TO SCREEN

	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif

	MS_FLUSH()

Return
