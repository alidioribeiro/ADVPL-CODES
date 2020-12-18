#include "rwmake.ch"  
#Include "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  IMPETIQS   บAutor  ณJefferson Moreira   บ Data ณ  05/12/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Esse programa tem o objetivo de imprimir as etiquetas com  บฑฑ
ฑฑบ          ณ o codigo de barra dos itens de NF saida conforme parametrosบฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SigaFat                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function IMPETIQS()

Private oDlg := Nil

Pergunte("NFSIGW",.F.)

//Da Nota Fiscal ?    mv_par01
//Ate a Nota Fiscal ? mv_par02
//Da Serie ?          mv_par03
//Tipo Opera็ใo ?     mv_par04

@ 96,42 TO 323,505 DIALOG oDlg TITLE "Etiquetas de Saida"
@ 8,10 TO 84,222
@ 94,133 BMPBUTTON TYPE 5 ACTION Pergunte("NFSIGW")
@ 94,163 BMPBUTTON TYPE 1 ACTION ImpEtqSaida()
@ 94,193 BMPBUTTON TYPE 2 ACTION Close(oDlg)
@ 23,14 SAY "Esse programa tem o objetivo de imprimir as etiquetas com"
@ 33,14 SAY "o codigo de barra dos itens de NF saida conforme parametros"
@ 43,14 SAY "especificado pelo usuแrio."
@ 53,14 SAY ""
ACTIVATE DIALOG oDlg

Return nil

Static Function ImpEtqSaida()  


 cQuery := " Select "
 cQuery += " C6_PEDCLI,C6_TPEDIDO,C6_LINHA,F2_DOC,F2_SERIE,A7_PRODUTO,A7_CODCLI,A7_DESCCLI,C6_UM,A1_NREDUZ,C6_ENTREG,C6_HORA,C6_SETOR,SUM(C6_QTDVEN)AS C6_QTDVEN,C6_CLI,C6_LOJA,C6_ENTREGA "
 
 cQuery += " From DADOSAP10..SF2010 "
 cQuery += " INNER JOIN DADOSAP10..SC6010 ON F2_DOC = C6_NOTA    AND F2_SERIE = C6_SERIE"
 cQuery += " INNER JOIN DADOSAP10..SA1010 ON C6_CLI = A1_COD     AND C6_LOJA  = A1_LOJA"
 cQuery += " INNER JOIN DADOSAP10..SA7010 ON C6_CLI = A7_CLIENTE AND C6_LOJA  = A7_LOJA  AND C6_PRODUTO = A7_PRODUTO"
 
 cQuery += " WHERE " 
 cQuery += " SF2010. D_E_L_E_T_ <> '*'  AND "
 cQuery += " SC6010. D_E_L_E_T_ <> '*'  AND " 
 cQuery += " SA1010. D_E_L_E_T_ <> '*'  AND "  
 cQuery += " SA7010. D_E_L_E_T_ <> '*'  AND " 
 cQuery += " F2_DOC >='" + mv_par01 +"' AND "  
 cQuery += " F2_DOC <='" + mv_par02 +"' AND "  
 cQuery += " F2_SERIE ='" + mv_par03 +"'
 
 cQuery += " GROUP BY "
 cQuery += " C6_PEDCLI,C6_TPEDIDO,C6_LINHA,F2_DOC,F2_SERIE,A7_PRODUTO,A7_CODCLI,A7_DESCCLI,C6_UM,A1_NREDUZ,C6_ENTREG,C6_HORA,C6_SETOR,C6_CLI,C6_LOJA, C6_ENTREGA "
 
 cQuery += " Order By " 
 cQuery += " F2_DOC ASC " 
 
 cQuery := ChangeQuery(cQuery)

 TCQUERY cQuery Alias TAA New 

 
 dbSelectArea("TAA")
 dbGoTop()

While !EOF() 
 
 _NumPed := Subs(C6_PEDCLI,1,8) 
 _TpPed  := Subs(C6_TPEDIDO,1,2)
 _LinPed := Subs(C6_LINHA,1,6)
 _NumNF  := Subs(F2_DOC,1,6)
 _SerNF  := Subs(F2_SERIE,3,1) //Subs(F2_SERIE,1,1)+Subs(F2_SERIE,3,1) 06.03.07
 _Serie  := Subs(F2_SERIE,1,3)
 _CodPro := Subs(A7_CODCLI,1,20) + Space(5)
 _DesPro := Subs(A7_DESCCLI,1,25)
 _zQuant := C6_QTDVEN
 _jQuant := C6_QTDVEN
 _Um     := Subs(C6_UM,1,2)
 _Emp    := Subs(A1_NREDUZ,1,4)
 _DtEnt  := Subs(C6_ENTREG,7,2) + "/" + Subs(C6_ENTREG,5,2)+ "/" + Subs(C6_ENTREG,3,2)
 _HrEnt  := Subs(C6_HORA,1,2)+":"+Subs(C6_HORA,3,4)
 _Setor  := C6_SETOR
 _LocEntrega := C6_ENTREGA
 _CodNS  := A7_PRODUTO
 _Lotes  := Array(1,10) 
 _xLotes := 1
 _Clien  := C6_CLI
 _Loja   := C6_LOJA
 For x:=1 to 10
    _Lotes[1][x] := ""
 Next 
 
 dbSelectArea("SD2")
 dbSetOrder(3)
 dbSeek(xFilial("SD2") + _NumNF + _Serie + _Clien + _Loja + _CodNS)
   WHILE D2_COD == _CodNS
        If _xLotes < 11
         _Lotes [1][_xLotes] := D2_LOTECTL   
        Else 
        _xLotes++  
        Endif
   dbSkip()
   Enddo 
 
 dbSelectArea("SB1")
 dbSetOrder(1)
 dbSeek(xFilial("SB1") + _CodNS)         
 
 _xQuant := B1_QE * 24
 _xVol := Int(_zQuant /_xQuant)
 
 If _xVol <> _zQuant /_xQuant
    _xVol += 1
 Endif   
 
 
 dbSelectArea("TAA")
 
 For _Ent:= 1 to _xVol
    
   If _Ent <> _xVol
      _Quant1 := Transform (_xQuant ,"@E 999999999.999")
   
   Elseif _xVol == 1
        _Quant1 := Transform (_zQuant ,"@E 999999999.999") 
   
   Else
      _Quant1 := Transform (_jQuant ,"@E 999999999.999")                      
   Endif
   
   _jQuant -= _xQuant
   _Quant  := RetNum_(Val(_Quant1),12,3)
   
   MSCBPRINTER("Z4M","LPT1",,,)
   MSCBCHKStatus(.F.)
 
   MSCBBEGIN(1,6)
      
   MSCBWrite("^XA~TA000~JSN^LT0^MMT^MNW^MTT^PON^PMN^LH0,0^JMA^PR4,4^MD0^JUS^LRN^CI0^XZ^XA^LL1807^PW933")
   MSCBWrite("^FT68,1094^A0B,17,19^FH\^FDNRO. PEDIDO^FS")
   MSCBWrite("^FT66,344^A0B,17,21^FH\^FDNOTA FISCAL^FS")
   MSCBWrite("^FT76,1757^A0B,17,21^FH\^FDFORNECEDOR^FS")
   MSCBWrite("^FT139,1752^A0B,58,57^FH\^FDNIPPON SEIKI^FS")
   MSCBWrite("^FT132,347^A0B,58,57^FH\^FD"+_NumNF+"-"+_SerNF+"^FS")
   MSCBWrite("^FO648,28^GB0,1755,3^FS")
   MSCBWrite("^FO909,25^GB0,1767,6^FS")
   MSCBWrite("^FO781,33^GB0,1755,5^FS")
   MSCBWrite("^FO308,27^GB0,1755,5^FS")
   MSCBWrite("^FO46,26^GB0,1771,5^FS")
   MSCBWrite("^FT385,1704^A0B,58,57^FH\^FD"+ _CodPro+"^FS")
   MSCBWrite("^BY3,3,138^FT286,1298^BCB,,N,N")
   MSCBWrite("^FD>:"+ _NumPed+_TpPed+_LinPed+_NumNF+_SerNF+ "^FS")
   MSCBWrite("^BY3,3,133^FT532,1615^BCB,,N,N")
   MSCBWrite("^FD>:"+  _CodPro+_Quant+_Um  + "^FS")
   MSCBWrite("^FT334,1761^A0B,17,16^FH\^FDITEM^FS")
   MSCBWrite("^FT571,1768^A0B,17,16^FH\^FDDESCRI\80\C7O DO ITEM^FS")
   MSCBWrite("^FT628,1764^A0B,50,50^FH\^FD"+ _DesPro +"^FS")
   MSCBWrite("^FT564,886^A0B,17,16^FH\^FDQUANTIDADE^FS")
   MSCBWrite("^FT631,888^A0B,58,57^FH\^FD"+ _Quant1 +"^FS")
   MSCBWrite("^FT567,340^A0B,17,16^FH\^FDUN^FS")
   MSCBWrite("^FT627,308^A0B,58,57^FH\^FD"+ _Um +"^FS")
   MSCBWrite("^FT750,1698^A0B,58,57^FH\^FD"+ _Emp  + "^FS")
   MSCBWrite("^FT678,1761^A0B,17,16^FH\^FDEMPRESA^FS")
   MSCBWrite("^FT755,1415^A0B,58,57^FH\^FD"+ _DtEnt +"^FS")
   MSCBWrite("^FT681,1444^A0B,17,16^FH\^FDDATA DE ENTREGA^FS")
   MSCBWrite("^FT681,1052^A0B,17,21^FH\^FDHORA DE ENTREGA^FS")
   MSCBWrite("^FT755,995^A0B,58,57^FH\^FD"+ _HrEnt +"^FS")
   MSCBWrite("^FT752,587^A0B,58,57^FH\^FD"+ _Setor +"^FS")
   MSCBWrite("^FT683,614^A0B,17,24^FH\^FDSETOR^FS")
   MSCBWrite("^FT882,1761^A0B,58,57^FH\^FD"+ Strzero(_Ent,3) + "/"+ Strzero(_xVol,3) +"^FS")
   MSCBWrite("^FT813,1771^A0B,17,19^FH\^FDQTD/VOL^FS")
   MSCBWrite("^FT818,1440^A0B,17,16^FH\^FDOUTROS^FS")
   MSCBWrite("^FO780,694^GB133,0,3^FS")
   MSCBWrite("^FO655,695^GB133,0,3^FS")
   MSCBWrite("^FO652,1070^GB132,0,2^FS")
   MSCBWrite("^FO658,1463^GB249,0,3^FS")
   MSCBWrite("^FT139,1102^A0B,58,57^FH\^FD" +_NumPed+"-"+_TpPed+"-"+_LinPed+ "^FS")
   MSCBWrite("^FO47,23^GB863,0,5^FS")
   MSCBWrite("^FO46,1792^GB868,0,4^FS")
//   MSCBWrite("^FT843,1380^A0B,42,40^FH\^FD Lote(s): ^FS")
   MSCBWrite("^FT843,1229^A0B,42,40^FH\^FD"+ _Lotes[1][1] + "^FS")
   MSCBWrite("^FT842,998^A0B,42,40^FH\^FD" + _Lotes[1][2] + "^FS")
   MSCBWrite("^FT842,761^A0B,42,40^FH\^FD" + _Lotes[1][3] + "^FS")
   MSCBWrite("^FT840,528^A0B,42,40^FH\^FD" + _Lotes[1][4] + "^FS")
   MSCBWrite("^FT842,293^A0B,42,40^FH\^FD" + _Lotes[1][5] + "^FS")
   MSCBWrite("^FT894,1228^A0B,42,40^FH\^FD"+ _Lotes[1][6] + "^FS")
   MSCBWrite("^FT887,588^A0B,58,57^FH\^FD" +_LocEntrega+"^FS")
   MSCBWrite("^FT818,617^A0B,17,16^FH\^FDLOCAL DE ENTREGA^FS")   
   MSCBWrite("^PQ1,0,1,Y^XZ") 
   MSCBEND()
   MSCBCLOSEPRINTER()
 
 Next
 
 TAA->(dbSkip())
EndDo
 
dbClearFil(NIL)
dbCloseArea()

Return

Static Function RetNum_(nCampo,nTam,nDec)
   Local cRet
   
   cRet := StrZero(nCampo * If(nDec==Nil,1,10**nDec),nTam)

Return(cRet)