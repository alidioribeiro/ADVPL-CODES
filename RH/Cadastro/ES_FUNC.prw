#INCLUDE "rwmake.ch" 
#include "protheus.ch"
#Include "TBICONN.CH"
#Include "TOPCONN.CH"
#include "ap5mail.ch" 
#include 'fivewin.ch'
#include 'tbiconn.ch' 
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

//aLTECAO ADSON

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma³Portaria    º Autor ³ Willliam Rodrigues º Data ³  09/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß 

/*/
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Incluir Visitas Com Agendamentos                                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/       

User Function ES_FUNC()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Local lRet        := .T.  
	Local aReg:={}
	Private cCadastro := "Cadastro de Entrada e Saída"

	Private aRotina := { {"Pesquisar" ,"AxPesqui"  ,0,1 },;
	{"Visualizar","U_VisuFunc",0,2 },;
	{"Incluir"   ,"U_CadFunc" ,0,3 },;
	{"Alterar"   ,"U_AltFunc" ,0,4 },; 
	{"&Excluir"  ,"U_ExcFunc" ,0,5 },;
	{"Prosseguir","U_ProFunc" ,0,6 },; 
	{"Finalizar" ,"U_FimFunc" ,0,7 },;
	{"Aprovar"   ,"U_AprFunc" ,0,8 },;
	{"Cancelar"  ,"U_CanFunc" ,0,9 },;   
	{"Relatório" ,"U_relcesf" ,0,10},;                
	{"Legenda"   ,"U_ESFULeng",0,11}}   

	Private aCores 	 := {{ "ZZI->ZZI_STATUS=='0'", 'BR_AZUL'    },;  // Aberto AxInclui
	{ "ZZI->ZZI_STATUS=='1'", 'BR_VERDE'   },;  // Aprovado
	{ "ZZI->ZZI_STATUS=='2'", 'BR_VERMELHO'},;  // Realizado finalizado
	{ "ZZI->ZZI_STATUS=='3'", 'BR_PRETO'   },;  // Nao Realizado 
	{ "ZZI->ZZI_STATUS=='4'", 'BR_AMARELO' },;  // Em Andamento
	{ "ZZI->ZZI_STATUS=='5'", 'BR_LARANJA'}}    // Nao houve aprovacão e o funcionário saio

	Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

	Private	_cEmpUso  	:= AllTrim(cEmpAnt)+"/",;
	_cPerg    	:= "ZZICESF"
	_bFiltraBrw	:= ''
	_aIndexZZI 	:= {}
	_cFiltro  	:= ''    
	Private aEnvEmail   :={} // Vetor de carega os dados da solicitação para os email do funcionários

	Private cMarca      := GetMark()
	Private cDelFunc    := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
	Private cString     := "ZZI" 
	Private IRel        := .T.
	Private cDelFunc    := ".T." 
	private opcao       := 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ recuperando valores do usuário logado                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	xUserVali           := __cUserId
	PSWORDER(1) //Indexação da senha do usuário pelo ID da senha
	aInfoUser           := PswRet()
	cMatSol             := Subs(aInfoUser[1][22],5,6)
	cCCSoli             := alltrim(Posicione("SRA",1,xFilial("SRA") + cMatSol,"RA_CC"))
	cDescSol            := alltrim(Posicione("CTT",1,xFilial("CTT") + cCCSoli,"CTT_DESC01"))
	cUser               := __cUserId  

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Amostrando somente os agendamento do solicitante                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF U_ValAprova(__cUserId,1)  
		_cFiltro := "ZZI->ZZI_NAPROV = '"+__cUserId+"' .Or. AllTrim(ZZI->ZZI_CCUSTO) = '"+AllTrim(cCCSoli)+"' .Or. AllTrim(ZZI->ZZI_STATUS) = '4' .Or. AllTrim(ZZI->ZZI_STATUS) = '2'"     
	ElseIf cNivel > 1 .And. !U_ValAprova(__cUserId,1)               
		_cFiltro := "AllTrim(ZZI->ZZI_CCUSTO) == '"+Alltrim(cCCSoli)+"' .Or. AllTrim(ZZI->ZZI_IDUSER)== '"+__cUserId+"'"    
	Else
		_cFiltro = "AllTrim(ZZI->ZZI_STATUS)$'0/1/4/5' .And. Alltrim(ZZI->ZZI_OK) = ''" 
	EndIF

	If (Alltrim(cCCSoli) ='124')
		_cFiltro := ""
	EndIF			                        

	If (Alltrim(cCCSoli) ='126') 
		_cFiltro := ""
	EndIF			

	If	! Empty(_cFiltro) 
		_bFiltraBrw := {|| FilBrowse("ZZI",@_aIndexZZI,@_cFiltro) }
		Eval(_bFiltraBrw)
	EndIf

	dbSelectArea(cString)
	dbSetOrder(1) 

	mBrowse(6,1,22,75,cString,,,,,,aCores)

	EndFilBrw("ZZI",_aIndexZZI)
Return                            


User Function ESFULeng()
	Local	aLegenda  := {	{'BR_AZUL'		,'Aberto'},;
	{'ENABLE'		,'Aprovado'},;
	{'BR_AMARELO'	,'Em Andamento'},;
	{'BR_PRETO'	    ,'Cancelado'},;  
	{'BR_LARANJA'	,'Sem Aprovação'},;
	{'DISABLE'		,'Encerrado'}	}

	BrwLegenda(cCadastro,'Legenda',aLegenda)

Return .T.



static function redirect()   

	If opcao <= 2  
		IF validarCamp()
			//CadFun()
			MsgRun(OemToAnsi('Gerando o registro.... Aguarde....'),'',{|| CursorWait(), CadFun() ,CursorArrow()})
		ENDIF
	elseIf opcao = 3

		oDlgEsFun:end()

	elseIf opcao = 5
		//IF validarCamp()
		AlterarFun()
		//EnDIF
	elseIf opcao = 4

		AprovarFun()

	elseIf opcao = 6

		CancelarFun()

	elseIf opcao = 7
		IF (dtSai() .AND. hrSai())
			ProceguirFun()        
		EndiF

	elseIf opcao = 8

		FinalizarFun()   

	elseIf opcao = 10
		if Msgbox("Confirma a exclusão!","Alerta!","YesNo")
			ExcluirFun() 
		EndIF
	EndIF

return


User function ExcFunc()
	if AllTrim(ZZI->ZZI_IDUSER) =__cUserId 
		if ZZI->ZZI_STATUS = "0" .Or. ZZI->ZZI_STATUS = "1"
			opcao := 10
			FormCad()  
		Else
			Msgbox("Você não pode excluir!","Mensage","INFO")    
		EndIF
	Else
		Msgbox("Você não pode excluir, somente o elaborador da solicitação!","Mensage","INFO")    
	EndIF

return                 

User function CadFunc()
	if cNivel < 4
		opcao := 1
		FormCad()
	Else
		opcao := 2
		FormCad()
	EndIF   
return

User function VisuFunc()
	opcao := 3
	FormCad() 
return          

User function AprFunc()
	Local proceguir := .F.
	proceguir := U_ValAprova(__cUserId,1)
	if proceguir .And. ZZI->ZZI_STATUS = "0"   	
		opcao := 4
		FormCad()
	else 
		alert("Você não pode aprovar!")
	EndIf 
return

User function AltFunc()

	IF ZZI->ZZI_STATUS=='0' .Or. cNivel < 5 
		opcao := 5
		FormCad() 
	Else 
		Alert("Você não pode Alterar Essa solicitação, Por Favor Entre em contato com  a T.I !")
	EndIF
return

User function CanFunc()
	if ZZI->ZZI_STATUS = '0' .Or. ZZI->ZZI_STATUS = '1' .Or. U_ValAprova(__cUserId,1)
		//não pode cancelar solicitações diferentes 
		if AllTrim(ZZI->ZZI_MAT) == Subs(aInfoUser[1][22],5,6)  .Or. AllTrim(ZZI->ZZI_NAPROV) == Subs(aInfoUser[1][22],5,6) .Or. cNivel < 5
			opcao := 6
			FormCad() 
		Else 
			Alert("Você não pode Cancelar essa Solicitação")
		EndIF
	EndIF
Return         

User Function ProFunc()
	if cNivel < 4  .And. ZZI-> ZZI_STATUS = "1"
		opcao := 7
		FormCad()
	Elseif cNivel < 4  .And. ZZI-> ZZI_STATUS = "0"
		opcao := 7
		FormCad()
	else
		alert("Você não pode dá proseguimento a essa solicitação!") 
	EndIF
Return

User function FimFunc()
	if cNivel < 4  .And. ZZI-> ZZI_STATUS = "4"
		opcao := 8
		FormCad()    
	elseif cNivel < 4  .And. ZZI-> ZZI_STATUS = "5"
		opcao := 8
		FormCad()
	else
		alert("Você não pode Finalizar !") 
	EndIF
return

static function FormCad()
	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Declaração de cVariable dos componentes                                 ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	dbSelectArea("ZZI")                 
	dbSetOrder(1) 
	Private cDoc       := U_GeraSeq("ZZI","ZZI_DOC")                                                                                                      
	Private cAprov     := PADL(0,6,'0')
	Private cCcSol     := Space(9)
	Private cDescMotiv := Space(40)
	Private cDescSol   := Space(30)
	Private cHrSaiTipo := Space(5)
	Private cHrSol     := Time()
	Private cMatSol    := Space(6)
	Private cMotivo    := Space(40)
	Private cNomeAprov := Space(40)
	Private cNomeSol   := Space(40)
	Private cSeg       := Space(40)
	Private cTurno     := Space(30) 
	private cDiaLicen  := Space(6)
	private dDtCheFun  := CtoD(" ")
	Private dDtSaiRel  := CtoD(" ")  
	Private dDtLicen   := CtoD(" ")
	Private dDtSaiTipo := Date()
	Private dDtSol     := Date()
	Private nHrEnt     := 0
	Private nHrChegada := 0
	Private nHrSaiRel  := 0
	Private nHrTotal   := 0
	Private nHrEntAl   := 0
	Private nHrSaiAl   := 0
	Private cObs       := Space(60)
	Private nRetorno
	Private nTipoSai   := Space(60)
	private cImg 	   := "ns.jpg"

	cIdGestor := ""
	cIdFunc   := "" 
	nEntraAlm :=0
	nSaiAlm   :=0  
	cIdTurno  := ""

	if (opcao > 2)
		VisuFunSel()
	EndIF        
	if cNivel < 5 
		cSeg:=cUserName
	EndiF

	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Se opcao for
	// 1 - Cadastro de entrada e feito pela portario
	// 2 - Cadastro de saída e feito pelo funcionário
	// 3 - Visualizar 
	// 4 - Aprovar
	// 5 - Alterar
	// 6 - Cancelar
	// 7 - Proceguir
	// 8 - Finalizar         
	9 - processeguir sem está aprovado
	// IRel igual a .T.
	//Desabilita o  campos,
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/


	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Declaração de Variaveis Private dos Objetos                             ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	SetPrvt("oDlgEsFun","oGrp1","oFoto","oSay1","oSay2","oSay3","oSay5","oSay6","oSay10","oSay12","oDtSol")
	SetPrvt("oNomeSol","oCcSol","oDescSol","oHrSol","oDoc","oGrp2","oSay8","oSay9","oSay11","oSay7","oSay13")
	SetPrvt("oSay15","oSay22","oSay23","oAprov","oNomeAprov","oMotivo","oDtSaiTipo","oHrSaiTipo","oRetorn")
	SetPrvt("oDiaLicen","oCBox1","oGrp3","oSay16","oSay18","oSay17","oSay19","oSay20","oSay4","oSay14","oSay25","dDtLicen")
	SetPrvt("oSeg","oDtSaiRel","oHrSaiRel","oHrChegada","oHrTotal","cTurno","oHrEnt","oHrSaiAl","oHrEntAl","nTipoSai","oDtCheFun")

	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	oDlgEsFun  := MSDialog():New( 091,237,648,1126,"Cadastro de Entrada e Saída de Funcionário",,,.F.,,,,,,.T.,,,.T. )
	oDlgEsFun:bInit := {||EnchoiceBar(oDlgEsFun,{||redirect()},{||oDlgEsFun:end()},.F.,{})}
	oGrp1      := TGroup():New( 016,004,096,432,"Dados do Funcionário",oDlgEsFun,CLR_BLACK,CLR_WHITE,.T.,.F. )

	oFoto      := TBitmap():New( 028,012,060,056,,cImg,.F.,oGrp1,,,.F.,.T.,,"",.T.,,.T.,,.F. )
	oSay1      := TSay():New( 023,092,{||"Documento:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
	oSay2      := TSay():New( 045,092,{||"Matricula:(*)"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay3      := TSay():New( 045,144,{||"Funcioário:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
	oSay5      := TSay():New( 066,092,{||"C. Custo:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay6      := TSay():New( 066,145,{||"Descrição:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay10     := TSay():New( 023,144,{||"Dt. Solicitação:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
	oSay12     := TSay():New( 023,201,{||"Hr. Solicitação:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,047,008)

	oDtSol     := TGet():New( 035,144,{|u| If(PCount()>0,dDtSol:=u,dDtSol)},oGrp1,048,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","dDtSol",,)
	oMatSol    := TGet():New( 057,092,{|u| If(PCount()>0,cMatSol:=u,cMatSol)},oGrp1,047,008,'999999',{||FunPesq()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cMatSol",,)
	oNomeSol   := TGet():New( 057,144,{|u| If(PCount()>0,cNomeSol:=u,cNomeSol)},oGrp1,278,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cNomeSol",,)
	oCcSol     := TGet():New( 078,092,{|u| If(PCount()>0,cCcSol:=u,cCcSol)},oGrp1,047,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cCcSol",,)
	oDescSol   := TGet():New( 078,144,{|u| If(PCount()>0,cDescSol:=u,cDescSol)},oGrp1,279,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cDescSol",,)
	oHrSol     := TGet():New( 035,201,{|u| If(PCount()>0,cHrSol:=u,cHrSol)},oGrp1,047,008,'99:99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cHrSol",,)
	oDoc       := TGet():New( 035,092,{|u| If(PCount()>0,cDoc:=u,cDoc)},oGrp1,047,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cDoc",,)

	oGrp2      := TGroup():New( 104,004,200,432,"Dados do Solicitação",oDlgEsFun,CLR_BLACK,CLR_WHITE,.T.,.F.)
	oSay8      := TSay():New( 117,012,{||"Aprovador:(*)"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
	oSay9      := TSay():New( 118,062,{||"Nome:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay11     := TSay():New( 143,141,{||"Motivo:(*)"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay7      := TSay():New( 172,172,{||"Hora Saida Prevista:(*)"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,008)
	oSay13     := TSay():New( 143,012,{||"Tipo:(*)"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
	oSay21     := TSay():New( 144,088,{||"Retorno:(*)"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay15     := TSay():New( 172,124,{||"Data Saida Prevista:(*)"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
	oSay22     := TSay():New( 172,012,{||"Data Licença:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
	oSay23     := TSay():New( 172,066,{||"Dias Licença:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)                                                                       
	if cNivel >= 5
		oAprov     := TGet():New( 129,012,{|u| If(PCount()>0,cAprov:=u,cAprov)},oGrp2,047,008,'999999',{||AchaNome()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ZZS","cAprov",,)
	Else 
		oAprov     := TGet():New( 129,012,{|u| If(PCount()>0,cAprov:=u,cAprov)},oGrp2,047,008,'999999',{||AchaFunAp()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SRAPOR","cAprov",,)
	EndIF
	oNomeAprov := TGet():New( 129,062,{|u| If(PCount()>0,cNomeAprov:=u,cNomeAprov)},oGrp2,366,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cNomeAprov",,)
	oTipoSai   := TComboBox():New( 156,012,{|u| If(PCount()>0,nTipoSai:=u,nTipoSai)},{"","Atraso","Sem Crachá","Particular","Licença Medica","HR Extra","A Serviço"},072,010,oGrp2,,,{||tipoSol()},CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nTipoSai ) 
	//oTipoSai   := TComboBox():New( 156,012,{|u| If(PCount()>0,nTipoSai:=u,nTipoSai)},{"","Atraso","Sem Crachá","Particular","Licença Medica","HR Extra","A Serviço","A trabalho"},072,010,oGrp2,,,{||tipoSol()},CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nTipoSai ) 
	oRetorno   := TComboBox():New( 156,088,{|u| If(PCount()>0,nRetorno:=u,nRetorno)},{"","SIM","NAO"},044,010,oGrp2,,,{||S_retorno()},CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nRetorno )
	oMotivo    := TGet():New( 155,140,{|u| If(PCount()>0,cMotivo:=u,cMotivo)},oGrp2,287,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cMotivo",,)
	oDtLicen   := TGet():New( 182,012,{|u| If(PCount()>0,dDtLicen:=u,dDtLicen)},oGrp2,047,008,'',{||DtAt()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDtLicen",,)
	oDiaLicen  := TGet():New( 182,066,{|u| If(PCount()>0,cDiaLicen:=u,cDiaLicen)},oGrp2,047,008,'999999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDiaLicen",,)
	oDtSaiTipo := TGet():New( 182,124,{|u| If(PCount()>0,dDtSaiTipo:=u,dDtSaiTipo)},oGrp2,047,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDtSaiTipo",,)
	oHrSaiTipo := TGet():New( 182,180,{|u| If(PCount()>0,cHrSaiTipo:=u,cHrSaiTipo)},oGrp2,047,008,'99:99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cHrSaiTipo",,) 

	oGrp3      := TGroup():New( 208,004,264,432,"Dados da finalizações",oDlgEsFun,CLR_BLACK,CLR_WHITE,.T.,.F. )

	oSay4      := TSay():New( 216,016,{||"Periódo do Turno:"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,057,008)  

	oSay18     := TSay():New( 216,140,{||"Data da Chegada:"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,043,008)
	oSay19     := TSay():New( 216,190,{||"Hr. Chegada"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,043,008)

	oSay17     := TSay():New( 216,320,{||"Hr. Saída"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,008)     

	oSay18     := TSay():New( 216,350,{||"Data da saída:"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,043,008)

	oSay16     := TSay():New( 238,013,{||"Segurança:"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)


	oSay20     := TSay():New( 216,395,{||"Hr. Total"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)

	oSay14     := TSay():New( 216,225,{||"Hr. Entrada"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,043,008)       

	oSay25     := TSay():New( 220,260,{||"Hr. de Almoço de/ ate"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,056,008)

	oSay24     := TSay():New( 240,209,{||"Observação do segurança:"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)                                    

	oTurno     := TGet():New( 228,012,{|u| If(PCount()>0,cTurno:=u,cTurno)},oGrp3,127,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cTurno",,)


	oSeg       := TGet():New( 249,013,{|u| If(PCount()>0,cSeg:=u,cSeg)},oGrp3,183,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cSeg",,)

	oDtCheFun  := TGet():New( 228,140,{|u| If(PCount()>0,dDtCheFun:=u,dDtCheFun)},oGrp3,047,008,'',{||dtChe()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDtCheFun",,)
	oHrChegada := TGet():New( 228,190,{|u| If(PCount()>0,nHrChegada:=u,nHrChegada)},oGrp3,027,008,'99.99',{||CalcHr()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nHrChegada",,)
	oHrSaiRel  := TGet():New( 228,314,{|u| If(PCount()>0,nHrSaiRel:=u,nHrSaiRel)},oGrp3,027,008,'99.99',{||CalcHr()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nHrSaiRel",,)

	oDtSaiRel  := TGet():New( 228,345,{|u| If(PCount()>0,dDtSaiRel:=u,dDtSaiRel)},oGrp3,047,008,'',{||dtSaida()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDtSaiRel",,)

	oHrTotal   := TGet():New( 228,395,{|u| If(PCount()>0,nHrTotal:=u,nHrTotal)},oGrp3,028,008,'99.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nHrTotal",,)

	oHrEnt     := TGet():New( 228,225,{|u| If(PCount()>0,nHrEnt:=u,nHrEnt)},oGrp3,027,008,'99.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nHrEnt",,)
	oHrSaiAl   := TGet():New( 228,258,{|u| If(PCount()>0,nHrSaiAl:=u,nHrSaiAl)},oGrp3,027,008,'99.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nHrSaiAl",,)
	oHrEntAl   := TGet():New( 228,284,{|u| If(PCount()>0,nHrEntAl:=u,nHrEntAl)},oGrp3,027,008,'99.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nHrEntAl",,)
	oObs       := TGet():New( 248,209,{|u| If(PCount()>0,cObs:=u,cObs)},oGrp3,207,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cObs",,)

	//desabilita todos os campos
	DesabForm()                     

	if opcao < 3 .Or. opcao = 5    

		oAprov     :Enable()
		oMotivo    :Enable()
		oHrSaiTipo :Enable()
		oMatSol    :Enable() 
		oDtSaiTipo :Enable()
		oRetorno   :Enable()
		oTipoSai   :Enable()

	ELSEIF opcao = 7
		oHrSaiRel:Enable()  
		oDtSaiRel:Enable()  
		oObs     :Enable() 
	ELSEIF opcao = 8       

		IF Alltrim(ZZI->ZZI_TIPO)=="HR Extra" .Or. Alltrim(ZZI->ZZI_TIPO)=="Sem Crachá"//na hora da finalização se for do tipo Hora extra ou A serviço não peenche o
			oHrChegada:disable() 
			oRetorno  :disable()  
			oDtSaiRel:Enable()
			oHrSaiRel:Enable()
		ELSE    
			oDtSaiRel:Enable()  
			oDtCheFun:Enable()  
			oHrChegada:Enable()  
			oObs      :Enable() 
			oRetorno  :Enable()
			oDtSaiRel:Enable()
			oHrSaiRel:Enable()
		ENDIF

	EndIF        
	IF opcao ==5 .And. cNivel < 5
		oDtSaiRel:Enable()  
		oDtCheFun:Enable()  
		oHrChegada:Enable()  
		oObs      :Enable() 
		oRetorno  :Enable()
		oDtSaiRel:Enable()
		oHrSaiRel:Enable()
	EndIF
	If cNivel < 5
		oObs     :Enable()
	EndiF

	oDlgEsFun:Activate(,,,.T.)  

Return                      

Static function DesabForm()

	oDoc       :Disable()                                                                                                  
	oAprov     :Disable()
	oCcSol     :Disable()
	oMotivo    :Disable()
	oDescSol   :Disable()
	oHrSaiTipo :Disable()
	oHrSol     :Disable()
	oMatSol    :Disable()
	oMotivo    :Disable()
	oNomeAprov :Disable()
	oNomeSol   :Disable()
	oSeg       :Disable()
	oTurno     :Disable() 
	oDiaLicen  :Disable()
	oDtSaiRel  :Disable() 
	oDtLicen   :Disable()
	oDtSaiTipo :Disable()
	oDtSol     :Disable()
	oHrEnt     :Disable()
	oHrChegada :Disable()
	oHrSaiRel  :Disable()
	oHrTotal   :Disable()
	oHrEntAl   :Disable() 
	oDtCheFun  :Disable()
	oHrSaiAl   :Disable()
	oObs       :Disable()
	oRetorno   :Disable()
	oTipoSai   :Disable()
	oFoto      :Disable()
return      

Static function VisuFunSel()
	cDoc       :=ZZI->ZZI_DOC        
	dDtSol     :=ZZI->ZZI_DTSOL           
	cHrSol     :=ZZI->ZZI_HRSOL         
	cMatSol    :=ZZI->ZZI_MAT 
	cNomeSol   :=ZZI->ZZI_NOME
	cCcSol     :=ZZI->ZZI_CCUSTO     
	cDescSol   :=ZZI->ZZI_CNOME                                                                                 
	cAprov     :=ZZI->ZZI_NAPROV      
	cNomeAprov :=ZZI->ZZI_NOMEA
	cMotivo    :=ZZI->ZZI_MOTIVO  
	cDescMotiv :=ZZI->ZZI_ESPC 
	nRetorno   :=ZZI->ZZI_RETORN 
	nTipoSai   :=ZZI->ZZI_TIPO   
	dDtCheFun  :=ZZI->ZZI_DTCHEG
	dDtSaiTipo :=ZZI->ZZI_DTPLAN 
	cHrSaiTipo :=ZZI->ZZI_HRPLAN
	dDtSaiRel  :=ZZI->ZZI_DTFIM 
	cTurno     :=ZZI->ZZI_TURNO 
	nHrEnt     :=ZZI->ZZI_HRENT
	nHrSaiRel  :=ZZI->ZZI_HRSAI 
	nHrChegada :=ZZI->ZZI_HRCHEG
	nHrTotal   :=ZZI->ZZI_HRGAST
	cSeg       :=ZZI->ZZI_SEG
	cImg       :=ZZI->ZZI_FOTO 
	dDtLicen   :=ZZI->ZZI_DTLICE
	cDiaLicen  :=ZZI->ZZI_DIALIN  
	nHrEntAl   :=ZZI->ZZI_ENTAL
	nHrSaiAl   :=ZZI->ZZI_SAIAL      
	cObs       :=ZZI->ZZI_OBSSEG
return    

static function DtAt()
	dDtSaiRel := dDtLicen
return

STATIC function dtSaida()  
	Local IRet := .T.       
	IF dDtSaiRel == CtoD(" ")
		IRet := .F. 
		MsgInfo("Preencha a data da saída","Atenção")       
	EndIF
return(IRet)


//SELECIONA OS CAMPOS DO TIPO DA SOLICITAÇÃO;
static function tipoSol()
	Local IRet := .F.          

	IF !empty(nTipoSai) 
		If cNivel < 5
			nRetorno := ""
			IF Alltrim(nTipoSai) == "HR Extra" .Or. Alltrim(nTipoSai) == "Sem Crachá" .Or. Alltrim(nTipoSai) == "A Serviço"         
				nHrSaiRel  := 0
				nHrEntAl   := 0 
				nHrSaiAl   := 0    
				nHrTotal   := 0
				nHrChegada := 0
				dDtCheFun  :=  CtoD(" ")
				dDtSaiTipo :=  CtoD(" ")
				oHrChegada:Enable()
				//oHrEnt:Enable()
				oDtCheFun:Enable()
				nRetorno := ""     
				IRet := .T.       
				oRetorno:Disable()          
				oRetorno:Disable()  
				oDtLicen:Disable()     
				oDiaLicen:Disable()
				oHrSaiTipo :Disable()
				oDtSaiTipo :Disable()  

			ElseIF Alltrim(nTipoSai)=="Atraso"  

				dDtSaiTipo :=  CtoD(" ")
				nRetorno := "SIM"  
				nHrEnt   :=0
				oHrChegada:Enable()
				oHrEnt:Disable()
				oDtCheFun:Enable()
				oRetorno:Disable()
				oDtLicen:Disable()     
				oDiaLicen:Disable()
				oHrSaiTipo :Disable()
				oDtSaiTipo :Disable()

				FunPesq()  
				IRet := .T.
			ElseIF Alltrim(nTipoSai)=="Licença Medica"     
				nHrEnt     := 0
				nHrSaiRel  := 0
				nHrEntAl   := 0 
				nHrSaiAl   := 0    
				nHrTotal   := 0         
				nRetorno   := ""     
				oRetorno:Disable()
				dDtSaiTipo := CtoD(" ")    
				oDtLicen:Enable()       
				oDiaLicen:Enable()
				oHrSaiTipo :Disable()
				oDtSaiTipo :Disable()
				IRet := .T.

			ElseIF Alltrim(nTipoSai)=="Particular"    
				IRet := .F.
				alert("Selecione outro tipo!")
			EndIF

		Else  

			IF Alltrim(nTipoSai) == "HR Extra" .Or. Alltrim(nTipoSai) == "Sem Crachá" .Or. Alltrim(nTipoSai)=="Atraso"  
				//    IF Alltrim(nTipoSai) == "HR Extra" .Or. Alltrim(nTipoSai) == "Sem Crachá" .Or. Alltrim(nTipoSai)=="Atraso" .Or. Alltrim(nTipoSai)=="A Serviço"        

				alert("Esse tipo não e permitido, por favor redirecione a portaria!")    
				IRet := .F.    
				nTipoSai:=""

			ElseIF Alltrim(nTipoSai)=="Licença Medica"     

				nHrEnt     := 0
				nHrSaiRel  := 0
				nHrEntAl   := 0 
				nHrSaiAl   := 0    
				nHrTotal   := 0         
				nRetorno   := ""     
				dDtSaiTipo :=  CtoD(" ")    
				cHrSaiTipo :=Space(5)
				oDtLicen   :Enable()       
				oDiaLicen  :Enable()
				oHrSaiTipo :Disable()
				oDtSaiTipo :Disable()       
				oRetorno   :Disable()  
				IRet := .T.       

				//ElseIF Alltrim(nTipoSai)=="A trabalho" .Or.  Alltrim(nTipoSai)=="Particular"     
			ElseIF Alltrim(nTipoSai)=="A Serviço" .Or.  Alltrim(nTipoSai)=="Particular"    
				IRet := .T.
				oDtLicen:Disable()       
				oDiaLicen:Disable()
				oHrSaiTipo :Enable()
				oDtSaiTipo :Disable()
				oRetorno   :Enable()       
				dDtLicen   := CtoD(" ")
				cDiaLicen  :=space(6)
			EndIF

		ENDIF              
	Else 
		Alert("Preencha o campo TIPO!")
		IRet := .F.
	EndIF
Return(IRet)


//SITUAÇÃO DE RETORNO	
static function S_retorno    
	FunPesq()
	if nRetorno == "NAO"                              
		nHrChegada:= 0
		IF nTipoSai =="A trabalho" 
			nHrTotal   := 0      
		EndIF
	Else
		nHrChegada:= 0
	EndIF
Return          


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±Pesquisa do aprovador de atrasos                                      ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/       
static function AchaFunAp()    
	Local lRet   := .T.         
	Local cCustoFunc 

	cAprov := PADL(ALLTRIM(cAprov),6,'0')

	if !empty(cAprov)
		DbSelectArea("SRA")

		DbSetOrder(1)     
		DbGotop()

		If DbSeek(xFilial("SRA") + cAprov)     
			cAprov     := SRA->RA_MAT
			cNomeAprov := SRA->RA_NOME   
			cCustoFunc := SRA->RA_CC
			cIdGestor  := alltrim(Posicione("ZZS",1,SRA->RA_CC,"ZZS_USER"))  		                		               		      

		Endif

		if empty(SRA->RA_MAT)

			cQuery := " SELECT RA_NOME,RA_CC,RA_DEMISSA,RA_MAT FROM SRA020 WHERE D_E_L_E_T_='' AND  RA_MAT = '" +cAprov+ "'
			Query := ChangeQuery(cQuery)
			TCQUERY cQuery Alias TRA New 

			dbSelectArea("TRA")    
			cAprov     := TRA->RA_MAT
			cNomeAprov := TRA->RA_NOME
			cCustoFunc := TRA->RA_CC
			cIdGestor  := alltrim(Posicione("ZZS",1,TRA->RA_CC,"ZZS_USER"))             
		EndIF

		If empty(RA_NOME) .And. empty(SRA->RA_MAT)
			Alert("Atenção: Matricula Não Encontrada")
			lRet := .F.
		EndIF                        

		dbCloseArea("TRA")
		dbCloseArea()

	EndIF                         

Return(lRet) 


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Consultas dados do Solicitante                                          ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/ 
static function FunPesq()    

	Local lRet   := .T.
	Local cCodTurno
	Local cAux    
	Local cTeste
	if Alltrim(cMatSol) <> ''
		cMatSol := PADL(ALLTRIM(cMatSol),6,'0')

		if AllTrim(nTipoSai) <> 'Licença Medica' .And. Alltrim(nTipoSai) <> "HR Extra" .And. Alltrim(nTipoSai) <> "Sem Crachá" .And. Alltrim(nTipoSai) <> "A Serviço"  

			DbSelectArea("SRA")  
			DbSetOrder(1)     
			DbGotop()

			If DbSeek(xFilial("SRA") + cMatSol)
				cNomeSol   := SRA->RA_NOME 
				cMatSol    := SRA->RA_MAT  
				cCcSol     := SRA->RA_CC
				cImg       := SRA->RA_BITMAP  
				cIdTurno   := SRA->RA_TNOTRAB
				cTurno     := alltrim(Posicione("SR6",1,xFilial("SR6") + cIdTurno,"R6_DESC"))    
				nSaiAlm    := Posicione("SPJ",1,xFilial("SPJ") + cIdTurno,"PJ_SAIDA1")    
				nEntraAlm  := Posicione("SPJ",1,xFilial("SPJ") + cIdTurno,"PJ_ENTRA2")
				nHrEntAl   := nEntraAlm 
				nHrSaiAl   := nSaiAlm 

				if opcao = 1               
					//nHrEnt   := Posicione("SPJ",1,xFilial("SPJ") + cIdTurno,"PJ_ENTRA1")
					//nHrSaiRel:= Posicione("SPJ",1,xFilial("SPJ") + cIdTurno,"PJ_SAIDA2")
				Else
					//nHrEnt   := Posicione("SPJ",1,xFilial("SPJ") + cIdTurno,"PJ_ENTRA1")
				EndIF

				If empty(cImg)
					cImg:="ns.jpg" 
				Else
					cImg:=alltrim(SRA->RA_BITMAP)+".jpg"
				EndIF 

				cDescSol := alltrim(Posicione("CTT",1,xFilial("CTT") + cCcSol,"CTT_DESC01"))            		               		      
			Endif     

			if empty(SRA->RA_MAT)

				cQuery := " SELECT RA_NOME,RA_CC,RA_DEMISSA,RA_MAT,RA_TNOTRAB,RA_BITMAP FROM SRA020 WHERE D_E_L_E_T_='' AND  RA_MAT = '" +cMatSol+ "'
				Query := ChangeQuery(cQuery)
				TCQUERY cQuery Alias TRA New 

				dbSelectArea("TRA")          

				cNomeSol    := TRA->RA_NOME 
				cMatSol     := TRA->RA_MAT  
				cCcSol      := TRA->RA_CC
				cImg        := TRA->RA_BITMAP   
				cIdTurno    := TRA->RA_TNOTRAB
				cTurno      := alltrim(Posicione("SR6",1,xFilial("020") + cIdTurno,"R6_DESC"))
				nSaiAlm     := Posicione("SPJ",1,xFilial("020") + cIdTurno,"PJ_SAIDA1")    
				nEntraAlm   := Posicione("SPJ",1,xFilial("020") + cIdTurno,"PJ_ENTRA2")
				nHrEntAl    := nEntraAlm 
				nHrSaiAl    := nSaiAlm

				if opcao = 1
					// nHrEnt   := Posicione("SPJ",1,xFilial("020") + cIdTurno,"PJ_ENTRA1")
					// nHrSaiRel:= Posicione("SPJ",1,xFilial("020") + cIdTurno,"PJ_SAIDA2")    

				Else
					// nHrEnt   := Posicione("SPJ",1,xFilial("020") + cIdTurno,"PJ_ENTRA1")
				EndIF

				If empty(cImg)
					cImg:="ns.jpg" 
				Else
					cImg:=alltrim(TRA->RA_BITMAP)+".jpg"
				EndIF 

				cDescSol := alltrim(Posicione("CTT",1,xFilial("CTT") + cCcSol,"CTT_DESC01"))

			EndIF

			If empty(cMatSol) .And. empty(cNomeSol)
				Alert("Atenção: Matricula Não Encontrada")
				lRet := .F.   
			EndIF         

			dbCloseArea("SRA")                
			dbCloseArea("TRA") 
		ENDIF
	Else
		alert("Preecha o campo matricula!")
		lRet := .F.
	EndIF
Return(lRet)             


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Calcula a Hora de entrada e Hora de Saida                               ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
static function CalcHr

	Local IRel := .T.          
	Local xAux := 0     

	if  nHrChegada > 23.59                                                

		alert("Hora de Chegada superior a 24H informe entre 1.00 á 23.59")    
		IRel := .F.  

	elseIf nHrSaiRel > 23.59

		alert("Hora da Saida superior a 24H informe entre 1.00 á 23.59")
		IRel := .F.

	elseIf nHrEnt > 23.59

		alert("Hora da Entrada superior a 24H informe entre 1.00 á 23.59")
		IRel := .F.

	else   

		IF Alltrim(nTipoSai)== "Atraso"   

			nHrEnt:= Posicione("SPJ",1,xFilial("020") + cIdTurno,"PJ_ENTRA1")

		EndIF


		If opcao = 1
			if nHrEntAl >= nHrChegada .And. nHrSaiAl < nHrChegada

				xAux     :=SubHoras(nHrChegada,nHrSaiAl) 
				nHrTotal :=SubHoras(nHrChegada,nHrEnt)     
				nHrTotal :=SubHoras(nHrTotal,xAux)   
				Alert("Não será descontado minutos de almoço!") 

			ElseIF nHrEntAl < nHrChegada 

				nHrTotal :=SubHoras(nHrChegada,nHrEnt)     
				nHrTotal :=SubHoras(nHrTotal,1.00) 
				Alert("Não será descontado a hora do almoço!")

			Else

				nHrTotal := SubHoras(nHrChegada,nHrEnt)     

			EndIf     


		Else     

			nSaiAlm  := nHrSaiAl   
			nEntraAlm:= nHrEntAl        

			If nHrSaiRel <= nSaiAlm .and. nHrChegada >= nEntraAlm // Saiu antes e chagou depois do almoço

				xAux     := 1.0 //não será descontado 1hora do horario de almoço     
				nHrTotal := SubHoras(nHrChegada,nHrSaiRel)     
				nHrTotal := SubHoras(nHrTotal,xAux)                           

			ElseIf nHrSaiRel >= nSaiAlm .and. nHrChegada <= nEntraAlm    //Saiu na hora do almoço e chegou antes do fim	              

				nHrTotal := 0                          

			ElseIf nHrSaiRel > nEntraAlm  .and. nHrChegada>=nEntraAlm // Saiu depois do horario do almoço e chegou depois	        	        

				nHrTotal := SubHoras(nHrChegada,nHrSaiRel)    

			ElseIf nHrSaiRel < nEntraAlm  .and. nHrChegada>=nEntraAlm .And. nHrSaiRel > nSaiAlm// Saiu antes do horario do almoço e chegou antes 	        	        

				nHrTotal := SubHoras(nHrChegada,nEntraAlm)

			ElseIf nHrSaiRel < nEntraAlm  .and. nHrChegada<=nEntraAlm .And. nHrSaiRel < nSaiAlm// Saiu antes do horario do almoço e chegou antes 	        	        

				nHrTotal := SubHoras(nHrChegada,nHrSaiRel) 

			Else

				nHrTotal := SubHoras(nHrChegada,nHrSaiRel)     

			Endif     
		EndIF

		nHrEnt:=0

	EndIF      

	IF Alltrim(nTipoSai) == "HR Extra" .Or. Alltrim(nTipoSai) == "Sem Crachá" .Or. Alltrim(nTipoSai) == "A Serviço" 

		nHrTotal := 0

	EndIF 

return(IRel)                                                                   


//Acha o nome do aprovador na tabela ZZS
User function ValAprova(cAprov,nPosicao) 

	Local cPermitir
	Local IRel := .T.
	Local nTam :=0
	cAprov := PADL(ALLTRIM(cAprov),6,'0')

	cPermitir := alltrim(Posicione("ZZS",2,cAprov,"ZZS_ACESSO")) 
	nTam:= len(cPermitir)

	if subStr(cPermitir,nPosicao,1)!="S"
		IRel :=.F.
	EndIF

Return(IRel)


//Se deve enviar o email para o supervisor
User function ValEnvia(cSupervisor,nPosicao) 
	Local cPermitir
	Local IRel := .T.
	Local nTam :=0

	cPermitir := alltrim(Posicione("ZZS",2,cSupervisor,"ZZS_WORKF")) 
	nTam:= len(cPermitir)

	if subStr(cPermitir,nPosicao,nTam)!="S"
		IRel :=.F.
	EndIF

return(IRel)


static function AchaNome()
	Local lRet := .F.
	cAprov := PADL(ALLTRIM(cAprov),6,'0')
	
	lRet := U_ValAprova(cAprov,1)

	IF __cUserId = cAprov
		alert("Sr(a). Aprovador você não pode aprovar sua solicitação, selecione outros entre em contato com o RH!")                              
		lRet := .F. 
	Else          

		If lRet
			cNomeAprov := alltrim(Posicione("ZZS",2,cAprov,"ZZS_NUSER"))      
			if !lRet
				alert("Selecione Um aprovador com permições!")
				lRet:=.F.
			EndIF
		Else
			alert("Aprovador Não tem Permição para Aprovar,Por Favor Selecione outro aprovador!")
		EndIF 

	endIF
return(lRet)                  


Static function hrChe()    

	Local bBool := .T.

	If Empty(nHrChegada)
		MsgInfo("Informe o harario da chegada!","Alerta")
		bBool := .T. 
	EndIF	          
return (bBool)


Static function dtChe()    
	Local bBool := .T.
	If Empty(dDtCheFun)
		msgInfo("Informe a data da chegada!","Alerta")
		bBool := .T. 
	EndIF	          
return (bBool)


Static function hrSai()    
	Local bBool := .T.
	If Empty(nHrSaiRel)
		MsgInfo("Informe o harario da saída!","Alerta")
		bBool := .T. 
	EndIF	          
return (bBool)


Static function dtSai()
	Local bBool := .T.
	If Empty(dDtSaiRel)
		MsgInfo("Informe o harario da saída!","Alerta")
		bBool := .T. 
	EndIF
return(bBool)


static function validarCamp() 

	Local lRet := .F. 

	IF !empty(nTipoSai)
		If   opcao = 1
			if Alltrim(nTipoSai) == "HR Extra" .Or. Alltrim(nTipoSai) == "Sem Crachá" .Or. Alltrim(nTipoSai) == "Atraso" .Or. Alltrim(nTipoSai) == "A Serviço"
				if empty(cMatSol) .Or. empty(cMotivo) .Or. empty(cAprov) .Or. empty(dDtSol) .Or. empty(nHrChegada) .Or. empty(dDtCheFun) 
					alert("Preencha os compos com ' * '(Asterisco) corretamente...,Existem campos Vazios")    
					lRet := .F.   
				Else
					lRet := .T.
				ENDIF  
			ELSEIF Alltrim(nTipoSai) == "Licença Medica"    
				if empty(cMatSol) .Or. empty(cMotivo) .Or. empty(cAprov) .Or. empty(dDtLicen) .Or. empty(cDiaLicen) 
					alert("Preencha os compos com ' * '(Asterisco) corretamente...,Existem campos Vazios")    
					lRet := .F.   
				Else
					lRet := .T.
				ENDIF 
			Else 
				alert("Preencha o campo 'tipo' corretamente!")    
			ENDIF
		ELSE 

			if Alltrim(nTipoSai) == "Particular" .Or. Alltrim(nTipoSai) == "A Serviço"  
				// if Alltrim(nTipoSai) == "Particular" .Or. Alltrim(nTipoSai) == "A trabalho"  
				if empty(cMatSol) .Or. empty(cMotivo) .Or. empty(cAprov) .Or. empty(dDtSaiTipo) .Or. empty(cHrSaiTipo) .Or. empty(nRetorno) 
					alert("Preencha os compos com ' * '(Asterisco) corretamente...,Existem campos Vazios")    
					lRet := .F.   
				Else
					lRet := .T.
				ENDIF  
			ELSEIF Alltrim(nTipoSai) == "Licença Medica"    
				if empty(cMatSol) .Or. empty(cMotivo) .Or. empty(cAprov) .Or. empty(dDtLicen) .Or. empty(cDiaLicen) 
					alert("Preencha os compos com ' * '(Asterisco) corretamente...,Existem campos Vazios")    
					lRet := .F.   
				Else
					lRet := .T.
				ENDIF 
			Else 
				alert("Preencha o campo 'tipo' corretamente!")    
			ENDIF    
		EndIF              
	Else           
		alert("Preencha o campo 'tipo'!")    
	ENDIF    

return(lRet)                                                                   


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Se opcao for
// 1 - Cadastro de entrada e feito pela portario
// 2 - Cadastro de saída e feito pelo funcionário
// 3 - Visualizar 
// 4 - Aprovar
// 5 - Alterar
// 6 - Cancelar
// 7 - Proceguir
// 8 - Finalizar         
9 - processeguir sem está aprovado
// IRel igual a .T.
//Desabilita o  campos,
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
//Pesistencia de dados

static function CadFun()
	Local lRet := .T.     
	Local lPadrao  

	lPadrao:=Msgbox("Você confirma os dados preenchidos no formulario","Atenção","YESNO")

	If lPadrao 
		dbSelectArea("ZZI")

		RecLock("ZZI",.T.)

		Replace ZZI->ZZI_FILIAL      With xFilial()
		Replace ZZI->ZZI_DOC         With U_GeraSeq("ZZI","ZZI_DOC")     

		if opcao = 1
			if Alltrim(nTipoSai)== "Atraso"   

				nRetorno :="SIM"    
				Replace ZZI->ZZI_STATUS With "2"  

			Elseif  Alltrim(nTipoSai) == "HR Extra" .Or. Alltrim(nTipoSai) == "Sem Crachá" .Or. Alltrim(nTipoSai) == "A Serviço" 

				Replace ZZI->ZZI_STATUS With "4"

				nRetorno :="" 

			Else 
				Replace ZZI->ZZI_STATUS With "2"   
			EndIF         
		else    
			IF Alltrim(nTipoSai) == "Licença Medica"
				Replace ZZI->ZZI_STATUS With "2"
			Else  
				Replace ZZI->ZZI_STATUS With "0"
			EndIF
		EndIF  
		Replace ZZI->ZZI_DTSOL       With dDtSol     
		Replace ZZI->ZZI_HRSOL       With cHrSol  
		Replace ZZI->ZZI_IDUSER      With __cUserId
		Replace ZZI->ZZI_MAT         With cMatSol 
		Replace ZZI->ZZI_NOME        With cNomeSol
		Replace ZZI->ZZI_CCUSTO      With cCcSol
		Replace ZZI->ZZI_CNOME       With cDescSol                                                                                 
		Replace ZZI->ZZI_NAPROV      With cAprov
		Replace ZZI->ZZI_NOMEA       With cNomeAprov   
		Replace ZZI->ZZI_MOTIVO      With cMotivo  
		Replace ZZI->ZZI_RETORN      With nRetorno  
		Replace ZZI->ZZI_TIPO        With nTipoSai       
		Replace ZZI->ZZI_DTPLAN      With dDtSaiTipo     
		Replace ZZI->ZZI_HRPLAN      With cHrSaiTipo 
		Replace ZZI->ZZI_TURNO       With cTurno  
		Replace ZZI->ZZI_DTFIM       With dDtSaiRel
		Replace ZZI->ZZI_HRENT       With nHrEnt     
		Replace ZZI->ZZI_HRSAI       With nHrSaiRel 
		Replace ZZI->ZZI_HRCHEG      With nHrChegada      
		Replace ZZI->ZZI_HRGAST      With nHrTotal        
		Replace ZZI->ZZI_SEG         With cSeg       
		Replace ZZI->ZZI_FOTO        With cImg    
		Replace ZZI->ZZI_DTLICE      With dDtLicen
		Replace ZZI->ZZI_DIALIN      With cDiaLicen 
		Replace ZZI->ZZI_IDTURN      With cIdTurno 
		Replace ZZI->ZZI_ENTAL       With nHrEntAl
		Replace ZZI->ZZI_SAIAL       With nHrSaiAl
		Replace ZZI->ZZI_ACAO        With cUserName
		Replace ZZI->ZZI_OBSSEG      With cObs
		Replace ZZI->ZZI_DTCHEG      With dDtCheFun

		MsUnlock()                 

		EnviarMail(.T.)      
		Close(oDlgEsFun)

		Msgbox("Cadastro realizado com sucesso!","Mensage","INFO")

	EndIF
Return     

Static function CancelarFun()
	Local lPadrao  

	lPadrao:=Msgbox("Você confirma para carcelar!","Atenção","YESNO")
	if lPadrao 

		dbSelectArea("ZZI")

		RecLock("ZZI",.F.)
		Replace ZZI_STATUS      With "3" 
		Replace ZZI_ACAO        With cUserName 
		MsUnlock()
		Close(oDlgEsFun)      
	EndIf
Return


static function AprovarFun()

	Local lPadrao  
	lPadrao:=Msgbox("Você confirma a aprovação!","Atenção","YESNO")
	if lPadrao 
		dbSelectArea("ZZI")
		RecLock("ZZI",.F.)
		Replace ZZI->ZZI_STATUS      With "1" 
		Replace ZZI->ZZI_NAPROV      With __cUserId
		Replace ZZI->ZZI_NOMEA       With cUserName
		Replace ZZI->ZZI_ACAO        With cUserName 

		MsUnlock()      
		EnviarMail()
		Close(oDlgEsFun)
	EndIF
return 


static function ProceguirFun()
	Local lPadrao  
	lPadrao:=Msgbox("Você confirma esse Prosseguimento !","Atenção","YESNO")       
	if lPadrao 
		dbSelectArea("ZZI")
		RecLock("ZZI",.F.) 
		IF ZZI->ZZI_STATUS == '0'  
			Replace ZZI->ZZI_STATUS With "5"
			IF nRetorno = 'NAO'
				Replace ZZI->ZZI_OK With "OK"             
			EndIF 

		Else 

			if nRetorno = 'NAO'
				Replace ZZI->ZZI_STATUS     With "2"
			Else   
				Replace ZZI->ZZI_STATUS     With "4"
			EndIF        

		EndIF
		Replace ZZI->ZZI_HRENT      With nHrEnt     
		Replace ZZI->ZZI_HRSAI      With nHrSaiRel 
		Replace ZZI->ZZI_DTFIM      With dDtSaiRel
		Replace ZZI->ZZI_HRCHEG     With nHrChegada      
		Replace ZZI->ZZI_HRGAST     With nHrTotal  
		Replace ZZI->ZZI_SEG        With cUserName     
		Replace ZZI->ZZI_OBSSEG     With cObs
		MsUnlock()                     

		IF ZZI->ZZI_STATUS == '5'          
			EnviarMail()  
		ENDIF  
		Close(oDlgEsFun)
	EndIF
Return


static function FinalizarFun()                                                      

	Local lPadrao 

	if empty(cMatSol) 
		alert("Preencha o compo Matricula")    
	ELSEif empty(cMotivo)
		alert("Preencha o compo motivo")    
	Elseif empty(cNomeAprov)        
		alert("Preencha o compo Aprovador")      
	Elseif ZZI->ZZI_TIPO = "HR Extra" .And. Empty(nHrSaiRel)
		alert("Preencha o compo Hora da saída")      
	Elseif ZZI->ZZI_TIPO = "Sem Crachá" .And. Empty(nHrSaiRel)
		alert("Preencha o compo Hora da saída")   
	Elseif ZZI->ZZI_TIPO = "A Serviço" .And. Empty(nHrSaiRel)
		alert("Preencha o compo Hora da saída")   
	Elseif ZZI->ZZI_TIPO = "Atraso" .And. Empty(nHrChegada)
		alert("Preencha o compo Hora da chegada")  
	Elseif Empty(dDtCheFun)
		alert("Preencha o compo data da chegada") 
	ELSE

		lPadrao:=Msgbox("Você confirma essa Finalização!","Atenção","YESNO")
		if lPadrao 
			dbSelectArea("ZZI")
			RecLock("ZZI",.F.) 
			IF ZZI->ZZI_STATUS <> '5'
				Replace ZZI->ZZI_STATUS     with "2"
			END 
			Replace ZZI->ZZI_HRENT      With nHrEnt     
			Replace ZZI->ZZI_HRSAI      With nHrSaiRel 
			Replace ZZI->ZZI_HRCHEG     With nHrChegada
			if Alltrim(nTipoSai) == "HR Extra" .Or. Alltrim(nTipoSai) == "Sem Crachá"  .Or. Alltrim(nTipoSai) == "A trabalho".Or. Alltrim(nTipoSai) == "A Serviço"
				Replace ZZI->ZZI_HRGAST     With 0 
			Else       
				Replace ZZI->ZZI_HRGAST     With nHrTotal  
			EndIF
			Replace ZZI->ZZI_RETORN     With nRetorno  
			Replace ZZI->ZZI_SEG        With cUserName 
			Replace ZZI->ZZI_OK         With "OK"    
			Replace ZZI->ZZI_DTCHEG     With dDtCheFun
			Replace ZZI->ZZI_OBSSEG     With cObs
			MsUnlock()
			Close(oDlgEsFun)
		EndIF
	EndIF 
Return

static function AlterarFun()

	Local lRet := .T.     
	Local lPadrao  

	lPadrao:=Msgbox("Você confirma os dados preenchidos no formulario para Alteração!","Atenção","YESNO")

	If lPadrao 

		If cNivel > 5 
			If opcao = 1
				if empty(cMatSol) .Or. empty(cMotivo) .Or. empty(cNomeAprov) .Or. empty(dDtSol) .Or. empty(nHrEnt) 
					alert("Preencha os compos com ' * '(Asterisco) corretamente...,Existem campos Vazios")    
					lRet := .F.   
				EndIF        
			ElseIf opcao = 2 
				if empty(dDtSaiRel) .Or. empty(dDtSaiTipo) .Or. empty(cMatSol) .Or. empty(cMotivo) .Or. empty(cNomeAprov)  .Or. empty(cHrSaiTipo)  
					alert("Preencha os compos com ' * '(Asterisco) corretamente...,Existem campos Vazios") 
					lRet := .F.   
				EndIF

			Else
				lRet := .T.   
			EndIF
		EndIf

		If lRet 

			dbSelectArea("ZZI")

			RecLock("ZZI",.F.) 

			Replace ZZI_DTSOL       With dDtSol     
			Replace ZZI_HRSOL       With cHrSol  
			Replace ZZI_MAT         With cMatSol 
			Replace ZZI_NOME        With cNomeSol
			Replace ZZI_CCUSTO      With cCcSol
			Replace ZZI_CNOME       With cDescSol                                                                                 
			Replace ZZI_NAPROV      With cAprov
			Replace ZZI_NOMEA       With cNomeAprov   
			Replace ZZI_MOTIVO      With cMotivo 
			Replace ZZI_ESPC        With cDescMotiv 
			Replace ZZI_RETORN      With nRetorno  
			Replace ZZI_TIPO        With nTipoSai       
			Replace ZZI_DTPLAN      With dDtSaiTipo     
			Replace ZZI_HRPLAN      With cHrSaiTipo 
			Replace ZZI_TURNO       With cTurno  
			Replace ZZI_DTFIM       With dDtSaiRel
			Replace ZZI_HRENT       With nHrEnt     
			Replace ZZI_HRSAI       With nHrSaiRel 
			Replace ZZI_HRCHEG      With nHrChegada      
			Replace ZZI_HRGAST      With nHrTotal        
			Replace ZZI_SEG         With cSeg       
			Replace ZZI_FOTO        With cImg    
			Replace ZZI_DTLICE      With dDtLicen
			Replace ZZI_DIALIN      With cDiaLicen  
			Replace ZZI_ENTAL       With nHrEntAl
			Replace ZZI_SAIAL       With nHrSaiAl
			Replace ZZI_ACAO        With cUserName      
			Replace ZZI_OBSSEG      With cObs
			MsUnlock()
			Close(oDlgEsFun)
		EndIF
	EndIF
return

static function ExcluirFun()  
	dbSelectArea("ZZI")
	DbSetOrder(6)     
	DbGotop()

	If DbSeek(cDoc)
		RecLock("ZZI",.F.)
		dbDelete()
		MsunLock()
	EndIF
	Msgbox("O registro foi excluido!","Sucesso!","INFO")                   

	Close(oDlgEsFun)
return

/**********************************************************************************/
User Function GeraSeq (Alias,Campo)
	Local Seq:=1,AuxS

	cQuery:=" select max("+Campo+") as SEQ from "+RetSqlName(ALIAS)+" 
	cQuery := ChangeQuery(cQuery)
	TCQUERY cQuery Alias TMP New 

	DbSelectArea("TMP")
	DbGotop()
	If !Eof()
		Seq:=Val(TMP->SEQ)+1
	EndIf    

	NumSeq:=StrZero(Seq,6)

	DbSelectArea("TMP")
	DbCloseArea()

Return NumSeq    

//Cancelar todos as solicitações fora do dias só para agendamento
User function CanAberto()
	Local dAtual:= Date()      
	x:=1       
	aReg:={}
	Prepare Environment Empresa "01" Filial "01" Tables "ZZI"  

	dbSelectArea("ZZI")
	dbGoTop()                        
	While !EOF()      
		IF ZZI_STATUS = '0' .Or. ZZI_STATUS = '1'

			IF ZZI_DTSOL <> dAtual     
				AAdd(aReg,{ZZI_DOC,Subs(Dtos(ZZI_DTSOL),7,2)+"/"+Subs(Dtos(ZZI_DTSOL),5,2)+"/"+Subs(Dtos(ZZI_DTSOL),3,2),ZZI_HRSOL,ZZI_MAT,ZZI_NOME,ZZI_CCUSTO,ZZI_CNOME,Subs(Dtos(ZZI_DTPLAN),7,2)+"/" + Subs(Dtos(ZZI_DTPLAN),5,2)+"/"+ Subs(Dtos(ZZI_DTPLAN),3,2),ZZI_HRPLAN,ZZI_TIPO,ZZI_RETORN,ZZI_MOTIVO,ZZI_NAPROV,ZZI_IDUSER})           
				EVPED()                                                                                                                                  
				x+=1
			ENDIF      

		ENDIF

		DbSelectArea("ZZI")
		dbSkip() // Avanca o ponteiro do registro no arquivo
	EndDo    

return                                                                         


static function  EVPED()  

	Local _cTo:=alltrim(UsrRetMail(aReg[x][14]))

	oProcess := TWFProcess():New( "000001", "Envia Email" )
	oProcess :NewTask( "100001", "\WORKFLOW\SSI.HTM" )
	oProcess :cSubject := "Solicitação Pendente - Registro de Entrada de Funcionário na NSB"

	oHTML    := oProcess:oHTML          
	cMen := " <html>"
	cMen += " <head>"
	cMen += " <title>Controle de Entrada e Saída de Funcionário</title>"
	cMen += " </head>"    
	cMen += " <body>"
	cMen += ' <table border="1" width="1000px" >'
	cMen += ' <tr align="center" >'

	cMen += ' <td colspan=11 > Solicitação de Entrada e Saída de Funcionário </td></tr>'       
	cMen += ' <tr >'
	cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="2" face="Times">Doc</font></td>'  //[1]
	cMen += ' <td align="center" width="15%"  bgcolor="#FFFFFF"><font size="2" face="Times">Data/Hora</font></td>'  //[2]
	cMen += ' <td align="center" width="3%"  bgcolor="#FFFFFF"><font size="2" face="Times">Matricula</font></td>'  //[3]
	cMen += ' <td align="center" width="40%" bgcolor="#FFFFFF"><font size="2" face="Times">Nome         </font></td>'  //[4]
	cMen += ' <td align="center" width="3%"  bgcolor="#FFFFFF"><font size="2" face="Times">C.C          </font></td>'  //[5]

	cMen += ' <td align="center" width="2%"  bgcolor="#FFFFFF"><font size="2" face="Times">Data saída prevista</font></td>'  //[6]
	cMen += ' <td align="center" width="2%"  bgcolor="#FFFFFF"><font size="2" face="Times">Hora da saída prevista</font></td>'  //[7]
	cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="2" face="Times">Tipo da Solicitação</font></td>'  //[8]
	cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="2" face="Times">Retorno</font></td>'  //[9]
	cMen += ' <td align="center" width="30%" bgcolor="#FFFFFF"><font size="2" face="Times">Motivo</font></td>'  //[10] 
	cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="2" face="Times">Aprovador</font></td>'  //[11]
	cMen += ' </tr>'
	cMen += ' <tr>'
	cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+aReg[x][1]+'</font></td>'  //[1]       
	cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+aReg[x][2]+"/"+aReg[x][3]+'</font></td>'  //[2]
	cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+aReg[x][4]+'</font></td>'  //[3]
	cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+aReg[x][5]+'</font></td>'  //[4]   
	cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+aReg[x][6]+'/'+aReg[x][7]+'</font></td>'  //[5]   

	cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+aReg[x][8]+'</font></td>'  //[6]
	cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+aReg[x][9]+'</font></td>'  //[7]

	cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+aReg[x][10]+'</font></td>'  //[8]
	cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+aReg[x][11]+'</font></td>'  //[9]
	cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+aReg[x][12]+'</font></td>'  //[10]    
	cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+aReg[x][13]+'</font></td>'  //[10]                                                                                 
	cMen += ' </tr>' 
	cMen += ' <tr>'
	cMen += ' <td align="center"  bgcolor="#FFFFFF" colspan=11 ><font size="3" face="Times">Por favor verifique a exclusão ou o cancelamento!</font></td>'  //[10]    
	cMen += ' </tr>'     
	cMen += ' <tr>'
	cMen += ' </tr>'
	cMen += ' </table>'
	cMen += " </body>"
	cMen += " </html>" 
	oHtml:ValByName("MENS", cMen)
	If Right(_cTo,1)==";"
		_cTo:=Substring(_cTo,1,len(_cTo)-1)
	EndIf  

	oProcess:cTo  := _cTo   
	cMailId := oProcess:Start()

return


static function  EnviarMail(lFlag)  

	Local _cTo:=""
	Local supervisor  

	DEFAULT lFlag := .F.


	oProcess := TWFProcess():New( "000001", "Envia Email" )
	oProcess :NewTask( "100001", "\WORKFLOW\SSI.HTM" )
	Do Case
		Case opcao == 1
		oProcess :cSubject := "Registro de Entrada de Funcionário na NSB"
		Case opcao == 2 .And.  Alltrim(nTipoSai) <> "Licença Medica" 
		oProcess :cSubject := "Registro Aberto - Solicitação de Entrada e saída de funcionário"
		Case opcao == 4
		oProcess :cSubject := "Registro Aprovado - Solicitação de Entrada e saída de funcionário"
		Case ZZI->ZZI_STATUS = '5'                                                                  
		oProcess :cSubject := "Registro de saída sem aprovação - Solicitação de Entrada e saída de funcionário"
		Case  Alltrim(nTipoSai) = "Licença Medica"                                                                   
		oProcess :cSubject := "Registro de Licença Medica - Solicitação de Entrada e saída de funcionário"
	EndCase                    

	oHTML    := oProcess:oHTML          
	cMen := " <html>"
	cMen += " <head>"
	cMen += " <title>Controle de Entrada e Saída de Funcionário</title>"
	cMen += " </head>"    
	cMen += " <body>"
	cMen += ' <table border="1" width="1000px" >'
	cMen += ' <tr align="center" >'

	cMen += ' <td colspan=11 > Solicitação de Entrada e Saída de Funcionário </td></tr>'       
	cMen += ' <tr >'
	cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="2" face="Times">Doc</font></td>'  //[1]
	cMen += ' <td align="center" width="15%"  bgcolor="#FFFFFF"><font size="2" face="Times">Data/Hora</font></td>'  //[2]
	cMen += ' <td align="center" width="3%"  bgcolor="#FFFFFF"><font size="2" face="Times">Matricula</font></td>'  //[3]
	cMen += ' <td align="center" width="40%" bgcolor="#FFFFFF"><font size="2" face="Times">Nome         </font></td>'  //[4]
	cMen += ' <td align="center" width="3%"  bgcolor="#FFFFFF"><font size="2" face="Times">C.C          </font></td>'  //[5]
	if opcao = 1
		cMen += ' <td align="center" width="2%"  bgcolor="#FFFFFF"><font size="2" face="Times">Data da Entrada</font></td>'  //[6]
		cMen += ' <td align="center" width="2%"  bgcolor="#FFFFFF"><font size="2" face="Times">Hora da Chegada</font></td>'  //[7]
	Else 
		cMen += ' <td align="center" width="2%"  bgcolor="#FFFFFF"><font size="2" face="Times">Data da Saída</font></td>'  //[6]
		cMen += ' <td align="center" width="2%"  bgcolor="#FFFFFF"><font size="2" face="Times">Hora da Saída</font></td>'  //[7]
	EndIF           

	cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="2" face="Times">Tipo da Solicitação</font></td>'  //[8]
	if Alltrim(nTipoSai) = "Licença Medica"                                                            
		cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="2" face="Times">Data da Licença</font></td>'  //[9] 
		cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="2" face="Times">quantidade de dias</font></td>'  //[9]
	EndIF
	cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="2" face="Times">Retorno</font></td>'  //[9]
	cMen += ' <td align="center" width="30%" bgcolor="#FFFFFF"><font size="2" face="Times">Motivo</font></td>'  //[10] 
	cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="2" face="Times">Aprovador</font></td>'  //[11]
	cMen += ' </tr>'
	cMen += ' <tr>'
	cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+cDoc+'</font></td>'  //[1]       
	cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+Subs(Dtos(dDtSol),7,2) + "/"+Subs(Dtos(dDtSol),5,2)+ "/" + Subs(Dtos(dDtSol),3,2) +"/"+ cHrSol+'</font></td>'  //[2]
	cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+cMatSol+'</font></td>'  //[3]
	cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+cNomeSol+'</font></td>'  //[4]   

	cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+cCcSol+'/'+cDescSol+'</font></td>'  //[5]   

	if opcao = 1
		cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+Subs(Dtos(dDtSaiRel),7,2) + "/" + Subs(Dtos(dDtSaiRel),5,2)+ "/" + Subs(Dtos(dDtSaiRel),3,2) +'</font></td>'  //[6]
		cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+Transform(StrTran(StrZero(nHrChegada,5,2),".",""),"@R !!:!!" )+'</font></td>'  //[7]
	Else
		cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+Subs(Dtos(dDtSaiTipo),7,2) + "/" + Subs(Dtos(dDtSaiTipo),5,2)+ "/" + Subs(Dtos(dDtSaiTipo),3,2) +'</font></td>'  //[6]
		cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+cHrSaiTipo+'</font></td>'  //[7]
	EndIF

	cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+nTipoSai+'</font></td>'  //[8]
	if Alltrim(nTipoSai) = "Licença Medica"                                                            
		cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="2" face="Times">'+Subs(Dtos(dDtLicen),7,2) + "/" + Subs(Dtos(dDtLicen),5,2)+ "/" + Subs(Dtos(dDtLicen),3,2)+'</font></td>'  //[9] 
		cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="2" face="Times">'+cDiaLicen+'</font></td>'  //[9]
	EndIF
	cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+nRetorno+'</font></td>'  //[9]
	cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+cMotivo+'</font></td>'  //[10]    
	cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+cNomeAprov+'</font></td>'  //[10]                                                                                 
	cMen += ' </tr>' 
	cMen += ' <tr>'
	If opcao = 1
		cMen += ' <td align="center"  bgcolor="#FFFFFF" colspan=11 ><font size="3" face="Times">Status : Aprovado a entrada</font></td>'  //[10]    
	elseif opcao = 2 .And.  Alltrim(nTipoSai) <> "Licença Medica"  
		cMen += ' <td align="center"  bgcolor="#FFFFFF" colspan=11 ><font size="3" face="Times">Status :Esperando Aprovação</font></td>'  //[10]        
	elseIf opcao = 4
		cMen += ' <td align="center"  bgcolor="#FFFFFF" colspan=11 ><font size="3" face="Times">Status :Aprovada</font></td>'  //[10] 
	elseIf ZZI->ZZI_STATUS = '5' 
		cMen += ' <td align="center"  bgcolor="#FFFFFF" colspan=11 ><font size="3" face="Times">Saída sem Aprovação</font></td>'  //[10]    
	EndIF
	cMen += ' </tr>'     
	cMen += ' <tr>'
	cMen += ' <td colspan=11 align="center">'
	// cMen += '   <a href="http://nsb44:8081/WebSite/aprovaSiga.html">Click Aqui para Proseguir</a>'
	cMen += ' </td>'
	cMen += ' </tr>'
	cMen += ' </table>'
	cMen += " </body>"
	cMen += " </html>" 

	If  opcao = 1                                                                   
		_cTo := IIF(!lFlag,alltrim(UsrRetMail(cAprov)),"")

		//ADICIONANDO OS SUPEVISORES
		dbSelectArea("ZZS")
		dbGoTop()
		While !EOF()

			IF ZZS->ZZS_CCUSTO == cCcSol .And. alltrim(subStr(ZZS->ZZS_WORKF,1,LEN(ZZS->ZZS_WORKF))) == "S"  //SE O CENTRO DE CUSTO DO FUNCIONÁRIO IGUAL AO DO SUPERVIDOR E ENVAR FOR VERDADEIRO //retorna verdadeiro ou falso
				_cTo += ';'+alltrim(UsrRetMail(ZZS->ZZS_USER))
			EndIF

			DbSelectArea("ZZS")
			dbSkip() // Avanca o ponteiro do registro no arquivo
		EndDo

	ElseIF opcao = 4
		_cTo := alltrim(UsrRetMail(ZZI->ZZI_IDUSER))
	ElseIF opcao = 2 .Or. ZZI->ZZI_STATUS = '5'   

		_cTo := alltrim(UsrRetMail(cAprov))+';'+ alltrim(UsrRetMail(__cUserId))+';'

		//ADICIONANDO OS SUPEVISORES
		dbSelectArea("ZZS")
		dbGoTop()
		While !EOF()
			nTam:= len(ZZS->ZZS_WORKF)                                      
			//SE ALTERAR A PERMIÇÃO DE WORKFLOK TEM QUE ALTERAR DAS OUTRAS ROTINA DO MODULO DE PORTARIA EXEMPLO: SSSN
			IF ZZS->ZZS_CCUSTO == cCcSol .And. Alltrim(ZZS->ZZS_WORKF)=="SS" .And. Alltrim(ZZS->ZZS_SUPERV)== "SIM" //SE O CENTRO DE CUSTO DO FUNCIONÁRIO IGUAL AO DO SUPERVIDOR E ENVAR FOR VERDADEIRO //retorna verdadeiro ou falso
				_cTo += alltrim(UsrRetMail(ZZS->ZZS_USER))+';'
			EndIF

			DbSelectArea("ZZS")
			dbSkip() // Avanca o ponteiro do registro no arquivo
		EndDo


	EndIF         

	oHtml:ValByName("MENS", cMen)
	If Right(_cTo,1)==";"
		_cTo:=Substring(_cTo,1,len(_cTo)-1)
	EndIf  

	oProcess:cTo  := _cTo   
	cMailId := oProcess:Start()

return
/******************************************************************************************************************************************************************/