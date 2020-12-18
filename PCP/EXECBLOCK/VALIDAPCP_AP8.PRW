#include "rwmake.ch"
#include "TOPCONN.CH"

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA  ³ VALIDAPCP         REMERSON MOGI            DATA ³ 24/01/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³ Validações do modulo de pcp                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ALTERACAO ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³CLIENTE   ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
/*/

******************************
User Function validTurno()
******************************
//*****************************
//*VALIDAÇÃO o turno na tabela SD3 (Apontamento de Produção)
//*****************************

If  !Alltrim(FunName()) $ "MATA250"
	Return .T.
EndIf

cArea    := GetArea()
cTM      := M->D3_TM
cOP      := M->D3_OP
cCC      := SUBS(POSICIONE("SC2",1,xFilial("SC2")+SUBS(cOP,1,6)+SUBS(cOP,7,2)+SUBS(cOP,9,3),"C2_CC"),1,3)

cTurno   := POSICIONE("SC2",1,xFilial("SC2")+SUBS(cOP,1,6)+SUBS(cOP,7,2)+SUBS(cOP,9,3),"C2_TURNO") 
dDataHj  := ddatabase

lPode    := .T.

/*
IF cTM == "400" .and. cCC=="231"
   lPode        := .T.     
   dbSetOrder(1)
   If !dbSeek(xFilial("SD3")+cOP)
      DO CASE
         CASE SUBS(cOP,5,2)>="01" .AND. SUBS(cOP,5,2)<="10"
              cTurno:="01"
         CASE SUBS(cOP,5,2)>="11" .AND. SUBS(cOP,5,2)<="20"
              cTurno:="02"
         CASE SUBS(cOP,5,2)>="21" .AND. SUBS(cOP,5,2)<="30"
              cTurno:="03"
      ENDCASE                    
      M->D3_TURNO:=cTurno                                                      
   Else
      msgstop("Ordem de Produção encerrada...")
   End   
End
*/ 

IF cTM == "400" 
   lPode        := .T.     
   dbSetOrder(1)
   If !dbSeek(xFilial("SD3")+cOP)       
      M->D3_TURNO:=cTurno                                                      
   Else
      msgstop("Ordem de Produção encerrada...")
   End   
End
      
RestArea(cArea)
Return(lPode) 


User Function QuanProd(cProd) 
 cArea    := GetArea()
 xPreco :=0

 cQuery := ""
 cQuery := " SELECT AIB_PRCCOM "
 cQuery += " FROM  DADOSAP10..AIB010 "
 cQuery += " WHERE AIB_CODPRO='"+cProd+"'"            
 cQuery += " AND   AIB_CODTAB IN ('001','003')" 
 cQuery += " AND   AIB010.D_E_L_E_T_ <> '*'"  

 cQuery := ChangeQuery(cQuery)

 TCQUERY cQuery Alias TRA New  
 
 dbSelectArea("TRA")
      
 xPreco := AIB_PRCCOM   

 dbClearFil(NIL)
 dbCloseArea("TRA")
 dbCloseArea()   
 RestArea(cArea)
 
 Return xPreco   
 
 
 User Function getLoteSB8(cProd,cLocal,dDtInv)  
 aLote  :={}
 xEmpresa  := SM0->M0_CODIGO
 
 cQuery := ""
 cQuery += " Select B8_PRODUTO,B8_LOCAL,SUM(B8_SALDO) AS B8_SALDO,B8_LOTECTL"
 cQuery += " from DADOSAP10..SB8"+xEmpresa+"0" 
 cQuery += " WHERE B8_PRODUTO ='"+cProd +"'"
 cQuery += " AND   B8_LOCAL   ='"+cLocal+"'" 
 cQuery += " AND   B8_SALDO > 0"
 cQuery += " AND   B8_DATA  <= '"+DTOS(dDtInv)+"'"
 cQuery += " AND   SB8"+xEmpresa+"0.D_E_L_E_T_ <> '*'"  
 
 cQuery += " GROUP BY B8_PRODUTO,B8_LOCAL,B8_LOTECTL"
 
 
 cQuery := ChangeQuery(cQuery)

 TCQUERY cQuery Alias TAX New      // Tabela de Totais do SZ9 Temporarios
 
 DbSElectArea("TAX")  
 ProcRegua(RecCount())
 
 DbGotop() 
 While !TAX->(Eof()) 
       //nPos := aScan(xCompra,{|X| X[1] == cComp .And. xMescomp == X[4] })
	
	   //If nPos == 0 
	      //msgstop(B8_PRODUTO+B8_LOTECTL)
		  aAdd(aLote, {B8_PRODUTO,;                     // 01 PRODUTO
		                 B8_LOCAL,;						// 02 ARMAZEM
		                 B8_SALDO,;						// 03 SALDO
		               B8_LOTECTL,;						// 04 LOTE
		                     .T. })                     // 05 FLAG
	   //EndIf        
     TAX->(DBSKIP())    
 ENDDO 
 dbSelectArea("TAX")
 dbClearFil(NIL)
 dbCloseArea("TAX")
 dbCloseArea()
Return aLote   
  
// User Function getSomaLoteSB8(cProd,cLocal)  
// nTotLote  :=0

// cQuery := ""
// cQuery += " Select sum(B8_SALDO) as B8_SALDOT"
// cQuery += " From DADOSAP10..SB8010" 
// cQuery += " WHERE B8_PRODUTO ='"+cProd +"'"
// cQuery += " AND   B8_LOCAL   ='"+cLocal+"'" 
// cQuery += " AND   B8_SALDO <> 0" 
 //cQuery += " AND   SB8010.D_E_L_E_T_ <> '*'"  
 
 //cQuery += " GROUP BY B8_PRODUTO,B8_LOCAL,B8_LOTECTL"
 
 
// cQuery := ChangeQuery(cQuery)

// TCQUERY cQuery Alias TAX New      // Tabela de Totais do SZ9 Temporarios
 
// DbSElectArea("TAX")  

// nTotLote  :=B8_SALDOT

// dbSelectArea("TAX")
// dbClearFil(NIL)
 //dbCloseArea("TAX")
 //dbCloseArea()
//Return nTotLote   


 User Function getLoteBJ(cProd,cLocal,dDtInv)  
 aLote  :={}
 
 cQuery := ""
 cQuery += " Select BJ_COD,BJ_LOCAL,BJ_LOTECTL,BJ_NUMLOTE,BJ_QINI"
 cQuery += " From DADOSAP10..SBJ010" 
 cQuery += " WHERE BJ_COD ='"+cProd +"'"
 cQuery += " AND   BJ_LOCAL   ='"+cLocal+"'" 
 cQuery += " AND   BJ_QINI <> 0"
 cQuery += " AND   BJ_DATA  = '"+DTOS(dDtInv)+"'"
 
 cQuery += " AND   SBJ010.D_E_L_E_T_ <> '*'"   
 cQuery += " order by BJ_DTVALID ASC" 
 
 cQuery := ChangeQuery(cQuery)

 TCQUERY cQuery Alias TAX New      // Tabela de Totais do SZ9 Temporarios
 
 DbSElectArea("TAX")  
 ProcRegua(RecCount())
 
 DbGotop() 
 While !TAX->(Eof()) 
       //nPos := aScan(xCompra,{|X| X[1] == cComp .And. xMescomp == X[4] })
	
	   //If nPos == 0 
	      //msgstop(B8_PRODUTO+B8_LOTECTL)
		  aAdd(aLote, {BJ_COD,;                     // 01 PRODUTO
		             BJ_LOCAL,;						// 02 ARMAZEM
		              BJ_QINI,;						// 03 SALDO
		           BJ_LOTECTL,;						// 04 LOTE
		           BJ_NUMLOTE,;                     // 05 NUMLOTE
		                 .T. })                     // 06 FLAG
	   //EndIf        
     TAX->(DBSKIP())    
 ENDDO 
 dbSelectArea("TAX")
 dbClearFil(NIL)
 dbCloseArea("TAX")
 dbCloseArea()
Return aLote   

 User Function getLotB8(cProd,cLocal,dDtInv)  
 aLote  :={}
 
 cQuery := ""
 cQuery += " Select B8_PRODUTO,B8_SALDO AS B8_SALDO,B8_LOTECTL,B8_NUMLOTE"
 cQuery += " from DADOSAP10..SB8010" 
 cQuery += " WHERE B8_PRODUTO ='"+cProd +"'"
 cQuery += " AND   B8_LOCAL   ='"+cLocal+"'" 
 cQuery += " AND   B8_SALDO > 0"
 cQuery += " AND   B8_DATA  <= '"+DTOS(dDtInv)+"'"
 cQuery += " AND   SB8010.D_E_L_E_T_ <> '*'"  
 
 cQuery += " order by B8_DATA ASC" 
 
 cQuery := ChangeQuery(cQuery)

 TCQUERY cQuery Alias TAX New      // Tabela de Totais do SZ9 Temporarios
 
 DbSElectArea("TAX")  
 ProcRegua(RecCount())
 
 DbGotop() 
 While !TAX->(Eof()) 
       //nPos := aScan(xCompra,{|X| X[1] == cComp .And. xMescomp == X[4] })
	
	   //If nPos == 0 
	      //msgstop(B8_PRODUTO+B8_LOTECTL)
		  aAdd(aLote, {B8_PRODUTO,;                     // 01 PRODUTO
		                 B8_NUMLOTE,;						// 02 ARMAZEM
		                 B8_SALDO,;						// 03 SALDO
		               B8_LOTECTL,;						// 04 LOTE
		                     .T. })                     // 05 FLAG
	   //EndIf        
     TAX->(DBSKIP())    
 ENDDO 
 dbSelectArea("TAX")
 dbClearFil(NIL)
 dbCloseArea("TAX")
 dbCloseArea()
Return aLote   





 User Function getDoc()  
 aDoc  :={}
 
 cQuery := ""
 cQuery += " Select DISTINCT D3_DOC"
 cQuery += " from DADOSAP10..SD3010" 
 cQuery += " WHERE D3_EMISSAO = '20060315'"
 //cQuery += " AND   D3_EMISSAO <= '20060315'"
 cQuery += " AND   SD3010.D_E_L_E_T_ <> '*'" 

 
 cQuery := ChangeQuery(cQuery)

 TCQUERY cQuery Alias TAX New      // Tabela de Totais do SZ9 Temporarios
 
 DbSElectArea("TAX")  
 ProcRegua(RecCount())
 
 DbGotop() 
 While !TAX->(Eof()) 
   	    
   	    aAdd(aDoc, {D3_DOC,;                     // 01 PRODUTO
	                    .T. })                    // 02 FLAG

     TAX->(DBSKIP())    
 ENDDO 
 dbSelectArea("TAX")
 dbClearFil(NIL)
 dbCloseArea("TAX")
 dbCloseArea()
Return aDoc   

