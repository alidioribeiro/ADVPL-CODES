#INCLUDE "rwmake.ch"    
#include "ap5mail.ch"     
#Include "TOPCONN.CH"
#Include "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWFE10     บAutor  ณJefferson Moreira   บ Data ณ  21/02/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ ENVIA PARA OS RESPONSAVEIS A RELACAO DE SOLICITACOES ABER- บฑฑ
ฑฑบ          ณ TAS DO DIA ANTERIOR.                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP8  - Esse grava o e-mail enviado                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

********************************
  User Function wfe10
********************************  
  aProd := {}
  cProd := ''
  cMen  := ''
   
  Prepare Environment Empresa "01" Filial "01" Tables "SCP"  // Usado apenas quando o uso for por agendamento
  yData := Dtos(dDataBase) 

cQuery := " Select "
cQuery += " CP_OP,CP_PRODUTO,B1_DESC,CP_QUANT,CP_QUJE,CP_NUM,CP_ITEM,CP_EMISSAO,CP_LOCAL,CP_CC,CP_SOLICIT,CP_HORA "
cQuery += " FROM DADOSAP10..SCP010 "
cQuery += "  INNER JOIN DADOSAP10..SB1010 ON CP_PRODUTO = B1_COD "
cQuery += " WHERE "
cQuery += "  SCP010.D_E_L_E_T_ <> '*' AND  "
cQuery += "  SB1010.D_E_L_E_T_ <> '*' AND  "
cQuery += "  CP_STATUS <> 'E' AND "
cQuery += "  CP_EMISSAO < '" + yData + "'" 
cQuery += " ORDER BY CP_NUM,CP_ITEM,CP_PRODUTO "

cQuery := ChangeQuery(cQuery)

TCQUERY cQuery Alias TAA New 

dbSelectArea("TAA")
dbGoTop()

While !TAA->(Eof())
    
      xEmissao := Subs(CP_EMISSAO,7,2) + "/" + Subs(CP_EMISSAO,5,2)+ "/" + Subs(CP_EMISSAO,3,2)
      xQuant   := Transform (CP_QUANT, "@E 999,999.99999")
      xQuje    := Transform (CP_QUJE,  "@E 999,999.99999") 
      AAdd(aProd,{CP_NUM,CP_ITEM,CP_OP,CP_PRODUTO,B1_DESC,xEmissao,xQuant,xQuje,CP_CC,CP_SOLICIT,CP_HORA})
    
      TAA->(DbSkip())
Enddo

IF Len(aProd) > 0	
	
	aSCC:= FiltrarCC("211")
	sendMsg(.F.)
	aSCC:= FiltrarCC("221")
	sendMsg(.F.)

   	aSCC:=aProd
   	sendMsg(.T.)
    dbCloseArea()
   

ENDIF

Return


************************************
Static Function FiltrarCC(CC)
************************************
xFilter:={}

For i:=1 to Len(aProd)

    If aProd[i][9] <> CC
		Loop
	Else
			
		AAdd(xFilter,{aProd[i][1],;  // Numero da Solicitacao   
			          aProd[i][2],;  // Item   
			          aProd[i][3],;  // Op  
			          aProd[i][4],;  // Cod. Prod   
			          aProd[i][5],;  // Desc. Prod
			          aProd[i][6],;  // Emissao  
			          aProd[i][7],;  // Quantidade  
			          aProd[i][8],;  // Quantidade Entregue 
			          aProd[i][9],;  // centro de Custo 
			          aProd[i][10],; // Solicitante   
			          aProd[i][11]}) // Hora da Solicitacao  
			               
			
	Endif
	
Next

Return xFilter




//*********************************
//* Fun็ใo para envio de messagens*
//*********************************
**********************************
Static Function sendMsg(gerencia)
**********************************

If Len(aSCC) > 0
  
    oProcess := TWFProcess():New( "000001", "Solicitacoes em Aberto" )
    oProcess :NewTask( "100001", "\WORKFLOW\Solicitacoes.HTM" )
    oProcess :cSubject := "WFE10 - Solicita็๕es Abertas"
    oHTML    := oProcess:oHTML 
    
    
    cMen := " <html>"
    cMen += " <head>"
    cMen += " <title></title>"
    cMen += " </head>"    
    cMen += " <body>"
    cMen += ' <table border="1" width="900">'
    cMen += ' <tr width="900" align="center" >'
 //   cMen += ' <TD ><IMG src="\\Nsbsrv01\CORREIO\Workflow\Imagens\LogoNSB.JPG"></TD>'
    cMen += ' <td colspan=11 > Relacao das Solicitacoes em Aberto </td></tr>' 
    cMen += ' <tr >'
    cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">Num. SA     </font></td>'  //[1]
    cMen += ' <td align="center" width="3%"  bgcolor="#FFFFFF"><font size="1" face="Times">Item SA     </font></td>'  //[2]
    cMen += ' <td align="center" width="6%"  bgcolor="#FFFFFF"><font size="1" face="Times">OP          </font></td>'  //[3]
    cMen += ' <td align="center" width="8%"  bgcolor="#FFFFFF"><font size="1" face="Times">Produto     </font></td>'  //[4]
    cMen += ' <td align="center" width="25%" bgcolor="#FFFFFF"><font size="1" face="Times">Descri็ใo   </font></td>'  //[5]
    cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">Emissใo     </font></td>'  //[6] 
    cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">Quant.Ori   </font></td>'  //[7]
    cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">Quant.Ent   </font></td>'  //[8]
    cMen += ' <td align="center" width="2%"  bgcolor="#FFFFFF"><font size="1" face="Times">C.C.        </font></td>'  //[9]
    cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">Solicitante </font></td>'  //[10]
    cMen += ' <td align="center" width="2%"  bgcolor="#FFFFFF"><font size="1" face="Times">Hora        </font></td>'  //[11]
    cMen += ' </tr>'
    For x:= 1 to Len(aSCC) 
      cMen += ' <tr>'
      cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+aSCC[x][1]+'</font></td>'  //[1]
      cMen += ' <td align="center" width="3%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+aSCC[x][2]+'</font></td>'  //[2]
      cMen += ' <td align="center" width="6%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+aSCC[x][3]+'</font></td>'  //[3]
      cMen += ' <td align="center" width="8%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+aSCC[x][4]+'</font></td>'  //[4]
      cMen += ' <td align="left  " width="25%" bgcolor="#FFFFFF"><font size="1" face="Times">'+aSCC[x][5]+'</font></td>'  //[5]
      cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+aSCC[x][6]+'</font></td>'  //[6] 
      cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+aSCC[x][7]+'</font></td>'  //[7]
      cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+aSCC[x][8]+'</font></td>'  //[8]
      cMen += ' <td align="center" width="2%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+aSCC[x][9]+'</font></td>'  //[9]
      cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+aSCC[x][10]+'</font></td>' //[10]
      cMen += ' <td align="center" width="2%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+aSCC[x][11]+'</font></td>' //[11]
      cMen += ' </tr>'
    Next 
    cMen += ' </table>'
    cMen += " </body>"
    cMen += " </html>" 
	codRot:="WFE10"
    aDados:= u_MRecECC(CodRot)

    For i:=1 to Len(aDados)
      		If Alltrim(aSCC[1][9]) = Alltrim(aDados[i][1])  .or.   (Gerencia .and. Empty(aDados[i][1])   )
      				oHtml:ValByName("MENS", cMen)
			    	oProcess:cTo  :=aDados[i][2]
				   cMailId := oProcess:Start()
			       ConOut("E-mail enviado com sucesso...")			  	  			
      		Endif                 
    Next


/*

	if gerencia         // Gerencial
	
		oHtml:ValByName("MENS", cMen)
	  	oProcess:cTo  := "paulo@nippon-seikibr.com.br;rosicleide@nippon-seikibr.com.br;marina@nippon-seikibr.com.br"
        oProcess:cCC  := "edyikeoka@nippon-seikibr.com.br;ruthf@nippon-seikibr.com.br" // Com Copia
      //  oProcess:cBCC := "marcus@nippon-seikibr.com.br" // Com Copia Oculta
		cMailId := oProcess:Start()
	
	else                                          
	
	   IF Alltrim(aSCC[1][9]) == "211"
		
		  oHtml:ValByName("MENS", cMen)
	  	  oProcess:cTo  := "wagner@nippon-seikibr.com.br;allan@nippon-seikibr.com.br"
		  cMailId := oProcess:Start()		
		
	   ElseIF Alltrim(aSCC[1][9]) == "221"
		
		  oHtml:ValByName("MENS", cMen)
	      oProcess:cTo  := "clavis@nippon-seikibr.com.br"
		  cMailId := oProcess:Start()
		
       EndIf*/
//	Endif
EndIf

Return