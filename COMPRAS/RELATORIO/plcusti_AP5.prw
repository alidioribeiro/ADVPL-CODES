#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 08/03/02
 #IFNDEF WINDOWS
    #DEFINE PSAY SAY
 #ENDIF        

User Function PlCusti()        // incluido pelo assistente de conversao do AP5 IDE em 08/03/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,ARETURN,NLASTKEY")
SetPrvt("LI,M_PAG,CSTRING,CPERG,WNREL,ADRIVER")
SetPrvt("CPARAM,CINVOICE,CCONHEC,CDI,CDESP,CDRIVER")
SetPrvt("NFRETE,NFOB,NTXFRETE,NTAXA,CABEC1,CABEC2")
SetPrvt("NOMEPROG,TAMANHO,ATOT,AITENS,NCINLAND,NCPACKING")
SetPrvt("NDESPESAS,_SALIAS,NPESOLIQ,NFOBTOT,I,AIMP")
SetPrvt("NII,NIPI,NICM,")

 #IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 08/03/02 ==>     #DEFINE PSAY SAY
 #ENDIF        
 /*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ PLAEIC ³ Autor ³ Wagner da Gama Correa ³ Data ³ 10.10.2000 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Planilha de Custo - Itens                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico - NISSIN                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
 /*/
 Titulo   := " Planilha de Custo "
 cDesc1   := OemToAnsi("Planilha de Custo de Importacao - Itens")
 cDesc2   := OemToAnsi("")
 cDesc3   := OemToAnsi("")                     
 aReturn  := {"Zebrado",1,"Administracao",2,2,1,"",1}
 nLastKey := 0
 li       := 60
 m_pag    := 1

 cString  := "SW6"
 cPerg    := "PLCUST"
 wnrel    := "PLCUSTI"
 aDriver  := ReadDriver()

 pergunte("PLCUST",.T.)
 cParam := mv_par01

 wnrel:=SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,)

 cInvoice := ""
 cConhec  := ""
 cDI      := ""

 cDesp := Space(10)

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
    RptStatus({|| Corpo_PlCusti() })// Substituido pelo assistente de conversao do AP5 IDE em 08/03/02 ==>     RptStatus({|| Execute(Corpo) })
    Return
    Static Function Corpo_PlCusti()
 #ENDIF

 cDriver := ReadDriver()

 SB1->(DbSetOrder(01))
 SW7->(DbSetOrder(01))
 SW8->(DbSetOrder(01))
 SWD->(DbSetOrder(01))

 SW6->(DbSetOrder(01))
 SW6->(DbSeek(xFilial()+cParam,.T.))

 SW8->(DbSeek(xFilial()+cParam))
 cInvoice := SW8->W8_INVOICE

 cConhec := SW6->W6_HOUSE
 cDI     := SW6->W6_DI_NUM
 nFrete  := SW6->W6_VL_FRET
 nFOB    := SW6->W6_TX_FOB
 nTXFrete:= SW6->W6_TX_FRET
 nTaxa   := SW6->W6_TX_US_D

 titulo   := " PLANILHA DE CUSTO POR ITEM / PROCESSO: "+cParam
 cabec1   := PadR("Invoice: " + cInvoice,25," ") + PadC("Conhecimento: "+cConhec,30," ")+PadR("No. D.I.: "+cDI,25," ")
 cabec2   := "COD. ITEM       DESCRICAO                                                QUANTIDADE        PESO LIQ.              FOB            FRETE        OUT.DESP.            TOTAL     PRECO MEDIO"
          //  123456789012345 12345678901234567890123456789012345678901234567890 999,999,999.9999 999,999,999.9999 999,999,999.9999 999,999,999.9999 999,999,999.9999 999,999,999.9999 99,999,999.9999
          //  00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111222222222222222222222
          //  00000000001111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000000111111111122222222223333333333444444444455555555556666666666777777777788888888889999999999000000000011111111112
          //  01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
 nomeprog := "PLCUSTI.PRW"
 tamanho  := "G"

 While !SW6->(Eof()) .and. cParam == SW6->W6_HAWB

    SW7->(DbSeek(xFilial()+SW6->W6_HAWB,.T.))

    aTot   := Array(7,1)
    aFill(aTot,0)
    aItens := {}

    nCInland := SW6->W6_INLAND  / SW6->W6_FOB_TOT
    nCPacking := SW6->W6_PACKING / SW6->W6_FOB_TOT

    nDespesas := 0
    While !SW7->(Eof()) .and. SW7->W7_HAWB == SW6->W6_HAWB
       _sAlias := Select()
       DbSelectArea("SB1")
       DbSetOrder(1)
       DbSeek(xFilial()+SW7->W7_COD_I)
       DbSelectArea(_sAlias)
       aAdd(aItens,{ SW7->W7_COD_I,;
                     AllTrim(SB1->B1_DESC),;
                     SW7->W7_QTDE,;
                     SB1->B1_PESO*SW7->W7_QTDE,;
                     (SW7->W7_PRECO+(SW7->W7_PRECO*nCInland)+(SW7->W7_PRECO*nCPacking))*SW7->W7_QTDE*nFOB,;
                     0, 0, 0, 0,SW7->W7_PRECO*SW7->W7_QTDE*nFOB})
       SW7->(DbSkip())
    End

    _sAlias := Select()
    DbSelectArea("SWD")
    DbSetOrder(1)
    DbSeek(xFilial()+SW6->W6_HAWB,.T.)

    DbSelectArea(_sAlias)

    While !SWD->(Eof()) .and. SWD->WD_HAWB==SW6->W6_HAWB
//       If !(SWD->WD_DESPESA $ "103/420/418/402/403/421/404/417/406/201")
//          SWD->(DbSkip())
//          Loop
//       EndIf
       If (SWD->WD_DESPESA $ "101/102/104") .or. (Left(SWD->WD_DESPESA,1) == "2")
           SWD->(DbSkip())
           Loop
       EndIf
       nDespesas := nDespesas + SWD->WD_VALOR_R
       SWD->(DbSkip())
    End

    nPesoLiq := 0
    nFOBTot  := 0
    For i:=1 To Len(aItens)
       nPesoLiq:=nPesoLiq+aItens[i,4]
       nFOBTot :=nFOBTot +aItens[i,5]
    Next
    For i:=1 To Len(aItens)
       aItens[i,6] := (nFrete/nPesoLiq)*aItens[i,4]*nTXFrete
    Next

    aImp := {}

    For i:=1 To Len(aItens)
       DbSelectArea("SB1")
       DbSetOrder(1)
       DbSeek(xFilial()+aItens[i,1])

       DbSelectArea("SYD")
       DbSetOrder(1)
       DbSeek(xFilial()+SB1->B1_POSIPI)

       nII  := Round( (aItens[i,5]+aItens[i,6])*(YD_PER_II/100), 2)
       nIPI := Round( (nII+aItens[i,5]+aItens[i,6])*(YD_PER_IPI/100), 2)
       nICM := Round( (nII+nIPI+aItens[i,5]+aItens[i,6])*(YD_ICMS_RE/100), 2)

       aAdd( aImp , nII + nIPI + nICM)
    Next

    For i:=1 To Len(aItens)
       aItens[i,7] := (nDespesas/nFOBTot)*aItens[i,10] + aImp[i]
       aItens[i,10] := (nDespesas/nFOBTot)*aItens[i,5] + aImp[i]
       aItens[i,8] := aItens[i,8]+aItens[i,5]+aItens[i,6]+aItens[i,10]
       aItens[i,9] := aItens[i,8]/aItens[i,3]
    Next

    For i:= 1 To Len(aItens)
       If li >= 60
          Cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
       EndIf
       @ li,000 PSAY aItens[i,1]
       @ li,016 PSAY Left(aItens[i,2], 50)
       @ li,067 PSAY Transf(aItens[i,3],"@R 999,999,999.9999")
       @ li,084 PSAY Transf(aItens[i,4],"@R 999,999,999.9999")
       @ li,101 PSAY Transf(aItens[i,5],"@R 999,999,999.9999")
       @ li,118 PSAY Transf(aItens[i,6],"@R 999,999,999.9999")
       @ li,135 PSAY Transf(aItens[i,7],"@R 999,999,999.9999")
       @ li,152 PSAY Transf(aItens[i,8],"@R 999,999,999.9999")
       @ li,169 PSAY Transf(aItens[i,9],"@R 99,999,999.9999")
       IncLin()

       aTot[1] := aTot[1] + aItens[i,3]
       aTot[2] := aTot[2] + aItens[i,4]
       aTot[3] := aTot[3] + aItens[i,5]
       aTot[4] := aTot[4] + aItens[i,6]
       aTot[5] := aTot[5] + aItens[i,7]
       aTot[6] := aTot[6] + aItens[i,8]
       aTot[7] := aTot[7] + aItens[i,9]
    Next                     

    IncLin()
    IncLin()
    @ li,000 PSAY Replicate("*",220)
    IncLin()
    @ li,016 PSAY "TOTAIS ........"
    @ li,067 PSAY Transf(aTot[1],"@R 999,999,999.9999")
    @ li,084 PSAY Transf(aTot[2],"@R 999,999,999.9999")
    @ li,101 PSAY Transf(aTot[3],"@R 999,999,999.9999")
    @ li,118 PSAY Transf(aTot[4],"@R 999,999,999.9999")
    @ li,135 PSAY Transf(aTot[5],"@R 999,999,999.9999")
    @ li,152 PSAY Transf(aTot[6],"@R 999,999,999.9999")
    IncLin()
    @ li,000 PSAY Replicate("*",220)
    IncLin()

    li := 0

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

// Substituido pelo assistente de conversao do AP5 IDE em 08/03/02 ==>  Function IncLin
Static Function IncLin()
    If li >= 60
       Cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
    EndIf
    li := li + 1
 Return
