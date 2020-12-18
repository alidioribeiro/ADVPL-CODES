#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 08/03/02
 #IFNDEF WINDOWS
    #DEFINE PSAY SAY
 #ENDIF        

User Function PlCust()        // incluido pelo assistente de conversao do AP5 IDE em 08/03/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,ARETURN,NLASTKEY")
SetPrvt("LI,CSTRING,CPERG,WNREL,ADRIVER,CDESP")
SetPrvt("AITENS,MPAG,CPARAM,LSEGURO,ADESPESAS,ADESPAUX")
SetPrvt("ADESCDESP,ACODREDD,ACODREDA,NDESPREA,NDESPUSS,CPESO")
SetPrvt("_SALIAS,CHAWB,NITEM,CDESCDESP,I,AHEADER")
SetPrvt("ACOLS,LPRIMEIRA,LACHOU,NDESPADU,CCLASS,CONT")

 #IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 08/03/02 ==>     #DEFINE PSAY SAY
 #ENDIF        
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ PLAEIC ³ Autor ³ Wagner da Gama Correa ³ Data ³ 10.10.2000 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Planilha de Custo                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico - NISSIN                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
 Titulo   := " Planilha de Custo "
 cDesc1   := OemToAnsi("Planilha de Custo de Importacao")
 cDesc2   := OemToAnsi("")
 cDesc3   := OemToAnsi("")                     
 aReturn  := {"Zebrado",1,"Administracao",1,2,1,"",1}
 nLastKey := 0
 li       := 60

 cString  := "SW6"
 cPerg    := "PLCUST"
 wnrel    := "PLCUST"
 aDriver  := ReadDriver()

 pergunte("PLCUST",.T.)
 wnrel:=SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,)

 cDesp := Space(10)

 aItens := {}
 If nLastKey == 27
    Set Filter To
    Return
 Endif
 SetDefault(aReturn,cString)
 If nLastKey == 27
    Set Filter To
    Return
 Endif

 #IFDEF WINDOWS
    RptStatus({|| Corpo_PlCust() })// Substituido pelo assistente de conversao do AP5 IDE em 08/03/02 ==>     RptStatus({|| Execute(Corpo) })
    Return
// Substituido pelo assistente de conversao do AP5 IDE em 08/03/02 ==>     Function Corpo
Static Function Corpo_PlCust()
 #ENDIF
 
 mPag   :=  0
                                // !                    !
 cParam := mv_par01             // ! Numero do Processo !
                                // !                    !

 lSeguro := .F.

 DbSelectArea("SF1")
 DbSetOrder(1)

 DbSelectArea("SD1")
 DbSetOrder(1)

 SA2->( DbSetOrder(1) )
 SY2->( DbSetOrder(1) )
 SW2->( DbSetOrder(1) )
 SW7->( DbSetOrder(1) )
 SW8->( DbSetOrder(1) )
 SW6->( DbSetOrder(1) )
 SB1->( DbSetOrder(1) )
 SW1->( DbSetOrder(2) )

 aDespesas := Array(7,1)
 aFill(aDespesas, 0)

 aDespAux  := {}
 aDescDesp := {}

 aCodRedD   := Array(7,1)
 aFill( aCodRedD, Space(4) )
 aCodRedA   := {}

 nDespREA := 0
 nDespUSS := 0

 SW6->(DbSeek(xFilial()+cParam,.T.))

 While !SW6->(Eof()) .and. SW6->W6_HAWB == cParam
    If li >= 60
       fImpCabec()
    EndIf

    @ li,000 PSAY "| Conhecimento: " + SW6->W6_HOUSE
    @ li,050 PSAY "Dt. Conhecimento: " + DtoC(SW6->W6_DT_ETD)
    @ li,100 PSAY "Tx.DI: " + Transform(SW6->W6_TX_US_D, "@R 99.999999")
    @ li,131 PSAY "|"
    IncLin()

    SW7->( DbSeek(xFilial("SW7") + cParam,.T.) )
    SW2->( DbSeek(xFIlial("SW2") + SW7->W7_PO_NUM) )
    SY2->( DbSeek(xFilial("SYT") + SW2->W2_IMPORT) )

    DbSelectArea("SYQ")
    DbSetOrder(1)
    DbSeek(xFilial()+SW6->W6_VIA_TRA)

    @ li,000 PSAY "| Importador: " + Left(AllTrim(SYT->YT_NOME),30)
    @ li,050 PSAY "Via: "          + Left(SYQ->YQ_DESCR,25)
    @ li,080 PSAY "Origem: "       + SW6->W6_ORIGEM
    @ li,100 PSAY "Destino: "      + SW6->W6_DEST
    @ li,131 PSAY "|"
    IncLin()

    DbSelectArea("SA2")
    DbSeek(xFilial()+SW7->W7_FORN)

    DbSelectArea("SW8")
    DbSeek(xFilial()+cParam)

    DbSelectArea("SY6")
    DbSeek(xFilial()+SW2->W2_COND_PA)

    DbSelectArea("SYP")
    DbSeek(xFilial()+SY6->Y6_DESC_P)
    @ li,000 PSAY "| Fornecedor: " + Left(AllTrim(SA2->A2_NREDUZ),25)+"-"+AllTrim(SA2->A2_COD)
    @ li,050 PSAY "Invoice: "      + SW8->W8_INVOICE
    @ li,080 PSAY "Cond. Pgto: "   + Left(SYP->YP_TEXTO,30)
    @ li,131 PSAY "|"
    IncLin()

    DbSelectArea("SD1")
    DbSeek(xFilial()+Left(SW6->W6_NF_ENT,6)+AllTrim(SW6->W6_SE_NF))

    @ li,000 PSAY "| Vlr. FOB: " + SW6->W6_FOBMOE + Transform(SW6->W6_FOB_TOT+SW6->W6_INLAND+SW6->W6_PACKING, "@R 999,999,999.999999")
    @ li,050 PSAY "Tx. FOB: "    + Transform(SW6->W6_TX_FOB,"@R 999.999999")
    @ li,100 PSAY "C.F.O.: "     + SD1->D1_CF
    @ li,131 PSAY "|"
    IncLin()

    @ li,000 PSAY "| Vlr. Frete: "  + SW6->W6_FREMOED+ Transform(SW6->W6_VL_FRET,"@R 9,999,999.9999")
    @ li,050 PSAY "Tx.Frete: "      + Transform(SW6->W6_TX_FRET,"@R 999.999999")
    @ li,100 PSAY "Tipo de Frete: " + IIF(SW2->W2_FREPPCC=="CC","COLLECT","PRE PAID")
    @ li,131 PSAY "|"
    IncLin()

    cPeso := 0
    _sAlias := Select()
    DbSelectArea("SW7")
    While !Eof() .and. W7_HAWB == cParam
       SB1->(DbSeek(xFilial("SB1")+SW7->W7_COD_I))
       cPeso := cPeso + (SB1->B1_PESO*W7_QTDE)
       DbSkip()
    End
    DbSelectArea(_sAlias)

    @ li,000 PSAY "| Vlr. Seguro: " + SW6->W6_SEGMOED + " "+ Transform( SW6->W6_VL_USSE,"@R 9,999,999,999.999999")
    @ li,050 PSAY "Tx. Seguro: " + IIF( Empty(SW6->W6_VL_USSE), Transform(0,"@R 999.999999"),Transform(SW6->W6_TX_US_D,"@R 999.999999"))
    @ li,100 PSAY "Peso Liquido: "+Transform(cPeso, "@R 9,999,999.9999")
    @ li,131 PSAY "|"
    IncLin()

    @ li,000 PSAY "+"+Replicate("-",130)+"+"
    IncLin()

    // ! --------------------------- !
    // ! Carrega despesas para vetor !
    // ! --------------------------- !

    DbSelectArea("SWD")
    DbSetOrder(1)
    DbSeek(xFilial()+cParam,.T.)
    cHawb := cParam

    aDespesas[2] := SW6->W6_INLAND * SW6->W6_TX_FOB
    aDespesas[3] := SW6->W6_PACKING * SW6->W6_TX_FOB

    While !Eof() .and. SWD->WD_HAWB ==cHawb
       Do Case
          Case WD_DESPESA == "101"
               aDespesas[1]  := aDespesas[1]  + WD_VALOR_R
               aCodRedD[1] := "78"
          Case WD_DESPESA == "102"
               aDespesas[4]  := aDespesas[4]  + WD_VALOR_R
               aCodRedD[4] := "616"
          Case WD_DESPESA == "103"
               lSeguro := .T.
               aDespesas[6]  := aDespesas[6]  + WD_VALOR_R
               aCodRedD[6] := "22"
          Otherwise
               nItem := aScan( aDespAux, WD_DESPESA)

               If nItem == 0
                  DbSelectArea("SYB")
                  DbSetOrder(1)
                  DbSeek(xFilial()+SWD->WD_DESPESA)
                  cDescDesp := YB_DESCR
                  DbSelectArea("SWD")

                  aAdd( aDespAux, 0)
                  aAdd( aDescDesp, cDescDesp)

                  aDespAux[Len(aDespAux)] := aDespAux[Len(aDespAux)] + WD_VALOR_R
               Else
                  aDespAux[nItem] := aDespAux[nItem] + WD_VALOR_R
               EndIf
       EndCase
       DbSkip()
    End
    For i:=1 To Len(aDespAux)
       aAdd( aCodRedA, "22")
    Next

    aHeader := {}
    AADD(aHeader, {"Conta" , "W6_CONTA1", "@R 999.99.99999", 10, 0, ".T.", "", "C", "SW6" } )
    AADD(aHeader, {"Red."  , "W6_CR1"   , "@!"             ,  4, 0, ".T.", "", "C", "SW6" } )
    AADD(aHeader, {"Descr.", "YB_DESCR" , "@!"             , 40, 0, ".T.", "", "C", "SYB" } )

    aCols := Array(1,4)
    aCols[1,1] := Space(10)
    aCols[1,2] := Space(4)
    aCols[1,3] := Space(40)
    aCols[1,4] := .F.

    lPrimeira := .T.
    For i:=1 To Len(aDespesas)+Len(aDespAux)
       _sAlias := Select()
       DbSelectArea("SI1")
       DbSetOrder(3)
       lAchou := DbSeek(xFilial()+AllTrim(IIF( i<=Len(aDespesas) ,aCodRedD[i], aCodRedA[i-Len(aDespesas)] )))

       DbSelectArea(_sAlias)
       If lAchou
          If lPrimeira
             aCols[1,1] := SI1->I1_CODIGO
             aCols[1,2] := IIF(i<=Len(aDespesas),aCodRedD[i], aCodRedA[i-Len(aDespesas)])
             aCols[1,3] := Space(40)
             aCols[1,4] := .F.
             lPrimeira := .F.
           Else
             aAdd( aCols, {SI1->I1_CODIGO, IIF(i<=Len(aDespesas),aCodRedD[i], aCodRedA[i-Len(aDespesas)]), Space(40), .F.} )
             aCols[Len(aCols), 3 ] := IIF( i<= Len(aDespesas), Space(40), aDescDesp[i-Len(aDespesas)])
          EndIf
        Else
          aAdd( aCols, { Space(10), Space(4), Space(40), .F.} )
       EndIf
    Next

    aCols[1,3] := "FOB"
    aCols[2,3] := "INLAND"
    aCols[3,3] := "PACKING"
    aCols[4,3] := "FRETE"
    aCols[5,3] := "C e F"
    aCols[6,3] := "SEGURO"
    aCols[7,3] := "C.I.F."

    @ 00,00 TO 210,250 DIALOG oDlgContas TITLE "Contas"
    @ 10,05 To 85,120 MULTILINE MODIFY DELETE
    @ 90,90 BMPBUTTON TYPE 1 ACTION Close(oDlgContas)
    ACTIVATE DIALOG oDlgContas CENTERED

    aDespesas[1] := aDespesas[1] - aDespesas[2] - aDespesas[3]

    aDespesas[5] := aDespesas[1] + aDespesas[2] + aDespesas[3] + aDespesas[4] 
    aDespesas[7] := aDespesas[1] + aDespesas[2] + aDespesas[3] + aDespesas[4] + aDespesas[6]

    For i:=1 To Len(aDespAux)
       nDespREA := nDespREA + aDespAux[i]
       nDespUSS := nDespUSS + (aDespAux[i]/SW6->W6_TX_US_D)
    Next

    nDespREA := nDespREA + aDespesas[7]
    nDespUSS := nDespUSS + (aDespesas[7]/SW6->W6_TX_US_D)

    @ li,000 PSAY "| No. DI: "+ Transform(SW6->W6_DI_NUM,"@R 99/9999999-9")
    @ li,050 PSAY "Dt. DI: "  + DTOC(SW6->W6_DT)
    @ li,100 PSAY "N.F.E.: "  + SW6->W6_NF_ENT
    @ li,131 PSAY "|"
    IncLin()
    
    @ li,000 PSAY "| Base Calculo R$: " + IIF( SD1->D1_CF $ "399/397", Transform(aDespesas[7],"@R 9,999,999,999.9999"),Transform(0,"@R 9,999,999,999.9999"))
    @ li,050 PSAY "ICMS: " + IIF( SD1->D1_CF $ "399/397", Transform(aDespesas[7]*0.17, "@R 9,999,999,999.9999"),Transform(0, "@R 9,999,999,999.9999"))
    @ li,100 PSAY "Dt. N.F.E.: " + DtoC(SW6->W6_DT_NF)
    @ li,131 PSAY "|"
    IncLin()

    nDespAdu := 0
    For i:=8 To Len(aDespesas)
        nDespAdu := nDespAdu + aDespesas[i]
    Next

    @ li,000 PSAY "| Desp. Aduaneiras: " + IIF( SD1->D1_CF $ "399/397", Transform(nDespAdu,"@R 9,999,999,999.9999"), Transform(0,"@R 9,999,999,999.9999"))
    @ li,050 PSAY "ICMS: "+ IIF(SD1->D1_CF $ "399/397", Transform(nDespAdu*0.17,"9,999,999,999.9999"), Transform(0,"9,999,999,999.9999"))
    @ li,100 PSAY "Dt. Entrada: " + DtoC(SW6->W6_DT_ENTR)
    @ li,131 PSAY "|"
    IncLin()
                        
    SW1->(DbSeek(xFilial("SW1")+SW2->W2_PO_NUM))

    @ li,000 PSAY "+----------------------------------------------------------------------------------------------------------------------------------+"; IncLin()
    @ li,000 PSAY "|                                                 CONTA DEBITO                                      |            MATERIAL          |"; IncLin()
    @ li,000 PSAY "+----------------------------------------------------------------------------------------------------------------------------------+"; IncLin()

    @ li,000 PSAY "| D 112.01.01003 | 18 | MATERIA PRIMA                                 |"
    If SW1->W1_CLASS == "1"
       @ li,081 PSAY Transform(nDespREA, "@R 9,999,999,999.9999")
    EndIf
    
    @ li,100 PSAY "|"
    @ li,131 PSAY "|"
    IncLin()
   
    If SW2->W2_PO_NUM == SW1->W1_PO_NUM
       cClass := IIF( SW1->W1_CLASS == "1", "INDUSTRIALIZACAO",;
                 IIF( SW1->W1_CLASS == "2", "SECUNDARIO",;
                 IIF( SW1->W1_CLASS == "3", "CONSUMO",;
                 IIF( SW1->W1_CLASS == "4", "ATIVO FIXO",;
                 IIF( SW1->W1_CLASS == "5", "REVENDA", "") ) ) ) )
    EndIf

    @ li,000 PSAY "+---------------------------------------------------------------------------------------------------|                              |"; IncLin()
    @ li,000 PSAY "| D "+Transform(Left(SW6->W6_CONTA1,10), "@R 999.99.99999")
    @ li,017 PSAY "| "+SW6->W6_CR1+" | " + SW6->W6_DESCRI1 + " "+"|        "+Transform(SW6->W6_VALINF1,"@R 9,999,999,999,999.99")+" |                              |"; IncLin()
    @ li,000 PSAY "+---------------------------------------------------------------------------------------------------|                              |"; IncLin()
    @ li,000 PSAY "| D "+Transform(Left(SW6->W6_CONTA2,10), "@R 999.99.99999")
    @ li,017 PSAY "| "+SW6->W6_CR2+" | " + SW6->W6_DESCRI2 + " "+"|        "+Transform(SW6->W6_VALINF2,"@R 9,999,999,999,999.99")+" |"
    @ li,103 PSAY Padc( Left(cClass,25), 27, " ")
    @ li,131 PSAY "|"; IncLin()
    @ li,000 PSAY "+---------------------------------------------------------------------------------------------------|                              |"; IncLin()
    @ li,000 PSAY "| D "+Transform(Left(SW6->W6_CONTA3,10), "@R 999.99.99999")
    @ li,017 PSAY "| "+SW6->W6_CR3+" | " + SW6->W6_DESCRI3 + " "+"|        "+Transform(SW6->W6_VALINF3,"@R 9,999,999,999,999.99")+" |                              |"; IncLin()
    @ li,000 PSAY "+---------------------------------------------------------------------------------------------------|                              |"; IncLin()
    @ li,000 PSAY "| D "+Transform(Left(SW6->W6_CONTA4,10), "@R 999.99.99999")
    @ li,017 PSAY "| "+SW6->W6_CR4+" | " + SW6->W6_DESCRI4 + " "+"|        "+Transform(SW6->W6_VALINF4,"@R 9,999,999,999,999.99")+" |                              |"; IncLin()

    @ li,000 PSAY "+----------------------------------------------------------------------------------------------------------------------------------+"; IncLin()

    @ li,000 PSAY "| CONTA CREDITO       | DESPESAS                                      |       CUSTO REAL EM R$      |     CUSTO TOTAL EM US$       |"; IncLin()    // linha 26
    @ li,000 PSAY "+----------------------------------------------------------------------------------------------------------------------------------+"; IncLin()

    @ li,000 PSAY "| C"
    @ li,004 PSAY Transf(aCols[1,1], "@R 999.99.99999")
    @ li,017 PSAY "|"+PadC(aCols[1,2],4)+"|"
    @ li,024 PSAY aCols[1,3]
    @ li,070 PSAY "|"
    @ li,081 PSAY Transform(aDespesas[1], "@R 9,999,999,999.9999")
    @ li,100 PSAY "|"
    @ li,112 PSAY Transform(aDespesas[1]/SW6->W6_TX_US_D, "@R 9,999,999,999.9999")
    @ li,131 PSAY "|"
    IncLin()

    @ li,000 PSAY "| C"
    @ li,004 PSAY Transf(aCols[2,1], "@R 999.99.99999")
    @ li,017 PSAY "|"+PadC(aCols[2,2],4)+"|"
    @ li,024 PSAY aCols[2,3]
    @ li,070 PSAY "|"
    @ li,081 PSAY Transform(aDespesas[2], "@R 9,999,999,999.9999")
    @ li,100 PSAY "|"
    @ li,112 PSAY Transform(aDespesas[2]/SW6->W6_TX_US_D, "@R 9,999,999,999.9999")
    @ li,131 PSAY "|"
    IncLin()

    @ li,000 PSAY "| C"
    @ li,004 PSAY Transf(aCols[3,1], "@R 999.99.99999")
    @ li,017 PSAY "|"+PadC(aCols[3,2],4)+"|"
    @ li,024 PSAY aCols[3,3]
    @ li,070 PSAY "|"
    @ li,081 PSAY Transform(aDespesas[3], "@R 9,999,999,999.9999")
    @ li,100 PSAY "|"
    @ li,112 PSAY Transform(aDespesas[3]/SW6->W6_TX_US_D, "@R 9,999,999,999.9999")
    @ li,131 PSAY "|"
    IncLin()

    @ li,000 PSAY "| C"
    @ li,004 PSAY Transf(aCols[4,1], "@R 999.99.99999")
    @ li,017 PSAY "|"+PadC(aCols[4,2],4)+"|"
    @ li,024 PSAY aCols[4,3]
    @ li,070 PSAY "|"
    @ li,081 PSAY Transform(aDespesas[4], "@R 9,999,999,999.9999")
    @ li,100 PSAY "|"
    @ li,112 PSAY Transform(aDespesas[4]/SW6->W6_TX_US_D, "@R 9,999,999,999.9999")
    @ li,131 PSAY "|"
    IncLin()

    @ li,000 PSAY "| C"
    @ li,004 PSAY Transf(aCols[5,1], "@R 999.99.99999")
    @ li,017 PSAY "|"+PadC(aCols[5,2],4)+"|"
    @ li,024 PSAY aCols[5,3]
    @ li,070 PSAY "|"
    @ li,081 PSAY Transform(aDespesas[5], "@R 9,999,999,999.9999")
    @ li,100 PSAY "|"
    @ li,112 PSAY Transform(aDespesas[5]/SW6->W6_TX_US_D, "@R 9,999,999,999.9999")
    @ li,131 PSAY "|"
    IncLin()

    @ li,000 PSAY "| C"
    @ li,004 PSAY Transf(aCols[6,1], "@R 999.99.99999")
    @ li,017 PSAY "|"+PadC(aCols[6,2],4)+"|"
    @ li,024 PSAY aCols[6,3]
    @ li,070 PSAY "|"
    @ li,081 PSAY Transform(aDespesas[6], "@R 9,999,999,999.9999")
    @ li,100 PSAY "|"
    @ li,112 PSAY Transform(aDespesas[6]/SW6->W6_TX_US_D, "@R 9,999,999,999.9999")
    @ li,131 PSAY "|"
    IncLin()

    @ li,000 PSAY "| C"
    @ li,004 PSAY Transf(aCols[7,1], "@R 999.99.99999")
    @ li,017 PSAY "|"+PadC(aCols[7,2],4)+"|"
    @ li,024 PSAY aCols[7,3]
    @ li,070 PSAY "|"
    If lSeguro
       @ li,081 PSAY Transform(aDespesas[7], "@R 9,999,999,999.9999")
     Else
       @ li,081 PSAY Transform(0, "@R 9,999,999,999.9999")
    EndIf
    @ li,100 PSAY "|"
    If lSeguro
       @ li,112 PSAY Transform(aDespesas[7]/SW6->W6_TX_US_D, "@R 9,999,999,999.9999")
     Else
       @ li,112 PSAY Transform(0, "@R 9,999,999,999.9999")
    EndIf
    @ li,131 PSAY "|"
    IncLin()

    For i:=1 to Len(aDespAux)
       @ li,000 PSAY "| C 112.01.11001 | 22 | "
       @ li,024 PSAY Left(aDescDesp[i],45)
       @ li,070 PSAY "|"
       @ li,081 PSAY Transform(aDespAux[i], "@R 9,999,999,999.9999")
       @ li,100 PSAY "|"
       @ li,112 PSAY Transform(aDespAux[i]/SW6->W6_TX_US_D, "@R 9,999,999,999.9999")
       @ li,131 PSAY "|"
       IncLin()

    Next

    @ li,000 PSAY "+----------------------------------------------------------------------------------------------------------------------------------+"; IncLin()
    @ li,000 PSAY "|                        VALORES TOTAIS                               |"
    @ li,079 PSAY Transform(nDespREA, "@R 999,999,999,999.9999")
    @ li,100 PSAY "|"
    @ li,110 PSAY Transform(nDespUSS, "@R 999,999,999,999.9999")
    @ li,131 PSAY "|"
    IncLin()

    DbSelectArea("SYP")
    DbSetOrder(1)
    DbSeek(xFilial()+SW6->W6_COMPLEM,.T.)
    @ li,000 PSAY "+----------------------------------------------------------------------------------------------------------------------------------+"; IncLin()
    cont := 0
    While !Eof() .and. SW6->W6_COMPLEM == YP_CHAVE
       If cont == 4
          Exit
       EndIf
       @ li,000 PSAY "|"
       @ li,002 PSAY YP_TEXTO
       @ li,131 PSAY "|"; IncLin()
       DbSkip()
       cont := cont + 1
    End

    @ li,000 PSAY "+----------------------------------------------------------------------------------------------------------------------------------+"; IncLin()

    SW6->(DbSkip())
 End

 Set Device To Screen
 If aReturn[5] == 1
    Set Printer To
    Commit
    OurSpool(wnrel)
 Endif

 MS_FLUSH()
 Return

// Substituido pelo assistente de conversao do AP5 IDE em 08/03/02 ==>  Function fImpCabec
Static Function fImpCabec()
    li   := 0
    mPag := mPag + 1

    @ li,000 PSAY  AvalImp(132); IncLin()
    @ li,000 PSAY "+----------------------------------------------------------------------------------------------------------------------------------+"; IncLin()
    @ li,000 PSAY "| "+PadR(AllTrim(SM0->M0_FILIAL),64)                              +                              PadL("Folha.: "+Str(mpag,8),64)+" |"; IncLin()
    @ li,000 PSAY "| SIGA/PLAEIC                                                                                                     Dt.Ref: "+ Dtoc(dDataBase)+" |"; IncLin()
    @ li,000 PSAY "|"+PadC("PLANILHA DE CUSTO",80)                                                                     +PadR("Processo: "+cParam,50)+"|"; IncLin()
    @ li,000 PSAY "| "+PadR("Hora: "+Time(),65," ")                                  +                        PadL("Emissao:"+Dtoc(Date()),63," ")+" |"; IncLin()
    @ li,000 PSAY "+----------------------------------------------------------------------------------------------------------------------------------+"; IncLin()
 //                000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111
 //                000000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233
 //                012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901

 Return

// Substituido pelo assistente de conversao do AP5 IDE em 08/03/02 ==>  Function IncLin
Static Function IncLin()
    li := li + 1
    If li >= 60
       fImpCabec()
    EndIf
 Return
