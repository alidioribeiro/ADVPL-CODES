#include "protheus.ch"
#INCLUDE "rwmake.ch" 
#Include "TOPCONN.CH"
#include "ap5mail.ch" 
#include 'fivewin.ch'  
#include 'hbutton.ch'
#include 'tbiconn.ch' 
#include 'FONT.CH'
#include 'COLORS.CH'

//ALTERACAO ADSON 


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Cont. de Ent. e Saida de Veiculos      º Data ³  06/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function Cesv()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    

Local opcao       := 0     
Local msnTxt      := ""

Private cCadastro := "Controle de Entrada e Saída de Veiculos na NSB"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ recuperando valores do usuário logado                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
xUserVali := __cUserId
PSWORDER(1) //Indexação da senha do usuário pelo ID da senha
aInfoUser := PswRet()
cMatSol   := substr(aInfoUser[1][22],5,6)// aInfoUser[1][30][5] //Subs(aInfoUser[1][30][5])
cCCSoli   := alltrim(Posicione("SRA",1,xFilial("SRA") + cMatSol,"RA_CC"))
cDescSol  := alltrim(Posicione("CTT",1,xFilial("CTT") + cCCSoli,"CTT_DESC01"))
cUser     := __cUserId       




//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta um aRotina proprio                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","U_VisuVeic",0,2} ,;
             {"Incluir","U_InclVei",0,3} ,;
             {"Alterar","U_AlterVei",0,4} ,;
             {"Excluir","U_ExcVei",0,5},; 
             {"Aprovar","U_AprovVei",0,6},; 
             {"Prosseguir","U_AndamentVei",0,7},;
             {"Cancelar","U_CanVei",0,8},;
             {"Relatorio","U_RelVeiculo",0,9},; 
             {"Tabela de Horario","U_FiltroV",0,10},;
             {"Finalizar","U_FinVei",0,11},;
              {"Legenda","U_CHAMLeng",0,12}}                                             
             Private aCores := {{ "ZZJ->ZZJ_STATUS=='0'", 'BR_AZUL' },;     // Aberto 
		              { "ZZJ->ZZJ_STATUS=='1'", 'ENABLE'  },;     // Aprovado
		              { "ZZJ->ZZJ_STATUS=='2'", 'DISABLE' },;     // Realizado
				      { "ZZJ->ZZJ_STATUS=='3'", 'BR_PRETO'},;     // Nao Realizado 
				      { "ZZJ->ZZJ_STATUS=='4'", 'BR_AMARELO'}}    // Nao houve aprovac

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
                        
                        
Private	_cEmpUso  	:= AllTrim(cEmpAnt)+"/",;
		_bFiltraBrw	:= ''
		_aIndexZZJ 	:= {}
		_cFiltro  	:= '' 
Private cString := "ZZJ"

IF U_ValAprova(cUser,2)  

     _cFiltro := "ALLTRIM(ZZJ->ZZJ_APROV)= '"+Alltrim(cUser)+"' .Or. ALLTRIM(ZZJ->ZZJ_MATID)= '"+Alltrim(cUser)+"'" // .Or. AllTrim(ZZJ->ZZJ_CCUSTO) = '"+AllTrim(cCCSoli)+"' "//.Or. AllTrim(ZZJ->ZZJ_STATUS) = '4'"
     
ElseIf AllTrim(cCCSoli) = '126' .or.  AllTrim(cCCSoli) = '124' 

	_cFiltro := ""
	
ElseIf cNivel > 1 .And. !U_ValAprova(cUser,2) .And. AllTrim(cCCSoli) <> '124' .And.  AllTrim(cCCSoli) <> '614'             

    _cFiltro := "AllTrim(ZZJ->ZZJ_CCUSTO) == '"+Alltrim(cCCSoli)+"'"

Else
    _cFiltro = "AllTrim(ZZJ->ZZJ_STATUS)$'0/1/4'"
    
EndIF	
//teste aglair 20/06/2012
//if AllTrim(cCCSoli) = '126' 	 
//	_cFiltro:=""
//Endif    

If	! Empty(_cFiltro)      
		   	_bFiltraBrw := {|| FilBrowse("ZZJ",@_aIndexZZJ,@_cFiltro) }
			Eval(_bFiltraBrw)                          
EndIf	  
                                                                  
dbSelectArea(cString)
dbSelectArea("ZZJ")
dbSetOrder(1) 

//mBrowse(6,1,22,75,cString,,,,,,aCores)  
mBrowse(6,1,22,75,"ZZJ",,,,,,aCores)  
EndFilBrw("ZZJ",_aIndexZZJ)

Return         
    

Static Function FormVeic(opcao)                  
Local cIdGestor
Local op
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/ 
Private cDoc       := U_GeraSeq("ZZJ","ZZJ_DOC") 
Private cAprov     := PADL(0,6,'0')
Private cCcusto    := Space(9)
Private cCdesc     := Space(30)
Private cCorVeic   := Space(10)
Private cDescVeic  
Private cDestino   := Space(50)
Private dDtCh      := CtoD(" ")
Private cEmpresaSo := Space(30)
Private nHrChPre   := 0
Private nHrChReal  := 0
Private nHrReg     := Time()
Private nHrSaiPre  := 0
Private nHrSaiRel  := 0
Private nHrTotal   := 0
Private nKmCh      := 0
Private nKmSai     := 0
Private nKmTT      := 0
Private nHrTTFim   := 0
Private cMarca     := Space(30)
Private cMatId     := Space(15)
Private cMotivo    
Private cNomeAp    := Space(6)
Private cNomeSol   := Space(60)
Private cObsAp     := Space(50)
Private cObsVeic   
Private cPlaca     := Space(10)
Private cPropiet   := Space(30)
Private cStatus1   := Space(10)
Private cTipoSol   := Space(15)
Private cTipoVeic  := Space(15)
Private dDtReg     := date()     
private dDtEvt     := date()  
Private nBoxExte  
Private nBoxFarol 
Private nBoxInt   
Private nBoxLanter
Private nBoxPneus 
Private nBoxRodas 
Private nCBoxGCh := 0
Private nCBoxGsai:= 0               
                       




if opcao > 2 //todas as opções maiores que dois

VisualizarV() //Seleciona o registro para a visualização               

IF  ZZJ->ZZJ_STATUS = '0'
cStatus1  :="Aberto"
ElSEIF ZZJ->ZZJ_STATUS = '1'
cStatus1  :="Aprovado" 
ElSEIF ZZJ->ZZJ_STATUS = '2'
cStatus1  :="Concluido"
ElSEIF ZZJ->ZZJ_STATUS = '3' 
cStatus1  :="Cancelado"
ElSEIF ZZJ->ZZJ_STATUS = '4'
cStatus1  :="Em Andamento"
EndIF
Endif 

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oFldVei","oGrp3","oSay20","oSay21","oSay27","oSay28","oSay18","oSay19","oSay22")
SetPrvt("oGrp1","oSay1","oSay2","oSay3","oSay4")
SetPrvt("oSay6","oSay7","oSay8","oSay9","oSay10","oSay11","oSay12","oSay13","oSay17","oDoc","oDtReg")
SetPrvt("oMatId","oNomeSol","oCcusto","oCdesc","oHrSaiPre","oHrChPre","oHrTotal","oTipoSol","oEmpresaSol")
SetPrvt("oDestino","oGrp2","oSay14","oSay15","oSay16","oSay38","oAprov","oNomeAp","oStatus1","oObsAp","oPlaca","oTipoVeic","oCorVeic","oPropiet","DescVeic","Acompan")
SetPrvt("oSay24","oSay25","oSay23","oFotoComb","oSay26","oSay29","oSay30","oSay31","oHrSaiRel","oKmSai","oDtEvt")
SetPrvt("oHrChReal","oKmCh","oCBoxGCh","oDtCh","oGrp5","oSay32","oSay33","oSay34","oSay35","oSay36","oSay37")
SetPrvt("oBoxExte","oBoxInt","oBoxFarol","oBoxRodas","oBoxLanter","oBoxPneus","oObsVeic","oCBoxTipo","oSlider","oKmTT","oHrTTFim")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlgVeic        := MSDialog():New( 086,220,730,1200,"Formulario de Requisição de saída de veiculos",,,.F.,,,,,,.T.,,,.T. )
oDlgVeic:bInit  := {||EnchoiceBar(oDlgVeic,{||Redirect()},{||oDlgVeic:end()},.F.,{})}
oFldVei    := TFolder():New( 026,004,{"Dados da Solicitação","Dados do Veiculo","Dados de Finalização"},{},oDlgVeic,,,,.T.,.F.,468,280,) 

oGrp1      := TGroup():New( 004,004,196,460,"Dados do Solicitante",oFldVei:aDialogs[1],CLR_BLACK,CLR_WHITE,.T.,.F. )

oSay1      := TSay():New( 016,012,{||"Documento:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay2      := TSay():New( 016,084,{||"Data do Registro:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
oSay3      := TSay():New( 016,152,{||"Hora do Registro:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
oSay5      := TSay():New( 040,080,{||"Nome do Condutor *:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)  
oSay11     := TSay():New( 065,013,{||"Tipo *:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,035,008)
oSay12     := TSay():New( 065,081,{||"Empresa *:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,030,008)
oSay6      := TSay():New( 088,012,{||"C. de Custo *:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,035,008)
oSay7      := TSay():New( 088,080,{||"Descrição do C. custo:"},oGrp1,,,.F.,.F.,.T.,.T.,CLR_BLACK,CLR_WHITE,056,008)
/*
IF opcao == 1  

oSay8      := TSay():New( 112,080,{||"Hora de Saida*:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,065,008)
oSay9      := TSay():New( 112,012,{||"Hora da Chegada *:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,070,008)

Else    
 */     
oSay14     := TSay():New( 112,012,{||"Data do evento*:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,065,008)
oSay8      := TSay():New( 112,82,{||"Hora de Saida Prevista *:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,065,008)
oSay9      := TSay():New( 112,150,{||"Hora da Chegada Prevista *:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,070,008)
/*                                                                                                 
EndIF         
*/
oSay10     := TSay():New( 112,240,{||"Total de Horas "},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)    

oSay17     := TSay():New( 132,012,{||"Destino *:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,035,008)
oSay13     := TSay():New( 156,012,{||"Motivo *:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,035,008)

oDoc       := TGet():New( 024,012,{|u| If(PCount()>0,cDoc:=u,cDoc)},oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDoc",,)
oDoc:Disable()
oDtReg     := TGet():New( 024,080,{|u| If(PCount()>0,dDtReg:=u,dDtReg)},oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDtReg",,)
oDtReg:Disable()
oHrReg     := TGet():New( 024,148,{|u| If(PCount()>0,nHrReg:=u,nHrReg)},oGrp1,060,008,'99:99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nHrReg",,)
oHrReg:Disable()    

//preenche os campos           
If opcao == 2
cMatId := Subs(aInfoUser[1][22],5,6)
FunPesq()
EndIF

If opcao == 2 .Or. AllTrim(cTipoSol) == "FUNCIONARIO"        

oSay4      := TSay():New( 040,012,{||"Matricula *:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,065,008)
oMatId     := TGet():New( 048,012,{|u| If(PCount()>0,cMatId:=u,cMatId)},oGrp1,060,008,'999999',{||FunPesq()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cMatId",,)
    
ElseIF opcao == 1  .Or. AllTrim(cTipoSol) <> "FUNCIONARIO"                                                                                                                     

oSay4      := TSay():New( 040,012,{||"Indentificação *:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,065,008)
oMatId     := TGet():New( 048,012,{|u| If(PCount()>0,cMatId:=u,cMatId)},oGrp1,060,008,'!!!!!!!!!!!!!!!',{||pesqOutro()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cMatId",,)
/*oMatId     := TGet():New( 048,012,{|u| If(PCount()>0,cMatId:=u,cMatId)},oGrp1,060,008,'999999999999999',{||pesqOutro()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cMatId",,) ALTERADO MIKAEL 06/02/2019 */

EndIF              

oNomeSol   := TGet():New( 048,080,{|u| If(PCount()>0,cNomeSol:=u,cNomeSol)},oGrp1,372,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cNomeSol",,)

IF opcao == 1 .Or. (opcao == 3 .And. cNivel < 5)

oTipoSol  := TComboBox():New(073,013,{|u| If(PCount()>0,cTipoSol:=u,cTipoSol)},{"","FORNECEDOR","TERCERIZADO","GERENTE","CLIENTE"},060,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,cTipoSol )
            
Else

oTipoSol   := TGet():New( 073,013,{|u| If(PCount()>0,cTipoSol:=u,cTipoSol)},oGrp1,060,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nTipoSol",,)

EndIF                                                    

oEmpresaSo := TGet():New( 073,081,{|u| If(PCount()>0,cEmpresaSol:=u,cEmpresaSol)},oGrp1,372,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cEmpresaSol",,)
oCcusto    := TGet():New( 096,012,{|u| If(PCount()>0,cCcusto:=u,cCcusto)},oGrp1,060,008,'999999999',{||pesCcusto()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"CTT","cCcusto",,)
oCdesc     := TGet():New( 096,080,{|u| If(PCount()>0,cCdesc:=u,cCdesc)},oGrp1,372,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cCdesc",,)  
oCdesc:Disable()                                                            

/*                                     
IF opcao == 1 

OHrChPre   := TGet():New( 120,012,{|u| If(PCount()>0,nHrChReal:=u,nHrChReal)},oGrp1,064,008,'99.99',{||CalcHr()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nHrChReal",,)
oHrSaiPre  := TGet():New( 120,080,{|u| If(PCount()>0,nHrSaiRel:=u,nHrSaiRel)},oGrp1,060,008,'99.99',{||CalcHr()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nHrSaiRel",,)
Else
 */
oDtEvt     := TGet():New( 120,012,{|u| If(PCount()>0,dDtEvt:=u,dDtEvt)},oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDtEvt",,) 
oHrSaiPre  := TGet():New( 120,80,{|u| If(PCount()>0,nHrSaiPre:=u,nHrSaiPre)},oGrp1,060,008,'99.99',{||CalcHr()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nHrSaiPre",,)
OHrChPre   := TGet():New( 120,150,{|u| If(PCount()>0,nHrChPre:=u,nHrChPre)},oGrp1,064,008,'99.99',{||CalcHr()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nHrChPre",,)

/*
EndiF
*/                                                           

oHrTotal   := TGet():New( 120,220,{|u| If(PCount()>0,nHrTotal:=u,nHrTotal)},oGrp1,060,008,'99.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nHrTotal",,)

oHrTotal:Disable()                           
oDestino   := TGet():New( 140,012,{|u| If(PCount()>0,cDestino:=u,cDestino)},oGrp1,440,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDestino",,)   
oMotivo    := TMultiGet():New( 164,012,{|u| If(PCount()>0,cMotivo:=u,cMotivo)},oGrp1,440,028,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
oGrp3      := TGroup():New( 004,004,256,460,"Dados do Veiculo",oFldVei:aDialogs[2],CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay20     := TSay():New( 016,012,{||"Placa *:"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
oSay21     := TSay():New( 016,080,{||"Marca *:"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
oSay27     := TSay():New( 037,013,{||"Tipo de veiculo *:"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,047,008)
oSay28     := TSay():New( 037,081,{||"Cor *:"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,030,008)
oSay18     := TSay():New( 060,012,{||"Proprietário *:"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oSay19     := TSay():New( 090,012,{||"Descrição *:"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)

If opcao == 1 .Or. cNivel < 5                                                                                   
oPlaca     := TGet():New( 024,012,{|u| If(PCount()>0,cPlaca:=u,cPlaca)},oGrp3,060,008,'!!!-!!!!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cPlaca",,) 
/*  oPlaca     := TGet():New( 024,012,{|u| If(PCount()>0,cPlaca:=u,cPlaca)},oGrp3,060,008,'999-9999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cPlaca",,) ALTERADO MIKAEL 06/02/2019 - ATENDER NOVO PADRAO DE PLACAS */
Else 
oPlaca     := TGet():New( 024,012,{|u| If(PCount()>0,cPlaca:=u,cPlaca)},oGrp3,060,008,'!!!-!!!!',{||PesqVeic()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ZZUM","cPlaca",,)
/*oPlaca     := TGet():New( 024,012,{|u| If(PCount()>0,cPlaca:=u,cPlaca)},oGrp3,060,008,'!!!-!!!!',{||PesqVeic()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ZZUM","cPlaca",,)ALTERADO MIKAEL 06/02/2019 - ATENDER NOVO PADRAO DE PLACAS*/
EndIF

oMarca     := TGet():New( 024,080,{|u| If(PCount()>0,cMarca:=u,cMarca)},oGrp3,372,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cMarca",,)
oTipoVeic  := TGet():New( 045,013,{|u| If(PCount()>0,cTipoVeic:=u,cTipoVeic)},oGrp3,060,008,'@!',{||valTipo()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ZX","cTipoVeic",,)
oCorVeic   := TGet():New( 045,081,{|u| If(PCount()>0,cCorVeic:=u,cCorVeic)},oGrp3,372,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cCorVeic",,)
oPropiet   := TGet():New( 068,012,{|u| If(PCount()>0,cPropiet:=u,cPropiet)},oGrp3,440,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cPropiet",,)
DescVeic   := TMultiGet():New( 100,012,{|u| If(PCount()>0,cDescVeic:=u,cDescVeic)},oGrp3,440,108,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )

oGrp2      := TGroup():New( 200,004,260,460,"Dados do Aprovador:",oFldVei:aDialogs[1],CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay14     := TSay():New( 212,012,{||"Aprovador *:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
oSay15     := TSay():New( 212,072,{||"Nome do Aprovador:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
oSay16     := TSay():New( 236,012,{||"Status:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay38     := TSay():New( 236,072,{||"Obs:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)

if opcao == 1 .Or. cNivel < 5    
oAprov     := TGet():New( 220,012,{|u| If(PCount()>0,cAprov:=u,cAprov)},oGrp2,048,008,'',{||ValFunc()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SRAPOR","cAprov",,)
Else 
oAprov     := TGet():New( 220,012,{|u| If(PCount()>0,cAprov:=u,cAprov)},oGrp2,048,008,'',{||ValAprovar()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ZZS","cAprov",,)
EndIF

oNomeAp    := TGet():New( 220,072,{|u| If(PCount()>0,cNomeAp:=u,cNomeAp)},oGrp2,380,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cNomeAp",,)
oStatus1   := TGet():New( 244,012,{|u| If(PCount()>0,cStatus1:=u,cStatus1)},oGrp2,048,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cStatus1",,)
oStatus1:Disable()
oObsAp     := TGet():New( 244,072,{|u| If(PCount()>0,cObsAp:=u,cObsAp)},oGrp2,380,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cObsAp",,)

oGrp4      := TGroup():New( 004,004,156,460,"Dados em finalização",oFldVei:aDialogs[3],CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 016,008,{||"Hr. da saída:"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay2      := TSay():New( 016,044,{||"Hr. da Chegada:"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oSay3      := TSay():New( 016,088,{||"Total Hr.:"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay4      := TSay():New( 016,180,{||"KM - Saída:"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay5      := TSay():New( 016,277,{||"KM - Chegada:"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oSay6      := TSay():New( 016,372,{||"KM - Total:"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oBmp1      := TBitmap():New( 048,124,052,104,,"nivel.jpg",.F.,oGrp4,,,.F.,.T.,,"",.T.,,.T.,,.F. )
oBmp2      := TBitmap():New( 048,261,052,105,,"nivel.jpg",.F.,oGrp4,,,.F.,.T.,,"",.T.,,.T.,,.F. )
oSay7      := TSay():New( 036,128,{||"Nivel Saída - Gás"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,056,008)

oCBoxGsai := TRadMenu():New( 047,180,{"10","9","8","7","6","5","4","3","2","1","0"},,oGrp4,,,CLR_BLACK,CLR_WHITE,"",,,228,020,,.F.,.F.,.T. )
oCBoxGsai:bSetGet := {|u| If(PCount()>0,nCBoxGsai:=u,nCBoxGsai)}    
oCBoxGCh := TRadMenu():New( 047,315,{"10","9","8","7","6","5","4","3","2","1","0"},,oGrp4,,,CLR_BLACK,CLR_WHITE,"",,,228,020,,.F.,.F.,.T. )
oCBoxGCh:bSetGet := {|u| If(PCount()>0,nCBoxGCh:=u,nCBoxGCh)}

//oRClientes:bChange     := { || FiltraCli() }

oSay8      := TSay():New( 037,261,{||"Nivel Chegada - Gás"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,056,008)
oSay16     := TSay():New( 016,124,{||"Data Chegada:"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oHrSaiRel  := TGet():New( 024,008,{|u| If(PCount()>0,nHrSaiRel:=u,nHrSaiRel)},oGrp4,028,008,'99.99',{||CalcHr1()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nHrSaiRel",,)
oHrChReal  := TGet():New( 024,047,{|u| If(PCount()>0,nHrChReal:=u,nHrChReal)},oGrp4,028,008,'99.99',{||CalcHr1()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nHrChReal",,)
oHrTTFim   := TGet():New( 024,086,{|u| If(PCount()>0,nHrTTFim:=u,nHrTTFim)},oGrp4,028,008,'99.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nHrTTFim",,)
oKmSai     := TGet():New( 024,180,{|u| If(PCount()>0,nKmSai:=u,nKmSai)},oGrp4,080,008,'9999999999999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nKmSai",,)
oKmCh      := TGet():New( 025,277,{|u| If(PCount()>0,nKmCh:=u,nKmCh)},oGrp4,080,008,'9999999999999',{||CalcKmTT()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nKmCh",,)
oKmTT      := TGet():New( 025,373,{|u| If(PCount()>0,nKmTT:=u,nKmTT)},oGrp4,080,008,'9999999999999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nKmTT",,)
oDtCh      := TGet():New( 024,120,{|u| If(PCount()>0,dDtCh:=u,dDtCh)},oGrp4,048,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDtCh",,)

oGrp5      := TGroup():New( 160,004,260,460,"Vistória Chegada",oFldVei:aDialogs[3],CLR_BLACK,CLR_WHITE,.T.,.F. ) 

oSay9      := TSay():New( 176,020,{||"Externo:"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay10     := TSay():New( 176,096,{||"Pneus"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay11     := TSay():New( 176,168,{||"Rodas"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay12     := TSay():New( 176,244,{||"Lanternas"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay13     := TSay():New( 176,320,{||"Forol"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay14     := TSay():New( 176,396,{||"Interno"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay15     := TSay():New( 200,020,{||"Observação:"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)

oBoxExte   := TComboBox():New( 184,020,{|u| If(PCount()>0,nBoxExte:=u,nBoxExte)},{"","OK","NG"},048,010,oGrp5,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBoxExte )
oBoxPneus  := TComboBox():New( 184,097,{|u| If(PCount()>0,nBoxPneus:=u,nBoxPneus)},{"","OK","NG"},048,010,oGrp5,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBoxPneus )
oBoxRodas  := TComboBox():New( 184,169,{|u| If(PCount()>0,nBoxRodas:=u,nBoxRodas)},{"","OK","NG"},048,010,oGrp5,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBoxRodas )
oBoxLanter := TComboBox():New( 184,245,{|u| If(PCount()>0,nBoxLanter:=u,nBoxLanter)},{"","OK","NG"},048,010,oGrp5,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBoxLanter )
oBoxFarol  := TComboBox():New( 184,321,{|u| If(PCount()>0,nBoxFarol:=u,nBoxFarol)},{"","OK","NG"},048,010,oGrp5,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBoxFarol )
oBoxInt    := TComboBox():New( 184,397,{|u| If(PCount()>0,nBoxInt:=u,nBoxInt)},{"","OK","NG"},048,010,oGrp5,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBoxInt )
oObsVeic   := TMultiGet():New( 208,020,{|u| If(PCount()>0,cObsVeic:=u,cObsVeic)},oGrp5,428,044,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )

//Desabilita para não edição de funcionário
if opcao == 2   

//desabilita campos
SelecVisual()   


oHrSaiPre:Enable()
oHrChPre:Enable()
oMotivo:Enable()                  
oDestino:Enable()
oAprov  :Enable()
oDtEvt:Enable()

//VEICULO
oPlaca:Enable() 
                               
ElseIF opcao == 1
//desabilita campos
SelecVisual()

oMatId:Enable()
oNomeSol:Enable()
oTipoSol:Enable()
oEmpresaSo:Enable()
oMotivo:Enable()                  
oDestino:Enable()
oAprov  :Enable()
//VEICULO
oPlaca:Enable() 
oMarca:Enable()
oTipoVeic:Enable()
oPropiet:Enable()   
DescVeic:Enable()
oHrChReal:Enable()       

EndIf

//Visualização  
if 3 <= opcao  
//desabilita campos
SelecVisual()
EndIf              


//amdamento  
if opcao == 7
//desabilita campos
SelecVisual()
//Habilita
oKmSai:Enable()
oHrSaiRel:Enable()
oCBoxGsai:Enable()
EndIf

//Finalização  
if opcao == 6
//desabilita campos
SelecVisual() 
If AllTrim(ZZJ->ZZJ_TIPOSO) = "FUNCIONARIO"  
  
oHrChReal:Enable()
oKmCh    :Enable()
oCBoxGCh :Enable()
oDtCh :Enable()
oBoxExte :Enable()
oBoxInt  :Enable()
oBoxFarol:Enable()
oBoxRodas:Enable()
oBoxLanter:Enable()
oBoxPneus :Enable()
oObsVeic  :Enable()

     
Else
oHrSaiRel:Enable()
EndIF

EndIf                 

//Alterar Solicitação
If opcao == 3 .And. cNivel < 5       
//desabilita campos
SelecVisual()

oMatId:Enable()
oNomeSol:Enable()
oTipoSol:Enable()
oEmpresaSo:Enable()
oHrSaiRel:Enable()
oHrChReal:Enable()
oMotivo:Enable()                  
oDestino:Enable()
oAprov  :Enable()
oDtEvt:Enable()
//VEICULO
oPlaca:Enable() 
oMarca:Enable()
oTipoVeic:Enable()
oPropiet:Enable()   
DescVeic:Enable()
oKmSai:Enable()
oHrSaiRel:Enable()
oCBoxGsai:Enable()           

ElseIF opcao == 3 .And. cNivel >= 5                                 
//desabilita campos
SelecVisual()   

oMatId:Enable()
oHrSaiPre:Enable()
oHrChPre:Enable()
oMotivo:Enable()                  
oDestino:Enable()
oAprov :Enable()
oDtEvt:Enable()
//VEICULO
oPlaca:Enable() 
                               

EndIf    
    
//Adicionar ao compo observação do aprovador

If opcao <> 5
   

oObsAp :Disable()                  

Else   

oObsAp :Enable()                  

EndIF


oDlgVeic:Activate(,,,.T.)

Return  
                       

Static Function SelecVisual()
//desabilita campos
oMatId:Disable() 
oNomeSol:Disable() 
oTipoSol:Disable() 
oEmpresaSo:Disable() 
oCcusto:Disable()    
oCdesc:Disable()    
oHrSaiPre:Disable()
oHrChPre:Disable()
oHrTotal:Disable()
oDestino:Disable()
oMotivo:Disable()
oPlaca:Disable() 
oMarca:Disable() 
oTipoVeic:Disable() 
oDtEvt:Disable()  
oPropiet:Disable()   
DescVeic:Disable()
oAprov  :Disable()
oNomeAp :Disable()
oStatus1:Disable()
oObsAp  :Disable()
oHrSaiRel:Disable()
oKmSai:Disable()
oCBoxGsai:Disable()
oHrChReal:Disable()
oKmCh    :Disable()
oCBoxGCh :Disable()
oDtCh :Disable()
oBoxExte :Disable()
oBoxInt  :Disable()
oBoxFarol:Disable()
oBoxRodas:Disable()
oBoxLanter:Disable()
oBoxPneus :Disable()
oObsVeic  :Disable()
oHrTTFim:Disable()
oKmTT:Disable()

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
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Funções de Cadastrar solicitação                                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
User function InclVei()  

 if cNivel < 4
 
    opcao:=1 //Cadastro da portaria
    FormVeic(opcao)
    
 Else
    
    opcao:=2//Cadastro do Funcionario
    FormVeic(opcao)     
    
 EndIF

return 

user function VisuVeic()        
    
    opcao   :=8//Visualizar
    FormVeic(opcao)
    
return

user function AlterVei()
  
  If cNivel < 5 
  
    opcao   :=3//Alterar
    FormVeic(opcao)
    
  ElseIf cNivel >= 5 .And. AllTrim(ZZJ->ZZJ_TIPOSO) == "FUNCIONARIO" .And. ZZJ-> ZZJ_STATUS = '0' .And. Alltrim(ZZJ->ZZJ_MATID) == Subs(aInfoUser[1][22],5,6)
  
    opcao   :=3//Alterar
    FormVeic(opcao)   
  
    
  Else
  
    Alert("Você não pode Alterar essa solicitação!")
    
  EndIF
return

user function CanVei()
 
  if AllTrim(ZZJ->ZZJ_MATID) == Subs(aInfoUser[1][22],5,6)  .Or. AllTrim(ZZJ->ZZJ_APROV) == Subs(aInfoUser[1][22],5,6) .Or. cNivel < 5
  
    opcao:=4 //Cancelar
    FormVeic(opcao)  
    
  Else                                    
  
  Alert("Atenção: Não pode cancelar!")    
  
  Endif

return             

user function AprovVei()   
                   
 if U_ValAprova(__cUserId ,2) .And. Alltrim(__cUserId) == ALLTRIM(ZZJ->ZZJ_APROV)   //função para validar o aprovador  	
	if ZZJ-> ZZJ_STATUS = '0' //solicitações pendentes		
		if Alltrim(__cUserId) == ALLTRIM(ZZJ->ZZJ_APROV) .And. ALLTRIM(ZZJ->ZZJ_MATID) == Alltrim(__cUserId)
		 	 Alert("Atenção: Você não tem permissão para aprovar Sua(Própria) solicitação!")
		Else
			opcao:=5//Aprovar
		    FormVeic(opcao)  			
		Endif       
	Else 
		Alert("Atenção: Solicitação já aprovada!")
	EndIF 
 Else 
    Alert("Atenção: Você não tem permissão para aprovar essa solicitação!")
 EndIF  

return

user function FinVei()   

   If cNivel < 5 .And. ZZJ_STATUS = '4'
    opcao:=6 //Finalizar solicitação
    FormVeic(opcao)
   Else 
    Alert("Você não pode finalizar!")
   EndIF
   
return

user function AndamentVei()         

  If cNivel < 5 .And. ZZJ_STATUS = '1'
    
    opcao:=7 //Finalizar solicitação
    FormVeic(opcao)                 
    
   Else 
   
    Alert("Você não pode dá prosseguimento!")
    
   EndIF
return               

user function ExcVei()  

 Alert("Atenção:Você não pode excluir essa solicitação, Entre em contato com a T.I")

return                                              

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Validações de Tipo                                                      ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

static function valTipo()         

 Local Irel := .T.  
 IF Alltrim(cTipoVeic) == "01" .Or. Alltrim(cTipoVeic) == "02" .Or. Alltrim(cTipoVeic) == "03" .Or. Alltrim(cTipoVeic) == "04" 
 Irel := .T.
 ELSE
 Alert("Atenção: Tipo de veiculo Invalido!")
 Irel := .F.
 ENDIF
 
return(Irel)

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
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Funções que redireciona                                                ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

static function Redirect () 

Local lPadrao  

 IF opcao=1
 lPadrao:=Msgbox("Você confirma o cadastro !","Atenção","YESNO")    
 if lPadrao
 CadSolVei()       
 EndIf
        
 ELSEIF opcao=2    
  lPadrao:=Msgbox("Você confirma o cadastro !","Atenção","YESNO")    
 if lPadrao       
 CadSolVei()
 EndIf
        
 ELSEIF opcao=3     
  lPadrao:=Msgbox("Você confirma Alteração!","Atenção","YESNO")    
 if lPadrao
 AlteraV()       
 EndIf
 
 ELSEIF opcao=4      
  lPadrao:=Msgbox("Você confirma o cancelamento!","Atenção","YESNO")    
 if lPadrao
 CancelarV()       
 EndIf
        
 ELSEIF opcao=5
  lPadrao:=Msgbox("Você confirma a aprovação !","Atenção","YESNO")    
  
 if lPadrao
 AprovarV()       
 EndIf
        
 ELSEIF opcao=6   
  lPadrao:=Msgbox("Você confirma a finalização!","Atenção","YESNO")    
 if lPadrao
  If Alltrim(cTipoSol)="FUNCIONARIO"
         IF empty(nBoxExte) .Or. empty(nBoxPneus).Or. empty(nBoxRodas).Or. empty(nBoxLanter).Or. empty(nBoxInt)
         Alert("Atenção: Preencha os campos de vistoria")      
         lPadrao:=.F.
         ElseIF empty(dDtCh)
         Alert("Atenção: Preencha a data Chegada")      
         lPadrao:=.F.        
         EndIF
         
     ELSE
         AndamentoV()        
     ENDIF  
      if lPadrao
         FinalizarV()
      EndIF       
 EndIf
        
 ELSEIF opcao=7
  lPadrao:=Msgbox("Você confirma o andamento!","Atenção","YESNO")    
 if lPadrao

  IF  nCBoxGsai <> 0 .And. nHrSaiRel <> 0 .And. nKmSai <> 0 
         AndamentoV()        
         AndamentoV()         
  Else  
      Alert("Atenção:Preencha os campos de finalização!")
     lPadrao :=.F.
  EndIf
 EndIF       
 ELSEIF opcao=8
        oDlgVeic:end()      
 ENDIF

return(lPadrao)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Pesquisar veiculos                                                      ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
          

static function PesqVeic()   

Local IRel := .T.
DbSelectArea("ZZU")

          DbSetOrder(1)     
          DbGotop()         
           If DbSeek(AllTrim(cPlaca))
		         cMarca     :=ZZU->ZZU_MARCA
                 cTipoVeic  :=ZZU->ZZU_TIPO
                 cCorVeic   :=""
                 cPropiet   :=ZZU->ZZU_PROP
                 cDescVeic  :=ZZU->ZZU_DESC
           Endif
     
        dbCloseArea("ZZU")     
     
         if Empty(cPropiet) .Or. Empty(cTipoVeic)
              alert("PLACA INCORRETA OU VEICULO NÃO CADASTRADA!") 
              IRel := .F.
         ENDIF                                  
      /*
      Seleciona todas iguais a data atual, placa igual, status diferente de cancelados e status diferente de concluidos;
      */   
    cQuery := "SELECT * FROM ZZJ010 WHERE D_E_L_E_T_=''  AND ZZJ_DTEVT = "+Dtos(dDtEvt)+" AND ZZJ_PLACA = '"+AllTrim(cPlaca)+"' AND ZZJ_STATUS <> '3' AND ZZJ_STATUS <> '2' AND ZZJ_TIPOSO = 'FUNCIONARIO' "
    Query := ChangeQuery(cQuery)
    TCQUERY cQuery Alias KRA New 
    dbSelectArea("KRA")
    dbGoTop()
    While !EOF()
      
     
    If opcao <> 3
    if ZZJ_HRSAIP <= nHrSaiPre .And. ZZJ_HRCHPR >= nHrChPre
         alert("Conflito de Horarios... Por favor consulte a tabela de horario e escolha outro veiculo") 
         IRel := .F. 
    ElseIf ZZJ_HRSAIP >= nHrSaiPre .And. ZZJ_HRSAIP <= nHrSaiPre 
         alert("Conflito de Horarios... Por favor consulte a Tabla de horario e escolha Outro veiculo") 
         IRel := .F.  
    ElseIf ZZJ_HRSAIP >= nHrSaiPre .And. ZZJ_HRCHPR <= nHrChPre 
         alert("Conflito de Horarios... Por favor consulte a Tabla de horario e escolha Outro veiculo") 
         IRel := .F. 
    ElseIf ZZJ_HRSAIP >= nHrSaiPre .And. ZZJ_HRCHPR <= nHrChPre 
         alert("Conflito de Horarios... Por favor consulte a Tabla de horario e escolha Outro veiculo") 
         IRel := .F.    
    ElseIf ZZJ_HRSAIP <= nHrSaiPre .And. ZZJ_HRCHPR >= nHrSaiPre
         alert("Conflito de Horarios... Por favor consulte a Tabla de horario e escolha Outro veiculo") 
         IRel := .F. 
    ElseIf ZZJ_HRSAIP >= nHrSaiPre .And. ZZJ_HRCHPR >= nHrSaiPre .And. ZZJ_HRSAIP <= nHrChPre
         alert("Conflito de Horarios... Por favor consulte a Tabla de horario e escolha Outro veiculo") 
         IRel := .F.      
    
    EndIF
    EndIF 
        dbSkip() // Avanca o ponteiro do registro no arquivo
    EndDo
	      
    
    dbCloseArea("KRA")  
    
    //chamando a tabeçda de horarios           
    
    if IRel = .F. 
         cAteV :=cPlaca
         cDeV  :=cPlaca
         TabelaHr()           
    	cPlaca     :=space(10)
    	cMarca     :=""
        cTipoVeic  :=""
        cCorVeic   :=""
        cPropiet   :=""
        cDescVeic  :=""
    
    EndIF
      

    
return(IRel)               

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Validar aprovador                                                ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Static function ValAprovar()              
Local lRet := .F.

 if lRet := U_ValAprova(cAprov,2) .And. Alltrim(__cUserId) <> ALLTRIM(cAprov)
   cNomeAp:= alltrim(Posicione("ZZS",2,cAprov,"ZZS_NUSER"))     
 Else 
    alert("Aprovador selecionado não pode aprovar essa solicitação, Por favor Informe outros aprovador!")
    cAprov  := Space(len(cAprov))
    cNomeAp := Space(len(cNomeAp))
 EndIF
 
return()//retorna Falso ou Verdadeiro

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Pesquisar Centro de custo                                               ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

static function pesCcusto()
Local IRel := .T.
cCdesc := alltrim(Posicione("CTT",1,xFilial("CTT") + cCcusto,"CTT_DESC01"))
if AllTrim(cCdesc)=""
 Alert("Centro de Custo Incorreto!")
 IRel := .F.
EndIF
Return(IRel)                

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Pesquisar Aprovador se for funcionário                                  ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

                                                                              
static function ValFunc()

Local lRet   := .T.

cAprov := PADL(ALLTRIM(cAprov),6,'0')

DbSelectArea("SRA")
DbSetOrder(1)     
          
If DbSeek(xFilial("SRA") + cAprov)
    cNomeAp := SRA->RA_NOME   
    cIdGestor  := alltrim(Posicione("ZZS",1,SRA->RA_CC,"ZZS_USER"))  		                		               		      
Endif
    
if empty(SRA->RA_MAT)
     
    cQuery := " SELECT RA_NOME,RA_CC,RA_DEMISSA,RA_MAT FROM SRA010 WHERE D_E_L_E_T_='' AND  RA_MAT = '" +cAprov+ "'"
    Query := ChangeQuery(cQuery)
    TCQUERY cQuery Alias TRA New 
    dbSelectArea("TRA")
    
    cNomeAp := TRA->RA_NOME
    cIdGestor  := alltrim(Posicione("ZZS",1,TRA->RA_CC,"ZZS_USER"))  		

EndIF                                                                                    

           
If empty(cNomeAp)
   Alert("Atenção: Matricula Não Encontrada")
   lRel := .F.
EndIF                        
                
dbCloseArea("TRA")
dbCloseArea()

Return(lRet) 

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Calcular Horas                                                          ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/ 

static function CalcHr ()

Local IRel := .T.
             
if  nHrChPre > 23.59
    alert("Hora de Chegada superior a 24H informe entre 00.00 á 23.59")
    IRel := .F.  
    
elseIf nHrSaiPre > 23.59
    alert("Hora da Saida superior a 24H informe entre 00.00 á 23.59")
    IRel := .F.
elseIf !empty(nHrChPre) .And. nHrSaiPre > nHrChPre      

    alert("Informe o horario correto!")
    IRel := .F.
    
else           

    nHrTotal   := SubHoras(nHrChPre ,nHrSaiPre) //calcular Horario  
    
EndIF
return(IRel)                                                                               

static function CalcHr1 () //calcular hora da saida e entrada na situação real

Local IRel := .T.   

if  nHrChReal > 23.59          

    alert("Hora de Chegada superior a 24H informe entre 00.00 á 23.59")
    IRel := .F.  
    
elseIf nHrSaiRel > 23.59
    alert("Hora da Saida superior a 24H informe entre 00.00 á 23.59")
    IRel := .F.
elseIf !empty(nHrChReal) .And. nHrSaiRel > nHrChReal

    alert("Informe o horario correto!")
    IRel := .F.
    
else           

    nHrTTFim   := SubHoras(nHrChReal,nHrSaiRel) //calcular Horario  
    
EndIF
return(IRel)                                                                               

static function CalcKmTT () //calcular hora da saida e entrada na situação real

Local IRel := .T.             

if  nKmSai > nKmCh          
    alert("Atenção:Icorreto!")
    IRel := .F.    
else           
    nKmTT   := (nKmCh-nKmSai) //calcular Horario      
EndIF
return(IRel)                                                                               

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Consultas dados do Solicitante                                          ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/ 


static function FunPesq()    

Local lRet   := .T.
Local a_Area := GetArea() 
Local cCodTurno
Local cAux    
Local cTeste  

cStatus1  :="Aberto"
cNomeSol := ""
cCcusto := ""
cEmpresaSo:=""   
cTipoSol :=""
cCdesc  := ""
cMatId := STRZERO(VAL(cMatId),6)


          DbSelectArea("SRA")  
          DbSetOrder(1)     
          DbGotop()
          If DbSeek(xFilial("SRA") + cMatId)     
             If SRA->RA_DEMISSA = CtoD(" ")
		      cMatId    := SRA->RA_MAT  
		      cNomeSol  := SRA->RA_NOME
		      cCcusto   := SRA->RA_CC        
		      cEmpresaSo:="NIPPON SEIKI DO BRASIL LTDA."   
		      cTipoSol  :="FUNCIONARIO"
              cCdesc    := alltrim(Posicione("CTT",1,xFilial("CTT") + cCcusto,"CTT_DESC01"))   
             EndIF          		               		      
          Endif     
          
if empty(cNomeSol)
     
    cQuery := "SELECT RA_NOME,RA_CC,RA_DEMISSA,RA_MAT,RA_TNOTRAB,RA_DEMISSA,RA_BITMAP FROM SRA020 WHERE  RA_MAT = '" +Alltrim(cMatId)+ "'"
    Query := ChangeQuery(cQuery)
    TCQUERY cQuery Alias TRA New                                         
    dbSelectArea("TRA")
              
              cMatId    :=TRA->RA_MAT  
		      cNomeSol  :=TRA->RA_NOME
		      cCcusto   :=TRA->RA_CC        
		      cEmpresaSo:="NIPPON SEIKI DO BRASIL LTDA." 
		      cTipoSol  :="FUNCIONARIO"
              cCdesc    := alltrim(Posicione("CTT",1,xFilial("CTT") + cCcusto,"CTT_DESC01"))             		               		      
              
    EndIF
                
if empty(cNomeSol)

lRet:= .F.          
Alert("Não Encontrado! Por favor Digite corretamete.")

EndIF      
          
dbCloseArea("TRA")          
dbCloseArea("SRA")

Return(lRet)                                


static Function pesqOutro()

Local lRet   := .T.
Local a_Area := GetArea() 
Local cCodTurno
Local cAux    
Local cTeste  
    cStatus1  :="Aberto"            
    cQuery := "SELECT * FROM ZZJ010 WHERE D_E_L_E_T_=''  AND ZZJ_MATID ='"+Alltrim(cMatId)+"'"
    Query := ChangeQuery(cQuery)
    TCQUERY cQuery Alias TRT New 
    dbSelectArea("TRT")  
    IF Alltrim(TRT->ZZJ_MATID) == Alltrim(cMatId)
           
             cMatId     :=TRT->ZZJ_MATID  
		     cNomeSol   :=TRT->ZZJ_SOLIC
             cEmpresaSo :=TRT->ZZJ_EMPRES		     
             cPlaca     :=TRT->ZZJ_PLACA  
             cMarca     :=TRT->ZZJ_MARCA  
             cTipoVeic  :=TRT->ZZJ_TIPO   
             cCorVeic   :=TRT->ZZJ_COR    
             cPropiet   :=TRT->ZZJ_PPVEIC   
             cTipoSol   :=TRT->ZZJ_TIPOSO
                          
    ENDIF            
      
/*
   
   DbSelectArea("ZZJ")  
   DbSetOrder(2)     
   DbGotop()        
   If DbSeek(Alltrim(cMatId))
   EndIF
   */
             
    cDescVeic  :=Posicione("ZZJ",2,Alltrim(TRT->ZZJ_MATID),"ZZJ_DESCVE")
             
    dbCloseArea("TRT")
      
Return(lRet)


Static function Validar()
Local IOk := .T.   

IF Empty(cMatId) .Or. Empty(cNomeSol) .Or. Empty(cTipoSol) .Or. Empty(cEmpresaSo) .Or. Empty(cDestino).Or. Empty(cMotivo).Or. Empty(cAprov).Or. Empty(cPlaca).Or. Empty(cTipoVeic).Or. Empty(cPropiet) .Or. Empty(cDescVeic) 
	IOk:= .F.
	Alert("PREENCHE OS CAMPOS CORRETAMENTE IDENTIFICADOS COM (*) ASTERISCO")
EndIF                        

IOk:= iif(IOk , PesqVeic() ,IOk)
   

return (IOk)

Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Pesistência na Tabelas                                                  ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

static function CadSolVei()    

Local OK := .T.

Local cIDnum := U_GeraSeq("ZZJ","ZZJ_DOC")

IF AllTrim(cTipoSol) <> "GERENTE"        
    OK := Validar() 
ENDIF
     if cNivel < 5 .And. Empty(nHrChReal)       
        Alert("Preecha o campo Hora da chegada!")
        OK:=.F.
     ElseIF cNivel > 4
        IF Empty(dDtEvt) .Or. nHrSaiPre = 0 .Or. nHrChPre = 0
           Alert("Preecha os campos da saída ou retorno previsto!")
           OK:=.F.
        EndIF
     EndIF
     
if OK   

dbSelectArea("ZZJ") 
RecLock("ZZJ",.T.)

ZZJ_FILIAL := xFilial()    
ZZJ_DOC    :=cIDnum
ZZJ_DTREG  :=dDtReg 
ZZJ_HRREG  :=nHrReg      
ZZJ_IDUSER :=__cUserId
ZZJ_MATID  :=cMatId     
ZZJ_SOLIC  :=cNomeSol    

ZZJ_TIPOSO :=cTipoSol
ZZJ_EMPRES :=cEmpresaSo 
ZZJ_CCUSTO :=cCcusto    
//atribui o nome da empresa na descrição do centro de custo
   if Alltrim(cTipoSol) <> "FUNCIONARIO"
             ZZJ_CNOME  :=cEmpresaSo
   Else
             ZZJ_CNOME  :=cCdesc 
   EndIF
   
ZZJ_HRCHRE :=nHrChReal 
ZZJ_HRSAIR :=nHrSaiRel  
ZZJ_TTHRPR :=nHrTotal  
ZZJ_DTEVT  :=dDtEvt
ZZJ_HRCHPR :=nHrChPre
ZZJ_HRSAIP :=nHrSaiPre  
ZZJ_DESTIN :=cDestino
ZZJ_MOTIVO :=cMotivo     
ZZJ_APROV  :=cAprov    
ZZJ_NAPROV :=cNomeAp
ZZJ_OBSAP  :=cObsAp  
/*CARRO*/
ZZJ_PLACA  :=cPlaca     
ZZJ_MARCA  :=cMarca     
ZZJ_TIPO   :=cTipoVeic 
ZZJ_COR    :=cCorVeic 
ZZJ_PPVEIC :=cPropiet
ZZJ_DESCVE :=cDescVeic
/*
ZZJ_EXTERN :=nBoxExte  
ZZJ_FAROL  :=nBoxFarol 
ZZJ_INTERN :=nBoxInt   
ZZJ_LANTER :=nBoxLanter
ZZJ_PNEU   :=nBoxPneus 
ZZJ_RODAS  :=nBoxRodas 
ZZJ_OBSCAR :=cObsVeic   
*/
/*
ZZJ_KMCHEG :=nKmCh     
ZZJ_KMSAI  :=nKmSai
*/

ZZJ_NGCHEG :=nCBoxGCh  
ZZJ_NGSAI  :=nCBoxGsai 
ZZJ_ACAO   :=cUserName

//SEGUNRAÇA           
if cNivel > 4
   ZZJ_STATUS := "0"     
   MsUnlock()
   EnviarMail()
ELSE  
   ZZJ_STATUS := "4"  
   ZZJ_SEG    :=cUserName
   MsUnlock()
   EnviarMail()
ENDIF

//para não da a mensagem de erro que existe conflito de horario
cPlaca="ZZZ-9999"          
oDlgVeic:end()
              
ENDIF
return

static function AlteraV()  
Local OK := Validar()

if OK
if cNivel < 5 .And. Empty(nHrChReal)       
   Alert("Preecha o campo Hora da chegada!")
ELSE      

dbSelectArea("ZZJ") 

DbSetOrder(1)     
DbGotop()
          
If DbSeek(cDoc)
RecLock("ZZJ",.F.)      

ZZJ_MATID  :=cMatId     
ZZJ_SOLIC  :=cNomeSol   
ZZJ_TIPOSO :=cTipoSol
ZZJ_EMPRES :=cEmpresaSo 
ZZJ_CCUSTO :=cCcusto    
ZZJ_CNOME  :=cCdesc 
ZZJ_HRCHRE :=nHrChReal 
ZZJ_HRSAIR :=nHrSaiRel  
ZZJ_TTHRPR :=nHrTotal     
ZZJ_DTEVT  :=dDtEvt
ZZJ_HRCHPR :=nHrChPre
ZZJ_HRSAIP :=nHrSaiPre  
ZZJ_DESTIN :=cDestino
ZZJ_MOTIVO :=cMotivo     
ZZJ_APROV  :=cAprov    
ZZJ_NAPROV :=cNomeAp
ZZJ_OBSAP  :=cObsAp  
/*CARRO*/
ZZJ_PLACA  :=cPlaca     
ZZJ_MARCA  :=cMarca     
ZZJ_TIPO   :=cTipoVeic 
ZZJ_COR    :=cCorVeic 
ZZJ_PPVEIC :=cPropiet
ZZJ_DESCVE :=cDescVeic

ZZJ_KMSAI  :=nKmSai    
ZZJ_NGSAI  :=nCBoxGsai 
ZZJ_ACAO   :=cUserName 

MsUnlock()                 
Endif
Close(oDlgVeic)
ENDIF              
ENDIF
return

static function CancelarV()

dbSelectArea("ZZJ") 
RecLock("ZZJ",.F.)
   ZZJ_STATUS := "3"  
   ZZZ_ACAO :=cUserName 
   MsUnlock()                 
   oDlgVeic:end()
   EnviarMail()
return          

static function AprovarV()

dbSelectArea("ZZJ") 
RecLock("ZZJ",.F.)
   ZZJ_STATUS := "1"  
   ZZZ_ACAO :=cUserName 
   ZZJ_OBSAP:=cObsAp
   MsUnlock()                 
   oDlgVeic:end()
   EnviarMail()
return                 

static function AndamentoV()

dbSelectArea("ZZJ") 
RecLock("ZZJ",.F.)
   ZZJ_STATUS := "4"  
   ZZZ_ACAO   :=cUserName 
   ZZJ_OBSAP  :=cObsAp
   ZZJ_NGSAI  :=nCBoxGsai  
   ZZJ_HRSAIR :=nHrSaiRel 
   ZZJ_KMSAI  :=nKmSai 
   MsUnlock()                 
   oDlgVeic:end()

return

static function FinalizarV()
           
dbSelectArea("ZZJ") 
RecLock("ZZJ",.F.)
   ZZJ_STATUS := "2"  
   ZZJ_SEG:= cUserName
   ZZJ_HRCHRE := nHrChReal 
   ZZJ_HRSAIR := nHrSaiRel  
   ZZJ_HRTTF  := SubHoras(nHrChReal,nHrSaiRel)   
ZZJ_EXTERN :=nBoxExte  
ZZJ_FAROL  :=nBoxFarol 
ZZJ_INTERN :=nBoxInt   
ZZJ_LANTER :=nBoxLanter
ZZJ_PNEU   :=nBoxPneus 
ZZJ_RODAS  :=nBoxRodas 
ZZJ_NGCHEG :=nCBoxGCh  
ZZJ_NGSAI  :=nCBoxGsai 
ZZJ_OBSCAR :=cObsVeic   
ZZJ_KMCHEG :=nKmCh    
ZZJ_DTCHEG :=dDtCh
ZZJ_NKMTT  :=nKmTT      
 
MsUnlock()                 
Close(oDlgVeic)
EnviarMail() 
return

static function VisualizarV()    

cDoc       :=ZZJ->ZZJ_DOC    
dDtReg     :=ZZJ->ZZJ_DTREG  
nHrReg     :=ZZJ->ZZJ_HRREG  
cMatId     :=ZZJ->ZZJ_MATID  
cNomeSol   :=ZZJ->ZZJ_SOLIC  
cTipoSol   :=ZZJ->ZZJ_TIPOSO 
cEmpresaSo :=ZZJ->ZZJ_EMPRES 
cCcusto    :=ZZJ->ZZJ_CCUSTO 
cCdesc     :=ZZJ->ZZJ_CNOME  
nHrChReal  :=ZZJ->ZZJ_HRCHRE 
nHrSaiRel  :=ZZJ->ZZJ_HRSAIR 
nHrTotal   :=ZZJ->ZZJ_TTHRPR 
dDtEvt     :=ZZJ->ZZJ_DTEVT
nHrChPre   :=ZZJ->ZZJ_HRCHPR 
nHrSaiPre  :=ZZJ->ZZJ_HRSAIP 
cDestino   :=ZZJ->ZZJ_DESTIN 
cMotivo    :=ZZJ->ZZJ_MOTIVO 
cAprov     :=ZZJ->ZZJ_APROV  
cNomeAp    :=ZZJ->ZZJ_NAPROV 
cObsAp     :=ZZJ->ZZJ_OBSAP  
/*CARRO*/
cPlaca     :=ZZJ->ZZJ_PLACA  
cMarca     :=ZZJ->ZZJ_MARCA  
cTipoVeic  :=ZZJ->ZZJ_TIPO   
cCorVeic   :=ZZJ->ZZJ_COR    
cPropiet   :=ZZJ->ZZJ_PPVEIC 
cDescVeic  :=ZZJ->ZZJ_DESCVE
nBoxExte   :=ZZJ->ZZJ_EXTERN 
nBoxFarol  :=ZZJ->ZZJ_FAROL  
nBoxInt    :=ZZJ->ZZJ_INTERN 
nBoxLanter :=ZZJ->ZZJ_LANTER
nBoxPneus  :=ZZJ->ZZJ_PNEU   
nBoxRodas  :=ZZJ->ZZJ_RODAS  
nCBoxGCh   :=ZZJ->ZZJ_NGCHEG 
nCBoxGsai  :=ZZJ->ZZJ_NGSAI  
cObsVeic   :=ZZJ->ZZJ_OBSCAR 
nKmCh      :=ZZJ->ZZJ_KMCHEG 
nKmSai     :=ZZJ->ZZJ_KMSAI   
nHrTTFim   :=ZZJ->ZZJ_HRTTF   
nKmTT      :=ZZJ->ZZJ_NKMTT
dDtCh      :=ZZJ->ZZJ_DTCHEG  

cUserName  :=ZZJ->ZZJ_ACAO   
return      

User Function FiltroV  

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Private cAteV      := Space(8)
Private cDeV       := Space(8)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg2","oGrp1","oSay1","oSay2","oDeV","oAteV","oSBtn1","oSBtn2")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg2      := MSDialog():New( 229,261,424,748,"Filtro de Veiculos",,,.F.,,,,,,.T.,,,.T. )
oGrp1      := TGroup():New( 008,036,076,196,"Filtro",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 024,052,{||"De Veiculo:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay2      := TSay():New( 036,052,{||"Até Veiculo:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oDeV       := TGet():New( 024,084,{|u| If(PCount()>0,cDeV:=u,cDeV)},oGrp1,064,008,'!!!-9999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ZZUM","cDeV",,)
oAteV      := TGet():New( 037,084,{|u| If(PCount()>0,cAteV:=u,cAteV)},oGrp1,064,008,'!!!-9999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ZZUM","cAteV",,)

oSBtn1     := SButton():New( 052,084,1,{||TabelaHr()},oGrp1,,"", )
oSBtn2     := SButton():New( 052,120,2,{||oDlg2:End()},oGrp1,,"", )

oDlg2:Activate(,,,.T.)

Return

    
static Function TabelaHr
    cQuery := "SELECT * FROM ZZJ010 WHERE D_E_L_E_T_=''  AND ZZJ_DTEVT = "+Dtos(date())+" AND ZZJ_STATUS <> '3' AND ZZJ_STATUS <> '2' AND ZZJ_TIPOSO = 'FUNCIONARIO' AND ZZJ_PLACA <= '"+cAteV+"' AND ZZJ_PLACA >= '"+cDeV +"'"
    Query := ChangeQuery(cQuery)
    TCQUERY cQuery Alias TRT New 
    dbSelectArea("TRT")


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/ 

oDlg1       := MSDialog():New( 091,232,592,1273,"Reservado",,,.F.,,,,,,.T.,,,.T. )
oDlg1:bInit := {||EnchoiceBar(oDlg1,{||oDlg1:End()},{||oDlg1:End()},.F.,{})}
oTabCar     := MsSelect():New( "TRT","","",{{"ZZJ_DOC","","Documento",""},{"ZZJ_DTEVT","","Data Evento","@D"},{"ZZJ_HRSAIP","99.99","Hr. Saida Prevista","99.99"},{"ZZJ_HRCHPR","99.99","Hr. Chegada Prevista","99.99"},{"ZZJ_PLACA","","Placa",""},{"ZZJ_MARCA","","Marca",""},{"ZZJ_MATID","","Matricula",""},{"ZZJ_SOLIC","","Solicitante",""},{"ZZJ_CCUSTO","","C. Custo",""},{"ZZJ_APROV","","Aprovador",""}},.F.,,{020,004,204,512},,, oDlg1) 
 
oTabCar:oBrowse:Disable()
oDlg1:Activate(,,,.T.) 

dbCloseArea("TRT")  

Return
 

/* ********** /
*             /
*Enviar Email /
*             /
*/
           
static function  EnviarMail()  
    
    Local _cTo:=""
    Local supervisor     
 
    oProcess := TWFProcess():New( "000001", "Envia Email" )
    oProcess :NewTask( "100001", "\WORKFLOW\SSI.HTM" )    
    oProcess :cSubject := "Informativo de Veiculos na NSB"
    
    
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
 cMen +='<title>Serviço de entrada e saída de veiculos</title>'
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
 cMen +='   <td width="109" height="23"><div align="right">Matricula:&nbsp;</div></td>'
 cMen +='    <td width="364">&nbsp;'+cMatId+'</td>'
 cMen +='  </tr>'
 cMen +='  <tr>'
 cMen +='    <td height="23"><div align="right">Nome:&nbsp;</div></td>'
 cMen +='    <td>&nbsp;'+cNomeSol+'</td>'
 cMen +='  </tr>'
 cMen +='  <tr>'
 cMen +='    <td height="23"><div align="right">Centro de Custo: &nbsp;</div></td>'
 cMen +='   <td>&nbsp;'+cCcusto+'/'+cCdesc+'</td>'
 cMen +=' </tr>'
 cMen +='</table>'
 cMen +='</td></tr>'
 cMen +='<tr><td>'
 cMen +='<table width="489" height="186" border="1" align="left" cellpadding="0" cellspacing="0">'
 cMen +='  <tr>'
 cMen +='   <td height="29" colspan="4"><div align="center">Dados do Ve&iacute;culo </div></td>'
 cMen +='  </tr>'
 cMen +=' <tr>'
 cMen +='   <td width="170" height="23"><div align="right">Placa:&nbsp;</div></td>'
 cMen +='    <td width="319">&nbsp;'+cPlaca+'</td>'
 cMen +='  </tr>'
 cMen +=' <tr>'
 cMen +='   <td height="23"><div align="right">Marca:&nbsp;</div></td>'
 cMen +='    <td>&nbsp;'+cMarca+'</td>'
 cMen +='  </tr>'
 cMen +=' <tr>'
 cMen +='   <td height="19"><p align="right">Destino:&nbsp;</p>    </td>'
 cMen +='    <td>&nbsp;'+cDestino+'</td>'
 cMen +='  </tr>'
 cMen +=' <tr>'
 cMen +='   <td height="23"><div align="right">Hora da Sa&iacute;da Prevista:&nbsp; </div></td>'
 cMen +='    <td>&nbsp;'+Transform(StrTran(StrZero(nHrSaiPre,5,2),".",""),"@R !!:!!" )+'</td>'
 cMen +=' </tr>'
 cMen +=' <tr> '
 cMen +='   <td height="23"><div align="right">Hora da Chegada Prevista: &nbsp;</div></td>'
 cMen +='    <td>&nbsp;'+Transform(StrTran(StrZero(nHrChPre,5,2),".",""),"@R !!:!!" )+'</td>'
 cMen +=' </tr>'
  cMen +=' <tr> '
 cMen +='   <td height="23"><div align="right">Observa&ccedil;&atilde;o do Aprovador: &nbsp;</div></td>'
 cMen +='    <td>&nbsp;'+cObsVeic+'</td>'
 cMen +=' </tr>'
 cMen +=' <tr>'
 cMen +='   <td height="23" colspan="2"><div align="center">Motivo:&nbsp;</div></td>'
 cMen +='  </tr>'
 cMen +=' <tr>'
 cMen +='   <td colspan="2">&nbsp;'+cMotivo+'</td>'
 cMen +='  </tr>'
 cMen +=' <tr>' 
 if opcao = 1
 cMen +='   <td colspan="2"><div align="center">Situa&ccedil;&atilde;o Atual: <b>Entrada autorizada</b></div></td>'
 Elseif opcao = 2
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
 
       IF opcao = 1
          _cTo := alltrim(UsrRetMail(cAprov))         
       ElseIF opcao = 5 .Or.opcao = 4 //.or. opcao = 6
         _cTo +=alltrim(UsrRetMail(ZZJ->ZZJ_IDUSER))+";" +alltrim(UsrRetMail(ZZJ->ZZJ_APROV))+";" 
       EndIF
       
	   IF opcao = 2
	      _cTo := alltrim(UsrRetMail(cAprov))         
	      _cTo +=";"+alltrim(UsrRetMail(__cUserId))
	        
     	    //ADICIONANDO OS SUPEVISORES
     	    dbSelectArea("ZZS")
            dbGoTop()
            While !EOF()
              nTam:= len(ZZS->ZZS_WORKF)                                      
              //SE ALTERAR A PERMISSÃO DE WORKFLOK TEM QUE ALTERAR DAS OUTRAS ROTINA DO MODULO DE PORTARIA EXEMPLO: SSSN
              IF ZZS->ZZS_CCUSTO == cCcusto .And. Alltrim(ZZS->ZZS_WORKF)=="SS" .And. Alltrim(ZZS->ZZS_SUPERV)== "SIM" //SE O CENTRO DE CUSTO DO FUNCIONÁRIO IGUAL AO DO SUPERVIDOR E ENVAR FOR VERDADEIRO //retorna verdadeiro ou falso
	             If ! Empty(_cTo)
		            _cTo +=";"+alltrim(UsrRetMail(ZZS->ZZS_USER))
		         Else  		      
				     _cTo:= alltrim(UsrRetMail(ZZS->ZZS_USER))		         	
		         Endif    
	          EndIF
              
              DbSelectArea("ZZS")
              dbSkip() // Avanca o ponteiro do registro no arquivo
            EndDo
	      
	    EndIF         
	  
		oHtml:ValByName("MENS", cMen)
		_cTo:=Alltrim(_cTo)
		If Right(_cTo,1)==";"
			_cTo:=Substring(_cTo,1,len(_cTo)-1)
		EndIf  
		If !Empty(_cTo)
			oProcess:cTo  := _cTo 
		  	cMailId := oProcess:Start()
		EndIf 	
		  	
//	  	oProcess:cTo  := "aishii@nippon-seikibr.com.br"
        

	  	//enviar email que já está disponível o veiculos para os proximos 
	  	IF opcao = 4 .Or.opcao = 6
            EnviarDisp()   
        EndIF
return   

static function  EnviarDisp()  
    
    Local _cTo:=""
    Local supervisor     
 
    oProcess := TWFProcess():New( "000001", "Envia Email" )
    oProcess :NewTask( "100001", "\WORKFLOW\SSI.HTM" )    
    oProcess :cSubject := "Informativo de Veiculos na NSB"
    
    
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
 cMen +='<title>Serviço de entrada e saída de veiculos</title>'
 cMen +='</head>'
 cMen +='<body>'
 cMen +='<p>&nbsp;</p>'                                                                         
 
 cMen +='<table border="0">'
 cMen +='  <tr>'
 cMen +='   <td>'
 
 cMen +='<table width="489" height="186" border="1" align="left" cellpadding="0" cellspacing="0">'
 cMen +='  <tr>'
 cMen +='   <td height="29" colspan="4"><div align="center">Dados do Ve&iacute;culo </div></td>'
 cMen +=' </tr>'
 cMen +='  <tr>'
 cMen +='    <td width="170" height="23"><div align="right">Placa:&nbsp;</div></td>'
 cMen +='   <td width="319">&nbsp;'+cPlaca+'</td>'
 cMen +=' </tr>'
 cMen +='  <tr>'
 cMen +='   <td height="23"><div align="right">Marca:&nbsp;</div></td>'
 cMen +='   <td>&nbsp;'+cMarca+'</td>'
 cMen +=' </tr>'
 cMen +=' <tr>'
 cMen +='   <td height="23"><div align="right">Horas Prevista: &nbsp;</div></td>'
 cMen +='   <td>&nbsp;'+Transform(StrTran(StrZero(nHrSaiPre,5,2),".",""),"@R !!:!!" )+' &aacute;s '+Transform(StrTran(StrZero(nHrChPre,5,2),".",""),"@R !!:!!" )+'</td>'
 cMen +=' </tr>'
 cMen +=' <tr>'
 cMen +='   <td height="23"><div align="right">Horas Efetivadas:&nbsp; </div></td>'
 cMen +='    <td>&nbsp;'+Transform(StrTran(StrZero(nHrSaiRel,5,2),".",""),"@R !!:!!" )+' &aacute;s '+Transform(StrTran(StrZero(nHrChReal,5,2),".",""),"@R !!:!!" )+'</td>'
 cMen +=' </tr> '
 cMen +=' <tr>'
 cMen +='   <td><div align="right">Ultimo condutor: &nbsp;</div></td><td>&nbsp;'+cNomeSol+'</td>'
 cMen +=' </tr>'
 cMen +='  <tr>'
 cMen +='   <td colspan="2"><div align="center">Situa&ccedil;&atilde;o Atual:<b>Ve&iacute;culo Dispon&iacute;vel Nesse Período</b></div></td>'
 cMen +=' </tr>'
 cMen +='</table>'
      
  cMen +='  </td>'
 cMen +='  </tr>'
 cMen +='  <tr>'
 cMen +='   <td>'
 
 
 cMen +='<table width="587" border="1">'
 cMen +=' <tr>'
 cMen +=   '<td colspan="6"><div align="center">Dados da vist&oacute;ria </div></td>'
 cMen +=' </tr>'
 cMen +=' <tr>'
 cMen +='   <td width="91"><div align="center">Externo</div></td>'
 cMen +='   <td width="91"><div align="center">Pneus</div></td>'
 cMen +='   <td width="91"><div align="center">Rodas</div></td>'
 cMen +='   <td width="92"><div align="center">Lanterna</div></td>'
 cMen +='	<td width="91"><div align="center">Foral</div></td>'
 cMen +='   <td width="91"><div align="center">Interno</div></td>'
 cMen +=' </tr>'
 cMen +=' <tr>'       
 cMen +='   <td width="91">'+nBoxExte+'</td>'
 cMen +='   <td width="91">'+nBoxPneus+'</td>'
 cMen +='   <td width="92">'+nBoxRodas+'</td>'
 cMen +='	<td width="91">'+nBoxLanter+'</td>'
 cMen +='   <td width="91">'+nBoxFarol+'</td>'
 cMen +='   <td width="91">'+nBoxInt+'</td>'
 cMen +=' </tr>'
 cMen +=' <tr>'
 cMen +='   <td colspan="6"><div align="center">Observa&ccedil;&otilde;es</div></td>'
 cMen +=' </tr>'
 cMen +=' <tr>'
 cMen +='   <td colspan="6"><div align="left">'+cObsVeic+'</div></td>'
 cMen +=' </tr>'
 cMen +='</table>'
 cMen +='  </td>'
 cMen +='  </tr>'
 cMen +='</table>' 
 cMen +='<p>&nbsp;</p>'
 cMen +='</body>'
 cMen +='</html>'
            
            _cTo :=""
     	    
    //Email para o Solicitante
    _cTo +=alltrim(UsrRetMail(ZZJ->ZZJ_IDUSER))+";"

    cQuery := "SELECT * FROM ZZJ010 WHERE D_E_L_E_T_=''  AND ZZJ_DTREG = "+Dtos(date())+" AND ZZJ_PLACA = '"+AllTrim(cPlaca)+"' AND ZZJ_STATUS = '1'"
    Query := ChangeQuery(cQuery)
    TCQUERY cQuery Alias TRA New 
    dbSelectArea("TRA")
    dbGoTop()
            While !EOF()
              
              _cTo +=alltrim(UsrRetMail(TRA->ZZJ_IDUSER))+";"
              
              dbSkip() // Avanca o ponteiro do registro no arquivo
            EndDo 
                   

//    _cTo +="rh@nippon-seikibr.com.br"
	If Right(_cTo,1)==";"
		_cTo:=Substring(_cTo,1,len(_cTo)-1)
	EndIf  

    
    dbCloseArea("TRA")  
    oHtml:ValByName("MENS", cMen)
    oProcess:cTo  := _cTo   
    cMailId := oProcess:Start()
    
return  