#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#include "ap5mail.ch"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"


/* Rotinas de Uso Generico */
User Function ContaQ(pStr,pAntes,pMuda,pOrdem)
   Local nRegs

   TCQUERY pStr ALIAS ZZZ New
   dbSelectArea("ZZZ")
   nRegs := If( SOMA == Nil , 0, SOMA)
   dbCloseArea()
   //
   pStr := StrTran(pStr,pAntes,pMuda)+If(pOrdem==Nil.Or.Empty(pOrdem),"", " ORDER BY "+pOrdem)
   //
Return(nRegs)
//
//
User Function Stod(pData)
   dDtRet := Ctod(SubStr(pData,7,2)+"/"+SubStr(pData,5,2)+"/"+SubStr(pData,1,4))
Return(dDtRet)
//
//
User Function Posicao(pCampo)
   cCampo := pCampo+Space(10-Len(pCampo))
   nPos := AScan(aHeader,{|x| x[2] == cCampo })
Return(nPos)
//
//
/* Rotinas especificas da Timex */
User Function CodTimex(pCod)
   Local cProd := pCod
   Do Case
      Case Len(AllTrim(pCod)) < 8
      Case SubStr(pCod,1,1) $ "P" .AND. SubStr(pCod,2,1) $ "0123456789"
      Case SubStr(pCod,1,1) $ "GI" 
      Case SubStr(pCod,1,1) $ "TI"
      Case Upper(SubStr(pCod,4,3)) == "EYE"
      OtherWise
         cProd := SubStr(pCod,4,7)+Space(8)
   EndCase
Return(cProd)
//
//
User Function RetVen(pMen)
   cAlias := Alias()
   cVen   := Space(06)
   dbSelectArea("SA3")
   dbSetOrder(7)
   dbSeek(XFILIAL("SA3")+__cUserId,.T.)
   While ! Eof() .And. __cUserId == A3_CODUSR .And. XFILIAL("SA3") == A3_FILIAL
      cVen := AllTrim(cVen) + If( A3_COD $ cVen , "", A3_COD + ",")
      dbSkip()
   Enddo
   If Empty(cVen) .And. pMen
      Alert("Usuario nao esta no Cadastro de Vendedores !")
   ElseIf Len(cVen) > 6
      cVen := SubStr(cVen,1,Len(cVen)-1)
   Endif
   dbSelectArea(cAlias)
Return(cVen)

User Function PegaTes(pTipo)
   cTES   := ""
   cAlias := Alias()
   dbSelectArea("SX5")
   dbSetOrder(1)
   If dbSeek(XFILIAL("SX5")+"Y6"+pTipo)   
      IF PTIPO $ "SAI/VEN"
         cTES := AllTrim(X5_DESCRI)+AllTrim(X5_DESCENG)+AllTrim(X5_DESCSPA) //ALTERADO EM 19/08/02 SARKIS  //AllTrim(X5_DESCRI)
        ELSE 
         cTES := AllTrim(x5_DESCRI)
      ENDIF 
   Endif
   dbSelectArea(cAlias)
Return(cTES)

User Function SepEmp(pCod,pQuant,pRet,pEmp)
   Local cCodPrd := U_CodTimex(pCod), nQtdInd, nQtdCor, nSaldo
   dbSelectArea("SB2")
   dbSetOrder(1)
   If dbSeek("03"+cCodPrd+"17")
      nQtdCor := B2_QATU - (B2_RESERVA + B2_QPEDVEN)
      nQtdCor := If( nQtdCor < 0, 0, nQtdCor)
      If nQtdCor > 0
         nQtdInd := 0
         dbSelectArea("SZC")
         dbSetOrder(1)
         If dbSeek(XFILIAL("SZC")+cCodPrd)
            dbSelectArea("SB2")
            dbSetOrder(1)
            If dbSeek("01"+SZC->ZC_CODIND+"01")
               nQtdInd := B2_QATU - (B2_RESERVA + B2_QPEDVEN)
               nQtdInd := If( nQtdInd < 0, 0, nQtdInd)
            Endif
         Endif

         If pQuant > nQtdCor .And. nQtdInd > 0
            If pQuant > nQtdInd
               nSaldo := pQuant - nQtdInd
               PesqInd(cCodPrd,.T.,pRet,pQuant-nSaldo)
               If aFil[1] .And. pEmp $ "IT"
                  U_GrvPedEst(vInd[Len(vInd),1],"01","01",pQuant-nSaldo,.T.)
               Endif
               If aFil[1]
                     //          Cod       Indice  Quant                 Tes CFo Flag    Flag   
                     //                                                             Del.Ind Del.Cor
                     aFil[2] := .T.
                     AAdd( vCor , { cCodPrd, &(pRet) , 0, 0, 0, "", "",aFil[1],aFil[2] })
               Else
                  nSaldo := pQuant
               Endif
               vCor[Len(vCor),3] := nSaldo
               If pEmp $ "CT"
                  U_GrvPedEst(cCodPrd,"03","17",nSaldo,.T.)
               Endif
            Else
                     //          Cod       Indice  Quant                 Tes CFo Flag    Flag   
                     //                                                             Del.Ind Del.Cor
               aFil[1] := .T.
               AAdd( vInd , { SZC->ZC_CODIND, &(pRet), pQuant, 0, 0, "", "",       aFil[1] , aFil[2] })
               If pEmp $ "IT"
                  U_GrvPedEst(SZC->ZC_CODIND,"01","01",pQuant,.T.)
               Endif
            Endif
         Else
            aFil[2] := .T.
            AAdd( vCor , { cCodPrd, &(pRet), pQuant, 0, 0, "", "",aFil[1],aFil[2]} )
            If pEmp $ "CT"
               U_GrvPedEst(cCodPrd,"03","17",pQuant,.T.)
            Endif
         Endif
      Else
         PesqInd(cCodPrd,.F.,pRet,pQuant)
         If aFil[1] .And. pEmp $ "IT"
            U_GrvPedEst(vInd[Len(vInd),1],"01","01",pQuant,.T.)
         ElseIf pEmp $ "CT"
            U_GrvPedEst(cCodPrd,"03","17",pQuant,.T.)
         Endif
      Endif
   Else
      PesqInd(cCodPrd,.T.,pRet,pQuant)
      If aFil[1] .And. pEmp $ "IT"
         U_GrvPedEst(vInd[Len(vInd),1],"01","01",pQuant,.T.)
      ElseIf pEmp $ "CT"
         U_GrvPedEst(cCodPrd,"03","17",pQuant,.T.)
      Endif
   Endif
Return
Static Function PesqInd(pCod,pOk,pRet,pQtd)
   dbSelectArea("SZC")
   dbSetOrder(1)
   If dbSeek(XFILIAL("SZC")+pCod)
      dbSelectArea("SB2")
      dbSetOrder(1)
      If dbSeek("01"+SZC->ZC_CODIND+"01")
         If B2_QATU > 0
            aFil[1] := .T.
            AAdd( vInd , { SZC->ZC_CODIND, &(pRet), pQtd, 0, 0, "", "",aFil[1],aFil[2]})
         Else
            PesqSaida(pQtd,pRet)
         Endif
      //ElseIf dbSeek("01"+SZC->ZC_CODINC+"01")
      //   If B2_QATU > 0
      //      AAdd( vInd , { SZC->ZC_CODINC, &(pRet), pQtd, 0, 0, "", ""} )
      //      aFil[1] := .T.
      //   Else
      //      PesqSaida(pQtd,pRet)
      //   Endif
      ElseIf pOk .And. !Empty(SZC->ZC_PREFIXO)
         dbSelectArea("SB1")
         dbSetOrder(1)
         If dbSeek(XFILIAL("SB1")+SZC->ZC_CODIND)
            aFil[1] := .T.                                               
            AAdd( vInd , { SZC->ZC_CODIND, &(pRet), pQtd, 0, 0, "", "",aFil[1],aFil[2]})
         Else
            aFil[2] := .T.
            AAdd( vCor , { SZC->ZC_CODINC, &(pRet), pQtd, 0, 0, "", "",aFil[1],aFil[2]})
         Endif
      Else
         aFil[2] := .T.                                               
         AAdd( vCor , { SZC->ZC_CODINC, &(pRet), pQtd, 0, 0, "", "",aFil[1],aFil[2]} )
      Endif
   Else
      aFil[2] := .T.                                     
      AAdd( vCor , { pCod, &(pRet), pQtd, 0, 0, "", "",aFil[1],aFil[2]} )
   Endif
Return
Static Function PesqSaida(pQtd,pRet)
   Local dDtCor := Ctod("  /  /  "), dDtInd := Ctod("  /  /  "), cCodInd := Space(Len(SB1->B1_COD))

   dbSelectArea("SD2")
   dbSetOrder(6)
   /* Pesquisa a ultima saida do produto no corredor */
   dbSeek("03"+SZC->ZC_CODINC+"179",.T.)
   dbSkip(-1)
   If D2_FILIAL+D2_COD+D2_LOCAL == "03"+SZC->ZC_CODINC+"17"
      dDtCor := D2_EMISSAO
   Endif
   /* Pesquisa a ultima saida do produto no industria */
   dbSeek("01"+SZC->ZC_CODIND+"019",.T.)
   dbSkip(-1)
   If D2_FILIAL+D2_COD+D2_LOCAL == "01"+SZC->ZC_CODIND+"01"
      dDtInd  := D2_EMISSAO
      cCodInd := SZC->ZC_CODIND
   Endif
   /* Pesquisa a ultima saida do produto na industria com o codigo do corredor */
   //dbSeek("01"+SZC->ZC_CODINC+"019",.T.)
   //dbSkip(-1)
   //If D2_FILIAL+D2_COD+D2_LOCAL == "01"+SZC->ZC_CODINC+"01"
   //   dDtInd  := If( D2_EMISSAO > dDtInd , D2_EMISSAO, dDtInd)
   //   cCodInd := SZC->ZC_CODINC
   //Endif
   /* Verifica qual a ultima saida e grava o codigo */
   If dDtCor >= dDtInd                                             
      aFil[2] := .T.
      AAdd( vCor , { SZC->ZC_CODINC, &(pRet), pQtd, 0, 0, "", "",aFil[1],aFil[2] })
   Else
      aFil[1] := .T.
      AAdd( vInd , { cCodInd       , &(pRet), pQtd, 0, 0, "", "",aFil[1],aFil[2] })
   Endif
Return

User Function GrvPedEst(pCod,pFil,pLoc,pQtd,pSoma)
   dbSelectArea("SB2")
   dbSetOrder(1)
   If dbSeek(pFil+pCod+pLoc)
      RecLock("SB2",.F.)
      SB2->B2_QPEDVEN := SB2->B2_QPEDVEN + (pQtd * If( pSoma , 1, -1))
      MsUnLock()
   Endif
Return

User Function CalcPre(pPreco,pTxDol,pCdPg,pDesc)
   cAlias := Alias()
   cAcres := GetMv("MV_TABJUR")
   dbSelectArea("SE4")
   dbSetOrder(1)
   dbSeek(XFILIAL("SE4")+pCdPg)
   cTabela := SubStr(E4_FORMA,1,3)

   /*   Calcula valor do Acresc. Financ.  */
   nPos   := At( cTabela , cAcres ) + 3
   nTxAcr := If( ! Empty(cTabela) , Val(SubStr(cAcres,nPos,5)), 0) / 100

   nPreco := pPreco * pTxDol
   nPreco := nPreco + (nPreco * nTxAcr)
   nPreco := nPreco - (nPreco * pDesc)
   dbSelectArea(cAlias)
Return(nPreco)

User Function GravPLib(pGrv,pVet)
   Local lVet := (pVet <> Nil), cAlias := Alias(), cBusca := ""

   dbSelectArea("SC9")
   If pGrv
      RecLock("SC9",.T.)
      SC9->C9_FILIAL  := If( lVet , pVet[1], SC6->C6_FILIAL)
      SC9->C9_PEDIDO  := If( lVet , pVet[2], SC6->C6_NUM)
      SC9->C9_ITEM    := If( lVet , pVet[3], SC6->C6_ITEM)
      SC9->C9_CLIENTE := If( lVet , pVet[4], SC6->C6_CLI)
      SC9->C9_LOJA    := If( lVet , pVet[5], SC6->C6_LOJA)
      SC9->C9_PRODUTO := If( lVet , pVet[6], SC6->C6_PRODUTO)
      SC9->C9_QTDLIB  := If( lVet , pVet[7], SC6->C6_QTDVEN)
      SC9->C9_DATALIB := dDataBase
      SC9->C9_SEQUEN  := "01"
      SC9->C9_GRUPO   := SB1->B1_GRUPO
      SC9->C9_PRCVEN  := If( lVet , pVet[8], SC6->C6_PRCVEN)
      SC9->C9_BLCRED  := IF(U_PlmFun(25),"01",SC9->C9_BLCRED) //"01" //VERIFICAR BLOQUEI POR CREDITO. 
      SC9->C9_ORIPED  := IF(U_PlmFun(25),"02","01")
      SC9->C9_LOCAL   := If( lVet , pVet[9], SC6->C6_LOCAL)
      MsUnLock()
      IF ! U_PlmFun(25)
        dbSelectArea("SC5")
        SC5->C5_LIBEROK :="S"
        MsUnLock()         
      Endif  
      dbSelectArea("SC9")
   Else
      cBusca := If( lVet , pVet[2]+pVet[3]+"01"+pVet[6], SC6->C6_NUM+SC6->C6_ITEM+;
                "01"+SC6->C6_PRODUTO)
      dbSetOrder(1)
      //If dbSeek(XFILIAL("SB9")+cBusca) 
      If dbSeek(XFILIAL("SC9")+cBusca) // alterado 20/08/2002 sarkis
         RecLock("SC9",.F.)
         Delete
         MsUnLock()
      Endif
   Endif
   dbSelectArea(cAlias)
Return

User Function TesTimex(pTes)
   Local cAlias := Alias(), vRet := { pTes, " ", pTes, " "}, cEmp := XFILIAL("SF4")
   dbSelectArea(IIF(M->C5_TIPO$"DB","SA2","SA1"))
   dbSetOrder(1)
   dbSeek(xFilial()+M->C5_CLIENTE+M->C5_LOJAENT)
   If cNumEmp $ "0201,0203"
      cEmp := "01"
      dbSelectArea("SZT")
      dbSetOrder(1)
      If dbSeek(XFILIAL("SZT")+pTes)
         vRet[1] := ZT_TESIND
         vRet[3] := ZT_TESINC
      Else
         dbSetOrder(2)
         If dbSeek(XFILIAL("SZT")+pTes)
            vRet[1] := ZT_TESIND
            vRet[3] := ZT_TESINC
         Endif
      Endif
      dbSelectArea("SF4")
      dbSetOrder(1)
      dbSeek("03"+vRet[3])
      If M->C5_TIPO $ "DB"
         vRet[4] := IIF(M->C5_TIPOCLI!="X",If(SA2->A2_EST==cEstado, F4_CF,"6"+Subs(F4_CF,2,LEN(F4_CF)-1)),"7"+Subs(F4_CF,2,LEN(SF4->F4_CF)-1))
      Else
         vRet[4] := IIF(M->C5_TIPOCLI!="X",If(SA1->A1_EST==cEstado, F4_CF,"6"+Subs(F4_CF,2,LEN(F4_CF)-1)),"7"+Subs(F4_CF,2,LEN(SF4->F4_CF)-1))
      EndIf
   Endif
   dbSelectArea("SF4")
   dbSetOrder(1)
   dbSeek(cEmp+vRet[1])
   If M->C5_TIPO $ "DB"
      vRet[2] := IIF(M->C5_TIPOCLI!="X",If(SA2->A2_EST==cEstado, F4_CF,"6"+Subs(F4_CF,2,LEN(F4_CF)-1)),"7"+Subs(F4_CF,2,LEN(SF4->F4_CF)-1))
   Else
      vRet[2] := IIF(M->C5_TIPOCLI!="X",If(SA1->A1_EST==cEstado, F4_CF,"6"+Subs(F4_CF,2,LEN(F4_CF)-1)),"7"+Subs(F4_CF,2,LEN(SF4->F4_CF)-1))
   EndIf

   dbSelectArea(cAlias)
Return(vRet)

User Function VldNumPed()
   Local cFilProc, cAlias := Alias(), nInd := IndexOrd(), nRecno := Recno(), lRet := .T.
   If cNumEmp <> "0202"
      If Upper(SubStr(M->C5_NUM,1,1)) $ "PV" .And.;
         Upper(AllTrim(cUserName)) $ "PSILVA,ACARDOSO,RROCHA"
         Alert("Letra Inicial Invalida !")
         lRet := .F.
      ElseIf GetMv("MV_SEPPED") == "S" .And. M->C5_SEPPED == "S"
         cFilProc := If( cNumEmp == "0201" , "03", "01")
         dbSelectArea("SC5")
         dbSetOrder(1)
         If dbSeek(cFilProc+M->C5_NUM)
            Help(" ",1,"EXISPED")
            lRet := .F.
         Endif
         dbSelectArea(cAlias)
         dbSetOrder(nInd)
         dbGoTo(nRecno)
      Endif
   Endif
Return(lRet)

User Function OrdImpFam(pDig)
   Local cAlias := Alias(), cRet
   dbSelectArea("SX5")
   dbSetOrder(1)
   dbSeek(XFILIAL("SX5")+"Z4"+pDig)
   cRet := AllTrim(X5_DESCRI)
   dbSelectArea(cAlias)
Return(cRet)

User Function NumPedFil()
  Local cFilProc, cAlias := Alias(), nInd := IndexOrd(), nRecno := Recno(),lNumPed:="F"
   If SM0->M0_CODIGO+SM0->M0_CODFIL <> "0202"
      If GetMv("MV_SEPPED") == "S" .And. M->C5_SEPPED == "S" .AND.!U_PLMFUN(25)                            
         cFilProc := If( SM0->M0_CODIGO+SM0->M0_CODFIL == "0201" , "03", "01")
         dbSelectArea("SC5")
         dbSetOrder(1)
         If dbSeek(cFilProc+M->C5_NUM)
            Help(" ",1,"EXISPED")
            lNumPed:="T" 
         Endif
         dbSelectArea(cAlias)
         dbSetOrder(nInd)
         dbGoTo(nRecno)
      Endif
   Endif
Return(lNumPed)

*************************************************************************************************
User Function BuscaProd(pProd)
*************************************************************************************************
Local cCodNovo:=" " 
dbSelectArea("SB1")
dbSetOrder(01)
If dbSeek(XFILIAL("SB1")+pProd)        
      dbSelectArea("SZC")
      dbSetOrder(1)
      If dbSeek(XFILIAL("SZC")+pProd)
          if SB1->(DbSeek(xFilial("SB1")+SZC->ZC_CODIND)) 
             cCodNovo:=SZc->ZC_CODIND
          Endif  
        Else 
          cCodNovo:=pProd
      Endif 
  Else
    cCodNovo:=pProd    
Endif                  
Return(cCodNovo)
*************************************************************************************************
User Function CFOD4SQL(pVetor)
*************************************************************************************************
   Local cCFO := "", cAlias := Alias()

   //Busca Tabela de Relacionamento de CFO 
   //Tabela CF e monta String com CFO novo e antigo 
   dbSelectArea("SX5")
   dbSetOrder(1)

   For icfo:=1 To Len(pVetor)
      cCfo += "'" + pVetor[icfo] + "',"
      If dbSeek(XFILIAL("SX5")+"ZF"+pVetor[icfo])   
         cCfo += "'" + AllTrim(x5_DESCRI)+"',"
      Endif
   Next
   
   cCfo := SubStr(cCfo,1,Len(cCfo)-1)

   dbSelectArea(cAlias)
Return(cCFO)                  
*********************************************************************************************************************
USER Function fAceitaSaldo(pCliente,pLoja,pPedido)
*********************************************************************************************************************
Local  lSaldoPed:=.F.
Local cSaldoPed:="N",cNota:=Space(06)

  cSaldoPed:=Posicione("SA1",1,xFilial("SA1")+pCLIENTE+pLOJA,"A1_SALDPED")
  cSaldoPed:=if(Empty(cSaldoPed),"N",cSaldoPed)
  cNota    :=Posicione("SD2",8,xFilial("SD2")+pPedido       ,"D2_DOC")
  
  if cSaldoPed = "N"  .and. !Empty(cNota)
      lSaldoPed:=.F.
    Else 
      lSaldoPed:=.T.
  Endif              

Return(lSaldoPed)   
***********************************************************************************************************************************
User Function fReserva(pFilial,pCod,pLocal,pData)
***********************************************************************************************************************************
Local cAlias := Alias(), nInd := IndexOrd(), nRecno := Recno()
Local Soma:=0  
Local cQuery :=""
cQuery := "SELECT SUM(C9_QTDLIB)QTD FROM SC9020 "
cQuery += " WHERE D_E_L_E_T_  = '' AND "
cQuery += " C9_PRODUTO  = '"+pCod  +"' AND "
cQuery += " C9_LOCAL    = '"+pLocal+"' AND "
cQuery += " C9_BLEST    = '' AND " 
cQuery += " C9_BLCRED   = '' AND "
cQuery += " C9_NFISCAL  = '' AND "
cQuery += " C9_DATALIB  <= '"+DTOS(pData) +"' AND "
cQuery += " C9_FILIAL   = '"+pFilial+"'"
TCQUERY cQuery NEW ALIAS RSV
Soma:=RSV->Qtd
RSV->(DbCloseArea())

cQuery := "SELECT SUM(C0_QUANT)QTD FROM SC0020 "
cQuery += " WHERE D_E_L_E_T_  <> '*' AND "
cQuery += " C0_PRODUTO  = '"+pCod+"' AND "  
cQuery += " C0_VALIDA  >= '"+DTOS(pData) +"' AND "
cQuery += " C0_LOCAL    = '"+pLocal+"' AND "
cQuery += " C0_FILIAL   = '"+pFilial+"' "
TCQUERY cQuery NEW ALIAS RSV
Soma:= SOMA + RSV->Qtd
RSV->(DbCloseArea())

DbSelectArea("SB2")
DbSetOrder(01)
if DbSeek(pFilial+pCod+pLocal)
  RecLock("SB2",.F. )
   Sb2->B2_Reserva :=Soma
  MsUnLock() 
Endif 

dbSelectArea(cAlias)
dbSetOrder(nInd)
dbGoTo(nRecno)

Return 
********************************************************************************************************************
User Function fFormaPgto(pForma)                                                                               
********************************************************************************************************************
Local cForma:=pForma

if  Alltrim(pForma)="2" 
    cForma:="P00" 
 Elseif Alltrim(pForma)="3"
    cForma:="P30" 
 Elseif Alltrim(pForma)="4"
    cForma:="P45" 
 Elseif Alltrim(pForma)="5"
    cForma:="P60"         
 Elseif Alltrim(pForma)="6"
    cForma:="P75"           
 Elseif Alltrim(pForma)="7"
    cForma:="P90"  
 Elseif Alltrim(pForma)="CV"
    cForma:="105"    
 Elseif Alltrim(pForma)="CXX"
    cForma:="120"     
Endif 

Return(cForma)
********************************************************************************************************************
User Function VldCpoSx3(pCampo)                                                                               
********************************************************************************************************************
Local lResp:=.T.
Local cAlias,cOrdem,cRecno
calias:=alias()
cOrdem:=dbSetOrder()
crecno:=recno()      
DbSelectArea("SX3")
DbSetOrder(02)
If !DbSeek(pCampo)
  lResp:=.F.
Endif 
dbSelectArea(calias)
dbSetOrder(cOrdem)
dbGoto(crecno)
Return(lResp)    
********************************************************************************************************************
User Function fVer_Acesso(Par01,Par02,Par03,Par04,Par05)       
********************************************************************************************************************
Local lResp:=.T.
Local cCondicao
Local _cAlias :=Alias()
//DBUSEAREA(.T.,, "SZX.DTC","SZX", .T., .F. )
Use Szx Index Acesso Alias "Acesso" New
//Reindex on Zx_Usuario+Zx_Procedu To Acesso
DbSelectArea("Acesso")
DbSetOrder(01)
If DbSeek(cUserName+Upper(Procname(1)))
   cCondicao:=Zx_Condica
   If !Empty(Par01)
      cCondicao:=StrTran(cCondicao,"PAR01",Par01)
     ElseIf !Empty(Par02)
       cCondicao:=StrTran(cCondicao,"PAR02",Par02)
     ElseIf !Empty(Par03)
       cCondicao:=StrTran(cCondicao,"PAR03",Par03)
     ElseIf !Empty(Par04)
       cCondicao:=StrTran(cCondicao,"PAR04",Par04)
     ElseIf !Empty(Par05)
       cCondicao:=StrTran(cCondicao,"PAR05",Par05)
   Endif    
   lResp:=&(cCondicao) 
Endif       
DbSelectArea("Acesso")
Close
dbSelectArea(_cAlias)
Return(lResp) 
********************************************************************************************************************
User Function fGera_SDA(pFilial,pProd,pQtdOri,pQuant,pData,pLocal,pDoc,pSerie,pCli,pLoja,pTpNf,pOriDados,pNumSeq,pExclui)
********************************************************************************************************************
Local _cAlias :=Alias()
DbSelectArea("SDA")
DbSetOrder(01)
      If !pExclui
          RecLock("SDA",.T.)
             Sda->Da_Filial  :=pFilial
             Sda->Da_Produto :=pProd
             Sda->Da_QtdOri  :=pQtdOri
             Sda->Da_Saldo   :=pQuant
             Sda->Da_Data    :=pData
//           Sda->Da_LoteCtl
             Sda->Da_Local   :=pLocal
             Sda->Da_Doc     :=pDoc
             Sda->Da_Serie   :=pSerie
             Sda->Da_CliFor  :=pCli
             Sda->Da_Loja    :=pLoja
             Sda->Da_TipoNF  :=pTpNf
             Sda->Da_Origem  :=pOriDados
             Sda->Da_NumSeq  :=pNumSeq
//           Sda->Da_Empenho
//           Sda->Da_QtSegum
//           Sda->Da_QtdOri2
//           Sda->Da_Emp2
//           Sda->Da_RegWMS         
//           Sda->Da_Kit
//           Sda->Da_DtMov
           Sda->(MsUnLock())
        ElseIf pExclui .and. Sda->(DbSeek(pFilial+pProd+pLocal+pNumSeq+pDoc+pSerie+pCli+pLoja))
           RecLock("SDA",.f.)
             Delete
           Sda->(MsUnLock()) 
      Endif 

dbSelectArea(_cAlias)
Return
********************************************************************************************************************
User Function fBx_SBF(pProduto,pLocal,pQuant,pDoc,pSerie,pCliFor,pLoja,pTipoNf,pNumSeq,pItem)
********************************************************************************************************************
Local aVet:={}
Local _cAlias :=Alias()
Local i 
   aVet:=u_fEndQtd(pProduto,pLocal,"",pQuant,"N")
   For i:=1 To Len(aVet)                                                                            
      u_GeraSDB(pProduto,pLocal,aVet[i,2],pDoc,pSerie,pCliFor,pLoja,pTipoNF,aVet[i,3],pNumSeq,pItem,"999","100","999") 
      If SubStr(aVet[i,2],1,3) <> "SEM"
         IF !u_fAtuSBF(pProduto,pLocal,aVet[i,2],aVet[i,3]*-1)
            //Msgbox("Endereco nao encontrado para este produto - "+pProduto,pLocal+" - "+aVet[i,2])
            u_fGera_SDA(xFilial("SD1"),pProduto,aVet[i,3],aVet[i,3],dDataBase,pLocal,pDoc,pSerie,pCliFor,pLoja,pTipoNf,"SBE",pNumSeq,.f.)
         Endif 
      EndIf   
   Next i
dbSelectArea(_cAlias)   
Return
*********************************************************************************************************************
User Function GeraSDB(pProduto,pLocal,pEndereco,pDoc,pSerie,pCliFor,pLoja,pTipoNF,pQuant,pNumSeq,pItem,pTM,pOrigem,pServ) 
*********************************************************************************************************************
Local cItem            
Local _cAlias :=Alias()
 RecLock("SDB",.T.)
     Sdb->Db_Filial  :=xFilial("SDB")
     Sdb->Db_Item    :=pItem
     Sdb->Db_Produto :=pProduto
     Sdb->Db_Local   :=pLocal
     Sdb->Db_Localiz :=pEndereco
     Sdb->Db_Doc     :=pDoc
     Sdb->Db_Serie   :=pSerie
     Sdb->Db_CliFor  :=pClifor
     Sdb->Db_Loja    :=pLoja
     Sdb->Db_TipoNf  :=pTipoNF
     Sdb->Db_Tm      :=pTM     //"999"
     Sdb->Db_Origem  :=pOrigem //"100"
     Sdb->Db_Quant   :=pQuant
     Sdb->Db_Data    :=dDataBase
     Sdb->Db_NumSeq  :=pNumSeq
     Sdb->Db_Tipo    :="M"
     Sdb->Db_Servic  :=pServ //"999"
     Sdb->Db_Ativid  :="ZZZ"
     Sdb->Db_HrIni   :=Time()
     Sdb->Db_AtuEst  :="S"
     Sdb->Db_Status  :="M"
     Sdb->Db_OrdAtiv :="ZZ" 
  // Sda->Da_IdOpera :=
  //   Sdb->Db_Kit     :=cKit
     Sdb->Db_DtMov   :=dDataBase
 SDB->(MsUnlock())   
 dbSelectArea(_cAlias)
Return 
********************************************************************************************************************
User Function fEx_Bx_SBF(pProduto,pLocal,pQuant,pDoc,pSerie,pCliFor,pLoja,pTipoNf,pNumSeq,pItem)
********************************************************************************************************************
Local aVet:={}
Local _cAlias :=Alias()
Local i 
   DbSelectArea("SDB")   
   DbSetOrder(01)
   DbSeek(xFilial("SDB")+pProduto+pLocal+pNumSeq+pDoc+pSerie+pCliFor+pLoja+pItem)
   While !Eof().and. xFilial("SDB")+pProduto+pLocal+pNumSeq+pDoc+pSerie+pCliFor+pLoja+pItem =;
            Sdb->Db_Filial+Sdb->Db_Produto+Sdb->Db_Local+Sdb->Db_NumSeq+Sdb->Db_Doc+Sdb->Db_Serie+Sdb->Db_CliFor+Sdb->Db_Loja+Sdb->Db_Item
         If Sdb->Db_Origem  <> "100"
            DbSelectArea("SDB")   
            DbSkip() 
            Loop
         Endif   
         If SubStr(Sdb->Db_Localiz,1,3) <> "SEM"
            IF SBF_Exist(pProduto,pLocal,Sdb->Db_Localiz,"",pQuant)
              u_fGera_SDA(xFilial("SD1"),pProduto,pQuant,pQuant,dDataBase,pLocal,pDoc,pSerie,pCliFor,pLoja,pTipoNf,"SBE",pNumSeq,.T.)
            Endif 
         EndIf 
         DbSelectArea("SDB")   
         RecLock("SDB",.F.)
          Delete
         Sdb->(MsUnLock())
     DbSkip() 
   End 
dbSelectArea(_cAlias)   
Return
*********************************************************************************************************************
Static Function SBF_Exist(pProduto,pLocal,pLocaliz,pKit,pQuant)
*********************************************************************************************************************
Local lResp:=.F.
  DbSelectArea("SBF")
  DbSetOrder(01)
  If !DbSeek(xFilial("SBF")+pLocal+pLocaliz+pProduto)
       RecLock("SBF",.t.)
        Sbf->Bf_Filial  :=xFilial("SBF")
        Sbf->Bf_Produto :=pProduto
        Sbf->Bf_Local   :=pLocal
        Sbf->Bf_Prior   :="ZZZ" 
        Sbf->Bf_Localiz :=pLocaliz
        Sbf->Bf_Quant   :=pQuant
        Sbf->Bf_Kit     :=pKit
        Sbf->Bf_DtMov   :=dDataBase
     Else                
       RecLock("SBF",.F.)
        Sbf->Bf_Quant   +=pQuant   
        Sbf->Bf_DtMov   :=dDataBase
        lResp:=.F.
  Endif 
  Sbf->(MsUnlock())
Return(lResp) 
*********************************************************************************************************************
User Function fExl_SDB(pProduto,pLocal,pEndereco,pDoc,pSerie,pCliFor,pLoja,pTipoNF,pNumSeq,pItem,pTM,pOrigem) 
*********************************************************************************************************************
Local _sAlias
_sAlias := Alias()
cQuery  := "DELETE FROM  " + RetSqlName("SDB")
cQuery  += " Where D_E_L_E_T_ <>'*' AND "  
cQuery  += " DB_FILIAL  = '"+xFilial("SDB")+"' AND "  
cQuery  += " DB_PRODUTO = '"+pProduto+"' AND "  
cQuery  += " DB_LOCAL   = '"+pLocal+"' AND "   
cQuery  += " DB_LOCALIZ = '"+pEndereco+"' AND "   
cQuery  += " DB_DOC     = '"+pDoc+"' AND "   
cQuery  += " DB_SERIE   = '"+pSerie+"' AND "   
cQuery  += " DB_CLIFOR  = '"+pCliFor+"' AND "  
cQuery  += " DB_LOJA    = '"+pLoja+"' AND "  
cQuery  += " DB_TIPONF  = '"+pTipoNF+"' AND "   
cQuery  += " DB_NUMSEQ  = '"+pNumSeq+"' AND "  
cQuery  += " DB_ITEM    = '"+pItem+"' AND "   
cQuery  += " DB_TM      = '"+pTM+"' AND "   
cQuery  += " DB_ORIGEM  = '"+pOrigem+"' "   
TCSQLExec(cQuery)
dbSelectArea(_sAlias)
Return 
*********************************************************************************************************************
User Function fUsa_End(pProduto) 
*********************************************************************************************************************
Local lResp:=.f. 
If Posicione("SB1",1,xFilial("SB1")+pProduto,"B1_LOCALIZ") = "S"
  lResp:=.T. 
Endif 
Return(lResp) 
*********************************************************************************************************************
User Function fBlqComp(pProduto,pData) 
*********************************************************************************************************************
Local lResp:=.T. 
Local _sAlias,cTipo
_sAlias := Alias()   
cTipo:=Posicione("SB1",1,xFilial("SB1")+pProduto,"B1_TIPO")
If cTipo == "MN" 
     DbSelectArea("SG1")
     DbSetOrder(02)
     DbSeek(xFilial("SG1")+pProduto)
	 While SG1->(!Eof()).and. xFilial("SG1")+pProduto == Sg1->G1_Filial+Sg1->G1_Comp
	    If pData < Sg1->G1_Ini .OR. pData > SG1->G1_Fim 
	       lResp:=.F.    
	        Msgbox("Produto bloqueado na estrutura da Engenharia!Item: "+Sg1->G1_Cod)
	       Exit
	    Endif  
        DbSelectArea("SG1")	    
        DbSkip()  
	 End
Endif 
dbSelectArea(_sAlias)
Return(lResp) 

User Function MyMata415()
Local aCabec := {}
Local aItens := {}
Local aLinha := {}
Local nX     := 0
Local nY     := 0
Local cDoc   := ""
Local lOk    := .T.
PRIVATE lMsErroAuto := .F.
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//| Abertura do ambiente                                                 |
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
//ConOut(Repl("-",80))
//ConOut(PadC("Teste de Inclusao de 10 orcamentos de venda  com 30 itens cada",80))
PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "FAT" TABLES "SC5","SC6","SA1","SA2","SB1","SB2","SF4","SCJ","SCK","SCL"
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//| Verificacao do ambiente para teste                           |
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
dbSelectArea("SB1")
dbSetOrder(1)
If !SB1->(MsSeek(xFilial("SB1")+"PA001"))
    lOk := .F.
    ConOut("Cadastrar produto: PA001")
EndIf
dbSelectArea("SF4")
dbSetOrder(1)
If !SF4->(MsSeek(xFilial("SF4")+"501"))
    lOk := .F.
    ConOut("Cadastrar TES: 501")
EndIf
dbSelectArea("SE4")
dbSetOrder(1)
If !SE4->(MsSeek(xFilial("SE4")+"001"))
    lOk := .F.
    ConOut("Cadastrar condicao de pagamento: 001")
EndIf
If !SB1->(MsSeek(xFilial("SB1")+"PA002"))
    lOk := .F.
    ConOut("Cadastrar produto: PA002")
EndIf
dbSelectArea("SA1")
dbSetOrder(1)
If !SA1->(MsSeek(xFilial("SA1")+"CL000101"))
    lOk := .F.
    ConOut("Cadastrar cliente: CL000101")
EndIf
If lOk
    ConOut("Inicio: "+Time())
    For nY := 1 To 1
        cDoc := GetSxeNum("SCJ","CJ_NUM")
        RollBAckSx8()
        aCabec := {}
        aItens := {}
        aadd(aCabec,{"CJ_NUM"   ,cDoc,Nil})
        aadd(aCabec,{"CJ_CLIENTE",SA1->A1_COD,Nil})
        aadd(aCabec,{"CJ_LOJACLI",SA1->A1_LOJA,Nil})
        aadd(aCabec,{"CJ_LOJAENT",SA1->A1_LOJA,Nil})
        aadd(aCabec,{"CJ_CONDPAG",SE4->E4_CODIGO,Nil})
        For nX := 1 To 1
            aLinha := {}
            aadd(aLinha,{"CK_ITEM",StrZero(nX,2),Nil})
            aadd(aLinha,{"CK_PRODUTO",SB1->B1_COD,Nil})
            aadd(aLinha,{"CK_QTDVEN",1,Nil})
            aadd(aLinha,{"CK_PRCVEN",100,Nil})
            aadd(aLinha,{"CK_PRUNIT",100,Nil})           
            aadd(aLinha,{"CK_VALOR",100,Nil})
            aadd(aLinha,{"CK_TES","501",Nil})
            aadd(aItens,aLinha)
        Next nX
        //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
        //| Teste de Inclusao                                            |
        //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
        MATA415(aCabec,aItens,3)
        If !lMsErroAuto
            ConOut("Incluido com sucesso! "+cDoc)   
        Else
            ConOut("Erro na inclusao!")
        EndIf
    Next nY
    ConOut("Fim  : "+Time())
    //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
    //| Teste de alteracao                                           |
    //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
    aCabec := {}
    aItens := {}
    aadd(aCabec,{"CJ_NUM",cDoc,Nil})
    aLinha := {}
    aadd(aLinha,{"LINPOS","CK_ITEM","01"})
    aadd(aLinha,{"AUTDELETA","S",Nil})
    aadd(aItens,aLinha)
    For nX := 2 To 2
        aLinha := {}
        aadd(aLinha,{"CK_ITEM",StrZero(nX,2),Nil})
        aadd(aLinha,{"CK_PRODUTO",SB1->B1_COD,Nil})
        aadd(aLinha,{"CK_QTDVEN",2,Nil})
        aadd(aLinha,{"CK_PRCVEN",100,Nil})
        aadd(aLinha,{"CK_PRUNIT",100,Nil})           
        aadd(aLinha,{"CK_VALOR",200,Nil})
        aadd(aLinha,{"CK_TES","501",Nil})
        aadd(aItens,aLinha)
    Next nX   
    ConOut(PadC("Teste de alteracao",80))
    ConOut("Inicio: "+Time())
    MATA415(aCabec,aItens,4)
    ConOut("Fim  : "+Time())
    ConOut(Repl("-",80))
    //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
    //| Teste de Exclusao                                            |
    //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
    ConOut(PadC("Teste de exclusao",80))
    ConOut("Inicio: "+Time())
    MATA415(aCabec,aItens,5)
    If !lMsErroAuto
        ConOut("Exclusao com sucesso! "+cDoc)   
    Else
        ConOut("Erro na exclusao!")
    EndIf
    ConOut("Fim  : "+Time())
    ConOut(Repl("-",80))
EndIf
RESET ENVIRONMENT
Return