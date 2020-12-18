// #########################################################################################
// Projeto:Controle de agendamento de serviços de metrologia
// Modulo :SIGAESP/ Metrologia
// Fonte  : SolMetrologia
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 06/02/12 | William Rodrigues | Gerado pelo Assistente de Código
// ---------+-------------------+-----------------------------------------------------------

#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include 'libnsb.prw'


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} novo
Permite a manutenção de dados armazenados em ZZM.

@author    TOTVS Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     6/02/2012
/*/
//------------------------------------------------------------------------------------------
user function SOLMETROLO()
//--< variáveis >---------------------------------------------------------------------------
	local cOpcao :=0
//Indica a permissão ou não para a operação (pode-se utilizar 'ExecBlock')
	local cVldAlt := ".T." // Operação: ALTERAÇÃO
	local cVldExc := ".T." // Operação: EXCLUSÃO

//trabalho/apoio
	local cAlias
//Email das pessoas/ solicitante
	private _cTo:=""
	private cEmailTec  :="weber@nippon-seikibr.com.br"
	private cEmailAprov:="darlan.alves@nippon-seikibr.com.br;ronaldob@nippon-seikibr.com.br"
//Status da solicitação
	private cStatu

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
cCCSoli            := alltrim(Posicione("SRA",1,xFilial("SRA") + cMatSol,"RA_CC"))
cDescSol           := alltrim(Posicione("CTT",1,xFilial("CTT") + cCCSoli,"CTT_DESC01"))
cUser              := __cUserId  
//--< procedimentos >-----------------------------------------------------------------------
	cAlias := "ZZM"
	chkFile(cAlias)
	dbSelectArea(cAlias)
//indices
	dbSetOrder(1)
	
	Private cCadastro := "Cadastro de Entrada e saída"

		
Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","U_VisFmMetro",0,2} ,;
             {"Incluir","U_CadFmMetro",0,3} ,;
             {"Alterar","U_AltFmMetro",0,4} ,; 
             {"&Excluir","U_ExcFmMetro",0,5} ,;
             {"Iniciar","U_IniFmMetro",0,6},; 
             {"Finalizar","U_FimFmMetro",0,7},;
             {"Aprovar","U_AproFmMetro",0,8},;
             {"Cancelar","U_CanFmMetro",0,9},;   
             {"Relatório","",0,10},;                
             {"Legenda"   ,"U_ESFULeng",0,11}}   
             
Private aCores 	  := {{ "ZZM->ZZM_STATUS=='0'", 'BR_AZUL' },;     // Aberto AxInclui
		              { "ZZM->ZZM_STATUS=='1'", 'BR_VERDE'  },;     // Aprovado
		              { "ZZM->ZZM_STATUS=='2'", 'BR_VERMELHO' },;     // Realizado finalizado
				      { "ZZM->ZZM_STATUS=='3'", 'BR_PRETO'},;     // Nao Realizado 
				      { "ZZM->ZZM_STATUS=='4'", 'BR_AMARELO'},;     // Em Andamento
				      { "ZZM->ZZM_STATUS=='5'", 'BR_LARANJA'}}    // Nao houve aprovacão e o funcionário saio

//	setKey(123, nil) // Desativa a tecla F12 para acionamento dos parametros
  

     mBrowse(6,1,22,75,cAlias,,,,,,aCores)
    
return
	
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Cadastro  da requisição														 //
// 1 - Cadastro 
// 2 - Visualizar 
// 3 - Aprovar
// 4 - Alterar
// 5 - Cancelar
// 6 - Proceguir
// 7 - Finalizar
// 8 - Excluir
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/	


STATIC Function FormMetrologia()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private cAprov     := Space(1)
Private cCodObj    := Space(3)
Private cCodPro    := Space(15)
Private cDecServ  
Private cCodForn   := Space(6)
Private cDescObj   := Space(60)
Private cDescPro   := Space(60)
Private cDescPropr := Space(60)
Private cDoc       := GeraSeq("ZZM","ZZM_DOC")
Private cFornecedo := Space(60)
Private cMat       := Space(6)
Private cNome  
Private cCusto
Private cCDesc
Private cModelo    := Space(60)
Private cNaprov    := Space(60)
    
Private cNomeFor   
Private cNomeTec   := Space(60)
Private cObserv    := Space(60)
Private cParecer  
Private cPropri    := Space(1)
Private cSeppen    := Space(10)
Private cTecnico   := Space(6)

Private dDtEntrega := CtoD(" ")
Private dDtPrevist := CtoD(" ")
Private dDtReg     := date()
Private dDtSai     := CtoD(" ")
Private nResultado

If (cOpcao > 1)
visuSol()
EndIf
If (cOpcao = 6)
cNomeTec   :=cUserName 
cTecnico   :=cMatSol
dDtEntrega:=date()
EndIf

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oObrigator","oDlg1","oFld1","oGrp1","oSay9","oSay10","oSay11","oDtEntrega","oDtPrevista","oObserv")
SetPrvt("oSay12","oSay13","oSay14","oSay15","oSay16","oDtSai","oParecer","oTecnico","oNomeTec","oResultado","oCDesc","cCusto")
SetPrvt("oSay17","oSay18","oSay19","oSay20","oSay21","oSay22","oDoc","oDtReg","oMat","oNome","oGet21")
SetPrvt("oGrp5","oSay3","oSay2","oSay4","oSay5","oSay6","oSay23","oSay24","oNomeFor","oSay26")
SetPrvt("oSay1","oSay7","oSay8","oCodPro","oDescPro","oModelo","oSeppen","oFornecedor","oGet25","oCodObj")
SetPrvt("oPropri","oDescPropri","oDecServ","oAprov","oNaprov")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

oObrigator := TFont():New( "MS Sans Serif",0,-11,,.T.,0,,380,.F.,.F.,,,,,, )
oDlg1      := MSDialog():New( 084,279,703,1106,"Solicitação de servço de Metrologia v1.0",,,.F.,,,,,,.T.,,,.T. )
oDlg1:bInit := {||EnchoiceBar(oDlg1,{||redirecionar()},{||oDlg1:end()},.F.,{})}

oFld1      := TFolder():New( 016,004,{"Dados da solicitação","Dados Técnicos"},{},oDlg1,,,,.T.,.F.,396,284,) 

oGrp1      := TGroup():New( 004,004,040,388,"Dados em andamento",oFld1:aDialogs[2],CLR_BLACK,CLR_WHITE,.T.,.F. )

oSay9      := TSay():New( 012,008,{||"Dt. ini. Atividade:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
oSay10     := TSay():New( 012,064,{||"Dt. Prevista:"},oGrp1,,oObrigator,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,060,008)
oSay11     := TSay():New( 012,120,{||"Observação"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oDtEntrega := TGet():New( 020,008,{|u| If(PCount()>0,dDtEntrega:=u,dDtEntrega)},oGrp1,040,008,'',,CLR_BLACK,CLR_WHITE,oObrigator,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDtEntrega",,)
oDtPrevist := TGet():New( 020,064,{|u| If(PCount()>0,dDtPrevista:=u,dDtPrevista)},oGrp1,040,008,'',,CLR_BLACK,CLR_WHITE,oObrigator,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDtPrevista",,)
oObserv    := TGet():New( 020,120,{|u| If(PCount()>0,cObserv:=u,cObserv)},oGrp1,264,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cObserv",,)

oGrp2      := TGroup():New( 048,004,264,388,"Relatório técnico",oFld1:aDialogs[2],CLR_BLACK,CLR_WHITE,.T.,.F. )

oSay12     := TSay():New( 060,008,{||"Dt da entrega"},oGrp2,,oObrigator,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,040,008)
oSay13     := TSay():New( 060,064,{||"Resultado"},oGrp2,,oObrigator,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,032,008)
oSay14     := TSay():New( 108,008,{||"Parecer Técnoco"},oGrp2,,oObrigator,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,044,008)
oSay15     := TSay():New( 080,008,{||"Tecnico"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay16     := TSay():New( 080,064,{||"Nome do Tecnico"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oDtSai     := TGet():New( 068,008,{|u| If(PCount()>0,dDtSai:=u,dDtSai)},oGrp2,040,008,'',{||dtEntregaF()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDtSai",,)

oTecnico   := TGet():New( 088,008,{|u| If(PCount()>0,cTecnico:=u,cTecnico)},oGrp2,040,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cTecnico",,)
oNomeTec   := TGet():New( 088,064,{|u| If(PCount()>0,cNomeTec:=u,cNomeTec)},oGrp2,320,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cNomeTec",,)
oResultado := TComboBox():New( 068,064,{|u| If(PCount()>0,nResultado:=u,nResultado)},{"","APROVADO","APROVADO CONDICIONAL","REPROVADO"},072,010,oGrp2,,,{||resultado()},CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nResultado )
oParecer   := TMultiGet():New( 116,008,{|u| If(PCount()>0,cParecer:=u,cParecer)},oGrp2,376,140,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )



oGrp4      := TGroup():New( 006,004,078,384,"Dados do solicitante",oFld1:aDialogs[1],CLR_BLACK,CLR_WHITE,.T.,.F. )

oSay17     := TSay():New( 014,012,{||"Documento"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay18     := TSay():New( 014,064,{||"Dt. Registro"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay19     := TSay():New( 034,012,{||"Matricula"},oGrp4,,oObrigator,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,032,008)
oSay20     := TSay():New( 034,064,{||"Nome "},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay21     := TSay():New( 054,012,{||"C. Custo"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay22     := TSay():New( 054,064,{||"Descrição"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)

oDoc       := TGet():New( 022,012,{|u| If(PCount()>0,cDoc:=u,cDoc)},oGrp4,040,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDoc",,)
oDtReg     := TGet():New( 022,064,{|u| If(PCount()>0,dDtReg:=u,dDtReg)},oGrp4,044,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDtReg",,)
oMat       := TGet():New( 042,012,{|u| If(PCount()>0,cMat:=u,cMat)},oGrp4,040,008,'999999',{||achasol()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cMat",,)
oNome      := TGet():New( 042,064,{|u| If(PCount()>0,cNome:=u,cNome)},oGrp4,316,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cNome",,)
cCusto     := TGet():New( 062,012,{|u| If(PCount()>0,cCusto:=u,cCusto)},oGrp4,040,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cCusto",,)
oCDesc     := TGet():New( 062,064,{|u| If(PCount()>0,cCDesc:=u,cCDesc)},oGrp4,316,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cCDesc",,)

oGrp5      := TGroup():New( 084,004,264,384,"Dados para preencher",oFld1:aDialogs[1],CLR_BLACK,CLR_WHITE,.T.,.F. )

oSay3      := TSay():New( 092,012,{||"Aprovador"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
oSay2      := TSay():New( 092,064,{||"Nome do Aprovador"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,144,008)
oAprov     := TGet():New( 100,012,{|u| If(PCount()>0,cAprov:=u,cAprov)},oGrp5,040,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cAprov",,)
oNaprov    := TGet():New( 100,064,{|u| If(PCount()>0,cNaprov:=u,cNaprov)},oGrp5,316,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cNaprov",,)



oSay4      := TSay():New( 112,012,{||"Cod. Produto"},oGrp5,,oObrigator,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,048,008)
oSay5      := TSay():New( 112,064,{||"Descrição do produto"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,008)
oSay6      := TSay():New( 112,245,{||"Modelo"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay23     := TSay():New( 112,312,{||"Seppen"},oGrp5,,oObrigator,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,032,008)
oSay24     := TSay():New( 132,012,{||"Cod. Fornecedor"},oGrp5,,oObrigator,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,060,008)
oNomeFor   := TSay():New( 132,064,{||"Fornecedor"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay26     := TSay():New( 152,012,{||"Cod. Obj. Aval."},oGrp5,,oObrigator,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,040,008)
oSay27     := TSay():New( 152,064,{||"Descrição do Objetivo da  avaliação"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,092,008)
oSay1      := TSay():New( 172,012,{||"Cod. Prioridade"},oGrp5,,oObrigator,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,060,008)
oSay7      := TSay():New( 172,064,{||"Descrição prioridade"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,056,008)
oSay8      := TSay():New( 192,012,{||"Descrição do serviço solicitado(Descrever o que deverá ser mensurado na medição, relate da forma mais clara e objetiva)"},oGrp5,,oObrigator,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,360,008)
//SB1010
oCodPro    := TGet():New( 120,012,{|u| If(PCount()>0,cCodPro:=u,cCodPro)},oGrp5,040,008,'@!',{||achaProd()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ALT","cCodPro",,)
oDescPro   := TGet():New( 120,64,{|u| If(PCount()>0,cDescPro:=u,cDescPro)},oGrp5,170,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDescPro",,)
oModelo    := TGet():New( 120,245,{|u| If(PCount()>0,cModelo:=u,cModelo)},oGrp5,060,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cModelo",,)
oSeppen    := TGet():New( 120,312,{|u| If(PCount()>0,cSeppen:=u,cSeppen)},oGrp5,068,008,'@!',{||valSeppen()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cSeppen",,)
oGet25     := TGet():New( 140,012,{|u| If(PCount()>0,cCodForn:=u,cCodForn)},oGrp5,040,008,'@!',{||getFornecedor()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA2MT","cCodForn",,)
//SA2MT
oFornecedo := TGet():New( 140,064,{|u| If(PCount()>0,cFornecedor:=u,cFornecedor)},oGrp5,316,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cFornecedor",,)
oCodObj    := TGet():New( 160,012,{|u| If(PCount()>0,cCodObj:=u,cCodObj)},oGrp5,040,008,'@!',{||getObjetivo()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"MO","cCodObj",,)
oDescObj   := TGet():New( 160,064,{|u| If(PCount()>0,cDescObj:=u,cDescObj)},oGrp5,316,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDescObj",,)
oPropri    := TGet():New( 180,012,{|u| If(PCount()>0,cPropri:=u,cPropri)},oGrp5,040,008,'@!',{||getPrioridade()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ZG","cPropri",,)
oDescPropr := TGet():New( 180,064,{|u| If(PCount()>0,cDescPropri:=u,cDescPropri)},oGrp5,060,008,'@!',{||getDesc()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDescPropri",,)
oDecServ   := TMultiGet():New( 200,012,{|u| If(PCount()>0,cDecServ:=u,cDecServ)},oGrp5,356,036,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )

desabilidados()
//alterar solicitante
IF(cOpcao==1 .Or. cOpcao==4 )
 	oMat        :enable()
 	oCodPro     :enable() 
 	oSeppen     :enable() 
 	oCodObj     :enable()
	oPropri     :enable()
	oDecServ    :enable()
	oGet25      :enable() 
//visualizar todos 
ELSEIF(cOpcao==2)
	oFld1:aDialogs[2]:enable()
ELSEIF(cOpcao==3)
	oDtPrevist  :enable()
    oObserv     :enable() 
    oFld1:aDialogs[2]:enable()
ElseIf (cOpcao == 6)
    oFld1:aDialogs[2]:enable()
    oDtPrevist  :enable()
    oObserv      :enable()
ElseIf (cOpcao == 7)
    oFld1:aDialogs[2]:enable()
    oResultado	:enable()
	oParecer	:enable()
	oDtSai		:enable()
ElseIf (cOpcao == 5)
	oFld1:aDialogs[2]:enable()
ElseIf (cOpcao == 8)
	oFld1:aDialogs[2]:enable()
//alterar tecnico
ElseIf (cOpcao == 9)
	oFld1:aDialogs[2]:enable()
    oDtPrevist  :enable()
    oObserv      :enable()
EndIF

oDlg1:Activate(,,,.T.)

Return

//Desabilita os campos

static function desabilidados()
oCodPro     :disable()
oDescPro    :disable()
oModelo     :disable()
oSeppen     :disable()
oGet25      :disable()
//SA2MT
oFornecedo :disable()
oCodObj     :disable()
oDescObj    :disable()
oPropri     :disable()
oDescPropr  :disable()
oDecServ    :disable()

oAprov      :disable()
oNaprov     :disable()

oDoc        :disable()
oDtReg      :disable()
oMat        :disable()
oNome       :disable()
cCusto      :disable()
oCDesc      :disable()

oDtSai      :disable()
oParecer    :disable()
oTecnico    :disable()
oNomeTec    :disable()
oResultado  :disable()

oDtEntrega  :disable()
oDtPrevist  :disable()
oObserv      :disable()

oFld1:aDialogs[2]:disable()
return

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Cadastro  da requisição														 //
// 1 - Cadastro 
// 2 - Visualizar 
// 3 - Aprovar
// 4 - Alterar
// 5 - Cancelar
// 6 - Proceguir
// 7 - Finalizar
// 8 - Excluir
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/	


User function CadFmMetro()
	cOpcao:=1
	_cTo:= alltrim(UsrRetMail(__cUserId))+';'+cEmailTec+";"+cEmailAprov
	FormMetrologia()
	
return

User function VisFmMetro()
	cOpcao:=2
   
	//CHAMA A TELA   
	FormMetrologia()
    /*
	ZZM->ZZM_DOC		
	ZZM->ZZM_DTREG	:=dDtReg	
	ZZM->ZZM_MAT		:=cMat
	ZZM->ZZM_NOME		:=cNome
	ZZM->ZZM_CUSTO	:=cCusto
	ZZM->ZZM_CDESC	:=CCDesc
	ZZM->ZZM_NUMAP	:=cAprov	
	ZZM->ZZM_NOMEAP	:=cNaprov
	ZZM->ZZM_CODPRO	:=cCodPro
	ZZM->ZZM_MATDES	:=cDescPro
	ZZM->ZZM_MODELO	:=cModelo
	ZZM->ZZM_SEPPEN	:=cSeppen
	ZZM->ZZM_CODFOR	:=cCodForn
	ZZM->ZZM_DESFOR	:=cFornecedor
	ZZM->ZZM_CODOBJ	:=cCodObj
	ZZM->ZZM_DESOBJ	:=cDescObj
	ZZM->ZZM_CODPRI	:=cPropri
	ZZM->ZZM_DESCPR	:=cDescPropr
	ZZM->ZZM_DESCSO	:=cDecServ
	ZZM->ZZM_DTINI	:=dDtEntrega
	ZZM->ZZM_DTPREV	:=dDtPrevist
	ZZM->ZZM_DTENTR	:=dDtSai
	ZZM->ZZM_OBSERV	:=cObserv
	ZZM->ZZM_RESULT	:=nResultado
	ZZM->ZZM_TEC		:=cTecnico
	ZZM->ZZM_NOMETC	:=cNomeTec
	ZZM->ZZM_PARECE   :=cParecer
	*/
	
return

User function AproFmMetro()
//para adicionar mais pessoas (cMatSol == '000512') .or. cMatSol == '000512'))
//(cMatSol == '000473' .or. cMatSol == '000357')
   IF (cMatSol == '000118' .Or. cMatSol == '000945' .Or. cMatSol == '000029') .And. (ZZM->ZZM_STATUS == '0')  
   		cOpcao:=3    	
   		_cTo:= ZZM->ZZM_EMAILS+';'+cEmailTec
   		FormMetrologia()
   		
   Else
   		MsgAlert("Sr(a) "+AllTrim(cUserName)+" Você não pode aprovar!","Atenção")
   EndIF

return

User function AltFmMetro()
 IF (ZZM->ZZM_STATUS <> '2') .And.(cMatSol <> '000512')
    cOpcao:=4   	
    _cTo:= ZZM->ZZM_EMAILS+';'+cEmailTec+";"+cEmailAprov
   	FormMetrologia()
   //se igual ao tecnico  
   ElseIF (cMatSol == '000473') .AND. ZZM->ZZM_STATUS == '4'
    cOpcao:=9  	
   	FormMetrologia()
   Else
   	MsgAlert("Sr(a) "+AllTrim(cUserName)+" Você não pode Alterar essa solicitação!","Atenção")   	
   EndIF
return

User function CanFmMetro()
//para adicionar mais pessoas (cMatSol == '000512') .or. cMatSol == '000512'))
   IF (cMatSol == ZZM->ZZM_MAT .Or. cMatSol == '000118' .Or. cMatSol == '000029' .Or. cMatSol =="000945") .And. (ZZM->ZZM_STATUS <> '2')
    cOpcao:=5    	
    _cTo:= ZZM->ZZM_EMAILS+';'+cEmailTec
   	FormMetrologia()
   Else
   	MsgAlert("Sr(a) "+AllTrim(cUserName)+" Você não pode cancelar essa solicitação!","Atenção")
   EndIF
return

User function IniFmMetro()
//para adicionar mais pessoas (cMatSol == '000512') .or. cMatSol == '000512'))
IF (cMatSol == '000118' .Or. cMatSol == '000945' .Or. cMatSol == '000029')  .And. (ZZM->ZZM_STATUS == '1')
     cOpcao:=6    
     _cTo:= ZZM->ZZM_EMAILS+';'+cEmailTec
   	FormMetrologia()
   Else
   	MsgAlert("Sr(a) "+AllTrim(cUserName)+" Você não pode iniciar essa solicitação!","Atenção")
   EndIF
return

User function FimFmMetro()
//para adicionar mais pessoas (cMatSol == '000512') .or. cMatSol == '000512'))
IF (cMatSol == '000473' .or. cMatSol == '000357') .And. (ZZM->ZZM_STATUS == '4')
    cOpcao:=7    	
     _cTo:= ZZM->ZZM_EMAILS+';'+cEmailTec+";"+cEmailAprov
   	FormMetrologia()
   Else
   	MsgAlert("Sr(a) "+AllTrim(cUserName)+" Você não pode finalizar essa solicitação!","Atenção")
   EndIF
return

User function ExcFmMetro()

IF (cMatSol == ZZM->ZZM_MAT) .And. (ZZM->ZZM_STATUS <> '2')
    cOpcao:=8    	
   	FormMetrologia()
   Else
   	MsgAlert("Sr(a) "+AllTrim(cUserName)+" Você não pode excluir essa solicitação!","Atenção")
   EndIF

return



/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Cadastro  da requisição														 //
// 1 - Cadastro 
// 2 - Visualizar 
// 3 - Aprovar
// 4 - Alterar
// 5 - Cancelar
// 6 - Proceguir
// 7 - Finalizar
// 8 - Excluir
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/	
static Function redirecionar()
	Local bValCam := .F.	
	
	IF cOpcao ==1
	//Validar se os campos estam preenchidos
	if achasol() .And. achaProd()  .And. getDesc() .And. valSeppen() .And. getFornecedor()
	 if empty(cCodObj) .Or. empty(cPropri) 
	 MsgInfo("Preenchas os campos vazios!","Atenção")
	 else
     MsgRun(OemToAnsi('Gerando o Chamado.... Aguarde....'),'',{|| CursorWait(),cadSol(),CursorArrow()})
	 bValCam:=.T.
	 EndIF
	EndIF 
	 
	ElseIf cOpcao ==2
	bValCam:=.T.
	oDlg1:end()
	ElseIf cOpcao ==3
	if dDtPrevist == CtoD(" ") 
	 	MsgInfo("Preenchas o campo Data Prevista!","Atenção")
	Else
		MsgRun(OemToAnsi('Aprovando o Chamado.... Aguarde....'),'',{|| CursorWait(),aproSol(),CursorArrow()})	
		bValCam:=.T. 
	EndIF 
	
	ElseIf cOpcao ==4
	 if empty(cCodObj) .Or. empty(cPropri) 
	 MsgInfo("Preenchas os campos vazios!","Atenção")
	 else
	 altSol()
	 bValCam:=.T.
	 EndIf
	ElseIf cOpcao ==5
	canSol()
	bValCam:=.T.
	ElseIf cOpcao ==6
	
	if dDtPrevist == CtoD(" ") 
	 MsgInfo("Preenchas o campo Data Prevista!","Atenção")
	 bValCam:=.F.
	 else
     iniSol()
	 bValCam:=.T.
	 EndIF
	
	ElseIf cOpcao ==7
	IF dtEntregaF() .And. resultado() .And. parecerF()
	 bValCam:=.T.
	 MsgRun(OemToAnsi('Finalizando o Chamado.... Aguarde....'),'',{|| CursorWait(),finalSol(),CursorArrow()})
	EndiF
	
	ElseIf cOpcao ==8
	delSol()
	ElseIf cOpcao ==9
	 if dDtPrevist == CtoD(" ") 
	 MsgInfo("Preenchas o campo Data Prevista!","Atenção")
	 bValCam:=.F.
	 else
	 altTec()
	 bValCam:=.T.
	 EndiF
	EndIF
	
	
Return(bValCam)
//--------------------------< Pessistência no banco de dados ZZM >---------------//
static Function cadSol()
		
Local bVal :=  MsgNoYes("Você confirma os dados","Atenção")

IF bVal
    RecLock("ZZM",.T.)
    ZZM->ZZM_FILIAL   :=xFilial()
	ZZM->ZZM_DOC		:=GeraSeq("ZZM","ZZM_DOC")
	ZZM->ZZM_DTREG	:=dDtReg
	ZZM->ZZM_MAT		:=cMat
	ZZM->ZZM_NOME		:=cNome
	ZZM->ZZM_CUSTO	:=cCusto 
	ZZM->ZZM_CDESC	:=CCDesc
	ZZM->ZZM_NUMAP	:=cAprov	
	ZZM->ZZM_NOMEAP	:=cNaprov
	ZZM->ZZM_CODPRO	:=cCodPro
	ZZM->ZZM_MATDES	:=cDescPro
	ZZM->ZZM_MODELO	:=cModelo
	ZZM->ZZM_SEPPEN	:=cSeppen
	ZZM->ZZM_CODFOR	:=cCodForn
	ZZM->ZZM_DESFOR	:=cFornecedor
	ZZM->ZZM_CODOBJ	:=cCodObj
	ZZM->ZZM_DESOBJ	:=cDescObj
	ZZM->ZZM_CODPRI	:=cPropri
	ZZM->ZZM_DESCPR	:=cDescPropr
	ZZM->ZZM_DESCSO	:=cDecServ
	ZZM->ZZM_STATUS	:='0'
	ZZM->ZZM_ACAO		:=cUserName
	ZZm->ZZM_EMAILS   :=alltrim(UsrRetMail(__cUserId))
     _cTo:=";"+alltrim(UsrRetMail(__cUserId))
	MsUnlock()
	MsgInfo("Cadastro realizado com sucesso, Documento :"+cDoc,"Sucesso") 
	EnviarMail()    	
oDlg1:end()
EndIF
Return bVal

static Function altSol()
		
Local bVal :=  MsgNoYes("Você confirma a alteração dos dados","Atenção")

IF bVal
    RecLock("ZZM",.F.)

	ZZM->ZZM_DTREG	:=dDtReg
	ZZM->ZZM_MAT		:=cMat
	ZZM->ZZM_NOME		:=cNome
	ZZM->ZZM_CUSTO	:=cCusto 
	ZZM->ZZM_CDESC	:=CCDesc
	ZZM->ZZM_NUMAP	:=cAprov	
	ZZM->ZZM_NOMEAP	:=cNaprov
	ZZM->ZZM_CODPRO	:=cCodPro
	ZZM->ZZM_MATDES	:=cDescPro
	ZZM->ZZM_MODELO	:=cModelo
	ZZM->ZZM_SEPPEN	:=cSeppen
	ZZM->ZZM_CODFOR	:=cCodForn
	ZZM->ZZM_DESFOR	:=cFornecedor
	ZZM->ZZM_CODOBJ	:=cCodObj
	ZZM->ZZM_DESOBJ	:=cDescObj
	ZZM->ZZM_CODPRI	:=cPropri
	ZZM->ZZM_DESCPR	:=cDescPropr
	ZZM->ZZM_DESCSO	:=cDecServ
	ZZM->ZZM_ACAO		:=cUserName
	MsUnlock()
	MsgInfo("Alteração realizado com sucesso, Documento :"+cDoc,"Sucesso")   
	
	EnviarMail()   	
oDlg1:end()
EndIF
Return bVal
static Function aproSol()
Local bVal :=  MsgNoYes("Você confirma essa aprovação","Atenção")

IF bVal
 RecLock("ZZM",.F.)
 	ZZM->ZZM_NUMAP	:=cMatSol	
	ZZM->ZZM_NOMEAP	:=cUserName
	ZZM->ZZM_STATUS	:='1'
 MsUnlock()
	MsgInfo("Documento :"+cDoc+" Foi aprovado com  sucesso","Sucesso")  
	EnviarMail()   	
oDlg1:end()		
EndIF
	
Return bVal

static Function iniSol()
Local bVal :=  MsgNoYes("Você confirma iniciar essa solicitação","Atenção")

IF bVal
 RecLock("ZZM",.F.)
	ZZM->ZZM_TEC		:=cMatSol	
	ZZM->ZZM_NOMETC	:=cUserName
	ZZM->ZZM_DTPREV	:=dDtPrevist
	ZZM->ZZM_DTINI	:=dDtEntrega
	ZZM->ZZM_OBSERV	:=cObserv
	ZZM->ZZM_STATUS	:='4'
 MsUnlock()
	MsgInfo("Documento :"+cDoc+" Foi iniciado com  sucesso","Sucesso")    
	EnviarMail()	
oDlg1:end()		
EndIF		
	
	
Return bVal

static Function altTec()
Local bVal :=  MsgNoYes("Você confirma Alteração essa solicitação","Atenção")

IF bVal
 RecLock("ZZM",.F.)
	ZZM->ZZM_TEC		:=cMatSol	
	ZZM->ZZM_NOMETC	:=cUserName
	ZZM->ZZM_DTPREV	:=dDtPrevist
	ZZM->ZZM_DTINI	:=dDtEntrega
	ZZM->ZZM_OBSERV	:=cObserv
	ZZM->ZZM_STATUS	:='4'
 MsUnlock()
	MsgInfo("Documento :"+cDoc+" Foi alterado com  sucesso","Sucesso")    	
oDlg1:end()		
EndIF		
	
	
Return bVal


static Function finalSol()

Local bVal :=  MsgNoYes("Você confirma a finalização!","Atenção")

IF bVal
 RecLock("ZZM",.F.)
    ZZM->ZZM_DTENTR	:=dDtSai
	ZZM->ZZM_RESULT	:=nResultado
	ZZM->ZZM_PARECE   :=cParecer
	ZZM->ZZM_STATUS	:='2'
 MsUnlock()
	MsgInfo("Documento :"+cDoc+" Foi finalizado com  sucesso","Sucesso")
	EnviarMail()    	
 oDlg1:end()
		   	
EndIF		
	
	
Return bVal


static Function canSol()
Local bVal :=  MsgNoYes("Você confirma o cancelamento!","Atenção")

IF bVal

	    RecLock("ZZM",.F.)
		ZZM->ZZM_STATUS	:='3'
		MsunLock()

	MsgInfo("Documento :"+cDoc+" Foi cancelado com  sucesso","Sucesso") 
	EnviarMail()   	
 oDlg1:end()

EndiF		
	
	
Return nil

static Function delSol()

Local bVal :=  MsgNoYes("Você confirma a exclusão!","Atenção")

IF bVal

dbSelectArea("ZZM")
DbSetOrder(1)     
DbGotop()
          
If DbSeek(xFilial()+cDoc)
	    RecLock("ZZM",.F.)
		dbDelete()
		MsunLock()
EndIF
	MsgInfo("Documento :"+cDoc+" Foi Excluido com  sucesso","Sucesso")    	
 oDlg1:end()

EndiF
	
Return nil

Static Function visuSol()
		
	cDoc  		:=ZZM->ZZM_DOC		
	dDtReg		:=ZZM->ZZM_DTREG		
	cMat		:=ZZM->ZZM_MAT		
    cNome		:=ZZM->ZZM_NOME	
	cCusto		:=ZZM->ZZM_CUSTO	
	CCDesc		:=ZZM->ZZM_CDESC	
	cAprov		:=ZZM->ZZM_NUMAP		
	cNaprov	:=ZZM->ZZM_NOMEAP	
	cCodPro	:=ZZM->ZZM_CODPRO	
	cDescPro	:=ZZM->ZZM_MATDES	
	cModelo	:=ZZM->ZZM_MODELO
	cSeppen	:=ZZM->ZZM_SEPPEN	
	cCodForn	:=ZZM->ZZM_CODFOR	
	cFornecedor:=ZZM->ZZM_DESFOR	
	cCodObj	:=ZZM->ZZM_CODOBJ	
	cDescObj	:=ZZM->ZZM_DESOBJ	
	cPropri	:=ZZM->ZZM_CODPRI	
	cDescPropr	:=ZZM->ZZM_DESCPR
	cDecServ	:=ZZM->ZZM_DESCSO	
	dDtEntrega	:=ZZM->ZZM_DTINI	
	dDtPrevist	:=ZZM->ZZM_DTPREV	
	dDtSai		:=ZZM->ZZM_DTENTR
	cObserv	:=ZZM->ZZM_OBSERV	
	nResultado	:=ZZM->ZZM_RESULT	
	cTecnico	:=ZZM->ZZM_TEC		
	cNomeTec	:=ZZM->ZZM_NOMETC	
	cParecer	:=ZZM->ZZM_PARECE
	
Return nil




//---------------------------< Funções do programas >----------------------------//
static Function getDesc()
	Local bAchou :=.F.	
	If Empty(cDecServ)
	bAchou :=.F.
	MsgInfo("Preencha o Descrição do serviço","Atenção")
	Else
	bAchou :=.T.
	EndIF
Return bAchou


//Pesquisar solicitante
static function achasol()
	Local bAchou :=.F.
	Local aDados := {}
	//retorna os dados do funcionário
	aDados:= FunPesq(cMat)  

	if(aDados[1][1])
		cMat	:=aDados[1][2]//MATRICULA  
		cNome  :=aDados[1][3]//NOME DO FUNCIONARIO
		cCusto :=aDados[1][4]//CENTRO DE CUSTO
		cCDesc :=aDados[1][5]//DESCRIÇÃO DO CENTRO DE CUSTO
	
	Else
		MsgInfo("Funcionário não foi encontrado!","Atenção")
	EndIF
	
   bAchou := aDados[1][1]

return bAchou

//Pesquisar produtos tabela SB1
static function achaProd()
	Local bAchou :=.F.
	Local aDados := {}
	//retorna os dados do produto
	aDados:= PESQPROD(cCodPro)  

	if(aDados[1][1])
		cDescPro   :=aDados[1][2]//Descrição do produto 
		cModelo    :=aDados[1][3]//Modelo do produto	
	Else
		MsgInfo("Produto não foi encontrado!","Atenção")
	EndIF
	
   bAchou := aDados[1][1]

return bAchou

//Fornecedor
static function  getFornecedor()
	Local bAchou :=.F.
   if(empty(cFornecedor))
   MsgInfo("Informe o fornecedor!","Atenção")
   Else
  		cFornecedor :=alltrim(Posicione("SA2",1,xFilial("SA2") +cCodForn,"A2_NOME"))
  		bAchou :=.T.
   EndIF
return bAchou

//prioridade
static function  getPrioridade()
  Local bAchou :=.F.
  if empty(cPropri)
  bAchou :=.F.
  MsgInfo("Por favor: Informe o tipo de prioridade!","Atenção!")

  else
  cDescPropri :=Tabela('ZG',cPropri)
  if empty(cDescPropri)
  bAchou :=.F.
  MsgInfo("Não Encontrado!")
  Else
  bAchou :=.T.
  EndIF
 endIF 
 
return

//Objetivo
static function  getObjetivo()
  Local bAchou :=.F.
  if empty(cCodObj)
  	bAchou :=.F.
  	MsgInfo("Por favor: Informe o objetivo!","Atenção!")
  else
  	cDescObj := Tabela('MO',cCodObj)
  	MsgInfo("Por favor: especifique o objetivo!","Atenção!")
  	iF Alltrim(cDescObj) == 'Z'
  	oDescObj:enable()
  	EndIF
  if empty(cDescObj)
  	bAchou :=.F.
  	MsgInfo("Não Encontrado!")
  Else
  	bAchou :=.T.
  EndIF
 endIF
return(bAchou)

Static Function dtEntregaF()
  Local bAchou :=.F.
  if dDtSai== CtoD(" ") 
  MsgInfo("Informe a data da entrega da solicitação","Atenção")
  Else
   bAchou :=.T. 
  EndIF	
	
	
Return bAchou

Static Function resultado()
		
  Local bAchou :=.F.
  if AllTrim(nResultado)== "" 
  MsgInfo("Informe o resultado da solicitação","Atenção")
  Else
   bAchou :=.T. 
  EndIF	
	
Return bAchou
Static Function parecerF()
   Local bAchou :=.F.
  if empty(cParecer) 
  MsgInfo("Informe o parecer tecnico","Atenção")
  Else
   bAchou :=.T. 
  EndIF	
		
	
	
Return bAchou

Static Function valSeppen()
	Local bAchou :=.F.
	if empty(cSeppen) 
    MsgInfo("Informe o SEPPEN","Atenção")
    Else
   bAchou :=.T. 
  EndIF	
	
Return(bAchou)



//--< Email >----------------------------------------------------------------------

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Cadastro  da requisição														 //
// 1 - Cadastro 
// 2 - Visualizar 
// 3 - Aprovar
// 4 - Alterar
// 5 - Cancelar
// 6 - Proceguir
// 7 - Finalizar
// 8 - Excluir
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/	
static function  EnviarMail()  
    IF cOpcao ==1
      cStatu := "EM ABERTO - ESPERANDO APROVAÇÃO"
    ElseIF cOpcao ==3
      cStatu := "APROVADO - ESPERANDO INICALIZAR SOLICITAÇÃO"
    ElseIF cOpcao ==4
      cStatu := "FOI ALTERADO"
    ElseIF cOpcao ==6
      cStatu := "FOI INICIADO"	
    ElseIF cOpcao ==7
      cStatu := "FINALIZADO"	
    ENDIF
    
    oProcess := TWFProcess():New( "000001", "Envia Email" )
    oProcess :NewTask( "100001", "\WORKFLOW\SSI.HTM" )
    
    oProcess :cSubject := "Solicitação de Metrologia"   
    
    oHTML    := oProcess:oHTML          
    
    cMen := " <html>"
    cMen += " <head>"
    cMen += " <title>Serviço de Solicitação de metrologia - Data:"+Subs(Dtos(date()),7,2) + "/" + Subs(Dtos(date()),5,2)+ "/" + Subs(Dtos(date()),3,2)+" Hora:"+time()+"</title>"
    cMen += " </head>"    
    cMen += " <body>"
    cMen += ' <table border="1" width="1000px" >'
    cMen += ' <tr align="center" >'
    
    cMen += ' <td colspan=2>Solicitação de serviço de metrologia -  Data:'+Subs(Dtos(date()),7,2) + "/" + Subs(Dtos(date()),5,2)+ "/" + Subs(Dtos(date()),3,2)+'</td></tr>'
    
    cMen += ' <tr>'    
    cMen += ' <td align="right">Documento :</td><td>'+cDoc+' </td></tr>'
    
    cMen += ' <tr>'    
    cMen += ' <td align="right">Solicitante :</td><td> '+cNome+'</td></tr>'
    
    cMen += ' <tr>'    
    cMen += ' <td align="right">Cod. Produto :</td><td>'+cCodPro+' </td></tr>'
    
    cMen += ' <tr>'    
    cMen += ' <td align="right">Desc. Produto:</td><td> '+cDescPro+'</td></tr>'
    
    cMen += ' <tr>'    
    cMen += ' <td align="right">Desc. do serviço:</td><td>'+cDecServ+'</td></tr>'
    If (!Empty(nResultado))
    cMen += ' <tr>'    
    cMen += ' <td  align="right">Resultado:</td><td>'+nResultado+'</td></tr>'
    EndiF
    cMen += ' <tr>'    
    cMen += ' <td align="right">Status</td><td>'+cStatu+'</td></tr>'
    
    cMen += ' </table>'       
    cMen += ' </body>'
    cMen += ' </html>'
	oHtml:ValByName("MENS", cMen)
	oProcess:cTo  := _cTo   
	cMailId := oProcess:Start()
    
return


//--< fim de arquivo >----------------------------------------------------------------------

