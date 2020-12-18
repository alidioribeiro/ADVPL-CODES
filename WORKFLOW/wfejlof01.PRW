#INCLUDE "rwmake.ch"   
#include "ap5mail.ch"     
#Include "TOPCONN.CH"
#Include "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWFJL01     บAutor  ณJose Luis  		 บ Data ณ  16/10/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ ENVIA E-MAIL INFORMANDO OS MATERIAIS REJEITADOS PELO C.Q.  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP8  - Esse grava o e-mail enviado                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

************************************** 
  User Function WFJL01   
**************************************  
  
  
//  Local xDesc,cMen
//  Local xProd :=''
//  Local xForn := ''
//  Local xValor:=''

  Local xQuant_ent:=''
  Local xQuant_orig:=''
  Local xData:=''
  Local xDif :=''
  xPedMp:={}
  xPedImp:={}
  xPedGer:={}
  



    
    Prepare Environment Empresa "01" Filial "01" Tables "SC7"  // Usado apenas quando o uso for por agendamento
 	yData := Dtos(dDataBase) 


	cQuery := "SELECT C7_PRODUTO,C7_DESCRI,C7_UM,C7_QUANT,C7_QUJE,C7_NUM,C7_ITEM,C7_EMISSAO,C7_FORNECE,C7_LOJA,A2_NOME,C7_DTEMBAR,B1_TIPO,C7_FORNECE,B1_GRUPO "
    cQuery += " FROM DADOSAP10..SC7010 "
	cQuery += "  INNER JOIN DADOSAP10..SA2010 ON C7_FORNECE + C7_LOJA = A2_COD + A2_LOJA "
	cQuery += "  INNER JOIN DADOSAP10..SB1010 ON C7_PRODUTO = B1_COD "
	cQuery += " WHERE SC7010.D_E_L_E_T_ <> '*' AND  "
	cQuery += "  SA2010.D_E_L_E_T_ <> '*' AND  "
	cQuery += "  SB1010.D_E_L_E_T_ <> '*' AND  "
	  //   cQuery += "  B1_TIPO = 'MP' AND "      
	cQuery += "  C7_ENCER = '' AND C7_RESIDUO = '' AND " 
	cQuery += "  C7_QUANT > C7_QUJE AND " 
	cQuery += "  C7_DATPRF <= '" + yData + "'" 
	cQuery += " ORDER BY B1_TIPO,C7_PRODUTO,C7_NUM "
	
	
	TCQUERY cQuery Alias TJZ New
	     
	dbSelectArea("TJZ")
	dbGoTop()
	While !TJZ->(Eof())
	    
	      xQuant_ent:= Transform(C7_QUJE,"@E 999,999")
	      xQuant_orig:= Transform(C7_QUANT,"@E 999,999")
	      xData := Subs(C7_DTEMBAR,7,2) + "/" + Subs(C7_DTEMBAR,5,2)+ "/" + Subs(C7_DTEMBAR,3,2)
		  xDif:= Transform(C7_QUANT - C7_QUJE,"@E 999,999")

	      If (Alltrim(TJZ->B1_TIPO)="MP" .AND. Alltrim(TJZ->B1_GRUPO)<>"MPI" )
		
	           
		      AAdd(xPedMp,{C7_NUM,;		// [1] Condigo do Pedido      			
		                 C7_PRODUTO,;   // [2] Condigo do Produto      
		                 C7_UM,;        // [3] Unidade de medida
		                 C7_DESCRI,;    // [4] Descricao do produto
		                 B1_TIPO,;      // [5] Tipo do Material
		                 xData,;        // [6] Data prevista d
		                 xQuant_orig,;  // [6] Quantidade Solicitada
		                 xQuant_ent,;   // [7] Quantidade entregue                 
		                 xDif,;			// [8] Diferenca do Entre os qt entregue X Prevista
		                 A2_NOME,;      // [9] Fornecedor
   		                 C7_FORNECE+'-'+C7_LOJA }) // [11] Fornecedor


		    xPedMp:=aSort( xPedMp ,,,{ |x,y| x[6]+x[1] < y[6]+y[1] } )
        ElseIf Alltrim(TJZ->B1_GRUPO)<>"MPI" 
		      AAdd(xPedGer,{C7_NUM,;		// [1] Condigo do Pedido      			
		                 C7_PRODUTO,;   // [2] Condigo do Produto      
		                 C7_UM,;        // [3] Unidade de medida
		                 C7_DESCRI,;    // [4] Descricao do produto
		                 B1_TIPO,;      // [5] Tipo do Material
		                 xData,;        // [6] Data prevista d
		                 xQuant_orig,;  // [6] Quantidade Solicitada
		                 xQuant_ent,;   // [7] Quantidade entregue                 
		                 xDif,;			// [8] Diferenca do Entre os qt entregue X Prevista
		                 A2_NOME,;      // [9] Fornecedor
		                 C7_FORNECE+'-'+C7_LOJA})      // [10] Fornecedor/ Loja Fornecedora
			    xPedGer:=aSort( xPedGer ,,,{ |x,y| x[6]+x[1] < y[6]+y[1] } )
        EndIF
	    If (Alltrim(TJZ->B1_GRUPO)="MPI")  		    
			      AAdd(xPedImp,{C7_NUM,;		// [1] Condigo do Pedido      			
		                 C7_PRODUTO,;   // [2] Condigo do Produto      
		                 C7_UM,;        // [3] Unidade de medida
		                 C7_DESCRI,;    // [4] Descricao do produto
		                 B1_TIPO,;      // [5] Tipo do Material
		                 xData,;        // [6] Data prevista d
		                 xQuant_orig,;  // [6] Quantidade Solicitada
		                 xQuant_ent,;   // [7] Quantidade entregue                 
		                 xDif,;			// [8] Diferenca do Entre os qt entregue X Prevista
		                 A2_NOME,;      // [9] Fornecedor
		                 C7_FORNECE+'-'+C7_LOJA})      // [10] Fornecedor/ Loja Fornecedora
			    xPedImp:=aSort( xPedImp ,,,{ |x,y| x[6]+x[1] < y[6]+y[1] } )
	
        EndIF
		
		
		TJZ->(DbSkip())
	enddo     					
   	GeraHtml(xPedMp,"MATERIA-PRIMA","WFJL01C")
   	GeraHtml(xPedGer,"MATERIAL EM GERAL","WFJL01C")
   	GeraHtml(xPedImp,"MATERIAL IMPORTADO","WFJL01I")
	dbCloseArea("TJZ")
    dbCloseArea() 	
	

Return 
/***************************************************************************************************/
/*Fun็ใo que monta o html para o e-mail*************************************************************/
/***************************************************************************************************/
Static Function GeraHtml(ListaPed,Msg,CodRot)
	  If Len(ListaPed) > 0
	  
	    oProcess := TWFProcess():New( "000098", "Compras nao entregues" )
	    oProcess :NewTask( "100098", "\WORKFLOW\MT.htm" )
	    oProcess :cSubject :="("+Alltrim(CodRot)+")Materiais nใo entregues pelos fornecedores na data prevista -"+Msg
	    oHTML    := oProcess:oHTML 
	    
	    
	    cMen := " <html>"
	    cMen := " <head>"
	    cMen := " <title></title>"
	    cMen := " </head>"    
	    cMen += " <body>"
	    cMen += ' <table border="1" width="1250">'
	    cMen += ' <tr width="1250" align="center" >
	 //   cMen += ' <TD ><IMG src="\\Nsbsrv01\CORREIO\Workflow\Imagens\LogoNSB.JPG"></TD>'
	    cMen += ' <td colspan=10 >Materiais nใo entregues pelos fornecedores na data prevista</td></tr>' 
	    cMen += ' <tr >'
	    cMen += ' <td align="center" width="5%"bgcolor="#FFFFFF"><font size="1" face="Times">PEDIDO</font></td>'        //[1]
	    cMen += ' <td align="center" width="6%"bgcolor="#FFFFFF"><font size="1" face="Times">PRODUTO</font></td>'       //[2]
	    cMen += ' <td align="center" width="2%"bgcolor="#FFFFFF"><font size="1" face="Times">UM</font></td>'            //[3]
	    cMen += ' <td align="center" width="18%"bgcolor="#FFFFFF"><font size="1" face="Times">DESCRICAO</font></td>'    //[4]
	    cMen += ' <td align="center" width="2%"bgcolor="#FFFFFF"><font size="1" face="Times">TIPO</font></td>'          //[5] 
	    cMen += ' <td align="center" width="4%"bgcolor="#FFFFFF"><font size="1" face="Times">DATA PREVISTO</font></td>'	//[6]
	    cMen += ' <td align="center" width="5%"bgcolor="#FFFFFF"><font size="1" face="Times">QTD SOLICITADA</font></td>'//[7]
	    cMen += ' <td align="center" width="5%"bgcolor="#FFFFFF"><font size="1" face="Times">QTD ENTREGUE</font></td>'  //[8]
	    cMen += ' <td align="center" width="5%"bgcolor="#FFFFFF"><font size="1" face="Times">QTD RESTANDO</font></td>'  //[9] 
	    cMen += ' <td align="center" width="20%"bgcolor="#FFFFFF"><font size="1" face="Times">FORNECEDOR</font></td>'   //[10]
//	    cMen += ' <td align="center" width="3%"bgcolor="#FFFFFF"><font size="1" face="Times">LOJA</font></td>' 			//[11]
		cMen += ' </tr>'
	    For x:= 1 to Len(ListaPed) 
	      cMen += ' <tr>'
	      cMen += ' <td align="center" width="5%"bgcolor="#FFFFFF"><font size="1" face="Times">'+ListaPed[x][1]+'</font></td>'  //[1]
	      cMen += ' <td align="center" width="6%"bgcolor="#FFFFFF"><font size="1" face="Times">'+ListaPed[x][2]+'</font></td>'  //[2]
		  cMen += ' <td align="center" width="2%"bgcolor="#FFFFFF"><font size="1" face="Times">'+ListaPed[x][3]+'</font></td>'  //[3]
		  cMen += ' <td align="center" width="18%"bgcolor="#FFFFFF"><font size="1" face="Times">'+ListaPed[x][4]+'</font></td>' //[4]
	      cMen += ' <td align="center" width="2%"bgcolor="#FFFFFF"><font size="1" face="Times">'+ListaPed[x][5]+'</font></td>'  //[5]
	      cMen += ' <td align="center" width="5%"bgcolor="#FFFFFF"><font size="1" face="Times">'+ListaPed[x][6]+'</font></td>'  //[6]
	      cMen += ' <td align="center" width="5%"bgcolor="#FFFFFF"><font size="1" face="Times">'+ListaPed[x][7]+'</font></td>'  //[7]
	      cMen += ' <td align="center" width="3%"bgcolor="#FFFFFF"><font size="1" face="Times">'+ListaPed[x][8]+'</font></td>'  //[8]
	      cMen += ' <td align="center" width="5%"bgcolor="#FFFFFF"><font size="1" face="Times">'+ListaPed[x][9]+'</font></td>' //[9]
	      cMen += ' <td align="center" width="3%"bgcolor="#FFFFFF"><font size="1" face="Times">'+ListaPed[x][11]+"("+ListaPed[x][10]+")"+'</font></td>'
//	      cMen += ' <td align="center" width="4%"bgcolor="#FFFFFF"><font size="1" face="Times">'+xRej[x][11]+'</font></td>' //[11]
	      cMen += ' </tr>'
	    Next 
	    cMen += ' </table>'
	    cMen += " </body>"
	    cMen += " </html>" 
	    
	    oHtml:ValByName( "MENS", cMen)
		oProcess:cTo  := u_MontaRec(CodRot)
	 	
	    cMailId := oProcess:Start()
	  EndIf
Return	