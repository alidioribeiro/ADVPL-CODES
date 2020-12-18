/*#Include "Rwmake.ch"
#Include "TOPCONN.ch"
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"
//#include 'tbiconn.ch'

#DEFINE USADO CHR(0)+CHR(0)+CHR(1)
#DEFINE LINHAS 999

#DEFINE STR0001 ''
#DEFINE STR0002 ''
#DEFINE STR0003 ''
#DEFINE STR0004 ''
#DEFINE STR0005 ''
#DEFINE STR0006 'Codigo'
#DEFINE STR0007 'Descri'
#DEFINE STR0008 'UM'
#DEFINE STR0009 'Almox'
#DEFINE STR0010 'End. Orig.'
#DEFINE STR0011 'Cod. Dest.'
#DEFINE STR0012 'Descri Dest.'
#DEFINE STR0013 'UM Dest.'
#DEFINE STR0014 'Almox Dest.'
#DEFINE STR0015 'End. Dest.'
#DEFINE STR0016 'Num. Serie'
#DEFINE STR0017 'Numlote'
#DEFINE STR0018 'Lote Orig.'
#DEFINE STR0019 'Valid. Orig.'
#DEFINE STR0020 'Quant.'
#DEFINE STR0021 ''
#DEFINE STR0022 ''
#DEFINE STR0023 'DOCUMENTO'
#DEFINE STR0024 'EMISSAO'
#DEFINE STR0044 'Lote Dest.'
#DEFINE STR0046 'Valid. Dest.'

//
//
User Function CTRL_PER()
Private _cFiltro   	:= ''
Private	_bFiltraBrw	:= ''
Private _aIndexZZ6 	:= {}
Private cMarca      := GetMark()
Private InfUser     := {}
Private cCadastro   := "CTRLPER - Controle de Perdas"
Private cRotina     := "LIBPER4050"
//Private aRotina := {	{"Pesquisar","AxPesqui"  		, 0 , 1, 0,.F.} ,; 	//"Pesquisar"
Private aRotina   := {  {"Pesquisar" ,"AxPesqui"        ,0,1,0,.F.} ,;
						{"Visualiza" ,"U_VisualPer"     ,0,2,0,.F.} ,;
						{"Lib.Producao","U_LibPerPrd(1)",0,3,0,.F.} ,;
						{"Lib.C.Q."    ,"U_LibPerCQ(1)" ,0,3,0,.F.} ,;
						{"Lib.Almox"   ,"U_LibPerAlm(1)",0,3,0,.F.} ,;	// {"Rejeitar"    ,"U_LibPer4050(2)" ,0,3,0,.F.} ,;
						{"Realizar"  ,"U_Realiza4050"   ,0,3,0,.F.} ,;						
						{"Imprimir"  ,"U_RLibPer1"      ,0,3,0,.F.} ,;
						{"Legenda"   ,"U_LegPer"        ,0,3,0,.F.} }

Private aCores := {	{ "Eval({|| ZZ6_STATUS==' '  })" , 'BR_VERDE'      },;
					{ "Eval({|| ZZ6_STATUS=='L'  })" , 'BR_AMARELO'    },;  //LIBERADO
				    { "Eval({|| ZZ6_STATUS=='C'  })" , 'BR_AZUL' 	   },;	//LIBERAÇÃO PENDENTE PELO CQ.				
					{ "Eval({|| ZZ6_STATUS=='R'  })" , 'BR_PRETO'      },;										
					{ "Eval({|| ZZ6_STATUS=='T'  })" , 'BR_VERMELHO'   } }


Private lPrdAprova := .F. //iif(_TpLiberacao=="PRD",.t.,.f.)
Private lCQAprova  := .F. //iif(_TpLiberacao=="CQ" ,.t.,.f.)
Private lExecute   := Posicione('ZZ0',1,xFilial('ZZ0')+__cUserID+cRotina,'ZZ0_EXECUT')
Private cCodGrp    := Posicione('ZZ0',1,xFilial('ZZ0')+__cUserID+cRotina,'ZZ0_GRUPO' )
Private cDescGrp   := ""
Private nPercGrp   := 0
Private nValorIni  := 0
Private nValorFim  := 0
Private cUserSup   := ""
Private cUserSupn  := ""
Private aInfoUser  := PswRet()
Private lPermissao := .F.
//                    
//
dbselectarea("ZZ0")
ZZ0->(dbsetorder(1))
ZZ0->(dbSeek(xFilial("ZZ0")+ __cUserId))
Do While !Eof()
	If Alltrim(ZZ0->ZZ0_FUNCAO) == cRotina .AND. ZZ0->ZZ0_EXECUT
		lPermissao := .T.
	Endif
	ZZ0->(dbSkip())
Enddo
//
//
If !lPermissao
	msgstop("Usuario não autorizado a entrar na rotina de autorização de transferencia 40,50!","Retornando...")
	Return
Endif
//
dbSelectArea("ZZ6")
dbSetOrder(1)
dbgobottom()
//
MBrowse(6,1,22,75,"ZZ6",,,,,,aCores,,,,,,,,@_cFiltro)
//
Return
//
//
User Function LibPer4050(_nOpc)
Local lRet := .T.
Local nRecZZ5 := 0

Private _oBrwLotes
Private oDlgLotes
Private _cMarca   := GetMark()
Private aCampos := {}
Private _cTitulo := 'Liberação de perdas no processo'
Private _nOpcao := _nOpc 
Private nCustoTot := 0
Private nCustoPar := 0
//
//Private cRotina := "LIBPER4050"
//
//

If _nOpcao == 1 .and. ZZ6->ZZ6_STATUS == "A" 
	msgInfo("Documento/Item já aprovado!","Atenção")
	Return(.F.)
Endif

If _nOpcao == 1 .and. ZZ6->ZZ6_STATUS == "F" 
	msgInfo("Documento/Item já rejeitado!","Atenção")
	Return(.F.)
Endif

If _nOpcao == 1 .and. ZZ6->ZZ6_STATUS == "T" 
	msgInfo("Documento/Item já transferido!","Atenção")
	Return(.F.)
Endif
//
//
ZZ5->(dbSetOrder(1))
ZZ5->(dbSeek(xFilial("ZZ5")+ cCodGrp))
nRecZZ5 := ZZ5->(Recno())
cDescGrp   := ZZ5->ZZ5_DESCRI
nPercGrp   := ZZ5->ZZ5_PERC             
nValorIni  := ZZ5->ZZ5_VALORI
nValorFim  := ZZ5->ZZ5_VALORF
cUserSup   := ZZ5->ZZ5_CODSUP                                               
cUserSupn  := POSICIONE('ZZ5',1,xFilial('ZZ5')+ZZ5->ZZ5_CODSUP,'ZZ5_DESCRI')
ZZ5->(dbgoto(nRecZZ5))
//
nQryOpc := 0
If ZZ5->ZZ5_LIBPRD 
	nQryOpc := 1

ElseIf ZZ5->ZZ5_LIBCQ
	nQryOpc := 2

ElseIf ZZ5->ZZ5_LIBPRD .AND. ZZ5->ZZ5_LIBCQ
	nQryOpc := 3
	
Endif	
//
//
//If !Empty(ZZ6->ZZ6_CODAUT) .And. !Empty(ZZ6->ZZ6_CODCQL)
//	MSGINFO("Item já liberado!","Atenção")
//	Return(lRet)                                       	
//Endif
//

Cria_TRB(nOpcQry)
							   AADD(aCampos,{'ZZ6_OK'		,'  '        ,'@!','02'	  ,'0'	  })
aTam := TamSX3('ZZ6_DOC'    ); AADD(aCampos,{'ZZ6_DOC'	    ,'Doc.'		 ,'@!',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_OP'     ); AADD(aCampos,{'ZZ6_OP'		,'Ord. Prod.','@!',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_PRODUT' ); AADD(aCampos,{'ZZ6_PRODUT'	,'Cod. Orig.','@!',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_DESCRI' ); AADD(aCampos,{'ZZ6_DESCRI'	,'Desc.Orig.','@!',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_LOCORI' ); AADD(aCampos,{'ZZ6_LOCORI'	,'Arm. Orig.','@!',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_TIPO'	); AADD(aCampos,{'ZZ6_TIPO'		,'Tipo'		 ,'@!',aTam[1],aTam[2]})
							   AADD(aCampos,{'ZZ6_TPDESC'	,'Tp. Desc.' ,'@!',10     ,0      })
aTam := TamSX3('ZZ6_APLIC'  ); AADD(aCampos,{'ZZ6_APLIC'	,'Aplic.'	 ,'@!',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_MOTIVO' ); AADD(aCampos,{'ZZ6_MOTIVO'	,'Motivo'    ,'@!',aTam[1],aTam[2]})
							   AADD(aCampos,{'ZZ6_MOTDES'	,'Mot.Des'   ,'@!',20     ,0      })
aTam := TamSX3('ZZ6_QUANT'  ); AADD(aCampos,{'ZZ6_QUANT'	,'Quant.'    ,PesqPict("ZZ6","ZZ6_QUANT"),aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_DATA'   ); AADD(aCampos,{'ZZ6_DATA'		,'Data'	     ,'@D',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_OBS'	); AADD(aCampos,{'ZZ6_OBS'		,'OBS.'   	 ,'@!',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_OPERAD' ); AADD(aCampos,{'ZZ6_OPERAD'	,'Operador'	 ,'@!',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_RECURS' ); AADD(aCampos,{'ZZ6_RECURS'   ,'Recurso'   ,'@!',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_OPERAC' ); AADD(aCampos,{'ZZ6_OPERAC'	,'Operacao'  ,'@!',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_LOTECT' ); AADD(aCampos,{'ZZ6_LOTECT'	,'Lote Orig.','@!',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_NUMLOT' ); AADD(aCampos,{'ZZ6_NUMLOT'	,'Num. Lote.','@!',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_DTVALI' ); AADD(aCampos,{'ZZ6_DTVALI'	,'Validade'  ,'@D',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_LOCALI' ); AADD(aCampos,{'ZZ6_LOCALI'	,'End. Orig.','@!',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_NUMSER' ); AADD(aCampos,{'ZZ6_NUMSER'	,'Num. Serie','@!',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_LOCAL'  ); AADD(aCampos,{'ZZ6_LOCAL'	,'Arm. Dest.','@!',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_LOCDES' ); AADD(aCampos,{'ZZ6_LOCDES'	,'End. Dest.','@!',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_NSEDES' ); AADD(aCampos,{'ZZ6_NSEDES'	,'N Ser.Dest','@!',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_CODDES' ); AADD(aCampos,{'ZZ6_CODDES'	,'Cod. Dest.','@!',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_QTDDES' ); AADD(aCampos,{'ZZ6_QTDDES'	,'Qtd. Dest.',PesqPict("ZZ6","ZZ6_QTDDES"),aTam[1],aTam[2]})
//
dbSelectArea('ZZ6TMP')
//@ 100,005 TO 500,750 DIALOG oDlgLotes TITLE Alltrim(OemToAnsi(_cTitulo))
//DEFINE DIALOG oDlgLotes FROM 38,16 TO 500,800 TITLE Alltrim(OemToAnsi(_cTitulo)) Pixel // 430,531
@ 006,005 TO 190,380 BROWSE "ZZ6TMP" MARK "ZZ6_OK" FIELDS aCampos Object _oBrwLotes
//
@ 200,010 SAY "Custo total   OP R$:"
//@ 200,060 SAY nCustoTot VAR Object oCustoTot SIZE 50,12 PIXEL OF oDlgLotes
//
@ 220,010 SAY "Custo parcial OP R$:"
//@ 220,060 SAY nCustoPar VAR Object oCustoPar SIZE 50,12 PIXEL OF oDlgLotes
//
//@ 200,200 BUTTON OemtoAnsi("Marcar")    SIZE 50,12 ACTION MarcarTudo()     PIXEL OF oDlgLotes
//@ 200,290 BUTTON OemtoAnsi("Desmarcar") SIZE 50,12 ACTION DesMarcaTudo()   PIXEL OF oDlgLotes
//@ 220,200 BUTTON iif(_nOpcao==1,OemtoAnsi("Autorizar"),OemtoAnsi("Rejeitar")) SIZE 50,12 ACTION LibPerArm()      PIXEL OF oDlgLotes
//@ 220,290 BUTTON OemtoAnsi("Sair")      SIZE 50,12 ACTION FechaTela()      PIXEL OF oDlgLotes
//@ 200,360 BUTTON OemtoAnsi("WF")        SIZE 50,12 ACTION MsAguarde({||U_WFCTRL04()},'Processando...')      PIXEL OF oDlgLotes
//
_oBrwLotes:bMark := {|| Marcar() }
ACTIVATE DIALOG oDlgLotes CENTERED
Return
//
//
User Function LibPerPrd(_nOpc)
Local lRet := .T.
Local nRecZZ5 := 0
//
Private _oBrwLotes
Private oDlgLotes
Private _cMarca   := GetMark()
Private aCampos := {}
Private _cTitulo := 'Liberação de perdas no processo'
Private _nOpcao := _nOpc 
Private nCustoTot := 0
Private nCustoPar := 0
//
//
//Private cRotina := "LIBPER4050"
//
//
If _nOpcao == 1 .and. ZZ6->ZZ6_STATUS == "A" 
	msgInfo("Documento/Item já aprovado!","Atenção")
	Return(.F.)
Endif
//
If _nOpcao == 1 .and. ZZ6->ZZ6_STATUS == "F" 
	msgInfo("Documento/Item já rejeitado!","Atenção")
	Return(.F.)
Endif
//
If _nOpcao == 1 .and. ZZ6->ZZ6_STATUS == "T" 
	msgInfo("Documento/Item já transferido!","Atenção")
	Return(.F.)
Endif
//
//
ZZ5->(dbSetOrder(1))
ZZ5->(dbSeek(xFilial("ZZ5")+ cCodGrp))
nRecZZ5 := ZZ5->(Recno())
cDescGrp   := ZZ5->ZZ5_DESCRI
nPercGrp   := ZZ5->ZZ5_PERC             
nValorIni  := ZZ5->ZZ5_VALORI
nValorFim  := ZZ5->ZZ5_VALORF
cUserSup   := ZZ5->ZZ5_CODSUP                                               
cUserSupn  := POSICIONE('ZZ5',1,xFilial('ZZ5')+ZZ5->ZZ5_CODSUP,'ZZ5_DESCRI')
ZZ5->(dbgoto(nRecZZ5))
//
nQryOpc := 1
If !ZZ5->ZZ5_LIBPRD
	msgStop("O usuário não tem permissão para liberar produção!","Atenção")   
	Return(lRet)
Endif	
//
//
Cria_TRB(nQryOpc)
//							   AADD(aCampos,{'ZZ6_OK'		,'  '        ,'@!','02'	  ,'0'	  })
aTam := TamSX3('ZZ6_DOC'    ); AADD(aCampos,{'ZZ6_DOC'	    ,'Doc.'		 ,'@!',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_OP'     ); AADD(aCampos,{'ZZ6_OP'		,'Ord. Prod.','@!',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_PRODUT' ); AADD(aCampos,{'ZZ6_PRODUT'	,'Cod. Orig.','@!',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_DESCRI' ); AADD(aCampos,{'ZZ6_DESCRI'	,'Desc.Orig.','@!',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_LOCORI' ); AADD(aCampos,{'ZZ6_LOCORI'	,'Arm. Orig.','@!',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_TIPO'	); AADD(aCampos,{'ZZ6_TIPO'		,'Tipo'		 ,'@!',aTam[1],aTam[2]})
							   AADD(aCampos,{'ZZ6_TPDESC'	,'Tp. Desc.' ,'@!',10     ,0      })
aTam := TamSX3('ZZ6_APLIC'  ); AADD(aCampos,{'ZZ6_APLIC'	,'Aplic.'	 ,'@!',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_MOTIVO' ); AADD(aCampos,{'ZZ6_MOTIVO'	,'Motivo'    ,'@!',aTam[1],aTam[2]})
							   AADD(aCampos,{'ZZ6_MOTDES'	,'Mot.Des'   ,'@!',20     ,0      })
aTam := TamSX3('ZZ6_QUANT'  ); AADD(aCampos,{'ZZ6_QUANT'	,'Quant.'    ,PesqPict("ZZ6","ZZ6_QUANT"),aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_DATA'   ); AADD(aCampos,{'ZZ6_DATA'		,'Data'	     ,'@D',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_OBS'	); AADD(aCampos,{'ZZ6_OBS'		,'OBS.'   	 ,'@!',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_OPERAD' ); AADD(aCampos,{'ZZ6_OPERAD'	,'Operador'	 ,'@!',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_RECURS' ); AADD(aCampos,{'ZZ6_RECURS'   ,'Recurso'   ,'@!',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_OPERAC' ); AADD(aCampos,{'ZZ6_OPERAC'	,'Operacao'  ,'@!',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_LOTECT' ); AADD(aCampos,{'ZZ6_LOTECT'	,'Lote Orig.','@!',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_NUMLOT' ); AADD(aCampos,{'ZZ6_NUMLOT'	,'Num. Lote.','@!',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_DTVALI' ); AADD(aCampos,{'ZZ6_DTVALI'	,'Validade'  ,'@D',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_LOCALI' ); AADD(aCampos,{'ZZ6_LOCALI'	,'End. Orig.','@!',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_NUMSER' ); AADD(aCampos,{'ZZ6_NUMSER'	,'Num. Serie','@!',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_LOCAL'  ); AADD(aCampos,{'ZZ6_LOCAL'	,'Arm. Dest.','@!',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_LOCDES' ); AADD(aCampos,{'ZZ6_LOCDES'	,'End. Dest.','@!',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_NSEDES' ); AADD(aCampos,{'ZZ6_NSEDES'	,'N Ser.Dest','@!',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_CODDES' ); AADD(aCampos,{'ZZ6_CODDES'	,'Cod. Dest.','@!',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_QTDDES' ); AADD(aCampos,{'ZZ6_QTDDES'	,'Qtd. Dest.',PesqPict("ZZ6","ZZ6_QTDDES"),aTam[1],aTam[2]})
//
dbSelectArea('ZZ6TMP')
//@ 100,005 TO 500,750 DIALOG oDlgLotes TITLE Alltrim(OemToAnsi(_cTitulo))
//DEFINE DIALOG oDlgLotes FROM 38,16 TO 500,800 TITLE Alltrim(OemToAnsi(_cTitulo)) Pixel //430,531
@ 006,005 TO 190,380 BROWSE "ZZ6TMP" MARK "ZZ6_OK" FIELDS aCampos Object _oBrwLotes
//
@ 200,010 SAY "Custo total   OP R$:"
//@ 200,060 SAY oCustoTot VAR nCustoTot SIZE 50,12 PIXEL OF oDlgLotes
//
@ 220,010 SAY "Custo parcial OP R$:"
//@ 220,060 SAY nCustoPar VAR Object oCustoPar SIZE 50,12 PIXEL OF oDlgLotes
//
//@ 200,200 BUTTON OemtoAnsi("Marcar")    SIZE 50,12 ACTION MarcarTudo()     PIXEL OF oDlgLotes
//@ 200,290 BUTTON OemtoAnsi("Desmarcar") SIZE 50,12 ACTION DesMarcaTudo()   PIXEL OF oDlgLotes
//@ 220,200 BUTTON iif(_nOpcao==1,OemtoAnsi("Autorizar"),OemtoAnsi("Rejeitar")) SIZE 50,12 ACTION LibPerArm()      PIXEL OF oDlgLotes
//@ 220,290 BUTTON OemtoAnsi("Sair")      SIZE 50,12 ACTION FechaTela()      PIXEL OF oDlgLotes
//@ 200,360 BUTTON OemtoAnsi("WF")        SIZE 50,12 ACTION MsAguarde({||U_WFCTRL04()},'Processando...')      PIXEL OF oDlgLotes
//
_oBrwLotes:bMark := {|| Marcar() }
ACTIVATE DIALOG oDlgLotes CENTERED
Return
//
//
Static Function FechaTela()
ZZ6TMP->(dbclosearea())
Close(oDlgLotes)
Return
//
//
Static Function LibPerArm()
Local cUsuario := __cUserID
Local cPassword:= Space(15)
Local lSair    := .F.
Local lRet     := .F.
Local cCont    := Space(01)

Private oDlgAut
Private cNomeUsu := cUserName
Private oNomeUsu
Private cPMotDesc := Space(TamSX3('ZZ2_DESCRI')[1])
Private oPMotDesc := Nil
Private cPObservacao := Space(TamSX3('ZZ6_OBSERV')[1])
Private oPObservacao := Nil
Private cQMotDesc := Space(TamSX3('ZZ2_DESCRI')[1])
Private oQMotDesc := Nil
Private cQObservacao := Space(TamSX3('ZZ6_OBSERV')[1])
Private oQObservacao := Nil
Private cPMotivo  := Space(TamSX3('ZZ2_COD')[1])
Private cQMotivo  := Space(TamSX3('ZZ2_COD')[1])
//
//
/*/
PswEncript(cStrEncrypt,nType) -> cStrEncrypt || cStrDecrypt
Str2Array(cSPFDet,lEncrypt) -> aSPFDet
Array2Str(aSPFDet,lEncrypt) -> cSPFDet
PswOrder(nPswOrder)
PswSeek(cPswKey) -> lFound
PswRet(nType) -> aPswDet
PswRecno() -> nPswRecno
AllGroups() -> aPswGroups
AllUsers() -> aPswUsers
PswUsrGrp(cPswUserId,cPswGroupId) -> lPswUserInPswGroup               
/*/
aPUser := {}
aQUSer := {}
PswOrder(1)
If lPrdAprova
   aPUser := aInfoUser
   PswSeek(ZZ6->ZZ6_CODCQL)
   aQUser := PswRet()
   cQMotivo     := ZZ6->ZZ6_MOTCQL
   cQMotDesc    := Posicione('ZZ2',1,xFilial('ZZ2')+ZZ6->ZZ6_MOTCQL,'ZZ2_DESCRI')
   cQObservacao := ZZ6->ZZ6_OBSCQL   

ElseIf lCqAprova 
   aQUser := aInfoUser     
   PswSeek(ZZ6->ZZ6_CODAUT)   
   aPUser := PswRet()             
   cPMotivo     := ZZ6->ZZ6_CODMOT   
   cPMotDesc    := Posicione('ZZ2',1,xFilial('ZZ2')+ZZ6->ZZ6_CODMOT,'ZZ2_DESCRI')
   cPObservacao := ZZ6->ZZ6_OBSERV
Endif
//
//@ 100,005 TO 300,750 DIALOG oDlgAut TITLE "Autorizar"
DEFINE MSDIALOG oDlgAut FROM 05,10 TO 400,620 TITLE Alltrim(OemToAnsi('Autorizar Perda')) Pixel Style 128 //430,531
//@ 005, 083 Say _oTecAloc Var _cTecAloc Font oFontWin Of oFolder:aDialogs[3] Pixel
DEFINE FONT oArial12 NAME 'Arial' SIZE 06,12 BOLD
DEFINE FONT oArial14 NAME 'Arial' SIZE 06,14 BOLD
//
//@ 005,005 TO 065,300 LABEL 'Liberação da Produção'  PIXEL OF oDlgAut
//@ 015,015 say   'ID:'            	SIZE 030,10 PIXEL OF oDlgAut //COLOR CLR_BLUE
//@ 015,030 say   aPUser[1,1]  		SIZE 080,10 PIXEL oF oDlgAut FONT oArial14 COLOR CLR_RED
//@ 015,075 say   'Usuario:'       	SIZE 030,10 PIXEL OF oDlgAut //COLOR CLR_BLUE
//@ 015,100 say   aPUser[1,2]  		SIZE 080,10 PIXEL oF oDlgAut FONT oArial14 COLOR CLR_RED
//@ 015,150 say   'Nome:'          	SIZE 030,10 PIXEL OF oDlgAut //COLOR CLR_BLUE
//@ 015,170 say   aPUser[1,4]		  	SIZE 080,10 PIXEL of oDlgAut FONT oArial14 COLOR CLR_RED
//@ 030,015 say   'Motivo :'          SIZE 020,10 PIXEL OF oDlgAut //COLOR CLR_BLUE
//@ 030,045 MSGet cPMotivo   Picture '@!'   Valid  naovazio(cPMotivo) .and. ValidMot(cPMotivo)  F3 'ZZ2TRF'  SIZE 020,10  PIXEL of oDlgAut COLOR CLR_BLUE WHEN lPrdAprova
//@ 030,090 say   oPMotDesc  Var cPMotDesc  SIZE 160,10 PIXEL OF oDlgAut //COLOR CLR_BLUE
//@ 045,015 say   'Observ.:'                SIZE 020,10 PIXEL OF oDlgAut //COLOR CLR_BLUE
//@ 045,045 MSGet cPObservacao Picture '@!' Valid  naovazio(cPObservacao) .and. Alltrim(cPObservacao) != "."  SIZE 250,10  PIXEL of oDlgAut COLOR CLR_BLUE WHEN lPrdAprova
//                                    
//If 
/*	@ 070,005 TO 130,300 LABEL 'Liberação da Qualidade' PIXEL OF oDlgAut                                   
	@ 080,015 say   'ID:'            	SIZE 030,10 PIXEL OF oDlgAut //COLOR CLR_BLUE
	@ 080,030 say   aQUser[1,1]  		SIZE 080,10 PIXEL oF oDlgAut FONT oArial14 COLOR CLR_RED
	@ 080,075 say   'Usuario:'       	SIZE 030,10 PIXEL OF oDlgAut //COLOR CLR_BLUE
	@ 080,100 say   aQUser[1,2]  		SIZE 080,10 PIXEL oF oDlgAut FONT oArial14 COLOR CLR_RED
	@ 080,150 say   'Nome:'          	SIZE 030,10 PIXEL OF oDlgAut //COLOR CLR_BLUE
	@ 080,170 say   aQUser[1,4] 	 	SIZE 080,10 PIXEL of oDlgAut FONT oArial14 COLOR CLR_RED
	@ 095,015 say   'Motivo :'          SIZE 020,10 PIXEL OF oDlgAut //COLOR CLR_BLUE
	@ 095,045 MSGet cQMotivo   Picture '@!'   Valid  naovazio(cQMotivo) .and. ValidMot(cQMotivo)  F3 'ZZ2TRF'  SIZE 020,10  PIXEL of oDlgAut COLOR CLR_BLUE WHEN lCQAprova
	@ 095,090 say   oQMotDesc  Var cQMotDesc  SIZE 160,10 PIXEL OF oDlgAut COLOR CLR_BLUE
	@ 110,015 say   'Observ.:'                SIZE 020,10 PIXEL OF oDlgAut //COLOR CLR_RED
	@ 110,045 MSGet cQObservacao Picture '@!' Valid  naovazio(cQObservacao) .and. Alltrim(cQObservacao) != "."  SIZE 250,10  PIXEL of oDlgAut COLOR CLR_BLUE WHEN lCQAprova
*/	
//Endif
//
/*
If _nOpcao == 1
	@ 150,100 BUTTON "Liberar"     SIZE 40,15 ACTION MsAguarde({|| ChkValPer() .and. LiberaPer(__cUserID, cUserName, cPMotivo, cPObservacao), Close(oDlgAut)},'Processando...') PIXEL OF oDlgAut
Else
	@ 150,100 BUTTON "Rejeitar"    SIZE 40,15 ACTION MsAguarde({|| RejeitaPer(__cUserID, cUserName, cQMotivo, cQObservacao), Close(oDlgAut)},'Processando...') PIXEL OF oDlgAut
Endif                 
//
@ 150,150 BUTTON "Sair"          SIZE 40,15 ACTION MsAguarde({|| Close(oDlgAut)},'Processando...') PIXEL OF oDlgAut
//ACTIVATE DIALOG oDlgAut CENTERED
ACTIVATE MSDIALOG oDlgAut CENTERED //ON INIT EnchoiceBar(oWindow,&(bOk),&(bCancel),,aButtons)
//*/
Return
//
//
Static Function ChkValPer()
Local lRet   := .T.
Local cQuery := ""
Local nCusPerZZ6 := 0
Local nCusPerSBC := 0
Local nCusTotSC2  := 0
Local cOp        := ""
//              
//                                 
If _nOpcao == 2 .or. (_nOpcao == 1 .and. lCqAprova)
	Return(.T.)
Endif                    
//
ZZ6TMP->(dbGotop())
cOp := Left(ZZ6TMP->ZZ6_OP,11)
Do While ZZ6TMP->(!Eof())
	If ZZ6TMP->ZZ6_OK == _cMarca
		//If (!Empty(ZZ6->ZZ6_CODAUT) .and. lCqAprova) .or. (!Empty(ZZ6->ZZ6_CODCQL) .and. lPrdAprova)
			aSaldo := CalcEst(ZZ6TMP->ZZ6_PRODUT, ZZ6TMP->ZZ6_LOCORI, dDatabase+1)
			nCusPerZZ6 += (ZZ6TMP->ZZ6_QUANT * (aSaldo[2]/aSaldo[1]))
		//Endif
	Endif
	ZZ6TMP->(dbSkip())
Enddo
ZZ6TMP->(dbGotop())
//
If nCusPerZZ6 > 0
	//
	SBC->(dbSeek(xFilial("SBC")+ cOp))
	Do While SBC->(!Eof()) .AND. Left(SBC->BC_OP,11) == cOp
		aSaldo := CalcEst(SBC->BC_PRODUTO, SBC->BC_LOCORIG, dDatabase+1)
		nCusPerSBC += (SBC->BC_QUANT * (aSaldo[2]/aSaldo[1]))
		SBC->(dbSkip())
	Enddo
	//
	nCodPro    := Posicione('SC2',1,xFilial('SC2')+cOp,'C2_PRODUTO')
	cLocPro    := Posicione('SC2',1,xFilial('SC2')+cOp,'C2_LOCAL'  )
	nQtdSC2    := Posicione('SC2',1,xFilial('SC2')+cOp,'C2_QUANT'  )
	aSaldo 	   := CalcEst(nCodPro, cLocPro, dDatabase+1)
	nCusTotSC2 := nQtdSC2 * (aSaldo[2]/aSaldo[1])
	//
	//lExecute    := Posicione('ZZ0',1,xFilial('ZZ0')+__cUserID+cRotina ,'ZZ0_EXECUT')
	//cCodGrp 	  := Posicione('ZZ0',1,xFilial('ZZ0')+__cUserID+cRotina ,'ZZ0_GRUPO' )
	//cDescGrp    := Posicione('ZZ5',1,xFilial('ZZ5')+cCodGrp           ,'ZZ5_DESCRI')
	//nPercGrp    := Posicione('ZZ5',1,xFilial('ZZ5')+cCodGrp           ,'ZZ5_PERC'  )
	//
	//MSGINFO(cCodGrp+"-"+str(nPercGrp))
	cMens_cal := "Perdas já apontadas: R$ "+Alltrim(Str(nCusPerSBC,15,2))
	cMens_cal += "  Perdas a apontar: R$ "   +Alltrim(Str(nCusPerZZ6,15,2))
	cMens_cal += "  Somam = R$ " +Alltrim(Str(nCusPerSBC + nCusPerZZ6,15,2))
	cMens_cal += "  Custo da OP: R$ " +Alltrim(Str(nCusTotSC2,15,2))  
	cMens_cal += "  Percentual de perda realizado e a realizar: " +Alltrim(Str((nCusPerSBC+nCusPerZZ6)/nCusTotSC2*100,15,2))+" (%) "
	cMens_cal += "  Limite do usuario: R$ "+Alltrim(Str(nValorFim,13,2))
	cMens_cal += "  Limite disponivel do usuario: R$ " +iif(nValorFim-nCusPerSBC<0,"0,00",Alltrim(Str(nValorFim-nCusPerSBC,13,2)))+ "	"
	msginfo(cMens_cal,"Informação")
	//
	//msginfo("Custo de perdas: "+str((nCusPerSBC + nCusPerZZ6) / nCusTotSC2 * 100))
	//msginfo("Custo de perdas: "+str((nCusPerSBC + nCusPerZZ6) / nCusTotSC2 * 100))
	//
	If !((nCusPerSBC+nCusPerZZ6) >= nValorIni .and. (nCusPerSBC+nCusPerZZ6) <= nValorFim)
		cMsg := "O custo das perdas apontadas anteriormente somado ao custo das perdas que deseja liberar no momento "
		cMsg += " ultrapassam o limite permitido para o usuário/alçada: "+Alltrim(cUserName)+" / "+Alltrim(cDescGrp)+" "
		cMsg += " que é de R$ "+Alltrim(Str(nValorIni,13,2))+" até R$ "+Alltrim(Str(nValorFim,13,2))
		cMsg += " Para liberar esta perda será necessário solicitar que um usuário com nivel de alçada maior efetue a liberação!"
		cMsg += " O próximo nivel é: "+ UPPER(cUsersupn)
		msgInfo(cMsg,"Atenção")
		lRet := .F.
	Endif
Endif
Return(lRet)
//
//
Static FUNCTION Cria_TRB(_nOpcQry)
//
If Select("ZZ6TMP") <> 0
	ZZ6TMP->(dbCloseArea())
Endif
//
aFields   := {}
							   AADD(aFields,{"ZZ6_OK"       ,"C",     02,      0})
aTam := TamSX3('ZZ6_DOC'    ); AADD(aFields,{'ZZ6_DOC'		,'C',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_OP'     ); AADD(aFields,{'ZZ6_OP'		,'C',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_PRODUT' ); AADD(aFields,{'ZZ6_PRODUT'	,'C',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_DESCRI' ); AADD(aFields,{'ZZ6_DESCRI'	,'C',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_LOCORI' ); AADD(aFields,{'ZZ6_LOCORI'   ,'C',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_TIPO'   ); AADD(aFields,{'ZZ6_TIPO'     ,'C',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_TPDESC' ); AADD(aFields,{'ZZ6_TPDESC'   ,'C',10     ,0      })
aTam := TamSX3('ZZ6_APLIC'  ); AADD(aFields,{'ZZ6_APLIC'	,'C',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_MOTIVO' ); AADD(aFields,{'ZZ6_MOTIVO'   ,'C',aTam[1],aTam[2]})
                               AADD(aFields,{'ZZ6_MOTDES'   ,'C',20     ,0      })
aTam := TamSX3('ZZ6_QUANT'  ); AADD(aFields,{'ZZ6_QUANT'    ,'N',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_CUSTO'  ); AADD(aFields,{'ZZ6_CUSTO'    ,'N',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_DATA'   ); AADD(aFields,{'ZZ6_DATA'     ,'D',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_OBS'    ); AADD(aFields,{'ZZ6_OBS'      ,'C',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_OPERAD' ); AADD(aFields,{'ZZ6_OPERAD'   ,'C',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_RECURS' ); AADD(aFields,{'ZZ6_RECURS'   ,'C',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_OPERAC' ); AADD(aFields,{'ZZ6_OPERAC'   ,'C',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_LOTECT' ); AADD(aFields,{'ZZ6_LOTECT'	,'C',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_NUMLOT' ); AADD(aFields,{'ZZ6_NUMLOT'   ,'C',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_DTVALI' ); AADD(aFields,{'ZZ6_DTVALI'   ,'D',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_LOCALI' ); AADD(aFields,{'ZZ6_LOCALI'   ,'C',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_NUMSER' ); AADD(aFields,{'ZZ6_NUMSER'   ,'C',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_LOCAL'  ); AADD(aFields,{'ZZ6_LOCAL'    ,'C',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_LOCDES' ); AADD(aFields,{'ZZ6_LOCDES'   ,'C',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_NSEDES' ); AADD(aFields,{'ZZ6_NSEDES'   ,'C',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_CODDES' ); AADD(aFields,{'ZZ6_CODDES'	,'C',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_QTDDES' ); AADD(aFields,{'ZZ6_QTDDES'   ,'N',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_CODAUT' ); AADD(aFields,{'ZZ6_CODAUT'   ,'C',aTam[1],aTam[2]})
aTam := TamSX3('ZZ6_CODCQL' ); AADD(aFields,{'ZZ6_CODCQL'   ,'C',aTam[1],aTam[2]})
							   AADD(aFields,{'ZZ6_RECNO'    ,'N',15,0})
//
cArq:=Criatrab(aFields,.T.)
dbUseArea(.t.,,cArq,"ZZ6TMP")
//
cQuery := " "
cQuery += " SELECT ZZ6_OK=SPACE(02), A.*, B.B1_DESC " //ZZ6_OP AS OP, A.ZZ6_RECURS AS RECURSO, A.ZZ6_OPERAC AS OPERACAO, "
cQuery += " FROM "+RetSqlName("ZZ6")+" AS A  INNER JOIN "+RetSqlName("SB1")+" AS B ON (A.ZZ6_PRODUT=B.B1_COD) "
cQuery += " WHERE A.D_E_L_E_T_<>'*' AND B.D_E_L_E_T_<>'*' "
cQuery += " AND ZZ6_FILIAL   = '"+xFilial("ZZ6")+"' "
cQuery += " AND  B1_FILIAL   = '"+xFilial("SB1")+"' "
cQuery += " AND ZZ6_OP       = '"+ZZ6->ZZ6_OP   +"' "
//
if _nOpcQry  == 1
	cQuery += " AND ZZ6_STATUS   = ' ' "
	
elseif _nOpcQry  == 2
	cQuery += " AND ZZ6_STATUS   = 'C' "

elseif _nOpcQry  == 3
	cQuery += " AND ZZ6_STATUS   IN (' ','C') "

endif
//cQuery += " GROUP BY ZZ6_DATA, ZZ6_LOCAL, ZZ6_LOCALI, ZZ6_LOTECT, ZZ6_COD, B1_UM, B1_DESC "
cQuery += " ORDER BY ZZ6_PRODUT, ZZ6_LOCORI, ZZ6_LOTECT "
//
//MSGINFO(CQUERY)
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"ZZ6QRY",.T.,.T.)
aTam := TamSX3('ZZ6_QUANT' ); TcSetField("ZZ6QRY","ZZ6_QUANT" ,"N",aTam[1],aTam[2])
aTam := TamSX3('ZZ6_QTDDES'); TcSetField("ZZ6QRY","ZZ6_QTDDES","N",aTam[1],aTam[2])
aTam := TamSX3('ZZ6_DATA'  ); TcSetField("ZZ6QRY","ZZ6_DATA"  ,"D",aTam[1],aTam[2])
aTam := TamSX3('ZZ6_DTAUT' ); TcSetField("ZZ6QRY","ZZ6_DTAUT" ,"D",aTam[1],aTam[2])
aTam := TamSX3('ZZ6_DTCQL' ); TcSetField("ZZ6QRY","ZZ6_DTCQL" ,"D",aTam[1],aTam[2])
aTam := TamSX3('ZZ6_DTVALI'); TcSetField("ZZ6QRY","ZZ6_DTVALI","D",aTam[1],aTam[2])
aTam := TamSX3('ZZ6_CUSTO') ; TcSetField("ZZ6QRY","ZZ6_CUSTO" ,"N",aTam[1],aTam[2])
//							  TcSetField("ZZ6QRY","ZZ6_RECNO" ,"N",15,0)
//
dbselectarea("ZZ6QRY")
Do While ZZ6QRY->(!EOF())
	//
	RecLock("ZZ6TMP",.T.)
	ZZ6TMP->ZZ6_OK  	:= _cMarca  //ThisMark()
	ZZ6TMP->ZZ6_DOC 	:= ZZ6QRY->ZZ6_DOC
	ZZ6TMP->ZZ6_OP  	:= ZZ6QRY->ZZ6_OP
	ZZ6TMP->ZZ6_RECURS  := ZZ6QRY->ZZ6_RECURS
	ZZ6TMP->ZZ6_OPERAC	:= ZZ6QRY->ZZ6_OPERAC
	ZZ6TMP->ZZ6_PRODUT 	:= ZZ6QRY->ZZ6_PRODUT
	ZZ6TMP->ZZ6_DESCRI  := Posicione("SB1",1,xFilial("SB1")+ZZ6QRY->ZZ6_PRODUT,"B1_DESC") //Posicione("SZC",1,xFilial("SZC")+ZZ6QRY->ZZ6_MOTIVO,"ZC_DESC")
	ZZ6TMP->ZZ6_LOCORI 	:= ZZ6QRY->ZZ6_LOCORI
	ZZ6TMP->ZZ6_TIPO   	:= ZZ6QRY->ZZ6_TIPO
	//
	If 	   ZZ6QRY->ZZ6_TIPO	== 'R' //R=Refugo;S=Scrap;D=Devolucao;T=Retrabalho
		ZZ6TMP->ZZ6_TPDESC := "Refugo"
	Elseif ZZ6QRY->ZZ6_TIPO == 'S'
		ZZ6TMP->ZZ6_TPDESC := "Scrap"
	Elseif ZZ6QRY->ZZ6_TIPO == 'D'
		ZZ6TMP->ZZ6_TPDESC := "Devolucao"
	Elseif ZZ6QRY->ZZ6_TIPO == 'T'
		ZZ6TMP->ZZ6_TPDESC := "Retrabalho"
	Endif
	//
	ZZ6TMP->ZZ6_APLIC   := ZZ6QRY->ZZ6_APLIC
	ZZ6TMP->ZZ6_MOTIVO 	:= ZZ6QRY->ZZ6_MOTIVO
	ZZ6TMP->ZZ6_MOTDES 	:= Posicione("SZC",1,xFilial("SZC")+ZZ6QRY->ZZ6_MOTIVO,"ZC_DESC")
	ZZ6TMP->ZZ6_QUANT	:= ZZ6QRY->ZZ6_QUANT
	ZZ6TMP->ZZ6_CUSTO   := ZZ6QRY->ZZ6_QUANT * Posicione("SB2",1,xFilial("SB2")+ZZ6QRY->ZZ6_PRODUT+ZZ6QRY->ZZ6_LOCORI,"B2_CM1")
	ZZ6TMP->ZZ6_DATA   	:= ZZ6QRY->ZZ6_DATA
	ZZ6TMP->ZZ6_OBS 	:= ZZ6QRY->ZZ6_OBS
	ZZ6TMP->ZZ6_OPERAD  := ZZ6QRY->ZZ6_OPERAD
	ZZ6TMP->ZZ6_RECURS  := ZZ6QRY->ZZ6_RECURS
	ZZ6TMP->ZZ6_OPERAC  := ZZ6QRY->ZZ6_OPERAC
	ZZ6TMP->ZZ6_LOTECT  := ZZ6QRY->ZZ6_LOTECT
	ZZ6TMP->ZZ6_NUMLOT  := ZZ6QRY->ZZ6_NUMLOT
	ZZ6TMP->ZZ6_DTVALI  := ZZ6QRY->ZZ6_DTVALI
	ZZ6TMP->ZZ6_LOCALI  := ZZ6QRY->ZZ6_LOCALI
	ZZ6TMP->ZZ6_NUMSER  := ZZ6QRY->ZZ6_NUMSER
	ZZ6TMP->ZZ6_LOCAL   := ZZ6QRY->ZZ6_LOCAL
	ZZ6TMP->ZZ6_LOCDES  := ZZ6QRY->ZZ6_LOCDES
	ZZ6TMP->ZZ6_NSEDES  := ZZ6QRY->ZZ6_NSEDES
	ZZ6TMP->ZZ6_CODDES  := ZZ6QRY->ZZ6_CODDES
	ZZ6TMP->ZZ6_QTDDES  := ZZ6QRY->ZZ6_QUANT
	ZZ6TMP->ZZ6_CODAUT  := ZZ6QRY->ZZ6_CODAUT
	ZZ6TMP->ZZ6_CODCQL  := ZZ6QRY->ZZ6_CODCQL	
	ZZ6TMP->ZZ6_RECNO   := ZZ6QRY->R_E_C_N_O_
	ZZ6TMP->(MsUnLock())
	//
	dbSelectArea('ZZ6QRY')
	ZZ6QRY->(dbskip())
EndDo
//
ZZ6QRY->(dbCloseArea())
//
dbselectarea("ZZ6TMP")
dbGoTop()
SysRefresh()
Return
//
//

//
//
Static Function MarcarTudo()
dbSelectArea('ZZ6TMP')
dbGoTop()
While !Eof()
	//MsProcTxt('Aguarde...')
	RecLock('ZZ6TMP',.F.)
	ZZ6TMP->ZZ6_OK := _cMarca
	MsUnlock()
	dbSkip()
EndDo
DbGoTop()
DlgRefresh(oDlgLotes)
SysRefresh()
Return(.T.)
//
//
Static Function DesmarcaTudo()
dbSelectArea('ZZ6TMP')
dbGoTop()
While !Eof()
	//MsProcTxt('Aguarde...')
	RecLock('ZZ6TMP',.F.)
	ZZ6TMP->ZZ6_OK := ThisMark()
	MsUnlock()
	dbSkip()
Enddo
dbGoTop()
DlgRefresh(oDlgLotes)
SysRefresh()
Return(.T.)
//
//
Static Function Marcar()
dbSelectArea('ZZ6TMP')
RecLock('ZZ6TMP',.F.)
If Empty(ZZ6TMP->ZZ6_OK)
	ZZ6TMP->ZZ6_OK := _cMarca
Endif
MsUnlock()
DlgRefresh(oDlgLotes)
SysRefresh()
Return(.T.)
//
//
STATIC FUNCTION ValidUsr(_cUsuario, _cFuncao)
Local lRet := .F.

If ZZ0->(dbSeek(xFilial("ZZ0")+ _cUsuario+ Upper(_cFuncao)))
	If ZZ0->ZZ0_EXECUT
		cNomeUsu := ZZ0->ZZ0_NOME
		oNomeUsu:Refresh()
		//
		lRet := .T.
	Else
		msgstop('Usuario nao autorizado a utilizar esta função!', 'AVISO')
	Endif
Else
	msgstop('Usuario nao cadastrado para utilizar esta função!', 'AVISO')
Endif
Return(lRet)
//
//
STATIC FUNCTION ValidMot(_cMotivo)
Local lRet := .F.

If ZZ2->(dbSeek(xFilial("ZZ2")+ _cMotivo))	
	If lPrdAprova
		cPMotDesc := ZZ2->ZZ2_DESCRI
		oPMotDesc:Refresh()
	Endif	
	If lCqAprova
		cQMotDesc := ZZ2->ZZ2_DESCRI
		oQMotDesc:Refresh()
	Endif	
	//
	lRet := .T.
Else
	msgstop('Motivo nao cadastrado!', 'AVISO')                                                     Ó
Endif
Return(lRet)
//
//
Static Function RejeitaPer(_cCodAut,_cNomeAut,_cMotivo, _cObservacao)
Local lRet := .T.
Local cDoc:="", cOp:=""

If Empty(_cMotivo)
	msgstop("O motivo não pode ser vazio!","Aviso")
	Return(.F.)
Endif
//               
aWFREJ  := {}     
cHrAut  := Time()
lGravou := .F.   
ZZ6TMP->(dbGotop())
Do While ZZ6TMP->(!Eof())
	If ZZ6TMP->ZZ6_OK == _cMarca
		If (!Empty(ZZ6->ZZ6_CODAUT) .and. lCqAprova) .or. (!Empty(ZZ6->ZZ6_CODCQL) .and. lPrdAprova)
			cQuery := " UPDATE "+RetSqlName("ZZ6")+" "
			If lPrdAprova
				cQuery += " SET ZZ6_CODAUT = '"+_cCodAut       +"', ZZ6_NOMEAU = '"+_cNomeAut+"', "
				cQuery += "     ZZ6_DTAUT  = '"+dTos(dDatabase)+"', ZZ6_HRAUT  = '"+cHrAut   +"', "
				cQuery += "     ZZ6_CODMOT = '"+_cMotivo+"', "
				cQuery += "     ZZ6_OBSERV = '"+Alltrim(_cObservacao)+"', "
				cQuery += "     ZZ6_STATUS = 'R' "				
			Endif
			If lCqAprova
				cQuery += " SET ZZ6_CODCQL = '"+_cCodAut       +"', ZZ6_NOMCQL = '"+_cNomeAut+"', "
				cQuery += "     ZZ6_DTCQL  = '"+dTos(dDatabase)+"', ZZ6_HRCQL  = '"+cHrAut   +"', "
				cQuery += "     ZZ6_MOTCQL = '"+_cMotivo+"', "
				cQuery += "     ZZ6_OBSCQL = '"+Alltrim(_cObservacao)+"', "				
				cQuery += "     ZZ6_STATUS = 'R' "
			Endif      
			//cQuery+="     ZZ6_NSEQD3 = '"+Alltrim(xSEQSD3)+"' "
			cQuery += " FROM "+RetSqlName("ZZ6")+" "
			cQuery += " WHERE "
			cQuery += " D_E_L_E_T_<>'*' "
			cQuery += " AND ZZ6_FILIAL = '"+xFilial("ZZ6")    +"' "
			cQuery += " AND ZZ6_DOC    = '"+ZZ6TMP->ZZ6_DOC   +"' "
			cQuery += " AND ZZ6_OP     = '"+ZZ6TMP->ZZ6_OP    +"' "
			cQuery += " AND ZZ6_PRODUT = '"+ZZ6TMP->ZZ6_PRODUT+"' "
			cQuery += " AND ZZ6_LOCORI = '"+ZZ6TMP->ZZ6_LOCORI+"' "
			cQuery += " AND ZZ6_LOCALI = '"+ZZ6TMP->ZZ6_LOCALI+"' "
			cQuery += " AND ZZ6_LOTECT = '"+ZZ6TMP->ZZ6_LOTECT+"' "
			cQuery += " AND R_E_C_N_O_ =  "+STR(ZZ6TMP->ZZ6_RECNO)+" "			
			//
			IF lPrdAprova
				cQuery += " AND ZZ6_CODAUT = '' "
				cQuery += " AND ZZ6_CODCQL = '"+ZZ6TMP->ZZ6_CODCQL+"' "									
			Endif	
			If lCqAprova                       
				cQuery += " AND ZZ6_CODCQL = '' "
				cQuery += " AND ZZ6_CODAUT = '"+ZZ6TMP->ZZ6_CODAUT+"' "				
			Endif
			//
			aadd(aWFREJ, Alltrim(Str(ZZ6TMP->ZZ6_RECNO)) )
			//
			lGravou := .T.
			//MSGINFO(CQUERY)
			TCSQLEXEC(cQuery)			
			cDoc := ZZ6TMP->ZZ6_DOC
			cOp  := ZZ6TMP->ZZ6_OP
		Endif				
	Endif
	ZZ6TMP->(dbSkip())
Enddo
//
_cRecList := ""
If Len(aWFREJ) > 0
	For nX := 1 to Len(aWFREJ)
		_cRecList += aWFREJ[nX] + iif(nX<>Len(aWFREJ),",","")
	Next
	_cRecList := fContidoSQL(_cRecList)				    
Endif
//msginfo(_cRecList)
//
If !Empty(_cRecList)
	U_WFCTRL02(_cRecList)
Endif
//
If ZZ6TMP->(Reccount()) > 0
	FechaTela()
Else
	_oBrwLotes:Refresh()
	DlgRefresh(oDlgLotes)
	SysRefresh()
	//
	oObjBrow := GetObjBrow() //Obtém o ultimo Objeto Browse
	oObjBrow:ResetLen()
	oObjBrow:GoTop()
	oObjBrow:Refresh()
Endif

Return(lRet)
//
//
Static Function LiberaPer(_cCodAut,_cNomeAut,_cMotivo, _cObservacao)
Local lRet 	  := .T.
Local cAlias  := Select()
Local lGravou := .T.
Local cHrAut  := ""
Local cDoc := ""
Local cOp  := ""

Private xSeqSD3 := SPACE(TamSX3('BC_SEQSD3')[01])
Private aTransf := {}


If Empty(_cMotivo)
	msgstop("O motivo não pode ser vazio!","Aviso")
	Return(.F.)
Endif
//        
lMsErroAuto := .F.
lMsHelpAuto := .T.
//          
lMarcados := .F.
ZZ6TMP->(dbGotop())
Do While ZZ6TMP->(!Eof())
	If ZZ6TMP->ZZ6_OK == _cMarca 			
		lMarcados := .T.
	Endif
	//
	ZZ6TMP->(dbSkip())	
Enddo		   
//
If !lMarcados
	msgstop("É necessário marcar algum item para efetuar a liberação!","Aviso")
	Return(.F.)
Endif
//

aWFREJ  := {}     	
aCabec2 := {}  //Array(Len(aEtiqueta)+1)
aItens2 := {}
aLinha2 := {}          
//
cHrAut  := Time()			
ZZ6TMP->(dbGotop())

aCabec2 := {{"BC_OP"     , ZZ6->ZZ6_OP	 	,NIL},;
			{"BC_RECURSO", ZZ6->ZZ6_RECURS 	,NIL},;
			{"BC_OPERAC" , ZZ6->ZZ6_OPERAC	,NIL}}	
//						{"BC_RECURSO", ZZ6TMP->ZZ6_RECURS   ,NIL},;
Do While ZZ6TMP->(!Eof())
	If ZZ6TMP->ZZ6_OK == _cMarca 			
		If (!Empty(ZZ6->ZZ6_CODAUT) .and. lCqAprova ) .or. (!Empty(ZZ6->ZZ6_CODCQL) .and. lPrdAprova)
		    //
			aItens2 := {{"BC_PRODUTO", ZZ6TMP->ZZ6_PRODUT   ,NIL},;
						{"BC_QUANT"  , ZZ6TMP->ZZ6_QUANT    ,NIL},;
						{"BC_LOCORIG", ZZ6TMP->ZZ6_LOCORI   ,NIL},;
						{"BC_LOCALIZ", ZZ6TMP->ZZ6_LOCALI   ,NIL},;
						{"BC_TIPO"   , ZZ6TMP->ZZ6_TIPO     ,NIL},;
						{"BC_APLIC"  , ZZ6TMP->ZZ6_APLIC    ,NIL},;
						{"BC_MOTIVO" , ZZ6TMP->ZZ6_MOTIVO   ,NIL},;
						{"BC_DATA"   , ZZ6TMP->ZZ6_DATA     ,NIL},;
						{"BC_OBS"    , ZZ6TMP->ZZ6_OBS      ,NIL},;
						{"BC_OPERADO", ZZ6TMP->ZZ6_OPERAD   ,NIL},;
						{"BC_LOTECTL", ZZ6TMP->ZZ6_LOTECT   ,NIL},;
						{"BC_NUMLOTE", ZZ6TMP->ZZ6_NUMLOT   ,NIL},;
						{"BC_DTVALID", ZZ6TMP->ZZ6_DTVALI   ,NIL},;
						{"BC_NUMSERI", ZZ6TMP->ZZ6_NUMSER   ,NIL},;
						{"BC_LOCAL"  , ZZ6TMP->ZZ6_LOCAL    ,NIL},;
						{"BC_LOCDEST", ZZ6TMP->ZZ6_LOCDES   ,NIL},;
						{"BC_NSEDEST", ZZ6TMP->ZZ6_NSEDES   ,NIL},;
						{"BC_CODDEST", ZZ6TMP->ZZ6_CODDES   ,NIL},;
						{"BC_QTDDEST", ZZ6TMP->ZZ6_QTDDES   ,NIL}}
			
			aadd(aLinha2 ,aItens2)
		Endif
	Endif
	ZZ6TMP->(dbSkip())
Enddo
//  
lGravou := .F.
If Len(aLinha2) > 0
	Begin Transaction
	MsExecAuto ( {|x,y,z| MATA685(x,y,z) }, aCabec2, aLinha2, 3)
	MSGSTOP(XSEQSD3)
	If lMsErroAuto
		msgStop("Falha na gravacao da Perda!","Atenção")
		MostraErro()
		DisarmTransaction()
		Break
	Else
		lGravou := .T.						
	Endif
	End Transaction			
Endif	
//
ZZ6TMP->(dbGotop())
Do While ZZ6TMP->(!Eof())
	If ZZ6TMP->ZZ6_OK == _cMarca		   
		If lGravou		
			If !Empty(ZZ6->ZZ6_CODCQL) .and. lPrdAprova	
				cQuery:=" UPDATE "+RetSqlName("ZZ6")+" "
				cQuery+=" SET ZZ6_CODAUT = '"+_cCodAut       +"', ZZ6_NOMEAU = '"+_cNomeAut+"', "
				cQuery+="     ZZ6_DTAUT  = '"+dTos(dDatabase)+"', ZZ6_HRAUT  = '"+cHrAut   +"', "
				cQuery+="     ZZ6_CODMOT = '"+_cMotivo+"', "
				cQuery+="     ZZ6_OBSERV = '"+Alltrim(_cObservacao)+"', "
				cQuery+="     ZZ6_NSEQD3 = '"+Alltrim(xSEQSD3)+"', "					
				cQuery+="     ZZ6_STATUS = 'T' "						
				cQuery+=" FROM "+RetSqlName("ZZ6")+" "
				cQuery+=" WHERE "
				cQuery+=" D_E_L_E_T_<>'*' "
				cQuery+=" AND R_E_C_N_O_ =  "+STR(ZZ6TMP->ZZ6_RECNO)+" "							
				cQuery+=" AND ZZ6_FILIAL = '"+xFilial("ZZ6")    +"' "
				cQuery+=" AND ZZ6_DOC    = '"+ZZ6TMP->ZZ6_DOC   +"' "
				cQuery+=" AND ZZ6_OP     = '"+ZZ6TMP->ZZ6_OP    +"' "
				cQuery+=" AND ZZ6_PRODUT = '"+ZZ6TMP->ZZ6_PRODUT+"' "
				cQuery+=" AND ZZ6_LOCORI = '"+ZZ6TMP->ZZ6_LOCORI+"' "
				cQuery+=" AND ZZ6_LOCALI = '"+ZZ6TMP->ZZ6_LOCALI+"' "
				cQuery+=" AND ZZ6_LOTECT = '"+ZZ6TMP->ZZ6_LOTECT+"' "
				cQuery+=" AND ZZ6_CODCQL = '"+ZZ6TMP->ZZ6_CODCQL+"' "									
				cQuery+=" AND ZZ6_CODAUT = '' "				
				//
				aadd(aWFREJ, Alltrim(Str(ZZ6TMP->ZZ6_RECNO)) )
				//MSGINFO(CQUERY)
				TCSQLEXEC(cQuery)						
			Endif
			//
			If !Empty(ZZ6->ZZ6_CODAUT) .and. lCqAprova
				//
				cQuery:=" UPDATE "+RetSqlName("ZZ6")+" "
				cQuery+=" SET ZZ6_CODCQL = '"+_cCodAut       +"', ZZ6_NOMCQL = '"+_cNomeAut+"', "
				cQuery+="     ZZ6_DTCQL  = '"+dTos(dDatabase)+"', ZZ6_HRCQL  = '"+cHrAut   +"', "
				cQuery+="     ZZ6_MOTCQL = '"+_cMotivo+"', "
				cQuery+="     ZZ6_OBSERV = '"+Alltrim(_cObservacao)+"', "
				cQuery+="     ZZ6_NSEQD3 = '"+Alltrim(xSEQSD3)+"', "
				cQuery+="     ZZ6_STATUS = 'T' "
				cQuery+=" FROM "+RetSqlName("ZZ6")+" "
				cQuery+=" WHERE "
				cQuery+=" D_E_L_E_T_<>'*' "                          
				cQuery+=" AND R_E_C_N_O_ =  "+STR(ZZ6TMP->ZZ6_RECNO)+" "											
				cQuery+=" AND ZZ6_FILIAL = '"+xFilial("ZZ6")    +"' "
				cQuery+=" AND ZZ6_DOC    = '"+ZZ6TMP->ZZ6_DOC   +"' "
				cQuery+=" AND ZZ6_OP     = '"+ZZ6TMP->ZZ6_OP    +"' "
				cQuery+=" AND ZZ6_PRODUT = '"+ZZ6TMP->ZZ6_PRODUT+"' "
				cQuery+=" AND ZZ6_LOCORI = '"+ZZ6TMP->ZZ6_LOCORI+"' "
				cQuery+=" AND ZZ6_LOCALI = '"+ZZ6TMP->ZZ6_LOCALI+"' "
				cQuery+=" AND ZZ6_LOTECT = '"+ZZ6TMP->ZZ6_LOTECT+"' "
				cQuery+=" AND ZZ6_CODAUT = '"+ZZ6TMP->ZZ6_CODAUT+"' "				
				cQuery+=" AND ZZ6_CODCQL = '' "
				//
				aadd(aWFREJ, Alltrim(Str(ZZ6TMP->ZZ6_RECNO)) )
				//MSGINFO(CQUERY)
				TCSQLEXEC(cQuery)						
			Endif	                            
		Else
			If Empty(ZZ6->ZZ6_CODAUT) .and. Empty(ZZ6->ZZ6_CODCQL)
                //
				cQuery := " UPDATE "+RetSqlName("ZZ6")+" "
				If lPrdAprova
					cQuery += " SET ZZ6_CODAUT = '"+_cCodAut       +"', ZZ6_NOMEAU = '"+_cNomeAut+"', "
					cQuery += "     ZZ6_DTAUT  = '"+dTos(dDatabase)+"', ZZ6_HRAUT  = '"+cHrAut   +"', "
					cQuery += "     ZZ6_CODMOT = '"+_cMotivo+"', "
					cQuery += "     ZZ6_OBSERV = '"+Alltrim(_cObservacao)+"', "
					cQuery += "     ZZ6_STATUS = 'A' "										
				Endif
				If lCqAprova
					cQuery += " SET ZZ6_CODCQL = '"+_cCodAut       +"', ZZ6_NOMCQL = '"+_cNomeAut+"', "
					cQuery += "     ZZ6_DTCQL  = '"+dTos(dDatabase)+"', ZZ6_HRCQL  = '"+cHrAut   +"', "
					cQuery += "     ZZ6_MOTCQL = '"+_cMotivo+"', "
					cQuery += "     ZZ6_OBSERV = '"+Alltrim(_cObservacao)+"', "
					cQuery += "     ZZ6_STATUS = 'A' "
				Endif
				cQuery += " FROM "+RetSqlName("ZZ6")+" "
				cQuery += " WHERE "
				cQuery += " D_E_L_E_T_<>'*' "
				cQuery += " AND R_E_C_N_O_ =  "+STR(ZZ6TMP->ZZ6_RECNO)+" "
				cQuery += " AND ZZ6_FILIAL = '"+xFilial("ZZ6")    +"' "				
				cQuery += " AND ZZ6_DOC    = '"+ZZ6TMP->ZZ6_DOC   +"' "
				cQuery += " AND ZZ6_OP     = '"+ZZ6TMP->ZZ6_OP    +"' "
				cQuery += " AND ZZ6_PRODUT = '"+ZZ6TMP->ZZ6_PRODUT+"' "
				cQuery += " AND ZZ6_LOCORI = '"+ZZ6TMP->ZZ6_LOCORI+"' "
				cQuery += " AND ZZ6_LOCALI = '"+ZZ6TMP->ZZ6_LOCALI+"' "
				cQuery += " AND ZZ6_LOTECT = '"+ZZ6TMP->ZZ6_LOTECT+"' "
				If lPrdAprova
				   cQuery += " AND ZZ6_CODAUT = '' "				
				Endif
				If lCqAprova
				   cQuery += " AND ZZ6_CODCQL = '' "
				Endif
                //               
       			aadd(aWFREJ, Alltrim(Str(ZZ6TMP->ZZ6_RECNO)) )
				//MSGINFO(CQUERY)
				TCSQLEXEC(cQuery)										
			Endif				
		Endif
	Endif
	ZZ6TMP->(dbSkip())
Enddo                       
//
_cRecList := ""
If Len(aWFREJ) > 0
	For nX := 1 to Len(aWFREJ)
		_cRecList += aWFREJ[nX] + iif(nX<>Len(aWFREJ),",","")
	Next
	_cRecList := fContidoSQL(_cRecList)				    
Endif
//
If lGravou
	//U_WFCTRL02(_cDoc, _cOP, dDatabase, cHrAut)
	U_WFCTRL01(_cRecList)	
Endif
/*/
RecLock("ZZ6TMP", .F.)
ZZ6TMP->(dbdelete())
ZZ6TMP->(MsUnlock())
ZZ6TMP->(dbgobottom())
ZZ6TMP->(dbgotop())
/*/
//
If ZZ6TMP->(Reccount()) > 0
	FechaTela()
Else
	_oBrwLotes:Refresh()
	DlgRefresh(oDlgLotes)
	SysRefresh()
	//
	oObjBrow := GetObjBrow() //Obtém o ultimo Objeto Browse
	oObjBrow:ResetLen()
	oObjBrow:GoTop()
	oObjBrow:Refresh()
Endif
//
dbselectarea(cAlias)
Return(lRet)
//
//
User Function Realiza4050()

If Alltrim(ZZ6->ZZ6_ROTINA) == cRotina	
	
	
	aCabec2 := {}  //Array(Len(aEtiqueta)+1)
	aItens2 := {}
	aLinha2 := {}
	//
	aCabec2 := {{"BC_OP"     , ZZ6->ZZ6_OP	 	,NIL},;
				{"BC_RECURSO", ZZ6->ZZ6_RECURS 	,NIL},;
				{"BC_OPERAC" , ZZ6->ZZ6_OPERAC	,NIL}}
	//
	//
	cHrAut  := Time()			
	ZZ6TMP->(dbGotop())
	Do While ZZ6TMP->(!Eof())
		If ZZ6TMP->ZZ6_OK == _cMarca 			
			If (!Empty(ZZ6->ZZ6_CODAUT) .and. lCqAprova) .or. (!Empty(ZZ6->ZZ6_CODCQL) .and. lPrdAprova)
			    //
				aItens2 := {{"BC_PRODUTO", ZZ6TMP->ZZ6_PRODUT   ,NIL},;
							{"BC_QUANT"  , ZZ6TMP->ZZ6_QUANT    ,NIL},;
							{"BC_LOCORI" , ZZ6TMP->ZZ6_LOCORI   ,NIL},;
							{"BC_LOCALIZ", ZZ6TMP->ZZ6_LOCALI   ,NIL},;
							{"BC_TIPO"   , ZZ6TMP->ZZ6_TIPO     ,NIL},;
							{"BC_APLIC"  , ZZ6TMP->ZZ6_APLIC    ,NIL},;
							{"BC_MOTIVO" , ZZ6TMP->ZZ6_MOTIVO   ,NIL},;
							{"BC_DATA"   , ZZ6TMP->ZZ6_DATA     ,NIL},;
							{"BC_OBS"    , ZZ6TMP->ZZ6_OBS      ,NIL},;
							{"BC_OPERADO", ZZ6TMP->ZZ6_OPERAD   ,NIL},;
							{"BC_RECURSO", ZZ6TMP->ZZ6_RECURS   ,NIL},;
							{"BC_OPERAC" , ZZ6TMP->ZZ6_OPERAC   ,NIL},;
							{"BC_LOTECTL", ZZ6TMP->ZZ6_LOTECT   ,NIL},;
							{"BC_NUMLOTE", ZZ6TMP->ZZ6_NUMLOT   ,NIL},;
							{"BC_DTVALID", ZZ6TMP->ZZ6_DTVALI   ,NIL},;
							{"BC_NUMSERI", ZZ6TMP->ZZ6_NUMSER   ,NIL},;
							{"BC_LOCAL"  , ZZ6TMP->ZZ6_LOCAL    ,NIL},;
							{"BC_LOCDEST", ZZ6TMP->ZZ6_LOCDES   ,NIL},;
							{"BC_NSEDEST", ZZ6TMP->ZZ6_NSEDES   ,NIL},;
							{"BC_CODDEST", ZZ6TMP->ZZ6_CODDES   ,NIL},;
							{"BC_QTDDEST", ZZ6TMP->ZZ6_QTDDES   ,NIL}}
				
				aadd(aLinha2 ,aItens2)
			Endif
		Endif
		//
		ZZ6TMP->(dbSkip())
	Enddo
	//
	If Len(aLinha2) > 0
		//
		Begin Transaction
		MsExecAuto ( {|x,y,z| MATA685(x,y,z) }, aCabec2, aLinha2, 3)
		//
		MSGSTOP(XSEQSD3)
		//                
		If lMsErroAuto
			msgStop("Falha na gravacao da Perda!","Atenção")
			MostraErro()
			DisarmTransaction()
			Break					
		Endif
		End Transaction			
		//
	Endif	
Endif
Return()
//
// **************************************** REGISTRAR LOG DE AUTORIZAÇÃO NA TABELA ZZ3 *************************************
// EM: 19/08/2013 BY ALEX ALMEIDA
// *************************************************************************************************************************
//
User Function CTRLPer_LogQuebraFifo(_cProduto, _cLocal, _cLocali, _cLotectl, _cNumLote, _nQuant, _cEtiqueta, _cUsuarioAut, _cNomeAut, _cCodMot, _cOrigem, _cOp, _cObservacao)
Local lRet := .T.
Local cAlias := Alias()
Local nOrder := indexord(cAlias)
//
If _cOp == Nil
	_cOp :=  Space(tamsx3("ZZ6_OP")[1])
Endif
//
dbselectarea("ZZ6")
dbsetorder(2)
If dbSeek(xFilial("ZZ6")+ _cEtiqueta) .and. _cOrigem == "CB0"
	RecLock("ZZ6", .F.)
Else
	RecLock("ZZ6", .T.)
Endif
//
ZZ6->ZZ6_DATA   := dDatabase
ZZ6->ZZ6_HORA   := Time()
//ZZ3->ZZ3_CODUSR := __cUserID
//ZZ3->ZZ3_NOMEUS := cUserName
//ZZ3->ZZ3_CODIGO := _cProduto
//ZZ3->ZZ3_LOCAL  := _cLocal
//ZZ3->ZZ3_LOCALI := _cLocali
//ZZ3->ZZ3_LOTECT := _cLotectl
//ZZ3->ZZ3_NUMLOT := ""
//ZZ3->ZZ3_QUANT   := _nQuant
ZZ6->ZZ6_ETIQ   := _cEtiqueta
ZZ6->ZZ6_CODMOT := _cPCodMot
//ZZ3->ZZ3_ORIGEM := _cOrigem
//ZZ3->ZZ3_OP     := _cOp
ZZ6->ZZ6_OBSERV := _cPObservacao
ZZ6->(MsUnlock())
//
//If IsTelnet()
//   vtALERT("LOG Quebra/FIFO foi atualizado... Favor providenciar autorização!","AVISO",.t.,4000)
//Endif
//
dbSelectarea(cAlias)
dbSetOrder(nOrder)
Return(lRet)
//
//
/*/ **************************************** REGISTRAR LOG DE AUTORIZAÇÃO NA TABELA ZZ3 ************************************** /*/
//
//
User Function LegPer()
Local aCores := {	{ 'BR_VERDE' 	, 'Sem liberação'						},;
					{ 'BR_AMARELO'  , 'Liberação parcial Produção'			},;
					{ 'BR_AZUL'     , 'Liberação parcial C.Q.'				},;
					{ 'BR_MARRON'	, 'Liberação total'						},;
					{ 'BR_PINK'     , 'Rejeitado parcial Produção'			},;
					{ 'BR_LARANJA'  , 'Rejeitado parcial C.Q.'   			},;
					{ 'BR_PRETO' 	, 'Rejeitado totalmente'      			},;													
					{ 'BR_VERMELHO'	, 'Liberação e transferência concluidos'}}


BrwLegenda(cCadastro,"Autorização de Transferencia",aCores )
Return
//
//
User Function VisualPer(cAlias,nReg,nOpcX)
Local lPyme:= Iif(Type("__lPyme") <> "U",__lPyme,.F.)
Local oDlg
Local bCampo
Local aArea      := GetArea()
Local aSB1Area   := SB1->(GetArea())
Local aSD3Area   := ZZ6->(GetArea())
Local nOpcao     := 5
Local aTam       := {}
Local cSeek      := ''
Local cNumSeq    := ''
Local cLocCQ     := GetMV('MV_CQ')

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atribui valores as variaveis de Posicao utilizado no Siga Pyme   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nPosDOri	  := 2					//Descricao do Produto Origem
Local nPosUMOri	  := 3					//Unidade de Medida Origem
Local nPosLOCOri  := 4					//Armazem Origem
Local nPosLcZOri  := 5					//Localizacao Origem

Local nPosDDes	  := Iif(!lPyme,7,6)	//Descricao do Produto Destino
Local nPosUMDes	  := Iif(!lPyme,8,7)	//Unidade de Medida Destino
Local nPosLOCDes  := Iif(!lPyme,9,8)	//Armazem Destino
Local nPosLcZDes  := 10					//Localizacao Destino
Local nPosNSer	  := 11					//Numero de Serie
Local nPosLoTCTL  := Iif(!lPyme,12,9)	//Lote de Controle
Local nPosNLOTE	  := Iif(!lPyme,13,10)  //Numero do Lote
Local nPosDTVAL	  := Iif(!lPyme,14,11)	//Data Valida
Local nPosPotenc  := Iif(!lPyme,15,12)	//Potencia do Lote
Local nPosQUANT	  := Iif(!lPyme,16,13)	//Quantidade
Local nPosQTSEG	  := Iif(!lPyme,17,14)	//Quantidade na 2a. Unidade de Medida
Local nPosEstor   := Iif(!lPyme,18,15)	//Estornado
Local nPosNumSeq  := Iif(!lPyme,19,16)	//Sequencia
Local nPosLotDes  := Iif(!lPyme,20,17)  //Lote Destino
Local nPosDtVldD  := Iif(!lPyme,21,18)	//Data Valida de Destino
Local nPosCAT83O  := 0   //Cod.CAT 83 Prod.Origem
Local nPosCAT83D  := 0   //Cod.CAT 83 Prod.Destino
Local nPosServic  := 0
Local aBut261     := {}
Local lContinua   := .T.
Local lCAT83      := .F.
Local cMemo
Local cDescMemo
Local nMem
Local lExistGrade := .F.
Local nPItem      := 0
Local nPosCODOri  := 1
Local nPosCODDes  := Iif(!lPyme,6,5) 	//Codigo do Produto Destino
Local oSize
Local lRet        := .T.

Private aCols      := {}
Private aHeader    := {}
Private cDocumento := ZZ6->ZZ6_DOC
Private dA261Data  := ZZ6->ZZ6_DATA 

/*/
If Alltrim(ZZ6->ZZ6_ROTINA) != "CTRLPERARM"
	lRet := .F.
	msgInfo("O documento não é uma transferencia!","Atenção")
	Return(lRet)
Endif
/*/

//-- Verifica se est  na filial correta
If cFilial # ZZ6->ZZ6_FILIAL
	Help(' ',1,'A000FI')
	lContinua := .F.
EndIf

//-- S¢ Trabalha com Movimenta‡”es RE4/DE4
/*
If lContinua .And. !ZZ6->ZZ6_CF $ 'RE4úDE4'
	Help(' ',1,'A260NAO')
	lContinua := .F.
EndIf
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa variaveis para campos Memos Virtuais						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type("aMemos")=="A" .And. Len(aMemos) > 0
	For nMem := 1 to Len(aMemos)
		cMemo := aMemos[nMem][2]
		cDescMemo := aMemos[nMem][3]
		If ExistIni(cMemo)
			&cMemo := InitPad(SX3->X3_RELACAO)
		Else
			&cMemo := ""
		EndIf
	Next i
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do AHeader (Visualiza‡„o)   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lContinua
	//
	aHeader := {}
	aTam := TamSX3('ZZ6_COD'    ); Aadd(aHeader, {STR0006, 'ZZ6_COD'    , PesqPict('ZZ6', 'ZZ6_COD'    , aTam[1]         ), aTam[1], aTam[2], 'A261VldCod(1)', USADO, 'C', 'ZZ6', ''}) // 'Prod.Orig.'
	aTam := TamSX3('ZZ6_DESCRI' ); Aadd(aHeader, {STR0007, 'ZZ6_DESCRI' , PesqPict('ZZ6', 'ZZ6_DESCRI' , aTam[1]         ), aTam[1], aTam[2], ''             , USADO, 'C', 'ZZ6', ''}) // 'Desc.Orig.'
	aTam := TamSX3('ZZ6_UM'     ); Aadd(aHeader, {STR0008, 'ZZ6_UM'     , PesqPict('ZZ6', 'ZZ6_UM'     , aTam[1], aTam[1]), aTam[1], aTam[2], ''             , USADO, 'C', 'ZZ6', ''}) // 'UM Orig.'
	aTam := TamSX3('ZZ6_LOCAL'  ); Aadd(aHeader, {STR0009, 'ZZ6_LOCAL'  , PesqPict('ZZ6', 'ZZ6_LOCAL'  , aTam[1]         ), aTam[1], aTam[2], 'A261Almox(1)' , USADO, 'C', 'ZZ6', ''}) // 'Almox Orig.'
	aTam := TamSX3('ZZ6_LOCALI' ); Aadd(aHeader, {STR0010, 'ZZ6_LOCALI', PesqPict('ZZ6', 'ZZ6_LOCALI'  , aTam[1]         ), aTam[1], aTam[2], 'A261Locali(1)', USADO, 'C', 'ZZ6', ''}) // 'Localiz.Orig.'
	aTam := TamSX3('ZZ6_COD'    ); Aadd(aHeader, {STR0011, 'ZZ6_COD'    , PesqPict('ZZ6', 'ZZ6_COD'    , aTam[1]         ), aTam[1], aTam[2], 'A261VldCod(2)', USADO, 'C', 'ZZ6', ''}) // 'Prod.Destino'
	aTam := TamSX3('ZZ6_DESCRI' ); Aadd(aHeader, {STR0012, 'ZZ6_DESCRI' , PesqPict('ZZ6', 'ZZ6_DESCRI' , aTam[1]         ), aTam[1], aTam[2], ''             , USADO, 'C', 'ZZ6', ''}) // 'Desc.Destino'
	aTam := TamSX3('ZZ6_UM'     ); Aadd(aHeader, {STR0013, 'ZZ6_UM'     , PesqPict('ZZ6', 'ZZ6_UM'     , aTam[1], aTam[1]), aTam[1], aTam[2], ''             , USADO, 'C', 'ZZ6', ''}) // 'UM Destino'
	aTam := TamSX3('ZZ6_LOCAL'  ); Aadd(aHeader, {STR0014, 'ZZ6_LOCAL'  , PesqPict('ZZ6', 'ZZ6_LOCAL'  , aTam[1]         ), aTam[1], aTam[2], 'A261Almox(2)' , USADO, 'C', 'ZZ6', ''}) // 'Almox Destino'
	aTam := TamSX3('ZZ6_LOCALI' ); Aadd(aHeader, {STR0015, 'ZZ6_LOCALI', PesqPict('ZZ6', 'ZZ6_LOCALI'  , aTam[1]         ), aTam[1], aTam[2], 'A261Locali(2)', USADO, 'C', 'ZZ6', ''}) // 'Localiz.Destino'
	aTam := TamSX3('ZZ6_NUMSER' ); Aadd(aHeader, {STR0016, 'ZZ6_NUMSER', PesqPict('ZZ6', 'ZZ6_NUMSER'  , aTam[1]         ), aTam[1], aTam[2], ''             , USADO, 'C', 'ZZ6', ''}) // 'N£mero Serie'
	aTam := TamSX3('ZZ6_LOTECT' ); Aadd(aHeader, {STR0018, 'ZZ6_LOTECT', PesqPict('ZZ6', 'ZZ6_LOTECT'  , aTam[1]         ), aTam[1], aTam[2], 'A261Lote()'   , USADO, 'C', 'ZZ6', ''}) // 'Lote'
	aTam := TamSX3('ZZ6_NUMLOT' ); Aadd(aHeader, {STR0017, 'ZZ6_NUMLOT', PesqPict('ZZ6', 'ZZ6_NUMLOT'  , aTam[1]         ), aTam[1], aTam[2], 'A261Lote()'   , USADO, 'C', 'ZZ6', ''}) // 'Sub-Lote'
	//	aTam := TamSX3('ZZ6_DTVALI' ); Aadd(aHeader, {STR0019, 'ZZ6_DTVALI', PesqPict('ZZ6', 'ZZ6_DTVALI', aTam[1]         ), aTam[1], aTam[2], ''             , USADO, 'D', 'ZZ6', ''}) // 'Validade'
	//	aTam := TamSX3('ZZ6_POTENCI'); Aadd(aHeader, {STR0039, 'ZZ6_POTENCI', PesqPict('ZZ6', 'ZZ6_POTENCI', aTam[1]         ), aTam[1], aTam[2], ''             , USADO, 'N', 'ZZ6', ''}) // 'Potencia'
	aTam := TamSX3('ZZ6_QUANT'  ); Aadd(aHeader, {STR0020, 'ZZ6_QUANT'  , PesqPict('ZZ6', 'ZZ6_QUANT'    			        ), aTam[1], aTam[2], 'A261Quant(.T.)'  , USADO, 'N', 'ZZ6', ''}) // 'Quantidade'
	//	aTam := TamSX3('ZZ6_QTSEGUM'); Aadd(aHeader, {STR0021, 'ZZ6_QTSEGUM', PesqPict('ZZ6', 'ZZ6_QTSEGUM',         			), aTam[1], aTam[2], 'A261Quant(.T.)'  , USADO, 'N', 'ZZ6', ''}) // 'Qt 2aUM'
	//	aTam := TamSX3('ZZ6_ESTORNO'); Aadd(aHeader, {STR0022, 'ZZ6_ESTORNO', PesqPict('ZZ6', 'ZZ6_ESTORNO', aTam[1]         ), aTam[1], aTam[2], ''             , USADO, 'C', 'ZZ6', ''}) // 'Estornado'
	//	aTam := TamSX3('ZZ6_NUMSEQ' ); Aadd(aHeader, {STR0028, 'ZZ6_NUMSEQ' , PesqPict('ZZ6', 'ZZ6_NUMSEQ' , aTam[1]         ), aTam[1], aTam[2], ''             , USADO, 'C', 'ZZ6', ''}) // 'Sequencia'
	aTam := TamSX3('ZZ6_LOTECT' ); Aadd(aHeader, {STR0044, 'ZZ6_LOTECT', PesqPict('ZZ6', 'ZZ6_LOTECT', aTam[1]         ), aTam[1], aTam[2], ''   , USADO, 'C', 'ZZ6', ''})
	//	aTam := TamSX3('ZZ6_DTVALI' ); Aadd(aHeader, {STR0046, 'ZZ6_DTVALI', PesqPict('ZZ6', 'ZZ6_DTVALI', aTam[1]         ), aTam[1], aTam[2], 'A261DtPot(3)' , USADO, 'D', 'ZZ6', ''}) // 'Validade Destino'
	//	aTam := TamSX3('ZZ6_ITEMGRD'); Aadd(aHeader, {STR0055, 'ZZ6_ITEMGRD' , PesqPict('ZZ6', 'ZZ6_ITEMGRD'  , aTam[1]         ), aTam[1], aTam[2], ''             , USADO, 'C', 'ZZ6', ''}) // 'Sequencia'
	If Type("aMemos")=="A" .And. Len(aMemos) > 0
		aTam := TamSX3(cMemo);Aadd(aHeader, {cDescMemo, cMemo, PesqPict('ZZ6', cMemo, aTam[1]         ), aTam[1], aTam[2], ''             , USADO, 'M', 'ZZ6', ''})	// CAMPOS MEMO
	EndIf
	//
	//-- ExecBlock para incluir campos no aHeader
	//
	ADHeadRec("ZZ6",aHeader)
	//
	//-- Posicionamento das Ordens utilizadas na fun‡„o
	SB1->(dbSetOrder(1))
	ZZ6->(dbSetOrder(1))
	//
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem do ACols (Visualiza‡„o)     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCols   := {}
	cNumSeq := 'ú'
	nPItem:= aScan(aHeader,{|x| AllTrim(x[2])=="ZZ6_ITEMGRD"})
	//
	If !ZZ6->(dbSeek( cSeek := xFilial('ZZ6')+cDocumento,.F.))
		Help(' ',1,'A260NAO')
		lContinua := .F.
	EndIf
EndIf
/*/
For nX := 1 to Len(aHeader)
	If Alltrim(aHeader[nX,2]) == "D3_COD"     .and. "ORI" $ Upper(Alltrim(aHeader[nX,1]))
		nPosCodOrig := nX
	Endif
	If Alltrim(aHeader[nX,2]) == "D3_COD"     .and. "DES" $ Upper(Alltrim(aHeader[nX,1]))
		nPosCodDest := nX
	Endif
	If Alltrim(aHeader[nX,2]) == "D3_UM"      .and. "ORI" $ Upper(Alltrim(aHeader[nX,1]))
		nPosUMOrig := nX
	Endif
	If Alltrim(aHeader[nX,2]) == "D3_UM"      .and. "DES" $ Upper(Alltrim(aHeader[nX,1]))
		nPosUMDest := nX
	Endif
	If Alltrim(aHeader[nX,2]) == "D3_LOCAL"   .and. "ORI" $ Upper(Alltrim(aHeader[nX,1]))
		nPosLocOrig := nX
	Endif
	If Alltrim(aHeader[nX,2]) == "D3_LOCAL"   .and. "DES" $ Upper(Alltrim(aHeader[nX,1]))
		nPosLocDest := nX
	Endif
	If Alltrim(aHeader[nX,2]) == "D3_LOCALIZ" .and. "ORI" $ Upper(Alltrim(aHeader[nX,1]))
		nPosEndOrig := nX
	Endif
	If Alltrim(aHeader[nX,2]) == "D3_LOCALIZ" .and. "DES" $ Upper(Alltrim(aHeader[nX,1]))
		nPosEndDest := nX
	Endif
	If (Alltrim(aHeader[nX,2]) == "D3_LOTECTL" .and. "ORI" $ Upper(Alltrim(aHeader[nX,1]))) .or. (Alltrim(aHeader[nX,2]) == "D3_LOTECTL" .and. !("DES" $ Upper(Alltrim(aHeader[nX,1]))))
		nPosLotOrig := nX
	Endif
	If Alltrim(aHeader[nX,2]) == "D3_LOTECTL" .and. "DES" $ Upper(Alltrim(aHeader[nX,1]))
		nPosLotDest := nX
	Endif
Next

nPosNumLote := ASCAN(aHeader, {|x| Alltrim(x[2]) == "D3_NUMLOTE" }) //
nPosNumSeri := ASCAN(aHeader, {|x| Alltrim(x[2]) == "D3_NUMSERI" }) //
nPosQuant   := ASCAN(aHeader, {|x| Alltrim(x[2]) == "D3_QUANT"   }) //
nPosDtValid := ASCAN(aHeader, {|x| Alltrim(x[2]) == "D3_DTVALID" }) //
/*/
//
Do While lContinua .And. !ZZ6->(Eof()) .And. cSeek == ZZ6->ZZ6_FILIAL+ZZ6->ZZ6_DOC
	/*
	If ZZ6->ZZ6_CF $ 'RE4úDE4'
		aAdd(aCols, Array(Len(aHeader)))
		cNumSeq := '' //ZZ6->ZZ6_NUMSEQ
	Else
		ZZ6->(dbSkip())
		Loop
	EndIf
	*/
	//
	Do While !ZZ6->(Eof())  .And. cSeek == ZZ6->ZZ6_FILIAL+ZZ6->ZZ6_DOC //.And. cNumSeq == ZZ6->ZZ6_NUMSEQ
		
		If ZZ6->ZZ6_CF $ 'RE4'
			
			//-- Posiciona o Arquivo de Produtos (SB1)
			If !SB1->(dbSeek(xFilial('SB1')+ZZ6->ZZ6_COD,.F.))
				Help(' ', 1, 'REGNOIS')
				lContinua := .F.
				Exit
			EndIf
			aCols[Len(aCols),01] := ZZ6->ZZ6_COD
			aCols[Len(aCols),02] := SB1->B1_DESC
			aCols[Len(aCols),03] := ZZ6->ZZ6_UM
			aCols[Len(aCols),04] := ZZ6->ZZ6_LOCAL
			aCols[Len(aCols),05] := ZZ6->ZZ6_LOCALI
			//aCols[Len(aCols),nPosQTSEG]     := ZZ6->ZZ6_QTSEGUM
			//aCols[Len(aCols),nPosEstor]     := ZZ6->ZZ6_ESTORNO
			//aCols[Len(aCols),nPosNumSeq]    := cNumSeq
			//aCols[Len(aCols),nPItem]        := ZZ6->ZZ6_ITEMGRD
			aCols[Len(aCols),11] := ZZ6->ZZ6_NUMSER
			aCols[Len(aCols),12] := ZZ6->ZZ6_LOTECT
			aCols[Len(aCols),13] := ZZ6->ZZ6_NUMLOT
			aCols[Len(aCols),14] := ZZ6->ZZ6_QUANT
			//aCols[Len(aCols),nPosDTVAL] := ZZ6->ZZ6_DTVALID
			//aCols[Len(aCols),nPosPotenc]:= ZZ6->ZZ6_POTENCI
			
		ElseIf ZZ6->ZZ6_CF $ 'DE4'
			//-- Posiciona o Arquivo de Produtos (SB1)
			If !SB1->(dbSeek(xFilial('SB1')+ZZ6->ZZ6_COD,.F.))
				Help(' ', 1, 'REGNOIS')
				lContinua := .F.
				Exit
			EndIf
			aCols[Len(aCols),06] := ZZ6->ZZ6_COD
			aCols[Len(aCols),07] := SB1->B1_DESC
			aCols[Len(aCols),08] := ZZ6->ZZ6_UM
			aCols[Len(aCols),09] := ZZ6->ZZ6_LOCAL
			aCols[Len(aCols),10] := ZZ6->ZZ6_LOCALI
			aCols[Len(aCols),15] := ZZ6->ZZ6_LOTECT
			//aCols[Len(aCols),nPosDtVldD]	:= ZZ6->ZZ6_DTVALI
		EndIf
		
		aCols[Len(aCols)][Len(aHeader)-1] := "ZZ6"
		aCols[Len(aCols)][Len(aHeader)]	  := ZZ6->(RecNo())
		
		ZZ6->(dbSkip())
		If !Empty(aCols[Len(aCols),nPosCODOri]) .And. !Empty(aCols[Len(aCols),nPosCODDes])
			Exit
		EndIf
	EndDo
	If !lContinua
		Exit
	EndIf
	If Empty(aCols[Len(aCols),nPosCODOri]) .Or. Empty(aCols[Len(aCols),nPosCODDes])
		Help(' ',1,'A260NAO')
		lContinua := .F.
		Exit
	EndIf
	//-- ExecBlock para atribuir valores nos campos de usuario
	//If (ExistBlock('MA261IN'))
	//	ExecBlock('MA261IN',.F.,.F.)
	//EndIf
Enddo

If lContinua .And. Len(aCols) == 0
	Help(' ',1,'A240ESTORN')
	lContinua := .F.
EndIf

If lContinua
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula dimensões                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSize := FwDefSize():New( .F. )
	
	oSize:AddObject( "CIMA"  ,  100,  20, .T., .F., .T. ) // Nao dimensiona Y
	oSize:AddObject( "BAIXO",  100, 100, .T., .T., .T. ) // Totalmente dimensionavel
	
	oSize:lProp := .T. // Proporcional
	oSize:aMargins := { 3, 3, 3, 3 } // Espaco ao lado dos objetos 0, entre eles 3
	
	oSize:Process() // Dispara os calculos
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa ponto de entrada para montar array com botoes a      ³
	//³ serem apresentados na tela                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (ExistBlock("M261BCHOI"))
		aBut261:=ExecBlock("M261BCHOI",.F.,.F.)
		If ValType(aBut261) # "A"
			aBut261:={}
		EndIf
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta Dialog                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFINE MSDIALOG oDlg TITLE cCadastro ;  //"Transferencia Mod2"
	FROM oSize:aWindSize[1],oSize:aWindSize[2] TO oSize:aWindSize[3],oSize:aWindSize[4] OF oMainWnd PIXEL
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Adiciona Panel                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oPanel1:= tPanel():New(000,000,,oDlg,,,,,,100,oSize:aPosObj[1,3])
	oPanel2:= tPanel():New(000,000,,oDlg,,,,,,100,oSize:aPosObj[2,3])
	
	oPanel1:Align := CONTROL_ALIGN_TOP
	oPanel2:Align := CONTROL_ALIGN_ALLCLIENT
	
	@ oSize:aPosObj[1,1], 003 SAY   OemToAnsi(STR0023) OF oPanel1 PIXEL // 'N£mero Documento'
	@ oSize:aPosObj[1,1], 053 MSGET cDocumento When .F. SIZE 65,08 OF oPanel1 PIXEL
	@ oSize:aPosObj[1,1], 125 SAY   OemToAnsi(STR0024) OF oPanel1 PIXEL // 'Emiss„o'
	@ oSize:aPosObj[1,1], 150 MSGET dA261Data When .F. OF oPanel1 PIXEL
	
	oGet := MSGetDados():New(oSize:aPosObj[2,1],oSize:aPosObj[2,2],oSize:aPosObj[2,3],oSize:aPosObj[2,4],2,;
	'AllwaysTrue','AllwaysTrue','',.F.,{"ZZ6_QUANT","ZZ6_QTSEGUM"},NIL,NIL,LINHAS,,,,,,,,,oPanel2)
	oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||oDlg:End(),If(oGet:TudoOK(),nOpca:=1,nOpca:=0)},{||oDlg:End()},,aBut261)
EndIf
//-- Retorna a integridade do Sistema
RestArea(aSB1Area)
RestArea(aSD3Area)
RestArea(aArea)
Return NIL
//
//
Static Function ValidPerg(cPerg)
dbSelectArea("SX1")
dbSetOrder(1)

aRegs := {}
aAdd(aRegs, {cPerg, "01","Da Dt. Leitura             ?","","","mv_ch1","D",08,0,0,"G","","mv_par01","    	  ","","","","","         ","","","","","         ","","","","","         ","","","","","         ","","","","   ","","",""})
aAdd(aRegs, {cPerg, "02","Ate Dt. Leitura            ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","   	  ","","","","","         ","","","","","         ","","","","","         ","","","","","         ","","","","   ","","",""})
aAdd(aRegs, {cPerg, "03","Do Codigo                  ?","","","mv_ch3","C",15,0,0,"G","","mv_par03","   	  ","","","","","         ","","","","","         ","","","","","         ","","","","","         ","","","","   ","","",""})
aAdd(aRegs, {cPerg, "04","Ate o Codigo               ?","","","mv_ch4","C",15,0,0,"G","","mv_par04","   	  ","","","","","         ","","","","","         ","","","","","         ","","","","","         ","","","","   ","","",""})
aAdd(aRegs, {cPerg, "05","Do Lote                    ?","","","mv_ch5","C",10,0,0,"G","","mv_par05","   	  ","","","","","         ","","","","","         ","","","","","         ","","","","","         ","","","","   ","","",""})
aAdd(aRegs, {cPerg, "06","Ate o Lote                 ?","","","mv_ch6","C",10,0,0,"G","","mv_par06","   	  ","","","","","         ","","","","","         ","","","","","         ","","","","","         ","","","","   ","","",""})
aAdd(aRegs, {cPerg, "07","Do Local                   ?","","","mv_ch7","C",02,0,0,"G","","mv_par07","   	  ","","","","","         ","","","","","         ","","","","","         ","","","","","         ","","","","   ","","",""})
aAdd(aRegs, {cPerg, "08","Ate o Local                ?","","","mv_ch8","C",02,0,0,"G","","mv_par08","   	  ","","","","","         ","","","","","         ","","","","","         ","","","","","         ","","","","   ","","",""})
aAdd(aRegs, {cPerg, "09","Tipo de Filtro             ?","","","mv_ch9","N",01,0,0,"C","","mv_par09","Autorizados","","","","","Nao Autorizados","","","","","Ambos","","","","","         ","","","","","         ","","","","   ","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(PadR(cPerg,10)+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	EndIf
Next
Return
//
//
Static Function ValidPerg2(cPerg)
dbSelectArea("SX1")
dbSetOrder(1)

aRegs := {}
aAdd(aRegs, {cPerg, "01","Da Dt. Leitura             ?","","","mv_ch1","D",08,0,0,"G","","mv_par01","    	  ","","","","","         ","","","","","         ","","","","","         ","","","","","         ","","","","   ","","",""})
aAdd(aRegs, {cPerg, "02","Ate Dt. Leitura            ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","   	  ","","","","","         ","","","","","         ","","","","","         ","","","","","         ","","","","   ","","",""})
aAdd(aRegs, {cPerg, "03","Do Codigo                  ?","","","mv_ch3","C",15,0,0,"G","","mv_par03","   	  ","","","","","         ","","","","","         ","","","","","         ","","","","","         ","","","","   ","","",""})
aAdd(aRegs, {cPerg, "04","Ate o Codigo               ?","","","mv_ch4","C",15,0,0,"G","","mv_par04","   	  ","","","","","         ","","","","","         ","","","","","         ","","","","","         ","","","","   ","","",""})
aAdd(aRegs, {cPerg, "05","Do Lote                    ?","","","mv_ch5","C",10,0,0,"G","","mv_par05","   	  ","","","","","         ","","","","","         ","","","","","         ","","","","","         ","","","","   ","","",""})
aAdd(aRegs, {cPerg, "06","Ate o Lote                 ?","","","mv_ch6","C",10,0,0,"G","","mv_par06","   	  ","","","","","         ","","","","","         ","","","","","         ","","","","","         ","","","","   ","","",""})
aAdd(aRegs, {cPerg, "07","Do Local                   ?","","","mv_ch7","C",02,0,0,"G","","mv_par07","   	  ","","","","","         ","","","","","         ","","","","","         ","","","","","         ","","","","   ","","",""})
aAdd(aRegs, {cPerg, "08","Ate o Local                ?","","","mv_ch8","C",02,0,0,"G","","mv_par08","   	  ","","","","","         ","","","","","         ","","","","","         ","","","","","         ","","","","   ","","",""})
aAdd(aRegs, {cPerg, "09","Do Separador               ?","","","mv_ch9","C",06,0,0,"G","","mv_par09","   	  ","","","","","         ","","","","","         ","","","","","         ","","","","","         ","","","","   ","","",""})
aAdd(aRegs, {cPerg, "10","Ate o Separador            ?","","","mv_cha","C",06,0,0,"G","","mv_par10","   	  ","","","","","         ","","","","","         ","","","","","         ","","","","","         ","","","","   ","","",""})
aAdd(aRegs, {cPerg, "11","Da Etiqueta                ?","","","mv_chb","C",10,0,0,"G","","mv_par11","   	  ","","","","","         ","","","","","         ","","","","","         ","","","","","         ","","","","   ","","",""})
aAdd(aRegs, {cPerg, "12","Ate a Etiqueta             ?","","","mv_chc","C",10,0,0,"G","","mv_par12","   	  ","","","","","         ","","","","","         ","","","","","         ","","","","","         ","","","","   ","","",""})


For i:=1 to Len(aRegs)
	If !dbSeek(PadR(cPerg,10)+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	EndIf
Next
Return
//
//
USER FUNCTION FiltraPer()
Local lRet:= .T.
Local cPerg := Padr("ZZ6FILTRO",10)
Local lPerg := .F.

Private _cFiltro := ""

ValidPerg(cPerg)
lPerg := Pergunte(cPerg)

If lPerg
	_cFiltro := ""
	If mv_par09 == 1
		_cFiltro  += '!Empty(ZZ6->ZZ6_CODAUT)'
	ElseIf mv_par09 == 2
		_cFiltro  += 'Empty(ZZ6->ZZ6_CODAUT)'
	Endif
	//
	EndFilBrw('ZZ6', @_aIndexZZ6)
	_bFiltraBrw := {|| FilBrowse('ZZ6', @_aIndexZZ6, @_cFiltro) }
	Eval(_bFiltraBrw)	
	//
	oObjBrow := GetObjBrow()
	oObjBrow:ResetLen()
	oObjBrow:GoTop()
	oObjBrow:Refresh()
	//
	SysRefresh()
Endif
Return(lRet)
//
//
User Function ZZ6ChkStatus(_cStatus)
Local cRet := ""

If Upper(_cStatus) == " "
	cRet := PadR("Sem aprovação"   ,16)

ElseIf Upper(_cStatus) == "A"
	cRet := PadR("Aprov. parcial"  ,16)

ElseIf Upper(_cStatus) == "R"
	cRet := PadR("Aprov. Declinada",16)

ElseIf Upper(_cStatus) == "T"
	cRet := PadR("Aprov. Concluida",16)
Endif
Return(cRet)
//
//
Static Function fContidoSQL(pTexto)
Local cTexto:=""
cTexto:=StrTran(AllTrim(PTexto),".","")
cTexto:="'"+StrTran(cTexto,",","','")+"'"
Return(cTexto)

*/ 