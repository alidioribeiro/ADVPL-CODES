#Include 'protheus.ch'
#Include 'rwmake.ch' 
#Include 'topconn.ch'
#include 'fivewin.ch'
#include 'tbiconn.ch'
#INCLUDE 'font.ch'
#INCLUDE 'colors.ch'         
#include 'fwmvcdef.ch'
#Include 'libnsb.prw'

/*/{Protheus.doc} TICMDA01
//TODO Controle de Chamados TI.
@author Wagner da Gama Corrêa
@since 21/02/2017
@version 1.0
@type function
/*/
User Function TICMDA01()
	Private cCadastro := "Chamados do TI"
	Private _cCCAprov := ""
	Private _aAprov   := {}

	Private _cIDAtual, _xMatAtual, _cCCAtual, _aInfoAtual

	Private aRotina := {;
	{"Pesquisar",   "AxPesqui",       0, 01},;
	{"Visualizar",  "U_CMDA01(01)",   0, 02},;
	{"Incluir",     "U_CMDA01(02)",   0, 03},;
	{"Alterar",     "U_CMDA01(03)",   0, 04},;
	{"Cancelar",    "U_CMDA01(05)",   0, 07},;
	{"Classificar", "U_CMDA01(06)",   0, 08},;
	{"Estimar",     "U_CMDA01(10)",   0, 13},;
	{"Aprovar",     "U_CMDA01(04)",   0, 06},;
	{"Atender",     "U_CMDA01(07)",   0, 09},;
	{"Finalizar",   "U_CMDA01(08)",   0, 10},;
	{"Relatório",   "U_CMDA01(09)",   0, 11},;
	{"Legenda",     "U_CMDA01LEG(1)", 0, 12} }   

	Private aCores := {;
	{ "SZH->ZH_STATUS == '0'", 'BR_VERDE'   },; // Aberto
	{ "SZH->ZH_STATUS == '7'", 'BR_CANCEL'  },; // Cancelado
	{ "SZH->ZH_STATUS == '4'", 'BR_AMARELO' },; // Classificação
	{ "SZH->ZH_STATUS == '3'", 'BR_BRANCO'  },; // Projeto
	{ "SZH->ZH_STATUS == '1'", 'BR_AZUL'    },; // Estimativa
	{ "SZH->ZH_STATUS == '2'", 'BR_LARANJA' },; // Aprovado
	{ "SZH->ZH_STATUS == '6'", 'BR_MARROM'  },; // Projeto Rejeitado
	{ "SZH->ZH_STATUS == '5'", 'BR_PINK'    },; // Resposta
	{ "SZH->ZH_STATUS == '8'", 'BR_CINZA'   },; // Resposta negativa
	{ "SZH->ZH_STATUS == '9'", 'BR_VERMELHO'} } // Encerrado

	_cIDAtual := __cUserID

	_cCond := "ZH_SOLCHAM='" + _cIDAtual + "' "

	//  .------------------------------.
	// |   Tratativa para aprovadores   |
	//  '------------------------------'
	_cQry := "SELECT ZZS_CCUSTO "
	_cQry +=    "FROM " + RetSqlName("ZZS") + " ZZS " 
	_cQry += "WHERE ZZS.D_E_L_E_T_='' AND ZZS_USER='" + _cIDAtual + "' AND LEFT(ZZS_ACESSO,1)='S' "

	dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY( _cQry)), "TMP01", .T., .F. )

	TMP01->(dbGoTop())

	While !TMP01->(Eof())

		_cCond += "OR ZH_CC = " + ZZS_CCUSTO + " "
		_cCCAprov += ZZS_CCUSTO+"/"
		TMP01->(dbSkip())
	End
	
	TMP01->(dbCloseArea())

	//  .----------------------------------.
	// |   Carrega dados do usuário atual   |
	//  '----------------------------------'
	PswOrder(1)
	If PswSeek( _cIDAtual, .T.)
		_aInfoAtual := PswRet(1)
	EndIf	

	_xMatAtual := SubStr( _aInfoAtual[1][22], 5, 6)
	_cCCAtual  := AllTrim( Posicione("SRA", 1, xFilial("SRA") + _xMatAtual, "RA_CC"))

	//  .---------------------------------------------------------.
	// | Centro de Custo do TI pode visualizar todos os chamados   |
	//  '---------------------------------------------------------'
	If _cCCAtual = "126" .or. _xMatAtual = "070069" //Giovany - Aprendiz
		_cCond := ""
	EndIf

	mBrowse(6,1,22,75,'SZH',,,,,,aCores,,,,,,,,_cCond)

Return
//
//  .------------------.
// |   Tela Principal   |
//  '------------------'
//
User Function CMDA01( _nOpcao )

	Private _oDlg, _oFld // Objetos principais
	//  .-----------------------------
	// |   Objetos aba Solicitantes
	//  '-----------------------------
	//
	// Primeiro Grupo - Solicitante
	//
	Private _oGrpSol1
	Private _oSaySol1, _oSaySol2, _oSaySol3, _oSaySol4
	Private _cMat, _cSolic,	_cCC, _cDescCC
	Private _oMat, _oSolic, _oCC, _oDescCC
	//
	// Segundo Grupo - Solicitação
	//
	Private _oGrpSol2
	Private _oSaySol5, _oSaySol6, _oSaySol7, _oSaySol8, _oSaySol9, _oSaySol10  
	Private _cTpSer, _cDescSer, _cOcorren, _cDoc
	Private _oTpSer, _oDescSer, _oOcorren, _oDoc

	//  .------------------------------
	// |   Objetos aba Classificação
	//  '------------------------------
	//
	// Primeiro grupo - Classificação
	//
	Private _oGrpAna1
	Private _oSayAna1, _oSayAna2
	Private _aOpAnali
	Private _cTpAnali, _cAnalise, _cResumo, _cEstima
	Private _oTpAnali, _oAnalise, _oResumo, _oEstima

	//
	// Segundo Grupo - Aprovação
	//
	Private _oGrpAna2
	Private _oSayAna3
	Private _aOpAprov // Opções de aprovação
	Private _cAprov, _cNomeAprov, _cCodAprov // Escolha
	Private _oAprov, _oNomeAprov, _oCodAprov

	//  .------------------------
	// |   Objetos aba Execução
	//  '------------------------
	//
	// Primeiro grupo - Execução
	//
	Private _oGrpExe1
	Private _oSay6
	Private _cExec
	Private _oExec

	//  .------------------------
	// |   Objetos aba Resposta
	//  '------------------------
	//
	// Primeiro grupo - Avaliação
	//
	Private _oGrpRes1
	Private _oSayRes1

	Private _aOpResp
	Private _cTpResp, _oTpResp
	Private _cResp, _oResp

	//
	// Segundo Grupo - Qualidade
	//
	Private _oGrpRes2
	Private _oSayRes1, _oSayRes2, _oSayRes3, _oSayRes4
	Private _aOpNota, _cNota, _oNota

	//  .--------------------.
	// |   Carregando dados   |
	//  '--------------------'

	_cTpAnali := "Suporte"
	_cAprov   := ""
	_cTpResp  := ""
	_cNota    := "3"
			
	If !CarregaDados( _nOpcao)
		Return
	EndIf

	//
	//  .--------------------------------.
	// |   T E L A    P R I N C I P A L   |
	//  '--------------------------------'
	//
	_oDlg := MSDialog():New( 090, 290, 700, 1235, "Chamados de TI", , , .F., , , , , , .T., , , .T. )
	_oDlg:bInit := {|| EnchoiceBar( _oDlg, {|| Confirmacao( _nOpcao)}, {|| _oDlg:end()}, .F., {}) }

	_oFld := TFolder():New( 030, 005, {"Solicitação", "Classificação", "Execução", "Resposta"}, {}, _oDlg, , , , .T., .F., 430, 250, )

	//  .------------------------------.
	// |   Primeira Aba - Solicitação   |
	//  '------------------------------'
	//
	// Primeiro grupo - Solicitante
	//
	_oGrpSol1 := TGroup():New( 005, 005, 055, 420, "Solicitante", _oFld:aDialogs[1], CLR_BLACK, CLR_WHITE, .T., .F. )

	_oSaySol1 := TSay():New( 012, 010, {||"ID:"},                    _oGrpSol1, , , .F., .F., .F., .T., CLR_BLACK, CLR_WHITE, 032, 008)
	_oSaySol2 := TSay():New( 012, 065, {||"Nome:"},                  _oGrpSol1, , , .F., .F., .F., .T., CLR_BLACK, CLR_WHITE, 032, 008)
	_oSaySol3 := TSay():New( 032, 010, {||"C. Custo:"},              _oGrpSol1, , , .F., .F., .F., .T., CLR_BLACK, CLR_WHITE, 032, 008)
	_oSaySol4 := TSay():New( 032, 065, {||"Descrição do C. Custo:"}, _oGrpSol1, , , .F., .F., .F., .T., CLR_BLACK, CLR_WHITE, 080, 008)

	_oMat     := TGet():New( 020, 010, { |u| If( PCount()>0, _cMat   :=u, _cMat    )}, _oGrpSol1, 050, 008,'', , CLR_BLACK, CLR_WHITE, , , , .T., "", , , .F., .F., , .F., .F., "", "_cMat", ,)
	_oSolic   := TGet():New( 020, 065, { |u| If( PCount()>0, _cSolic :=u, _cSolic  )}, _oGrpSol1, 345, 008,'', , CLR_BLACK, CLR_WHITE, , , , .T., "", , , .F., .F., , .F., .F., "", "_cSolic", ,)
	_oCC      := TGet():New( 040, 010, { |u| If( PCount()>0, _cCC    :=u, _cCC     )}, _oGrpSol1, 050, 008,'', , CLR_BLACK, CLR_WHITE, , , , .T., "", , , .F., .F., , .F., .F., "", "_cCC", ,)
	_oDescCC  := TGet():New( 040, 065, { |u| If( PCount()>0, _cDescCC:=u, _cDescCC )}, _oGrpSol1, 105, 008,'', , CLR_BLACK, CLR_WHITE, , , , .T., "", , , .F., .F., , .F., .F., "", "_cDescCC", ,)

	_oMat:Disable()
	_osolic:Disable()
	_oCc:Disable()
	_oDescCc:Disable()

	//
	// Segundo Grupo - Solicitação
	//
	_oGrpSol2  := TGroup():New( 060, 005, 230, 420, "Solicitação", _oFld:aDialogs[1], CLR_BLACK, CLR_WHITE, .T., .F. )

	_oSaySol5  := TSay():New( 075, 010, {|| "Tipo:"},           _oGrpSol2, , , .F., .F., .F., .T., CLR_BLACK, CLR_WHITE, 025, 008)

	_oSaySol10 := TSay():New( 075, 150, {|| "Chamado:"},        _oGrpSol2, , , .F., .F., .F., .T., CLR_BLACK, CLR_WHITE, 040, 008)
	_oSaySol10 := TSay():New( 075, 180, {|| _cDoc},             _oGrpSol2, , , .F., .F., .F., .T., CLR_HBLUE, CLR_WHITE, 042, 008)

	_oSaySol6  := TSay():New( 075, 250, {|| "Abertura:"},       _oGrpSol2, , , .F., .F., .F., .T., CLR_BLACK, CLR_WHITE, 035, 008)
	_oSaySol7  := TSay():New( 075, 280, {|| DtoC( dDataBase)},  _oGrpSol2, , , .F., .F., .F., .T., CLR_GREEN, CLR_WHITE, 035, 008)

	_oSaySol8  := TSay():New( 075, 345, {|| "Hora:"},           _oGrpSol2, , , .F., .F., .F., .T., CLR_BLACK, CLR_WHITE, 025, 008)
	_oSaySol9  := TSay():New( 075, 365, {|| Time()},            _oGrpSol2, , , .F., .F., .F., .T., CLR_GREEN, CLR_WHITE, 025, 008)

	_oTpSer    := TGet():New( 075, 035, { |u| If( PCount() > 0, _cTpSer   := u, _cTpSer   )}, _oGrpSol2, 040, 008, '999', {|| TipoServico() }, CLR_BLACK, CLR_WHITE, , , , .T., "", , ,         .F., .F., , .F., .F., "ZF", "_cTpSer"  , ,)
	_oDescSer  := TGet():New( 075, 080, { |u| If( PCount() > 0, _cDescSer := u, _cDescSer )}, _oGrpSol2, 060, 008, '@!' , ,                    CLR_BLACK, CLR_WHITE, , , , .T., "", , {|| .F.}, .F., .F., , .F., .F., ,     "_cDescSer", ,)

	_oOcorren  := TMultiGet():New( 090, 010, {|u| If( PCount() > 0, _cOcorren := u, _cOcorren)}, _oGrpSol2, 400, 130, , , CLR_BLACK, CLR_WHITE, , .T., "", , , .F., .F., .F., , , .F., , )

	//  .-------------------------------.
	// |   Segunda Aba - Classificação   |
	//  '-------------------------------'
	//  .-----------------------------------
	// |   Primeiro grupo - Classificação
	//  '-----------------------------------
	_oGrpAna1 := TGroup():New( 005, 005, 160, 420, "Classificação", _oFld:aDialogs[2], CLR_BLACK, CLR_WHITE, .T., .F. )

	_oSayAna1 := TSay():New( 015, 010, {||"Resumo:"}, _oGrpAna1, , , .F., .F., .F., .T., CLR_BLACK, CLR_WHITE, 042, 008)
	_oResumo  := TGet():New( 015, 065, { |u| If( PCount()>0, _cResumo :=u, _cResumo)}, _oGrpAna1, 228, 008,'', , CLR_BLACK, CLR_WHITE, , , , .T., "", , , .F., .F., , .F., .F., "", "_cResumo", ,)

	_oSayAna1 := TSay():New( 035, 010, {||"Tipo:"},   _oGrpAna1, , , .F., .F., .F., .T., CLR_BLACK, CLR_WHITE, 022, 008)

	_aOpAnali := { "Suporte", "Projeto"}
	_cTpAnali := "Suporte"

	_oTpAnali := TComboBox():New( 035, 065, {|u| If( PCount()>0, _cTpAnali := u, _cTpAnali)}, _aOpAnali, 100, 020, _oGrpAna1 , , , {|| Classifica()}, , , .T., , , , , , , , , '_cTpAnali')
	_oAnalise := TMultiGet():New( 050, 010, {|u| If( PCount()>0, _cAnalise := u, _cAnalise)}, _oGrpAna1, 400, 035, , , CLR_BLACK, CLR_WHITE, , .T., "", , , .F., .F., .F., , , .F., , )

	_oSayAna2 := TSay():New( 090, 010, {||"Estimativa:"}, _oGrpAna1, , , .F., .F., .F., .T., CLR_BLACK, CLR_WHITE, 042, 008)	
	_oEstima  := TMultiGet():New( 100, 010, {|u| If( PCount()>0, _cEstima  := u, _cEstima )}, _oGrpAna1, 400, 55, , , CLR_BLACK, CLR_WHITE, , .T., "", , , .F., .F., .F., , , .F., , )
	//  .------------------------------
	// |   Segundo grupo - Aprovação
	//  '------------------------------
	_oGrpAna2 := TGroup():New( 170, 005, 230, 420, "Aprovação", _oFld:aDialogs[2], CLR_BLACK, CLR_WHITE, .T., .F. )

	_oSayAna3   := TSay():New( 185, 010, { || "Aprovador:"}, _oGrpAna2, , , .F., .F., .F., .T., CLR_BLACK, CLR_WHITE, 032, 008)
	_oCodAprov  := TGet():New( 185, 050, { |u| If( PCount()>0, _cCodAprov  :=u, _cCodAprov )}, _oGrpAna2, 038, 008,'', , CLR_BLACK, CLR_WHITE, , , , .T., "", , , .F., .F., , .F., .F., "ZZS", "_cCodAprov",  ,)
	_oNomeAprov := TGet():New( 185, 100, { |u| If( PCount()>0, _cNomeAprov :=u, _cNomeAprov)}, _oGrpAna2, 228, 008,'', , CLR_BLACK, CLR_WHITE, , , , .T., "", , , .F., .F., , .F., .F., "", "_cNomeAprov", ,)

	_aOpAprov := { "Sim", "Não"}
	_oAprov   := TComboBox():New( 205, 010, {|u| If( PCount()>0, _cAprov := u, _cAprov)}, _aOpAprov, 100, 20, _oGrpAna2 , , , , , , .T., , , , , , , , , '_cAprov')

	//  .-------------------------.
	// |   Terceira Aba - Execução |
	//  '-------------------------'
	//
	// Primeiro grupo - Execução
	//

	_oGrpExe1 := TGroup():New( 005, 005, 225, 420, "Execução", _oFld:aDialogs[3], CLR_BLACK, CLR_WHITE, .T., .F. )

	_oSay6    := TSay():New( 015, 010, {||"Procedimento:"}, _oGrpExe1, , , .F., .F., .F., .T., CLR_BLACK, CLR_WHITE, 042, 008)

	_oExec := TMultiGet():New( 030, 010, {|u| If( PCount() > 0, _cExec := u, _cExec)}, _oGrpExe1, 400, 180, , , CLR_BLACK, CLR_WHITE, , .T., "", , , .F., .F., .F., , , .F., , )

	//  .-------------------------.
	// |   Quarta Aba - Resposta   |
	//  '-------------------------'
	//
	// Primeiro grupo - Resposta
	//
	_oGrpRes1 := TGroup():New( 005, 005, 160, 420, "Avaliação", _oFld:aDialogs[4], CLR_BLACK, CLR_WHITE, .T., .F. )

	_oSayRes1 := TSay():New( 015, 010, {||"Atendida:"}, _oGrpRes1, , , .F., .F., .F., .T., CLR_BLACK, CLR_WHITE, 032, 008)

	_aOpResp  := { "Sim", "Não"}

	_oTpResp  := TComboBox():New( 015, 040, {|u| If( PCount()>0, _cTpResp := u, _cTpResp)}, _aOpResp, 100, 20, _oGrpRes1 , , , {|| Resposta()}, , , .T., , , , , , , , , '_cTpResp')
	_oResp    := TMultiGet():New( 030, 010, {|u| If( PCount() > 0, _cResp := u, _cResp)}, _oGrpRes1, 400, 125, , , CLR_BLACK, CLR_WHITE, , .T., "", , , .F., .F., .F., , , .F., , )


	//
	// Segundo Grupo - Qualidade
	//
	_oGrpRes2 := TGroup():New( 170, 005, 230, 420, "Grau de Satisfação", _oFld:aDialogs[4], CLR_BLACK, CLR_WHITE, .T., .F. )

	_oSayRes1 := TSay():New( 185, 150, {||"1 - Não satisfeito"},          _oGrpRes2, , , .F., .F., .F., .T., CLR_HRED,  CLR_WHITE, 070, 008)
	_oSayRes2 := TSay():New( 195, 150, {||"2 - Parcialmente satisfeito"}, _oGrpRes2, , , .F., .F., .F., .T., CLR_RED,   CLR_WHITE, 070, 008)
	_oSayRes3 := TSay():New( 205, 150, {||"3 - Satisfeito"},              _oGrpRes2, , , .F., .F., .F., .T., CLR_BLUE,  CLR_WHITE, 070, 008)
	_oSayRes4 := TSay():New( 215, 150, {||"4 - Muito satisfeito"},        _oGrpRes2, , , .F., .F., .F., .T., CLR_GREEN, CLR_WHITE, 070, 008)

	_aOpNota  := { "1", "2", "3", "4"}
	_oNota    := TComboBox():New( 185, 010, {|u| If( PCount()>0, _cNota := u, _cNota)}, _aOpNota, 100, 20, _oGrpRes2 , , , , , , .T., , , , , , , , , '_cNota')

	// Desabilita abas e edições por status

	DesabilitaDados(_nOpcao)

	_oDlg:Activate(,,,.T.)

Return
//
//
//
User Function CMDA01Leg()

	Local	aLegenda  := {;
	{'BR_VERDE',    'Aberto'           },;
	{'BR_CANCEL',   'Cancelado'        },;
	{'BR_AMARELO',  'Classificado'     },;
	{'BR_AZUL',     'Estimativa'       },;
	{'BR_BRANCO',   'Projeto'          },;
	{'BR_LARANJA',  'Aprovado'         },;
	{'BR_MARROM',   'Projeto Rejeitado'},;
	{'BR_PINK',     'Resposta'         },;
	{'BR_CINZA',    'Resposta Negativa'},;
	{'BR_VERMELHO', 'Encerrado'        } }

	BrwLegenda(cCadastro,'Legenda',aLegenda)

Return
//  .-------------------.
// |   Tipo de Serviço   |
//  '-------------------'
Static Function TipoServico

	Local _lRet := .F.

	_cDescSer := Tabela('ZF', _cTpSer)
	If Empty( _cDescSer)
		MsgInfo("Codigo do tipo não encontrado!","Atenção")
		Return _lRet
	EndIf

	_lRet := .T.

Return _lRet
//  .----------------------------.
// |   Classificação do Serviço   |
//  '----------------------------'
Static Function Classifica()

	Local _lRet := .F.

	_cAnalise := ""
	If _cTpAnali = "Suporte"
		_oAnalise:Disable()
	Else
		_oAnalise:Enable()
	EndIf

	_lRet := .T.

Return _lRet
//  .------------.
// |   Resposta   |
//  '------------'
Static Function Resposta()

	Local _lRet := .F.

	_cResp := ""
	If _cTpResp = "Sim"
		_oResp:Disable()
		_oNota:Enable()
	Else
		_oResp:Enable()
		_oNota:Disable()
	EndIf

	_lRet := .T.

Return _lRet

//
//  .-------------------------------.
// |   Função de gravação de dados   |
//  '-------------------------------'
//
Static function Confirmacao( _nOpc)

	Local _lRet := .F.
	Local _lResp:= .F.
	Local _aMsg := {}

	If _nOpc = 1 //Visualizar
		_oDlg:End()
		Return
	EndIf

	_lRet := ValidaTela(_nOpc)

	If !_lRet
		Return _lRet
	EndIf

	aAdd( _aMsg, { 02, "Confirma inclusão?",      "Atenção", "Gerando o chamado... Aguarde",                 "Chamado aberto com sucesso."      })
	aAdd( _aMsg, { 03, "Confirma alteração?",     "Atenção", "Alterando o chamado... Aguarde",               "Chamado alterado com sucesso."    })
	aAdd( _aMsg, { 04, "Confirma aprovação?",     "Atenção", "Aprovando o chamado... Aguarde",               "Chamado aprovado com sucesso."    })
	aAdd( _aMsg, { 05, "Confirma cancelamento?",  "Atenção", "Cancelando o chamado... Aguarde",              "Chamado cancelado com sucesso."   })
	aAdd( _aMsg, { 06, "Confirma classificação?", "Atenção", "Enviando classificação do chamado... Aguarde", "Chamado classificado com sucesso."})
	aAdd( _aMsg, { 07, "Confirma atendimento?",   "Atenção", "Enviando atendimento do chamado... Aguarde",   "Chamado atendido com sucesso."    })
	aAdd( _aMsg, { 08, "Confirma finalização?",   "Atenção", "Finalizando o chamado... Aguarde",             "Chamado finalizado com sucesso."      })
	aAdd( _aMsg, { })
	aAdd( _aMsg, { 10, "Confirma estimativa?",    "Atenção", "Enviando estimativa do chamado... Aguarde",    "Chamado estimado com sucesso."      })

	_lResp := MsgYesNo( _aMsg[ _nOpc - 1, 2], _aMsg[ _nOpc - 1, 3])

	If _lResp
		MsgRun( OemToAnsi( _aMsg[ _nOpc - 1, 4]), '', {|| CursorWait(), Gravadados( _nOpc) ,CursorArrow()})
		MsgInfo( _aMsg[ _nOpc - 1, 5], _aMsg[ _nOpc - 1, 3])
		EnviaEmail( _nOpc)
		_oDlg:End()
	EndIf

Return _lRet
//
//  .-------------------------.
// |   Valida campos da tela   |
//  '-------------------------'
//
Static Function ValidaTela( _nOpc)

	Local _lRet := .T.

	If _nOpc = 2 .or. _nOpc = 3 // Inclusão ou Alteração

		If Empty( _cOcorren)
			MsgInfo("Conteúdo da ocorrência não pode ser vazio. ", "Atenção")
			_lRet := .F.
		EndIf
	EndIf 

Return _lRet
//
//  .--------------------------------------.
// |   Carrega dados do arquivo para tela   |
//  '--------------------------------------'
//
Static Function CarregaDados( _nOpc)

	_cMat     := Space(06)
	_cSolic   := Space(50)
	_cCC      := Space(09)
	_cDescCC  := Space(60)

	_cTpSer   := Space(03)
	_cDescSer := Space(50)

	//  .---------------------------------.
	// |   Carrega dados da primeira aba   |
	//  '---------------------------------'

	If _nOpc = 2 // Inclusão

		//  .-----------------------.
		// |   Inclusão de chamado   |
		//  '-----------------------'

		_cDoc   := StrZero( Val( GeraSeq( "SZH", "ZH_NUMCHAM")), 8)
		_tmpMat := __cUserID
		_tmpTpSer := Space(3)
	Else
		If SZH->ZH_STATUS = "9" .and. _nOpc <> 1 // Diferente de Visualização 
			MsgInfo("Chamado já encerrado. Só pode ser visualizado.")
		EndIf

		//  .----------------------------------------------------------------
		// |   Qualquer outra opção carrega todos os dados da primeira aba   
		//  '----------------------------------------------------------------

		If _nOpc = 3 .and. SZH->ZH_STATUS <> '0' // alteração
			MsgInfo("Chamado não pode ser alterado, pois já passou pelo processo de classificação.")
			Return .F.
		EndIf


		_cDoc     := SZH->ZH_NUMCHAM
		_tmpMat   := SZH->ZH_SOLCHAM
		_cOcorren := SZH->ZH_OCORREN

		_tmpTpSer := SZH->ZH_TIPO

	EndIf

	_cMat    := _tmpMat
	_cSolic  := xUsrDados( _tmpMat, 4)

	_aInfoUser := {}
	PswOrder(1)
	If PswSeek( _tmpMat, .T.)
		_aInfoUser := PswRet(1)
	EndIf	

	_xMat     := SubStr( _aInfoUser[1][22], 5, 6)

	_cCC      := AllTrim( Posicione("SRA", 1, xFilial("SRA") + _xMat, "RA_CC"))
	_cDescCC  := AllTrim( Posicione("CTT", 1, xFilial("CTT") + _cCC,  "CTT_DESC01"))

	_cTpSer   := _tmpTpSer
	_cDescSer := Posicione("SX5", 1, xFilial("SX5") + "ZF" + _tmpTpSer, "X5_DESCRI")
	
	//  .---------------------------------------------.
	// |   Validações de tela do próprio solicitante   |
	//  '---------------------------------------------'

	If _nOpc = 3 .or. _nOpc = 5 .or. _nOpc = 8 // Alterar, Cancelar ou Finalizar só pode ser realizado pelo solicitante

		If _nOpc = 8 .and. SZH->ZH_STATUS <> '5'
			MsgInfo("Você não pode finalizar um chamado que ainda não foi atendido.", "Atenção")
			Return .F.
		EndIf
		
		If _nOpc = 5 .and. SZH->ZH_STATUS = '9'
			MsgInfo("Você não pode finalizar um chamado que já foi encerrado.", "Atenção")
			Return .F.
		EndIf


		_cTexto := ""
		If _nOpc = 3
			_cTexto := "alterar"
		ElseIf _nOpc = 5
			_cTexto := "cancelar"
		Else 
			_cTexto := "finalizar"
		EndIf

		If __cUserId <> SZH->ZH_SOLCHAM
			MsgInfo("Você não tem permissão para " + _cTexto + " uma solicitação feita por outro usuário.", "Atenção")
			Return .F.
		EndIf
		
	EndIf
	
	//  .----------------------------------.
	// |   Validações de tela para o T.I.   |
	//  '----------------------------------'
	
	If _nOpc = 6 .or. _nOpc = 7 .or. _nOpc = 10 // Classificar, Atender e Estimar
		
		_cTexto := ""
		If _nOpc = 6
			_cTexto := "classificar"
		ElseIf _nOpc = 7
			_cTexto := "atender"
		Else
			_cTexto := "estimar"
		EndIf

		If AllTrim(_cCCAtual) <> "126" .and. _xMatAtual <> "070069" // Somente CC do TI pode classificar, atender, estimar
			MsgInfo("Você não tem permissão para " + _cTexto + " chamados.", "Atenção")
			Return .F.
		EndIf

		If _nOpc = 6 .and. SZH->ZH_STATUS <> '0' // Só se pode classificar chamados com status de "Aberto"
			MsgInfo("O chamado não pode mais ser classificado devido o seu status atual. Verificar legenda.", "Atenção")
			Return .F.
		EndIf
		
		
		If _nOpc = 7 .and. SZH->ZH_STATUS <> '4' .and. SZH->ZH_STATUS <> '3' // Só se poder atender chamados de suporte ou com o status de projeto
			MsgInfo("O chamado não pode ser atendido devido o seu status atual. Verificar legenda.", "Atenção")
			Return .F.
		EndIf
		
		If _nOpc = 10 .and. SZH->ZH_STATUS <> '1'
			MsgInfo("O chamado não pode ser estimado devido o seu status atual. Verificar legenda.", "Atenção")
			Return .F.
		EndIf 
		
		If _nOpc = 10
			//  .--------------------------------------.
			// |   Aprovadores do usuário solicitante   |
			//  '--------------------------------------'
			_cQry := "SELECT ZZS_USER "
			_cQry +=    "FROM " + RetSqlName("ZZS") + " ZZS " 
			_cQry += "WHERE ZZS.D_E_L_E_T_='' AND ZZS_CCUSTO='" + _cCC + "' AND LEFT(ZZS_ACESSO,1)='S' "

			dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY( _cQry)), "TMP01", .T., .F. )

			TMP01->(dbGoTop())

			While !TMP01->(Eof())

				aAdd( _aAprov, TMP01->ZZS_USER)
				TMP01->(dbSkip())
			End
			
			TMP01->(dbCloseArea())

		EndIf

	EndIf

	//  .--------------------------------------.
	// |   Validação de tela para aprovadores   |
	//  '--------------------------------------'
	
	If _nOpc = 4 // Aprovar
		If Empty(_cCCAprov)
			MsgInfo("Você não tem permissão para aprovar chamados de solicitantes desse centro de custo.", "Atenção")
			Return .F.
		EndIf
		
		If SZH->ZH_STATUS <> '3'
			MsgInfo("Você ainda não pode aprovar essa solicitação, pois ainda não foi classificada e estimada pelo setor de TI")
			Return .F.
		EndIf

		_cCodAprov  := __cUserID
		_cNomeAprov := AllTrim( xUsrDados( __cUserID, 4) )
	EndIf
    
 
	If _nOpc <> 2 // Se não for inclusão
       //  .--------------------------------.
	   // |   Carrega dados da segunda aba   |
	   //  '--------------------------------'
    
	   _cTpAnali := IIF(SZH->ZH_PRICHAM="Supo", "Suporte", "Projeto")
	
	
	   _cResumo  := SZH->ZH_DESC
	   _cAnalise := SZH->ZH_COMENTA
	   _cEstima  := SZH->ZH_DESCMOD

	   //  .---------------------------------.
	   // |   Carrega dados da terceira aba   |
	   //  '---------------------------------'

	   _cExec := SZH->ZH_SOLUCAO

	   //  .-------------------------------.
	   // |   Carrega dados da quarta aba   |
	   //  '-------------------------------'

	   _cResp := SZH->ZH_COMFUN
	   _cNota := SZH->ZH_CLASSIF
    
	EndIf
Return .T.
//
//  .-------------------------------------------------------------------------------------.
// |  Desabilita dados da tela e só habilita os campos que podem ser editados, por opção   |
//  '-------------------------------------------------------------------------------------'
//
Static Function DesabilitaDados( _nOpc)

	//  .-----------------------------
	// |   Objetos aba Solicitantes
	//  '-----------------------------
	//
	// Primeiro Grupo - Solicitante
	//
	_oGrpSol1:Disable()		
	_oSaySol1:Disable()
	_oSaySol2:Disable()
	_oSaySol3:Disable()
	_oSaySol4:Disable()

	_oMat:Disable()
	_oSolic:Disable()
	_oCC:Disable()
	_oDescCC:Disable()
	//
	// Segundo Grupo - Solicitação
	//
	_oGrpSol2:Disable()
	_oSaySol5:Disable()
	_oSaySol6:Disable()
	_oSaySol7:Disable()
	_oSaySol8:Disable()
	_oSaySol9:Disable()
	_oSaySol10:Disable()

	_oTpSer:Disable()
	_oDescSer:Disable()
	_oOcorren:Disable()
	//_oDoc:Disable()

	//  .------------------------------
	// |   Objetos aba Classificação
	//  '------------------------------
	//
	// Primeiro grupo - Classificação
	//
	_oGrpAna1:Disable()
	_oSayAna1:Disable()
	_oSayAna2:Disable()
	_oResumo:Disable()

	_oTpAnali:Disable()
	_oAnalise:Disable()
	_oEstima:Disable()
	//
	// Segundo grupo - Aprovação
	//
	_oGrpAna2:Disable()
	_oSayAna3:Disable()
	_oCodAprov:Disable()
	_oAprov:Disable()
	_oNomeAprov:Disable()

	//  .------------------------
	// |   Objetos aba Execução
	//  '------------------------
	//
	// Primeiro grupo - Execução
	//
	_oGrpExe1:Disable()
	_oSay6:Disable()
	_oExec:Disable()

	//  .------------------------
	// |   Objetos aba Resposta
	//  '------------------------
	//
	// Primeiro grupo - Execução
	//
	_oGrpRes1:Disable()
	_oSayRes1:Disable()

	_oTpResp:Disable()
	_oResp:Disable()

	//
	// Segundo Grupo - Qualidade
	//
	_oGrpRes2:Disable()
	_oSayRes1:Disable()
	_oSayRes2:Disable()
	_oSayRes3:Disable()
	_oSayRes4:Disable()
	_oNota:Disable()

	Do Case
		Case _nOpc = 2 .or. _nOpc = 3 .or. _nOpc = 5 // Inclusão / Alteração / Cancelamento
		If _nOpc = 2 .or. _nOpc = 3
			_oTpSer:Enable()
			_oOcorren:Enable()
		EndIf

		_oFld:HidePage(2) := .F.
		_oFld:HidePage(3) := .F.
		_oFld:HidePage(4) := .F.

		Case _nOpc = 4 .or. _nOpc = 6 .or. _nOpc = 10 // Aprovação / Classificação / Estimativa

		If _nOpc = 4 // Aprovar

			_oGrpAna2:Enable()
			_oSayAna2:Enable()
			_oAprov:Enable()
			_oNomeAprov:Disable()

		ElseIf _nOpc = 6 // Classificar

			_oGrpAna1:Enable()
			_oSayAna1:Enable()
			_oResumo:Enable()
			_oTpAnali:Enable()
			_oTpSer:Enable()

		Else // Estimar

			_oGrpAna1:Enable()
			_oSayAna1:Enable()
			_oEstima:Enable()

		EndIf

		_oFld:HidePage(3) := .F.
		_oFld:HidePage(4) := .F.

		Case _nOpc = 7 // Atender

		_oFld:HidePage(4) := .F.
		_oGrpExe1:Enable()
		_oSay6:Enable()
		_oExec:Enable()

		Case _nOpc = 8 // Finalizar

		_oGrpRes1:Enable()
		_oSayRes1:Enable()

		_oTpResp:Enable()
		_oResp:Disable()

		_oGrpRes2:Enable()
		_oSayRes1:Enable()
		_oSayRes2:Enable()
		_oSayRes3:Enable()
		_oSayRes4:Enable()
		_oNota:Enable()

	EndCase

Return
//
//
//
Static Function GravaDados( _nOpcao)

	If _nOpcao == 2 // Inclusão
		RecLock("SZH", .T.)
		SZH->ZH_FILIAL  := xFilial("SZH")  
		SZH->ZH_NUMCHAM := StrZero( Val( GeraSeq("SZH","ZH_NUMCHAM")), 8) 
		SZH->ZH_DTABERT := dDataBase
		SZH->ZH_HRABERT := Time()
		SZH->ZH_SOLCHAM := _cMat
		SZH->ZH_TIPO    := _cTpSer
		SZH->ZH_CC      := _cCC
	Else // Alteração                  
		RecLock("SZH", .F.) 
	EndIf

	If _nOpcao == 6 // Classificação
		SZH->ZH_TECNICO := __cUserID
		SZH->ZH_DESC    := _cResumo
		SZH->ZH_PRICHAM := _cTpAnali
		SZH->ZH_COMENTA := _cAnalise
	EndIf

	If _nOpcao = 10 // Estimativa
		SZH->ZH_DESCMOD := _cEstima
	EndIf

	If _nOpcao == 7 // Atendimento
		SZH->ZH_SOLUCAO := _cExec
	EndIf

	_cStatus := ""
	Do Case
		Case _nOpcao = 2 .or. _nOpcao = 3 // Inclusão ou alteração 
		_cStatus := "0" // Aberto
	    SZH->ZH_OCORREN := _cOcorren

		Case _nOpcao = 4 // Aprovação

		_cStatus := "2" // 2 - Aprovado / 6 - Rejeitado
		If _cAprov = "Sim"
			SZH->ZH_DTAPROV := dDataBase
			SZH->ZH_APROVA  := _cCodAprov
			_cStatus := "2"
		Else
			_cStatus := "6"
		EndIf

		Case _nOpcao = 5 // Cancelar
		_cStatus := "7" // Cancelado

		Case _nOpcao = 6 // Classificação

		If _cTpAnali = "Suporte"
			_cStatus := "4" // Suporte
		Else
			_cStatus := "1" // Estimativa
		EndIf

		Case _nOpcao = 7 // Atender
		_cStatus := "5"
		SZH->ZH_DTENTRE := dDataBase

		Case _nOpcao = 8 // Finalizar
		If _cTpResp = "Sim"
			_cStatus := "9"
			
			SZH->ZH_DTFECHA := dDataBase		 
			SZH->ZH_HRFECHA := Time()
			SZH->ZH_CLASSIF := _cNota 

		Else
			_cStatus := "8"
			SZH->ZH_COMFUN  := _cResp
		EndIf

		Case _nOpcao = 8 // Estimar
		_cStatus := "3"
	EndCase

	SZH->ZH_STATUS  := _cStatus
	MsUnlock() 

Return
//
//  .--------------------------------------------------------------.
// |   Envia email com os dados da fase que se encontra o Chamado   |
//  '--------------------------------------------------------------'
//
Static Function EnviaEmail( _nOpc)

	Local _cTo := ""

	oProcess := TWFProcess():New( "000001", "CHAMADO TI" )
	oProcess :NewTask( "100001", "\WORKFLOW\CHAMADOTI.HTM" )
	oHTML    := oProcess:oHTML 

	cMen := " <html>"
	cMen := " <head>"
	cMen := " <title></title>"
	cMen := " </head>"    
	cMen += " <body>"
	cMen += ' <table border="0" width="800">'
	cMen += ' <tr> CHAMADO Nº: '+ _cDoc + ' </tr>' // Número do Chamado
	cMen += ' <tr> </tr>'

	Do Case
		//  .-----------------------.
		// |   Inclusão do Chamado   |
		//  '-----------------------'
		Case( _nOpc = 2 )

		oProcess :cSubject := "Chamado - " + _cDoc + " - Aberto pelo(a) sr(a) " + _cSolic 
		cMen += ' <tr> Solicitante: '+ _cSolic   + '</tr>'
		cMen += ' <tr> Ocorrência: '+ _cOcorren + '</tr>'
		_cTo += "ti@nippon-seikibr.com.br;"

		//  .------------------------.
		// |   Alteração do Chamado   |
		//  '------------------------'
		Case( _nOpc = 3 )   

		oProcess :cSubject := "Chamado - " + _cDoc + " - Alterado pelo(a) sr(a) " + _cSolic
		cMen += ' <tr> Alterado por: ' + _cSolic   + '</tr>'
		cMen += ' <tr> Ocorrência: '   + _cOcorren + '</tr>'
		_cTo += "ti@nippon-seikibr.com.br;"

		//  .----------------------------------.
		// |   Aprovação do Chamado (Projeto)   |
		//  '----------------------------------'
		Case( _nOpc = 4 )   

		_cTipoResp := IIF( _cAprov = "Sim", "Aprovado", "Rejeitado")
		oProcess :cSubject := "Chamado - " + _cDoc + " - " + _cTipoResp + " pelo(a) sr(a) " + _cNomeAprov

		cMen += ' <tr> </tr>'
		cMen += ' <tr> ' + _cTipoResp + ' por: ' + _cNomeAprov + '</tr>'
		cMen += ' <tr> </tr>'
		cMen += ' <tr> Resumo do chamado: ' + _cResumo + '</tr>'
		cMen += ' <tr> Descrição do Projeto / Melhoria: ' + _cAnalise+ '</tr>'
		cMen += ' <tr> </tr>'
		cMen += ' <tr> Estimativa: '+ _cEstima + '</tr>'

		_cTo += AllTrim( UsrRetMail( _cMat)     ) + ";" // Email do Solicitante
		_cTo += AllTrim( UsrRetMail( __cUserID) ) + ";" // Email do Aprovador
		_cTo += "ti@nippon-seikibr.com.br;"

		//  .---------------------------.
		// |   Cancelamento do chamado   |
		//  '---------------------------'
		Case( _nOpc = 5 )

		oProcess :cSubject := "Chamado - " + _cDoc + " - Cancelado pelo(a) sr(a) " + _cSolic
		
		cMen += ' <tr> </tr>'
		cMen += ' <tr> Cancelado por: ' + _cSolic + '</tr>'
		cMen += ' <tr> Ocorrência: '+ _cOcorren + '</tr>'
		_cTo += "ti@nippon-seikibr.com.br;"

		//  .----------------------------.
		// |   Classificação do chamado   |
		//  '----------------------------'
		Case( _nOpc = 6 )

		oProcess :cSubject := "Chamado - " + _cDoc + " - Classificação"
		cMen += ' <tr> Classificado por: ' + AllTrim( xUsrDados( __cUserID, 4) ) + '</tr>'
		cMen += ' <tr> Tipo de chamado: '  + _cTpAnali + '</tr>'
		cMen += ' <tr> </tr>'
		cMen += ' <tr> Ocorrência: ' + _cOcorren + '</tr>'
		cMen += ' <tr> </tr>'
		cMen += ' <tr> Resumo do chamado: '+ _cResumo + '</tr>'

		If _cTpAnali = "Projeto"
			cMen += ' <tr> Descrição do Projeto / Melhoria: ' + _cAnalise+ '</tr>'
		EndIf

		_cTo += AllTrim( UsrRetMail( _cMat) )+";" // Email do Solicitante

		//  .--------------------------.
		// |   Atendimento do chamado   |
		//  '--------------------------'
		Case( _nOpc = 7 )       

		oProcess :cSubject := "Chamado - " + _cDoc + " - Atendido."
		cMen += ' <tr> </tr>'
		cMen += ' <tr> Atendido por: ' + AllTrim( xUsrDados( __cUserID, 4) ) + ' </tr>'
		cMen += ' <tr> </tr>'
		cMen += ' <tr> Ocorrência: ' + _cOcorren + '</tr>'
		cMen += ' <tr> Resumo do chamado: '+ _cResumo + '</tr>'
		cMen += ' <tr> Solução: ' + _cExec + '</tr>'

		_cTo += AllTrim( UsrRetMail( _cMat) )+";" // Email do Solicitante

		//  .--------------------------.
		// |   Finalização do Chamado   |
		//  '--------------------------'

		Case ( _nOpc = 8 ) // Finalizar

		If _cTpResp = "Sim"

			_cQualidade := ""
			If _cNota = '1'
				_cQualidade := "NÃO SATISFEITO"
			ElseIf _cNota = '2'
				_cQualidade := "PARCIALMENTE SATISFEITO"
			ElseIf _cNota = '3'
				_cQualidade := "SATISFEITO"
			Else
				_cQualidade := "MUITO SATISFEITO"
			EndIf

			oProcess :cSubject := "Chamado - " + _cDoc + " - Finalizado pelo(a) sr(a) " + _cSolic

			cMen += ' <tr> </tr>'
			cMen += ' <tr> Finalizado por : ' + _cSolic + ' </tr>'
			cMen += ' <tr> </tr>'
			cMen += ' <tr> Ocorrência: ' + _cOcorren + '</tr>'
			cMen += ' <tr> </tr>'
			cMen += ' <tr> Solução: ' + _cExec + '</tr>'
			cMen += ' <tr> </tr>'
			cMen += ' <tr> </tr>'
			cMen += ' <tr> Grau de Satisfação: ' + _cNota + ' - ' + _cQualidade +' </tr>'

		Else
			oProcess :cSubject := "Chamado - " + _cDoc + " - Resposta negativa do(a) sr(a) " + _cSolic

			cMen += ' <tr> Resposta negativa por : ' + _cSolic + ' </tr>'
			cMen += ' <tr> </tr>'
			cMen += ' <tr> Resposta: ' + _cResp + '</tr>'

		EndIf

		_cTo += AllTrim( UsrRetMail( _cMat) )+";" // Email do Solicitante
		_cTo += "ti@nippon-seikibr.com.br;"


		Case ( _nOpc = 10 ) // Estimativa

		oProcess :cSubject := "Chamado - " + _cDoc + " - Estimativa realizado pelo(a) sr(a) " + AllTrim( xUsrDados( __cUserID, 4) )

		cMen += ' <tr> Estimado por: ' + AllTrim( xUsrDados( __cUserID, 4) ) + '</tr>'

		cMen += ' <tr> </tr>'
		cMen += ' <tr> Ocorrência: ' + _cOcorren + '</tr>'
		cMen += ' <tr> Resumo do chamado: '+ _cResumo + '</tr>'
		cMen += ' <tr> Descrição do Projeto / Melhoria: ' + _cAnalise+ '</tr>'
		cMen += ' <tr> </tr>'
		cMen += ' <tr> Estimativa: '+ _cEstima + '</tr>'

		// e-mail dos aprovadores
		If Len(_aAprov) <> 0
			For i:=1 To Len(_aAprov)
				_cTo += AllTrim( UsrRetMail( _aAprov[i]) )+";"
			Next
		EndIf

		_cTo += AllTrim( UsrRetMail( _cMat) )+";" // Email do Solicitante
		_cTo += "ti@nippon-seikibr.com.br;"


	EndCase	       

	cMen += ' </table>'  
	cMen += " </body>"
	cMen += " </html>" 

	oHtml:ValByName( "MENS", cMen)
	oProcess:cTo := _cTo
	cMailId := oProcess:Start()

Return
