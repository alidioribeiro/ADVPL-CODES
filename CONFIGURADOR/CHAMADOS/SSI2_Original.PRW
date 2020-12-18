#INCLUDE 'PROTHEUS.CH'
#Include "Rwmake.ch" 
#Include "TOPCONN.ch"
#include 'fivewin.ch'
#include 'tbiconn.ch'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'         
#Include 'libnsb.prw'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³SSI2     ³ Autor ³ Jorge William         ³ Data ³23/02/2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³NSB               ³Contato ³                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³                                               ³±±
±±³              ³  /  /  ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

user function SSI2()
//--< variáveis >---------------------------------------------------------------------------
	local nOpcao :=0
//Indica a permissão ou não para a operação (pode-se utilizar 'ExecBlock')
	local cVldAlt := ".T." // Operação: ALTERAÇÃO
	local cVldExc := ".T." // Operação: EXCLUSÃO

//trabalho/apoio
	local cAlias
//Email das pessoas/ solicitante
	private _cTo:=""

//--< configuração de 'pergunte' e tecla de atalho >----------------------------------------
//	pergunte("RDS", .f.)
//	setKey(123,{|| pergunte("RDS", .t.)}) // Acionamento dos parametros - tecla F12
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ recuperando valores do usuário logado                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
xUserVali          := __cUserId
PSWORDER(1) //Indexação da senha do usuário pelo ID da senha
aInfoUser          := PswRet()
cMatSol            := Subs(aInfoUser[1][22],5,6)      
cConf     		   :=aInfoUser[1][1]  
if cConf == '000655' // RCallado (Fvncional) 
  cMatSol:= '000538' // Lucas.Rabelo (Nippon)
endif
cCCSoli            := alltrim(Posicione("SRA",1,xFilial("SRA") + cMatSol,"RA_CC"))
cDescSol           := alltrim(Posicione("CTT",1,xFilial("CTT") + cCCSoli,"CTT_DESC01"))
cUser              := __cUserId  
//--< procedimentos >-----------------------------------------------------------------------
	cAlias := "SZH"
	chkFile(cAlias)
	dbSelectArea(cAlias)
//indices
	dbSetOrder(1)
Private	_cEmpUso  	:= AllTrim(cEmpAnt)+"/",;
		_cPerg    	:= PadR("CHAMUS",10),;
		_bFiltraBrw	:= ''
		_aIndexSZH 	:= {}
		_cFiltro  	:= ''	
	Private cCadastro := "Cadastro de Entrada e saída"

		
Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","U_visSSI",0,2} ,;
             {"Incluir","U_cadSSI",0,3} ,;
             {"Copiar","U_copSSI",0,3},;
             {"Alterar","U_altSSI",0,4} ,; 
             {"Excluir","U_excSSI",0,5} ,;             
             {"Aprovar","U_aprSSI",0,6},;
             {"Cancelar","U_canSSI",0,7},;               
             {"Iniciar","U_iniSSI",0,8},;           
             {"Finalizar","U_fimSSI",0,9},;
             {"Relatório","U_SSIREL",0,10},;      
             {"Laudo","U_comSSI",0,11},;          
             {"Legenda"   ,"U_SSILeng",0,12}}   
             
Private 	aCores    	:= {{ "SZH->ZH_STATUS=='0'", 'BR_AZUL' },;     // Aberto
		                { "SZH->ZH_STATUS=='2'", 'ENABLE'},;       // Aprovado
						{ "SZH->ZH_STATUS=='8'", 'BR_PRETO'},;     // Cancelado
						{ "SZH->ZH_STATUS=='9'", 'DISABLE'},;      // Encerrado
						{ "SZH->ZH_STATUS=='1'", 'BR_AMARELO'}} // Em andamento


	    DbSelectArea(cAlias)
		(cAlias)->(DbSetOrder(1))
		(cAlias)->(DbGoTop())

		//	setKey(123, nil) // Desativa a tecla F12 para acionamento dos parametros
		If	( cNivel < 9 ) // Caso nao seja Usuario Superior 
		    //	If	! ( AllTrim(cModulo) $ "ATF|" ) // Caso o modulo nao seja Ativo Fixo
		    _cFiltro := "ALLTRIM(SZH->ZH_SOLCHAM) == ALLTRIM(__cUserId) .OR. ALLTRIM(SZH->ZH_APROVA) == ALLTRIM(__cUserId) " //ALLTRIM(SZH->ZH_CC) == ALLTRIM(cCCSoli)" // Filtra, mostrando somente os chamados do usuario.
		Else
			    //_cFiltro := "_cEmpUso $ SZH->ZH_EMPCHAM" // Filtra, mostrando os dados de todos os usuarios, mas somente da mesma empresa.
			//EndIf 
		   // AjustaSx1(_cPerg) // ajusta os parametros da rotina.
			If	!Pergunte(_cPerg,.T.) // Faz as perguntas ao usuario.
				Return .f.
			ELSE
			    
			
					// Monta o filtro de acordo com os parametros selecionados.
				If	( mv_par01 == 1 ) // Aberto
					_cFiltro := "(AllTrim(SZH->ZH_STATUS)='0')" //.or. AllTrim(SZH->ZH_STATUS)='1') "
				ElseIf	( mv_par01 == 2 ) // Aprovado
					_cFiltro := "AllTrim(SZH->ZH_STATUS)='2'"
				ElseIf	( mv_par01 == 3 ) // Em andamento
					_cFiltro := "AllTrim(SZH->ZH_STATUS)='1'"
				ElseIf	( mv_par01 == 4 ) // Encerrados
					_cFiltro := "AllTrim(SZH->ZH_STATUS)='9'"
				Else
					_cFiltro := "AllTrim(SZH->ZH_STATUS)$'0/1/2/8/9'"
				EndIf
				
				If	( mv_par02 == 1 ) // Alto
					_cFiltro += " .AND. AllTrim(SZH->ZH_PRICHAM)='A'"
				ElseIf	( mv_par02 == 2 ) // Normal                                 
					_cFiltro += " .AND. AllTrim(SZH->ZH_PRICHAM)='N'"
				ElseIf	( mv_par02 == 3 ) // Baixa
					_cFiltro += " .AND. AllTrim(SZH->ZH_PRICHAM)='B'"
				Else
					_cFiltro += " .AND. AllTrim(SZH->ZH_PRICHAM)$'A/B/N'"
				EndIf

				_cFiltro += " .AND. SZH->ZH_SOLCHAM >= '" + mv_par03 + "' .AND. SZH->ZH_SOLCHAM <= '" + mv_par04 + "' "
				
				If	( mv_par05 == 1 ) // Filtra por Tecnico /1=Sim,2=Nao
					_cFiltro += " .AND. ( (SZH->ZH_SOLCHAM == __cUserId) .or. (SZH->ZH_TECALOC == __cUserId) .or. (SZH->ZH_TECNICO == __cUserId) ) "
				EndIf
				
				If	( ! Empty(mv_par06) )
					_cFiltro += " .AND. ( AllTrim(Upper(mv_par06)) $ Upper(SZH->ZH_DESC) .or. AllTrim(Upper(mv_par06)) $ Upper(SZH->ZH_OCORREN) ) "
				EndIf
				
				
				_cFiltro += " .AND. SZH->ZH_CC >= '" + mv_par07 + "' .AND. SZH->ZH_CC <= '" + mv_par08 + "' "
				
                /*
                DbSelectArea("CTT")
                DbGotop()
                RelCC:=""
                While !Eof()
                    If Alltrim(CConf)=Alltrim(CTT->CTT_GER)
                    	RelCC+="/"+Alltrim(CTT->CTT_CUSTO)
                    Endif 
	                DbSkip()
                EndDo 
                */      
                //PROVADOR QUE CONTENHA O ID DELE
				IF  ValAprova(__cUserId,5) .And. (__cUserId <> '000025') .AND. (Alltrim(cCCSoli) <> '126') // 126 = CC do TI      
					If	( mv_par01 == 1 ) // Aberto
						_cFiltro := "(AllTrim(SZH->ZH_STATUS)='0')" //.or. AllTrim(SZH->ZH_STATUS)='1') "
					ElseIf	( mv_par01 == 2 ) // Aprovado
						_cFiltro := "AllTrim(SZH->ZH_STATUS)='2'"
					ElseIf	( mv_par01 == 3 ) // Em andamento
						_cFiltro := "AllTrim(SZH->ZH_STATUS)='1'"
					ElseIf	( mv_par01 == 4 ) // Encerrados
						_cFiltro := "AllTrim(SZH->ZH_STATUS)='9'"
					Else
						_cFiltro := "AllTrim(SZH->ZH_STATUS)$'0/1/2/8/9'"
					EndIf
					 _cFiltro+="   .AND.(AllTrim(SZH->ZH_APROVA)=='"+__cUserId+"'  "						                					
					_cFiltro +="  .OR. AllTrim(SZH->ZH_CC)=='"+cCCSoli+"') "  /*Enxerga apenas o centro de custo dele ***********/
					_cFiltro += " .AND. SZH->ZH_SOLCHAM >= '" + mv_par03 + "' .AND. SZH->ZH_SOLCHAM <= '" + mv_par04 + "' "
						// Monta o filtro de acordo com os parametros selecionados.
				
				
					If	( mv_par02 == 1 ) // Alto
						_cFiltro += " .AND. AllTrim(SZH->ZH_PRICHAM)='A'"
					ElseIf	( mv_par02 == 2 ) // Normal                                 
						_cFiltro += " .AND. AllTrim(SZH->ZH_PRICHAM)='N'"
					ElseIf	( mv_par02 == 3 ) // Baixa
						_cFiltro += " .AND. AllTrim(SZH->ZH_PRICHAM)='B'"
					Else
						_cFiltro += " .AND. AllTrim(SZH->ZH_PRICHAM)$'A/B/N'"
					EndIf     
				
	     			If	( ! Empty(mv_par06) )
						_cFiltro += " .AND. ( AllTrim(Upper(mv_par06)) $ Upper(SZH->ZH_DESC) .or. AllTrim(Upper(mv_par06)) $ Upper(SZH->ZH_OCORREN) ) "
					EndIf
	

				ENDif
                 /*
                if  !Empty(RelCC)
	                _cFiltro +="  .AND. AllTrim(SZH->ZH_CC)$'"+RelCC+"'  "						                	
                ElseIf cCCSoli <>'126' .or. CNivel<>9   /*Proprio para TI e para o Sr. Ronaldo Bosco**/
                									 /**e o código não for da Daniele que está cadastrada na empresa terceiros**/	
                									  /* 				  
                if  cMatSol<>'080030' 
                    _cFiltro +="  .AND. AllTrim(SZH->ZH_CC)=='"+cCCSoli+"' "  /*Enxerga apenas o centro de custo dele ***********/
                   // EndIF 
               // Endif     //             
				
					
			ENDIf
		EndIF		

	If	! Empty(_cFiltro) 
			_bFiltraBrw := {|| FilBrowse("SZH",@_aIndexSZH,@_cFiltro) }
			Eval(_bFiltraBrw)
		EndIf

		mBrowse(6,1,22,75,'SZH',,,,,,aCores)

		EndFilBrw("SZH",_aIndexSZH)
    
return

static Function telaSSI2()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
//recuperação dos dados do funcionário

aDados := FunPesq(cMatSol)
Private cNomeSol   :=  aDados[1][3]
Private cAprov     := Space(6)    
Private dDtAprov   := Ctod('  /  /  ')
Private cCcusto    := cCCSoli
Private cDesc      := cDescSol
Private cComenta  
Private cCometaSol
Private cDoc       := StrZero(val(GeraSeq("SZH","ZH_NUMCHAM")),8)
Private cDocTp     := Space(60)
Private cDescCha   := Space(80)
Private cDescPri   := Space(60)
Private cDtEnc     := Ctod('  /  /  ')
Private dDtPrev    := Ctod('  /  /  ')
Private cDtReg     := Date()
Private cEmp       := Space(1)
Private cExecuta   := Space(1)
Private cHrEnc     := Space(1)
Private cHrReg     := Time()
Private cMat       := __cUserId
Private cMatAcss   := Space(6)
Private cMosulosD  
Private cNomeAce   := Space(60)
Private cNomeAp    := Space(60)
Private cNomeEnc   := Space(601)
private nHrIni1    :=0
private nHrFim1    :=0 
private nHrIni2    :=0
private nHrFim2    :=0
Private cNomeTec   := Space(60)
Private cSitesD   
private cDescGer 
Private cSolucao  
Private cTec       := Space(6)
Private cTecEnc    := Space(1)
Private cTipoPri   := Space(1)
Private cTipoSer   := Space(3)
Private lCBBloq    := .F.
Private lCBCorreio := .F.
Private lCBEmail   := .F.
Private lCBMicros  := .F.
Private lCBPartic  := .F.
Private lCBRede    := .F.
Private lCBSite    := .F.
Private lCBThin    := .F.
Private lCBWind    := .F.                                                    

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± ATRIBUIR DADOS PARA VISUALIZAÇÃO						                    ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/                                  
IF nOpcao == 4
	copySSI()    
ElseIf nOpcao > 1 .And. nOpcao <> 4
	visualSSI()     		
EndIF


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oFld1","oGrp3","oSay20","oSay21","oSay22","oSay23","oTec","oNomeTec","oDtPrev","oComenta")
SetPrvt("oSay1","oSay2","oSay3","oSay4","oSay17","oMat","oNomeSol","oCcusto","oDesc","oEmp","oGrp2","oSay5")
SetPrvt("oSay7","oSay8","oSay9","oSay10","oSay11","oSay12","oSay13","oSay14","oSay15","oSay16","oSay18","oSay20")
SetPrvt("oDoc","oDtReg","oHrReg","oDescCha","oAprov","oNomeAp","oTipoSer","oDocTp","oTipoPri","oDescPri")
SetPrvt("oCBSite","oCBMicros","oCBPartic","oCBCorreio","oCBWind","oCBThin","oCBEmail","oCBBloq","oCBRede")
SetPrvt("oMosulosD","oMatAcss","oNomeAce","oGrp5","oSay24","oSay25","oSay26","oSay27","oSay28","oSay29","oSay30","oSay31")
SetPrvt("oHrEnc","oExecuta","oTecEnc","oNomeEnc","oSolucao",'oGrp7',"oGrp6","oCometaSol","oHrIni","oHrFim","oHrFim2","oHrIni2","oTextD","oDtAprov")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 088,239,698,1135,"SSI - Serviço de Solicitações de Informática",,,.F.,,,,,,.T.,,,.T. )
oDlg1:bInit := {||EnchoiceBar(oDlg1,{||redirect()},{||oDlg1:end()},.F.,{})}

oFld1      := TFolder():New( 016,008,{"Dados da solicitação","Detalhes da solicitação","Dados do andamento","Dados da finalização"},{},oDlg1,,,,.T.,.F.,428,280,) 

oGrp3      := TGroup():New( 004,004,252,416,"Andamento da SSI",oFld1:aDialogs[3],CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay20     := TSay():New( 016,016,{||"Tec. Alocado:"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
oSay21     := TSay():New( 016,060,{||"Nome do tec."},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
oSay22     := TSay():New( 040,016,{||"Data da entrega  prevista:"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,068,008)
oSay23     := TSay():New( 064,016,{||"Comentários:"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)

oTec       := TGet():New( 024,016,{|u| If(PCount()>0,cTec:=u,cTec)},oGrp3,036,008,'',{||xTecAloc()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ZU","cTec",,)
oNomeTec   := TGet():New( 024,060,{|u| If(PCount()>0,cNomeTec:=u,cNomeTec)},oGrp3,344,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cNomeTec",,)
oDtPrev    := TGet():New( 048,016,{|u| If(PCount()>0,dDtPrev:=u,dDtPrev)},oGrp3,060,008,'',{||xDtPrev()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDtPrev",,)
oComenta   := TMultiGet():New( 072,016,{|u| If(PCount()>0,cComenta:=u,cComenta)},oGrp3,388,168,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )

oGrp7		:= TGroup():New( 004,004,252,416,"Detalhamentos geral",oFld1:aDialogs[2],CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay15     := TSay():New( 016,016,{||"Descrição dos sites:"},oGrp7,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
oSay15     := TSay():New( 016,070,{||"1ºHorario:"},oGrp7,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,056,008)
oSay15     := TSay():New( 016,130,{||"ás:"},oGrp7,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)                  

oSay30     := TSay():New( 016,180,{||"2ºHorario:"},oGrp7,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,056,008)
oSay31     := TSay():New( 016,240,{||"ás:"},oGrp7,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)


oSay16     := TSay():New( 80,016,{||"Descrição dos modulos:"},oGrp7,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,008)
oSay14     := TSay():New( 145,016,{||"Detalhamento Geral da Ocorência:"},oGrp7,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,164,008)

oHrIni     := TGet():New( 015,95,{|u| If(PCount()>0,nHrIni1:=u,nHrIni1)},oGrp7,30,008,'99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nHrIni1",,)
oHrFim     := TGet():New( 015,140,{|u| If(PCount()>0,nHrFim1:=u,nHrFim1)},oGrp7,30,008,'99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nHrFim1",,)

oHrIni2     := TGet():New( 015,205,{|u| If(PCount()>0,nHrIni2:=u,nHrIni2)},oGrp7,30,008,'99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nHrIni2",,)
oHrFim2     := TGet():New( 015,250,{|u| If(PCount()>0,nHrFim2:=u,nHrFim2)},oGrp7,30,008,'99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nHrFim2",,)




oSitesD    := TMultiGet():New( 024,016,{|u| If(PCount()>0,cSitesD:=u,cSitesD)},oGrp7,388,50,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  ) 
oMosulosD	:= TMultiGet():New( 090,016,{|u| If(PCount()>0,cMosulosD:=u,cMosulosD)},oGrp7,388,50,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  ) 
//oMosulosD	:= TMultiGet():New( 090,016,{|u| If(PCount()>0,cMosulosD:=u,cMosulosD)},oGrp7,388,50,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.T.,,,.F.,, .T.  ) 
oTextD		:= TMultiGet():New( 155,016,{|u| If(PCount()>0,cDescGer:=u,cDescGer)},oGrp7,388,95,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )


oGrp1      := TGroup():New( 004,004,056,420,"Dados do solicitante",oFld1:aDialogs[1],CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 012,012,{||"ID:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay2      := TSay():New( 012,064,{||"Nome:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay3      := TSay():New( 032,012,{||"C. Custo:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay4      := TSay():New( 032,064,{||"Descrição do C. Custo:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,008)

oMat       := TGet():New( 020,012,{|u| If(PCount()>0,cMat:=u,cMat)},oGrp1,048,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cMat",,)
oNomeSol   := TGet():New( 020,064,{|u| If(PCount()>0,cNomeSol:=u,cNomeSol)},oGrp1,344,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cNomeSol",,)
oCcusto    := TGet():New( 040,012,{|u| If(PCount()>0,cCcusto:=u,cCcusto)},oGrp1,048,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cCcusto",,)
oDesc      := TGet():New( 040,064,{|u| If(PCount()>0,cDesc:=u,cDesc)},oGrp1,064,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDesc",,)

oGrp2      := TGroup():New( 060,004,264,420,"Informações",oFld1:aDialogs[1],CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay5      := TSay():New( 068,012,{||"Documento:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay6      := TSay():New( 068,064,{||"Data Registro:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
oSay7      := TSay():New( 068,116,{||"Hora do Registro:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oSay8      := TSay():New( 108,012,{||"Titulo do chamado:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,008)
oSay9      := TSay():New( 088,012,{||"Aprovador:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay10     := TSay():New( 088,064,{||"Nome do aprovador:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)

oSay20     := TSay():New( 088,354,{||"Data da Aprovação:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)

oSay11     := TSay():New( 128,012,{||"Tipo de serviço"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oSay12     := TSay():New( 128,064,{||"Descrição do serviço:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,056,008)
oSay13     := TSay():New( 128,172,{||"Tipo de Prioridades:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
oSay14     := TSay():New( 128,224,{||"Descrição de prioridade:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)

oSay18     := TSay():New( 204,012,{||"Matricula de Acessos"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
oSay19     := TSay():New( 204,076,{||"Nome:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)

oDoc       := TGet():New( 076,012,{|u| If(PCount()>0,cDoc:=u,cDoc)},oGrp2,048,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDoc",,)
oDtReg     := TGet():New( 076,064,{|u| If(PCount()>0,cDtReg:=u,cDtReg)},oGrp2,044,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDtReg",,)
oHrReg     := TGet():New( 076,116,{|u| If(PCount()>0,cHrReg:=u,cHrReg)},oGrp2,044,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cHrReg",,)
oAprov     := TGet():New( 096,012,{|u| If(PCount()>0,cAprov:=u,cAprov)},oGrp2,048,008,'999999',{||aprovador()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ZZS","cAprov",,)
oNomeAp    := TGet():New( 096,064,{|u| If(PCount()>0,cNomeAp:=u,cNomeAp)},oGrp2,280,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cNomeAp",,)

oDtAprov   := TGet():New( 096,354,{|u| If(PCount()>0,dDtAprov:=u,dDtAprov)},oGrp2,60,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDtAprov",,)

oDescCha   := TGet():New( 116,012,{|u| If(PCount()>0,cDescCha:=u,cDescCha)},oGrp2,396,008,'@!',{||descVal()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDescCha",,)
oTipoSer   := TGet():New( 136,012,{|u| If(PCount()>0,cTipoSer:=u,cTipoSer)},oGrp2,048,008,'999',{||tipoSol()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ZF","cTipoSer",,)
oDocTp     := TGet():New( 136,064,{|u| If(PCount()>0,cDocTp:=u,cDocTp)},oGrp2,092,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDocTp",,)
oTipoPri   := TGet():New( 136,176,{|u| If(PCount()>0,cTipoPri:=u,cTipoPri)},oGrp2,040,008,'@!',{||priSol()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ZG","cTipoPri",,)
oDescPri   := TGet():New( 136,224,{|u| If(PCount()>0,cDescPri:=u,cDescPri)},oGrp2,060,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDescPri",,)

oGrp4      := TGroup():New( 152,012,200,412,"Serviços adicionais",oGrp2,CLR_BLACK,CLR_WHITE,.T.,.F. )
oCBSite    := TCheckBox():New( 164,016,"Internet sites",{|u| If(PCount()>0,lCBSite:=u,lCBSite)},oGrp4,048,008,,{||abilitSite()},,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oCBMicros  := TCheckBox():New( 176,016,"Modulos Microsiga",{|u| If(PCount()>0,lCBMicros:=u,lCBMicros)},oGrp4,056,008,,{||abilitMicro()},,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oCBPartic  := TCheckBox():New( 188,016,"Pasta Particular",{|u| If(PCount()>0,lCBPartic:=u,lCBPartic)},oGrp4,048,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oCBCorreio := TCheckBox():New( 164,132,"Pasta Correios",{|u| If(PCount()>0,lCBCorreio:=u,lCBCorreio)},oGrp4,048,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oCBWind    := TCheckBox():New( 176,132,"Acessos Windows",{|u| If(PCount()>0,lCBWind:=u,lCBWind)},oGrp4,052,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oCBThin    := TCheckBox():New( 188,132,"Acessos Thin Client",{|u| If(PCount()>0,lCBThin:=u,lCBThin)},oGrp4,060,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oCBEmail   := TCheckBox():New( 164,256,"Acesso a Email",{|u| If(PCount()>0,lCBEmail:=u,lCBEmail)},oGrp4,048,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oCBBloq    := TCheckBox():New( 176,256,"Bloquear Acesso",{|u| If(PCount()>0,lCBBloq:=u,lCBBloq)},oGrp4,052,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oCBRede    := TCheckBox():New( 188,256,"Ponto de rede",{|u| If(PCount()>0,lCBRede:=u,lCBRede)},oGrp4,048,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )

oMatAcss   := TGet():New( 212,012,{|u| If(PCount()>0,cMatAcss:=u,cMatAcss)},oGrp2,048,008,'999999',{||usuAssSol()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cMatAcss",,)
oNomeAce   := TGet():New( 212,076,{|u| If(PCount()>0,cNomeAce:=u,cNomeAce)},oGrp2,332,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cNomeAce",,)



oGrp5      := TGroup():New( 008,008,152,416,"Informações tecnicas",oFld1:aDialogs[4],CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay24     := TSay():New( 020,020,{||"Data da entrega:"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oSay25     := TSay():New( 020,072,{||"Hora da entrega:"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
oSay26     := TSay():New( 020,132,{||"Dias em Atraso"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,068,008)
oSay27     := TSay():New( 044,020,{||"Tecnico:"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay28     := TSay():New( 044,072,{||"Nome"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay29     := TSay():New( 064,020,{||"Solução do problema"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,068,008)

oDtEnc     := TGet():New( 028,020,{|u| If(PCount()>0,cDtEnc:=u,cDtEnc)},oGrp5,044,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDtEnc",,)
oHrEnc     := TGet():New( 028,072,{|u| If(PCount()>0,cHrEnc:=u,cHrEnc)},oGrp5,044,008,'99:99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cHrEnc",,)
oExecuta   := TGet():New( 028,132,{|u| If(PCount()>0,cExecuta:=u,cExecuta)},oGrp5,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cExecuta",,)
oTecEnc    := TGet():New( 052,020,{|u| If(PCount()>0,cTecEnc:=u,cTecEnc)},oGrp5,044,008,'',{||xTecEnc()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ZU","cTecEnc",,)
oNomeEnc   := TGet():New( 052,068,{|u| If(PCount()>0,cNomeEnc:=u,cNomeEnc)},oGrp5,336,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cNomeEnc",,)
oSolucao   := TMultiGet():New( 076,020,{|u| If(PCount()>0,cSolucao:=u,cSolucao)},oGrp5,384,060,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )

oGrp6      := TGroup():New( 156,008,256,416,"Laudo Técnico",oFld1:aDialogs[4],CLR_BLACK,CLR_WHITE,.T.,.F. )
oCometaSol := TMultiGet():New( 168,016,{|u| If(PCount()>0,cCometaSol:=u,cCometaSol)},oGrp6,396,084,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )



/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Desabilitar todos os campos do formulário                               ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
desabilitar()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	1- Cadastro				
	2- Visualizar
	3- Alterar
	4- Copiar
	5- Aprovar
	6- Cancelar
	7- Imprimir
	8- Iniciar
	9- Finalizar
	10- comentar
	11- Encluir
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

if (nOpcao = 1)  .Or. (nOpcao = 4) .Or. (nOpcao = 3)
	oDescCha   :Enable()
	oAprov     :enable()
	oTipoSer   :enable()
	oTipoPri   :enable()
	oMatAcss   :enable()
	oCBSite    :enable()
	oCBMicros  :enable()
	oCBPartic  :enable()
	oCBCorreio :enable()
	oCBWind    :enable()
	oCBThin    :enable()
	oCBEmail   :enable()
	oCBBloq    :enable()
	oCBRede    :enable()
	oTextD	   :enable()
	oFld1:aDialogs[1]:enable()
	oFld1:aDialogs[2]:enable()	
ELSEIF nOpcao = 6 .Or. nOpcao = 5
	oCometaSol :enable()    
ELSEIF nOpcao = 8
	oTec       :enable()
	oDtPrev    :enable()
	oComenta   :enable()
ELSEIF nOpcao = 9
	oTec       :enable()
    oNomeTec   :enable()
	oDtPrev    :enable()
	oComenta   :enable()
	oDtEnc     :enable()
	oHrEnc     :enable()
	oTecEnc    :enable()
	oSolucao   :enable()
ELSEIF nOpcao = 10       	
	oCometaSol :enable()
EndIF    

IF nOpcao > 3 .Or. nOpcao = 2
	oFld1:aDialogs[1]:enable()
	oFld1:aDialogs[2]:enable()
	oFld1:aDialogs[3]:enable()
	oFld1:aDialogs[4]:enable()
eNDif
oDlg1:Activate(,,,.T.)

Return

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Desabilitar todos os campos do formulário                               ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function desabilitar()		
		
	oTec		:Disable()
    oNomeTec   :disable()
	oDtPrev    :disable()
	oComenta   :disable()
		
	oMat		:disable()
	oNomeSol	:disable()
	oCcusto		:disable()
	oDesc		:disable()
	oHrIni		:disable()
    oHrFim 		:disable()
    oHrFim2		:disable() 
    oHrIni2		:disable() 
    oTextD		:disable()
	oDoc       	:disable()
	oDtReg     	:disable()
	oHrReg     	:disable()
	oDescCha   	:disable()
	oAprov     	:disable()
	oNomeAp    	:disable()
	oDtAprov	:disable()
	oTipoSer   	:disable()
	oDocTp     	:disable()
	oTipoPri	:disable()
	oDescPri	:disable()
	
	oSitesD    :disable()
	//oMosulosD  :disable()
	oMosulosD  :lreadonly:=.T.
	oMatAcss   :disable()
	oNomeAce   :disable()
	
	oDtEnc     :disable()
	oHrEnc     :disable()
	oExecuta   :disable()
	oTecEnc    :disable()
	oNomeEnc   :disable()
	oSolucao   :disable()	
	oCometaSol	:disable()
	
	oCBSite    :disable()
	oCBMicros  :disable()
	oCBPartic  :disable()
	oCBCorreio :disable()
	oCBWind    :disable()
	oCBThin    :disable()
	oCBEmail   :disable()
	oCBBloq    :disable()
	oCBRede    :disable()
	
	oFld1:aDialogs[1]:disable()
	//oFld1:aDialogs[2]:disable()
	oFld1:aDialogs[2]:enable()
	oFld1:aDialogs[3]:disable()
	oFld1:aDialogs[4]:disable()
Return nil

 
Static Function visualSSI() 
		
	        cDoc		:= SZH->ZH_NUMCHAM
			//cEmpCham	:= SZH->ZH_EMPCHAM
			cMat		:= SZH->ZH_SOLCHAM      
			cNomeSol	:= xUsrDados(cMat,4)//Upper(UsrFullName(cTec))
			
			cTipoPri	:= SZH->ZH_PRICHAM
			cDescCha	:= SZH->ZH_DESC			
			cTipoSer	:= SZH->ZH_TIPO
			cMosulosD	:= SZH->ZH_MODULO   	
			//cDescPri	:= Tabela('ZG',SZH->ZH_PRICHAM)      
			//cProgCham	:= SZH->ZH_PROGRAM
			cDtReg		:= SZH->ZH_DTABERT
			cHrReg		:= SZH->ZH_HRABERT
			cDescGer	:= SZH->ZH_OCORREN
			//mAberOcor	:= SZH->ZH_OCORREN
			cTec		:= SZH->ZH_TECALOC  			
			cNomeTec	:= xUsrDados(cTec,4)//Upper(UsrFullName(cTec))
		    cComenta	:= SZH->ZH_COMENTA
			cDtEnc		:= SZH->ZH_DTFECHA
			cHrEnc		:= SZH->ZH_HRFECHA
			cTecEnc		:= SZH->ZH_TECNICO
			cNomeEnc	:= xUsrDados(cTecEnc,4)// Upper(UsrFullName(cTecEnc)) 		
			cSolucao	:= SZH->ZH_SOLUCAO
			//mSoluOcor	:= SZH->ZH_SOLUCAO
			//cClasFech	:= SZH->ZH_CLASSIF
			cAprov		:= SZH->ZH_APROVA     
			dDtAprov	:= SZH->ZH_DTAPROV     
			cNomeAp		:= xUsrDados(cAprov,4)
			dDtPrev     := SZH->ZH_DTENTRE
			cCcusto     := ALLTRIM(SZH->ZH_CC)        
			
			cMatAcss	:= SZH->ZH_MATACES 
            lCBSite		:= SZH->ZH_CHKINTE  
            lCBMicros	:= SZH->ZH_CHKSIGA	 
            lCBPartic	:= SZH->ZH_CHKPART	 
            lCBCorreio	:= SZH->ZH_CHKCORR	 
            lCBWind		:= SZH->ZH_CHKWIND	 
            lCBEmail	:= SZH->ZH_CHKEMAI	
            lCBBloq		:= SZH->ZH_CHKBLOC	 
            lCBRede		:= SZH->ZH_CHKREDE  
            lCBThin		:= SZH->ZH_CHKTHIN  
            cSitesD		:= SZH->ZH_DESCSIT 
            cMosulosD	:= SZH->ZH_DESCMOD 
            nHrIni1		:= SZH->ZH_HRINIEN
            nHrFim1		:= SZH->ZH_HRFIMEN            
            nHrIni2		:= SZH->ZH_HRINI2 	  
            nHrFim2		:= SZH->ZH_HRFIM2
            cCometaSol	:= SZH->ZH_COMFUN 
			cDesc		:= alltrim(Posicione("CTT",1,xFilial("CTT") + cCcusto,"CTT_DESC01"))
			
			IF nOpcao == 5      
					cAprov		:= __cUserId     
					cNomeAp		:= Upper(UsrFullName(__cUserId)) 				
					dDtAprov    := Date()
					
			EndIF        
			
			IF nOpcao == 3 .Or. nOpcao == 11
			  IF !ValAprova(__cUserId,5)
				cMat		:= __cUserId  				      
				cNomeSol	:= Upper(UsrFullName(__cUserId))     						
			   EndIF
			EndIF  
			
			//cTmpExec    := SZH->ZH_TMPEXEC  
			IF !Empty(cDtEnc)
			    cExecuta    := cDtEnc - dDtPrev
			ElseIF !Empty(dDtPrev)           
			    cExecuta    := dDataBase - dDtPrev	   
			Else
				cExecuta 	:= 0 	
			EndIF       
		
			priSol()           
			 
			cDocTp:=	 Tabela('ZF',cTipoSer)            

			aDados := FunPesq(cMatAcss)
			cNomeAce := aDados[1][3]
			
	
Return nil                                  

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Copiar SSI já feita                                                     ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Static Function copySSI()
	        
	cTipoPri		:= SZH->ZH_PRICHAM
	cDescCha		:= SZH->ZH_DESC			
	cTipoSer		:= SZH->ZH_TIPO
	cMosulosD		:= SZH->ZH_MODULO   	
	cDescGer		:= SZH->ZH_OCORREN
	cAprov			:= SZH->ZH_APROVA 
	cNomeAp			:= xUsrDados(cAprov,4) 
	nHrIni1			:= SZH->ZH_HRINIEN
    nHrFim1			:= SZH->ZH_HRFIMEN
    nHrIni2			:= SZH->ZH_HRINI2 	  
    nHrFim2			:= SZH->ZH_HRFIM2 	  
    lCBSite			:= SZH->ZH_CHKINTE  
    lCBMicros		:= SZH->ZH_CHKSIGA	 
    lCBPartic		:= SZH->ZH_CHKPART	 
    lCBCorreio		:= SZH->ZH_CHKCORR	 
    lCBWind			:= SZH->ZH_CHKWIND	 
    lCBEmail		:= SZH->ZH_CHKEMAI	
    lCBBloq			:= SZH->ZH_CHKBLOC	 
    lCBRede			:= SZH->ZH_CHKREDE  
    lCBThin			:= SZH->ZH_CHKTHIN  
    cSitesD			:= SZH->ZH_DESCSIT 
    cMosulosD		:= SZH->ZH_DESCMOD		       
  	
  	//priSol()          			 
   //	cDocTp:=	 Tabela('ZF',cTipoSer)            
    
    
    
	aDados 			:= FunPesq(cMatAcss)
	cNomeAce 		:= aDados[1][3]
	//priSol()           
	//cDocTp:=	 Tabela('ZF',cTipoSer)            

	
Return nil



/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Redirecionamento para telas                                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	1- Cadastro				
	2- Visualizar
	3- Alterar
	4- Copiar
	5- Aprovar
	6- Cancelar
	7- Imprimir
	8- Iniciar
	9- Finalizar
	10- comentar
	11- Encluir
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
//Leganda
User Function SSILeng()
Local	aLegenda  := {	{'BR_AZUL'		,'Aberto'},;
                        {'ENABLE'		,'Aprovado'},;
						{'BR_AMARELO'	,'Em Andamento'},;
						{'BR_PRETO'	    ,'Cancelado'},;
						{'DISABLE'		,'Encerrado'}	}

		BrwLegenda(cCadastro,'Legenda',aLegenda)

Return .T.
//cadastrar
User Function cadSSI()
		
	nOpcao:= 1
	telaSSI2()
	
Return nil
//visualizar
User Function visSSI()
		
	nOpcao:= 2
	telaSSI2()
	
Return nil

//alterar
User Function altSSI()
	IF SZH->ZH_STATUS == '0' .And. SZH->ZH_SOLCHAM == __cUserId   	
		nOpcao:= 3
		telaSSI2()
	EndIF
//adicionado para o setor de T.I. poder alterar as SSI 24/02/2016 por Nilton Cardoso
    IF Alltrim(cCCSoli)='126'  	
	nOpcao:= 3
	telaSSI2()
	EndIF 
//
Return nil
//copiar para cadastrar
User Function copSSI()		
	nOpcao:= 4
	telaSSI2()	
Return nil
//aprovar
User Function aprSSI()	   
	IF  ValAprova(__cUserId,5)     
		IF SZH->ZH_STATUS = '0'       
			nOpcao:= 5
			telaSSI2()
		Else
	    	MsgInfo("Solicitação já foi Aprovada!","Atenção")  	    	      
	  	ENDIF
	Else
		MsgInfo("Você não tem permição para aprovar!","Atenção")  	    	              
	EndIF
	
Return nil
//cancelar
User Function canSSI()
	IF SZH->ZH_STATUS <> '9' 
	  IF SZH->ZH_SOLCHAM == __cUserId .Or. ValAprova(__cUserId,5)
		nOpcao:= 6
		telaSSI2()                        		
	  EndIF
	   
    Else  
		MsgInfo("Você não pode cancelar solicitações finalizadas!","Atenção")  	    	       
	EndIF
Return nil

//inicializar uma solicitação
User Function iniSSI()           
  	IF cNivel == 9
		IF SZH->ZH_STATUS == '0' .Or. SZH->ZH_STATUS == '2'	    			    			
			nOpcao:= 8
			telaSSI2()      
		Else  
    		MsgInfo("Você não pode iniciar essa solicitação!","Atenção")  	    	       
		EndIF           
  	Else
  		MsgInfo("Você não tem permição!","Atenção")  	    	       	       
  	EndiF	
Return

//finalizar uma solicitação
User Function fimSSI()
	IF cNivel == 9     
		IF SZH->ZH_STATUS <> '8' .And. SZH->ZH_STATUS <> '9'	    			    	
			nOpcao:= 9
			telaSSI2()   
		Else  
    		MsgInfo("Você não pode finalizar essa solicitação!","Atenção")  	    	       
   		EndIF	
  	Else
  		MsgInfo("Você não tem permição!","Atenção")  	    	       	       
  	EndiF	
Return

//comentario
//alterado o comentario para laudo técnico 24/02/2016 por Nilton Cardoso
User Function comSSI()       
	IF Alltrim(cCCSoli)='126' 	
		IF Empty(SZH->ZH_COMFUN)
			nOpcao:= 10
			telaSSI2()
		Else
			MsgInfo("Laudo técnico já foi informado!","Atenção")  	    
		EndIF
	Else
		MsgInfo("Você não pode comentar essa solicitação!","Atenção")  	    
	EndIF
Return    

User Function excSSI()
	IF SZH->ZH_STATUS == '0' .And. SZH->ZH_SOLCHAM == __cUserId 
	 
    	nOpcao:= 11
		telaSSI2()        
	Else
	   MsgInfo("Você não pode Excluir!","Atenção")  	    
	ENdIF
return
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Redirecionamento pessistencia no banco                                  ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	1- Cadastro				
	2- Visualizar
	3- Alterar
	4- Copiar
	5- Aprovar
	6- Cancelar
	7- Imprimir
	8- Iniciar
	9- Finalizar
	10- comentar
	11- Encluir
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function redirect()
		Local lVal:= .F.
		Local bResp:= .F.
		
		lVal:= xValida()
	     
	    IF nOpcao == 1  .Or. nOpcao == 4//Registrar - Registrar o copiado
	    	IF lVal    
	    	    bResp := MsgYesNo("Você confirma os dados!","Atenção")      
	    	    
	    	    IF bResp
	    			MsgRun(OemToAnsi('Gerando o Chamado.... Aguarde....'),'',{|| CursorWait(), cadSSIF() ,CursorArrow()}) 
	    			MsgInfo("Cadastro realizado com sucesso","Atenção")     
	    			EnviaEmail()//enviar email
	    			oDlg1:End() 
	    		ENDIF
	    		
	    	ENDIF  
	    
	    ELSEIF nOpcao == 2//Visualizar	
	    	oDlg1:End()	    	 	    
	    ElseIF nOpcao == 3//Alterar
	    	IF lVal    
	    	    bResp := MsgYesNo("Você confirma os dados","Atenção")      
	    	    IF bResp
	    			MsgRun(OemToAnsi('Gerando o Chamado.... Aguarde....'),'',{|| CursorWait(), cadSSIF() ,CursorArrow()}) 
	    			MsgInfo("Altalização realizado com sucesso","Atenção")  
	    			oDlg1:End() 
	    		ENDIF
	    	ENDIF
	    ElseIF nOpcao == 5//Aprovar
	      		bResp := MsgYesNo("Você confirma os Aprovação!","Atenção")      
	    	    IF bResp	          
	    	        MsgRun(OemToAnsi('Gerando o Chamado.... Aguarde....'),'',{|| CursorWait(), cadSSIF() ,CursorArrow()}) 
	    			MsgInfo("Aprovação realizado com sucesso","Atenção")  	    	    
	    			EnviaEmail()//enviar email
	    			oDlg1:End()
	    	    ENDIF
	    ElseIF nOpcao == 6 //Cancelar 
	    	
	    		bResp := MsgYesNo("Você confirma o cancelamento!","Atenção")      
	    	    IF bResp	          
	    	        MsgRun(OemToAnsi('Gerando o Chamado.... Aguarde....'),'',{|| CursorWait(), cadSSIF() ,CursorArrow()}) 
	    			MsgInfo("Cancelado com sucesso!","Atenção")  	    	    
	    			EnviaEmail()//enviar email
	    			oDlg1:End()
	    	    ENDIF
	    ElseIF nOpcao == 8 //Iniciar 
	    	
	    		bResp := MsgYesNo("Você confirma a inicialização dessa atividade!","Atenção")      
	    	    IF bResp	          
	    	        MsgRun(OemToAnsi('Gerando o Chamado.... Aguarde....'),'',{|| CursorWait(), cadSSIF() ,CursorArrow()}) 
	    			MsgInfo("Iniciado com sucesso!","Atenção")  	    	    
	    			EnviaEmail()//enviar email
	    			oDlg1:End()
	    	    ENDIF
	    	
	    ElseIF nOpcao == 9 //Finalizar 
	    	
	    		bResp := MsgYesNo("Você confirma a inicialização dessa atividade!","Atenção")      
	    	    IF bResp	          
	    	        MsgRun(OemToAnsi('Gerando o Chamado.... Aguarde....'),'',{|| CursorWait(), cadSSIF() ,CursorArrow()}) 
	    			MsgInfo("Finalizado com sucesso!","Atenção")  	    	    
	    			EnviaEmail()//enviar email
	    			oDlg1:End()
	    	    ENDIF                 
	    ElseIF nOpcao == 10 //Comentar 
	            bResp := MsgYesNo("Você comentou o chamado obrigado!","Atenção")      
	    	    IF bResp	          
	    	        MsgRun(OemToAnsi('Gerando o Chamado.... Aguarde....'),'',{|| CursorWait(), cadSSIF() ,CursorArrow()}) 
	    			MsgInfo("Finalizado com sucesso!","Atenção")  	    	    
	    			EnviaEmail()//enviar email
	    			oDlg1:End()
	    	    ENDIF
	     ElseIF nOpcao == 11 //Excluir 
	            bResp := MsgYesNo("Você confirma a exclusão!","Atenção")      
	    	    IF bResp	          
	    	        MsgRun(OemToAnsi('Excluindo o Chamado.... Aguarde....'),'',{|| CursorWait(), cadSSIF() ,CursorArrow()}) 
   					MsgInfo("A solicitação foi excluida!","Atenção")  	    	       					
   					oDlg1:End()
	    	    ENDIF
	    
	    EndIF       
	             
Return lVal              


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Registro de usuários                                                    ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
                             
static function cadSSIF()
 //Se opcão for 1 cadastra senão altera
 
 IF nOpcao == 1 .Or. nOpcao == 4 
	RecLock("SZH",.T.) 
 Else                  
 	RecLock("SZH",.F.) 
 ENDIF 
			IF nOpcao == 1 .Or. nOpcao == 4
			Replace SZH->ZH_FILIAL   With xFilial()  
		    Replace SZH->ZH_NUMCHAM	 With StrZero(val(GeraSeq("SZH","ZH_NUMCHAM")),8) 
		    Replace SZH->ZH_EMPCHAM	 With "01/01" 
		    Else
		    Replace SZH->ZH_NUMCHAM	 With cDoc		    
		    EndIF		
			//cEmpCham	:= SZH->ZH_EMPCHAM
			Replace SZH->ZH_SOLCHAM  With cMat
			
			Replace SZH->ZH_PRICHAM  With cTipoPri	
			Replace SZH->ZH_DESC	 With cDescCha	
			Replace SZH->ZH_TIPO	 With cTipoSer	
			Replace SZH->ZH_MODULO   With cMosulosD	
			//cDescPri	:= Tabela('ZG',SZH->ZH_PRICHAM)      
			//cProgCham	:= SZH->ZH_PROGRAM
			Replace SZH->ZH_DTABERT  With cDtReg		
			Replace SZH->ZH_HRABERT  With cHrReg		
			Replace SZH->ZH_OCORREN  With cDescGer	
			//mAberOcor	:= SZH->ZH_OCORREN
			Replace SZH->ZH_TECALOC  With cTec		 

		    Replace SZH->ZH_COMENTA  With cComenta	
			Replace SZH->ZH_DTFECHA  With cDtEnc		 
			Replace SZH->ZH_HRFECHA  With cHrEnc
			Replace SZH->ZH_TECNICO  With cTecEnc		
			Replace SZH->ZH_SOLUCAO  With cSolucao	 
			//mSoluOcor	:= SZH->ZH_SOLUCAO
			//cClasFech	:= SZH->ZH_CLASSIF
			Replace SZH->ZH_APROVA   With cAprov
     		
			
			Replace SZH->ZH_DTENTRE  With dDtPrev     
			Replace SZH->ZH_CC       With cCcusto
			
			//Novos campos na tabela ; William Rodrigues           
			
            Replace SZH->ZH_MATACES  With cMatAcss	    
             
            Replace SZH->ZH_CHKINTE  With lCBSite   
            Replace SZH->ZH_CHKSIGA	 With lCBMicros	
            Replace SZH->ZH_CHKPART	 With lCBPartic
            Replace SZH->ZH_CHKCORR	 With lCBCorreio
            Replace SZH->ZH_CHKWIND	 With lCBWind
            Replace SZH->ZH_CHKEMAI	 With lCBEmail
            Replace SZH->ZH_CHKBLOC	 With lCBBloq
            Replace SZH->ZH_CHKREDE	 With lCBRede  
            Replace SZH->ZH_CHKTHIN  With lCBThin
            Replace SZH->ZH_DESCSIT	 With cSitesD 
            Replace SZH->ZH_DESCMOD	 With cMosulosD
            Replace SZH->ZH_HRINIEN	 With nHrIni1
            Replace SZH->ZH_HRFIMEN	 With nHrFim1 
            Replace SZH->ZH_HRINI2 	 With nHrIni2
            Replace SZH->ZH_HRFIM2 	 With nHrFim2
            Replace SZH->ZH_COMFUN 	 With cCometaSol
            
//Status da solicitação
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	1- Cadastro				
	2- Visualizar
	3- Alterar
	4- Copiar
	5- Aprovar
	6- Cancelar
	7- Imprimir
	8- Iniciar
	9- Finalizar
	10- comentar
	11- Encluir

		aCores    	:= {{ "SZH->ZH_STATUS=='0'", 'BR_AZUL' },;     // Aberto
		                { "SZH->ZH_STATUS=='2'", 'ENABLE'},;       // Aprovado
						{ "SZH->ZH_STATUS=='8'", 'BR_PRETO'},;     // Cancelado
						{ "SZH->ZH_STATUS=='9'", 'DISABLE'},;      // Encerrado
						{ "SZH->ZH_STATUS=='1'", 'BR_AMARELO'}} // Em andamento
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
            IF nOpcao == 1 .Or. nOpcao == 4 
            	Replace SZH->ZH_STATUS 	 With "0"
            ElseIF nOpcao == 5
            	Replace SZH->ZH_STATUS 	 With "2"
            	Replace SZH->ZH_DTAPROV  With dDtAprov
            ElseIF nOpcao == 6
            	Replace SZH->ZH_STATUS 	 With "8"
            ElseIF nOpcao == 8
            	Replace SZH->ZH_STATUS 	 With "1"
            ElseIF nOpcao == 9
            	Replace SZH->ZH_STATUS 	 With "9"            	
            EndIF
   MsUnlock() 
   IF nOpcao == 11    
   		ExcluirFun()  
   EndIF	 

return       
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Excluir Solicitação      			                                  ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/


static function ExcluirFun()  
	dbSelectArea("SZH")
	DbSetOrder(6)     
	DbGotop()
 	         
	If DbSeek(xFilial()+cDoc)
	    RecLock("SZH",.F.)
		dbDelete()
		MsunLock()
	EndIF
return

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Validações									                                  ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/       

//Aprovação
Static Function aprovador()
		
	Local lVal:=  ValAprova(cAprov,5) //posição de aprovadores de SSI
	Local EGestor:=.T.
	//cCCSoli 
    Acess:=ZZS->ZZS_ACESSO
    If Acess $ 'N' 
    	EGestor:=.F.
    EndIf 
	IF __cUserId = cAprov .and. ! EGestor //E se não for gestor
   	   	 msgInfo("Sr(a). Aprovador você não pode aprovar sua solicitação!","Atenção")                             
   	   	lVal := .F.
	EndiF
	IF lVal
	     cNomeAp :=AllTrim(Posicione("ZZS",2,cAprov,"ZZS_NUSER"))
	     lVal := .T.
	     Else
	     msgInfo("Aprovador não tem permissão no modulo SSI!","Atenção")    
	EndIF        
	
Return lVal
//Tipo
Static Function tipoSol()
		Local lVal:= .F.
		cDocTp:=	 Tabela('ZF',cTipoSer)
		if(Empty(cDocTp))
			MsgInfo("Codigo do tipo não encontrado!","Atenção")
			Else
			//Liberar acesso a Internet
			IF AllTrim(cTipoSer) = "005" .And. nOpcao <> 4				
					lCBBloq    := .F.
					lCBCorreio := .F.
					lCBEmail   := .F.
					lCBMicros  := .F.
					lCBPartic  := .F.
					lCBRede    := .F.
					
					lCBThin    := .F.
					lCBWind    := .F.
					lCBSite    := .T.
					
					oCBSite    :disable()
					oCBWind    :enable()
					oCBRede    :enable()	
					oCBMicros  :enable()
					
				ELSEIF AllTrim(cTipoSer) = "002".And. nOpcao <> 4
					
					lCBBloq    := .F.
					lCBCorreio := .F.
					lCBEmail   := .F.
					lCBMicros  := .F.
					lCBPartic  := .F.
					lCBRede    := .F.
					
					lCBThin    := .F.
					lCBWind    := .T.
					lCBSite    := .F.
					
					oCBSite    :enable()
					oCBWind    :disable()	
					oCBRede    :enable()
					oCBMicros  :enable()	
				ELSEIF AllTrim(cTipoSer) = "003".And. nOpcao <> 4
					
					lCBBloq    := .F.
					lCBCorreio := .F.
					lCBEmail   := .F.
					lCBMicros  := .F.
					lCBPartic  := .F.
					lCBRede    := .T.
					
					lCBThin    := .F.
					lCBWind    := .F.
					lCBSite    := .F.
					
					oCBSite    :enable()
					oCBWind    :enable()
					oCBRede    :disable()	
					oCBMicros  :enable()
				ELSEIF AllTrim(cTipoSer) = "004".And. nOpcao <> 4
					
					lCBBloq    := .F.
					lCBCorreio := .F.
					lCBEmail   := .F.
					lCBMicros  := .T.
					lCBPartic  := .F.
					lCBRede    := .F.
					
					lCBThin    := .F.
					lCBWind    := .F.
					lCBSite    := .F.
					
					oCBSite    :enable()
					oCBWind    :enable()
					oCBRede    :enable()	
					oCBMicros	:disable()
				Else    
				  IF nOpcao <> 4
					lCBBloq    := .F.
					lCBCorreio := .F.
					lCBEmail   := .F.
					lCBMicros  := .F.
					lCBPartic  := .F.
					lCBRede    := .F.
					
					lCBThin    := .F.
					lCBWind    := .F.
					lCBSite    := .F.
					oCBSite    :enable()
					oCBWind    :enable()
					oCBRede    :enable()	
					oCBMicros	:enable()
				  EndIf	
				ENDIF
			lVal:=.T.
		EndIF
	    
	    //liberar campo descrição	    
	    abilitSite()
	    
	    If lCBMicros	    	
			//oMosulosD:Enable()
			oMosulosD:lreadonly:=.F.
			cMosulosD:=Space(200)
		Else
			//oMosulosD:Disable()
			oMosulosD:lreadonly:=.T.
			cMosulosD:=Space(200)
	    EndIF
Return lVal
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Prioridade 								                                  ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function priSol()
		Local lVal:= .F.
		cDescPri:=	 Tabela('ZG',cTipoPri)
		if(Empty(cDescPri))
			MsgInfo("Codigo do tipo não encontrado!","Atenção")
			Else
			lVal:=.T.
		EndIF	
Return lVal
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Verifica quem e o usuário dono do acesso.                               ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function usuAssSol()
		Local lVal:= .F.
		Local aDados:= {}      
		//recuperando dados do funcionario
		aDados := FunPesq(cMatAcss)	
		
		IF (lCBBloq) .OR.	(lCBCorreio)  .OR. (lCBEmail)  .OR.(lCBMicros)  .OR. (lCBPartic)  .OR. (lCBThin)  .OR. (lCBWind) .OR. (lCBSite)
		    IF Alltrim(cMatAcss) = ''
		   		 MsgInfo("Preencha a matricula do funcionário que irá ter acesso!","Atenção")
		    Else
		        cNomeAce:= aDados[1][3]//nome do funcionario = libnsb.pwr
		        IF Empty(cNomeAce)
		        	MsgInfo("Informe a Matricula correta!","Atenção")
		        Else
		        	 lVal:= .T.
		        ENDIF
		    EndiF
		ELSE               
		
		lVal:= .T.	
			IF !Empty(cMatAcss)			   
			    cNomeAce:= aDados[1][3]
				IF Empty(cNomeAce)
				   cNomeAce:=""     
				   	MsgInfo("Informe a Matricula correta!","Atenção")   
				   	lVal:= .F.	
				ELSE				 
				 cNomeAce:= aDados[1][3]				 			 
			    ENDIF
			ELSE
				cNomeAce:= ""				 			 
			ENDIF
		EndIF	
		
Return lVal
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± CkeckBox do site  						                                  ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function abilitSite()

	/*If lCBSite	    	
			oSitesD :Enable()
			oHrIni  :Enable()
            oHrFim :Enable()
            cSitesD:=Space(200)
            nHrIni1  :=0
            nHrFim1  :=0
            
		Else
			oSitesD :Disable()
			oHrIni  :Disable()
            oHrFim :Disable()
            cSitesD:=Space(200)
            nHrIni1  :=0
            nHrFim1  :=0
	    EndIF
	  */
	  //liberar campo descrição	    
	    If lCBSite	    	
			oSitesD :Enable()
			oHrIni  :Enable()
            oHrFim  :Enable()  
            oHrFim2	:Enable()  
    		oHrIni2	:Enable()  
            cSitesD:=Space(200)
            nHrIni1  :=0
            nHrFim1  :=0
            nHrFim2	 :=0
    		nHrIni2	 :=0
		Else
			oSitesD :Disable()
			oHrIni  :Disable()
            oHrFim  :Disable()
            oHrFim2	:Disable() 
    		oHrIni2	:Disable() 
            
            cSitesD:=Space(200)
            nHrIni1  :=0
            nHrFim1  :=0
            nHrFim2	 :=0
    		nHrIni2	 :=0
	    EndIF  
	
Return 
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± CkeckBox do Microsiga     			                                  ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function abilitMicro()

	If lCBMicros	    	
			//oMosulosD:Enable()
			oMosulosD:lreadonly:=.F.
			cMosulosD:=Space(200)
		Else
			//oMosulosD:Disable()
			oMosulosD:lreadonly:=.T.
			cMosulosD:=Space(200)
	    EndIF
	
Return nil

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Descrição da solicitação 				                                  ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function descVal()
		
	Local lVal:= .T.
	IF Empty(cDescCha)
		MsgInfo("Informe a descrição do serviço!","Atenção")	
		lVal:= .F.      
	EndIF		
	
Return lVal

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Descrição de modulos				                                  ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function descMod()
		
	Local lVal:= .T.
	IF Empty(cMosulosD)
		lVal:= .F.
		MsgInfo("Na aba 'Detalhes da solicitação', Informe os modulos!","Atenção")
	EndIF
		
	
Return lVal

static Function xComenta()
	Local lVal:= .T.
	if Empty(cCometaSol)
		lVal:= .F.
		MsgInfo("Na aba 'Dados da finalização' informe o campo comentários do solicitante, descreva seu comentário!","Atenção")
	EndIF
return lVal

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Descrição dos sites          			                                  ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function descSite()
		
	Local lVal:= .T.
	IF Empty(cSitesD)
		lVal:= .F.
		MsgInfo("Na aba 'Detalhes da solicitação', Informe os sites!","Atenção")
	EndIF
		
	
Return lVal                                          

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Descrição Gearl do Chamadado			                                  ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Static Function descGerval()

	Local lVal:= .T.
	IF Empty(cDescGer)       
 		MsgInfo("Na aba 'Detalhes da solicitação', Informe a descrição geral!","Atenção")	
 		lVal:= .F.
	EndIF     
	
Return(lVal)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Tecnico alocado               		                                  ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Static Function xTecAloc()

	Local lVal:= .T.
	IF Empty(cTec)       
 		MsgInfo("Informe um Tecnico alocado!","Atenção")	
 		lVal:= .F. 
 	Else
 	    cNomeTec:= Tabela('ZU',cTec)  
 	    IF EMPTY(cNomeTec)
 	    	MsgInfo("Tecnico alocado não encontrado! ","Atenção")	
 			lVal:= .F.  	    
 	    ENDIF
	EndIF     
	
Return(lVal)


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Tecnico Encerramento                                                    ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Static Function xTecEnc()

	Local lVal:= .T.
	IF Empty(cTecEnc)       
 		MsgInfo("Informe um Tecnico para o encerramento!","Atenção")	
 		lVal:= .F. 
 	Else
 	    cNomeEnc:= Tabela('ZU',cTecEnc)  
 	    IF EMPTY(cNomeEnc)
 	    	MsgInfo("Tecnico de encerramento não encontrado!","Atenção")	
 			lVal:= .F.  	    
 	    ENDIF
	EndIF     
	
Return(lVal)    

     

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Data prevista                                                           ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Static Function xDtPrev()
	Local lVal:= .T.
	IF Empty(dDtPrev)
 		MsgInfo("Informe a data prevista para entregar a solicitação!","Atenção")	
 		lVal:= .F.  		
	EndIF     	
Return(lVal)        

static function xHrIni1()
	Local lVal:= .T.
    IF 	nHrIni1 > 12    
        MsgInfo("Informe Um horario Menor que 12:00PM !","Atenção")	
    	lVal:= .F.
    EndIF
return(lVal)         

static function xHrFim1()
    Local lVal:= .T.
    IF 	nHrFim1 > 12 .And. nHrFim1 >  nHrIni1  
        MsgInfo("Informe Um horario Menor que 12:00PM e maior de hora inicio! ","Atenção")	
    	lVal:= .F.
    EndIF
return(lVal)        

static function xHrIni2()
	Local lVal:= .T.
    IF 	nHrIni2 <= 11 .And. nHrIni2 < 24  
        MsgInfo("Informe Um horario Maior que ou igual a 12:00PM !","Atenção")	
        lVal:= .F.
    EndIF	
return(lVal)                 

static function xHrFim2()
	Local lVal:= .T.
    IF 	nHrFim2 <= 11 .And. nHrFim2 <  24  .And. nHrFim2 <  nHrIni2  
        MsgInfo("Informe Um horario Maior que ou igual a 12:00PM e maior de hora inicio !","Atenção")	
        lVal:= .F.
    EndIF	
return(lVal) 

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Validação de campos         			                                  ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Static Function xValida()
		
	Local lVal:= .T. 
	IF nOpcao >= 1 .And. nOpcao < 5
	
		IF !aprovador()
			lVal:= .F.
		ElseIF !descVal()
			lVal:= .F.
		ElseIF empty(cDocTp)
			lVal:= .F.
			MsgInfo("Selecione um Tipo de solicitação!","Atenção")
			
		ElseIF empty(cDescPri)
			lVal:= .F.
			MsgInfo("Selecione a prioridade da solicitação!","Atenção")
		ElseIF lCBSite .Or. lCBMicros .Or. lCBBloq .Or. lCBCorreio .Or. lCBEmail .Or. lCBMicros .Or.lCBPartic				
		    IF empty(cNomeAce)
				lVal:= .F.
				MsgInfo("Preencha a matricula do funcionário que irá ter as referências!","Atenção")
			EndiF
		EndiF
		
		IF lCBSite
		    IF !descSite()
		    	lVal:= .F.   
		    ENdIF
		    IF nHrFim1==0 .Or. nHrIni1==0  
		    	IF nHrFim2==0 .Or. nHrIni2==0 
		        MsgInfo("Verifique a hora do inicio e hora fim de acesso aos sites!","Atenção")
		    	lVal:= .F.                
		    	Else
		    		IF !xHrFim2()
		    			lVal:= .F.
		    		ElseIF !xHrIni2()
		    			lVal:= .F.	
		    		EndIF		    	
		    	EndIF
		    Else
		    	IF !xHrFim1()
		    		lVal:= .F.
		    	ElseIF !xHrIni1()
		    		lVal:= .F.	
		    	EndIF		    	
		    
		    EndIF    
		    
		EndIF
		
		IF lCBMicros
		    IF !descMod()
		    	lVal:= .F.
		    ENd
		EndIF   
		
		IF !descGerval()     
			lVal:= .F.			
		EndIF          
		
				
		
	ElseIF nOpcao = 8           
		lVal:= .T.
		IF !xDtPrev() 
			lVal:= .F.
		ElseIF !xTecAloc()
			lVal:= .F.
		ENDIF
		
	EndIF
	
Return (lVal)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	1- Cadastro				
	2- Visualizar
	3- Alterar
	4- Copiar
	5- Aprovar
	6- Cancelar
	7- Imprimir
	8- Iniciar
	9- Finalizar
	10- comentar
	11- Encluir
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Static Function  EnviaEmail()

    Local _cTo		:=""
    Local _dDtEntre := "" 
    Local cStats	:=""
    oProcess := TWFProcess():New( "000001", "SOLICITAR APROVAÇÃO" )
    oProcess :NewTask( "100001", "\WORKFLOW\SSI.HTM" )
    oHTML    := oProcess:oHTML 
      
    cMen := " <html>"
    cMen := " <head>"
    cMen := " <title></title>"
    cMen := " </head>"    
    cMen += " <body>"
    cMen += ' <table border="0" width="800">'
    cMen += ' <tr> SSI Nº : '+ cDoc + " - "+ cDescCha +'</tr>' //cDesCham
    Do Case
       Case( nOpcao == 1 )  

          cMen += ' <tr> Foi aberto por   : '+ cNomeSol + '</tr>'          
          oProcess :cSubject := "SSI - "+ cDoc + " - "+" Foi Aberto o Chamado" 
          _cTo += alltrim(UsrRetMail(cAprov))+";"
                    
	   Case( nOpcao == 4 )        
	   
          cMen += ' <tr> Foi aberto por   : '+ cNomeSol + '</tr>'          	   
          oProcess :cSubject := "SSI - "+ cDoc + " - "+" Foi Aberto o Chamado"
          _cTo += alltrim(UsrRetMail(cAprov))+";"
          
	   Case( nOpcao == 5 )
	      
	      cMen += ' <tr> Foi aprovado por : '+ cNomeAp + '</tr>'
	      oProcess :cSubject := "SSI - "+ cDoc + " - "+" Foi Aprovada"
	      _cTo+="ti@nippon-seikibr.com.br;"
	      
	   Case( nOpcao == 8 )
	         
	         oProcess :cSubject := "SSI - "+ cDoc + " - "+" Foi Iniciada"
	         _cTo+="ti@nippon-seikibr.com.br;"
	         _dDtEntre := Subs(Dtos(dDtPrev),7,2) + "/" + Subs(Dtos(dDtPrev),5,2)+ "/" + Subs(Dtos(dDtPrev),3,2)
	         cMen += ' <tr> Foi iniciado... </tr>'
	         cMen += ' <tr> Técnico Alocado  : '+ cNomeTec + '</tr>'
	         cMen += ' <tr> Data Entrega Prevista : '+ _dDtEntre + '</tr>'
	      
	      IF !Empty(cComenta)
	         cMen += ' <tr> Comentarios Tecnicos  : '+ cComenta  + '</tr>'
	      Endif
	   Case( nOpcao == 9 )          
	      oProcess :cSubject := "SSI - "+ cDoc + " - "+" Foi Encerrada"
	      cMen += ' <tr> Foi Encerrado... </tr>'
	      cMen += ' <tr> Técnico : '+ cNomeEnc + '</tr>' 
	      cMen += ' <tr> Solução : '+ cSolucao + '</tr>' 
	      
	   Case ( nOpcao == 6 )                                          
	      oProcess :cSubject := "SSI - "+ cDoc + " - "+" Foi Cancelada"
	      cMen += ' <tr> Foi Cancelado por : '+ Upper(UsrFullName(__cUserId)) +' </tr>'
   	   EndCase	       
   	
   	cMen += ' <tr> '+ cDescGer + '</tr>' 
	_cTo += alltrim(UsrRetMail(cMat))	
	 
    cMen += ' </table>'          
    
    cMen += " </body>"
    cMen += " </html>" 
    
    oHtml:ValByName( "MENS", cMen)
   // oProcess:ClientName( Subs(cUsuario,7,15) )
    oProcess:cTo  := _cTo
   // oProcess:cCC  := _cCC // Com Copia
 //   oProcess:cBCC := "jmoreira@nippon-seikibr.com.br" // Com Copia Oculta
    //oProcess:ATTACHFILE(cArq) - ANEXA UM ARQUIVO <CAMINHO + NOME DO ARQUIVO>
     //retornar valores      
     cMailId := oProcess:Start() 
Return


