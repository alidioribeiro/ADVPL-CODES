#INCLUDE "rwmake.ch"   
#INCLUDE "Protheus.ch"   
#include "ap5mail.ch"     
#Include "TOPCONN.CH"
#Include "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWFE14     บAutor  ณJefferson Moreira   บ Data ณ  29/04/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ INFORMA OS PRODUTOS QUE O ESTOQUE ATUAL ESTA MENOR QUE     บฑฑ
ฑฑบ          ณ O ESTOQUE DE SEGUNRACA.                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ PROTHEUS 8.11                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

********************************
  User Function WFJL
********************************  
  Local aEnvia := {}
  Local cMen 
    
  Prepare Environment Empresa "01" Filial "01" Tables "SB1"  // Usado apenas quando o uso for por agendamento
  /*
  cQuery := " SELECT B1_COD,B1_DESC,B1_UM,B1_TIPO,B1_GRUPO,B1_MODELO,B2_QATU,B2_QEMP,B2_QATU-B2_QEMP as B1_DISP,B1_ESTSEG "
  cQuery += " FROM SB1010 "
  cQuery += " INNER JOIN SB2010 ON B1_COD = B2_COD AND B2_LOCAL = '01' "
  cQuery += " WHERE B1_TIPO = 'MP' "
  cQuery += " AND  B1_MSBLQL <> '1' "
  cQuery += " AND  (B2_QATU+B2_QEMP) <= B1_ESTSEG "
  cQuery += " AND  SB1010.D_E_L_E_T_ = ' ' "
  cQuery += " AND  SB2010.D_E_L_E_T_ = ' ' "                                                                     	
  
  */
  /*
  cQuery := " SELECT B1_COD,B1_DESC,B1_UM,B1_TIPO,B1_GRUPO,B2_LOCAL,B1_MODELO,B1_ESTSEG,B2_QATU,C7_NUM,C7_DATPRF,C7_QUANT-C7_QUJE AS SALDO, "
  cQuery += " ( SELECT B2_QEMP FROM SB2010 WHERE B1_COD = B2_COD AND B2_LOCAL = '10' AND SB2010. D_E_L_E_T_ <> '*' AND SB1010.D_E_L_E_T_ <> '*') AS B2_QEMP "
  cQuery += " FROM SB1010 "
  cQuery += " LEFT JOIN SC7010 ON B1_COD = C7_PRODUTO AND C7_ENCER <> 'E' AND C7_RESIDUO <> 'S' AND  SC7010.D_E_L_E_T_ <> '*' "
  cQuery += " INNER JOIN SB2010 ON B1_COD = B2_COD AND B2_LOCAL = '01' "
              
  cQuery += " WHERE  B1_TIPO = 'MP' "
  cQuery += " AND  (B2_QATU+B2_QEMP) <= B1_ESTSEG "
  cQuery += " AND  B1_MSBLQL <> '1' "
  cQuery += " AND  B1_ESTSEG > 0 "
  cQuery += " AND  SB1010.D_E_L_E_T_ <> '*' "
  cQuery += " AND  SB2010.D_E_L_E_T_ <> '*' " 
   
  cQuery += " ORDER BY B1_COD,C7_DATPRF " */
     cQuery := " SELECT C7_PRODUTO,C7_DESCRI,C7_UM,C7_QUANT,C7_QUJE,C7_NUM,C7_ITEM,C7_EMISSAO,C7_FORNECE,C7_LOJA,A2_NOME,C7_DATPRF "
     cQuery += " FROM SC7010 "
     cQuery += "  INNER JOIN SA2010 ON C7_FORNECE + C7_LOJA = A2_COD + A2_LOJA "
     cQuery += " WHERE  SC7010.D_E_L_E_T_ <> '*' AND SA2010.D_E_L_E_T_ <> '*' AND  "
     cQuery += "  C7_ENCER = '' AND C7_RESIDUO = '' AND " 
     cQuery += "  C7_QUANT > C7_QUJE AND  " 
     cQuery += "  C7_DATPRF <= '20081017' "
     cQuery += " ORDER BY C7_NUM,C7_ITEM  "
  
  cQuery := ChangeQuery(cQuery)

  TCQUERY cQuery Alias TB1 New
  qout("foi doido...")  
  DbSelectArea("TB1")
  DbGotop()
  While !TB1->(Eof())
   // if !empty(C7_DATPRF) 
   //    xData  := Subs(C7_DATPRF,7,2) + "/" + Subs(C7_DATPRF,5,2)+ "/" + Subs(C7_DATPRF,3,2)
   //    xSaldo := TRANSFORM(SALDO,"@E 99,999,999.99 ")     
   // Else
   //   xData  := ''
   //   xSaldo := ''
   // Endif  
   // DISP := B2_QATU-B2_QEMP
   xQuant_ent:= Transform(C7_QUJE,"@E 999,999")
      xQuant_orig:= Transform(C7_QUANT,"@E 999,999")
      xData := Subs(C7_DATPRF,7,2) + "/" + Subs(C7_DATPRF,5,2)+ "/" + Subs(C7_DATPRF,3,2)
	  xDif:= Transform(C7_QUANT - C7_QUJE,"@E 999,999")
    
      qout("acumulou doido...")    
      AAdd(aEnvia,{C7_PRODUTO,;    // [1] Condigo do Produto      
                 C7_DESCRI,;    // [2] Descricao
                 C7_UM,;        // [3] Unidade de medida
                 xQuant_orig,;  // [4] Quantidade Solicitada
                 xQuant_ent,;   // [5] Quantidade entregue                 
                 xDif,;			// [6] Diferenca do Entre os qt entregue X Prevista
                 A2_NOME,;      // [7] Fornecedor
                 xData }) 	    // [8] Data Prevista de entega
  
    
    TB1->(DbSkip())
  End
 qout(Len(aEnvia))
    
  If Len(aEnvia) > 0
  qout("enviando doido...")
    oProcess := TWFProcess():New( "000009", "Estoque de Seguranca" )
    oProcess :NewTask( "100009", "\WORKFLOW\ESTSEG.HTM" )
    oProcess :cSubject := "TESTE"
    oHTML    := oProcess:oHTML 
    
 
    
    cMen := " <html>"
    
    cMen += " <body>"
    cMen += ' <table border="1" width="1150">'
    cMen += ' <tr width="1150" align="center" >'
    cMen += ' <td colspan=14 > Rela็ใo de Produtos </td></tr>' 
    cMen += ' <tr >'
    
    cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Codigo          </Blink></font></td>'
    cMen += ' <td align="center" width="20%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Descri็ใo       </Blink></font></td>'
    cMen += ' <td align="center" width="02%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>UM              </Blink></font></td>'
    cMen += ' <td align="center" width="02%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Tipo            </Blink></font></td>'
    cMen += ' <td align="center" width="02%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Grupo           </Blink></font></td>'
    cMen += ' <td align="center" width="02%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Local           </Blink></font></td>'
    cMen += ' <td align="center" width="08%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Modelo          </Blink></font></td>'
    cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Quant Atual     </Blink></font></td>'
    cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Quant Empenhada </Blink></font></td>'
    cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Quant Disponivel</Blink></font></td>'
    cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Est. Seguran็a  </Blink></font></td>'
    cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Pedido </Blink> </font></td>'
    cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Dt.Prev. Cheg   </Blink></font></td>'
    cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Saldo do Pedido </Blink></font></td>'
    cMen += ' </tr>'
    For x:= 1 to Len(aEnvia) 
      cMen += ' <tr>'
      
      cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+aEnvia[x][1]+'</Blink></font></td>'
      cMen += ' <td align="center" width="20%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+aEnvia[x][2]+'</Blink></font></td>'
      cMen += ' <td align="center" width="02%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+aEnvia[x][3]+'</Blink></font></td>'
      cMen += ' <td align="center" width="02%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+aEnvia[x][4]+'</Blink></font></td>'
      cMen += ' <td align="center" width="02%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+aEnvia[x][5]+'</Blink></font></td>'
      cMen += ' <td align="center" width="02%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+aEnvia[x][6]+'</Blink></font></td>'
      cMen += ' <td align="center" width="08%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+aEnvia[x][7]+'</Blink></font></td>'
      cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+aEnvia[x][8]+'</Blink></font></td>'
      cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+""+'</Blink></font></td>'
      cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+""+'</Blink></font></td>'
      cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+""+'</Blink></font></td>'
      cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+""+'</Blink></font></td>'
      cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+""+'</Blink></font></td>'
      cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+""+'</Blink></font></td>'
      cMen += ' </tr>'
    Next 
    cMen += ' </table>'
    cMen += " </body>"
    cMen += " </html>" 
    
    oHtml:ValByName( "MENS", cMen)
   // oProcess:ClientName( Subs(cUsuario,7,15) )
    oProcess:cTo  := "jluis@nippon-seikibr.com.br"
 //   oProcess:cCC  := "paulo@nippon-seikibr.com.br" // Com Copia
//    oProcess:cTo := "jmoreira@nippon-seikibr.com.br" // Com Copia Oculta
    //oProcess:ATTACHFILE(cArq) - ANEXA UM ARQUIVO <CAMINHO + NOME DO ARQUIVO>
    cMailId := oProcess:Start()
   qout("E-mail enviado com sucesso!!!")
  EndIf
 
Return