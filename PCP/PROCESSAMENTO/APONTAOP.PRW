#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/11/99
#INCLUDE "TOPCONN.CH"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

User Function ApontaOP()        // incluido pelo assistente de conversao do AP5 IDE em 19/11/99

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cCod       := Space(50)
Private cDesc      := Space(50)
Private cNrOp      := Space(13)
Private cQtdAp     := Space(10)
Private cQtdRet    := Space(10)
Private cProd      :=Space(15)
Private cQtdOp     := Space(10)
Private cQtdPer    := Space(10)
Private cQtdPerD   := Space(10)           
Private CQtdRetD := Space(10)           
Private cRecurso   := Space(15)
Private cTurno   := Space(15)
Private TipoI:=0 
Private cTitulo:=""
Private cCombo:=""
Private xBase:=""
Private cRecIDSD3:=0
                                                             


SetPrvt("NOPCX,NUSADO,AHEADER,ACOLS,CCLIENTE,CLOJA")
SetPrvt("DDATA,NLINGETD,CTITULO,AC,AR,ACGD")
SetPrvt("CLINHAOK,CTUDOOK,LRETMOD2")
SetPrvt("xHoras,xMinutos,xTdec")

//+--------------------------------------------------------------+
//¦ Opcao de acesso para o Modelo 2              
//+--------------------------------------------------------------+
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza
nOpcx:=3
TpRet:=.T.
If funname()<>"MATA250" //Rotina Customizada de Perdas
	CarregaDados()                   
EndIf	

Return
/*********************************************************************/
User Function MontaGrid (Alias)
//+--------------------------------------------------------------+
//¦ Montando aHeader                                             ¦
//+--------------------------------------------------------------+
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(Alias)
nUsado  := 0
aHeader := {}
While !Eof() .and. (X3_ARQUIVO == Alias)
	IF X3USO(X3_USADO) .and. cNivel >= X3_NIVEL .and. Val(X3_ORDEM)>=8 //.and. Val(X3_ORDEM)<15
		IF (Val(X3_ORDEM)==16 .or. ( Alias="SZ6" .and. Val(X3_ORDEM)=8)) .or.  (Alias="SZ8" .and. (Val(x3_ordem)<7 .OR. Val(x3_ordem)>10 ))
		   dbSkip()
		   LOOP
		ENDIF		

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
dbSeek(Alias)
nUsado := 0
While !Eof() .and. (X3_ARQUIVO == Alias)
	IF X3USO(X3_USADO) .and. cNivel >= X3_NIVEL  .and. Val(X3_ORDEM)>=8 ///.and. Val(X3_ORDEM)<15
		IF Val(X3_ORDEM)==16 .or. ( Alias="SZ6" .and. Val(X3_ORDEM)=8) .or. (Alias="SZ8" .and. ( Val(x3_ordem)<7 .OR. Val(x3_ordem)>10 ) )
		   dbSkip()                                                     	
		   LOOP
		ENDIF
		nUsado++
		IF nOpcx == 3
			IF X3_TIPO == "C"
				aCols[1][nUsado] := Space(X3_TAMANHO)
			Elseif X3_TIPO == "N"
				aCols[1][nUsado] := 0
			Elseif X3_TIPO == "D"
				aCols[1][nUsado] := ctod(" /  /  ") //dDataBase
			Elseif X3_TIPO == "M"
				aCols[1][nUsado] := ""
			Else
				aCols[1][nUsado] := .F.
			Endif
		Endif
	Endif
	dbSkip()
End
aCols[1][nUsado+1] := .F.

Return 


/****************************************************************************************************
*****************************************************************************************************
Função: Carrega Dados da Tela Principal
*****************************************************************************************************
*****************************************************************************************************/
Static Function CarregaDados    

Local aVetOP := {}

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oGrp1","oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oSay7","oSay8","NrOp","Cod")
SetPrvt("QtdOp","QtdAp","oCBox1","oSBtn1","QtdPerD","QtdPer")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 095,232,351,912,"Apontamentos de Horas Paradas/Perdas",,,.F.,,,,,,.T.,,,.T. )
oGrp1      := TGroup():New( 002,002,116,338,"Dados da Ordem de Produção",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 014,006,{||"Ordem de Produção"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008)
oSay2      := TSay():New( 027,007,{||"Código do Produto:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008)
oSay3      := TSay():New( 042,008,{||"Descrição"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,030,008)
oSay4      := TSay():New( 058,009,{||"Qtd da OP: "},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oSay5      := TSay():New( 058,155,{||"Qtd Apontada: "},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oSay6      := TSay():New( 100,010,{||"Apontar:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay7      := TSay():New( 071,155,{||"Qtd de Perdas Detalhadas: "},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,079,008)
oSay8      := TSay():New( 071,009,{||"Qtd de Perdas: "},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oSay9      := TSay():New( 084,009,{||"Qtd Ja Retrab.: "},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oSay10      := TSay():New( 084,155,{||"Qtd a Retrabalhar: "},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,008)   
//02-12-15 Adson validacao do parametro de transferencias
If SuperGetMV('MV_CTRLTRF', .F., "S") == "S" 
	aVetOP := {"Horas Paradas","Retrabalho"}
Else
	aVetOP := {"Horas Paradas","Perdas na Producao","Retrabalho"} 
EndIF

NrOp       := TGet():New( 014,063,{|u| If(PCount()>0,cNrOp:=u,cNrOp)},oGrp1,088,008,'',{||ChecaOp()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SC2","cNrOp",,)
Cod        := TGet():New( 027,063,{|u| If(PCount()>0,cCod:=u,cCod)},oGrp1,088,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cCod",,)
Desc       := TGet():New( 042,063,{|u| If(PCount()>0,cDesc:=u,cDesc)},oGrp1,204,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cDesc",,)
QtdOp      := TGet():New( 055,063,{|u| If(PCount()>0,cQtdOp:=u,cQtdOp)},oGrp1,088,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cQtdOp",,)
QtdAp      := TGet():New( 056,221,{|u| If(PCount()>0,cQtdAp:=u,cQtdAp)},oGrp1,088,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cQtdAp",,)
oCBox1     := TComboBox():New(100,062,{|u|if(PCount()>0,cCombo:=u,cCombo)},aVetOP,072,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,cCombo )
QtdRetD    := TGet():New( 084,063,{|u| If(PCount()>0,cQtdRetD:=u,cQtdRetD)},oGrp1,088,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cQtdRet",,)
QtdRet     := TGet():New( 084,221,{|u| If(PCount()>0,cQtdRet:=u,cQtdRet)},oGrp1,088,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cQtdRet",,)
QtdPerD    := TGet():New( 069,221,{|u| If(PCount()>0,cQtdPerD:=u,cQtdPerD)},oGrp1,088,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cQtdPerD",,)
QtdPer     := TGet():New( 068,063,{|u| If(PCount()>0,cQtdPer:=u,cQtdPer)},oGrp1,088,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cQtdPer",,)
oButton     :=tButton():New(100,154,"Ok",oGrp1,{||SecForm()},037,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

Return
/***********************************************************************/
Static Function  SecForm () 
//Local cAlias
DescTot:=""
cCod:=Posicione("SC2",1,xFilial("SC2")+cNrOP,"C2_PRODUTO")
cDoc:=""
cRecIDSD3:=0
If Empty(cCod)
   	Alert("Op não encontrada")
   	Return 
Else
	cDoc:=Posicione("SD3",1,xFilial("SD3")+cNrOP,"D3_DOC") 
    cEmissao:=SD3->D3_EMISSAO
	if cCombo="Perdas na Producao" .or. cCombo="Retrabalho" 
		Chave:=xFilial("SD3")+cNrOP+Ccod
		DbSelectArea("SD3")
	    While !Eof()
    	    If Chave#xFilial("SD3")+cNrOP+Ccod
        	    Exit 
			Elseif SD3->D3_PERDA>0 .and. SD3->D3_ESTORNO#'S'
				cDoc:=SD3->D3_DOC
	    	    cEmissao:=SD3->D3_EMISSAO   
   			    cRecIDSD3:=Recno()
				Exit
			EndIf		
		   	DbSkip()
	    EndDo 
	EndIf     
    If Empty(cDoc)
	   	Alert("Não há documento de Perda Apontado")
   		Return 
    Endif 
EndIf
TipoI:=1
if Empty(cDoc)
	Alert("Op não tem apontamento")
	Return .F.
EndIf

If cCombo="Horas Paradas"
    xBase:="SZ7"
    u_MontaGrid(xBase)
    cTitulo:="Apontamento dos Motivos de Horas Paradas."
   	DescTot:="Total de Horas Paradas"
ElseIf cCombo=="Perdas na Producao"
    If cQtdPerD=cQtdPer .or. cQtdPer=cQtdRetD+cQtdPerD
    	Alert ("Todas as Perdas já foram detalhadas")
    	Return
    EndIf                                                                                	
    TipoI:=2
    xBase:="SZ6"
    u_MontaGrid(xBase)
    cTitulo:="Apontamento de Perdas de Produção."
	DescTot:="Total de Perdas Detalhadas"
ElseIf cCombo="Retrabalho" 
	If !ConfCC221() // Op não é da Impressão
    	Alert ("Retrabalho só pode ser realizado nas OP's da impressão")
    	Return
    EndIf
    If cQtdPer >0 .and. cQtdPerD=0 
       	Alert ("Retrabalho só pode ser apontado depois dos detalhamentos das perdas")
    	Return
    EndIf   
    If cQtdRet=0
       	Alert ("Não há mais nada a retrabalhar dessa OP")
    	Return
    Endif 
    //Verificar o centro de Custo da OP
	TipoI:=3 
    xBase:="SZ8"
    u_MontaGrid(xBase)
    cTitulo := "Retrabalho"
   	DescTot:="Total Retrabalhado "

EndIF 
cAlias := Alias()
cRecno := Recno()

//+--------------------------------------------------------------+
//¦ Variaveis do Cabecalho do Modelo 2                           ¦
//+--------------------------------------------------------------+
//+--------------------------------------------------------------+
//¦ Variaveis do Rodape do Modelo 2                              ¦
//+--------------------------------------------------------------+
nLinGetD := 0
//+--------------------------------------------------------------+
//¦ Titulo da Janela                                             ¦
//+--------------------------------------------------------------+
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
aAdd(aC,{"cEmissao"	, {15,010} ,"Data de Emissao" ,"@e 99/99/99",,,.F.})
aAdd(aC,{"cDoc"	    , {15,200} ,"Nr. Documento  " ,             ,,,.F.})
aAdd(aC,{"cNrOp"	    , {30,010} ,"Ordem Producao " ,            ,,,.F.})

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
if xBase="SZ7"
	aAdd(aR,{"nLinGetD"	, {120,010} ,DescTot,"@R 99:99",,,.F.})
Else	
	aAdd(aR,{"nLinGetD"	, {120,010} ,DescTot,"@E 999,999",,,.F.})
EndIF 	


//+--------------------------------------------------------------+
//¦ Array com coordenadas da GetDados no modelo2                 ¦
//+--------------------------------------------------------------+
//ttaCGD := {44,5,118,315}//{44,5,118,315}
aCGD := {44,5,118,415}//{44,5,118,315}

//+--------------------------------------------------------------+
//¦ Validacoes na GetDados da Modelo 2                           ¦
//+--------------------------------------------------------------+
if TipoI=1
	cLinhaOk := "ExecBlock('LinOkAP',.F.,.F.)"
	cTudoOk  := "ExecBlock('LinOkAP',.F.,.F.)"
ElseIf TipoI=2
	cLinhaOk := "ExecBlock('VQPerdas',.F.,.F.)"
	cTudoOk  := "ExecBlock('VQPerdas',.F.,.F.)"
ElseIf TipoI=3         
	cLinhaOk:="ExecBlock('LinOkAP',.f.,.f.)"
	cTudoOk :="ExecBlock('LinOkAP',.f.,.f.)"
	
EndIf 	
//+--------------------------------------------------------------+
//¦ Chamada da Modelo2                                           ¦
//+--------------------------------------------------------------+
// lRetMod2 = .t. se confirmou
// lRetMod2 = .f. se cancelou
//TESTE
//If Len(a_HrPr)<>0
//	aCols := a_HrPr
//EndIf
lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,,,,,,,.T.)

If lRetMod2
	
	If TipoI=1
		a_HrPr := aCols
		GravaHorPar()
    Elseif TipoI=2
    	aRPerd:={}      
    	aRPerd:=aCols
    	GravaPerdas()
    Else    
	    a_MtRe:={}
    	a_MtRe:=aCols
    	GravaRetrab()
	EndIf	
Else
	MsgStop("Operacao Cancelada!")
Endif
InicVariaveis()

dbSelectArea(cAlias)
dbGoto(cRecno)


Return 


/*********************************************************************/
Static Function InicVariaveis()
	cCod       := Space(50)
	cDesc      := Space(50)
	cNrOp      := Space(13)
	cQtdAp     := Space(10)
	cQtdOp     := Space(10)
	cQtdPer    := Space(10)
	cQtdPerD   := Space(10)
	cQtdRet   := Space(10)
	cQtdRetD   := Space(10)
	cRecurso   := Space(15)
	cTurno   := Space(15)
	TipoI:=0 
	cTitulo:=""
//	cCombo:=""
	
Return 
/*********************************************************************/
User Function VQPerdas
lRet:=.T.
QuantP:=0
For i:=1 to len(aCols)             
	If ! aCols[i][Len(aCols[i])] 
		QuantP+=aCols[i][3]
		If QuantP>(cQtdPer-cQtdPerD) 
		    SomaPerdas:=cQtdPerD+QuantP
		    Alert("Quantidade detalhada  "+ Alltrim(Str(QuantP))+"  é maior que a perda a ser apontada " +Alltrim(Str(cQtdPer-cQtdPerD)))
		    lRet:=.F.
		EndIf
		nLinGetD:=QuantP
	EndIf 	

Next 


Return lRet
/*********************************************************************/
Static Function ConfDados()
	TpRet:=.T.
	Close(oDlg5)
Return 

/*********************************************************************/
Static Function CancDados()
	TpRet:=.F.
	Close(oDlg5)
Return 
/*********************************************************************/
Static Function ConfCC221()
Local lRet:=.T.
cCC:=Posicione("SC2",1,xFilial("SC2")+cNrOP,"C2_CC")       
If Alltrim(cCC)#"221"
 	lRet:=.F.
EndIf	
Return lRet

/*********************************************************************/
Static Function ChecaOp()
Local lRet:=.F.

DbSelectArea("SC2")
DbSetOrder(1)
if DbSeek(xFilial("SC2")+cNrOp)
    If SC2->C2_QUJE<=0
		Alert("A Op não pode ser utilizada pois não há quantidade produzida")
		Return 
    EndIf

    cCod:=SC2->C2_PRODUTO
    cQtdOp:=SC2->C2_QUANT
    cQtdAP:=SC2->C2_QUJE
    cRecurso:=SC2->C2_RECURSO
    cTurno:=SC2->C2_TURNO
    cProd:=SC2->C2_PRODUTO    
    cQtdPer:=SC2->C2_PERDA
	cQtdRetD:=SC2->C2_QTDRET
	cQtdPerD:=TotPerdas()    
	cQtdRet:=CQtdPer-CQtdPerd-cQtdRetD
    cDesc   :=Posicione("SB1",1,xFilial("SB1")+cCod,"B1_DESC")
//    cDoc   :=Posicione("SD3",1,xFilial("SD3")+cNrOp,"D3_DOC")
//    cEmissao:=Posicione("SD3",1,xFilial("SD3")+cNrOp,"D3_EMISSAO")
    lRet:=.t.
Else
	Alert("OP inexistente")
EndIf

Return  lRet         
////**********************************************************************************************/
Static Function TotPerdas()    
Local QtdP:=0

cQuery:="select sum(Z6_QUANT) as TotPer from "+RetSqlName("SZ6")+" WHERE Z6_OP='"+cNrOp+"' and D_E_L_E_T_='' AND Z6_ESTORNO='' "
TcQuery cQuery Alias "TRB"
DbSelectArea("TRB")
DbGotop()
If !Eof()
  QtdP:=TRB->TotPer
EndIf 
DbCloseArea("TRB")
	
Return QtdP      
/*******************************************************************************************************/
/******************************************************************************************************/
/*******************************************************************************************************/
/* Funçao de Gravação de Retrabalho*/


Static Function GravaRetrab()


DbSelectArea("SD3")
DbGoto (cRecIDSD3)
//SD3->dbrecno(cRecIDSD3)
//if DbSeek(cRecIDSD3)
RecLock("SD3",.F.)
SD3->D3_MOTRET ="S"
Msunlock()
//EndIf



If a_MtRe <> {}// .And. M->D3_MOTRET == "S"  // Rmogi - 12/06/07 - Validacao para gravar apenas qndo motivo igual a 'S'
		nQtdTot:=0
        QtdRetrab:=0
		For _i:=1 to Len(a_MtRe)
			If  Empty(aCols[_i][1]) .and. a_MtRe[_i][Len(a_MtRe[_i])]     // Verifica se registro näo foi deletado. Len(a_MtRe[I]) = ultimo campo do a_MtRe
				Loop
			EndIf		
	          dbSelectArea("SZ8")
	          RecLock("SZ8",.T.)
	          SZ8->Z8_Filial  := xFilial("SZ8") 
	          SZ8->Z8_Emissao := cEmissao
	          SZ8->Z8_Doc     := cDoc
	          SZ8->Z8_Cod     := cCod
	          SZ8->Z8_OP      := cNrOp        
	          SZ8->Z8_Turno   := cTurno
	          SZ8->Z8_Recurso := cRecurso
	          SZ8->Z8_CodMot  := a_MtRe[_i][1] 
	          SZ8->Z8_Motivo  := a_MtRe[_i][2]
	          SZ8->Z8_Quant   := a_MtRe[_i][3]
	          msUnlock() 
	          nQtdTot+=a_MtRe[_i][3]       
	          QtdRetrab+=SZ8->Z8_Quant
		Next
        dbSelectArea("SC2")
        RecLock("SC2",.F.)
        SC2->C2_QTDRET:=QtdRetrab
        msUnlock() 
        



		/*GERA OP DE RETRABALHO*/
//		IF alltrim(m->D3_CC) == "221" .And. nQtdTot>0 .And. M->D3_MOTRET == "S" // Rmogi - 12/06/07
		   	If MsgYesNo("Confirma geracao da OP de Retrabalho?") // Jorge 25/04/08
		       U_motRetOP(nQtdTot)
		    End   
//		End
	EndIf   
            
Return 

////**********************************************************************************************/
////**********************************************************************************************/
Static Function TotRetrab()    
Local QtdR:=0

cQuery:="select sum(Z8_QUANT) as TotRet from "+RetSqlName("SZ8")+" WHERE Z8_OP='"+cNrOp+"' and D_E_L_E_T_='' "
TcQuery cQuery Alias "TRB"
DbSelectArea("TRB")
DbGotop()
If !Eof()
  QtdR:=TRB->TotRet
EndIf 
DbSelectArea("TRB")
DbCloseArea()
	
Return QtdR
////**********************************************************************************************/

Static Function GravaHorPar()

	If a_HrPr<>{}
	   aHPMM := {} // Array de Horas Paradas de Manutencao de Maquinas 
		For i:=1 to Len(a_HrPr)
			If ! a_HrPr[i][Len(a_HrPr[i])]  // Verifica se registro näo foi deletado.
				
				dbSelectArea("SZ7")
				RecLock("SZ7",.T.)
				SZ7->Z7_FILIAL  := xFilial("SZ7")
				SZ7->Z7_EMISSAO := cEmissao
				SZ7->Z7_DOC     := cDoc
				SZ7->Z7_COD     := cCod
				SZ7->Z7_OP      := cNrOp
				SZ7->Z7_RECURSO := cRecurso
				SZ7->Z7_TURNO   := cTurno
				SZ7->Z7_CODMOT  := a_HrPr[I][1]
				SZ7->Z7_MOTIVO  := a_HrPr[I][2]
				SZ7->Z7_OBS     := a_HrPr[I][3]
				SZ7->Z7_DATINI  := a_HrPr[I][4]
				SZ7->Z7_HINI    := a_HrPr[I][5]
				SZ7->Z7_DATFIN  := a_HrPr[I][6]
				SZ7->Z7_HFIN    := a_HrPr[I][7]
				SZ7->Z7_TDEC    := a_HrPr[I][8] // a_HrPr[I][5]
				SZ7->Z7_CCAPLIC := a_HrPr[I][9]
				msUnlock()
			
			    If a_HrPr[I][1] == "29" .OR. alltrim(a_HrPr[I][9]) == "614"
		           
		           xDesc := Posicione("SB1",1,xFilial("SB1")+cProd,"B1_DESC")
		           
		           AAdd(aHPMM,{cEmissao,;   // [01] Data da Emissao
		                           cDoc,;   // [02] Documento
		                           cProd,;   // [03] Codigo do Produto
		                               xDesc,;   // [04] Descricao
		                            cNrOp,;   // [05] OP
		                            cRecurso,;   // [06] Recurso
		                         cTurno,;   // [07] Turno
		                        a_HrPr[I][1],;   // [08] Cod. Motivo
		                        a_HrPr[I][2],;   // [09] Desc. Motivo
	                            a_HrPr[I][3],;   // [10] Obs
	                            a_HrPr[I][4],;   // [11] Data Inicial da Parada
	                            a_HrPr[I][5],;   // [12] Hora Inicial da Parada
	                            a_HrPr[I][6],;   // [13] Data Final da Parada
	                            a_HrPr[I][7],;   // [14] Hora Final da Parada
	                                   xTdec,;   // [15] Tempo de Parada
	                            a_HrPr[I][9]})   // [16] CC Aplic da Parada
			
			    Endif
			EndIf
		Next
	EndIf
	U_WFE12(aHPMM)	
Return	       


//********************************************************************************************************************************/

Static Function GravaPerdas

For i:=1 to len (aCols)

 If ! aCols[i][Len(aCols[i])] 
		dbSelectArea("SZ6")
		RecLock("SZ6",.T.)
		SZ6->Z6_Filial  := xFilial("SZ6")
		SZ6->Z6_Emissao := cEmissao
		SZ6->Z6_Doc     := cDoc
		SZ6->Z6_Cod     := cCod
		SZ6->Z6_OP      := cNrOp
		SZ6->Z6_Recurso := cRecurso
		SZ6->Z6_Turno   := cTurno
		SZ6->Z6_CodMot  := aCols[i][1]
		SZ6->Z6_Motivo  := aCols[i][2]
		SZ6->Z6_Quant   := aCols[i][3]
		SZ6->Z6_MAT    := aCols[i][4]
		SZ6->Z6_RESP   := aCols[i][5]
		msUnlock()
 EndIf	
Next
Return

User Function LinOkAp()
Local lRet:=.T.

n_Soma   := 0
nLinGetD := 0

If xBase="SZ7" .and.  	aR[01][01]== "nLinGetD"
	Posc:=8
Else//if  xBase="SZ8" .OR. 
	PosC:=3	
EndIF 
if  !aCOLS[n][Len(aCols[n])]
 
	If xBase="SZ7" .and.  aR[01][01]== "nLinGetD"
		If dtos(aCols[n][4])+aCols[n][5]>dtos(aCols[n][6])+aCols[n][7]
			lRet := .F.
			MsgStop("Data e/ou Hora de Parada Incorretos!")		  
			Return lRet
	    Else
		   	aCols[n][PosC]:=DifHoras()
		EndIf
	EndIf
EndIF

For _i:=1 to Len(aCols)
	If !aCOLS[_i][Len(aCols[_i])] .and. aR[01][01]=="nLinGetD"
//		n_Soma += aCols[_i][PosC]
        If xBase="SZ7"      
			nLinGetD := SomaHoras(nLinGetD,aCols[_i][PosC] )
			
        Else           
			nLinGetD+=aCols[_i][PosC]
			If nLinGetD>cQtdRet
			  lRet:=.F.
			  MsgStop('Quantida a retrabalhar é de '+Alltrim(Str(nLinGetD))+' e informado '+Alltrim(Str(cQtdRet)) )
			  Return lRet
			EndIf
		EndIf 


	EndIf
	/*MOTIVO DE RETRABALHO - 08/03/07 - Rmogi*/
	//If !aCOLS[_i][Len(aCols[_i])] .and. aR[01][01]=="nRetr"
		//nRetr += aCols[_i][3]
	//EndIf	
    /*MOTIVO DE RETRABALHO - 08/03/07 - Rmogi*/
Next

Return(lRet)
///*********************************************************************/
Static Function DifHoras


	If dtos(aCols[n][6]) == dtos(aCols[n][4])
		If Val(Right(aCols[n][7],2)) >= Val(Right(aCols[n][5],2))
			xHoras   := Int(Val(Left( aCols[n][7],2)) - Val(Left( aCols[n][5],2)))
			xMinutos := Int(Val(Right(aCols[n][7],2)) - Val(Right(aCols[n][5],2)))
		Else
			xHoras   := Int(Val(Left( aCols[n][7],2)) - Val(Left( aCols[n][5],2)) - 01)
			xMinutos := Int(Val(Right(aCols[n][7],2)) - Val(Right(aCols[n][5],2)) + 60)
		EndIf
	Else
		If Val(Right(aCols[n][7],2)) >= Val(Right(aCols[n][5],2))
			xHoras   := Int(Val(Left( aCols[n][7],2)) - Val(Left( aCols[n][5],2)) + 24)
			xMinutos := Int(Val(Right(aCols[n][7],2)) - Val(Right(aCols[n][5],2)))
		Else
			xHoras   := Int(Val(Left( aCols[n][7],2)) - Val(Left( aCols[n][5],2)) + 23)
			xMinutos := Int(Val(Right(aCols[n][7],2)) - Val(Right(aCols[n][5],2)) + 60)
		EndIf
	EndIf
	xTdec := StrZero(xHoras,2)+StrZero(xMinutos,2)

Return xTdec


/***********************************************************************/
/************************************************************************************************/