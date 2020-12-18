#include "rwmake.ch"  
#Include "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณATVR01    บAutor  ณJefferson Moreira   บ Data ณ  05/12/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Esse programa tem o objetivo de imprimir as etiquetas com  บฑฑ
ฑฑบ          ณ o codigo de barra dos itens de NF saida conforme parametrosบฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SigaFat                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function IMPETIQE()

Private oDlg := Nil

Pergunte("ETQ002",.F.)

//Da Nota Fiscal ?    mv_par01
//Ate a Nota Fiscal ? mv_par02
//Da Serie ?          mv_par03
//Tipo Opera็ใo ?     mv_par04

@ 96,42 TO 323,505 DIALOG oDlg TITLE "Etiquetas de Saida"
@ 8,10 TO 84,222
@ 94,133 BMPBUTTON TYPE 5 ACTION Pergunte("ETQ002")
@ 94,163 BMPBUTTON TYPE 1 ACTION ImpEtqEnt()
@ 94,193 BMPBUTTON TYPE 2 ACTION Close(oDlg)
@ 23,14 SAY "Esse programa tem o objetivo de imprimir as etiquetas com"
@ 33,14 SAY "o Lote e o codigo de barra dos itens de NF entrada conforme"
@ 43,14 SAY "parametros especificado pelo usuแrio."
@ 53,14 SAY ""
ACTIVATE DIALOG oDlg

Return nil

Static Function ImpEtqEnt()  

 /*
 cQuery := " Select "
 cQuery += " D1_DOC,D1_INVOICE,D1_COD,B1_DESC,B1_TIPO,B1_GRUPO,B1_LOCPAD,D1_QUANT,D1_LOTECTL,D1_DTDIGIT,A2_NOME"
 
 cQuery += " From DADOSAP10..SD1010 "
 cQuery += " INNER JOIN DADOSAP10..SB1010 ON D1_COD = B1_COD"
 cQuery += " INNER JOIN DADOSAP10..SA2010 ON D1_FORNECE = A2_COD     AND D1_LOJA  = A2_LOJA"
 
 cQuery += " WHERE " 
 cQuery += " SD1010. D_E_L_E_T_ <> '*'  AND "
 cQuery += " SB1010. D_E_L_E_T_ <> '*'  AND " 
 cQuery += " SA2010. D_E_L_E_T_ <> '*'  AND "
 cQuery += " B1_RASTRO ='L' AND "
 cQuery += " D1_DOC >='" + mv_par01 +"' AND "  
 cQuery += " D1_DOC <='" + mv_par02 +"'
 
 
// cQuery += " GROUP BY "
// cQuery += " C6_PEDCLI,C6_TPEDIDO,C6_LINHA,F2_DOC,F2_SERIE,A7_PRODUTO,A7_CODCLI,A7_DESCCLI,C6_UM,A1_NREDUZ,C6_ENTREG,C6_HORA,C6_SETOR,C6_CLI,C6_LOJA "
 
 cQuery += " Order By " 
 cQuery += " D1_DOC ASC " 
 
 cQuery := ChangeQuery(cQuery)

 TCQUERY cQuery Alias TAB New 

                                              
 dbSelectArea("TAB")
 dbGoTop()
 
 _xEtiq := {}
  
While !EOF() 

_Quant := D1_QUANT     //qtd total

dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1") + TAB->D1_COD)         
_xQuant := B1_QE        //embalagem
 _xVol := Int(_Quant/_xQuant)
 
 If _xVol <> _Quant /_xQuant
    _xVol += 1
 Endif    
 
 dbSelectArea("TAB")
 
 If Empty(mv_par03) .and. mv_par03 == 0
 
    if Empty(_xQuant)
       Alert("Quantidade por embalagem nใo informada !!! ") 
       dbClearFil(NIL)
       dbCloseArea()
       Return
    Endif   
    
    For _Ent:= 1 to _xVol
    
       if _xVol == 1
          //Houver apenas um volume
          _qtd :=_Quant
       else   
           //Residuo 
          if _Quant <  _xQuant
             _qtd   := _Quant
          else
             _Quant-=_xQuant
             _qtd := _xQuant
          endif
       endif   
  
       _Data   := Subs(D1_DTDIGIT,7,2) + "/" + Subs(D1_DTDIGIT,5,2)+ "/" + Subs(D1_DTDIGIT,3,2)
 
       AAdd(_xEtiq,{D1_DOC,;     //  [01]
                D1_INVOICE,;     //  [02]
                    D1_COD,;     //  [03]
                   B1_DESC,;     //  [04]
                   B1_TIPO,;     //  [05]
                  B1_GRUPO,;     //  [06]
                 B1_LOCPAD,;     //  [07]
Transform(_qtd,"@E 999,999"),;//  [08]
                D1_LOTECTL,;     //  [09]
                     _Data,;     //  [10]
        Subs(A2_NOME,1,30)})     //  [11] 

    Next
 
 Else 
     _jQuant := Transform(_xQuant,"@E 999,999")//"[            ]"
     For n:=1 to mv_par03
     
         _Data   := Subs(D1_DTDIGIT,7,2) + "/" + Subs(D1_DTDIGIT,5,2)+ "/" + Subs(D1_DTDIGIT,3,2)
 
         AAdd(_xEtiq,   {D1_DOC,;     //  [01]
                     D1_INVOICE,;     //  [02]
                         D1_COD,;     //  [03]
                        B1_DESC,;     //  [04]
                        B1_TIPO,;     //  [05]
                       B1_GRUPO,;     //  [06]
                      B1_LOCPAD,;     //  [07]
                        _jQuant,;     //  [08]
                     D1_LOTECTL,;     //  [09]
                          _Data,;     //  [10]
             Subs(A2_NOME,1,30)})     //  [11]
 
 
     Next
        
 endif
 
 
dbSelectArea("TAB")
   TAB->(dbSkip())
EndDo

*/


 dbSelectArea("SD1")
 dbSetOrder(1)
 dbSeek(xFilial("SD1")+mv_par01,.T.)

 _xEtiq := {}
 While !Eof() .And. D1_DOC <= mv_par02 //.And. lContinua

   /*

       #IFNDEF WINDOWS
                    If LastKey() == 286
                       lEnd := .t.
                    End
       #ENDIF

       If lEnd
                    @PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
                    lContinua := .F.
                    Exit
       Endif
    */   
       If D1_COD < Mv_Par08 .Or. D1_COD > Mv_Par09
          dbSkip()
          Loop
       End
       
       If D1_Fornece < Mv_Par06 .Or. D1_Fornece > Mv_Par07
          dbSkip()
          Loop
       End

       If Empty(D1_LoteCtl) .Or. D1_DtDigit < mv_par04 .Or. D1_DtDigit > mv_par05
          dbSkip()
          Loop
       End
       
       dbSelectArea("SA2")
       dbSetOrder(1)
       dbSeek(xFilial("SA2")+SD1->D1_FORNECE)

       dbSelectArea("SA5") // Incluido By Souza At 07/11/14 as 06:46
       dbSetOrder(1)
       If dbSeek(xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_COD)
          xQtdEmb  := SA5->A5_QE       
       Endif


       dbSelectArea("SB1")
       dbSetOrder(1)
       dbSeek(xFilial("SD1")+SD1->D1_COD)
       
       xQuant := 0
       dbSelectArea("SD1")
       
       xLoteCtl := D1_LoteCtl
       xNomFor  := SubStr(SA2->A2_Nome,1,40)
       xCodigo  := D1_Cod
       xDtDigit := DTOC(D1_DTDIGIT)
       xDoc     := D1_Doc
       xInvoice := D1_Invoice
       xQtdEmb  := IIF(xQtdEmb==0,SB1->B1_QE,xQtdEmb) // Alterado By Souza At 07/11/14
       
       While !Eof() .And. D1_DOC == xDoc .And. D1_Cod == SB1->B1_Cod
             xQuant := xQuant + D1_Quant
             dbSkip()
       EndDo
       
       If Mv_par03 == 0 // Quantidade de Etiquetas por Produto.
          xQtdEtq := Iif(xQuant<=SB1->B1_QE,1,Int(xQuant/SB1->B1_QE))
       Else
          xQtdEtq := MV_Par03
       End         //     0123456789012345679012345678901234567890
                   //     xxxxx 9999999999      xxxxxxxx 99.99.99
       For xI := 1 To xQtdEtq 
           /*
           For k:=1 To 2
               @ li,000 PSAY chr(18)+"Lote Nr.: "+xLoteCtl
           Next
           li := li + 1    
           @ li,000 PSAY "Entrada: "+xDtDigit ; li := li + 1
           @ PROW(),PCOL() PSAY CHR(15)
           @ li,000 PSAY "Fornecedor.: "+xNomFor ; li := li + 1
           @ li,000 PSAY "N.Fiscal Nr.: "+xDoc+"    Invoice Nr.: "+xInvoice ; li := li + 1
           @ li,000 PSAY "Produto: "+xCodigo+"  Tipo: "+SB1->B1_Tipo+"  Grupo: "+SB1->B1_Grupo ; li := li + 1
           @ li,000 PSAY "Descricao: "+SubStr(SB1->B1_Desc,1,40) ; li := li + 1
           @ li,000 PSAY "  Nr. da OP         QTDE            DATA" ;  li := li + 1
           @ li,000 PSAY "[             ] [  "+Transform(xQtdEmb,"@E 999,999")+"   ] [    /    /    ]"
           li := li + 5
           @ PROW(),PCOL() PSAY CHR(18) 
           */
           AAdd(_xEtiq,   {xDoc,;     //  [01]
                       xInvoice,;     //  [02]
                        xCodigo,;     //  [03]
      SubStr(SB1->B1_Desc,1,40),;     //  [04]
                   SB1->B1_Tipo,;     //  [05]
                  SB1->B1_Grupo,;     //  [06]
                           "  ",;     //  [07]
Transform(xQtdEmb,"@E 999,999"),;     //  [08]
                       xLoteCtl,;     //  [09]
                       xDtDigit,;     //  [10]
                        xNomFor})     //  [11] 
           
       Next
       
 Enddo

IF Len(_xEtiq) > 0 

For i:=1 to Len(_xEtiq)// step 2 

     
MSCBPRINTER("Z4M","LPT1",,,)
MSCBCHKStatus(.F.)
MSCBBEGIN(1,6)
/*
MSCBWrite("^XA~TA000~JSN^LT0^MMT^MNW^MTD^PON^PMN^LH0,0^JMA^PR4,4^MD0^JUS^LRN^CI0^XZ")
MSCBWrite("~DG000.GRF,75264,112,")
MSCBWrite(",::::::::I07FpTF0,H03FpVF,H0pXFC0,01FpWFE0,03FpXF0,:03FC0pT07F0,07F0pU03F8,07E0pU01F8,0FE0pU01F8,0FC0pU01F8,::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::07C0pU01F8,07E0pU01F8,03E0pU01F0,03FpXF0,::01FpWFE0,H0pXFC0,H03FpVF,,::::::::::::::::::::::::::::~DG001.GRF,04480,028,")
MSCBWrite(",::::::::::::::::::Y0J8P0T80,X0K5O0T5,X0A2A2A0N0A2A2A2A2A2A2A2,X0K5N015S5,X0L8N0T8,X0K540L015R54,W0H2A2A2A0L0A2A2A2A2A2A2A28,W015K5M0T50,X0L8M0U8,W0M5M0M540,W02A2A2A280K02A2A2A280,W0M5M0M540,W0N8L0N80,V015L540J045M50,V02A2A2A2A20J0I2A2A2A20,V015M5K0515L50,W0N8K0808M8,V0O5J01515L54,V0H2A2A2A2A0I02A0A2A2A2A0,V0O5J0H545L54,V0P8J0P8,U015N540H0H545M5,U0H2A2A2A2A2A0H0A2A2A2A2A2A,U0I515L5H0155415L540,V0H808L8I0I808M80,U0I505L5H0155005L540,U02A202A2A2A28022A002A2A2A2A0,U0H5405L5405H5H0N50,U0I8H0M808H8I0N8,T01550015K5415540015L50,T02A28022A2A2A202A20022A2A2A28,T01550015K5415540015L54,U0H8I0M808H8I0N8,T0H540015O5J0N5,T0A2A0H0A2A2A2A2A20I0A2A2A2A280,S015540H0O540I015L5,T0I8J0O8K0N80,S015540H015M540I015L540,S0H2A0I02A2A2A2A280J0A2A2A2A20,S01550I015M540J0M540,T0H8K0O8K0N80,S0H540I015M5L0N50,S02A0K02A2A2A2A0K02A2A2A2A0,R015540J0M540K015L50,S0I8L0M8M0N8,R015540J0M540K015L50,R02A280J0H2A2A2A0L0H2A2A2A28,R0I5L015K5M0N50,S0H8M0L808S80,R0H540L0L515R540,R0A2A0L0A2A2A2H2A2A2A2A2A2A2A0,Q015540L0K545S540,R0I8N0g80,Q01550M0K515S5,Q0H2A0M02A2A202A2A2A2A2A2A2A,Q0I5N015H5415S5,,:::::::::::::P0LEH0LE80H0LEH06EIE0EEC2EE,O03FKFC0FKFE007FKF03FJF3FF87FF,O02BABABAA0BABABAB01ABABABA0ABABAA2BA82BA,O03FKFE1FLF03FKFE1FJFE7FF0FHF,O02EE80EHE0EEC0EHE86EEC0EHE2EHEI06EE0EHE,O03FF80FFE3FF807FF8FHF81FFE7FF80H07FF1FFE,O03BB00BBA3BB803BA1BBA01BAABBA0I0HBA0BBA,O0HFE01FFE7FF007FF1FFC01FFCFFE0H01FFE1FFC,O0IEH0LEH0IE2EE802EE8EHEJ0IE2EE8,N01FFC01FFCFFE00FFE3FF803FF9FHF8003FFC3FF8,N01AB802BA9ABA00BA82BA003AB0BAB8003AB83AB0,N03FF807FF1FFE07FF87FF007FF0FHFE003FF87FF0,N02EE86EHE2EEC2EHE06EE006EE0EIEH02EE86EE0,N07FKFC3FKFC0FLFE07FHF807FF0FFE0,N03BABHBA03BABHBA00BABHBAB800BHB803BA1BB80,N0MF83FKFC0FLFC00FHFE0FFE1FFC0,N0IE02EEC6EE00EEC0EEC02EE800EIE0EHE2EEC0,N0HFE01FFC7FF00FFC1FFC03FF8007FHF1FFC3FFC0,N0BAA01AB8BAA01ABA3AB802BA8002BAB0BA82BA80,M01FFC03FFCFFE01FFC3FF807FF8001FHF3FF83FF80,M02EEC06EECEEC00EEC6EE006EE0I0IE6EE86EE,M03FF807FJF803FF8FFE007FE0I0HFE7FF87FF,M03AB002BB3AB802BB8ABA00BBA0H01ABA3AB0BAA,M07FF01FHF3FF803FF8FFE00FFE0H03FFC7FF0FFE,M06ELE6EE806EE0EHEH0HECEKE8EHE0EKE8,M0MF87FF807FF1FFE01FFCFKF0FFE1FKF8,M0ABABABA02BA00BAA0BA803AB8BABABA0AB83ABABAB0,L01FKFC07FF00FFE1FFC03FF8FJF81FFC3FKF0,,::::::::::::::::::::::::::::::::::::::::::^XA^LL0933")
MSCBWrite("^PW933")
MSCBWrite("^FT32,864^XG000.GRF,1,1^FS")
MSCBWrite("^FT32,224^XG001.GRF,1,1^FS")
MSCBWrite("^FT56,262^A0N,50,50^FH\^FDLote: "+ _xEtiq[i][9] + "^FS")
MSCBWrite("^FT628,262^A0N,42,40^FH\^FDData: "+ _xEtiq[i][10] + "^FS")
MSCBWrite("^FT56,325^A0N,42,40^FH\^FDFornecedor: "+ _xEtiq[i][11] +"^FS")
MSCBWrite("^FT56,391^A0N,42,40^FH\^FDNota Fiscal: "+ _xEtiq[i][1] +"^FS")
MSCBWrite("^FT59,457^A0N,42,40^FH\^FDProduto: "+ _xEtiq[i][3] + "^FS")
MSCBWrite("^FT424,391^A0N,42,40^FH\^FDInvoice: "+ _xEtiq[i][2] +"^FS")
MSCBWrite("^FT543,453^A0N,42,40^FH\^FDTp: "+ _xEtiq[i][5] +"^FS")
MSCBWrite("^FT59,516^A0N,42,40^FH\^FDDescri\87\C6o: "+ _xEtiq[i][4] +"^FS")
MSCBWrite("^FT697,450^A0N,42,40^FH\^FDGrupo: "+ _xEtiq[i][6] +"^FS")
MSCBWrite("^FT56,581^A0N,42,40^FH\^FDOp: [                               ]^FS")
MSCBWrite("^FT56,651^A0N,42,40^FH\^FDData: [       /        /        ]^FS")
MSCBWrite("^BY2,3,94^FT147,782^BCN,,Y,N")
MSCBWrite("^FD>:"+_xEtiq[i][3]+_xEtiq[i][09]+"^FS")
MSCBWrite("^FT618,581^A0N,42,40^FH\^FDQuant.: "+  _xEtiq[i][8] +"^FS")
MSCBWrite("^FT240,154^A0N,58,50^FH\^FDNIPPON SEIKI DO BRASIL LTDA^FS")
MSCBWrite("^PQ1,0,1,Y^XZ")
MSCBWrite("^XA^ID000.GRF^FS^XZ")
MSCBWrite("^XA^ID001.GRF^FS^XZ")
*/
/*
MSCBWrite("^XA~TA000~JSN^LT0^MMT^MNW^MTT^PON^PMN^LH0,0^JMA^PR4,4^MD0^JUS^LRN^CI0^XZ")
MSCBWrite("~DG000.GRF,75264,112,")
MSCBWrite(",::::::::I07FpTF0,H03FpVF,H0pXFC0,01FpWFE0,03FpXF0,:03FC0pT07F0,07F0pU03F8,07E0pU01F8,0FE0pU01F8,0FC0pU01F8,::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::07C0pU01F8,07E0pU01F8,03E0pU01F0,03FpXF0,::01FpWFE0,H0pXFC0,H03FpVF,,::::::::::::::::::::::::::::~DG001.GRF,03840,024,")
MSCBWrite(",:::::::::::::::::::::::::::::::W0J8P0T80,V0K5O0T5,V0A2A2A0N0A2A2A2A2A2A2A2,V0K5N015S5,V0L8N0T8,V0K540L015R54,U0H2A2A2A0L0A2A2A2A2A2A2A28,U015K5M0T50,V0L8M0U8,U0M5M0M540,U02A2A2A280K02A2A2A280,U0M5M0M540,U0N8L0N80,T015L540J045M50,T02A2A2A2A20J0I2A2A2A20,T015M5K0515L50,U0N8K0808M8,T0O5J01515L54,T0H2A2A2A2A0I02A0A2A2A2A0,T0O5J0H545L54,T0P8J0P8,S015N540H0H545M5,S0H2A2A2A2A2A0H0A2A2A2A2A2A,S0I515L5H0155415L540,T0H808L8I0I808M80,S0I505L5H0155005L540,S02A202A2A2A28022A002A2A2A2A0,S0H5405L5405H5H0N50,S0I8H0M808H8I0N8,R01550015K5415540015L50,R02A28022A2A2A202A20022A2A2A28,R01550015K5415540015L54,S0H8I0M808H8I0N8,R0H540015O5J0N5,R0A2A0H0A2A2A2A2A20I0A2A2A2A280,Q015540H0O540I015L5,R0I8J0O8K0N80,Q015540H015M540I015L540,Q0H2A0I02A2A2A2A280J0A2A2A2A20,Q01550I015M540J0M540,R0H8K0O8K0N80,Q0H540I015M5L0N50,Q02A0K02A2A2A2A0K02A2A2A2A0,P015540J0M540K015L50,Q0I8L0M8M0N8,P015540J0M540K015L50,P02A280J0H2A2A2A0L0H2A2A2A28,P0I5L015K5M0N50,Q0H8M0L808S80,P0H540L0L515R540,P0A2A0L0A2A2A2H2A2A2A2A2A2A2A0,O015540L0K545S540,P0I8N0g80,O01550M0K515S5,O0H2A0M02A2A202A2A2A2A2A2A2A,O0I5N015H5415S5,,:::::::::::::N0LEH0LE80H0LEH06EIE0EEC2EE,M03FKFC0FKFE007FKF03FJF3FF87FF,M02BABABAA0BABABAB01ABABABA0ABABAA2BA82BA,M03FKFE1FLF03FKFE1FJFE7FF0FHF,M02EE80EHE0EEC0EHE86EEC0EHE2EHEI06EE0EHE,M03FF80FFE3FF807FF8FHF81FFE7FF80H07FF1FFE,M03BB00BBA3BB803BA1BBA01BAABBA0I0HBA0BBA,M0HFE01FFE7FF007FF1FFC01FFCFFE0H01FFE1FFC,M0IEH0LEH0IE2EE802EE8EHEJ0IE2EE8,L01FFC01FFCFFE00FFE3FF803FF9FHF8003FFC3FF8,L01AB802BA9ABA00BA82BA003AB0BAB8003AB83AB0,L03FF807FF1FFE07FF87FF007FF0FHFE003FF87FF0,L02EE86EHE2EEC2EHE06EE006EE0EIEH02EE86EE0,L07FKFC3FKFC0FLFE07FHF807FF0FFE0,L03BABHBA03BABHBA00BABHBAB800BHB803BA1BB80,L0MF83FKFC0FLFC00FHFE0FFE1FFC0,L0IE02EEC6EE00EEC0EEC02EE800EIE0EHE2EEC0,L0HFE01FFC7FF00FFC1FFC03FF8007FHF1FFC3FFC0,L0BAA01AB8BAA01ABA3AB802BA8002BAB0BA82BA80,K01FFC03FFCFFE01FFC3FF807FF8001FHF3FF83FF80,K02EEC06EECEEC00EEC6EE006EE0I0IE6EE86EE,K03FF807FJF803FF8FFE007FE0I0HFE7FF87FF,K03AB002BB3AB802BB8ABA00BBA0H01ABA3AB0BAA,K07FF01FHF3FF803FF8FFE00FFE0H03FFC7FF0FFE,K06ELE6EE806EE0EHEH0HECEKE8EHE0EKE8K0MF87FF807FF1FFE01FFCFKF0FFE1FKF8K0ABABABA02BA00BAA0BA803AB8BABABA0AB83ABABAB0J01FKFC07FF00FFE1FFC03FF8FJF81FFC3FKF0,:::::::::::::::::::::::::::::^XA^LL0933")
*/

MSCBWrite("^XA~TA000~JSN^LT0^MMT^MNW^MTT^PON^PMN^LH0,0^JMA^PR4,4^MD0^JUS^LRN^CI0^XZ")
MSCBWrite("~DG000.GRF,78848,112,")
MSCBWrite(",::::::::::::::::::::::::L01FpRFE0,L0pUFE,K03FpUF80K07FpUFC0K0pWFE0:K0HFpT0FE0J01FC0pS07F0J01F80pS03F0J03F80pS03F0J03F0pT03F0:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::J01F0pT03F0J01F80pS03F0K0F80pS03E0K0pWFE0::K07FpUFC0K03FpUF80L0pUFE,,:::::::::::~DG001.GRF,03072,024,")
MSCBWrite(",::::::::::::W0J8P0T80,V0K5O0T5,V0A2A2A0N0A2A2A2A2A2A2A2,V0K5N015S5,V0L8N0T8,V0K540L015R54,U0H2A2A2A0L0A2A2A2A2A2A2A28,U015K5M0T50,V0L8M0U8,U0M5M0M540,U02A2A2A280K02A2A2A280,U0M5M0M540,U0N8L0N80,T015L540J045M50,T02A2A2A2A20J0I2A2A2A20,T015M5K0515L50,U0N8K0808M8,T0O5J01515L54,T0H2A2A2A2A0I02A0A2A2A2A0,T0O5J0H545L54,T0P8J0P8,S015N540H0H545M5,S0H2A2A2A2A2A0H0A2A2A2A2A2A,S0I515L5H0155415L540,T0H808L8I0I808M80,S0I505L5H0155005L540,S02A202A2A2A28022A002A2A2A2A0,S0H5405L5405H5H0N50,S0I8H0M808H8I0N8,R01550015K5415540015L50,R02A28022A2A2A202A20022A2A2A28,R01550015K5415540015L54,S0H8I0M808H8I0N8,R0H540015O5J0N5,R0A2A0H0A2A2A2A2A20I0A2A2A2A280,Q015540H0O540I015L5,R0I8J0O8K0N80,Q015540H015M540I015L540,Q0H2A0I02A2A2A2A280J0A2A2A2A20,Q01550I015M540J0M540,R0H8K0O8K0N80,Q0H540I015M5L0N50,Q02A0K02A2A2A2A0K02A2A2A2A0,P015540J0M540K015L50,Q0I8L0M8M0N8,P015540J0M540K015L50,P02A280J0H2A2A2A0L0H2A2A2A28,P0I5L015K5M0N50,Q0H8M0L808S80,P0H540L0L515R540,P0A2A0L0A2A2A2H2A2A2A2A2A2A2A0,O015540L0K545S540,P0I8N0g80,O01550M0K515S5,O0H2A0M02A2A202A2A2A2A2A2A2A,O0I5N015H5415S5,,:::::::::::::N0LEH0LE80H0LEH06EIE0EEC2EE,M03FKFC0FKFE007FKF03FJF3FF87FF,M02BABABAA0BABABAB01ABABABA0ABABAA2BA82BA,M03FKFE1FLF03FKFE1FJFE7FF0FHF,M02EE80EHE0EEC0EHE86EEC0EHE2EHEI06EE0EHE,M03FF80FFE3FF807FF8FHF81FFE7FF80H07FF1FFE,M03BB00BBA3BB803BA1BBA01BAABBA0I0HBA0BBA,M0HFE01FFE7FF007FF1FFC01FFCFFE0H01FFE1FFC,M0IEH0LEH0IE2EE802EE8EHEJ0IE2EE8,L01FFC01FFCFFE00FFE3FF803FF9FHF8003FFC3FF8,L01AB802BA9ABA00BA82BA003AB0BAB8003AB83AB0,L03FF807FF1FFE07FF87FF007FF0FHFE003FF87FF0,L02EE86EHE2EEC2EHE06EE006EE0EIEH02EE86EE0,L07FKFC3FKFC0FLFE07FHF807FF0FFE0,L03BABHBA03BABHBA00BABHBAB800BHB803BA1BB80,L0MF83FKFC0FLFC00FHFE0FFE1FFC0,L0IE02EEC6EE00EEC0EEC02EE800EIE0EHE2EEC0,L0HFE01FFC7FF00FFC1FFC03FF8007FHF1FFC3FFC0,L0BAA01AB8BAA01ABA3AB802BA8002BAB0BA82BA80,K01FFC03FFCFFE01FFC3FF807FF8001FHF3FF83FF80,K02EEC06EECEEC00EEC6EE006EE0I0IE6EE86EE,K03FF807FJF803FF8FFE007FE0I0HFE7FF87FF,K03AB002BB3AB802BB8ABA00BBA0H01ABA3AB0BAA,K07FF01FHF3FF803FF8FFE00FFE0H03FFC7FF0FFE,K06ELE6EE806EE0EHEH0HECEKE8EHE0EKE8K0MF87FF807FF1FFE01FFCFKF0FFE1FKF8K0ABABABA02BA00BAA0BA803AB8BABABA0AB83ABABAB0J01FKFC07FF00FFE1FFC03FF8FJF81FFC3FKF0,::::::::::::::::^XA^LL0933")
MSCBWrite("^PW933")
MSCBWrite("^FT32,864^XG000.GRF,1,1^FS")
MSCBWrite("^FT32,192^XG001.GRF,1,1^FS")
MSCBWrite("^FT56,262^A0N,50,50^FH\^FDLote: "+ _xEtiq[i][9] + "^FS")
MSCBWrite("^FT628,262^A0N,42,40^FH\^FDData: "+ _xEtiq[i][10] + "^FS")
MSCBWrite("^FT56,325^A0N,42,40^FH\^FDFornecedor: "+ _xEtiq[i][11] +"^FS")
MSCBWrite("^FT56,391^A0N,42,40^FH\^FDNota Fiscal: "+ _xEtiq[i][1] +"^FS")
MSCBWrite("^FT59,457^A0N,42,40^FH\^FDProduto: "+ _xEtiq[i][3] + "^FS")
MSCBWrite("^FT424,391^A0N,42,40^FH\^FDInvoice: "+ _xEtiq[i][2] +"^FS")
MSCBWrite("^FT543,453^A0N,42,40^FH\^FDTp: "+ _xEtiq[i][5] +"^FS")
MSCBWrite("^FT59,516^A0N,42,40^FH\^FDDescri\87\C6o: "+ _xEtiq[i][4] +"^FS")
MSCBWrite("^FT697,450^A0N,42,40^FH\^FDGrupo: "+ _xEtiq[i][6] +"^FS")
MSCBWrite("^FT56,581^A0N,42,40^FH\^FDOp: [                               ]^FS")
MSCBWrite("^FT56,651^A0N,42,40^FH\^FDData: [       /        /        ]^FS")
MSCBWrite("^BY2,3,94^FT147,782^BCN,,Y,N")
MSCBWrite("^FD>:"+_xEtiq[i][3]+_xEtiq[i][09]+"^FS")
MSCBWrite("^FT618,581^A0N,42,40^FH\^FDQuant.: "+  _xEtiq[i][8] +"^FS")
MSCBWrite("^FT240,154^A0N,58,50^FH\^FDNIPPON SEIKI DO BRASIL LTDA^FS")
MSCBWrite("^PQ1,0,1,Y^XZ")
MSCBWrite("^XA^ID000.GRF^FS^XZ")
MSCBWrite("^XA^ID001.GRF^FS^XZ")


MSCBEND()
MSCBCLOSEPRINTER()

Next

ELSE
 
Alert("Nใo ha etiquetas para imprimir...Verifique os parametros!")

ENDIF 
dbClearFil(NIL)
dbCloseArea()

Return
