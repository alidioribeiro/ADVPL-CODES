#include "protheus.ch"
#include "apvt100.ch"

Static __nSem:=0

User Function NSACDG02()
Local aTela      := vtsave()
Local nOpcao     := 0
Local cOPOrigem  := space(10)

// Verifica se utiliza controle de transacao.
Private lTTS       := iif(getmv('MV_TTS') == 'S', .T., .F.)
Private aOP        := {}
Private cProduto   := space(tamsx3('B1_COD')[1])
Private cDescProd  := space(tamsx3('B1_DESC')[1])
Private cLote      := space(tamsx3('D3_LOTECTL')[1])
Private cNumLote      := space(tamsx3('D3_NUMLOTE')[1])
Private nQE        := 0
Private nQuantProd := 0
Private cOP := Space(11)
Private cLocal := space(tamsx3('C2_LOCAL')[1])
Private cEtiqueta := Space(10)
Private cEndereco := GETMV('MV_ENDEXP')//Space(tamsx3('DB_LOCALIZ')[1])
Private cDescEnd  := Space(tamsx3('BE_DESCRIC')[1])
Private cDoc := Space(tamsx3('DA_DOC')[1])	
Private cNumSeq := Space(tamsx3('DA_NUMSEQ')[1])	
Private cItem := Space(tamsx3('DB_ITEM')[1])	

abrearq()

while .t. // vtlastkey() <> 27

	vtclear
		
	cEtiqueta  := space(10)   // space(13)
	
	vtreverso(.T.)
	@ 00,02 vtsay 'Enderecamento P.A. '
	vtreverso(.F.)
	
    @ 01,00 vtsay 'Numero da Etiqueta.:'	
	@ 02,00 vtget cEtiqueta picture '@!' valid  !empty(cEtiqueta) .and. ValidOp(cEtiqueta)  f3 'CB0'

	@ 03,00 vtsay 'Prd: '
	@ 03,04 vtget cProduto   picture '@!' when .F.
	//@ 04,00 vtget cDescProd  picture '@!' when .F.

	@ 04,00 vtsay 'Ender. Destino:'
	@ 05,00 vtget cEndereco   picture '@!' valid  ValidEndereco(cLocal, cEndereco) f3 'SBE' //when .F.
	//@ 05,10 vtget cDescEnd    picture '@!' when .F.
	
	@ 06,00 vtsay 'Qtd.:'
	@ 06,06 vtget nQuantProd picture '@E 999,999.99' when .F.
	
	//@ 08,00 vtsay 'Lote  :'
	//@ 09,00 vtget cLote      when .F. 
	vtread

	If VtLastKey() == 27
		Exit
    EndIf
    	
	While .T. && Confirmacao de gravacao da Producao
        cCont := Space(01)
		@ 07,00 vtsay 'Confirma (1=S/0=N)'
		@ 07,18 vtget cCont	 	Picture '9' 	valid fConfirma(@cCont)
		vtread
		If cCont == '1'               
			If !empty(cEndereco)
				vtbeep(2)
				if lTTS
					begin transaction
					endereca(cProduto, cLocal, cEndereco, nQuantProd, cLote, cNumLote, cDoc, cNumSeq)
					dbcommitall()
					end transaction
				else
					endereca(cProduto, cLocal, cEndereco, nQuantProd, cLote, cNumLote, cDoc, cNumSeq)
					dbcommitall()
				endif		
				vtkeyboard(chr(0))
				vtclearbuffer()
			Endif
     	Endif
   	    Exit	     	
	Enddo    	
    //
	cEtiqueta := Space(10)
	cEndereco := Space(tamsx3('DB_LOCALIZ')[1])	
	cProduto   := space(tamsx3('B1_COD')[1])
	cDescProd  := space(tamsx3('B1_DESC')[1])      
	cDescEnd  := space(tamsx3('BE_DESCRIC')[1])      	
	cLote  := space(tamsx3('D3_LOTECTL')[1])      		
	cNumLote  := space(tamsx3('D3_NUMLOTE')[1])      			
	cDoc := Space(tamsx3('DA_DOC')[1])	
	cNumSeq := Space(tamsx3('DA_NUMSEQ')[1])	
	cItem := Space(tamsx3('DB_ITEM')[1])	
	nQuantProd := 0
    //
    vtgetrefresh('cEtiqueta')
	vtgetrefresh('cEndereco')	
	vtgetrefresh('cDescEnd')	
	vtgetrefresh('cProduto')
	vtgetrefresh('cDescProd')
	vtgetrefresh('nQuantProd')
	//
	dbSelectArea("SBE")
	SET FILTER TO
	dbGotop()
	//
Enddo
Return

//
//
Static Function Endereca(cProduto, cLocal, cEndereco, nQuantProd, cLote, cNumLote, cDoc, cNumSeq)
Local nModuloOld := 0
Local aCab := {}
Local aItens:= {}
//
Private lMsErroAuto	:= .F.
Private	lMsHelpAuto	:= .T.
//     
If !Empty(cDoc) .And. !Empty(cNumSeq)

	aCab:= {{"DA_PRODUTO"	     , cProduto 	,NIL},; 
				{"DA_LOCAL"		 , cLocal 		,NIL},;
				{"DA_LOTECTL"	 , cLote 		,NIL},;			
				{"DA_NUMLOTE"	 , cNumLote 	,NIL},;							
				{"DA_DOC"	   	 , cDoc 		,NIL},;						
				{"DA_NUMSEQ"     , cNumSeq 		,NIL}	}
					
	aItens:= {{	{"DB_ITEM"		 , cItem		,NIL},; 
					{"DB_LOCALIZ", cEndereco	,NIL},; 
					{"DB_QUANT"	 , nQuantProd	,NIL},;
					{"DB_DATA"	 , ddatabase	,NIL}; 
				}} 

  
	nModuloOld  := nModulo
	nModulo     := 4
	
	//Begin Sequence
	//AbreSemaf(cNumSeq)
	vtclear
	vtalert('Enderecando .....!', 'AVISO', .T., 4000)
	
	msexecAuto({|x,y| mata265(x,y)},aCab,aItens) //3 Distribui

	vtclear
	vtalert('item Enderecado .....!', 'AVISO', .T., 4000)
	
	//FechaSemaf(cNumSeq)
	//End Sequence
	
	nModulo     := nModuloOld
	
	if lMSErroAuto
		if IsTelnet()
			VTDispFile(NomeAutoLog(),.t.)
		else
			TerDispFile(NomeAutoLog())
		endif
	
		return ! lMSErroAuto
	endif
	
Else 
   vtalert('Nao existe itens para enderecar nesta etiqueta!', 'AVISO', .T., 4000)
Endif                        
return

//
//
Static Function ValidOp(cQR)
Local lRet         := .T.

cProduto := Posicione('CB0', 1, xfilial('CB0') + cQR , 'CB0_CODPRO')
if  !Empty(cProduto)
	nQuantProd := Posicione('CB0', 1, xfilial('CB0') + cQR,	 'CB0_QTDE')
	cLocal     := Posicione('CB0', 1, xfilial('CB0') + cQR,	 'CB0_LOCAL')
	cOP		   := Posicione('CB0', 1, xfilial('CB0') + cQR,	 'CB0_OP')
	cLote	   := Posicione('CB0', 1, xfilial('CB0') + cQR,	 'CB0_LOTE')	
	//cNumLote	   := Posicione('CB0', 1, xfilial('CB0') + cQR,	 'CB0_LOTE')		
	cNumSeq := Posicione('CB0', 1, xfilial('CB0') + cQR,	 'CB0_NUMSEQ')	
    //
	cAlias := Select()
	cIndex := SDA->(Indexord())
	//
	dbSelectArea("SDA")
	dbSetOrder(1)
	dbSeek(xFilial("SDA")+cProduto+cLocal+cNumSeq)
	Do While !Eof() .And. DA_FILIAL+DA_PRODUTO+DA_LOCAL+DA_NUMSEQ == xFilial("SDA")+cProduto+cLocal+cNumSeq
	    If DA_SALDO > 0 .And. DA_LOTECTL == cLote
	       cDoc := DA_DOC
	       nQuantProd := DA_SALDO
	       Exit
	    Endif
		dbSkip()
	Enddo
	dbSetOrder(cIndex)
	dbSelectArea(cAlias)
    //                                  
    If !Empty(cNumSeq) .And. !Empty(cDoc)
		cAlias := Select()
		cIndex := SDB->(Indexord())
		//    
		nItem := 0
		dbSelectArea("SDB")
		dbSetOrder(1)
		dbSeek(xFilial("SDB")+cProduto+cLocal+cNumSeq+cDoc)
		Do While !Eof() .And. DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_NUMSEQ+DB_DOC == xFilial("SDB")+cProduto+cLocal+cNumSeq+cDoc
    		nItem ++
			dbSkip()
		Enddo
		cItem := StrZero(nItem+1,4)
		dbSetOrder(cIndex)
		dbSelectArea(cAlias)
        //
	    dbSelectArea("SBE")
    	SET FILTER TO BE_LOCAL == cLocal
	    dbGotop()    
    	//
    Else
       vtalert('Nao existe saldo a enderecar!', 'AVISO', .T., 4000)
	   lRet := .F.
    Endif
    //
	vtgetrefresh('cProduto')
	vtgetrefresh('nQuantProd')
	vtgetrefresh('cLocal')	
	vtgetrefresh('cOP')		
	vtgetrefresh('cLote')			
Else   
   vtalert('Etiqueta nao encontrada!', 'AVISO', .T., 4000)
   lRet := .F.
Endif
return lRet
//
//
Static Function ValidEndereco(_Local, _Endereco)
Local lRet         := .T.

if  !Empty(cProduto)
	cDescEnd := Posicione('SBE', 1, xfilial('SBE')+ _Local+ _Endereco, 'BE_DESCRIC')
	vtgetrefresh('cDescEnd')
Else   
   vtalert('Endereco nao encontrado!', 'AVISO', .T., 4000)
   lRet := .F.
Endif
return lRet

//
//
Static Function ABREARQ()
// Abre areas de trabalho
dbselectarea('CB0')
dbsetorder(1)

dbselectarea('CB5')
dbsetorder(1)

dbselectarea('SB1')
dbsetorder(1)

dbselectarea('SC2')
dbsetorder(1)

dbselectarea('SD3')
dbsetorder(1)

dbselectarea('SZR')
dbsetorder(1)
return

//
//
Static Function fConfirma(cCont)
Local lRet	:= .t.
If Upper(cCont) != '1' .AND. Upper(cCont) != '0'
	lRet := .F.
Endif
Return(lRet)
