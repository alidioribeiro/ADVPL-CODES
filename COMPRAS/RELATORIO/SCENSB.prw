#Include "Rwmake.ch" 
#Include "Protheus.ch" 
#include "ap5mail.ch"
#Include "TOPCONN.ch"
#include 'tbiconn.ch'

/*/
 Aprovação da Solicitação de Compras
/*/
User Function SCENSB()

Local aIndex := {}
Local cFiltro := "LEFT(C1_ORIGEM,3) <> 'MPR'" //Expressao do Filtro

//Private cMarca      := GetMark()
Private InfUser   := {}  
Private _email_Solicitante := ""
Private _email_Aprovador   := ""
Private cAprovador         := ""
Private _cto               := ""
Private cCadastro := "Aprovar solicitação de compras"
Private aRotina   := {  {"Pesquisar" ,"AxPesqui"   ,0,1,0,.F.} ,;
						{"Visualizar","A110Visual" ,0,2,0,.F.} ,;
						{"Aprovar"   ,"U_AprovSC1"   ,0,3,0,.F.} ,;
						{"Rejeitar"  ,"U_RejSC1"   ,0,3,0,.F.} ,;						
						{"Legenda"   ,"U_LegSC1"   ,0,3,0,.F.} }


Private aCores := {	{ 'Eval({|| C1_APROV="L"})' , 'BR_AZUL'    },;
					{ 'Eval({|| C1_APROV="B"})' , 'BR_CINZA' } ,;
					{ 'Eval({|| C1_APROV="R"})' , 'BR_VERMELHO' } }
					
Private bFiltraBrw := { || FilBrowse( "SC1" , @aIndex , @cFiltro ) } //Determina a Expressao do Filtro					

aInfoUser := PswRet()
cMatSol   := Subs(aInfoUser[1][22],5,6)
cCCSoli   := alltrim(Posicione("SRA",1,xFilial("SRA") + cMatSol,"RA_CC"))
cDescSol  := alltrim(Posicione("CTT",1,xFilial("CTT") + cCCSoli,"CTT_DESC01"))
cUser     := __cUserId
cCodAprov := ""  
cNumSolic := ""
cSolici   := ""
lPermissao := .F.
_cto		  := ""

dbselectarea("SAK")
SAK->(dbsetorder(2))
If SAK->(dbSeek(xFilial("SAK")+ __cUserId))
   lPermissao := .T.	 
   cCodAprov := SAK->AK_COD
   cFiltro += " .AND. C1_CODAPRV='"+cCodAprov+"'"
   cNomAprov := SAK->AK_NOME
   cMatAprov := SAK->AK_USER
   _email_Aprovador   := UsrRetMail(cMatAprov)
   cAprovador         := cCODAPROV+'-'+cNomAPROV   
Endif
//
If lPermissao 
    Eval( bFiltraBrw )    //Efetiva o Filtro antes da Chamada a mBrowse
//	MBrowse(6,1,22,75,"SC1",,,,,,aCores,,,,,,,,@cFiltro) 
	MBrowse(6,1,22,75,"SC1",,,,,,aCores,,,,,,,) 
    EndFilBrw( "SC1" , @aIndex ) //Finaliza o Filtro	
Else 
	msgstop("Você não está autorizado a executar esta rotina!","Aviso")
Endif
//
Return

/* ------------------------------------------------------
AprovSC1 - Aprovacao de Solicitacao
---------------------------------------------------------
*/
User Function AprovSC1()
Private _oBrwLotes
Private oDlgLotes
Private _cMarca   := GetMark()
pRIVATE aCampos := {}

Cria_TRB()

AADD(aCampos,{'C1_OK'			,' '          ,'@!','02','0'})
AADD(aCampos,{'C1_NUM'   		,'Numero'     ,'@!','06','0'})
AADD(aCampos,{'C1_ITEM'  		,'Item'       ,'@!','04','0'})
AADD(aCampos,{'C1_PRODUTO'      ,'Produto'    ,'@!','15','0'})
AADD(aCampos,{'C1_DESC' 		,'Desc'       ,'@!','30','0'})
AADD(aCampos,{'C1_UM' 			,'UM'         ,'@!','02','0'})
AADD(aCampos,{'C1_QUANT'		,'Quant'      ,'@E 999,999,999.99','14','2'})
AADD(aCampos,{'C1_LOCAL'		,'Local'      ,'@!','02','0'})
AADD(aCampos,{'C1_CC'   		,'CC'         ,'@!','09','0'})                     
AADD(aCampos,{'C1_CONTA'   		,'Conta'      ,'@!','20','0'})                     
AADD(aCampos,{'C1_OBS'   		,'Obs'      ,'@!','30','0'})                     
AADD(aCampos,{'C1_USER'   		,'Cod.Solicitante' ,'@!','06','0'})                     

dbSelectArea('SC1TMP')

DEFINE MSDIALOG oDlgLotes FROM 38,16 TO 500,800 TITLE Alltrim(OemToAnsi('Solicitações pendentes de Aprovação')) Pixel //430,531 
@ 006,005 TO 190,380 BROWSE "SC1TMP" MARK "C1_OK" FIELDS aCampos Object _oBrwLotes
@ 200,050 BUTTON OemtoAnsi("Marcar")    SIZE 50,12 ACTION MarcarTudo()     PIXEL OF oDlgLotes
@ 200,130 BUTTON OemtoAnsi("Desmarcar") SIZE 50,12 ACTION DesMarcaTudo()   PIXEL OF oDlgLotes
@ 200,210 BUTTON OemtoAnsi("Aprovar")   SIZE 50,12 ACTION Aprovar()        PIXEL OF oDlgLotes
@ 200,290 BUTTON OemtoAnsi("Sair")      SIZE 50,12 ACTION FechaTela()      PIXEL OF oDlgLotes

_oBrwLotes:bMark := {|| Marcar()}
ACTIVATE DIALOG oDlgLotes CENTERED
//ACTIVATE MSDIALOG oDlgLotes CENTERED
Return


/* ------------------------------------------------------
RejSC1 - Rejeicao de Solicitacao
---------------------------------------------------------
*/
User Function RejSC1()
Private _oBrwLotes
Private oDlgLotes
Private _cMarca   := GetMark()
pRIVATE aCampos := {}

Cria_TRB()

AADD(aCampos,{'C1_OK'			,' '        ,'@!','02','0'})
AADD(aCampos,{'C1_NUM'   		,'Numero'   ,'@!','06','0'})
AADD(aCampos,{'C1_ITEM'  		,'Item'     ,'@!','04','0'})
AADD(aCampos,{'C1_PRODUTO'      ,'Produto'  ,'@!','15','0'})
AADD(aCampos,{'C1_DESC' 		,'Desc'     ,'@!','30','0'})
AADD(aCampos,{'C1_UM' 			,'UM'       ,'@!','02','0'})
AADD(aCampos,{'C1_QUANT'		,'Quant'    ,'@E 999,999,999.99','14','2'})
AADD(aCampos,{'C1_LOCAL'		,'Local'    ,'@!','02','0'})
AADD(aCampos,{'C1_CC'   		,'CC'       ,'@!','09','0'})                     
AADD(aCampos,{'C1_CONTA'   		,'Conta'    ,'@!','20','0'})                     
AADD(aCampos,{'C1_OBS'   		,'Obs'      ,'@!','30','0'})                     
AADD(aCampos,{'C1_USER'   		,'Cod.Solicitante' ,'@!','06','0'})                     

dbSelectArea('SC1TMP')
DEFINE MSDIALOG oDlgLotes FROM 38,16 TO 500,800 TITLE Alltrim(OemToAnsi('Solicitações a Rejeitar')) Pixel //430,531 
@ 006,005 TO 190,380 BROWSE "SC1TMP" MARK "C1_OK" FIELDS aCampos Object _oBrwLotes
@ 200,050 BUTTON OemtoAnsi("Marcar")    SIZE 50,12 ACTION MarcarTudo()     PIXEL OF oDlgLotes
@ 200,130 BUTTON OemtoAnsi("Desmarcar") SIZE 50,12 ACTION DesMarcaTudo()   PIXEL OF oDlgLotes
@ 200,210 BUTTON OemtoAnsi("Rejeitar")   SIZE 50,12 ACTION Rejeitar()      PIXEL OF oDlgLotes
@ 200,290 BUTTON OemtoAnsi("Sair")      SIZE 50,12 ACTION FechaTela()      PIXEL OF oDlgLotes

_oBrwLotes:bMark := {|| Marcar()}
ACTIVATE DIALOG oDlgLotes CENTERED
//ACTIVATE MSDIALOG oDlgLotes CENTERED
Return()
//
//
Static Function FechaTela()
SC1TMP->(dbclosearea())
Close(oDlgLotes)
Return

/* --------------------------------------
Aprovar - Aprova Solicitacao
-----------------------------------------
*/ 
Static Function Aprovar()
Local cUsuario := __cUserID
Local cPassword:= Space(15)
Local lSair    := .F.
Local lRet     := .F.
Local cCont    := Space(01)

Private oDlgAut
Private cNomeUsu := cUserName
Private oNomeUsu 
Private cMotDesc := Space(30)
Private oMotDesc 
Private cMotivo  := Space(30)
//
//
cListItem := ""
SC1TMP->(dbgotop())
Do While SC1TMP->(!Eof())
	If SC1TMP->C1_OK == _cMarca
	   cListItem += SC1TMP->C1_ITEM
	Endif
	SC1TMP->(dbSkip())
	//
	If SC1TMP->(!Eof()) .AND. SC1TMP->C1_OK == _cMarca
	   cListItem += ","
	Endif
Enddo
SC1TMP->(dbgotop())
//
cListItem := fContidoSQL(cListItem)			
//
DEFINE MSDIALOG oDlgAut FROM 05,10 TO 200,600 TITLE Alltrim(OemToAnsi('Aprovar Solicitação')) Pixel //430,531 
//
@ 10,015 say 'ID:'            SIZE 030,10 PIXEL OF oDlgAut
@ 10,045 say  aInfoUser[1,1]  SIZE 080,10 PIXEL oF oDlgAut COLOR CLR_BLUE
@ 20,015 say 'Usuario:'       SIZE 030,10 PIXEL OF oDlgAut
@ 20,045 say  aInfoUser[1,2]  SIZE 080,10 PIXEL oF oDlgAut COLOR CLR_BLUE
@ 30,015 say 'Nome:'          SIZE 030,10 PIXEL OF oDlgAut
@ 30,045 say  aInfoUser[1,4]  SIZE 080,10 PIXEL of oDlgAut COLOR CLR_BLUE
//
//@ 50,015 say   'Motivo:'               SIZE 020,10 PIXEL OF oDlgAut
//@ 50,045 MSget cMotivo   picture '@!' valid  naovazio(cMotivo) .and. ValidMot(cMotivo)  F3 'ZZ2'  SIZE 020,10  PIXEL of oDlgAut
//@ 50,090 say   oMotDesc  Var cMotDesc  SIZE 160,10 PIXEL OF oDlgAut COLOR CLR_BLUE
//
//@ 20,150 Say   OemToAnsi('Observação:') Size 028, 007 Of ODlgAut Pixel
//@ 20,150 MsGet oObs Var cObs Memo Size 200, 100 Of oDlgAut Pixel
//
@ 80,050 BUTTON "Confirmar"     SIZE 40,15 ACTION MsAguarde({|| Registra(SC1TMP->C1_NUM, cListItem,'L'), Close(oDlgAut)},'Processando...') PIXEL OF oDlgAut
@ 80,100 BUTTON "Sair"          SIZE 40,15 ACTION MsAguarde({|| Close(oDlgAut)},'Processando...') PIXEL OF oDlgAut
//ACTIVATE DIALOG oDlgAut CENTERED
ACTIVATE MSDIALOG oDlgAut CENTERED //ON INIT EnchoiceBar(oWindow,&(bOk),&(bCancel),,aButtons)
//
Return

/* -------------------------------------------
  Prepara Arquivo temporario das Solicitacoes
  --------------------------------------------
*/
Static FUNCTION Cria_TRB()
//
If Select("SC1TMP") <> 0
	SC1TMP->(dbCloseArea())
Endif
//
aFields   := {}
AADD(aFields,{"C1_OK"     ,"C",02,0})
AADD(aFields,{"C1_NUM"    ,"C",06,0})
AADD(aFields,{"C1_ITEM"   ,"C",04,0})
AADD(aFields,{"C1_PRODUTO","C",15,0})
AADD(aFields,{"C1_DESC"   ,"C",30,0})
AADD(aFields,{"C1_UM"     ,"C",02,0})
AADD(aFields,{"C1_QUANT"  ,"N",14,2})
AADD(aFields,{"C1_LOCAL"  ,"C",02,0})
AADD(aFields,{"C1_CC"     ,"C",09,0})
AADD(aFields,{"C1_CONTA"  ,"C",20,0})
AADD(aFields,{"C1_OBS"    ,"C",30,0})
AADD(aFields,{"C1_USER"   ,"C",06,0})

//
cArq:=Criatrab(aFields,.T.)
dbUseArea(.t.,,cArq,"SC1TMP")
//
cQuery := ""
cQuery += " SELECT C1_OK=SPACE(02), C1_NUM, C1_ITEM, C1_PRODUTO, C1_UM, C1_QUANT, C1_LOCAL, C1_CC, B1_DESC,C1_SOLICIT,C1_EMISSAO,C1_USER,C1_CONTA,C1_OBS "
cQuery += " FROM "+RetSqlName("SC1")+" A INNER JOIN "+RetSqlName("SB1")+" B ON (C1_PRODUTO=B1_COD) "
cQuery += " WHERE A.D_E_L_E_T_<>'*' AND  B.D_E_L_E_T_<>'*' "
cQuery += " AND C1_FILIAL  = '"+xFilial("SC1")+"'"
cQuery += " AND B1_FILIAL  = '"+xFilial("SB1")+"'"
cQuery += " AND C1_NUM     = '"+SC1->C1_NUM+"'"
cQuery += " AND C1_APROV  ='B' AND C1_CODAPRV='"+cCodAprov+"'"
cQuery += " ORDER BY C1_NUM, C1_ITEM"
//	msgStop(cQuery)
//
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"SC1QRY",.T.,.T.)
//
dbselectarea("SC1QRY")
Do While SC1QRY->(!EOF())
	//
	RecLock("SC1TMP",.T.)
	SC1TMP->C1_OK     := _cMarca  //ThisMark()
	SC1TMP->C1_NUM    := SC1QRY->C1_NUM   
	SC1TMP->C1_ITEM   := SC1QRY->C1_ITEM
	SC1TMP->C1_PRODUTO:= SC1QRY->C1_PRODUTO
	SC1TMP->C1_DESC   := SC1QRY->B1_DESC
	SC1TMP->C1_UM     := SC1QRY->C1_UM
	SC1TMP->C1_QUANT  := SC1QRY->C1_QUANT
	SC1TMP->C1_LOCAL  := SC1QRY->C1_LOCAL
	SC1TMP->C1_CC     := SC1QRY->C1_CC
	SC1TMP->C1_CONTA  := SC1QRY->C1_CONTA	
	SC1TMP->C1_OBS    := SC1QRY->C1_OBS		
	SC1TMP->C1_USER   := SC1QRY->C1_USER	
//	SC1TMP->C1_SOLICIT:= SC1QRY->C1_SOLICIT	
//	SC1TMP->C1_EMISSAO:= SC1QRY->C1_EMISSAO		
	SC1TMP->(MsUnLock())
	//
	dbSelectArea('SC1QRY')
	SC1QRY->(dbskip())
EndDo
//
SC1QRY->(dbCloseArea())
//
dbselectarea("SC1TMP")
dbGoTop()
//
Return

/* -------------------------------------
  Marca Todos os Itens da Solicitacao   
----------------------------------------  
*/
Static Function MarcarTudo()
dbSelectArea('SC1TMP')
dbGoTop()
While !Eof()
	//MsProcTxt('Aguarde...')
	RecLock('SC1TMP',.F.)
	SC1TMP->C1_OK := _cMarca
	MsUnlock()
	dbSkip()
EndDo
DbGoTop()
DlgRefresh(oDlgLotes)
SysRefresh()
Return(.T.)

/* -----------------------------------------
  DesMarca Todos os Itens da Solicitacao
--------------------------------------------  
*/
Static Function DesmarcaTudo()
dbSelectArea('SC1TMP')
dbGoTop()
While !Eof()
	//MsProcTxt('Aguarde...')
	RecLock('SC1TMP',.F.)
	SC1TMP->C1_OK := ThisMark()
	MsUnlock()
	dbSkip()
Enddo
dbGoTop()
DlgRefresh(oDlgLotes)
SysRefresh()
Return(.T.)

/* -------------------------------------
  Marca um Item da Solicitacao
----------------------------------------
*/
Static Function Marcar()
dbSelectArea('SC1TMP')
RecLock('SC1TMP',.F.)
If Empty(SC1TMP->C1_OK)
	SC1TMP->C1_OK := _cMarca
Endif
MsUnlock()
DlgRefresh(oDlgLotes)
SysRefresh()
Return(.T.)

/* ---------------------------------------------
  Registra os Itens Selecionados da Solicitacao
  ----------------------------------------------
*/
Static Function Registra(_cNum, _cListItem, _Flag)
Local lRet := .T.
Local cAlias := Select()                         
//
If Empty(_cListItem)
	msgStop("Nenhum item foi selecionado!","Atenção!")
	Return(.F.)         
Endif

//
cQuery:=" UPDATE "+RetSqlName("SC1")+" " 
cQuery+=" SET C1_APROV='"+_Flag+"'"
IF _Flag="R"
   cQuery+=" , C1_OBS='"+cMotivo+"'"
ENDIF   
cQuery+=" FROM "+RetSqlName("SC1")+" "
cQuery+=" WHERE  "
cQuery+=" D_E_L_E_T_<>'*' "
cQuery+=" AND C1_FILIAL='" + xFilial("SC1")+"' "
cQuery+=" AND C1_NUM   ='" + _cNum  +"' "
cQuery+=" AND C1_ITEM  IN (" + _cListItem +") "
//
//MSGINFO(CQUERY)                                 
//
TCSQLEXEC(cQuery)
//TCSQLEXEC("Commit")	
//    
aEnvia := {}             
SC1TMP->(dbgotop())
Do While SC1TMP->(!Eof())
    //
   	If SC1TMP->C1_OK == _cMarca
    aadd(aEnvia, {SC1TMP->C1_NUM, ;
    			  SC1TMP->C1_ITEM, ;
    			  SC1TMP->C1_PRODUTO, ;
    			  SC1TMP->C1_DESC,;
                  SC1TMP->C1_UM, ;
                  Transform(SC1TMP->C1_QUANT,"@E 99,999,999.99"), ;
                  SC1TMP->C1_LOCAL, ;
                  SC1TMP->C1_CC , ;
                  SC1TMP->C1_CONTA,;
                  SC1TMP->C1_OBS;
                  })
	Endif
    //
	RecLock("SC1TMP", .F.)
	SC1TMP->(dbdelete())
	SC1TMP->(MsUnlock()) 
	SC1TMP->(dbSkip())
Enddo
SC1TMP->(dbgobottom())
SC1TMP->(dbgotop())
//
WFAPRSC1(aEnvia,_Flag)  //chamada para envio de e-mail , _Flag (Contem 'L'=Aprovado ou 'R'=Rejeitado
//
If SC1TMP->(Reccount()) > 0
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
User Function LegSC1()
Local aCores := {	{ 'BR_AZUL' 	, 'Aprovado' },; 
					{ 'BR_CINZA'	, 'Bloqueado' },;
    				{ 'BR_VERMELHO'	, 'Rejeitado' }	}  

				
BrwLegenda(cCadastro,"Libera solicitação de Compras",aCores )
Return


//
Static Function fContidoSQL(pTexto)
Local cTexto:=""
cTexto:=StrTran(AllTrim(PTexto),".","")
cTexto:="'"+StrTran(cTexto,",","','")+"'"
Return(cTexto)


//
//
Static Function WFAPRSC1(_aEnvia,_Flag)
Local aEnvia := {}
Local cProd,cMen

//
aEnvia := _aEnvia
//Prepare Environment Empresa "01" Filial "01" Tables "ZZ3"  // Usado apenas quando o uso for por agendamento
If Len(aEnvia) > 0

   EnviaEmail(_Flag)
   
EndIf
Return



//************************************************************/
Static Function  EnviaEmail(_Flag)
Local cArea:=Alias()
dbselectarea("SAK")
SAK->(dbsetorder(2))
If SAK->(dbSeek(xFilial("SAK")+ __cUserId))
  cCodAprov := SAK->AK_COD
  cNomAprov := SAK->AK_NOME  
  cNumSolic := SC1->C1_NUM
  cSolici   := SC1->C1_SOLICIT
  cEmissao   := SC1->C1_EMISSAO   
  cAprovador := cCODAPROV+'-'+cNomAPROV   
Endif
_email_solicitante := UsrRetMail(SC1->C1_USER)  
DbselectArea(cArea)
//
//    _cTo:="aishii@nippon-seikibr.com.br"
    oProcess := TWFProcess():New( "000001", "Envia Email" )
    oProcess :NewTask( "100030", "\WORKFLOW\SC1.HTM" )
    oProcess :cSubject := "Solicitação de Compras - "+cNumSolic+IIF(_Flag="R","(REJEITADO)","(APROVADO)")
    oHTML    := oProcess:oHTML 
    cMen := " <html>"
    cMen += " <head>"
    cMen += '<h2 align="Left">' 
    cMen += '<td align="Left" width="1000" height="45"> '
	cMen += '<font color='+IIF(_Flag="R","#FF0000","#009900")+' size="4" face="Verdana, Arial, Helvetica, sans-serif"><strong>SOLICITA&Ccedil;&Atilde;O DE COMPRAS '+IIF(_Flag="R","REJEITADO","APROVADO")+'</strong></font></h2></td>'
	cMen += '<tr>'
	cMen += '</tr>
    cMen += ' <tr >'
    cMen += ' <table  border="1" width="1000" height="45"> '
    cMen += ' <td align="center" width="15%"   bgcolor="#FFFFFF"><font size="3" face="Courrier"><strong>No. Solicitacao</strong></font></td>'  //[2]
    cMen += ' <td align="center" width="30%"  bgcolor="#FFFFFF"><font size="3" face="Courrier"><strong>Solicitante</strong></font></td>'  //[3]
    cMen += ' <td align="center" width="40%"  bgcolor="#FFFFFF"><font size="3" face="Courrier"><strong>Aprovador</strong></font></td>'  //[4]
    cMen += ' <td align="center" width="10%"   bgcolor="#FFFFFF"><font size="3" face="Courrier"><strong>Emissao</strong></font></td>'  //[5]
    cMen += ' </tr>'     
   	cMen += ' <tr >'
	cMen += ' <td align="center" width="15%" bgcolor="#FFFFFF"><font color='+IIF(_Flag="R","#FF0000","#009900")+' size="4" face="Times New Roman"><strong>'+cNumSolic+'</strong></font></td>'
	cMen += ' <td align="center" width="30%" bgcolor="#FFFFFF"><font size="2" face="Times New Roman"><Blink>'+cSolici+'</Blink></font></td>'
	cMen += ' <td align="center" width="30%" bgcolor="#FFFFFF"><font size="2" face="Times New Roman"><Blink>'+cAprovador+'</Blink></font></td>'
	cMen += ' <td align="center" width="30%" bgcolor="#FFFFFF"><font size="2" face="Times New Roman"><Blink>'+dToc(cEmissao)+'</Blink></font></td>'
	cMen += ' </tr>'         
    IF _Flag="R"
     	cMen += '<tr>'    
		cMen += ' <td align="center" width="30%" bgcolor="#FFFFFF"><font size="3" face="Courrier"><strong> Motivo</strong></font></td>'    
     	cMen += ' <td align="center" width="160%" bgcolor="#FFFFFF"><font ="2" color="#CD0000" face="Times New Roman"><Blink>'+cMotivo+'</Blink></font></td>'		
    	cMen += '</tr>'    		
    Endif
	
	cMen += " </table>"    
	cMen += " </head>"    
    cMen += " <body>"      
	cMen += ' <table  border="1" width="1000" height="45">'

      cMen += ' <tr>'
      cMen += ' <td align="center" width="5%"   bgcolor="#FFFFFF"><font size="2" face="Courrier"><strong>Item</strong></font></td>'  //[2]
      cMen += ' <td align="center" width="15%"  bgcolor="#FFFFFF"><font size="2" face="Courrier"><strong>Codigo</strong></font></td>'  //[3]
      cMen += ' <td align="center" width="25%"  bgcolor="#FFFFFF"><font size="2" face="Courrier"><strong>Descricao</strong></font></td>'  //[4]
      cMen += ' <td align="left  " width="2%"   bgcolor="#FFFFFF"><font size="2" face="Courrier"><strong>UM</strong></font></td>'  //[5]
      cMen += ' <td align="right" width="10%"  bgcolor="#FFFFFF"><font size="2" face="Courrier"><strong>Quantidade</strong></font></td>'  //[6] 
      cMen += ' <td align="center" width="10%"  bgcolor="#FFFFFF"><font size="2" face="Courrier"><strong>Necessidade</strong></font></td>'  //[6]       
      cMen += ' <td align="center" width="20%"  bgcolor="#FFFFFF"><font size="2" face="Courrier"><strong>CC</strong></font></td>'  //[6]             
      cMen += ' <td align="center" width="9%"  bgcolor="#FFFFFF"><font size="2" face="Courrier"><strong>Conta</strong></font></td>'  //[6]             
      cMen += ' </tr>'
	
    For x:= 1 to Len(aEnvia) 
      cMen += ' <tr>'
      cMen += ' <td align="center" width="5%"   bgcolor="#FFFFFF"><font size="2" face="Courrier">'+aEnvia[x][2]+'</font></td>'  //[2]
      cMen += ' <td align="left" width="15%"    bgcolor="#FFFFFF"><font size="2" face="Courrier">'+aEnvia[x][3]+'</font></td>'  //[3]
      cMen += ' <td align="left" width="25%"    bgcolor="#FFFFFF"><font size="2" face="Courrier">'+aEnvia[x][4]+'</font></td>'  //[4]
      cMen += ' <td align="center" width="2%"   bgcolor="#FFFFFF"><font size="2" face="Courrier">'+aEnvia[x][5]+'</font></td>'  //[5]
      cMen += ' <td align="right" width="10%"   bgcolor="#FFFFFF"><font size="2" face="Courrier">'+aEnvia[x][6]+'</font></td>'  //[6] 
      cMen += ' <td align="center" width="10%"   bgcolor="#FFFFFF"><font size="2" face="Courrier">'+aEnvia[x][7]+'</font></td>'  //[6]       
      cMen += ' <td align="center" width="9%"   bgcolor="#FFFFFF"><font size="2" face="Courrier">'+aEnvia[x][8]+'</font></td>'  //[6]             
      cMen += ' <td align="center" width="20%"   bgcolor="#FFFFFF"><font size="2" face="Courrier">'+aEnvia[x][9]+'</font></td>'  //[6]             
      cMen += ' </tr>'
    Next 
    cMen += ' </table>'
    cMen += " </body>"
    cMen += " </html>" 
	
    oHtml:ValByName("MENS", cMen)
    _cto := _email_aprovador+" ; "+_email_solicitante+IIF(_Flag<>"R"," ; compras@nippon-seikibr.com.br","")
	oProcess:cTo  := _cTo
	cMailId := oProcess:Start()
   // Alert("E-mail enviado para Liberacao da Chefia: "+ cTo)   
Return


/* --------------------------------------
Rejeitar - Rejeitar Solicitacao
-----------------------------------------
*/ 
Static Function Rejeitar()
Local cUsuario := __cUserID
Local cPassword:= Space(15)
Local lSair    := .F.
Local lRet     := .F.
Local cCont    := Space(01)

Private oDlgAut
Private cNomeUsu := cUserName
Private oNomeUsu 
Private cMotDesc := Space(30)
Private oMotDesc 
Private cMotivo := Space(30)
//
//
cListItem := ""
Do While SC1TMP->(!Eof())
	If SC1TMP->C1_OK == _cMarca
	   cListItem += SC1TMP->C1_ITEM
	Endif
	SC1TMP->(dbSkip())
	//
	If SC1TMP->(!Eof()) .AND. SC1TMP->C1_OK == _cMarca
	   cListItem += ","
	Endif
Enddo
SC1TMP->(dbgotop())
//
cListItem := fContidoSQL(cListItem)			
//
DEFINE MSDIALOG oDlgAut FROM 05,10 TO 200,600 TITLE Alltrim(OemToAnsi('Rejeitar Solicitação')) Pixel //430,531 
//
@ 10,015 say 'ID:'            SIZE 030,10 PIXEL OF oDlgAut
@ 10,045 say  aInfoUser[1,1]  SIZE 080,10 PIXEL oF oDlgAut COLOR CLR_BLUE
@ 20,015 say 'Usuario:'       SIZE 030,10 PIXEL OF oDlgAut
@ 20,045 say  aInfoUser[1,2]  SIZE 080,10 PIXEL oF oDlgAut COLOR CLR_BLUE
@ 30,015 say 'Nome:'          SIZE 030,10 PIXEL OF oDlgAut
@ 30,045 say  aInfoUser[1,4]  SIZE 080,10 PIXEL of oDlgAut COLOR CLR_RED
@ 50,015 say   'Motivo:'               SIZE 020,10 PIXEL OF oDlgAut
@ 50,045 MSget cMotivo   picture '@!' valid  naovazio(cMotivo) SIZE 160,10 PIXEL OF oDlgAut COLOR CLR_BLUE
//
//@ 20,150 Say   OemToAnsi('Observação:') Size 028, 007 Of ODlgAut Pixel
//@ 20,150 MsGet oObs Var cObs Memo Size 200, 100 Of oDlgAut Pixel
//
@ 80,050 BUTTON "Confirmar"     SIZE 40,15 ACTION MsAguarde({|| Registra(SC1TMP->C1_NUM, cListItem, 'R' ), Close(oDlgAut)},'Processando...') PIXEL OF oDlgAut
@ 80,100 BUTTON "Sair"          SIZE 40,15 ACTION MsAguarde({|| Close(oDlgAut)},'Processando...') PIXEL OF oDlgAut
//ACTIVATE DIALOG oDlgAut CENTERED
ACTIVATE MSDIALOG oDlgAut CENTERED //ON INIT EnchoiceBar(oWindow,&(bOk),&(bCancel),,aButtons)
//
Return
