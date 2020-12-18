#include "protheus.ch"
#INCLUDE "rwmake.ch" 
#Include "TOPCONN.CH"
#include "ap5mail.ch" 
#include 'fivewin.ch'
#include 'tbiconn.ch' 
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include 'hbutton.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±Entrada e saída de materiais º Autor ³ William Rodrigues  º Data ³  15/07/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                       º±±
±±º          ³                                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CESM()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cCadastro := "Entrada e saída de Materias"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta um aRotina proprio                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","U_VisMat",0,2} ,;
             {"Incluir","U_IncluirMat",0,3} ,;             
             {"Alterar","U_AlterarMat",0,4} ,;
             {"Excluir","U_ExcMat",0,5} ,; 
             {"Aprovar","U_AprovMat",0,6} ,; 
             {"Cancelar","U_CanclMat",0,6} ,;
             {"Prosseguir","U_ProceMat",0,7} ,;              
             {"Finalizar","U_FinalMat",0,7} ,;              
             {"Relatorio","U_RELMATS",0,8},;
             {"Ledenda","U_CHAMLeng",0,9}}

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "ZZL" 

Private opcao := 0 


Private aCores 	  := {{ "ZZL->ZZL_STATUS=='0'", 'BR_AZUL' },;     // Aberto AxInclui
		              { "ZZL->ZZL_STATUS=='1'", 'ENABLE'  },;     // Aprovado
		              { "ZZL->ZZL_STATUS=='2'", 'DISABLE' },;     // Realizado
				      { "ZZL->ZZL_STATUS=='3'", 'BR_PRETO'},;     // Nao Realizado 
				      { "ZZL->ZZL_STATUS=='4'", 'BR_AMARELO'}}    // Nao houve aprovac

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private	_cEmpUso  	:= AllTrim(cEmpAnt)+"/",;
		_bFiltraBrw	:= ''
		_aIndexZZL 	:= {}
		_cFiltro  	:= ''    
Private aEnvEmail:={} //vetor de carega os dados da solicitação para os email do funcionários

Private cMarca      := GetMark()



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ recuperando valores do usuário logado                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
xUserVali := __cUserId
PSWORDER(1) //Indexação da senha do usuário pelo ID da senha
aInfoUser := PswRet()
cMatSol   := Subs(aInfoUser[1][22],5,6)
cCCSoli   := alltrim(Posicione("SRA",1,xFilial("SRA") + cMatSol,"RA_CC"))
cDescSol  := alltrim(Posicione("CTT",1,xFilial("CTT") + cCCSoli,"CTT_DESC01"))
cUser     := __cUserId  




dbSelectArea("ZZL")
dbSetOrder(1)

IF U_ValAprova(__cUserId,2)  

     _cFiltro := "ZZL->ZZL_APROV = '"+__cUserId+"' .Or. AllTrim(ZZL->ZZL_CCUSTO) = '"+AllTrim(cCCSoli)+"' .Or. AllTrim(ZZL->ZZL_STATUS) = '4'"

ElseIf AllTrim(cCCSoli) = '124' .Or. AllTrim(cCCSoli) = '126'                

    _cFiltro := "AllTrim(ZZL->ZZL_STATUS)$'0/1/4/2/3'"
     

ElseIf cNivel > 1 .And. !U_ValAprova(__cUserId,3)              

    _cFiltro := "AllTrim(ZZL->ZZL_CCUSTO) == '"+Alltrim(cCCSoli)+"'"

Else
    _cFiltro = "AllTrim(ZZL->ZZL_STATUS)$'0/1/4'"

EndIF	
	 
If	! Empty(_cFiltro) 
			_bFiltraBrw := {|| FilBrowse("ZZL",@_aIndexZZL,@_cFiltro) }
			Eval(_bFiltraBrw)
EndIf	  



/*
cPerg   := "ZZL"

Pergunte(cPerg,.F.)
SetKey(123,{|| Pergunte(cPerg,.T.)}) // Seta a tecla F12 para acionamento dos parametros
 */ 
 
dbSelectArea("ZZL")                          

mBrowse(6,1,22,75,"ZZL",,,,,,aCores)


Return                                  

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Formulário de Materias                                                  ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/




Static Function FormMat01()
 

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private cDoc       := U_GeraSeq("ZZL","ZZL_DOC")
Private cAprov     := "0"+Space(5)
Private cCcDesc    := cDescSol
Private cCcusto    := cCCSoli
Private cDescMat   := Space(60)
Private cElaborado := cUserName  
Private cEmpresa   := Space(30)
Private cCodCli    := Space(30)
Private cCodFor    := Space(30)
Private cDescEmp   := Space(60)
Private cIdProduto := Space(20)
Private cMarca     := Space(60)
Private cEspec     := Space(30)
Private cModelo    := Space(60)
Private cNaprov    := Space(30)
Private cNome      := Space(30)
Private cObs       := Space(255)
Private cReg       := Space(15)
Private cSeg       := Space(30)
Private cSt        := Space(1)   
Private cMotivo    := Space(100)
Private dDtCh      := CtoD(" ")
Private dDtRtPv    := CtoD(" ")
Private dDtSai     := CtoD(" ")
Private dDtSol     := Date()
Private nCbTipoSol
Private nHrCh      := 0
Private nHrSai     := 0
Private nHrSol     := time()
Private nQtd       := 0
Private nRetorn   
Private nTipoMat    
private pesqTab :="SA2MT"//pesquisa a tabela do formecedor                

  

If opcao >= 3
   VisMat()     
IF  Alltrim(ZZL->ZZL_STATUS)='0'
	cSt  :="Aberto"
ElSEIF Alltrim(ZZL->ZZL_STATUS)='1'
	cSt  :="Aprovado" 
ElSEIF Alltrim(ZZL->ZZL_STATUS)='2'
	cSt  :="Concluido"
ElSEIF Alltrim(ZZL->ZZL_STATUS)='3' 
	cSt  :="Cancelado"
ElSEIF Alltrim(ZZL->ZZL_STATUS)='4'
	cSt  :="Em Andamento"
EndIF
    
EndIF   
If cNivel < 5 .And. opcao > 3
	cSeg := cUserName
EndIF 

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oGrp1","oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oSay12","oSay13","oSay14","oSay15")
SetPrvt("oSay7","oSay8","oSay9","oSay10","oSay21","oSay22","oSay23","oSay25","oSay26","oSay27","oSay30","oDoc")
SetPrvt("oHrSol","oReg","oNome","oRetorn","oCcusto","oCcDesc","oQtd","oAprov","oEspec","oNaprov","oCodFor","oCodCli","cDescEmp")
SetPrvt("oElaborado","oDtRtPv","oIdProduto","oDescMat","oMarca","oModelo","oTipoMat","oGrp2","oSay11","oSay29")
SetPrvt("oSay18","oSay19","oSay20","oSay24","oSay28","oHrSai","oDtCh","oHrCh","oSt","oSeg","oDtSai","oObs","oMotivo","oSay29")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 067,233,673,1205,"Saida de Material",,,.F.,,,,,,.T.,,,.T. )
oDlg1:bInit := {||EnchoiceBar(oDlg1,{||Redrecionar()},{|| oDlg1:end()},.F.,{})}
oGrp1      := TGroup():New( 016,008,220,472,"Dados da Solicitação",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 028,016,{||"Documento:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay2      := TSay():New( 028,072,{||"Data da Solicitação:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
oSay3      := TSay():New( 028,128,{||"Hora da Solicitação:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
oSay4      := TSay():New( 052,088,{||"Identificação:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oSay5      := TSay():New( 052,145,{||"Nome:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay6      := TSay():New( 132,016,{||"Retorno:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,008)
oSay12     := TSay():New( 072,016,{||"C. Custo:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,008)
oSay13     := TSay():New( 072,072,{||"C. Custo Descrição:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,056,008)
oSay14     := TSay():New( 132,140,{||"Tipo de Material:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oSay15     := TSay():New( 152,016,{||"ID do Material:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,035,008)
oSay16     := TSay():New( 132,408,{||"Quantidade:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,008)
oSay7      := TSay():New( 132,200,{||"Especificar"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oSay8      := TSay():New( 092,016,{||"Aprovador:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay9      := TSay():New( 092,072,{||"Nome:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay10     := TSay():New( 114,016,{||"Cod. Fornecedor:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
oSay30     := TSay():New( 114,072,{||"Cod. Cliente:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay29     := TSay():New( 114,132,{||"Descrição empresa:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,056,008)
oSay21     := TSay():New( 052,016,{||"Tipo solicitante"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oSay22     := TSay():New( 028,188,{||"Elaborador da solicitação:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,084,008)
oSay23     := TSay():New( 132,072,{||"Data Retorno Prev."},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
oSay25     := TSay():New( 152,072,{||"Descrição do produto:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008)
oSay26     := TSay():New( 172,016,{||"Marca:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay27     := TSay():New( 172,180,{||"Modelo:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay29     := TSay():New( 192,016,{||"Motivo da saída:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)      

oDoc       := TGet():New( 036,016,{|u| If(PCount()>0,cDoc:=u,cDoc)},oGrp1,048,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cDoc",,)
oDtSol     := TGet():New( 036,072,{|u| If(PCount()>0,dDtSol:=u,dDtSol)},oGrp1,044,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","dDtSol",,)
oHrSol     := TGet():New( 036,129,{|u| If(PCount()>0,nHrSol:=u,nHrSol)},oGrp1,044,008,'99.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nHrSol",,)
oElaborado := TGet():New( 036,188,{|u| If(PCount()>0,cElaborado:=u,cElaborado)},oGrp1,272,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cElaborado",,)

oCbTipoSol := TComboBox():New( 060,016,{|u| If(PCount()>0,nCbTipoSol:=u,nCbTipoSol)},{"","FUNCIONARIO","TERCERIZADO","FORNECEDOR","CLIENTE","OUTROS"},064,010,oGrp1,,,{||f_tipoSol()},CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nCbTipoSol )

oReg       := TGet():New( 060,088,{|u| If(PCount()>0,cReg:=u,cReg)},oGrp1,048,008,'999999999999999',{||f_id()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cReg",,)
oNome      := TGet():New( 060,144,{|u| If(PCount()>0,cNome:=u,cNome)},oGrp1,317,008,'@!',{||f_nome()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cNome",,)
oCcusto    := TGet():New( 080,016,{|u| If(PCount()>0,cCcusto:=u,cCcusto)},oGrp1,048,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"CTT","cCcusto",,)
oCcDesc    := TGet():New( 080,072,{|u| If(PCount()>0,cCcDesc:=u,cCcDesc)},oGrp1,388,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cCcDesc",,)
oAprov     := TGet():New( 100,016,{|u| If(PCount()>0,cAprov:=u,cAprov)},oGrp1,048,008,'',{||f_aprov()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ZZS","cAprov",,)
oNaprov    := TGet():New( 100,072,{|u| If(PCount()>0,cNaprov:=u,cNaprov)},oGrp1,388,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cNaprov",,) 
oCodFor    := TGet():New( 122,016,{|u| If(PCount()>0,cCodFor:=u,cCodFor)},oGrp1,048,008,'@!',{||f_emp()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA2MT","cCodFor",,)
oCodCli    := TGet():New( 122,072,{|u| If(PCount()>0,cCodCli:=u,cCodCli)},oGrp1,048,008,'@!',{||f_emp()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA1MT","cCodCli",,)
oDescEmp   := TGet():New( 122,132,{|u| If(PCount()>0,cDescEmp:=u,cDescEmp)},oGrp1,328,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDescEmp",,)
oRetorn    := TComboBox():New( 140,016,{|u| If(PCount()>0,nRetorn:=u,nRetorn)},{"","SIM","NAO"},048,010,oGrp1,,,{||f_retorn()},CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nRetorn )
oDtRtPv    := TGet():New( 140,072,{|u| If(PCount()>0,dDtRtPv:=u,dDtRtPv)},oGrp1,048,008,'',{||f_dtpre()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDtRtPv",,)
oTipoMat   := TComboBox():New( 140,128,{|u| If(PCount()>0,nTipoMat:=u,nTipoMat)},{"","PRODUTO ACABADO","MATERIA PRIMA","INFORMATICA","FERRAMENTA","ELETRONICOS","OUTROS"},064,010,oGrp1,,,{||f_tipo()},CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nTipoMat )
oQtd       := TGet():New( 140,408,{|u| If(PCount()>0,nQtd:=u,nQtd)},oGrp1,052,008,'999',{||f_qtd()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nQtd",,)
oEspec     := TGet():New( 140,200,{|u| If(PCount()>0,cEspec:=u,cEspec)},oGrp1,196,008,'@!',{||f_epc()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cEspec",,)
oIdProduto := TGet():New( 160,016,{|u| If(PCount()>0,cIdProduto:=u,cIdProduto)},oGrp1,048,008,'@!',{||f_cod()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cIdProduto",,)
oDescMat   := TGet():New( 160,072,{|u| If(PCount()>0,cDescMat:=u,cDescMat)},oGrp1,388,008,'@!',{||f_descp()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDescMat",,)
oMarca     := TGet():New( 180,016,{|u| If(PCount()>0,cMarca:=u,cMarca)},oGrp1,144,008,'@!',{||f_marca()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cMarca",,)
oModelo    := TGet():New( 180,180,{|u| If(PCount()>0,cModelo:=u,cModelo)},oGrp1,280,008,'@!',{||f_modelo()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cModelo",,)
oMotivo    := TGet():New( 200,016,{|u| If(PCount()>0,cMotivo:=u,cMotivo)},oGrp1,444,008,'@!',{||f_motivo()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cMotivo",,)
oGrp2      := TGroup():New( 228,008,288,472,"Finalização",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay11     := TSay():New( 240,080,{||"Hora da Saída:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oSay17     := TSay():New( 240,128,{||"Data da Cheagada:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
oSay18     := TSay():New( 240,196,{||"Hora da Chegada:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
oSay19     := TSay():New( 264,016,{||"Situação:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay20     := TSay():New( 264,088,{||"Segurança:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay24     := TSay():New( 240,024,{||"Data da Saída:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oSay28     := TSay():New( 240,252,{||"Observação:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)       
oDtSai     := TGet():New( 248,016,{|u| If(PCount()>0,dDtSai:=u,dDtSai)},oGrp2,060,008,'',{||f_dtSai()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDtSai",,)
oHrSai     := TGet():New( 248,080,{|u| If(PCount()>0,nHrSai:=u,nHrSai)},oGrp2,036,008,'99.99',{||f_hrSai()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nHrSai",,)
oDtCh      := TGet():New( 248,124,{|u| If(PCount()>0,dDtCh:=u,dDtCh)},oGrp2,060,008,'',{||f_dtCh()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDtCh",,)
oHrCh      := TGet():New( 248,196,{|u| If(PCount()>0,nHrCh:=u,nHrCh)},oGrp2,044,008,'99.99',{||f_hrCh()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nHrCh",,)
oObs       := TGet():New( 248,252,{|u| If(PCount()>0,cObs:=u,cObs)},oGrp2,208,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cObs",,)
oSt        := TGet():New( 272,016,{|u| If(PCount()>0,cSt:=u,cSt)},oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cSt",,)
oSeg       := TGet():New( 272,088,{|u| If(PCount()>0,cSeg:=u,cSeg)},oGrp2,372,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cSeg",,)




//desabilita os butões;
DesabiBt()
If opcao <= 3
	oCbTipoSol :enable() 
	oReg       :enable() 
	oNome      :enable()
	oQtd       :enable()  
	oRetorn    :enable()  
	oTipoMat   :enable()  
	oAprov     :enable() 
	oDtRtPv    :enable()
	oIdProduto :enable()
	oDescMat   :enable()
	oMarca     :enable() 
	oModelo    :enable()
	oMotivo    :enable()
	    

/*
if cNivel < 5
oDtSai     :enable()
oHrSai     :enable()
oDtCh      :enable()
oHrCh      :enable()
oObs       :enable()
Endif
  */
ElseIf opcao = 4
	oObs       :enable() 
ElseIf opcao = 5
	oObs       :enable()
ElseIf opcao = 6    
	oDtCh      :enable()
	oHrCh      :enable()
	oObs       :enable()
ElseIf opcao = 7 
	oDtSai     :enable()
	oHrSai     :enable()
	oObs       :enable()
EndIF


oDlg1:Activate(,,,.T.)

Return
  
static function DesabiBt()                

oDoc       :Disable() 
oAprov     :Disable() 
oCcDesc    :Disable() 
oCcusto    :Disable() 
oDescMat   :Disable() 
oElaborado :Disable() 
oCodCli    :Disable() 
oCodFor    :Disable()
oDescEmp   :Disable() 
oIdProduto :Disable() 
oMarca     :Disable() 
oEspec     :Disable() 
oModelo    :Disable() 
oNaprov    :Disable() 
oNome      :Disable() 
oObs       :Disable() 
oReg       :Disable() 
oSeg       :Disable() 
oSt        :Disable() 
oDtCh      :Disable() 
oDtRtPv    :Disable() 
oDtSai     :Disable() 
oDtSol     :Disable() 
oCbTipoSol :Disable() 
oHrCh      :Disable() 
oHrSai     :Disable() 
oMotivo    :Disable() 

oDtSai     :Disable()
oHrSai     :Disable()
oDtCh      :Disable()
oHrCh      :Disable()
oObs       :Disable()

oHrSol     :Disable() 
oQtd       :Disable() 
oRetorn    :Disable() 
oTipoMat   :Disable() 

return

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Opições
   1 - Cadastro de agente de portaria - Entrada de veiculos
   2 - Cadastro de funcionário - Saída de veiculos
   3 - Alteração   
   4 - Cancelamneto
   5 - Aprovação
   6 - Finalização 
   7 - Em Andamento
   8 - Visualizar 
   9 - Excluir
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
                    
User function IncluirMat()         
	opcao := 1      
	FormMat01()    
return                  

User function AlterarMat()
   If Alltrim(ZZL->ZZL_IDELAB) =__cUserId .And. Alltrim(ZZL->ZZL_STATUS) ='0'       
		opcao := 3
		FormMat01()
    ElseIF cNivel < 5
       	opcao := 3
		FormMat01()   
	Else
	    Msgbox("Você não pode alterar essa solicitação!","Mensage","INFO")         
   EndIF
return

User function ProceMat()
	iF cNivel < 5 .And. Alltrim(ZZL->ZZL_STATUS)='1'
		opcao :=7
		FormMat01()  
	Else
		Msgbox("Você não pode prosseguir!","Mensage","INFO")         	
	EndIF
return
   

User function FinalMat()   
	iF cNivel < 5 .And. Alltrim(ZZL->ZZL_STATUS)='4'
		opcao :=6
		FormMat01()  
	Else
		Msgbox("Você não pode Finalizar!","Mensage","INFO")         	
	EndIF
return
 
User function CanclMat()                    
  If AllTrim(ZZL->ZZL_STATUS)<>'3' .And. AllTrim(ZZL->ZZL_STATUS)<>'2'
    if AllTrim(ZZL->ZZL_IDELAB) == __cUserId  .Or. AllTrim(ZZL->ZZL_APROV) == Subs(aInfoUser[1][22],5,6) .Or. cNivel < 5
		opcao :=4
		FormMat01()  
	Else
		Msgbox("Você não pode Cancelar!","Mensage","INFO")         	
	EndIF
Else
     Msgbox("Você não pode Cancelar!","Mensage","INFO")         	
 EndiF
return

User function AprovMat()
   if U_ValAprova(__cUserId,3)   //função para validar o aprovador
    if AllTrim(ZZL->ZZL_STATUS)='0' //solicitações pendentes
     opcao := 5
     FormMat01()
    ELSE
     ALERT("Solicitação já está aprovada!")
   Endif
   Else
    ALERT("Você não tem permição para aprovação!")
  Endif
return     

User function VisMat()       

opcao:=8          
FormMat01()
return       


User function ExcMat()       
if AllTrim(ZZL->ZZL_IDELAB) =__cUserId 
    if ZZL->ZZL_STATUS = "0" .Or. ZZL->ZZL_STATUS = "1"
       opcao:=9          
       FormMat01()

    Else
       Msgbox("Você não pode excluir!","Mensage","INFO")    
    EndIF
 Else
       Msgbox("Você não pode excluir, somente o elaborador da solicitação!","Mensage","INFO")    
 EndIF

return          

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Funcões de validações de campos
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/


static function f_tipoSol()
Local boo := .T.
IF Alltrim(nCbTipoSol) == ''
   	alert("Selecione o tipo de solicitante")        
   	boo := .F. 
ElseIF Alltrim(nCbTipoSol) == 'FUNCIONARIO'
	oCodFor :Disable()
	oCodCli :Disable()
	    	  
ELSEIF Alltrim(nCbTipoSol) == "CLIENTE"
    oCodFor    :Disable()
    oCodCli    :Enable()
    cCodFor    := space(30)
    cCodCli    := space(30)
    cCcDesc    := Space(30)
	cCcusto    := Space(9)       
	cNome      := Space(30)     
	cDescEmp   := Space(60)
	   
ELSE
    oCodFor :Enable()
    oCodCli :Disable()
    cCodFor    := space(30)
    cCodCli    := space(30)
    cCcDesc    := Space(30)
	cCcusto    := Space(9)       
	cNome      := Space(30)     
	cDescEmp   := Space(60)
EndIF         

return(boo)
 
static function f_id()
Local boo := .T.

IF Alltrim(cReg) == ''
   	alert("Informe a indentificação do solicitante")        
   	boo := .F.
Else

if  Alltrim(nCbTipoSol) == "FUNCIONARIO"    
	
	cReg := STRZERO(VAL(cReg),6)
	DbSelectArea("SRA")  
	DbSetOrder(1)     
	DbGotop()	
  If DbSeek(xFilial("SRA") + cReg)   
     	if Alltrim(RA_DEMISSA) == ''
	 		cNome    := SRA->RA_NOME 
   			cReg     := SRA->RA_MAT  
   			cCcusto  := SRA->RA_CC
   			cDescEmp :="NIPPON SEIKI DO BRASIL LTDA."    
   			cCodCli  :="01/01"
   		    cCodFor  :="01/01"
   			cCcDesc  := alltrim(Posicione("CTT",1,xFilial("CTT") + cCcusto,"CTT_DESC01"))    
   			oCodCli  :Disable() 
   			oCodFor    :Disable()
   			oNome    :Disable()  
            oDescEmp :Disable()

    	Endif
	Endif     
          
	if empty(SRA->RA_MAT)
		cQuery := " SELECT RA_NOME,RA_CC,RA_DEMISSA,RA_MAT,RA_TNOTRAB,RA_BITMAP FROM SRA020 WHERE RA_DEMISSA <> '' AND D_E_L_E_T_='' AND  RA_MAT = '" +cReg+ "'
		Query  := ChangeQuery(cQuery)
		TCQUERY cQuery Alias TRA New 
		dbSelectArea("TRA")          
	   	cNome    := TRA->RA_NOME 
	   	cReg     := TRA->RA_MAT  
   		cCcusto  := TRA->RA_CC      
   		cDescEmp :="NIPPON SEIKI DO BRASIL LTDA - TERCEIRO."    
   		cCodCli  :="02/02"
   		cCodFor  :="02/02"
   		cCcDesc   := alltrim(Posicione("CTT",1,xFilial("CTT") + cCcusto,"CTT_DESC01"))    
   		oCodCli:Disable()
   		oCodFor    :Disable() 
   		oNome   :Disable()    
   		oDescEmp:Disable()

	EndIF
           
	If empty(cReg) .And. empty(cNome)
    	 Alert("Atenção: Matricula Não Encontrada")
  	 	boo := .F.   
	EndIF         
               
	dbCloseArea("SRA")                
	dbCloseArea("TRA") 
Else 
   
   
   oDescEmp:Enable()
   oNome   :Enable()

    cQuery := " SELECT * FROM ZZL010 WHERE  ZZL_IDSOL = '" +AllTrim(cReg)+ "' AND ZZL_TIPOSO <> 'FUNCIONARIO' "
	Query := ChangeQuery(cQuery)
	TCQUERY cQuery Alias TRL New 
	dbSelectArea("TRL")          
   	cNome     := TRL->ZZL_NOME      	
   	cEmpresa  := TRL->ZZL_EMPRES
   	cDescEmp  := TRL->ZZL_DESCEM
   	dbCloseArea("TRL") 
    cCcDesc    := cDescSol
    cCcusto    := cCCSoli
EndIF

EndIF     
return(boo)

static function f_nome()
Local boo := .T.
IF Alltrim(cNome) == ''
   	alert("Informe o nome da pessoa")        
    boo := .F.
EndIF     
return(boo)
                      

static function f_aprov()
Local boo := .T.
IF Alltrim(cAprov) == ''
    alert("Selecione Um aprovador")        
    boo := .F.
Else
 if U_ValAprova(cAprov,3)
    cNaprov:= alltrim(Posicione("ZZS",2,cAprov,"ZZS_NUSER"))  
 Else 
    alert("Aprovador selecionado não pode aprovar essa solicitação, Por favor Informe outros aprovador!")
    boo := .F.
 EndIF
EndIF     
return(boo)            

static function f_emp()
Local boo := .T.
IF Alltrim(cCodFor) == '' .And. Alltrim(cCodCli) == ''
    alert("Informe o codigo da empresa")        
    boo := .F.                                  
    ELSEIF Alltrim(cCodFor) <> ''
    cEmpresa:=cCodFor
    cCodCli:= space(30)            
    ELSEIF Alltrim(cCodCli) <> ''
    cEmpresa:=cCodCli
    cCodFor:= Space(30)
EndIF     
return(boo)          

static function f_motivo()
Local boo := .T.
IF Alltrim(cMotivo) == ''
    alert("Informe o motivo da saída do material")        
    boo := .F.
EndIF     
return(boo)

 

static function f_retorn()
Local boo := .T.
IF Alltrim(nRetorn) == ""
    alert("Selecione o retorno")        
    boo := .F. 
elseIF Alltrim(nRetorn) == "NAO"      
 dDtRtPv:= CtoD(" ")
 oDtRtPv    :Disable()
ELSE                
 dDtRtPv:= CtoD(" ")  
 oDtRtPv    :ENABLE()
EndIF     
return(boo) 
            
static function f_dtpre()
Local boo := .T.
IF dDtRtPv == CtoD(" ")
    alert("Informe a data prevista")        
    boo := .F.
EndIF            

return(boo)

static function f_tipo()
Local boo := .T.
IF Alltrim(nTipoMat) == ''
    alert("Selecione o tipo de material")        
    boo := .F.
ElseIF Alltrim(nTipoMat) == "OUTROS"
    oEspec:Enable()
Else
    oEspec:Disable()
EndIF                 
           
return(boo)


static function f_epc()
Local boo := .T.
IF Alltrim(cEspec) == ''
    alert("Espicicar o nome do tipo de material")        
    boo := .F.
EndIF                 
           
return(boo)   

static function f_qtd()
Local boo := .T.
IF nQtd == 0
    alert("Informe a quantidade")        
    boo := .F.
EndIF                 
           
return(boo)       

static function f_cod()
Local boo := .T.
IF Alltrim(cIdProduto) == ''    
    alert("Informe o Codigo do material")        
    boo := .F.     
ELSE
            cQuery := "SELECT * FROM SB1010 WHERE B1_COD ='"+cIdProduto+"'"
			Query := ChangeQuery(cQuery)
			TCQUERY cQuery Alias TRA New  			
			dbSelectArea("TRA")  
			cDescMat   := TRA->B1_DESC
			If AllTrim(cDescMat) <> ''
				cMarca     := "NSB"
				cModelo    := TRA->B1_MODELO 
				oDescMat   :Disable()
				oMarca     :Disable()
				oModelo    :Disable()
			ELSE
			    oDescMat   :ENABLE()   
			    oMarca     :ENABLE()
				oModelo    :ENABLE()
			EndIF
			dbCloseArea("TRA") 
			
			cQuery  := "SELECT * FROM SN1010 WHERE N1_CODBAR ='"+cIdProduto+"'"
			Query   := ChangeQuery(cQuery)
			TCQUERY cQuery Alias TRA New  			
			dbSelectArea("TRA")
			If AllTrim(cDescMat) = ''
			cDescMat   := TRA->N1_DESCRIC
			EndIF  
			If AllTrim(cDescMat) <> ''              
				oDescMat   :Disable() 
			EndIF       
			
			IF AllTrim(cDescMat) = ''
			    cMarca     :=space(20)
				cModelo    :=space(20)
			    oDescMat   :ENABLE()   
			    oMarca     :ENABLE()
				oModelo    :ENABLE() 
				
			EndIF
			dbCloseArea("TRA") 
		    
			

EndIF                 
return(boo)          


static function f_descp()
Local boo := .T.
IF Alltrim(cDescMat) == ''
    alert("Informe a descrição do material")        
    boo := .F.
EndIF                 
           
return(boo)            

static function f_marca()
Local boo := .T.
IF Alltrim(cMarca) == ''
    alert("Informe a marca")        
    boo := .F.
EndIF                 
                       
           
return(boo)


static function f_modelo()
Local boo := .T.
IF Alltrim(cModelo) == ''
    alert("Informe a modelo")
    boo := .F.
EndIF                 
           
return(boo)                                                                  

static function f_dtSai()
Local boo := .T.
IF dDtSai == CtoD(" ")
    alert("Informe a data Atual")
    boo := .F.
EndIF                 
           
return(boo)            

static function f_hrSai()
Local boo := .T.
IF nHrSai == 0
    alert("Informe a hora Atual")
    boo := .F.
EndIF                 
           
return(boo)            
static function f_dtCh()
Local boo := .T.
IF dDtCh == CtoD(" ")
    alert("Informe data Atual")
    boo := .F.
EndIF                 
           
return(boo)           
static function f_hrCh()
Local boo := .T.
IF nHrCh == 0
    alert("Informe a hora Atual")
    boo := .F.
EndIF                 
           
return(boo)
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Opições
   1 - Cadastro de agente de portaria - Entrada de veiculos
   2 - Cadastro de funcionário - Saída de veiculos
   3 - Alteração   
   4 - Cancelamneto
   5 - Aprovação
   6 - Finalização 
   7 - Em Andamento
   8 - Visualizar 
   9 - Excluir
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
                
Static function Redrecionar()
Local lPadrao:= .F.

If opcao = 1      

 If ValCampo()    
   IF lPadrao := Msgbox("Você confirma o cadastro !","Atenção","YESNO")   
    CadMat()//incluir registro  
    Msgbox("Solicitação Registrada com sucesso aguande a aprovação!","Mensage","INFO")         
    Close(oDlg1)
   EndIF    
 EndIF

ElseIf opcao = 3  
   lPadrao:=Msgbox("Você confirma Alteração!","Atenção","YESNO")    
   if lPadrao     
	AlMat()
	Msgbox("Alteração reslizada com Sucesso!","Mensage","INFO")         
    Close(oDlg1)
   Endif
ElseIf opcao = 4  
 IF lPadrao := Msgbox("Você deseja cancelar !","Atenção","YESNO")   
    CanMat()
	Msgbox("Solicitação cancelada com sucesso!","Mensage","INFO")         
    Close(oDlg1)    
 EndIF
ElseIf opcao = 5
    AprMat()
	Msgbox("Solicitação Aprovada com sucesso!","Mensage","INFO")         
    Close(oDlg1)
ElseIf opcao = 6
    FimMat()
	Msgbox("Solicitação Finalizada!","Mensage","INFO")         
    Close(oDlg1)
ElseIf opcao = 7 
   IF lPadrao := Msgbox("Você confirma!","Atenção","YESNO")    
   	AmdMat()
    Close(oDlg1)                                                         
   EndIF
ElseIf opcao = 8
	Close(oDlg1)
ElseIf opcao = 9 
   IF lPadrao := Msgbox("Você confirma a exclusão!","Atenção","YESNO")    
   	ExclMat()   
   	Msgbox("Exclusão realizado com Sucesso!","Mensage","INFO")         
    Close(oDlg1)                                                         
   EndIF
EndIF
return                                                      

static function ValCampo()

Local  bool:= .T.

If opcao = 1
 
IF Alltrim(nCbTipoSol) == ''
   alert("Selecione o tipo de solicitante")        
   bool := .F.
ElseIF Alltrim(cReg) == ''
   alert("Informe a indentificação do solicitante")        
   bool := .F.   
ElseIF Alltrim(cNome) == ''
   alert("Informe o nome da pessoa")        
   bool := .F.
ElseIF Alltrim(cAprov) == ''
   alert("Selecione Um aprovador")        
   bool := .F.
ElseIF Alltrim(nRetorn) == ""
   alert("Selecione o retorno")        
   bool := .F.
ElseIF Alltrim(nTipoMat) == ''
   alert("Selecione o tipo de material")        
   bool := .F.
ElseIF Alltrim(nTipoMat) == "Outros"
   oEspec:Enable()                 
   IF Alltrim(cEspec) == ''
   alert("Espicicar o nome do tipo de material")        
   bool := .F.
   EndIF
ElseIF Alltrim(nTipoMat) <> 'Outros'
   oEspec:Disable()                
ElseIF nQtd == 0
   alert("Informe a quantidade")        
   bool := .F.
ElseIF Alltrim(cIdProduto) == ''
   alert("Informe o Codigo do material")        
   bool := .F.
ElseIF Alltrim(cDescMat) == ''
   alert("Informe a descrição do material")        
   bool := .F.
ELSEIF Alltrim(cMarca) == ''
   alert("Informe a marca")        
   bool := .F.
EndIF                 
                       
ElseIf opcao = 2

ElseIf opcao = 3

ElseIf opcao = 4

ElseIf opcao = 5

ElseIf opcao = 6

ElseIf opcao = 7

ElseIf opcao = 8

EndIF


return(bool)

//    pessistencia
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Opições
   1 - Cadastro de agente de portaria - Entrada de veiculos
   2 - Cadastro de funcionário - Saída de veiculos
   3 - Alteração   
   4 - Cancelamneto
   5 - Aprovação
   6 - Finalização 
   7 - Em Andamento
   8 - Visualizar
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Static function CadMat()

dbSelectArea("ZZL") 
RecLock("ZZL",.T.) 
//ZZL_HRRETO :=nHrRet     
//ZZL_HRSAI  :=nHrSai 
ZZL->ZZL_FILIAL :=xFilial("ZZL")
ZZL->ZZL_DOC    :=U_GeraSeq("ZZL","ZZL_DOC")
ZZL->ZZL_DTREG  :=dDtSol
ZZL->ZZL_HRREG  :=nHrSol
ZZL->ZZL_IDSOL  :=cReg
ZZL->ZZL_NOME   :=cNome

ZZL->ZZL_CDESC  :=cCcDesc    
ZZL->ZZL_CCUSTO :=cCcusto  
ZZL->ZZL_APROV  :=cAprov

ZZL->ZZL_NAPROV :=cNaprov
ZZL->ZZL_RETORN :=nRetorn 
ZZL->ZZL_TIPOMT :=nTipoMat
ZZL->ZZL_EMPRES :=cEmpresa
ZZL->ZZL_DESCEM :=cDescEmp  
ZZL->ZZL_TIPOSO :=nCbTipoSol
ZZL->ZZL_IDPROD :=cIdProduto
ZZL->ZZL_DESCMT :=cDescMat 
ZZL->ZZL_DTRTPV :=dDtRtPv
ZZL->ZZL_MARCA  :=cMarca   
ZZL->ZZL_MODELO :=cModelo
ZZL->ZZL_DESCTP :=cEspec

ZZL->ZZL_QTDPC  :=nQtd
ZZL->ZZL_IDELAB :=__cUserId
ZZL->ZZL_ELABOR :=cElaborado   
ZZL->ZZL_MOTIVO :=cMotivo
ZZL->ZZL_STATUS :='0'
EnviarMail()
MsUnlock()           
return

Static function AlMat()
dbSelectArea("ZZL") 
DbSetOrder(1)     
DbGotop()
          
If DbSeek(xFilial("ZZL")+cDoc)
RecLock("ZZL",.F.) 
//ZZL_HRRETO :=nHrRet     
//ZZL_HRSAI  :=nHrSai
 
	ZZL->ZZL_DTREG  :=dDtSol
	ZZL->ZZL_HRREG  :=nHrSol
	ZZL->ZZL_IDSOL  :=cReg
	ZZL->ZZL_NOME   :=cNome

	ZZL->ZZL_CDESC  :=cCcDesc    
	ZZL->ZZL_CCUSTO :=cCcusto  
	ZZL->ZZL_APROV  :=cAprov

	ZZL->ZZL_NAPROV :=cNaprov
	ZZL->ZZL_RETORN :=nRetorn 
	ZZL->ZZL_TIPOMT :=nTipoMat
	ZZL->ZZL_EMPRES :=cEmpresa
	ZZL->ZZL_DESCEM :=cDescEmp
	ZZL->ZZL_TIPOSO :=nCbTipoSol
	ZZL->ZZL_IDPROD :=cIdProduto
	ZZL->ZZL_DESCMT :=cDescMat 
	ZZL->ZZL_DTRTPV :=dDtRtPv
	ZZL->ZZL_MARCA  :=cMarca   
	ZZL->ZZL_MODELO :=cModelo
	ZZL->ZZL_DESCTP :=cEspec

	ZZL->ZZL_QTDPC  :=nQtd


	ZZL->ZZL_DTRETO :=dDtCh
	ZZL->ZZL_HRRETO :=nHrCh
	ZZL->ZZL_DTSAI  :=dDtSai
	ZZL->ZZL_HRSAI  :=nHrSai
	ZZL->ZZL_OBS    :=cObs
	ZZL->ZZL_MOTIVO :=cMotivo
	MsUnlock()
	EnviarMail()           
ENDIF
return

Static function AprMat()
dbSelectArea("ZZL") 
DbSetOrder(1)     
DbGotop()          
If DbSeek(xFilial("ZZL")+cDoc)
RecLock("ZZL",.F.)   
 	ZZL_STATUS  :='1'
 	ZZL_ACAO    :=cUserName
MsUnlock()           
EnviarMail()
EndIF
return

Static function FimMat()
dbSelectArea("ZZL") 
DbSetOrder(1)     
DbGotop()          
If DbSeek(xFilial("ZZL")+cDoc)
RecLock("ZZL",.F.)   
 	ZZL_STATUS  :='2' 	
    ZZL_DTRETO :=dDtCh      
    ZZL_HRRETO :=nHrCh
	ZZL_OBS    :=cObs
	ZZL_SEG    :=cSeg
MsUnlock()           
EndIF
return
 
Static function CanMat()
dbSelectArea("ZZL") 
DbSetOrder(1)     
DbGotop()          
If DbSeek(xFilial("ZZL")+cDoc)

RecLock("ZZL",.F.)   
 	ZZL_STATUS  :='3'
	ZZL_OBS    :=cObs
	ZZL_ACAO   :=cUserName
MsUnlock()  
    
EnviarMail()     

EndIF

return

Static function AmdMat()
dbSelectArea("ZZL") 
DbSetOrder(1)     
DbGotop()          
If DbSeek(xFilial("ZZL")+cDoc)

RecLock("ZZL",.F.)    
    if Alltrim(nRetorn) = 'SIM'
 	ZZL_STATUS  :='4'          
 	Else                       
 	ZZL_STATUS  :='2'          
 	EndiF
	ZZL_DTSAI  :=dDtSai
	ZZL_HRSAI  :=nHrSai
	ZZL_OBS    :=cObs
	ZZL_SEG    :=cSeg
	
MsUnlock()           

EndIF
return


Static function ExclMat()
dbSelectArea("ZZL")
DbSetOrder(1)     
DbGotop()          
If DbSeek(xFilial("ZZL")+cDoc)
	    RecLock("ZZL",.F.)
		dbDelete()
		MsunLock()
EndIF
return             

//VISUALIZAR 
Static function VisMat()
    
cReg       :=ZZL->ZZL_IDSOL 
   
cDoc       :=ZZL->ZZL_DOC    
dDtSol     :=ZZL->ZZL_DTREG

nHrSol     :=ZZL->ZZL_HRREG    
cNome      :=ZZL->ZZL_NOME   

cCcDesc    :=ZZL->ZZL_CDESC
cCcusto    :=ZZL->ZZL_CCUSTO 
cAprov     :=ZZL->ZZL_APROV

cNaprov    :=ZZL->ZZL_NAPROV 
nRetorn    :=ZZL->ZZL_RETORN  
nTipoMat   :=ZZL->ZZL_TIPOMT 
cEmpresa   :=ZZL->ZZL_EMPRES   
cDescEmp   :=ZZL->ZZL_DESCEM   

nCbTipoSol :=ZZL->ZZL_TIPOSO 
cIdProduto :=ZZL->ZZL_IDPROD 
cDescMat   :=ZZL->ZZL_DESCMT 
dDtRtPv    :=ZZL->ZZL_DTRTPV
cEspec     :=ZZL->ZZL_DESCTP
nQtd       :=ZZL->ZZL_QTDPC

dDtSai     :=ZZL->ZZL_DTSAI
nHrSai     :=ZZL->ZZL_HRSAI
dDtCh      :=ZZL->ZZL_DTRETO
nHrCh      :=ZZL->ZZL_HRRETO

cObs       :=ZZL->ZZL_OBS    
cSeg       :=ZZL->ZZL_SEG

cMarca     :=ZZL->ZZL_MARCA
cModelo    :=ZZL->ZZL_MODELO
cElaborado :=ZZL->ZZL_ELABOR
cMotivo    :=ZZL->ZZL_MOTIVO
return 

static function  EnviarMail()  
    
    Local _cTo:=""
    Local supervisor     
 
    oProcess := TWFProcess():New( "000001", "Envia Email" )
    oProcess :NewTask( "100001", "\WORKFLOW\SSI.HTM" )    
    oProcess :cSubject := "Informativo de saída de material"
    
    
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Opições
   1 - Cadastro de agente de portaria - Entrada de veiculos
   2 - Cadastro de funcionário - Saída de veiculos
   3 - Alteração   
   4 - Cancelamneto
   5 - Aprovação
   6 - Finalização 
   7 - Em Andamento
   8 - Visualizar
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
          
 oHTML    := oProcess:oHTML
           
 cMen :='<html>'
 cMen +='<head>'
 cMen +='<title>Sistema de saída de material</title>'
 cMen +='</head>'
 cMen +='<body>'
 cMen +='<p>&nbsp;</p>' 
 cMen +='<table>'
 cMen +='<tr><td>'
 cMen +='<table width="489" height="110" border="1" align="left" cellpadding="0" cellspacing="0">'
 cMen +='<tr>'
 cMen +='   <td height="29" colspan="4"><div align="center">Dados do solicitante </div></td>'
 cMen +=' </tr>'
 cMen +='  <tr>'
 cMen +='   <td width="109" height="23"><div align="right">Documento:&nbsp;</div></td>'
 cMen +='    <td width="364">&nbsp;'+cDoc+'</td>'
 cMen +='  </tr>'
 cMen +='  <tr>'
 cMen +='   <td width="109" height="23"><div align="right">Indentificação:&nbsp;</div></td>'
 cMen +='    <td width="364">&nbsp;'+cReg+'</td>'
 cMen +='  </tr>'
 cMen +='  <tr>'
 cMen +='    <td height="23"><div align="right">Nome:&nbsp;</div></td>'
 cMen +='    <td>&nbsp;'+cNome+'</td>'
 cMen +='  </tr>'
  cMen +='  <tr>'
 cMen +='    <td height="23"><div align="right">Tipo de solicitante:&nbsp;</div></td>'
 cMen +='    <td>&nbsp;'+nCbTipoSol+'</td>'
 cMen +='  </tr>'
 cMen +='  <tr>'
 cMen +='    <td height="23"><div align="right">Elaborador: &nbsp;</div></td>'
 cMen +='   <td>&nbsp;'+cElaborado+'</td>'
 cMen +=' </tr>'
 cMen +='  <tr>'
 cMen +='    <td height="23"><div align="right">Centro de Custo: &nbsp;</div></td>'
 cMen +='   <td>&nbsp;'+cCcusto+'/'+cCcDesc+'</td>'
 cMen +=' </tr>'     
 cMen +='</table>'
 cMen +='</td></tr>'
 cMen +='<tr><td>'
 cMen +='<table width="489" height="186" border="1" align="left" cellpadding="0" cellspacing="0">'
 cMen +='  <tr>'
 cMen +='   <td height="29" colspan="4"><div align="center">Dados do Material </div></td>'
 cMen +='  </tr>'
 cMen +=' <tr>'
 cMen +='   <td width="170" height="23"><div align="right">ID do Material:&nbsp;</div></td>'
 cMen +='    <td width="319">&nbsp;'+cIdProduto+'</td>'
 cMen +='  </tr>' 
 cMen +=' <tr>'
 cMen +='   <td height="23"><div align="right">Tipo de material:&nbsp;</div></td>'
 cMen +='    <td>&nbsp;'+nTipoMat+'  '+cEspec+'</td>'
 cMen +='  </tr>'
 cMen +=' <tr>'
 cMen +='   <td height="19"><p align="right">Descrição:&nbsp;</p>    </td>'
 cMen +='    <td>&nbsp;'+cDescMat+'</td>'
 cMen +='  </tr>'
 cMen +=' <tr>'
 cMen +='   <td height="19"><p align="right">Marca:&nbsp;</p>    </td>'
 cMen +='    <td>&nbsp;'+cMarca+'</td>'
 cMen +='  </tr>'
 cMen +=' <tr>'
 cMen +='   <td height="23"><div align="right">Modelo:&nbsp; </div></td>'
 cMen +='    <td>&nbsp;'+cModelo+'</td>'
 cMen +=' </tr>'
  cMen +=' <tr>'
 cMen +='   <td height="23"><div align="right">Quantidade:&nbsp; </div></td>'
 cMen +='   <td>&nbsp;'+STR(nQtd)+'</td>'
 cMen +=' </tr>'
 cMen +=' <tr> '
 cMen +='   <td height="23"><div align="right">Data da saída prevista: &nbsp;</div></td>'
 cMen +='    <td>&nbsp;'+ Dtoc(dDtSai) +'</td>'
 cMen +=' </tr>'
 cMen +=' <tr> '
 cMen +='   <td height="23"><div align="right">Motivo da saída: &nbsp;</div></td>'
 cMen +='    <td>&nbsp;'+cMotivo+'</td>'
 cMen +=' </tr>'

 if opcao <= 3

 cMen +='   <td colspan="2"><div align="center">Situa&ccedil;&atilde;o Atual: <b>Esperando aprova&ccedil;&atilde;o</b></div></td>'
 ElseIF opcao = 4 //cancelada
 cMen +='   <td colspan="2"><div align="center">Situa&ccedil;&atilde;o Atual: <b>Cancelado</b></div></td>' 
 ElseIF opcao = 5 //Aprovado
 cMen +='   <td colspan="2"><div align="center">Situa&ccedil;&atilde;o Atual: <b>Aprovado</b></div></td>'
 ElseIF opcao = 6 //Finalizado
 cMen +='   <td colspan="2"><div align="center">Situa&ccedil;&atilde;o Atual: <b>Encerrado</b></div></td>'
 EndIF
 cMen +='  </tr>'
 cMen +='</table>'
 cMen +='</td></tr></table>'
 cMen +='<p>&nbsp;</p>'
 cMen +='</body>'
 cMen +='</html>'   
 _cTo:=""     
 nTam := 0
 
       IF opcao <=3
          _cTo := alltrim(UsrRetMail(cAprov))         
	      _cTo +=";"+alltrim(UsrRetMail(__cUserId))+";"
	        
     	    //ADICIONANDO OS SUPEVISORES
     	    dbSelectArea("ZZS")
            dbGoTop()
            While !EOF()
              nTam:= len(ZZS->ZZS_WORKF)                                      
              //SE ALTERAR A PERMIÇÃO DE WORKFLOK TEM QUE ALTERAR DAS OUTRAS ROTINA DO MODULO DE PORTARIA EXEMPLO: SSSN
              IF ZZS->ZZS_CCUSTO == cCcusto .And. Alltrim(ZZS->ZZS_WORKF)=="SSS" .And. Alltrim(ZZS->ZZS_SUPERV)== "SIM" //SE O CENTRO DE CUSTO DO FUNCIONÁRIO IGUAL AO DO SUPERVIDOR E ENVAR FOR VERDADEIRO //retorna verdadeiro ou falso
	            _cTo += alltrim(UsrRetMail(ZZS->ZZS_USER))+';'
	          EndIF
              
              DbSelectArea("ZZS")
              dbSkip() // Avanca o ponteiro do registro no arquivo
            EndDo
	      
       ElseIF opcao = 5 .Or.opcao = 4
         _cTo =alltrim(UsrRetMail(ZZL->ZZL_IDELAB))+";"
       EndIF
                
	  
		oHtml:ValByName("MENS", cMen)
		If Right(_cTo,1)==";"
			_cTo:=Substring(_cTo,1,len(_cTo)-1)
		EndIf  
	  	oProcess:cTo  := _cTo   
	  	cMailId := oProcess:Start()
	  
return            

static function envia_retorno()            
     
  Local _cTo:=""
  Local supervisor          
    Prepare Environment Empresa "01" Filial "01" Tables "ZZL"  
    cQuery := "SELECT * FROM ZZL010 WHERE  ZZL_STATUS='4' AND ZZL_DTRTPV <'"+Dtos(Date())+"' AND ZZL_RETORN = 'SIM'
    Query := ChangeQuery(cQuery)
    TCQUERY cQuery Alias ZZZ New                                         
    dbSelectArea("ZZZ")  
    dbGoTop()
    While !EOF()
  
 
  oProcess := TWFProcess():New( "000001", "Envia Email" )
  oProcess :NewTask( "100001", "\WORKFLOW\SSI.HTM" )    
  oProcess :cSubject := "Informativo de saída de material - pendências"
    
    
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Opições
   1 - Cadastro de agente de portaria - Entrada de veiculos
   2 - Cadastro de funcionário - Saída de veiculos
   3 - Alteração   
   4 - Cancelamneto
   5 - Aprovação
   6 - Finalização 
   7 - Em Andamento
   8 - Visualizar
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
          
 oHTML    := oProcess:oHTML
           
 cMen :='<html>'
 cMen +='<head>'
 cMen +='<title>Sistema de saída de material</title>'
 cMen +='</head>'
 cMen +='<body>'
 cMen +='<p>&nbsp;</p>' 
 cMen +='<table>'
 cMen +='<tr><td>'
 cMen +='<table width="489" height="110" border="1" align="left" cellpadding="0" cellspacing="0">'
 cMen +='<tr>'
 cMen +='   <td height="29" colspan="4"><div align="center">Dados do solicitante </div></td>'
 cMen +=' </tr>'
 cMen +='  <tr>'
 cMen +='   <td width="109" height="23"><div align="right">Documento:&nbsp;</div></td>'
 cMen +='    <td width="364">&nbsp;'+ZZZ->ZZL_DOC+'</td>'
 cMen +='  </tr>'
 cMen +='  <tr>'
 cMen +='   <td width="109" height="23"><div align="right">Indentificação:&nbsp;</div></td>'
 cMen +='    <td width="364">&nbsp;'+ZZZ->ZZL_IDSOL+'</td>'
 cMen +='  </tr>'
 cMen +='  <tr>'
 cMen +='    <td height="23"><div align="right">Nome:&nbsp;</div></td>'
 cMen +='    <td>&nbsp;'+ZZZ->ZZL_NOME+'</td>'
 cMen +='  </tr>'
 cMen +='  <tr>'
 cMen +='    <td height="23"><div align="right">Tipo de solicitante:&nbsp;</div></td>'
 cMen +='    <td>&nbsp;'+ZZZ->ZZL_TIPOSO+'</td>'
 cMen +='  </tr>'
 cMen +='  <tr>'
 cMen +='    <td height="23"><div align="right">Elaborador: &nbsp;</div></td>'
 cMen +='   <td>&nbsp;'+ZZZ->ZZL_ELABOR+'</td>'
 cMen +=' </tr>'
 cMen +='  <tr>'
 cMen +='    <td height="23"><div align="right">Centro de Custo: &nbsp;</div></td>'
 cMen +='   <td>&nbsp;'+ZZZ->ZZL_CCUSTO+'/'+ZZZ->ZZL_CDESC+'</td>'
 cMen +=' </tr>'     
 cMen +='</table>'
 cMen +='</td></tr>'
 cMen +='<tr><td>'
 cMen +='<table width="489" height="186" border="1" align="left" cellpadding="0" cellspacing="0">'
 cMen +='  <tr>'
 cMen +='   <td height="29" colspan="4"><div align="center">Dados do Material </div></td>'
 cMen +='  </tr>'
 cMen +=' <tr>'
 cMen +='   <td width="170" height="23"><div align="right">ID do  Material:&nbsp;</div></td>'
 cMen +='    <td width="319">&nbsp;'+ZZZ->ZZL_IDPROD+'</td>'
 cMen +='  </tr>' 
 cMen +=' <tr>'
 cMen +='   <td height="23"><div align="right">Tipo de material:&nbsp;</div></td>'
 cMen +='    <td>&nbsp;'+ZZZ->ZZL_TIPOMT+' '+ZZZ->ZZL_DESCTP+'</td>'
 cMen +='  </tr>'
 cMen +=' <tr>'
 cMen +='   <td height="19"><p align="right">Descrição:&nbsp;</p>    </td>'
 cMen +='    <td>&nbsp;'+ZZZ->ZZL_DESCMT+'</td>'
 cMen +='  </tr>'
 cMen +=' <tr>'
 cMen +='   <td height="19"><p align="right">Marca:&nbsp;</p>    </td>'
 cMen +='    <td>&nbsp;'+ZZZ->ZZL_MARCA+'</td>'
 cMen +='  </tr>'
 cMen +=' <tr>'
 cMen +='   <td height="23"><div align="right">Modelo:&nbsp; </div></td>'
 cMen +='    <td>&nbsp;'+ZZZ->ZZL_MODELO+'</td>'
 cMen +=' </tr>'
  cMen +=' <tr>'
 cMen +='   <td height="23"><div align="right">Quantidade:&nbsp; </div></td>'
 cMen +='   <td>&nbsp;'+STR(ZZZ->ZZL_QTDPC)+'</td>'
 cMen +=' </tr>'
 cMen +=' <tr> '
 cMen +='   <td height="23"><div align="right">Data de retorno prevista: &nbsp;</div></td>'
 cMen +='    <td>&nbsp;'+  DTOC( STOD(ZZZ->ZZL_DTRTPV)) +'</td>'
 cMen +=' </tr>'
 cMen +=' <tr> '
 cMen +='   <td height="23"><div align="right">Motivo da saída: &nbsp;</div></td>'
 cMen +='    <td>&nbsp;'+ZZZ->ZZL_MOTIVO+'</td>'
 cMen +=' </tr>'
cMen +=' <tr> '
 cMen +='   <td height="23"><div align="right">Data da saída: &nbsp;</div></td>'
 cMen +='    <td>&nbsp;'+DTOC( STOD(ZZZ->ZZL_DTSAI)) +'</td>'
 cMen +=' </tr>'
 cMen +=' <tr> '
 cMen +='   <td height="23"><div align="right">Hora da saída: &nbsp;</div></td>'
 cMen +='    <td>&nbsp;'+Transform(StrTran(StrZero(ZZZ->ZZL_HRSAI,5,2),".",""),"@R !!:!!" )+'</td>'
 cMen +=' </tr>'      
  cMen +=' <tr>' 
 cMen +='   <td colspan="2"><div align="center">Situa&ccedil;&atilde;o Atual: <b>Em andameto / Ainda não retornou </b></div></td>'
 cMen +='  </tr>'
 cMen +='</table>'
 cMen +='</td></tr></table>'
 cMen +='<p>&nbsp;</p>'
 cMen +='</body>'
 cMen +='</html>'   
 _cTo:=""     
  nTam := 0
 
  
          _cTo := alltrim(UsrRetMail(ZZZ->ZZL_APROV))         
	      _cTo +=";"+alltrim(UsrRetMail(__cUserId))+";"
	        
		If Right(_cTo,1)==";"
			_cTo:=Substring(_cTo,1,len(_cTo)-1)
		EndIf    
	      
  		oHtml:ValByName("MENS", cMen)
	  	oProcess:cTo  := _cTo   
	  	cMailId := oProcess:Start()       
	  	       DbSelectArea("ZZZ")
              dbSkip() // Avanca o ponteiro do registro no arquivo
       
	  EndDo

DbCloseArea("ZZZ")

return

            

