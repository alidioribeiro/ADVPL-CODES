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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³parada_Tiº Autor ³ William Rodrigues   º Data ³  31/10/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Registros de paradas cadastrada pelos funcionários         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function parada_Ti()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cCadastro := "Cadastro de Paradas"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta um aRotina proprio                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private aRotina := {{"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","U_VisparTi",0,2} ,;
             {"Incluir","U_CadParTi",0,3} ,;
             {"Alterar","U_AltParTi",0,4} ,;
             {"Excluir","U_ExcParTi",0,5},; 
             {"Relatório","U_relParada",0,6},;
             {"Finalizar","U_FinParTi",0,7}}
               

Private opcao:=0 //vetor de carega os dados da solicitação para os email do funcionários     
Private aCores 	  := {{ "ZZP->ZZP_STATUS=='0'", 'BR_AZUL' },;     // Aberto AxInclui
		              { "ZZP->ZZP_STATUS=='1'", 'ENABLE'  },;     // Aprovado
		              { "ZZP->ZZP_STATUS=='2'", 'DISABLE' },;     // Realizado
				      { "ZZP->ZZP_STATUS=='3'", 'BR_PRETO'},;     // Nao Realizado 
				      { "ZZP->ZZP_STATUS=='4'", 'BR_AMARELO'}}    // Nao houve aprovac
Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString := "ZZP"
Private	_cEmpUso  	:= AllTrim(cEmpAnt)+"/",;
		_bFiltraBrw	:= ''
		_aIndexZZP 	:= {}
		_cFiltro  	:= ''    


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
dbSelectArea("ZZP")
dbSetOrder(1)



dbSelectArea(cString)

mBrowse(6,1,22,75,"ZZP",,,,,,aCores)

Return
                          
static Function TelaParadas()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Private cComentSol := Space(60)
Private cComentTec
Private cDoc       := U_GeraSeq("ZZP","ZZP_DOC")
Private cHrSol     := Time()
Private dDtSol     := date()
Private cLisAfet  
Private cListBene 
Private cMat       := cMatSol
Private cNome      := alltrim(Posicione("SRA",1,xFilial("SRA") + cMatSol,"RA_NOME"))
Private cCcDescr   := cDescSol
Private cCcSol     := cCCSoli
Private cNomeTec   := Space(60)
Private cTec       := Space(6)
Private dDtFim     := CtoD(" ")
Private dDtIni     := CtoD(" ")
Private nHrFim     := 0
Private nHrIni     := 0
Private nSelecAfet := Space(6)
Private nSelectBen:= Space(60)    
Private nTipo     := Space(60)    
private cEmailUser:= Space(255)    
//Fução para visualizar
if opcao > 1
cEmailUser := ZZP->ZZP_EMAIL
TiVispar()
EndiF

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg","oFld1","oGrp4","oSay17","oSay18","oSelectBene","oListBene","oGrp5","oSay19","oSay20")
SetPrvt("oTec","oNomeTec","oComentTec","oGrp2","oSay4","oSay7","oSay8","oSay9","oSay11","oSay13","oSay14")
SetPrvt("oMat","oNome","oCcSol","oCcDescr","oHrSol","oDoc","oGrp1","oSay1","oSay2","oSay3","oSay5","oSay6")
SetPrvt("oSay12","oTipo","oDtIni","oHrIni","oDtFim","oHrFim","oComentSol","oGrp3","oSay15","oSay16","oLisAfet")
SetPrvt("oDlg1","oBwComent")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg  := MSDialog():New( 091,237,660,1146,"Cadastro de paradas da T.I",,,.F.,,,,,,.T.,,,.T. )
oDlg:bInit := {||EnchoiceBar(oDlg,{||redirect()},{||oDlg:end()},.F.,{})}

oFld1      := TFolder():New( 016,004,{"Dados do solicitação","Dados Tecnicos"},{},oDlg,,,,.T.,.F.,440,256,)     

oGrp4      := TGroup():New( 004,004,092,432,"Setores beneficiados",oFld1:aDialogs[2],CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay17     := TSay():New( 014,012,{||"Houve setor beneficiados:"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,068,008)
oSay18     := TSay():New( 024,012,{||"Setores Beneficiados com a parada."},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,140,008)
oSelectBen := TComboBox():New( 012,076,{|u| If(PCount()>0,nSelectBene:=u,nSelectBene)},{"","NAO","SIM"},024,010,oGrp4,,,{||f_bene()},CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nSelectBene )
oListBene  := TMultiGet():New( 032,012,{|u| If(PCount()>0,cListBene:=u,cListBene)},oGrp4,412,048,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,{||f_lisbene()},,.F.,,  )

oGrp5      := TGroup():New( 096,004,236,432,"Parecer tecnico",oFld1:aDialogs[2],CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay19     := TSay():New( 104,012,{||"Tecnico:"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay20     := TSay():New( 104,068,{||"Nome:"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay21     := TSay():New( 128,012,{||"Comentários tecnico:"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,008)
oTec       := TGet():New( 112,012,{|u| If(PCount()>0,cTec:=u,cTec)},oGrp5,044,008,'',{||f_tec()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ZU","cTec",,)
oNomeTec   := TGet():New( 112,068,{|u| If(PCount()>0,cNomeTec:=u,cNomeTec)},oGrp5,356,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cNomeTec",,)
oComentTec := TMultiGet():New( 136,012,{|u| If(PCount()>0,cComentTec:=u,cComentTec)},oGrp5,412,092,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )

oGrp2      := TGroup():New( 004,004,084,432,"Dados do Funcionário",oFld1:aDialogs[1],CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay4      := TSay():New( 011,008,{||"Documento:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oSay7      := TSay():New( 033,008,{||"Matricula:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay8      := TSay():New( 033,060,{||"Funcioário:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oSay9      := TSay():New( 056,008,{||"C. Custo:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay11     := TSay():New( 056,061,{||"Descrição:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay13     := TSay():New( 011,060,{||"Dt. Solicitação:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
oSay14     := TSay():New( 011,117,{||"Hr. Solicitação:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,047,008)
oDtSol     := TGet():New( 023,060,{|u| If(PCount()>0,dDtSol:=u,dDtSol)},oGrp2,048,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","dDtSol",,)
oMat       := TGet():New( 045,008,{|u| If(PCount()>0,cMat:=u,cMat)},oGrp2,047,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cMat",,)
oNome      := TGet():New( 045,060,{|u| If(PCount()>0,cNome:=u,cNome)},oGrp2,364,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cNome",,)
oCcSol     := TGet():New( 066,008,{|u| If(PCount()>0,cCcSol:=u,cCcSol)},oGrp2,047,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cCcSol",,)
oCcDescr   := TGet():New( 066,060,{|u| If(PCount()>0,cCcDescr:=u,cCcDescr)},oGrp2,364,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cCcDescr",,)
oHrSol     := TGet():New( 023,117,{|u| If(PCount()>0,cHrSol:=u,cHrSol)},oGrp2,047,008,'99:99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cHrSol",,)
oDoc       := TGet():New( 023,008,{|u| If(PCount()>0,cDoc:=u,cDoc)},oGrp2,047,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cDoc",,)

oGrp1      := TGroup():New( 088,004,144,432,"Dados da parada",oFld1:aDialogs[1],CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 098,008,{||"Tipo de parada:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oSay2      := TSay():New( 098,084,{||"Data do inicio:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oSay3      := TSay():New( 098,136,{||"Hora Inicio"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay5      := TSay():New( 098,188,{||"Data do fim"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay6      := TSay():New( 098,240,{||"Hora Fim"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay10     := TSay():New( 108,172,{||"Até"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,012,008)
oSay12     := TSay():New( 120,008,{||"Comentarios do solicitante."},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,068,008)
oTipo      := TComboBox():New( 106,008,{|u| If(PCount()>0,nTipo:=u,nTipo)},{"","SINAL DE REDE","THIN CLIENT","TELEFONIA","MICROSIGA","INTERNET","EMAIL","OUTROS"},068,010,oGrp1,,,{||f_tipo()},CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nTipo )
oDtIni     := TGet():New( 106,084,{|u| If(PCount()>0,dDtIni:=u,dDtIni)},oGrp1,044,008,'',{||f_dtini()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDtIni",,)
oHrIni     := TGet():New( 106,136,{|u| If(PCount()>0,nHrIni:=u,nHrIni)},oGrp1,032,008,'99.99',{||f_hrini()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nHrIni",,)
oDtFim     := TGet():New( 106,188,{|u| If(PCount()>0,dDtFim:=u,dDtFim)},oGrp1,044,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDtFim",,)
oHrFim     := TGet():New( 106,240,{|u| If(PCount()>0,nHrFim:=u,nHrFim)},oGrp1,032,008,'99.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nHrFim",,)
oComentSol := TGet():New( 128,008,{|u| If(PCount()>0,cComentSol:=u,cComentSol)},oGrp1,416,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"Digiti o comentário",,,.F.,.F.,,.F.,.F.,"","cComentSol",,)

oGrp3      := TGroup():New( 148,004,232,432,"Setores Afetados:",oFld1:aDialogs[1],CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay15     := TSay():New( 160,008,{||"Lista de setores afetados"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,068,008)
oSay16     := TSay():New( 220,008,{||"Seu setor foi afetado:"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,056,008)


oLisAfet   := TMultiGet():New( 168,008,{|u| If(PCount()>0,cLisAfet:=u,cLisAfet)},oGrp3,416,044,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.T.,,,.F.,,  )
oSelecAfet := TComboBox():New( 216,060,{|u| If(PCount()>0,nSelecAfet:=u,nSelecAfet)},{"","NAO","SIM"},028,010,oGrp3,,,{||f_afet()},CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nSelecAfet )                          
//desabilitando campos
DesabiBt()
if opcao < 3  
	oTipo      :enable() 
	oDtIni     :enable()
	oHrIni     :enable() 
	oDtFim     :enable() 
	oHrFim     :enable() 
	oComentSol :enable()  
	oSelecAfet :enable()  
Elseif opcao = 3                 
    //desabilita os adicionamento de setores afetados
    If ZZP->ZZP_STATUS <> '2'
   	oSelecAfet :enable()    
   	EndiF
   	oFld1:aDialogs[2]:enable()    
Elseif opcao = 4
    oFld1:aDialogs[2]:enable()  
    oComentTec :enable()  
    oTec       :enable()  
    oListBene  :enable()  
    oSelectBen :enable()
    oDtFim     :enable()
	oHrFim     :enable()     
EndIF
oDlg:Activate(,,,.T.)
Return        


static function telaAfeta()
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/        

Private ccAfe      := cCCSoli
Private cCcDAfer   := cDescSol
Private cInforme   := Space(60)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oGrp1","oSay1","oSay2","oSay3","oInforme","occAfe","oCcDAfer","oOkB","oCanB")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 111,280,383,844,"Informações",,,.F.,,,,,,.T.,,,.T. )
oGrp1      := TGroup():New( 008,008,104,260,"Dados da pardada",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 044,016,{||"Informe onde ou como foi afetado:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,096,008)
oSay2      := TSay():New( 020,016,{||"C. Custo:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay3      := TSay():New( 020,076,{||"Descrição "},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oInforme   := TGet():New( 052,016,{|u| If(PCount()>0,cInforme:=u,cInforme)},oGrp1,236,034,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cInforme",,)
occAfe     := TGet():New( 028,016,{|u| If(PCount()>0,ccAfe:=u,ccAfe)},oGrp1,044,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"CTT",,,.F.,.F.,,.F.,.F.,"","ccAfe",,)
oCcDAfer   := TGet():New( 028,076,{|u| If(PCount()>0,cCcDAfer:=u,cCcDAfer)},oGrp1,176,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cCcDAfer",,)
oOkB       := TButton():New( 108,080,"OK",oDlg1,{||TiCadAfet()},037,012,,,,.T.,,"",,,,.F. )
oCanB      := TButton():New( 108,144,"Cancelar",oDlg1,{||oDlg1:end()},037,012,,,,.T.,,"",,,,.F. )

occAfe     :Disable()
oCcDAfer   :Disable()

oDlg1:Activate(,,,.T.)

return 

static function DesabiBt()
	oSelectBen :Disable() 
	oListBene  :Disable() 
	oTec       :Disable() 
	oNomeTec   :Disable() 
	oComentTec :Disable() 
	oDtSol     :Disable() 
	oMat       :Disable() 
	oNome      :Disable() 
	oCcSol     :Disable() 
	oCcDescr   :Disable() 
	oHrSol     :Disable() 
	oDoc       :Disable() 
	oTipo      :Disable() 
	oDtIni     :Disable() 
	oHrIni     :Disable() 
	oDtFim     :Disable() 
	oHrFim     :Disable() 
	oComentSol :Disable()      
	oFld1:aDialogs[2]:Disable()
	///oLisAfet   :Disable() 
	oSelecAfet :Disable() 
return
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± validações nos campos
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
                        
static function f_tipo()  
Local bool := .T. 
	     if AllTrim(nTipo) = ''
	       Alert("Selecione O tipo de parada!")
	       bool := .F.
		EndIF		
return(bool)       

 
static function f_dtini()

Local bool := .T. 
	   if dDtIni = CtoD(" ")
	       Alert("Informe a data de inicio da parada!")
	       bool := .F. 
        Else
           	cQuery := " SELECT * FROM ZZP010 WHERE ZZP_TIPO ='"+AllTrim(nTipo)+"' AND ZZP_DTINI = '"+Dtos(dDtIni)+"' AND ZZP_STATUS = '4'"
			Query := ChangeQuery(cQuery)
			TCQUERY cQuery Alias TRA New  			
			dbSelectArea("TRA")            
			
			IF Alltrim(TRA->ZZP_DOC) <> ''
			   
			    Msgbox("Atenção já existe uma parada com o tipo e data registrada, você deseja comenta-lá!","Mensage","INFO")   
				cDoc := TRA->ZZP_DOC 
				dbCloseArea("TRA")
				  dbSelectArea("ZZP") 
				  DbSetOrder(1)     
				  DbGotop()          
                 If DbSeek(xFilial("ZZP")+cDoc)     
			    	cLisAfet :=ZZP->ZZP_LISAFE 
			    	cEmailUser:=ZZP->ZZP_EMAIL
				 EndIF         
				 
				opcao = 3 // para registro 
				
				telaAfeta()				   
				Close(oDlg)
	        EndIF
	        	dbCloseArea("TRA")
						 
		EndIF		
return(bool)                        

static function f_hrini()

Local bool := .T. 
if nHrIni = 0
	       Alert("Informe a hora de inicio da parada!")
	       bool := .F.
		EndIF		
return(bool)                            

static function f_afet()  
	Local bool := .T. 
	Local cTrueDoc
	     if AllTrim(nSelecAfet) = ''
	       Alert("Selecione se o seu setor foi afetado")
	       bool := .F.
	     Elseif AllTrim(nSelecAfet) = 'SIM'
	       cTrueDoc := alltrim(Posicione("ZZO",3,Alltrim(cDoc+cCcSol),"ZZO_DOC"))    
	       if (cTrueDoc == '')
	       telaAfeta()
	       bool := .T.          
	       Else
	       bool := .F.   
	       Alert("Seu setor já comentou!")
	       EndIF
		EndIF		
return(bool)       

static function f_bene()
Local bool := .T.
If Alltrim(nSelectBene) = ''
Alert("Selecione se houve setor beneficiados com a parada!")
bool:=.F.
EndiF
return(bool)               

static function f_tec() 
Local bool := .T.
If Alltrim(cTec) = ''
Alert("Selecione o tecnico")
bool:=.F.
Else   
cNomeTec:= Upper(UsrFullName(cTec))
If Alltrim(cNomeTec) = ''
Alert("Selecione o tecnico")
bool:=.F.         
EndIF
EndIF
return(bool)                

static function f_hrfim()
Local bool := .T.
	If nHrFim = 0          
       Alert("Informe a Hora do fim da parada!")
	   bool:= .F.
	EndIF
return(bool)     

static function f_dtfim()     
Local bool := .T.
	If dDtFim = CtoD(" ")
       Alert("Informe a data do fim da parada!")
	   bool:= .F.
	EndIF
return(bool)  

static function f_lisbene()     
Local bool := .T. 
    IF Alltrim(nSelectBene) = 'SIM' 
	If cListBene = ""
       	Alert("Informe os setores!")
	    bool:= .F.
	EndIF   
	EndIF
return(bool)  
   

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Opições
   1 - Cadastro de agente de portaria - Entrada de veiculos
   2 - Alteração 
   3 - Visualizar
   4 - Finalização 
   5 - Excluir   
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

user function CadParTi()     
	opcao:=1
	TelaParadas()
return
user function AltParTi()
  IF AllTrim(ZZP->ZZP_IDUSER) =__cUserId .Or. cNivel > 8
	opcao:=2
	TelaParadas()
  Else
     	Msgbox("Você não pode alterar, somente que fez esse solicitação!","Mensage","INFO")   
  EndIF
return     
           
user function VisparTi()
	opcao:=3       
	TelaParadas()
return     

user function FinParTi()  
    If cNivel > 8 
		opcao:=4
		TelaParadas()
    Else
    	Alert("você não pode finalizar esse registro!")
	EndIF
return
   
user function ExcParTi()
 IF AllTrim(ZZP->ZZP_IDUSER) =__cUserId   .Or. cNivel > 8
	opcao:=5
	TelaParadas()
 Else 
    Msgbox("Você não excluir, somente que fez esse solicitação!","Mensage","INFO")    
 EndIF
	
return
            
         
         
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Opições
   1 - Cadastro de agente de portaria - Entrada de veiculos
   2 - Alteração 
   3 - Visualizar
   4 - Finalização 
   5 - Excluir   
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

static function redirect()

Local lPadrao:= .F.
If opcao = 1       
   IF lPadrao := Msgbox("Você confirma o cadastro !","Atenção","YESNO")   
    TiCadPar()
    Msgbox("Solicitação Registrada com sucesso!","Mensage","INFO")         
    Close(oDlg)
   EndIF    
ElseIf opcao = 2  
   lPadrao:=Msgbox("Você confirma Alteração!","Atenção","YESNO")    
   if lPadrao           
    TiAltPar()
	Msgbox("Alteração reslizada com Sucesso!","Mensage","INFO")         
    Close(oDlg)
   Endif
ElseIf opcao = 3  
    Close(oDlg)    
ElseIf opcao = 4     
   If f_tec()= .T. .And. f_dtfim()= .T. .And. f_hrfim()= .T.    
   		IF lPadrao := Msgbox("Você confirma a Finalização!","Atenção","YESNO")   
        	TiFinPar()
    		Msgbox("O registro foi Finalizada!","Mensage","INFO")         
      		Close(oDlg)
   		EndIF  
   EndIF
ElseIf opcao = 5
   IF lPadrao := Msgbox("Você confirma a exclusão!","Atenção","YESNO")    
    TiExcPar()   
   	Msgbox("Exclusão realizado com Sucesso!","Mensage","INFO")         
    Close(oDlg)                                                         
   EndIF
EndIF

return   
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Opições
   1 - Cadastro de agente de portaria - Entrada de veiculos
   2 - Alteração 
   3 - Visualizar
   4 - Finalização 
   5 - Excluir   
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

static function TiCadPar()

dbSelectArea("ZZP") 
RecLock("ZZP",.T.)  
ZZP->ZZP_FILIAL :=xFilial()
ZZP->ZZP_DOC    :=U_GeraSeq("ZZP","ZZP_DOC")     
ZZP->ZZP_DTSOL  :=dDtSol
ZZP->ZZP_HRSOL  :=cHrSol      
ZZP->ZZP_MAT    :=cMat
ZZP->ZZP_NOME   :=cNome 
ZZP->ZZP_CCUSTO :=cCcSol
ZZP->ZZP_CCDESC :=cCcDescr
ZZP->ZZP_TIPO   :=nTipo 
ZZP->ZZP_DTINI  :=dDtIni
ZZP->ZZP_HRINI  :=nHrIni
ZZP->ZZP_DTFIM  :=dDtFim
ZZP->ZZP_HRFIM  :=nHrFim          
ZZP->ZZP_COMSOL :=cComentSol
ZZP->ZZP_LISAFE :=cLisAfet  
ZZP->ZZP_TIPO   :=nTipo
ZZP->ZZP_IDUSER :=__cUserId
ZZP->ZZP_EMAIL  :=alltrim(UsrRetMail(__cUserId))+";"
ZZP->ZZP_STATUS :='4'
MsUnlock()          
 
	
dbSelectArea("ZZO")  
 RecLock("ZZO",.T.)  
   ZZO_FILIAL :=xFilial() 
   ZZO_DOC :=cDoc
   ZZO_CUSTO :=cCcSol
 MsUnlock()	
 
return
static function TiAltPar() 
    dbSelectArea("ZZP") 
    DbSetOrder(1)     
	DbGotop()          
    If DbSeek(xFilial("ZZP")+cDoc)     
		RecLock("ZZP",.F.)  
		ZZP_DTSOL  :=dDtSol
		ZZP_HRSOL  :=cHrSol      
		ZZP_MAT    :=cMat
		ZZP_NOME   :=cNome 
		ZZP_CCUSTO :=cCcSol
		ZZP_CCDESC :=cCcDescr
		ZZP_TIPO   :=nTipo 
		ZZP_DTINI  :=dDtIni
		ZZP_HRINI  :=nHrIni
		ZZP_DTFIM  :=dDtFim
		ZZP_HRFIM  :=nHrFim          
		ZZP_COMSOL :=cComentSol
		ZZP_LISAFE :=cLisAfet  
		ZZP_TIPO   :=nTipo
		MsUnlock()          
	EndIF
return   
             
static function TiFinPar()   
 dbSelectArea("ZZP") 
    DbSetOrder(1)     
	DbGotop()          
    If DbSeek(xFilial("ZZP")+cDoc)
		RecLock("ZZP",.F.)    
		ZZP_SETBEN :=nSelectBene
		ZZP_TEC    :=cTec
		ZZP_NOMETC :=cNomeTec
		ZZP_LISBEN :=cListBene
		ZZP_COMTEC :=cComentTec		
		ZZP_STATUS :='2'
		MsUnlock()          
	EndIF
return   

static function TiExcPar()
	dbSelectArea("ZZP") 
    DbSetOrder(1)     
	DbGotop()          
    If DbSeek(xFilial("ZZP")+cDoc)
		RecLock("ZZP",.F.)    
        dbDelete()
		MsUnlock()          
	EndIF
return
static function TiVispar()
	cDoc	  :=ZZP->ZZP_DOC    
	dDtSol	  :=ZZP->ZZP_DTSOL 
	cHrSol    :=ZZP->ZZP_HRSOL  
	cMat	  :=ZZP->ZZP_MAT    
	cNome	  :=ZZP->ZZP_NOME    
	cCcSol	  :=ZZP->ZZP_CCUSTO 
	cCcDescr  :=ZZP->ZZP_CCDESC 
	nTipo	  :=ZZP->ZZP_TIPO   
	dDtIni	  :=ZZP->ZZP_DTINI  
	nHrIni	  :=ZZP->ZZP_HRINI  
	dDtFim	  :=ZZP->ZZP_DTFIM  
	nHrFim	  :=ZZP->ZZP_HRFIM          
	cComentSol:=ZZP->ZZP_COMSOL 
	cLisAfet  :=ZZP->ZZP_LISAFE   
	nTipo	  :=ZZP->ZZP_TIPO   

	nSelectBene:=ZZP->ZZP_SETBEN
	cTec	  :=ZZP->ZZP_TEC    
	cNomeTec  :=ZZP->ZZP_NOMETC 
    cListBene :=ZZP->ZZP_LISBEN 
    cComentTec:=ZZP->ZZP_COMTEC 	
    cEmailUser:=ZZP->ZZP_EMAIL
return                         


static function TiCadAfet()

	cLisAfet+= "C. Custo: "+alltrim(ccAfe)+"   Descrição:"+alltrim(cCcDAfer)+"   Onde foi afetado :  "+alltrim(cInforme)+"/"+"   Funcionário: "+alltrim(Posicione("SRA",1,xFilial("SRA") + cMatSol,"RA_NOME"))+CHR(13)+CHR(10)
	cEmailUser+=alltrim(UsrRetMail(__cUserId))+";"
	//cadastrar os setores afetados no momento da visualização.        	
	
	if opcao = 3 .And. ZZP->ZZP_STATUS <> '2'
		    dbSelectArea("ZZP") 
			DbSetOrder(1)     
			DbGotop()          
	If DbSeek(xFilial("ZZP")+cDoc) 
	
			RecLock("ZZP",.F.) 
		    	ZZP_LISAFE :=cLisAfet 
				ZZP_EMAIL  :=AllTrim(cEmailUser)
	    	MsUnlock()     
	EndIF   
	
dbSelectArea("ZZO")  
 RecLock("ZZO",.T.)  
   ZZO_FILIAL :=xFilial() 
   ZZO_DOC :=cDoc
   ZZO_CUSTO :=cCcSol
 MsUnlock()	
  
 
EndIF       	
oDlg1:end()
	
return  

static function  EnviarMail()  
    
    Local _cTo:=""
    Local supervisor
    
    oProcess := TWFProcess():New( "000001", "Envia Email" )
    oProcess :NewTask( "100001", "\WORKFLOW\SSI.HTM" )
    Do Case
    Case opcao == 1
         oProcess :cSubject := "Registro de Paralização do sistema - T.I"
    Case opcao == 4
         oProcess :cSubject := "Regitro de Paralização do sistema - Finalizações"
    EndCase                    
    
    oHTML    := oProcess:oHTML          
    cMen := " <html>"
    cMen += " <head>"
    cMen += " <title>Controle de Paralização do sistema da T.I</title>"
    cMen += " </head>"    
    cMen += " <body>"
    cMen += ' <table border="1" width="1000px" >'
    cMen += ' <tr align="center" >'    
    cMen += ' <td colspan=11> Dados do Registro </td></tr>'       
    cMen += ' <tr >'
    cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="2" face="Times">Doc</font></td>'  //[1]
    cMen += ' <td align="center" width="15%" bgcolor="#FFFFFF"><font size="2" face="Times">Data/Hora</font></td>'  //[2]
    cMen += ' <td align="center" width="3%"  bgcolor="#FFFFFF"><font size="2" face="Times">Matricula</font></td>'  //[3]
    cMen += ' <td align="center" width="40%" bgcolor="#FFFFFF"><font size="2" face="Times">Nome         </font></td>'  //[4]
    cMen += ' <td align="center" width="3%"  bgcolor="#FFFFFF"><font size="2" face="Times">C.C          </font></td>'  //[5]
    
    cMen += ' <td align="center" width="2%"  bgcolor="#FFFFFF"><font size="2" face="Times">Data da Entrada</font></td>'  //[6]
    cMen += ' <td align="center" width="2%"  bgcolor="#FFFFFF"><font size="2" face="Times">Hora da Chegada</font></td>'  //[7]
    
    cMen += ' <td align="center" width="2%"  bgcolor="#FFFFFF"><font size="2" face="Times">Data da Saída</font></td>'  //[6]
    cMen += ' <td align="center" width="2%"  bgcolor="#FFFFFF"><font size="2" face="Times">Hora da Saída</font></td>'  //[7]
    
   
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
     	  _cTo := alltrim(UsrRetMail(cAprov))
     	    
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
	  	oProcess:cTo  := _cTo   
	  	cMailId := oProcess:Start()
    
return
       
