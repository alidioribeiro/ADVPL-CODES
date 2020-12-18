#include "protheus.ch"
#INCLUDE "rwmake.ch" 
#Include "TOPCONN.CH"
#include "ap5mail.ch" 
#include 'fivewin.ch'
#include 'tbiconn.ch' 
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH' 

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

User Function ES_VITAS()
                         

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lRet   := .T. 
Private cCadastro := "Cadastro de Entrada e saída de Visitantes"

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","U_visualizarVT",0,2} ,;
             {"Incluir","U_IncluirVS",0,3} ,;
             {"Alterar","U_AlterarVT",0,4} ,;
             {"Excluir","U_ExcluirVTAG",0,5},;
             {"Finalizar","U_EncerrarVT",0,6},;
             {"Entrada/Saída","U_Gesf_nsb",0,7},;
             {"Agendamentos","U_portAgenda",0,8},;  
             {"Relatório","U_RelPortaria",0,9},;  
             {"Legenda"   ,"U_CHAMLeng"    ,0,10}}   
Private aCores 	  := {{ "ZZH->ZZH_STATUS==' '", 'BR_AZUL' },;     // Aberto AxInclui
		              { "ZZH->ZZH_STATUS=='1'", 'ENABLE'  },;     // Aprovado
		              { "ZZH->ZZH_STATUS=='2'", 'DISABLE' },;     // Realizado
				      { "ZZH->ZZH_STATUS=='3'", 'BR_PRETO'},;     // Nao Realizado 
				      { "ZZH->ZZH_STATUS=='4'", 'BR_AMARELO'}}    // Nao houve aprovac

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private	_bFiltraBrw	:= ''
Private _aIndexZZH 	:= {} 
Private	_cFiltro   	:= ''
Private cMarca      := GetMark()
Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString := "ZZH"
Private cEmail := "portaria@nippon-seikibr.com.br"

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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Amostrando somente os agendamento do solicitante                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                    

_cFiltro := "ZZH->ZZH_STATUS =='4'" // Filtra, mostrando somente em amdamento.		                        

If cNivel >= 5 
      _cFiltro:=""
EndIF
		
If	! Empty(_cFiltro) 
			_bFiltraBrw := {|| FilBrowse("ZZH",@_aIndexZZH,@_cFiltro) }
			Eval(_bFiltraBrw)
EndIf

dbSetOrder(1) 
dbSelectArea(cString)
mBrowse(6,1,22,75,cString,,,,,,aCores)
      EndFilBrw("ZZH",_aIndexZZH)
Return      



User Function IncluirVS() 
Local IRel := .T.   

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
  
dbSelectArea("ZZH")                 
dbSetOrder(1)
Private cDoc       := GetSXENum("ZZH")                                                                                                      
Private cAg        := Space(6)  
private cChracha   := Space(6)  
private cContato   := Space(60)
Private cAprovador := Space(60)
Private cRG        := Space(8) 
Private cEmpre     := Space(60)
Private cMatricula := Space(6)
Private cMotivo    := Space(60)
Private cObs      
Private cSeg       := cUserName
Private cVisitante := Space(60)
Private dDtEnt     := Date()
Private nHrEnt     := 0
Private nHrSai     := 0
Private cHrTotal   := 0
Private cImg       := "ns.jpg" 
Private cCcusto    := Space(50)
Private cCcustoDig := Space(3)
Private cCcustoDec := Space(50)     
    

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Comparação de quem poderar cadastrar                                    ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
If	cNivel < 4
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oLeg","input","oDlg1","oFoto","oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oSay7","oSay8")
SetPrvt("oSay10","oSay11","oSay12","oSay13","oSay14","oSay15","oSay16","oSay17","oDoc","oAg","oVisitante")
SetPrvt("oEmpre","oMotivo","oDtEnt","oHrEnt","oHrSai","oMatricula","oAprovador","oSeg","oCancel","oOk")
SetPrvt("oObs","oGet2","oGet20","oGet22","oGet21","oGet23")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oLeg       := TFont():New( "Trebuchet MS",0,-16,,.T.,0,,700,.T.,.F.,,,,,, )
input      := TFont():New( "Palatino Linotype",0,-10,,.T.,0,,700,.F.,.F.,,,,,, )
oDlg1      := MSDialog():New( 095,232,670,927,"Cadastro de Visitantes",,,.F.,,,,,,.T.,,,.T. )
oFoto      := TBitmap():New( 008,008,068,088,,"ns.jpg",.F.,oDlg1,,,.F.,.T.,,"",.T.,,.T.,,.F. )
oSay1      := TSay():New( 008,080,{||"Dados do Visitante"},oDlg1,,oLeg,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,076,012)
oSay2      := TSay():New( 024,084,{||"Documento"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oSay4      := TSay():New( 072,084,{||"Nome do Visitante (*)"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,076,008)
oSay5      := TSay():New( 048,084,{||"RG (*)"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay20     := TSay():New( 048,150,{||"Chrachá (*)"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oSay21     := TSay():New( 048,210,{||"Contato (*)"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,076,008)
oSay6      := TSay():New( 112,012,{||"Empresa (*)"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay7      := TSay():New( 133,013,{||"Motivo (*)"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,055,008)
oSay8      := TSay():New( 185,013,{||"Aprovador"},oDlg1,,oLeg,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,076,012)
oSay9      := TSay():New( 157,012,{||"Data entrada (*)"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
oSay10     := TSay():New( 157,065,{||"Hora entrada (*)"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,051,008)
oSay11     := TSay():New( 157,126,{||"Hora Saída"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,046,008)
oSay12     := TSay():New( 196,012,{||"Matricula (*)"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
oSay13     := TSay():New( 196,056,{||"Nome"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)    
oSay18     := TSay():New( 197,245,{||"C. custo/Descrição"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,091,008)
oSay14     := TSay():New( 222,014,{||"Dados da Portaria"},oDlg1,,oLeg,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,076,012)
oSay15     := TSay():New( 233,013,{||"Segurança"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,043,008)
oSay16     := TSay():New( 105,229,{||"Observação"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,055,008)
oSay17     := TSay():New( 157,175,{||"Hora Total"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,046,008)
oDoc       := TGet():New( 036,084,{|u| If(PCount()>0,cDoc:=u,cDoc)},oDlg1,040,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cDoc",,)
oDoc:Disable()
oRG        := TGet():New( 060,084,{|u| If(PCount()>0,cRG:=u,cRG)},oDlg1,060,008,'99999999',{||Val_RG()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cCpf",,)
oGet22     := TGet():New( 060,150,{|u| If(PCount()>0,cChracha:=u,cChracha)},oDlg1,040,008,'999999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cChracha",,) 
oGet23     := TGet():New( 060,210,{|u| If(PCount()>0,cContato:=u,cContato)},oDlg1,100,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cContato",,)
oVisitante := TGet():New( 084,084,{|u| If(PCount()>0,cVisitante:=u,cVisitante)},oDlg1,148,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cVisitante",,)
oEmpre     := TGet():New( 124,012,{|u| If(PCount()>0,cEmpre:=u,cEmpre)},oDlg1,196,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cEmpre",,)
oMotivo    := TGet():New( 145,013,{|u| If(PCount()>0,cMotivo:=u,cMotivo)},oDlg1,199,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cMotivo",,)
oDtEnt     := TGet():New( 169,016,{|u| If(PCount()>0,dDtEnt:=u,dDtEnt)},oDlg1,036,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDtEnt",,)
oHrEnt     := TGet():New( 169,072,{|u| If(PCount()>0,nHrEnt:=u,nHrEnt)},oDlg1,036,008,'99.99',{||calcTotal()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nHrEnt",,)

oHrSai     := TGet():New( 169,128,{|u| If(PCount()>0,nHrSai:=u,nHrSai)},oDlg1,036,008,'99.99',{||calcTotal()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nHrSai",,)
oHrSai:Disable()
oMatricula := TGet():New( 209,013,{|u| If(PCount()>0,cMatricula:=u,cMatricula)},oDlg1,036,008,'',{||PesqAproVT()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cMatricula",,)
oAprovador := TGet():New( 208,056,{|u| If(PCount()>0,cAprovador:=u,cAprovador)},oDlg1,184,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cAprovador",,)  
oCcusto    := TGet():New( 206,246,{|u| If(PCount()>0,cCcusto:=u,cCcusto)},oDlg1,094,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cCcusto",,)
oAprovador:Disable()
oSeg       := TGet():New( 245,013,{|u| If(PCount()>0,cSeg:=u,cSeg)},oDlg1,227,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cSeg",,)
oSeg:Disable()
oCancel    := TButton():New( 264,132,"Cancelar",oDlg1,{||oDlg1:End()},037,012,,,,.T.,,"",,,,.F. )
oOk        := TButton():New( 264,184,"OK",oDlg1,{||CadVisitas()},037,012,,,,.T.,,"",,,,.F. )
oImg       := TButton():New( 100,008,"Adicionar Imagem",oDlg1,,068,012,,,,.T.,,"",,,,.F. )
oObs       := TMultiGet():New( 120,228,{|u| If(PCount()>0,cObs:=u,cObs)},oDlg1,092,060,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
oHrTotal      := TGet():New( 169,177,{|u| If(PCount()>0,cHrTotal:=u,cHrTotal)},oDlg1,036,008,'99.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cHrTotal",,)
oDlg1:Activate(,,,.T.)   
RollBackSx8()         
Else
Alert("Você não tem permição")
EndIF

Return

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Pesquisa do Usuario no cadastro Visitas                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/ 


static function PesqAproVT()
Local lRet   := .T.
Local a_Area := GetArea() 
if len(Alltrim(cMatricula)) == 1
    cMatricula := "00000"+cMatricula
    ElseIF len(Alltrim(cMatricula)) == 2
    cMatricula := "0000"+cMatricula
    ElseIF len(Alltrim(cMatricula)) == 3
    cMatricula := "000"+cMatricula
    ElseIF len(Alltrim(cMatricula)) == 4
    cMatricula := "00"+cMatricula
    ElseIF len(Alltrim(cMatricula)) == 5
    cMatricula := "0"+cMatricula
EndIF

DbSelectArea("SRA")       
          DbSetOrder(1)     
          DbGotop()
          If DbSeek(xFilial("SRA") +cMatricula)
		      cAprovador := SRA->RA_NOME 
		      cMatricula := SRA->RA_MAT  
		      cCcustoDig := SRA->RA_CC
		      cCcustoDec := alltrim(Posicione("CTT",1,xFilial("CTT") + cCcustoDig,"CTT_DESC01"))            		      
		      cCcusto:= alltrim(cCcustoDig+"/"+cCcustoDec)
          Endif     
          
if empty(SRA->RA_MAT)
     
    cQuery := " SELECT RA_NOME,RA_CC,RA_DEMISSA,RA_MAT FROM SRA020 WHERE D_E_L_E_T_='' AND  RA_MAT = '" +cMatricula+ "'
    Query := ChangeQuery(cQuery)
    TCQUERY cQuery Alias TRA New 
    dbSelectArea("TRA")    
    
              cAprovador := RA_NOME 
		      cMatricula := RA_MAT  
		      cCcustoDig := RA_CC
		      cCcustoDec := alltrim(Posicione("CTT",1,xFilial("CTT") + cCcustoDig,"CTT_DESC01"))            		      
		      cCcusto:= alltrim(cCcustoDig+"/"+cCcustoDec)
       
EndIF
           
If empty(RA_NOME) .And. empty(SRA->RA_MAT)
   Alert("Atenção: Matricula Incorreta")
   lRel := .F.
EndIF                        
                
dbCloseArea("TRA")
dbCloseArea()

Return(lRet)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Incluir Agendamento cadastrado                                          ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/ 
               
static Function IncluirVTAG()
Close(oDlg)
  
dbSelectArea("ZZH")                 
dbSetOrder(1)
                                                                                                                       

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/    
op = 2
Private cDoc       := GetSXENum("ZZH")
Private cAg        := ZZG->ZZG_COD
Private cAprovador := ZZG->ZZG_NOME
Private cRG        := Space(8) 
Private cEmpre     := ZZG->ZZG_EMPRE
Private cMatricula := ZZG->ZZG_MAT 
Private cMotivo    := ZZG->ZZG_MOTIVO
Private cObs       := ZZG->ZZG_OBS        
Private cSeg       := cUserName
Private cVisitante := ZZG->ZZG_ACOM 
Private dDtEnt     := Date()
Private nHrEnt     := 0
Private nHrSai     := 0
Private cHrTotal   := 0
Private cImg       := "ns.jpg"        
Private cCcusto    := ZZG->ZZG_CCUSTO+"/"+ZZG->ZZG_CNOME
Private cCcustoDig := ZZG->ZZG_CCUSTO
Private cCcustoDec := ZZG->ZZG_CNOME     
   


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oLeg","input","oDlg1","oFoto","oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oSay7","oSay8")
SetPrvt("oSay10","oSay11","oSay12","oSay13","oSay14","oSay15","oSay16","oSay17","oDoc","oAg","oVisitante")
SetPrvt("oEmpre","oMotivo","oDtEnt","oHrEnt","oHrSai","oMatricula","oAprovador","oSeg","oCancel","oOk")
SetPrvt("oObs","oHrTotal")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oLeg       := TFont():New( "Trebuchet MS",0,-16,,.T.,0,,700,.T.,.F.,,,,,, )
input      := TFont():New( "Palatino Linotype",0,-10,,.T.,0,,700,.F.,.F.,,,,,, )
oDlg1      := MSDialog():New( 095,232,670,927,"Cadastro de Visitantes",,,.F.,,,,,,.T.,,,.T. )
oFoto      := TBitmap():New( 008,008,068,088,,"ns.jpg",.F.,oDlg1,,,.F.,.T.,,"",.T.,,.T.,,.F. )
oSay1      := TSay():New( 008,080,{||"Dados do Visitante"},oDlg1,,oLeg,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,076,012)
oSay2      := TSay():New( 024,084,{||"Documento"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oSay3      := TSay():New( 024,152,{||"Documento Agendamento"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)
oSay4      := TSay():New( 072,084,{||"Nome do Visitante(*)"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,076,008)
oSay5      := TSay():New( 048,084,{||"RG(*)"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)               
oSay20     := TSay():New( 048,150,{||"Chrachá (*)"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oSay21     := TSay():New( 048,210,{||"Contato (*)"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,076,008)
oSay6      := TSay():New( 112,012,{||"Empresa(*)"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay7      := TSay():New( 133,013,{||"Motivo(*)"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,055,008)
oSay8      := TSay():New( 185,013,{||"Aprovador"},oDlg1,,oLeg,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,076,012)
oSay9      := TSay():New( 157,012,{||"Data entrada(*)"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
oSay10     := TSay():New( 157,065,{||"Hora entrada(*)"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,051,008)
oSay11     := TSay():New( 157,126,{||"Hora Saída"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,046,008)
oSay12     := TSay():New( 196,012,{||"Matricula(*)"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
oSay13     := TSay():New( 196,056,{||"Nome"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)      
oSay18     := TSay():New( 197,245,{||"C. custo/Descrição"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,091,008)
oSay14     := TSay():New( 222,014,{||"Dados da Portaria"},oDlg1,,oLeg,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,076,012)
oSay15     := TSay():New( 233,013,{||"Segurança"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,043,008)
oSay16     := TSay():New( 105,229,{||"Observação"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,055,008)
oSay17     := TSay():New( 157,175,{||"Hora Total"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,046,008)

oDoc       := TGet():New( 036,084,{|u| If(PCount()>0,cDoc:=u,cDoc)},oDlg1,040,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cDoc",,)
oAg        := TGet():New( 036,180,{|u| If(PCount()>0,cAg:=u,cAg)},oDlg1,040,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ZZG","cAg",,)
oRG        := TGet():New( 060,084,{|u| If(PCount()>0,cRG:=u,cRG)},oDlg1,060,008,'99999999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cCpf",,)
oGet22     := TGet():New( 060,150,{|u| If(PCount()>0,cChracha:=u,cChracha)},oDlg1,040,008,'999999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cChracha",,) 
oGet23     := TGet():New( 060,210,{|u| If(PCount()>0,cContato:=u,cContato)},oDlg1,100,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cContato",,)
oVisitante := TGet():New( 084,084,{|u| If(PCount()>0,cVisitante:=u,cVisitante)},oDlg1,148,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cVisitante",,)
oEmpre     := TGet():New( 124,012,{|u| If(PCount()>0,cEmpre:=u,cEmpre)},oDlg1,196,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cEmpre",,)
oMotivo    := TGet():New( 145,013,{|u| If(PCount()>0,cMotivo:=u,cMotivo)},oDlg1,199,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cMotivo",,)
oDtEnt     := TGet():New( 169,016,{|u| If(PCount()>0,dDtEnt:=u,dDtEnt)},oDlg1,036,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDtEnt",,)
oHrEnt     := TGet():New( 169,072,{|u| If(PCount()>0,nHrEnt:=u,nHrEnt)},oDlg1,036,008,'99.99',{||calcTotal()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nHrEnt",,)
oHrSai     := TGet():New( 169,128,{|u| If(PCount()>0,nHrSai:=u,nHrSai)},oDlg1,036,008,'99.99',{||calcTotal()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nHrSai",,)
oMatricula := TGet():New( 209,013,{|u| If(PCount()>0,cMatricula:=u,cMatricula)},oDlg1,036,008,'',{||PesqAproVT()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cMatricula",,)
oAprovador := TGet():New( 208,056,{|u| If(PCount()>0,cAprovador:=u,cAprovador)},oDlg1,184,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cAprovador",,)
oCcusto    := TGet():New( 206,246,{|u| If(PCount()>0,cCcusto:=u,cCcusto)},oDlg1,094,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cCcusto",,)
oSeg       := TGet():New( 245,013,{|u| If(PCount()>0,cSeg:=u,cSeg)},oDlg1,227,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cSeg",,)
oCancel    := TButton():New( 264,132,"Cancelar",oDlg1,{||oDlg1:End()},037,012,,,,.T.,,"",,,,.F. ) 
oOk        := TButton():New( 264,184,"OK",oDlg1,{||CadVisitas()},037,012,,,,.T.,,"",,,,.F. )
oImg       := TButton():New( 100,008,"Adicionar Imagem",oDlg1,,068,012,,,,.T.,,"",,,,.F. )
oObs       := TMultiGet():New( 120,228,{|u| If(PCount()>0,cObs:=u,cObs)},oDlg1,092,060,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
oHrTotal      := TGet():New( 169,177,{|u| If(PCount()>0,cHrTotal:=u,cHrTotal)},oDlg1,036,008,'99.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cHrTotal",,)


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Desabilitando os campos                                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/ 

oDoc:Disable()      
oSeg:Disable()
oMatricula:Disable()
oAprovador:Disable()
oAg:Disable()  
oHrSai:Disable()       
oGet22:Disable()
oGet23:Disable()
oVisitante:Disable()
oEmpre:Disable()
oMotivo:Disable()
oDlg1:Activate(,,,.T.)
RollBackSx8()
Return

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± OP= valores:                                                            ±±
±± 1- Visualizar                                                           ±±
±± 2- Alterar                                                              ±±
±± 3- Encerar                                                              ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

   
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Visualizar Cadastros de visitas feito pela portaria                     ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
User function visualizarVT()
Local IRel := .T.
op=1
VisualizarVTAG(op)
return(IRel)
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Alterar Cadastros de visitas feito pela portaria                     ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

User function AlterarVT()
Local IRel := .T.      

if cNivel < 4 
op=2
VisualizarVTAG(op)
Else    
alert("você não tem premição para alterar")
IRel := .F.
EndIF
  
return(IRel)
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Encerrar Cadastros de visitas feito pela portaria                     ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

User function EncerrarVT()
Local IRel := .F.
op=3
VisualizarVTAG(op)

return(IRel)

 
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Pesquisa Visitas pelo RG                                                ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/ 


static function Val_RG()

Local IRel := .T. 
//CGC(cCpf)<- cpf validos          

   /*  
      If (IRel)    
        
          DbSelectArea("ZZH")       
          DbSetOrder(2)     
          DbGotop()
          If DbSeek(cRG)
		      cVisitante := ZZH->ZZH_NOME 
		      cEmpre     := ZZH->ZZH_EMPRE 
          Endif 
      EndIF
           */
cQuery := " SELECT ZZH_NOME,ZZH_EMPRE FROM ZZH010 WHERE D_E_L_E_T_='' AND  ZZH_RG = '" +cRG+ "'
Query := ChangeQuery(cQuery)
TCQUERY cQuery Alias TRA New 
    dbSelectArea("TRA")    
    
              cVisitante := TRA->ZZH_NOME 
		      cEmpre     := TRA->ZZH_EMPRE  
		      
    dbCloseArea("TRA")
           
return(IRel)



static Function VisualizarVTAG(op)
 
dbSelectArea("ZZH")                 
dbSetOrder(1)
                                                                                                                       

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private cDoc       := ZZH->ZZH_COD
Private cAg        := ZZH->ZZH_CODAGE
Private cAprovador := ZZH->ZZH_APROV
Private cRG        := ZZH->ZZH_RG      
private cChracha   := ZZH->ZZH_CRACHA 
private cContato   := ZZH->ZZH_CONTAT
Private cEmpre     := ZZH->ZZH_EMPRE
Private cMatricula := ZZH->ZZH_MATAP 
Private cMotivo    := ZZH->ZZH_MOTIVO 
Private cObs       := ZZH->ZZH_OBS
Private cSeg       := ZZH->ZZH_SEG
Private cVisitante := ZZH->ZZH_NOME
Private dDtEnt     := ZZH->ZZH_DTENT
Private nHrEnt     := ZZH->ZZH_HRENT
Private nHrSai     := ZZH->ZZH_HRSAI
Private cHrTotal   := ZZH->ZZH_HRTOTA  
Private cImg       := ZZH->ZZH_FOTO     
Private cCcusto    := ALLTRIM(ZZH->ZZH_CCUSTO+"/"+ZZH->ZZH_CDESC)   
Private cCcustoDig := ZZH->ZZH_CCUSTO
Private cCcustoDec := ZZH->ZZH_CDESC     
 
statu := ZZH->ZZH_STATUS      


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oLeg","input","oDlg1","oFoto","oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oSay7","oSay8")
SetPrvt("oSay10","oSay11","oSay12","oSay13","oSay14","oSay15","oSay16","oSay17","oDoc","oAg","oVisitante")
SetPrvt("oEmpre","oMotivo","oDtEnt","oHrEnt","oHrSai","oMatricula","oAprovador","oSeg","oCancel","oOk")
SetPrvt("oObs","oHrTotal","oCcusto")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oLeg       := TFont():New( "Trebuchet MS",0,-16,,.T.,0,,700,.T.,.F.,,,,,, )
input      := TFont():New( "Palatino Linotype",0,-10,,.T.,0,,700,.F.,.F.,,,,,, )
oDlg1      := MSDialog():New( 095,232,670,927,"Alteração de Cadastro de Visitantes",,,.F.,,,,,,.T.,,,.T. )
oFoto      := TBitmap():New( 008,008,068,088,,"ns.jpg",.F.,oDlg1,,,.F.,.T.,,"",.T.,,.T.,,.F. )
oSay1      := TSay():New( 008,080,{||"Dados do Visitante"},oDlg1,,oLeg,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,076,012)
oSay2      := TSay():New( 024,084,{||"Documento"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oSay3      := TSay():New( 024,152,{||"Documento Agendamento"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)
oSay4      := TSay():New( 072,084,{||"Nome do Visitante (*)"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,076,008)
oSay5      := TSay():New( 048,084,{||"RG (*)"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008) 
oSay20     := TSay():New( 048,150,{||"Chrachá (*)"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oSay21     := TSay():New( 048,210,{||"Contato (*)"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,076,008)
oSay6      := TSay():New( 112,012,{||"Empresa (*)"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay7      := TSay():New( 133,013,{||"Motivo (*)"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,055,008)
oSay8      := TSay():New( 185,013,{||"Aprovador"},oDlg1,,oLeg,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,076,012)
oSay9      := TSay():New( 157,012,{||"Data entrada (*)"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
oSay10     := TSay():New( 157,065,{||"Hora entrada (*)"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,051,008)
oSay11     := TSay():New( 157,126,{||"Hora Saída"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,046,008)
oSay12     := TSay():New( 196,012,{||"Matricula (*)"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
oSay13     := TSay():New( 196,056,{||"Nome"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)
oSay14     := TSay():New( 222,014,{||"Dados da Portaria"},oDlg1,,oLeg,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,076,012)
oSay15     := TSay():New( 233,013,{||"Segurança"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,043,008)
oSay16     := TSay():New( 105,229,{||"Observação"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,055,008)
oSay17     := TSay():New( 157,175,{||"Hora Total"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,046,008)
oSay18     := TSay():New( 197,245,{||"C. custo/Descrição"},oDlg1,,input,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,091,008)

oDoc       := TGet():New( 036,084,{|u| If(PCount()>0,cDoc:=u,cDoc)},oDlg1,040,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cDoc",,)
oAg        := TGet():New( 036,180,{|u| If(PCount()>0,cAg:=u,cAg)},oDlg1,040,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ZZG","cAg",,)
oRG        := TGet():New( 060,084,{|u| If(PCount()>0,cRG:=u,cRG)},oDlg1,060,008,'99999999',{||Val_RG()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cCpf",,)
oGet22     := TGet():New( 060,150,{|u| If(PCount()>0,cChracha:=u,cChracha)},oDlg1,040,008,'999999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cChracha",,) 
oGet23     := TGet():New( 060,210,{|u| If(PCount()>0,cContato:=u,cContato)},oDlg1,100,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cContato",,)
oVisitante := TGet():New( 084,084,{|u| If(PCount()>0,cVisitante:=u,cVisitante)},oDlg1,148,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cVisitante",,)
oEmpre     := TGet():New( 124,012,{|u| If(PCount()>0,cEmpre:=u,cEmpre)},oDlg1,196,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cEmpre",,)
oMotivo    := TGet():New( 145,013,{|u| If(PCount()>0,cMotivo:=u,cMotivo)},oDlg1,199,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cMotivo",,)
oDtEnt     := TGet():New( 169,016,{|u| If(PCount()>0,dDtEnt:=u,dDtEnt)},oDlg1,036,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDtEnt",,)
oHrEnt     := TGet():New( 169,072,{|u| If(PCount()>0,nHrEnt:=u,nHrEnt)},oDlg1,036,008,'99.99',{||calcTotal()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nHrEnt",,)
oHrSai     := TGet():New( 169,128,{|u| If(PCount()>0,nHrSai:=u,nHrSai)},oDlg1,036,008,'99.99',{||calcTotal()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nHrSai",,)
oMatricula := TGet():New( 209,013,{|u| If(PCount()>0,cMatricula:=u,cMatricula)},oDlg1,036,008,'',{||PesqAproVT()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SRAPOR","cMatricula",,)
oAprovador := TGet():New( 208,056,{|u| If(PCount()>0,cAprovador:=u,cAprovador)},oDlg1,184,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cAprovador",,)
oCcusto    := TGet():New( 206,246,{|u| If(PCount()>0,cCcusto:=u,cCcusto)},oDlg1,094,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cCcusto",,)
oSeg       := TGet():New( 245,013,{|u| If(PCount()>0,cSeg:=u,cSeg)},oDlg1,227,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cSeg",,)
oCancel    := TButton():New( 264,132,"Cancelar",oDlg1,{||oDlg1:End()},037,012,,,,.T.,,"",,,,.F. ) 
oOk        := TButton():New( 264,184,"OK",oDlg1,{||ValidtVisitas(op)},037,012,,,,.T.,,"",,,,.F. )
oImg       := TButton():New( 100,008,"Adicionar Imagem",oDlg1,,068,012,,,,.T.,,"",,,,.F. )
oObs       := TMultiGet():New( 120,228,{|u| If(PCount()>0,cObs:=u,cObs)},oDlg1,092,060,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
oHrTotal   := TGet():New( 169,177,{|u| If(PCount()>0,cHrTotal:=u,cHrTotal)},oDlg1,036,008,'99.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cHrTotal",,)

oDoc:Disable()      
oSeg:Disable()

oAg:Disable() 

If op == 1 
oHrSai:Disable() 
oRG:Disable()
oVisitante:Disable()
oEmpre:Disable()
oMotivo:Disable() 

oAprovador:Disable()
oDtEnt:Disable()
oHrEnt:Disable()
oOk:Disable()
EndIf
oGet22:Disable()
oGet23:Disable()

oDlg1:Activate(,,,.T.)

Return                         

static function calcTotal()
Local IRel := .F.

IF nHrSai > 23.59 .Or. nHrEnt > 23.59 
  alert("A Hora é Superior a 24H ou  Incorreta... ")  
Else 
   cHrTotal:= SubHoras(nHrSai,nHrEnt)  
   IRel := .T.
EndIF

return(IRel)

static function ValidtVisitas(op)
 Local IRel := .F.
    
   

    If op = 2 .And. cNivel < 4 .And. ZZH->ZZH_STATUS <> '2'
    IRel := .T.          
     
     AlterarVT()
    ElseIf op = 3 .And. cNivel < 4 
    IRel := .T.
     EncerrarVST()
    Else   
     alert("Atenção:Você não pode fazer essa operação")
    EndIF

 
return(IRel)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Cadastro de Visitantes com ou sem Agendamnetos marcados                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/ 


static function CadVisitas()

Local lRel := .T.

If empty(cAprovador) .Or. empty(cEmpre) .Or. empty(cMatricula) .Or. empty(cMotivo) .Or. empty(nHrEnt) .Or.empty(dDtEnt) .Or. empty(cRG) .Or. empty(cVisitante)   
lRel :=.F.

alert("Preencha os compos com '(*)' corretamente...,Existem campos Vazios  ") 

Elseif cNivel > 4                                     

alert("Atenção: Você não tem permição para incluir visitantes") 

ELSE  



dbSelectArea("ZZH") 
ConfirmSX8()
RecLock("ZZH",.T.) 
ZZH_FILIAL      := xFilial()
ZZH_STATUS      := "4"
ZZH_COD         :=cDoc                                                                                                                    
ZZH_CODAGE      :=cAg        
ZZH_APROV       :=cAprovador 
ZZH_RG          :=cRG        
ZZH_EMPRE       :=cEmpre     
ZZH_MATAP       :=cMatricula 
ZZH_MOTIVO      :=cMotivo    
ZZH_OBS         :=cObs       
ZZH_SEG         :=cSeg       
ZZH_NOME        :=cVisitante 
ZZH_DTENT       :=dDtEnt     
ZZH_HRENT       :=nHrEnt     
ZZH_HRSAI       :=nHrSai     
ZZH_HRTOTA      :=cHrTotal
ZZH_CCUSTO      :=cCcustoDig
ZZH_CDESC       :=cCcustoDec     
ZZH_EMAIL       :=cEmail             
ZZH->ZZH_CRACHA :=cChracha
ZZH->ZZH_CONTATO:=cContato

if empty(cAg) 
ZZH_TIPOAG      :="NAO"
Else
ZZH_TIPOAG      :="SIM"
EndIF
ZZH_FOTO        :=oImg      
MsUnlock()      

if !empty(cAg) //compara se existe o agendamento
DbSelectArea("ZZG")
	RecLock("ZZG",.F.)                                      		
  	ZZG_DTEVIS      := dDtEnt
	ZZG_HRENVS      := nHrEnt 
	ZZG_HRSVS       := nHrSai
	ZZG_STATUS      := '4'
	MsUnlock()
EndIF          
 RollBackSx8()
alert("Cadastro realizado com sucesso!") 
Close(oDlg1)
EndIF//comparação de campos vazio
return(lRel)

static function AlterarVT()    
dbSelectArea("ZZH") 
DbSetOrder(1)     
DbGotop()
If DbSeek(cDoc)

RecLock("ZZH",.F.)
ZZH_APROV       :=cAprovador 
ZZH_RG          :=cRG        
ZZH_EMPRE       :=cEmpre     
ZZH_MATAP       :=cMatricula 
ZZH_MOTIVO      :=cMotivo    
ZZH_OBS         :=cObs       
ZZH_SEG         :=cSeg       
ZZH_NOME        :=cVisitante 
ZZH_DTENT       :=dDtEnt     
ZZH_HRENT       :=nHrEnt     
ZZH_HRSAI       :=nHrSai     
ZZH_HRTOTA      :=cHrTotal
ZZH_CCUSTO      :=cCcustoDig
ZZH_CDESC       :=cCcustoDec     
ZZH_EMAIL       :=cEmail
MsUnlock() 
alert("Alteração realizado com sucesso o processo ira ficar em amdamento... ") 
Close(oDlg1)    
EndIF

return 

static function EncerrarVST() 
Local lRel :=.T.
If nHrSai <= 0 .Or. nHrSai < nHrEnt 
lRel :=.F.

alert("Preencha os compos, Existe compos vazios... ") 

Else
dbSelectArea("ZZH") 
DbSetOrder(1)     
DbGotop()

If DbSeek(cDoc)
RecLock("ZZH",.F.)
ZZH_STATUS      := "2"
ZZH_HRSAI       :=nHrSai     
ZZH_HRTOTA      :=cHrTotal
MsUnlock() 
EndIF
 
DbSelectArea("ZZG")       
DbSetOrder(4)     
DbGotop()

If DbSeek(cAg+cVisitante)
		RecLock("ZZG",.F.) 
		ZZG_STATUS := '2'
		MsunLock() 
Endif

alert("A solicitação foi encerrada... ") 

Close(oDlg1)
EndIF
return(lRel)

User Function portAgenda()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private	_bFiltraBrw	:= ''
Private _aIndexZZG 	:= {} 
Private	_cFiltro   	:= ''
Private cMarca      := GetMark()
Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString := "ZZG"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta um aRotina proprio                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
                     {"Visualizar","U_VisuaAG",0,2} ,;
                     {"Incluir","U_AGIncl",0,3} ,;  
                     {"Alterar","U_AGAltera",0,4} ,; 
                     {"Cancelar","U_CanlelarAGVT",0,5} ,;
                     {"Excluir","U_ExcluirVTAG",0,6},;
                     {"Relatório","U_RelAge",0,7},;
                     {"Legenda"   ,"U_CHAMLeng"    ,0,8}}          
                     
Private cCadastro   := OemToAnsi("Agendamento de Visitas")      
            
Private aCores 	  := {{ "ZZG->ZZG_STATUS==' '", 'BR_AZUL' },;     // Aberto AxInclui
		              { "ZZG->ZZG_STATUS=='1'", 'ENABLE'  },;     // Aprovado
		              { "ZZG->ZZG_STATUS=='2'", 'DISABLE' },;     // Realizado
				      { "ZZG->ZZG_STATUS=='3'", 'BR_PRETO'},;     // Nao Realizado 
				      { "ZZG->ZZG_STATUS=='4'", 'BR_AMARELO'}}    // Nao houve aprovacao 


		      
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Amostrando somente os agendamento do solicitante                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("ZZG") 

If	( cNivel > 4 .And. cNivel < 6 ) // Caso nao seja Usuario Superior		
	_cFiltro := "ZZG->ZZG_CCUSTO =='"+cCCSoli+"'" // Filtra, mostrando somente os chamados do usuario.		                        
EndIf 

dbSetOrder(1) 
dbSelectArea(cString)
mBrowse(6,1,22,75,cString,,,,,,aCores)
      EndFilBrw("ZZG",_aIndexZZG)
Return
  
User function ExcluirVTAG()
          DbGotop() 
          alert("Entre em contato com a T.I- 8913/8914")
return

User Function ZZGNomeE() 
Local lRet   := .T.
Local a_Area := GetArea()
aCols[N][2]:=cRepre 
Return(lRet)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Incluir Agendamento                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function AGIncl() 
 BrowIncAG()   
Return 
Static Function BrowIncAG()
Local Usuario:=__cUserId
Private lPadrao:=.F.
SetPrvt("NOPCX,NUSADO,AHEADER,ACOLS,CCLIENTE,CLOJA")
SetPrvt("DDATA,CTITULO,AC,AR,ACGD") 
SetPrvt("CLINHAOK,CTUDOOK,LRETMOD2,N_Saldo,N_Horas")
//+--------------------------------------------------------------+
//¦ Opcao de acesso para o Modelo 2                              ¦
//+--------------------------------------------------------------+
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza 
nOpcao  := 0
nOpcx   := 3
cAlias  := Alias()
cRecno  := Recno()
aAgem   := {}   
aCadAg  :={}
cCC     := Alltrim(cCCSoli)    
//+--------------------------------------------------------------+
//¦ Declaração das variaveis                                     ¦
//+--------------------------------------------------------------+
dbSelectArea("ZZG")                 
dbSetOrder(1)
cNum     := GetSXENum("ZZG")                                                                                                       
cSolici  := cUserName                                                                                                                       
cEmissao := date()  
cRepre   := Space(60)
cEmpre   := Space(60)  
cDataVis := Date()
cHoraVis := Time()   
cMotivo  := Space(60)
cSolemail:= alltrim(UsrRetMail(__cUserId))
cEmail := "portaria@nippon-seikibr.com.br"

//¦ Montando aHeader                                             ¦
//+--------------------------------------------------------------+
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("ZZG")
nUsado  := 0
aHeader := {}   
//+--------------------------------------------------------------+
//¦ Montando aCols                                               ¦
//+--------------------------------------------------------------+
aCols := Array(1,nUsado+1)    // campos
dbSelectArea("SX3")
dbSeek("ZZG")
nUsado := 0     
While !Eof() .and. (x3_arquivo == "ZZG")
	IF X3USO(X3_USADO) .and. cNivel >= X3_NIVEL .and. Val(X3_ORDEM)>2  .and. Val(X3_ORDEM)<20 .and.  Val(X3_ORDEM)#11   
		nUsado++
		AADD(aHeader,{TRIM(X3_TITULO),;
		X3_CAMPO,;
		X3_PICTURE,;
		X3_TAMANHO,;
		X3_DECIMAL,;
		.F.,;
		X3_USADO,;
		X3_TIPO,;
		X3_ARQUIVO,;
		X3_CONTEXT})
	Endif
	dbSkip()
End
//+--------------------------------------------------------------+
//¦ Montando aCols                                               ¦
//+--------------------------------------------------------------+
aCols := Array(1,nUsado+1)    // campos
dbSelectArea("SX3")
dbSeek("ZZG")
nUsado := 0
While !Eof() .and. (X3_ARQUIVO == "ZZG")
	IF X3USO(X3_USADO) .and. cNivel >= X3_NIVEL .and. Val(X3_ORDEM)>2 .and. Val(X3_ORDEM)<20 .and.  Val(X3_ORDEM)#11   
		nUsado++ 
			IF X3_TIPO == "C"
				aCols[1][nUsado] := Space(X3_TAMANHO)
			Elseif X3_TIPO == "N"
				aCols[1][nUsado] := 0
			Elseif X3_TIPO == "D"
				aCols[1][nUsado] := dDataBase
			Elseif X3_TIPO == "M"
				aCols[1][nUsado] := ""
			Else
				aCols[1][nUsado] := .F.
			Endif
	Endif
	dbSkip()
End
aCols[1][nUsado+1] := .F.  


//+--------------------------------------------------------------+
//¦ Variaveis do Rodape do Modelo 2                              ¦
//+--------------------------------------------------------------+
nLinGetD := 0
//+--------------------------------------------------------------+
//¦ Titulo da Janela                                             ¦
//+--------------------------------------------------------------+
cTitulo  := "Agendamento de Visitas - NSB"
//+--------------------------------------------------------------+
//¦ Array com descricao dos campos do Cabecalho do Modelo 2      ¦
//+--------------------------------------------------------------+
aC:={}
// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.

AADD(aC,{"cNum"     , {15,010} ,"Documento"    ,"@e " ,,,.f.})
AADD(aC,{"cSolici"  , {15,100} ,"Solicitante"  ,"@e " ,,,.f.}) 
AADD(aC,{"cEmissao" , {15,250} ,"Data do Agendamento"      ,"@e " ,,,.f.})  
AADD(aC,{"cCC" , {30,18} ,"C. Custo"      ,"@e " ,,,.f.})  
AADD(aC,{"cDescSol" , {30,100} ,"Descrição"      ,"@e " ,,,.f.})  

AADD(aC,{"cEmpre", {45,018},"Empresa"      ,"@!",,,.T.})    
AADD(aC,{"cRepre" , {60,023} ,"Repre."      ,"@!","U_ZZGNomeE()",,.T.}) 
AADD(aC,{"cMotivo" , {75,022} ,"Motivo."      ,"@!",,,.T.})

AADD(aC,{"cDataVis" , {90,010} ,"Dt da Visita."      ,"@D" ,,,.T.})
AADD(aC,{"cHoraVis" , {90,100} ,"Hr da Visita."      ,"@!" ,,,.T.})

//+--------------------------------------------------------------+
//¦ Array com descricao dos campos do Rodape do Modelo 2         ¦
//+--------------------------------------------------------------+

aR:={}
// aR[n,1] = Nome da Variavel Ex.:"cCliente"
// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aR[n,3] = Titulo do Campo
// aR[n,4] = Picture
// aR[n,5] = Validacao
// aR[n,6] = F3
// aR[n,7] = Se campo e' editavel .t. se nao .f.

aCGD := {170,5,100,315}   

//+--------------------------------------------------------------+
//¦ Validacoes na GetDados da Modelo 2                           ¦
//+--------------------------------------------------------------+
//cLinhaOk := "ExecBlock('SZPLinOK',.f.,.f.)"
cLinhaOk := "U_ZZGLinOK()"
cTudoOk  := "ExecBlock('ZZGTudOk',.f.,.f.)"

//+--------------------------------------------------------------+
//¦ Validacoes na GetDados da Modelo 2                           ¦
//+--------------------------------------------------------------+

If Len(aCols)<>0
	//aCols := a_Perd
//	For _i:=1 to len(a_Perd)
//		aAdd(aCols,a_Perd[_i])
//	Next
EndIf

//lRetMod2 := Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,)
lRetMod2 := Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,,,,,{40,10,500,800})
If lRetMod2
	ConfirmSX8()
	For X:=1 to len(aCols)
		if !(aCols[x][len(aHeader)+1])

			dbSelectArea("ZZG") 
			RecLock("ZZG",.T.)
		    ZZG_FILIAL      := xFilial()
		    ZZG_STATUS      := "1"
		    ZZG_COD         := cNum        
	  	    ZZG_CCUSTO      := cCC 
	  	    ZZG_CNOME       := cDescSol    	  	     
		    ZZG_MAT         := cMatSol 
		    ZZG_NOME        := cSolici		    
		    ZZG_DTSOL       := cEmissao   
		    ZZG_HORA        := Time()
		    ZZG_EMPRE       := cEmpre
		    ZZG_REPRE       := cRepre
		    ZZG_HVIS        := cHoraVis
		    ZZG_DTVIS       := cDataVis
		    ZZG_MOTIVO      := cMotivo
		    ZZG_EMAIL       := cSolemail
		    ZZG_ITEM        := aCols[X][1] 
		    ZZG_ACOM        := aCols[X][2]
		   	ZZG_OBS         := aCols[X][3]		   	 
		   	MsUnlock()
		     DbSelectArea("ZZG")
		     AAdd(aAgem,{ZZG_ITEM,ZZG_ACOM,ZZG_OBS}) 
		    
	    EndIf
	     
    Next     
    xDataAG := Subs(Dtos(cDataVis),7,2) + "/" + Subs(Dtos(cDataVis),5,2)+ "/" + Subs(Dtos(cDataVis),3,2) 
   AAdd(aCadAg,{cNum,cDescSol,cSolici,cEmpre,cRepre,xDataAG,cHoraVis}) 
     /*****************************/
     // Obtendo Dados do usuário 
	   cTo := cEmail+";"+cSolemail
	   
	   nOpcao := 1  // inclusao
	   EnviaEmailAG(nOpcao,cTo)	
Else
    RollBackSx8()
//	Close(oDlg5)
	Sai := .f.
Endif

dbSelectArea(cAlias)
dbGoto(cRecno)
DbSelectArea("ZZG")
DbCloseArea()
Return    
         

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ<¿
//³Validação de Confirmação no Cadastro de agendamento ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ<Ù

User Function ZZGLinOK 
Local lRet   := .T.
Local a_Area := GetArea()  

IF Empty(aCols[N][2])
   Alert("Falta informar o nome do visitante...")
   lRet   := .f.     
EndIf

Return(lRet)

User Function ZZGTudOk()

Local Ret   := .T.
Local a_Area := GetArea()

if Empty(cEmpre)    
   Alert('Campo Empresa está vazio!')
   Ret   := .f.   
   Elseif Empty(cRepre)            
          Alert('Campo Representante está vazio!')
          Ret   := .f.          
          Elseif Empty(cDataVis)            
                 Alert('Campo Data está vazio!')
                 Ret   := .f.                      
                 Elseif Empty(cHoraVis)            
                       Alert('Campo Empresa está vazio!')          
                       Ret   := .f.
Endif

RestArea(a_Area)
Return(Ret) 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Visualisar Agendamento                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

User Function VisuaAG ()
	aSHE := {}                
	aCols:={}
	aHeader:={}                   
	Msg:="Visualiza Agendamento"
	MontaTelaAG(Msg,1)
Return
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TELA DO PROGRAMA AGENDAMENTO                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function MontaTelaAG(Msg,Tipo)
Opc:=.F.
If Tipo=2
	Opc:=.T.
EndIF    

If Tipo=4
	Opc:=.T.
EndIF 
nUsado  := 0
aHeader := {}
//+--------------------------------------------------------------+
//¦ Montando aCols                                               ¦
//+--------------------------------------------------------------+
aCols := Array(1,nUsado+1)    // campos
dbSelectArea("SX3")
dbSeek("ZZG")
nUsado := 0

aCols[1][nUsado+1] := .F.

dbSelectArea("ZZG")
//**Monta Cabeçalho****/
cDoc:=ZZG_COD
cItem:=ZZG_ITEM
cStat:=ZZG_STATUS
cNome:=ZZG_NOME
cMat :=ZZG_MAT 
cDataVis:= ZZG_DTVIS
cHoraVis:= ZZG_HVIS
//cData:=ZZG_DTVIS //Dtoc(ZP_DATA)
cCusto :=ZZG_CCUSTO
cCnome :=ZZG_CNOME
cEmpre :=ZZG_EMPRE
cRepre :=ZZG_REPRE
cAcomp :=ZZG_ACOM
cMotivoVis:=ZZG_MOTIVO
cObs   :=ZZG_OBS
cMemo  :=cObs  
cDataSol := ZZG_DTSOL
cHoraSol := ZZG_HORA   
cDataEncerra:= ZZG_DTEVIS  
cHrEntrada := ZZG_HRENVS
cHrSaida := ZZG_HRSVS

IF empty(cCusto)
 alert("")
 
EndIF

@ 010,010 TO 500,620 DIALOG oDlg TITLE MSG
@ 010,014 Say "Documento: " 
@ 010,045 Get cDoc Size 022, 010 When .F.
@ 025,014 Say "Solicitante: " 
@ 025,045 Get cNome Size 200, 010 When .F.
@ 040,014 Say "C. Custo: "
@ 040,045 GET cCusto  Size 18, 010 When .F.
@ 040,071 Say "Descrição: "
@ 040,0100 GET cCnome  Size 145, 010 When .F.
@ 055,014 Say "Empresa: "
@ 055,045 GET cEmpre  Size 145, 010 When Opc PICTURE "@!"
@ 070,014 Say "Repre.: "
@ 070,045 GET cRepre  Size 145, 010 When Opc PICTURE "@!" 
@ 085,014 Say "Visitante: "
@ 085,045 GET cAcomp  Size 145, 010 When Opc PICTURE "@!" 
@ 0100,014 Say "DT. Visita: "
@ 0100,045 GET cDataVis  Size 18, 010 When Opc PICTURE "@D"
@ 0100,090 Say "HR. Visita: "
@ 0100,0120 GET cHoraVis  Size 18, 010 When Opc PICTURE "@99:99"
@ 0115,014 Say "Motivo: "
@ 0115,045 GET cMotivoVis  Size 145, 010 When Opc PICTURE "@!" 
if Tipo=2
    @ 0130,014 Say "Observações:" 
	oMemo:= tMultiget():New(11,03,{|u|if(Pcount()>0,cMemo:=u,cObs)};
	,oDlg,220,50,,,,,,.F.,,,,,,.F.)
	Else
	@ 0130,014 Say "Observações:" 
	oMemo:= tMultiget():New(11,03,{|u|if(Pcount()>0,cMemo:=u,cObs)};
	,oDlg,220,50,,,,,,.F.,,,,,,.T.)
EndIF
	        



if Tipo=4 
	@ 230,150 BMPBUTTON TYPE 1 ACTION EncerraAG() 
ElseIf Tipo=2
	@ 230,150 BMPBUTTON TYPE 1 ACTION AltAG() 
ElseIf (Tipo=1 .And. ZZG_STATUS == '1' .And. cNivel < 4 )
	@ 230,150 BUTTON "Avançar" SIZE 40,10 ACTION IncluirVTAG() 
EndIf              
	@ 230,100 BMPBUTTON TYPE 2 ACTION Close(oDlg) 
	
ACTIVATE DIALOG oDlg CENTERED                    
Return 

/***************************************************************/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Encerrar Agendamento                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
Static Function EncerraAG ()    
Local lRet    := .T.    	
aCadAg  :={}
			
 
		    If	( ZZG->ZZG_STATUS == '1' .And. ZZG->ZZG_MAT == cMatSol )
		        If	MsgYesNo(OemToAnsi('Deseja Cancelar realmente este Agendamento ?'))
		                    If	RecLock('ZZG',.F.)
		                                Replace ZZG->ZZG_STATUS	With '3'
		                                Replace ZZG->ZZG_DTENCE	With dDataBase
		                                Replace ZZG->ZZG_HRENCE	With Time() 
		                                	                                
				                        MsUnLock() 	 
				                         cTo    := "aishii@nippon-seikibr.com.br"
	                                     nOpcao := 2  // problema	
	                                      xDataVIS := Subs(Dtos(ZZG->ZZG_DTVIS),7,2) + "/" + Subs(Dtos(ZZG->ZZG_DTVIS),5,2)+ "/" + Subs(Dtos(ZZG->ZZG_DTVIS),3,2)
	                                      xDataEMC := Subs(Dtos(ZZG->ZZG_DTENCE),7,2) + "/" + Subs(Dtos(ZZG->ZZG_DTENCE),5,2)+ "/" + Subs(Dtos(ZZG->ZZG_DTENCE),3,2)
	                                     AAdd(aCadAg,{ZZG->ZZG_COD,ZZG->ZZG_CNOME,ZZG->ZZG_NOME,ZZG->ZZG_EMPRE,ZZG->ZZG_ACOM,xDataVIS,ZZG->ZZG_HVIS,xDataEMC,ZZG->ZZG_HRENCE})
	                                     EnviaEmailAG(nOpcao,cTo)	                      
				            EndIf
		        EndIf
	        Else                                               
	        
		        Alert('Este Agendamento não pode ser Encerrado por outro solicitante.')    
		       
	        EndIf  
	        		                    
  
_bFiltraBrw := {|| FilBrowse("ZZG",@_aIndexZZG,@_cFiltro) }
Eval(_bFiltraBrw)       
  EndFilBrw("ZZG",_aIndexZZG) 
  
Close(oDlg)
Return 

User Function CanlelarAGVT()   


Local lRet    := .T.  
    
	aSHE := {}                
	aCols:={}
	aHeader:={}                   
	Msg:="Cancelar o Agendamento"
	MontaTelaAG(Msg,4)    
Return(lRet)        

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alterar Agendamento                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Static Function AltAG() 
Local lRet:=.F.
lRet:= U_ZZGTudOk()
if lRet 
	
	DbSelectArea("ZZG")
	RecLock("ZZG",.F.)                                      		
  	ZZG_HVIS        := cHoraVis
	ZZG_DTVIS       := cDataVis
	ZZG_EMPRE       := cEmpre
	ZZG_REPRE       := cRepre
	ZZG_MOTIVO      := cMotivoVis
	ZZG_ACOM        := cAcomp
	ZZG_OBS         := cMemo
	MsUnlock()
    Close(oDlg)
    	
Endif               
   
Return(lRet)  

User Function AGAltera ()   
Local lRet   := .T.
    aSHE   := {}                
	aCols  :={}
	aHeader:={}     
	cAlias  := Alias()
    cRecno  := Recno()              	               
	Msg:="Altera Agendamento" 
	
	If Alltrim(ZZG->ZZG_STATUS)='4'.or. Alltrim(ZZG->ZZG_STATUS)='1'
		MontaTelaAG(Msg,2)
	Else
		Alert("Só é possivel alterar agendamento em aberto")
	EndIf     
Return(lRet)  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alterar Agendamento                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ     



User Function Alterar ()
Local lRet   := .T. 

     If(ZZG->ZZG_STATUS == '2')     
            Help('',1,'AGENDA PORTARIA',,OemToAnsi('Este Agendamento não pode ser Alterado.'),1)          
         ELSE         
            AxAltera()            
     EndIF     
Return(lRet)
                       

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Excluir Agendamento                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ


User Function Excluir ()
Local lRet   := .T.          
            Help('',1,'AGENDA PORTARIA',,OemToAnsi('Este Agendamento não pode ser Excluido.'),1)          
         
     
Return(lRet)      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Enviar Email                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 

Static Function  EnviaEmailAG(_nOpcao,_cTo)
//    _cTo:="aishii@nippon-seikibr.com.br"
    oProcess := TWFProcess():New( "000001", "Envia Email" )
    oProcess :NewTask( "100001", "\WORKFLOW\SSI.HTM" )
    Do Case
    Case _nOpcao == 1
         oProcess :cSubject := "SOLICITAÇÃO DE AGENDAMENTO"
    Case _nOpcao == 2
         oProcess :cSubject := "CANCELAMENTO DE AGENDAMENTO"
    Case _nOpcao == 3
         oProcess :cSubject := "ENTRADA DE VISITANTES" 
    Case _nOpcao == 4
         oProcess :cSubject := "FINALIZAÇÃO DA ENTRADA DO VISITANTE"    
    EndCase
    oHTML    := oProcess:oHTML 
         
    cMen := " <html>"
    cMen += " <head>"
    cMen += " <title>Nippon Seiki do Brasil Ltda.</title>"  
    cMen += " </head>"    
    cMen += " <body>"   
IF _nOpcao= 2   

    cMen += ' <table cellpadding="1" cellspacing="1" width="800" style="border-style: dotted;border-color: black;border: 1px;">'
    cMen += ' <tr>'
    cMen += ' <td align="center" width="3%"   bgcolor="#228B22"><font size="2" face="Times">Documento</font></td>'  //[2] 
    cMen += ' <td align="center" width="10%"  bgcolor="#228B22"><font size="2" face="Times">Setor</font></td>'
    cMen += ' <td align="center" width="10%"  bgcolor="#228B22"><font size="2" face="Times">Solicitante</font></td>'  //[10]
    cMen += ' <td align="center" width="20%"  bgcolor="#228B22"><font size="2" face="Times">Empresa</font></td>'  //[10]
    cMen += ' <td align="center" width="20%"  bgcolor="#228B22"><font size="2" face="Times">Visitante</font></td>'  //[10]
    cMen += ' <td align="center" width="20%"  bgcolor="#228B22"><font size="2" face="Times">Data da Visita</font></td>'
    cMen += ' <td align="center" width="20%"  bgcolor="#228B22"><font size="2" face="Times">Hora da Visita</font></td>'
    cMen += ' <td align="center" width="20%"  bgcolor="#228B22"><font size="2" face="Times">Data do Cancelamento</font></td>'
    cMen += ' <td align="center" width="20%"  bgcolor="#228B22"><font size="2" face="Times">Hora do Cancelamento</font></td>'
    cMen += ' </tr>'   
    cMen += ' <tr >'
    cMen += ' <td align="center" width="3%"  bgcolor="#FFFFFF"><font size="2" face="Times">'+aCadAg[1][1]+'</font></td>'  //[1] 
    cMen += ' <td align="center" width="3%"  bgcolor="#FFFFFF"><font size="2" face="Times">'+aCadAg[1][2]+'</font></td>'
    cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="2" face="Times">'+aCadAg[1][3]+'</font></td>'  //[2]
    cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="2" face="Times">'+aCadAg[1][4]+'</font></td>'  //[3]
    cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="2" face="Times">'+aCadAg[1][5]+'</font></td>'  //[10]
    cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="2" face="Times">'+aCadAg[1][6]+'</font></td>'  //[10]
    cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="2" face="Times">'+aCadAg[1][7]+'</font></td>'  //[10]
    cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="2" face="Times">'+aCadAg[1][8]+'</font></td>'  //[10]
    cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="2" face="Times">'+aCadAg[1][9]+'</font></td>'  //[10]
    cMen += ' </tr>'   
    cMen += ' </table>
    Else 
    cMen += ' <table cellpadding="1" cellspacing="1" width="800" style="border-style: dotted;border-color: black;border: 1px;">'
    cMen += ' <tr>'
    cMen += ' <td align="center" width="3%"   bgcolor="#228B22"><font size="2" face="Times">Documento</font></td>'  //[2] 
    cMen += ' <td align="center" width="10%"  bgcolor="#228B22"><font size="2" face="Times">Setor</font></td>'
    cMen += ' <td align="center" width="10%"  bgcolor="#228B22"><font size="2" face="Times">Solicitante</font></td>'  //[10]
    cMen += ' <td align="center" width="20%"  bgcolor="#228B22"><font size="2" face="Times">Empresa</font></td>'  //[10]
    cMen += ' <td align="center" width="20%"  bgcolor="#228B22"><font size="2" face="Times">Representante</font></td>'  //[10]
    cMen += ' <td align="center" width="20%"  bgcolor="#228B22"><font size="2" face="Times">Data da Visita</font></td>'
    cMen += ' <td align="center" width="20%"  bgcolor="#228B22"><font size="2" face="Times">Hora da Visita</font></td>'
    cMen += ' </tr>'   
    cMen += ' <tr >'
    cMen += ' <td align="center" width="3%"  bgcolor="#FFFFFF"><font size="2" face="Times">'+aCadAg[1][1]+'</font></td>'  //[1] 
    cMen += ' <td align="center" width="3%"  bgcolor="#FFFFFF"><font size="2" face="Times">'+aCadAg[1][2]+'</font></td>'
    cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="2" face="Times">'+aCadAg[1][3]+'</font></td>'  //[2]
    cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="2" face="Times">'+aCadAg[1][4]+'</font></td>'  //[3]
    cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="2" face="Times">'+aCadAg[1][5]+'</font></td>'  //[10]
    cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="2" face="Times">'+aCadAg[1][6]+'</font></td>'  //[10]
    cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="2" face="Times">'+aCadAg[1][7]+'</font></td>'  //[10]
    cMen += ' </tr>'   
    cMen += ' </table>'
    //Acompanhantes  
    if Len(aAgem) > 0
    cMen += ' <table cellpadding="1" cellspacing="1" width="800" style="border-style: dotted;border-color: black;border: 1px;">'
    cMen += ' <tr>'
    cMen += ' <td align="center" bgcolor="#000000" colspan="3"><font size="2" face="Times" color="#FFFFFF">Visitantes</font></td>'
    cMen += ' </tr>'  
    cMen += ' <tr>'  
    cMen += ' <td align="center" width="10%"  bgcolor="#98FB98"><font size="2" face="Times">Item</font></td>'
    cMen += ' <td align="center" width="10%"  bgcolor="#98FB98"><font size="2" face="Times">Nome do Visitante</font></td>'  
    cMen += ' <td align="center" width="20%"  bgcolor="#98FB98"><font size="2" face="Times">Observações</font></td>'  
    cMen += ' </tr>'
       For X:=1 to len(aAgem)
       cMen += ' <tr >'
       cMen += ' <td align="center" width="3%"  bgcolor="#FFFFFF"><font size="2" face="Times">'+aAgem[X][1]+'</font></td>'  //[1] 
       cMen += ' <td align="center" width="3%"  bgcolor="#FFFFFF"><font size="2" face="Times">'+aAgem[X][2]+'</font></td>'
       cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="2" face="Times">'+aAgem[X][3]+'</font></td>'  //[2]
       cMen += ' </tr>'
       Next
    cMen += ' </table>' 
    EndIF
endIF
    cMen += " </body>"
    cMen += " </html>" 
	  
	oHtml:ValByName("MENS", cMen)
	oProcess:cTo  := _cTo
   	cMailId := oProcess:Start()    

Return
