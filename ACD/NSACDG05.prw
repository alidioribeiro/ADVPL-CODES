#Include 'Protheus.ch'
#Include 'Apvt100.ch'


User Function NSACDG05()
Local aTela      := vtsave()
Local nOpcao     := 0
Local cOPOrigem  := space(10)

// Verifica se utiliza controle de transacao.
Private lTTS       := iif(getmv('MV_TTS') == 'S', .T., .F.)
Private aOP        := {}
Private cProduto   := space(tamsx3('B1_COD')[1])
Private cDescProd  := space(tamsx3('B1_DESC')[1])
Private cLote      := space(tamsx3('D3_LOTECTL')[1])
Private nQE        := 0
Private nQuantProd := 0
Private cOP := Space(11)
Private cUM := space(tamsx3('C2_UM')[1])
Private cCC := space(tamsx3('C2_CC')[1])
Private cLocal := space(tamsx3('C2_LOCAL')[1])
Private cEtiqueta := Space(10)

//abrearq()

while .t. // vtlastkey() <> 27
	
	vtclear
	cEtiqueta  := space(10)   // space(13)
	vtreverso(.T.)
	@ 00,02 vtsay 'Apontamento de O.P.'
	vtreverso(.F.)
	
	@ 01,00 vtsay 'Numero da Etiqueta.:'
	@ 02,00 vtget cEtiqueta picture '@!' valid  !empty(cEtiqueta) .and. validop(cEtiqueta)  f3 'CB0'
	
	@ 03,00 vtsay 'OP: '
	@ 03,04 vtget cOP   picture '@!' when .F.
	
	@ 04,00 vtsay 'Prd: '
	@ 04,04 vtget cProduto   picture '@!' when .F.
	@ 05,00 vtget cDescProd  picture '@!' when .F.
	
	@ 06,00 vtsay 'Qtd.:'
	@ 06,05 vtget nQuantProd picture '@E 999,999.99' when .F.
	
	//@ 08,00 vtsay 'Lote  :'
	//@ 09,00 vtget cLote      when .F.
	vtread
	
	If VtLastKey() == 27
		Exit
	EndIf
	
	While .T. && Confirmacao de gravacao da Producao
		cCont := "1" 
		//@ 07,00 vtsay 'Confirma (1=S/0=N)'
		//@ 07,18 vtget cCont	 	Picture '!' 	valid fConfirma(@cCont)
		//vtread
		If cCont == '1'
			If !empty(cOP)
				vtbeep(2)
				if lTTS
					begin transaction
					Preaponta(cEtiqueta)
					dbcommitall()
					end transaction
				else
					Preaponta(cEtiqueta)
					dbcommitall()
				endif
				vtkeyboard(chr(0))
				vtclearbuffer()
			Endif
		Else
			vtalert('atencao : '+PadR(cEtiqueta,13)+" " +cProduto+' nao lida! ', 'Aviso', .T., 2000)
			vtbeep(2)
		Endif
		Exit
	Enddo
	//
	cEtiqueta := Space(10)
	cOP := Space(11)
	cProduto   := space(tamsx3('B1_COD')[1])
	cDescProd  := space(tamsx3('B1_DESC')[1])
	nQuantProd := 0
	cLote      := space(tamsx3('D3_LOTECTL')[1])
	//
	vtgetrefresh('cEtiqueta')
	vtgetrefresh('cOP')
	vtgetrefresh('cProduto')
	vtgetrefresh('cDescProd')
	vtgetrefresh('nQuantProd')
	vtgetrefresh('cLote')
	//
Enddo
Return
//
//
Static Function PREAPONTA(cQR)
//
CB0->(dbSetOrder(1))
CB0->(dbSeek(xFilial("CB0")+ cQR))
RecLock("CB0", .F.)
CB0->CB0_DTLEIT := Date()
CB0->CB0_HRLEIT := Time()
MsUnlock()
//
SC2->(dbSetOrder(1))
SC2->(dbSeek(xFilial("SC2")+ cOP))
RecLock("SC2", .F.)
SC2->C2_QUJL += nQuantProd
MsUnlock()
//
Return

//
//
Static Function VALIDOP(cQR)
Local lRet         := .T.
Local cDtLeitura := ""
Local cHrLeitura := ""

cOP := Posicione('CB0', 1, xfilial('CB0') + cQR , 'CB0_OP')
cDtLeitura := Posicione('CB0', 1, xfilial('CB0') + cQR , 'CB0_DTLEIT')
cHrLeitura := Posicione('CB0', 1, xfilial('CB0') + cQR , 'CB0_HRLEIT')
nQuantProd := Posicione('CB0', 1, xfilial('CB0') + cQR, 'CB0_QTDE')

if  Empty(cOP) .or. !SC2->(dbSeek(xFilial("SC2")+cOP))
	lRet := .F.
	vtalert('Etiqueta não possui ordem de produção!', 'AVISO', .T., 4000)
	vtgetsetfocus(vtreadvar())
	vtkeyboard(chr(20))
	
ElseIf !Empty(cDtLeitura) .Or. !Empty(cHrLeitura)
	lRet := .F.
	vtalert('Etiqueta já Lida!', 'AVISO', .T., 4000)
	vtgetsetfocus(vtreadvar())
	vtkeyboard(chr(20))
	
Else
	cProduto   := Posicione('SC2', 1, xfilial('SC2') + cOP, 'C2_PRODUTO')
	cUM 			:= Posicione('SC2', 1, xfilial('SC2') + cOP, 'C2_UM')
	cLocal 		:= Posicione('SC2', 1, xfilial('SC2') + cOP, 'C2_LOCAL')
	cCC 			:= Posicione('SC2', 1, xfilial('SC2') + cOP, 'C2_CC')
	nQE          := Posicione('SB1', 1, xfilial('SB1') + cProduto, 'B1_QE2')
	cDescProd := posicione('SB1', 1, xfilial('SB1') + cProduto, 'B1_DESC')
	cLote      	 := substr(cOP, 1, 8)
	//
	vtgetrefresh('cEtiqueta')
	vtgetrefresh('cOP')
	vtgetrefresh('cProduto')
	vtgetrefresh('cDescProd')
	vtgetrefresh('nQuantProd')
	vtgetrefresh('cLote')
Endif
return lRet
