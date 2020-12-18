#include "rwmake.ch"                                        
#INCLUDE "URZUM.CH" // Incluido por Afill
/*****************************************************************/
/*****Ponto de Entrada para exclusão Geral de Pedido****/
/*****************************************************************/
User function MTA120E()	                         
	Msgbox("Pedidos de compra da NSB não podem ser excluídos","Exclusão de Pedido","Alert")
Return .F. 
/*****************************************************************/
/**Ponto de Entrada para exclusão dos itens do pedido***/
/*****************************************************************/
/*User function MT120OK()
Local lRet:=.T. 
If Altera
	For i:=1 to Len(aCols)
		If aCols[i][Len(aHeader) + 1] 
				Msgbox("Itens do pedidos de compra da NSB não podem ser excluídos","Exclusão de Item do Pedido","Alert")
		        lRet:=.F.
				Return lRet 
		EndIf 		   	
	Next 
Endif 	        
// Inicio Afill
If !IsBlind()
	lRet := U_UZPCVIMP("GERAL")
	If !lRet
		MsgStop(MSGPI1,"Pedido Importado") 
	EndIf
EndIf          
// Fim Afill

Return lRet */
/************************************************************************/
/************************************************************************/
User Function MT120LOK
Local lRet:=.T.
    PrTab:=0
    PosRes:=aScan(aHeader,{|x| AllTrim(x[2])=="C7_RESIDUO"})
    PosMRes:=aScan(aHeader,{|x| AllTrim(x[2])=="C7_MSGR"})
    PosTab:=aScan(aHeader,{|x| AllTrim(x[2])=="C7_CODTAB"})
    PosVr:=aScan(aHeader,{|x| AllTrim(x[2])=="C7_PRECO"})
    PosP   :=aScan(aHeader,{|x| AllTrim(x[2])=="C7_PRODUTO"})
    PosC7   :=aScan(aHeader,{|x| AllTrim(x[2])=="C7_NUM"})

	If acols[N][PosREs]=='S'  .and. Empty(acols[N][PosMRes])                        
        MsgBox("Informe o  motivo da eliminacao do residuo (Msg Residuo)")
        lRet:=.F.                                                                                                                      
    Endif
    If ! Empty(acols[N][Postab])                        
       //aCols[n][PosTab]:=U_GtabPrc() 
       PrTab:=posicione("AIB",2,xFilial("AIB")+CA120FORN+CA120LOJ+acols[N][Postab]+aCols[n][Posp],"AIB_PRCCOM")
       if aCols[n][PosVr]<>PrTab
	        MsgBox("Preço diferente da tabela. Corrija para continuar.")       
            lRet:=.F.                 
       Endif
    Endif                                            
	//acols[N][PosC7] := cA120Num     
    //Chama o Gatinho da tabela de Preço novamente
    //    PosTab:=aScan(aHeader,{|x| AllTrim(x[2])=="C7_CODTAB"})


Return lRet
//******************************************************************************/

/*******************************************************************************/
User Function GTabPrC()      
Local Chave:="",CodTab:=""
Local EstFor:="",GrpProd:=""
//AIA_FILIAL, AIA_CODFOR, AIA_LOJFOR, AIA_CODTAB, R_E_C_N_O_, D_E_L_E_T_
PosTot:=aScan(aHeader,{|x| AllTrim(x[2])=="C7_TOTAL"})
PosP:=aScan(aHeader,{|x| AllTrim(x[2])=="C7_PRODUTO"})
PosPr:=aScan(aHeader,{|x| AllTrim(x[2])=="C7_PRECO"})
PosQ:=aScan(aHeader,{|x| AllTrim(x[2])=="C7_QUANT"})
GrpProd:=Posicione("SB1",1,xFilial("SB1")+aCols[n][PosP],"B1_GRUPO")
EstFor:=Posicione("SA2",1,xFilial("SA2")+CA120FORN+CA120LOJ,"A2_EST")
infC:=""
lRet:=.F.
//If Alltrim(EstFor)<>'EX' .and. Alltrim(GrpProd)="MPN" alterado pela aglair
if substring(Alltrim(GrpProd),1,2)="MP" 
	Chave:=xFilial("AIA")+CA120FORN+CA120LOJ
	//Procura a tabela valida para o produto
	DbSelectArea("AIA")
	DbSetOrder(1)
	If DbSeek(xFilial("AIA")+CA120FORN+CA120LOJ)
		CodTab:=""
		While !Eof()
	     	Chave:=xFilial("AIA")+CA120FORN+CA120LOJ
		     If AIA->AIA_FILIAL+AIA->AIA_CODFOR+AIA->AIA_LOJFOR=Chave
				If Empty(AIA->AIA_DATATE) .and. AIA->AIA_CONDPG=cCondicao
					CodTab:=AIA->AIA_CODTAB                              
					dbSelectArea("AIB")
					DbSetOrder(2)
				    Chave:=xFilial("AIB")+CA120FORN+CA120LOJ+CodTab+aCols[n][2]
				        //Verifica se o produto está na tabela informada
				    infC:=""
					if DbSeek(Chave)
				        aCols[n][PosPr]:=AIB->AIB_PRCCOM           
				        aCols[n][PosTot]:=aCols[n][PosPr]*aCols[n][PosQ]
					    M->C7_PRECO:=AIB->AIB_PRCCOM
					    M->C7_TOTAL:=aCols[n][PosTot]
					    lRet:=.T.
				    	Exit
				    EndIf 
				
				EndIf
			Else
				Exit	
			EndIf	
            DbSelectArea("AIA")
			DbSkip()
		EndDo
	EndIf	
    if Empty(CodTab) .and. ! lRet 
        Infor:="Material Produtivo tem que ter uma tabela de preço valida. "+chr(10)+chr(13) 
        Infor+=InfC
		Alert(Infor)
		//M->C7_PRODUTO=Space(15)
//		aCols[n][2]=Space(15) //Codigo do produto
//		aCols[n][3]="" //Desc do produto
		aCols[n][6]="" //Tabela de preço
	EndIf 

 EndIf 		                       
Return CodTab                       
/*****************************************************************/
//Validação da tabela
/*******************************************************************************/
User Function GatC7TAB()      
Local Chave:="",CodTab:=""
Local EstFor:="",GrpProd:=""
//AIA_FILIAL, AIA_CODFOR, AIA_LOJFOR, AIA_CODTAB, R_E_C_N_O_, D_E_L_E_T_

PosTab:=aScan(aHeader,{|x| AllTrim(x[2])=="C7_CODTAB"})
PosP:=aScan(aHeader,{|x| AllTrim(x[2])=="C7_PRODUTO"})
PosPreco:=aScan(aHeader,{|x| AllTrim(x[2])=="C7_PRECO"})
PosQ:=aScan(aHeader,{|x| AllTrim(x[2])=="C7_QUANT"})
PosTot:=aScan(aHeader,{|x| AllTrim(x[2])=="C7_TOTAL"})
EstFor:=Posicione("SA2",1,xFilial("SA2")+CA120FORN+CA120LOJ,"A2_EST")
GrpProd:=Posicione("SB1",1,xFilial("SB1")+aCols[n][PosP],"B1_GRUPO")
TabDig:=aCols[n][PosTab]
infC:=""
//Alterado para pegar todas as materias primas.
//If Alltrim(EstFor)<>'EX' .and. Alltrim(GrpProd)="MPN"
if    substring(Alltrim(GrpProd),1,2)="MP" 

	Chave:=xFilial("AIA")+CA120FORN+CA120LOJ
	//Procura a tabela valida para o produto
	DbSelectArea("AIA")
	DbSetOrder(1)
	If DbSeek(xFilial("AIA")+CA120FORN+CA120LOJ)
		While !Eof()
		    If AIA->AIA_FILIAL+AIA->AIA_CODFOR+AIA->AIA_LOJFOR=Chave
                if AIA->AIA_CONDPG=cCondicao
					if Alltrim(AIA->AIA_CODTAB)=Alltrim(TabDig) .and. Empty(AIA->AIA_DATATE) 
	                   CodTab:=TabDig
	                   Exit
					Elseif  Empty(AIA->AIA_DATATE)
					   CodTab:=AIA->AIA_CODTAB                              
				    EndIf 
	            EndIf     
			Else
				Exit	
			EndIf	
			DbSkip()
		EndDo
	EndIf	
	If ! Empty(CodTab)
		DbSelectArea("AIB")
		DbSetOrder(2)
        Chave:=xFilial("AIB")+CA120FORN+CA120LOJ+CodTab+aCols[n][PosP]
        //Verifica se o produto está na tabela informada
        infC:=""
		If !DbSeek(Chave)
		    CodTab:=""                
		    InfC:="Esse produto não existe na tabela do fornecedor"
		Else 
		  aCols[n][PosPreco]:=AIB->AIB_PRCCOM
		  aCols[n][PosTot]:=aCols[n][PosPreco]*aCols[n][PosQ]
		  M->C7_PRECO:=AIB->AIB_PRCCOM
		  M->C7_TOTAL:=aCols[n][PosTot]
		EndIf      
    EndIf 
    if Empty(CodTab) 
        Infor:="Material Produtivo com fornecedor nacional tem que ter tabela de preço valida. "+chr(10)+chr(13) 
        Infor+=InfC

		Alert(Infor)
		//M->C7_PRODUTO=Space(15)
//		aCols[n][2]=Space(15) //Codigo do produto
//		aCols[n][3]="" //Desc do produto
		aCols[n][PosTab]="  " //Tabela de preço
	EndIf 
EndIf 		                       
  aCols[n][PosTab]=CodTab //Tabela de preço
//  U_GTabPrC()
Return CodTab                       
/*****************************************************************/
User Function ValidAlt()       
Local lRet:=.T.
	if Altera .and. M->C7_QUANT<=M->C7_QUJE
		Alert("Pedido com a quantidade já atendida")
		lRet:=.F.
	EndIf 
Return  lRet

//****************************************************************/
//User Function MT120ALT ()
//Private CodTab:=""

//Return 
/*****************************************************************/