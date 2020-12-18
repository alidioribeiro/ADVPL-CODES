#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"
#include "apvt100.ch"
#include "RWMAKE.CH" 
#include "TBICONN.CH"

//
Static __nSem:=0
//
//
User Function ACDG07A()
Local aTela      := vtsave()
Local nOpcao     := 0
Local cOPOrigem  := space(10)
Local bkey24

// Verifica se utiliza controle de transacao.
Private lTTS       := iif(getmv('MV_TTS') == 'S', .T., .F.)
Private aOP        := {}
Private aSD4 := {}
Private aSCKLOTE := {}
Private aTmpEtiq := {}
Private aTmpLote := {}
Private aEtiqueta := {}
Private cProduto   := space(tamsx3('B1_COD')[1])
Private cDescProd  := space(tamsx3('B1_DESC')[1])
Private cLote      := space(tamsx3('D3_LOTECTL')[1])
Private nQE        := 0
Private nQuantProd := 0
Private nQuantLida := 0
Private nQuantEtiq := 0
Private cOP := Space(11)
Private cLocal := space(tamsx3('C2_LOCAL')[1])
Private cEtiqueta := Space(10)
Private cLocalOri := space(tamsx3('C2_LOCAL')[1])
Private cEndOri := Space(tamsx3('DB_LOCALIZ')[1])
Private cEndDes := Space(tamsx3('DB_LOCALIZ')[1])
Private cDescEnd  := Space(tamsx3('BE_DESCRIC')[1])
Private cDocSD3 := Space(tamsx3('DA_DOC')[1])
Private cNumSeq := Space(tamsx3('DA_NUMSEQ')[1])
Private cItem := Space(tamsx3('DB_ITEM')[1])
Private cNumOrd := Space(11) //tamsx3('D4_OP')[1])
Private cNumCC := Space(tamsx3('D3_CC')[1])
Private cCont := Space(01)
Private cCont2 := Space(01)
Private nX := 0
Private lPorLote := .F.
Private lSair := .F.
Private lProximo := .F.
Private lSaldo := .T.
Private lTrocaEnd := .F.
//
//
While .t.
	vtclear
	//
	aOP        := {}
	aSD4 := {}
	aSCKLOTE := {}
	aEtiqueta := {}
	cProduto     := space(tamsx3('B1_COD')[1])
	cDescProd  := space(tamsx3('B1_DESC')[1])
	cLote       := space(tamsx3('D3_LOTECTL')[1])
	nQE        := 0
	nQuantProd := 0
	nQuantLida := 0
	nQuantEtiq := 0
	cOP := Space(11)
	cLocal := space(tamsx3('C2_LOCAL')[1])
	cEtiqueta := Space(10)
	cEndOri := Space(tamsx3('DB_LOCALIZ')[1])
	cEndDes := Space(tamsx3('DB_LOCALIZ')[1])
	cDescEnd  := Space(tamsx3('BE_DESCRIC')[1])
	cDocSD3 := Space(tamsx3('DA_DOC')[1])
	cNumSeq := Space(tamsx3('DA_NUMSEQ')[1])
	cItem := Space(tamsx3('DB_ITEM')[1])
	cNumOrd := Space(11) //tamsx3('CJ_NUM')[1])
	cNumCC := Space(tamsx3('D3_CC')[1])
	cCont := Space(01)
	cCont2 := Space(01)
	lPorLote := .F.
	lSair := .F.
	lSaldo := .T.
	lTrocaEnd := .F.
	//
	vtreverso(.T.)
	@ 00,02 vtsay 'Pick List - Proc'
	vtreverso(.F.)
	//
	@ 01,00 vtsay 'Ord.Prd:'
	@ 02,00 vtget cNumOrd picture '@!' valid  !empty(cNumOrd) .and. ValidOrd(cNumOrd)  f3 'SC2'
	vtread
	If VtLastKey() == 27
		Exit
	Endif
	cCont := Space(01)
	cEtiqueta := Space(10)
	nQuantLida := 0
	nQuantEtiq := 0
	aTmpEtiq := {}
	aTmpLote := {}
	//
	lSair := .F.
	lTrocaEnd := .F.
	While  !lSair
			cEtiqueta := Space(10)
			@ 05,00 vtsay 'Etiqueta:'
			@ 05,10 vtget cEtiqueta picture '@!' valid  !Empty(cEtiqueta) .and. ValidEtiqueta()  //, cLocal, cEndOri, cEndDes, cProduto) //f3 'SBE' //when .F.
			@ 06,00 vtsay 'Qtd.Etq:'
			@ 06,10 vtget nQuantEtiq picture '@E 999,999.99' when .F.
			vtread
			If VtLastkey() == 27
				Exit
			Endif
	Enddo
	If  Len(aTmpEtiq) > 0 //nX > Len(aSD4)  .and. lSaldo
		cCont2 := Space(01)
		aTela := VTSave()
		VTClear()
		While .T.
			@ 03,00 vtsay ' Confirma a transfe '
			@ 04,00 vtsay ' rencia? (1=S/0=N) '
			@ 05,10 vtget cCont2 	Picture '9' 	valid cCont2 $ "01" //fConfirma(@cCont)
			vtread
			If cCont2 $ "1/0"
				Exit
			Endif
		Enddo
		vtRestore(,,,, aTela)
		If	cCont2 == "1" //VTYesNo("Confirma a transferencia?","Aviso" ,.T.) //"Confirma transferencia?"###"Aviso"
			vtbeep(2)
			If lTTS
				begin transaction
				TMATA241()
				dbcommitall()
				end transaction
			Else
				TMATA241()
				dbcommitall()
			Endif
			vtkeyboard(chr(0))
			vtclearbuffer()
		Else
			VTKeyboard(chr(20))
			vtalert('Descartando leituras !', 'AVISO', .T., 2000)
		Endif
	Else
		vtalert('Nao existem etiquetas lidas !', 'AVISO', .T., 2000)
	Endif
Enddo
Return
//
//
Static Function ValidOrd(cQR)
Local lRet         := .T.
//
dbSelectArea("SC2")
dbSetOrder(1)
If !dbSeek(xFilial('SC2')+ cQr)
	vtbeep(2)
	vtalert(' O.P.: '+ cQR +' nao encontrada! ', 'AVISO', .T., 3000)
	Return(.F.)
Else
	If SC2->C2_QUJE == SC2->C2_QUANT .or. !Empty(SC2->C2_DATRF)
		vtbeep(2)
		vtalert('O.P. já encerrada!', 'AVISO', .T., 3000)
		Return(.F.)
	Else
		cNUMCC := C2_CC  //C2_NUM+ C2_ITEM+ C2_SEQUEN
	Endif
Endif
//
dbSelectArea("SD4")
dbSetOrder(2)
If !dbSeek(xFilial('SD4')+ cQr)
	vtbeep(2)
	vtalert('Não foi achado lista de empenho da O.P.'+ cQR +'nao encontrada!', 'AVISO', .T., 3000)
	Return(.F.)
Endif
Return(lRet)
//
//
Static Function ValidEtiqueta()
Local lRet         := .F.
Local nQtd			:=  0
Local cQr := cEtiqueta
Local lAchou := .F.
//
//
dbSelectArea("CB0")
lAchou := dbSeek(xFilial("CB0")+ cQR )
//
If !lAchou
	vtalert('Etiqueta não existe!', 'AVISO', .T., 3000)
	Return(lRet)
Endif
If  (nPos := Ascan(aTmpEtiq, { |x| Alltrim(x[2]) == Alltrim(cQr) }) ) >0  
	vtalert('Etiqueta já foi lida!', 'AVISO', .T., 3000)
	Return(lRet)
Endif
If  Alltrim(CB0->CB0_OP) <> Alltrim(cNumOrd)
	vtalert('Etiqueta não foi separada p/ esta O.P.!', 'AVISO', .T., 3000)
	Return(lRet)
Endif
If  (!Empty(CB0->CB0_DTAPON) .OR. !Empty(CB0->CB0_DTAPON)) .and. CB0->CB0_LOCAL == GetMV("MV_LOCPROC")
	vtalert('Etiqueta já foi transferida para o armazen do processo!', 'AVISO', .T., 3000)
	Return(lRet)
Endif
//Inclui a validação do FIFO /////
//Inclusão feita as  25/09/2012 - Aglair Brito Ishii 
//aadd(aTmpLote, { cLocalOri+ cEndOri+CB0_LOTE, CB0_QTDE } )
//aadd(aTmpEtiq, {  CB0_CODPRO+ CB0_LOCAL+ CB0_LOCALI+ CB0_NUMSER+ CB0_LOTE+ CB0_SLOTE, cEtiqueta, CB0_CODPRO, CB0_LOTE, CB0_SLOTE, CB0_NUMSER, CB0_QTDE, CB0_LOCAL, CB0_LOCALI })
LoteFIFO:=u_ChecaLote(CB0->CB0_CODPRO,CB0->CB0_LOCAL)  //Função que retorna o lote do FIFO 

dbSelectArea("CB0")
If GetMv("MV_AFIFO")  //Se a Mensagem de alerta do Fifo deve aparecer no coletor
	If (nPos:=Ascan( aTmpEtiq, { |x| x[3]+x[4]== cLocalOri+CB0_LOTE })) = 0 
    	vtalert("O Lote a ser mov. pelo FIFO é "+LoteFifo+". Informe o lote correto!!",'AVISO',.T.,3000) 		
    EndIf 
Endif


If  Empty(CB0->CB0_OP) .OR. Empty(CB0->CB0_DTPROC) .OR. Empty(CB0->CB0_HRPROC)
	vtalert('Etiqueta não foi separada!', 'AVISO', .T., 3000)
	Return(lRet)
Endif
//
aadd(aTmpEtiq, {  CB0_CODPRO+ CB0_LOCAL+ CB0_LOCALI+ CB0_NUMSER+ CB0_LOTE+ CB0_SLOTE, cEtiqueta, CB0_CODPRO, CB0_LOTE, CB0_SLOTE, CB0_NUMSER, CB0_QTDE, CB0_LOCAL, CB0_LOCALI })
//
nQuantEtiq ++
vtgetrefresh('nQuantEtiq')
//
lRet := .T.
Return lRet
//
//
Static Function TMATA241()
Private _aCab1 := {}
Private _aItem := {}
Private _atotitem:={}
Private aTotal := {}           
Private aEtiqBkp := {}
Private cLocal := "" 
Private cLocalizacao := ""
Private lMsHelpAuto := .t. // se .t. direciona as mensagens de help
Private lMsErroAuto := .f. //necessario a criacao, pois sera
Private _acod:={"1","MPN"}
Private nModBkp := 0

nModBkp := nModulo
nModulo := 4


aTmpEtiq := ASORT(aTmpEtiq,,, { |x, y| x[1] < y[1] })   //Ordena o vetor por produto + lote

//VTalert('Totalizando lote(s) ...','Movimentação',.t.,2000)  //'Aguarde...'                 
VTMSG("Totalizando lote(s)...")

For nX := 1 to Len(aTmpEtiq)
	nPos := Ascan(aTotal, {|x| x[1] == aTmpEtiq[nX,1]})
	If nPos  == 0
		aadd( aTotal, { aTmpEtiq[nX,1], aTmpEtiq[nX,2], aTmpEtiq[nX,3], aTmpEtiq[nX,4], aTmpEtiq[nX,5], aTmpEtiq[nX,6], aTmpEtiq[nX,7], aTmpEtiq[nX,8], aTmpEtiq[nX,9] } )
	Else
		aTotal[nPos,7] += aTmpEtiq[nX,7]
	Endif
Next
//
aEtiqBkp := aTmpEtiq
aTmpEtiq := {}
aTmpEtiq := aTotal
//                           
For nX:=1 To Len(aTmpEtiq)     //aadd(aTmpEtiq, { "", cEtiqueta, CB0_CODPRO, CB0_LOTE, CB0_SLOTE, CB0_NUMSER, CB0_QTDE, CB0_LOCAL, CB0_LOCALI }) //aTmpEtiq[nX,7]
	 _aItem :=  {  {"D3_COD"    , aTmpEtiq[nX,3], NIL}, {"D3_QUANT"  , aTmpEtiq[nX,7], NIL},;
	               {"D3_LOCAL"  , aTmpEtiq[nX,8], NIL}, {"D3_LOCALIZ", aTmpEtiq[nX,9], NIL},;
	               {"D3_LOTECTL", aTmpEtiq[nX,4], NIL}, {"D3_NUMLOTE", aTmpEtiq[nX,5], NIL}, {"D3_NUMSER", aTmpEtiq[nX,6], NIL},;
				   {"D3_DTRM"   , dDatabase     , NIL}, {"D3_HORA"   , TIME()        , NIL}, {"D3_MOV"  , "PL"           , NIL},;
	               {"D3_OPNSB"  , cNumOrd       , NIL}}
				  
	 aadd(_atotItem, _aItem)
Next
//
//cDocSD3 := getsx8num('SD3','D3_DOC')

lExiste := .T.
Do While lExiste
	cDocSD3 := GetSx8Num('SD3','D3_DOC')
	confirmsx8()      
	If Empty(POSICIONE('SD3', 2,  xFilial('SD3')+ cDocSD3, 'D3_EMISSAO'))
	   lExiste := .F.
	Endif
Enddo

_aCab1 :={ {"D3_DOC"	, cDocSD3    ,NIL},;
		   {"D3_TM" 	, "600"      ,NIL},;
           {"D3_CC" 	, cNumCC     ,NIL},;
           {"D3_EMISSAO", ddatabase ,NIL} }
//
//  
// ***************** IMPLEMENTAÇÃO P/ BLOQUEAR MOV. DE ITEM DESBALANCEADO *********************
// EM: 10/11/2014 BY ALEX ALMEIDA
// ********************************************************************************************
//
For nX := 1 to Len(aTmpEtiq)
	//
	_cCodOrig := aTmpEtiq[nX,3]
	_cLocOrig := aTmpEtiq[nX,8]	
	//
	ContLote  := Posicione("SB1",1,xFilial("SB1")+_cCodOrig,"B1_RASTRO")
	If ContLote <> 'N' .and. Upper(Alltrim(GETMV("MV_CHKB8BF"))) == "S"
		If u_CheckB8BF(_cCodOrig, _cLocOrig)
			//
			VTALERT("Item "+Alltrim(Str(nX))+" o saldo do item origem "+_cCodOrig+"-"+_cLocOrig+" Kardex x Lote x Endereço encontra-se desbalanceado para que a movimentação seja realizada é necessário balancear o saldo do item!","NSACDG06 - Bloqueio")
			//
		Endif
	Endif		
Next
//  
// ***************** IMPLEMENTAÇÃO P/ BLOQUEAR MOV. DE ITEM DESBALANCEADO *********************
// EM: 10/11/2014 BY ALEX ALMEIDA
// ********************************************************************************************
//
VTMSG("Baixando Requisição...")
Begin Transaction
MSExecAuto({|x,y| MATA241(x,y)}, _aCab1, _atotItem) //, 3)

If lMsErroAuto
	//Mostraerro()
	DisarmTransaction()
	Break
	RollBackSx8()
Else
	ConfirmSx8()	
EndIf 
End Transaction
//
VTalert('Requisição baixada!',' Atencao ',.t.,3000)  //'Aguarde...'
If	lMsErroAuto
	VTDispFile(NomeAutoLog(),.t.)
Else
   	lRet := EndReq()    //Chamada de função de endereçamento
	aTmpEtiq := aEtiqBkp
    //
	For nX := 1 to Len(aTmpEtiq)
	     dbSelectarea("CB0")
	     dbSetorder(1)
	     dbSeek( xFilial("CB0")+ aTmpEtiq[nX,02] )
	     RecLock("CB0", .F.)
	     //CB0->CB0_DTPROC := DDATABASE
	     //CB0->CB0_HRPROC := TIME()
	     If !lRet
		     CB0->CB0_DTAPON := DDATABASE
		     CB0->CB0_HRAPON := TIME()	    
		     CB0->CB0_CC     := cNumCC
		     CB0->CB0_LOCAL  := GetMV("MV_LOCPROC")
		     CB0->CB0_LOCALI := cLocalizacao
	     Endif
	     MsUnlock()
   	Next
    //
Endif
nModulo := nModBkp
Return
//
//
Static Function EndReq() 
Local nModuloOld := 0
Local aCab := {}
Local aItens:= {}
//
Private lMsErroAuto	:= .F.
Private lMsHelpAuto	:= .T.

cLocalizacao := "" 
If Alltrim(cNumCC) == "211"        	
  cLocalizacao := "MONTAGEM" 
ElseIf  Alltrim(cNumCC) == "221"
  	  cLocalizacao := "IMPRESSAO"
ElseIf  Alltrim(cNumCC) $ "231/717"
      cLocalizacao := "INJECAO" 
ElseIf  Alltrim(cNumCC) == "241"
	  cLocalizacao := "INSERCAO"
ElseIf  Alltrim(cNumCC) == "251"
	  cLocalizacao := "SENSORFUEL"  
Else
	vtalert('C.C. da O.P. é inválido...!', 'AVISO', .T., 4000)	
Endif
//
//  
For nX:=1 To Len(aTmpEtiq)     //aadd(aTmpEtiq, { "", cEtiqueta, CB0_CODPRO , CB0_LOTE, CB0_SLOTE, CB0_NUMSER, CB0_QTDE, CB0_LOCAL, CB0_LOCALI }) //aTmpEtiq[nX,7]

	cNumSeq := LerNumSeq(aTmpEtiq[nX,3])

	aCab:= {{"DA_PRODUTO"	,aTmpEtiq[nX,3] 	,NIL},; 
			{"DA_LOCAL"		,GetMV("MV_LOCPROC"),NIL},;
			{"DA_LOTECTL"   ,aTmpEtiq[nX,4] 	,NIL},;			
			{"DA_DOC"	    ,cDocSD3           	,NIL},;
			{"DA_NUMSEQ"	,cNumSeq           	,NIL} }				

	aItens:= {{	{"DB_ITEM"	 , "0001"         	,NIL},;
				{"DB_LOCALIZ", cLocalizacao		,NIL},; 
				{"DB_DATA"	 , dDatabase		,NIL},;
				{"DB_QUANT"	 , aTmpEtiq[nX,7]	,NIL} }} 

//		    	{"DB_PRODUTO", aTmpEtiq[nX,3]	,NIL},; 
	
	nModuloOld  := nModulo
	nModulo     := 4
		
	VTMSG("Endereçando...")
	Begin Transaction
	msexecAuto({|x,y| mata265(x,y)}, aCab, aItens)  //3 Distribui
	If lMsErroAuto
		DisarmTransaction()
		Break
	EndIf 
	End Transaction	
	//
	If lMSErroAuto
	   VTDispFile(NomeAutoLog(),.t.)
	Else
		vtalert('Item enderecado!', 'AVISO', .T., 2000)	
		//
		dbSelectArea("SD4")
		dbsetorder(1)
		If dbSeek(xFilial("SD4")+ aTmpEtiq[nX,3]+ cNumOrd)
			RecLock("SD4", .F.)
			SD4->D4_SLDEXT += aTmpEtiq[nX,7]
			MsUnlock()	
			vtalert('Saldo da OP. atualizado!', 'AVISO', .T., 2000)	
		Endif		   		
	Endif			
	nModulo     := nModuloOld

Next
Return(lMSErroAuto)
//
//
Static Function LerNumSeq(cCodItem)
Local nX := 0
Local cNumSeq := ""

lQuery 	  := .T.
aStruSD3  := SD3->(dbStruct())
cAliasSD3 := "TMPSD3"

cQuery    := " SELECT SD3.*, SDA.* "
cQuery    += " FROM "+RetSqlName('SD3')+" SD3 INNER JOIN "+RetSqlName('SDA')+" SDA  ON (D3_DOC+D3_NUMSEQ+D3_LOTECTL+D3_COD=DA_DOC+DA_NUMSEQ+DA_LOTECTL+DA_PRODUTO) "
cQuery    += " WHERE "
cQuery    += " SD3.D3_FILIAL = '"+xFilial("SD3")+"' AND "
cQuery    += " SD3.D3_DOC = '"+cDocSD3+"' AND "
cQuery    += " SD3.D3_OPNSB  = '"+cNumOrd+"' AND "
cQuery    += " SD3.D3_COD  = '"+cCodItem+"' AND "
cQuery    += " SD3.D_E_L_E_T_ = ' ' AND "
cQuery    += " SDA.DA_FILIAL = '"+xFilial("SDA")+"' AND "
cQuery    += " SDA.D_E_L_E_T_ = ' ' AND "            
cQuery    += " SDA.DA_SALDO > 0 "            
cQuery    += " ORDER BY D3_COD " //+SqlOrder(SC2->(IndexKey()))
cQuery    := ChangeQuery(cQuery)

If Select("TMPSD3") >0
   TMPSD3->(dbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD3,.T.,.T.)
For nX := 1 To Len(aStruSD3)
	If ( aStruSD3[nX][2] <> "C" ) .And. FieldPos(aStruSD3[nX][1]) > 0
		TcSetField(cAliasSD3,aStruSD3[nX][1],aStruSD3[nX][2],aStruSD3[nX][3],aStruSD3[nX][4])
	EndIf
Next nX

cNumSeq := TMPSD3->DA_NUMSEQ
TMPSD3->(dbCloseArea())

Return(cNumSeq)