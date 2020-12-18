#include "rwmake.ch"
#Include "TOPCONN.CH"

User Function PCPR28()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CBTXT,CBCONT,CABEC1,CABEC2,WNREL,TITULO")
SetPrvt("CDESC1,CDESC2,CDESC3,TAMANHO,LIMITE,CSTRING")
SetPrvt("AORD,LCONTINUA,CUM,LEND,ARETURN,NOMEPROG")
SetPrvt("NLASTKEY,CPERG,GMPN,GMPI,GMSN,GMSI")
SetPrvt("GOUT,GQUANT,_CFLAG,LI,M_PAG,NTIPO")
SetPrvt("CPRD,ASTRU,NESTRU,I,XDESC,XTIPO")
SetPrvt("XUM,XGRUPO,TMEDIO,CCOMP,CQUANT,CCUSTO,CPERDA")
SetPrvt("xOP,ACM,CMEDIO,PCOMPRA,CCOMPRA")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PCPR28   ³ Autor ³ Jefferson Moreira     ³ Data ³ 13.02.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Producao Analitico                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ rdmake PCPR28                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

titulo    := PADC("Relatório de Produção Analítico ",74)
cDesc1    := PADC("Este programa tem com objetivo, de apresentar a Relatório",74)
cDesc2    := PADC("de Produção Analitico .",74)
cDesc3    := ""
tamanho   := "G"   // largura do relatorio --> P 80 pos - M 132 pos - G 220 pos
limite    := 220
cString   := "SC2"
aOrd      := {} //-- Ordem
lContinua := .T.
cUM       := ""
lEnd      := .F.
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nomeprog  := "PCPR28"
nLastKey  := 0
cPerg     := "PCPR28"
xSitu     := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ MV_PAR01     // Da OP                                        ³
//³ MV_PAR02     // Ate a OP                                     ³
//³ MV_PAR03     // Da Data                                      ³
//³ MV_PAR04     // Ate a Data                                   ³
//³ MV_PAR05     // Do Produto                                   ³
//³ MV_PAR06     // Ate o Produto                                ³
//³ MV_PAR07     // Do Componente                                ³
//³ MV_PAR08     // Ate o Componente                             ³
//³ MV_PAR09     // Do CC                                        ³
//³ MV_PAR10     // Ate CC                                       ³
//³ MV_PAR11     // Apenas Situação                              ³
//³ MV_PAR12     // Status da OP                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel  := "PCPR28"
wnrel  := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,)

If nLastKey==27
	Return
Endif

SetDefault(aReturn,cString)  


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt  := Space(10)
cbcont := 00
li     := 80
m_pag  := 01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

titulo := "Relatório de Produção Analítico"                                                      
cabec1 := "Codigo           Descricao                                 Um  Tp     Quantidade  Arm CC    Arm CC                                                                     Quantidade "
cabec2 := "                                                                      Necessaria  Ori Ori   Des Des  Data                               Lote        TM  CF  Doc          Entregue Estorno        Diferença  Hora   Usuario"
//         999999999999999  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  xx  xx 999,999.999999  99  999   99  999  99/99/99                           9999999999  XXX XXX 999999 999,999.999999 XXXXXXXXX 999,999.999999  HH:MM  XXXXXXXXXX
//         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                   1111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000000111111111122222222223333333333444444444455555555556666666666777777777788888888889999999999000000000011111111112

If nLastKey == 27
   Return
Endif

nTipo  := IIF(aReturn[4]==1,15,18)
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
  
RptStatus({|| TESTE() })
Return
 //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 //³ Inicio do Processamento                                      ³
 //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 
Static Function TESTE()

 cbtxt  := Space(10)
 cbcont := 00
 
 cQuery := " Select "
 
 cQuery += " D4_OP,D4_COD,B1_DESC,B1_UM,B1_TIPO,D4_QTDEORI,C2_PERDA "

 cQuery += " From DADOSAP10..SD4010 "
 cQuery += " INNER JOIN DADOSAP10..SC2010 ON C2_NUM+C2_ITEM+C2_SEQUEN = D4_OP "
 cQuery += " INNER JOIN DADOSAP10..SB1010 ON D4_COD = B1_COD "
// cQuery += "  LEFT JOIN DADOSAP10..SD3010 ON (D4_OP = D3_OPNSB AND D4_COD = D3_COD) "
 
 cQuery += " WHERE "
 cQuery += " SD4010. D_E_L_E_T_ <> '*'  AND "
 //cQuery += " SD3010. D_E_L_E_T_ <> '*'  AND "
 cQuery += " SB1010. D_E_L_E_T_ <> '*'  AND "
 cQuery += " SC2010. D_E_L_E_T_ <> '*'  AND "
 cQuery += " D4_QTDEORI <> 0 AND "
 cQuery += " D4_TRT <> '101' AND "
 
 cQuery += " C2_NUM+C2_ITEM+C2_SEQUEN >='"+ mv_par01 + "' AND "  
 cQuery += " C2_NUM+C2_ITEM+C2_SEQUEN <='"+ mv_par02 + "' AND "
 cQuery += " C2_EMISSAO >='"+ DTOS(mv_par03) + "' AND "
 cQuery += " C2_EMISSAO <='"+ DTOS(mv_par04) + "' AND "
 cQuery += " C2_PRODUTO >='"+ mv_par05 + "' AND "
 cQuery += " C2_PRODUTO <='"+ mv_par06 + "' AND " 
 cQuery += " D4_COD >='"+ mv_par07 + "' AND "
 cQuery += " D4_COD <='"+ mv_par08 + "' AND "
 cQuery += " C2_CC >='"+ mv_par09 + "' AND "
 cQuery += " C2_CC <='"+ mv_par10 + "' "
 IF mv_par12 == 1      // Aberta
    cQuery += " AND C2_DATRF = ' ' "
 ELSEIF mv_par12 == 2  // Fechada 
    cQuery += " AND C2_DATRF <> ' ' "
 ENDIF

 cQuery += " Order By "
 cQuery += " C2_NUM+C2_ITEM+C2_SEQUEN,D4_COD ASC "

 cQuery := ChangeQuery(cQuery)

 TCQUERY cQuery Alias TAA New 

dbSelectArea("TAA")
dbGoTop()
SetRegua(RecCount())
While !EOF()

       IncRegua()

       If lEnd
          @PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
          lContinua := .F.
          Exit
       Endif
       
       If li > 65
          cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
       End

       xOP      := D4_OP
       xSitu    := {}
       
       dbSelectArea("SC2")
       dbSetOrder(1)
       dbSeek(xFilial("SC2") + xOP )
       xDescOp:= Posicione("SB1",1,xFilial("SB1")+ C2_PRODUTO,"B1_DESC")
       xCCOp  := C2_CC
       xIniOp := C2_DATPRI
       xProdOp:= C2_PRODUTO
       xTpOp  := Posicione("SB1",1,xFilial("SB1")+ C2_PRODUTO,"B1_TIPO")
       xGpOp  := Posicione("SB1",1,xFilial("SB1")+ C2_PRODUTO,"B1_GRUPO")
       xUmOp  := Posicione("SB1",1,xFilial("SB1")+ C2_PRODUTO,"B1_UM")
       xQuantOp := C2_QUANT
       xQEntrOp := C2_QUJE
       xPerdas  := C2_PERDA
       xTurno   := C2_TURNO
       
       IF mv_par11 <> 1     
          @ li,000         PSAY "Numero da OP: " + alltrim (xOP)
          @ li,PCOL()+2    PSAY "CC: "+Alltrim(xCCOp)
          @ li,PCOL()+2    PSAY "Dt.Inicio: "+dtoc(xIniOp)
          @ li,PCOL()+2    PSAY "Turno: "+alltrim(transform(xTurno,"@E 9"))+"º"
          @ li,PCOL()+2    PSAY xProdOp
          @ li,PCOL()+2    PSAY Substr(xDescOp,1,40)
          @ li,PCOL()+2    PSAY Alltrim(xTpOp)
          @ li,PCOL()+2    PSAY Alltrim(xGpOp)
          @ li,PCOL()+2    PSAY "Qtd.Total: "+Transform(xQuantOp,"@E 9,999")
          @ li,PCOL()+2    PSAY "Qtd.Entregue: "+Transform(xQEntrOp,"@E 9,999")
          @ li,PCOL()+2    PSAY "Qtd.Perdas: "+Transform(xPerdas, "@E 9,999")          
          li := li + 2
       Endif
       
       
          dbSelectArea("TAA")  
          While  !EOF() .and. xOP == D4_OP
                 IncRegua()     
                 
                 IF mv_par11 <> 1 
                    
                    @ li,000       PSAY D4_COD
                    @ li,PCOL()+2  PSAY SUBSTR(B1_DESC,1,40)
                    @ li,PCOL()+2  PSAY B1_UM
                    @ li,PCOL()+2  PSAY B1_TIPO
                 ENDIF
                    xCod := D4_COD
                    xDesc:= B1_DESC
                    xUm  := B1_UM
                    xTp  := B1_TIPO
                    
                    tProduto := 0
                    tProduto += D4_QTDEORI           
                 IF mv_par11 <> 1               
                    @ li,PCOL()+1  PSAY TRANSFORM(tProduto,"@E 999,999.999999")
                 ENDIF               
                    xPcol := PCOL()
                    xRec  := 0
                    QuantEnt := 0
                    xMov := "PL"
                   
                    dbSelectArea("SD3")
                    dbSetOrder(13)
                    dbSeek(xFilial("SD3")+xOP+xCod+xMov)
                
                    While !Eof() .And. xOP == D3_OPNSB .And. xCod == D3_COD .AND. D3_MOV == xMov
                    IncRegua()
                                           
                        IF mv_par11 <> 1 
          
                           @ li,xPcol +2  PSAY IIF(D3_TM ='600',ALLTRIM(D3_LOCAL),'10')
                           @ li,xPcol +6  PSAY IIF(D3_TM ='600',"616",'211')                 
                           @ li,xPcol +12 PSAY IIF(D3_TM ='600',"10",'01')
                           @ li,xPcol +16 PSAY IIF(D3_TM ='600',ALLTRIM(D3_CC),'616')                  
                           @ li,xPcol +21 PSAY Subs(Dtos(D3_DTRM),7,2) + "/" + Subs(Dtos(D3_DTRM),5,2)+ "/" + Subs(Dtos(D3_DTRM),3,2)
                           @ li,136       PSAY D3_LOTECTL
                           @ li,PCOL()+2  PSAY D3_TM
                           @ li,PCOL()+1  PSAY D3_CF
                           @ li,PCOL()+1  PSAY D3_DOC
                           @ li,PCOL()+1  PSAY TRANSFORM(D3_QUANT,"@E 999,999.999999")
                           @ li,PCOL()+1  PSAY IIF(D3_ESTORNO == 'S',"Estornado",space(9))
                        
                        Endif
                      
                        IF D3_ESTORNO <> 'S'
                           QuantEnt += D3_QUANT
                        ENDIF
                        IF mv_par11 <> 1
                           @ li,PCOL()+17 PSAY D3_HORA
                           @ li,PCOL()+2  PSAY D3_USUARIO 
                           li++
                        Endif   
                        xRec += 1
                                           
                        If li > 65
                           cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
                        End
                        If lEnd
                           @PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
                           lContinua := .F.
                           Exit
                        Endif
                
                        SD3->(dbSkip())

                    EndDo
                
                Diferenca := QuantEnt-tProduto
                if Diferenca <> 0
                   AAdd(xSitu,{xCod,xDesc,xUm,xTp,Diferenca})
                endif
                dbSelectArea("TAA")   
                   If xRec == 0
                      IF mv_par11 <> 1
                         @ li,188 PSAY TRANSFORM(Diferenca,"@E 999,999.999999")    
                         li += 1
                      Endif
                      TAA->(dbSkip())
                   else
                      IF mv_par11 <> 1
                         @ li-1,189 PSAY TRANSFORM(Diferenca,"@E 999,999.999999")
                      Endif
                      TAA->(dbSkip())
                   Endif
              
          EndDo
          
          cQuery := " SELECT "          
          cQuery += " BC_PRODUTO,B1_DESC,B1_UM,B1_TIPO,BC_LOCORIG,BC_TIPO,BC_MOTIVO,ZC_TIPODEF,BC_QUANT,BC_DTRM ,BC_LOTECTL,BC_LOCAL,BC_APLIC,BC_DTRM,BC_HORA,D3_DOC,D3_TM,D3_CF,D3_USUARIO "
          cQuery += " FROM DADOSAP10..SBC010 "
          cQuery += " INNER JOIN DADOSAP10..SB1010 ON BC_PRODUTO = B1_COD "
          cQuery += " INNER JOIN DADOSAP10..SZC010 ON BC_MOTIVO  = ZC_COD "
          cQuery += " INNER JOIN DADOSAP10..SD3010 ON BC_SEQSD3  = D3_NUMSEQ AND D3_TM = '999' "
          cQuery += " WHERE "
          cQuery += " SBC010.D_E_L_E_T_ <> '*' AND "
          cQuery += " SZC010.D_E_L_E_T_ <> '*' AND "
          cQuery += " SB1010.D_E_L_E_T_ <> '*' AND "
          cQuery += " SD3010.D_E_L_E_T_ <> '*' AND " 
          cQuery += " BC_PRODUTO >='"+ mv_par07 + "' AND "
          cQuery += " BC_PRODUTO <='"+ mv_par08 + "' AND "
          cQuery += " BC_OP = '"+ xOP +"'
          cQuery += " Order By "
          cQuery += " BC_PRODUTO ASC "
          
          cQuery := ChangeQuery(cQuery)
          TCQUERY cQuery Alias TAB New     
          
          aDev := {}
          
          dbSelectArea("TAB")
          
          if !EOF()
              IF mv_par11 <> 1
                 //  li++
                 @ li,000  PSAY Repl("-",limite)
                   li++
                 @ li,000  PSAY "Devolucoes"
                   li++
                 @ li,000  PSAY Repl("-",15)
                   li++
              ENDIF
          Endif  
          While  !EOF() 
                 IncRegua()
                 if BC_TIPO == 'S'
                    xDev    := 'Scrap '
                 Elseif BC_TIPO == 'R'
                    xDev    := 'Refugo'  
                 else
                    xDev    := 'Devolu'
                 Endif   
                 
                 IF mv_par11 <> 1    
                      
                    @ li,000       PSAY BC_PRODUTO
                    @ li,PCOL()+2  PSAY SUBSTR(B1_DESC,1,40)
                    @ li,PCOL()+2  PSAY B1_UM
                    @ li,PCOL()+2  PSAY B1_TIPO
                    @ li,PCOL()+1  PSAY TRANSFORM(BC_QUANT,"@E 999,999.999999")
                    @ li,PCOL()+2  PSAY BC_LOCORIG                 
                    @ li,PCOL()+2  PSAY '   '
                    @ li,PCOL()+3  PSAY BC_LOCAL
                    @ li,PCOL()+2  PSAY Alltrim(BC_APLIC)                 
                    @ li,PCOL()+2  PSAY Subs(BC_DTRM,7,2) + "/" + Subs(BC_DTRM,5,2)+ "/" + Subs(BC_DTRM,3,2)            
                    @ li,136       PSAY BC_LOTECTL
                    @ li,PCOL()+2  PSAY D3_TM
                    @ li,PCOL()+1  PSAY D3_CF
                    @ li,PCOL()+1  PSAY D3_DOC
                    @ li,PCOL()+2  PSAY xDev
                    @ li,PCOL()+1  PSAY BC_MOTIVO
                    @ li,PCOL()+1  PSAY Subs(ZC_TIPODEF,1,29)
                    @ li,PCOL()+1  PSAY BC_HORA
                    @ li,PCOL()+2  PSAY Subs(D3_USUARIO,1,10) 
                    li++
                 Endif
                 
                 IF BC_TIPO $ "S/R"
                    nPos := Ascan(aDev, {|X| X[1] == BC_PRODUTO})
                    If nPos == 0              
                       AAdd(aDev,{BC_PRODUTO,B1_DESC,B1_UM,B1_TIPO,BC_QUANT})
                    else
                       aDev[nPos][5]+= BC_QUANT                 
                    Endif
                 Endif   
          TAB->(dbSkip())
          
          If li > 65
             cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
          End
          If lEnd
             @PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
             Continua := .F.
             Exit
          Endif
          Enddo
          If !EOF()
             IF mv_par11 <> 1
            //      li++
                @ li,000  PSAY Repl("-",limite)
                  li++
             ENDIF   
          ENDIF
          If li > 65
             cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
          Endif   

          dbCloseArea()
              
           cQuery := " SELECT "
           cQuery += " CP_PRODUTO,B1_DESC,B1_UM,B1_TIPO,CP_QUANT,CP_NUM,CP_ITEM,CP_EMISSAO,CP_DATPRF,CP_LOCAL,CP_CC,CP_SOLICIT,CP_DTRS,CP_HORA,D3_LOTECTL,D3_TM,D3_CF,D3_DOC,D3_QUANT,D3_ESTORNO,D3_HORA,D3_USUARIO "
           cQuery += " FROM DADOSAP10..SCP010 "
           cQuery += "  LEFT JOIN DADOSAP10..SCQ010 ON CQ_NUM = CP_NUM AND CQ_ITEM = CP_ITEM "
           cQuery += "  LEFT JOIN DADOSAP10..SD3010 ON CQ_NUMREQ = D3_NUMSEQ AND CQ_OP = D3_OPNSB"
           cQuery += " INNER JOIN DADOSAP10..SB1010 ON CP_PRODUTO = B1_COD "
           cQuery += " WHERE "
           cQuery += " SCP010.D_E_L_E_T_ <> '*' AND  "
           cQuery += " SCQ010.D_E_L_E_T_ <> '*' AND  "
           cQuery += " SD3010.D_E_L_E_T_ <> '*' AND  "
           cQuery += " SB1010.D_E_L_E_T_ <> '*' AND  "
   //        cQuery += " D3_CF = 'RE3' AND "
   //        cQuery += " D3_TM = '600' AND "
           cQuery += " CP_PRODUTO >='"+ mv_par07 + "' AND "
           cQuery += " CP_PRODUTO <='"+ mv_par08 + "' AND "
           cQuery += " CP_OP = '"+ xOP +"'
           cQuery += " ORDER BY CP_NUM,CP_ITEM,CP_PRODUTO "    
           
           cQuery := ChangeQuery(cQuery)
           TCQUERY cQuery Alias TAC New
           if !EOF()
              IF mv_par11 <> 1 
                 @ li,000  PSAY Repl("-",limite)
                   li++          
                 @ li,000  PSAY "Requisicoes"
                   li++
                 @ li,000  PSAY Repl("-",15)
                   li++
              ENDIF
           endif   
           While  !EOF() 
                 IncRegua()
                 xProd := CP_PRODUTO
                 xDesc := B1_DESC
                 xUm   := B1_UM
                 xTp   := B1_TIPO
                 QuantEnt := 0
                 xRec  := 0
                 xQuantOri := CP_QUANT
                 xMov := "RQ"
                 
                 IF mv_par11 <> 1 
                       
                    @ li,000       PSAY CP_PRODUTO
                    @ li,PCOL()+2  PSAY SUBSTR(B1_DESC,1,40)
                    @ li,PCOL()+2  PSAY B1_UM
                    @ li,PCOL()+2  PSAY B1_TIPO
                    @ li,PCOL()+1  PSAY TRANSFORM(CP_QUANT,"@E 999,999.999999")
                    @ li,PCOL()+2  PSAY '10'                 
                    @ li,PCOL()+2  PSAY IIF (!EMPTY(CP_CC),Alltrim(CP_CC),"   ")
                    @ li,PCOL()+1  PSAY CP_NUM
                    @ li,PCOL()+1  PSAY CP_ITEM             
                    @ li,PCOL()+2  PSAY Subs(CP_DTRS,7,2) + "/" + Subs(CP_DTRS,5,2)+ "/" + Subs(CP_DTRS,3,2)
                    @ li,PCOL()+2  PSAY CP_HORA
                    @ li,PCOL()+2  PSAY subs(CP_SOLICIT,1,10)
                 
                 Endif
                 
         //        dbSelectArea("SD3")
         //        dbSetOrder(13)
         //        dbSeek(xFilial("SD3")+xOP+xProd+xMov)
                 
                 While !EOF() .and. xProd == CP_PRODUTO
        //         While !Eof() .And. xOP == D3_OPNSB .And. xCod == D3_COD .AND. D3_MOV == xMov        
                       IF mv_par11 <> 1 
                          
                          @ li,136       PSAY D3_LOTECTL
                          @ li,PCOL()+2  PSAY D3_TM
                          @ li,PCOL()+1  PSAY D3_CF
                          @ li,PCOL()+1  PSAY D3_DOC
                          @ li,PCOL()+2  PSAY TRANSFORM(D3_QUANT,"@E 999,999.999999")
                          //@ li,PCOL()+1  PSAY '         '
                          @ li,PCOL()+1  PSAY IIF(D3_ESTORNO == 'S',"Estornado",space(9))
                          @ li,PCOL()+16 PSAY D3_HORA
                          @ li,PCOL()+2  PSAY Subs(D3_USUARIO,1,10)
                          li++
                       Endif                         
                       
                       If li > 65
                            cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
                       End
                       If lEnd
                           @PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
                           lContinua := .F.
                           Exit
                        Endif
                       IF D3_ESTORNO <> 'S'
                           QuantEnt += D3_QUANT
                       ENDIF
                       
                       xRec += 1
                       
                 
                 IF TRANSFORM(QuantEnt,"@E 999,999.999999") == TRANSFORM(xQuantOri,"@E 999,999.999999")//TRANSFORM(D3_QUANT,"@E 999,999.999999")
                    TAC->(dbSkip()) 
                    Exit
                 else
                    TAC->(dbSkip()) 
                 endif
                 Enddo

                    Diferenca := QuantEnt-xQuantOri
                    
                       IF Diferenca <> 0 
                          if Ascan(aDev,xProd)== 0   
                             AAdd(xSitu,{xProd,xDesc,xUm,xTp,Diferenca})
                          endif                 
                       ENDIF
                             
                       If xRec == 0
                        
                          IF mv_par11 <> 1
                             @ li,188 PSAY TRANSFORM(Diferenca,"@E 999,999.999999")    
                             li ++
                          ENDIF   
                          TAC->(dbSkip())
                       else
                          IF mv_par11 <> 1
                             @ li-1,189 PSAY TRANSFORM(Diferenca,"@E 999,999.999999")
                          ENDIF
                       Endif
                    
                    If li > 65
                       cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
                    Endif
                    If lEnd
                       @PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
                       lContinua := .F.
                       Exit
                    Endif
          Enddo
          If !EOF()
             IF mv_par11 <> 1
               //   li++
                @ li,000  PSAY Repl("-",limite)
                  li++             
             ENDIF
          Endif   
          dbCloseArea()
          
           cQuery := " SELECT "
           cQuery += " D3_COD,B1_DESC,B1_UM,B1_TIPO,D3_DOC,D3_TM,D3_CF,D3_LOCAL,D3_CC,D3_EMISSAO,D3_LOTECTL,C2_QUANT,D3_DOC,D3_QUANT,D3_USUARIO,D3_DTRM,D3_HORA "
           cQuery += " FROM DADOSAP10..SD3010 "
           cQuery += "  INNER JOIN DADOSAP10..SB1010 ON B1_COD = D3_COD "
           cQuery += "  INNER JOIN DADOSAP10..SC2010 ON C2_NUM+C2_ITEM+C2_SEQUEN = D3_OP "
           cQuery += " WHERE "
           cQuery += " SC2010.D_E_L_E_T_ <> '*' AND  "
           cQuery += " SD3010.D_E_L_E_T_ <> '*' AND  "
           cQuery += " SB1010.D_E_L_E_T_ <> '*' AND  "
           cQuery += " D3_ESTORNO <> 'S' AND "
           cQuery += " D3_TM = '400' AND "
           cQuery += " D3_OP = '"+ xOP +"'
                   
           cQuery := ChangeQuery(cQuery)
           TCQUERY cQuery Alias TAD New
           
           QuantEnt := 0
           xRec  := 0
           If !EOF()
               IF mv_par11 <> 1
                  @ li,000  PSAY Repl("-",limite)
                   li++
                  @ li,000  PSAY "Apontamentos"
                    li++
                  @ li,000  PSAY Repl("-",15)
                    li++
               ENDIF 
           Endif
           
           While  !EOF() 
                 IncRegua()
                 
                 If mv_par11 <> 1          
                 
                    @ li,000       PSAY D3_COD
                    @ li,PCOL()+2  PSAY SUBSTR(B1_DESC,1,40)
                    @ li,PCOL()+2  PSAY B1_UM
                    @ li,PCOL()+2  PSAY B1_TIPO
                    @ li,PCOL()+1  PSAY TRANSFORM(C2_QUANT,"@E 999,999.999999")
                    @ li,PCOL()+2  PSAY '10'                 
                    @ li,PCOL()+2  PSAY IIF (!EMPTY(D3_CC),Alltrim(D3_CC),"   ")
                    @ li,PCOL()+3  PSAY D3_LOCAL
                    @ li,PCOL()+2  PSAY '619'            
                    @ li,PCOL()+2  PSAY Subs(D3_DTRM,7,2) + "/" + Subs(D3_DTRM,5,2)+ "/" + Subs(D3_DTRM,3,2)
                    @ li,PCOL()+2  PSAY '     '
                    @ li,PCOL()+2  PSAY SPACE(10)
                               
                    @ li,136       PSAY D3_LOTECTL
                    @ li,PCOL()+2  PSAY D3_TM
                    @ li,PCOL()+1  PSAY D3_CF
                    @ li,PCOL()+1  PSAY D3_DOC
                    @ li,PCOL()+2  PSAY TRANSFORM(D3_QUANT,"@E 999,999.999999")
                    @ li,PCOL()+1  PSAY '         '
                    @ li,PCOL()+16 PSAY D3_HORA
                    @ li,PCOL()+2  PSAY Subs(D3_USUARIO,1,10)
                 
                 Endif 
                 xRec  += 1                               
                 QuantEnt += D3_QUANT
                 Diferenca := QuantEnt-xQuantOp
                 xCod := D3_COD
                 xDesc:= B1_DESC
                 xUm  := B1_UM
                 xTp  := B1_TIPO 
                 
                 If mv_par11 <> 1               
                    @ li,189 PSAY TRANSFORM(Diferenca,"@E 999,999.999999")
                    li++
                 Endif
                 If li > 65
                    cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
                 End 
                 If lEnd
                    @PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
                    lContinua := .F.
                    Exit
                 Endif          
                
                 TAD->(dbSkip()) 
            
           Enddo
           if xRec <> 0
              if Diferenca <> 0
                 AAdd(xSitu,{xCod,xDesc,xUm,xTp,Diferenca})
              endif
           Else
              Diferenca := 0-xQuantOp
              AAdd(xSitu,{xProdOp,xDescOp,xUmOP,xTpOP,Diferenca})
           endif   
              
           If Len(xSitu) <> 0
         //    li++
             If li > 65
                cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
             End  
           
           
           If mv_par11 == 1  .and. !Empty(xSitu)
                 @ li,000         PSAY "Numero da OP: " + alltrim (xOP)
                 @ li,PCOL()+2    PSAY "CC: "+Alltrim(xCCOp)
                 @ li,PCOL()+2    PSAY "Dt.Inicio: "+dtoc(xIniOp)
                 @ li,PCOL()+2    PSAY xProdOp
                 @ li,PCOL()+2    PSAY Substr(xDescOp,1,40)
                 @ li,PCOL()+2    PSAY Alltrim(xTpOp)
                 @ li,PCOL()+2    PSAY Alltrim(xGpOp)
                 @ li,PCOL()+2    PSAY Transform(xQuantOp,"@E 999,999")
                 @ li,PCOL()+2    PSAY Transform(xQEntrOp, "@E 999,999")
                 li += 1
                 @ li,000  PSAY Repl("-",limite)
                   li++
                 @ li,000  PSAY "Situacao"
               //    li++
                 @ li,000  PSAY Repl("_",15)
                   li++
           Else  
                 @ li,000  PSAY Repl("-",limite)
                   li++
                 @ li,000  PSAY "Situacao"
                   li++
                 @ li,000  PSAY Repl("-",15)
                   li++
           Endif           
             For i=1 to Len(xSitu)
                 if xProdOp == xSitu [i][1] .and. i<>1
                    @ li,000  PSAY Repl("-",15)
                    li++
                 endif
                 @ li,000       PSAY xSitu [i][1]
                 @ li,PCOL()+2  PSAY SUBSTR((xSitu[i][2]),1,40)
                 @ li,PCOL()+2  PSAY xSitu[i][3]
                 @ li,PCOL()+2  PSAY xSitu[i][4]
                 @ li,PCOL()+1  PSAY TRANSFORM((xSitu[i][5]),"@E 999,999.999999")
                 li++
               
                 If li > 65
                    cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
                 End
             Next
          
           Endif
              
           If mv_par11 <> 1
          //    li++
              @ li,000  PSAY Repl("=",limite)
              li++
           Elseif !Empty(xSitu)   
          //    li++
              @ li,000  PSAY Repl("=",limite)
              li++
           Endif
          
           dbCloseArea()


dbSelectArea("TAA")          
EndDo
 
 dbClearFil(NIL)
 dbCloseArea()
 
Set Device To Screen

If aReturn[5] == 1
    Set Printer to
    dbCommitAll()
    ourspool(wnrel)
 Endif
 MS_FLUSH()      
 Return