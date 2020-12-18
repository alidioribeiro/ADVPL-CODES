#INCLUDE "rwmake.ch"   
#include "ap5mail.ch"     
#Include "TOPCONN.CH"
#Include "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWFJL01     บAutor  ณAglair 		 บ Data ณ  16/10/08   บฑฑ
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
  User Function WFE029  
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


	cQuery := "SELECT C7_PRODUTO,C7_DESCRI,C7_UM,C7_QUANT,C7_QUJE,C7_NUM,C7_ITEM,C7_EMISSAO,C7_FORNECE,C7_LOJA,A2_NOME,C7_DATPRF,B1_TIPO,C7_FORNECE,B1_GRUPO, "
    cQuery += " A2_EMAIL,A2_EMAILS,A2_NOME,C7_DTEMBAR  "
    cQuery += " FROM "+RetSqlName("SC7")
	cQuery += "  INNER JOIN "+RetSqlName("SA2")+" ON  A2_COD =C7_FORNECE  AND A2_LOJA=C7_LOJA "
	cQuery += "  INNER JOIN "+RetSqlName("SB1")+" ON C7_PRODUTO = B1_COD "
	cQuery += " WHERE "+RetSqlName("SC7")+".D_E_L_E_T_ <> '*' AND  "
	cQuery += RetSqlName("SA2")+".D_E_L_E_T_ <> '*' AND  "
	cQuery += RetSqlName("SA2")+".D_E_L_E_T_ <> '*' AND  "                                                        		
	  //   cQuery += "  B1_TIPO = 'MP' AND "      
	cQuery += "  C7_ENCER = '' AND C7_RESIDUO = '' AND A2_EST<>'AM' AND C7_CONFEMB<>'S' AND A2_ENVWORK='S' AND" 
	cQuery += "  C7_QUANT > C7_QUJE AND " 
	cQuery += "  C7_DTEMBAR <= '" + yData + "'" 
	cQuery += " ORDER BY A2_COD,B1_TIPO,C7_PRODUTO,C7_NUM "
	
	
	TCQUERY cQuery Alias TJZ New
	     
	dbSelectArea("TJZ")
	dbGoTop()
    CodAnt:=""        
    xPedMp:={}
    While !TJZ->(Eof())
	
	      xQuant_ent:= Transform(C7_QUJE,"@E 999,999")
	      xQuant_orig:= Transform(C7_QUANT,"@E 999,999")
	      xDataEmb := Subs(C7_DTEMBAR,7,2) + "/" + Subs(C7_DTEMBAR,5,2)+ "/" + Subs(C7_DTEMBAR,3,2)
	      xDataPrf := Subs(C7_DATPRF,7,2) + "/" + Subs(C7_DATPRF,5,2)+ "/" + Subs(C7_DATPRF,3,2)
		  xDif:= Transform(C7_QUANT - C7_QUJE,"@E 999,999")
          CodAnt:=C7_FORNECE
	 //	  xPedMP:={}

          //If Empty(CodAnt) .and. CodAnt<>C7_FORNECE .and. Len(xPedMp)>0
		   //	GeraHtml(xPedMp,"","WFE29")
	     // EndIf
	      //If (Alltrim(TJZ->B1_TIPO)="MP" )
			           
		      AAdd(xPedMp,{C7_NUM,;		// [1] Condigo do Pedido      			
		                 C7_PRODUTO,;   // [2] Condigo do Produto      
		                 C7_UM,;        // [3] Unidade de medida
		                 C7_DESCRI,;    // [4] Descricao do produto
		                 B1_TIPO,;      // [5] Tipo do Material
		                 xDataEmb,;        // [7] Data prevista de Embarque
		                 xDataPrf,;        // [6] Data prevista de Chegada
		                 xQuant_orig,;  // [8] Quantidade Solicitada
		                 xQuant_ent,;   // [9] Quantidade entregue                 
		                 xDif,;			// [10] Diferenca do Entre os qt entregue X Prevista
   		                 Alltrim(A2_EMAIL)+";"+alltrim(A2_EMAILS),; //      [11] Emails
		                 A2_NOME,;      // [12] Fornecedor
   		                 C7_FORNECE+'-'+C7_LOJA,;// [13] Fornecedor
   		                 .F. }) //Verifica se o e-mail jแ foi enviado


		    xPedMp:=aSort( xPedMp ,,,{ |x,y| x[6]+x[1] < y[6]+y[1] } )
        //EndIF
        //CodAnt:=C7_FORNECE
		TJZ->(DbSkip())
	enddo     					
	ListaPed:={}
	Email:=""                                    
    xPedMp:=aSort( xPedMp ,,,{ |x,y| x[11] < y[11] } )          
    if Len(xPedMp)>0
       Email:=xPedMp[1][11]
    EndIf 
    For i:=1 to len(xPedMp)
       if Alltrim(Email)==Alltrim(xPedMp[i][11]) 
			aadd(ListaPed,xPedMp[I])
//			xPedMp[i][14]:=.T.
        Elseif Alltrim(Email)<>Alltrim(xPedMp[i][11])  
	  	   GeraHtml(ListaPed,"","WFE29")
		   ListaPed:={} 
		   aadd(ListaPed,xPedMp[I])
		EndIf
        Email:=xPedMp[i][11]
    Next


  if Len(ListaPed)>0
   	GeraHtml(ListaPed,"","WFE29")
   EndIf   	
   dbCloseArea("TJZ")
   dbCloseArea() 	

Return 
/***************************************************************************************************/
/*Fun็ใo que monta o html para o e-mail*************************************************************/
/***************************************************************************************************/
Static Function GeraHtml(ListaPed,Msg,CodRot)
	  If Len(ListaPed) > 0
	  
	    oProcess := TWFProcess():New( "000098", "Data de Embarque Nใo Confirmada" )
	    oProcess :NewTask( "100098", "\WORKFLOW\CONTEMB.htmL" )
	    oProcess :cSubject :="Informativo da Nippon Seiki para "+ListaPed[Len(ListaPed)][12]
	    oHTML    := oProcess:oHTML 
	    
	    
	    cMen := " <html>"
	    cMen := " <head>"
	    cMen := " <title></title>"
	    cMen := " </head>"    
	    cMen += " <body>"
	    cMen += ' <table border="1" width="1250">'
	    cMen += ' <tr width="1250" align="center" >
	 //   cMen += ' <TD ><IMG src="\\Nsbsrv01\CORREIO\Workflow\Imagens\LogoNSB.JPG"></TD>'
	    cMen += ' <td colspan=10 >Nใo hแ confirma็ใo do embarque dos pedidos abaixo relacionado</td></tr>' 
	    cMen += ' <tr >'
	    cMen += ' <td align="center" width="5%"bgcolor="#FFFFFF"><font size="1" face="Times">PEDIDO</font></td>'        //[1]
	    cMen += ' <td align="center" width="6%"bgcolor="#FFFFFF"><font size="1" face="Times">PRODUTO</font></td>'       //[2]
	    cMen += ' <td align="center" width="2%"bgcolor="#FFFFFF"><font size="1" face="Times">UM</font></td>'            //[3]
	    cMen += ' <td align="center" width="18%"bgcolor="#FFFFFF"><font size="1" face="Times">DESCRICAO</font></td>'    //[4]
	    cMen += ' <td align="center" width="2%"bgcolor="#FFFFFF"><font size="1" face="Times">TIPO</font></td>'          //[5] 
	    cMen += ' <td align="center" width="4%"bgcolor="#FFFFFF"><font size="1" face="Times">EMBARQUE PREVISTO</font></td>'	//[6]
	    cMen += ' <td align="center" width="4%"bgcolor="#FFFFFF"><font size="1" face="Times">CHEGADA  PREVISTA</font></td>'	//[6]
	    cMen += ' <td align="center" width="5%"bgcolor="#FFFFFF"><font size="1" face="Times">QTD SOLICITADA</font></td>'//[7]
	    cMen += ' <td align="center" width="5%"bgcolor="#FFFFFF"><font size="1" face="Times">QTD ENTREGUE</font></td>'  //[8]
	    cMen += ' <td align="center" width="5%"bgcolor="#FFFFFF"><font size="1" face="Times">QTD PENDENTE</font></td>'  //[9] 
//	    cMen += ' <td align="center" width="20%"bgcolor="#FFFFFF"><font size="1" face="Times">FORNECEDOR</font></td>'   //[10]
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
	      cMen += ' <td align="center" width="3%"bgcolor="#FFFFFF"><font size="1" face="Times">'+ListaPed[x][10]+'</font></td>'
//	      cMen += ' <td align="center" width="4%"bgcolor="#FFFFFF"><font size="1" face="Times">'+xRej[x][11]+'</font></td>' //[11]
	      cMen += ' </tr>'
	    Next 
	    cMen += ' </table>'
	    cMen += " </body>"
	    cMen += " </html>" 
	    Email:=u_MontaRec(CodRot)+";"+ListaPed[Len(ListaPed)][11]
//        Email:="aishii@nippon-seikibr.com.br"
	    oHtml:ValByName( "MENS", cMen) 
	    oHtml:ValByName( "EMAIL",Email ) 
	    oProcess:cTo  := email
	    cMailId := oProcess:Start()
	  EndIf                                                              
Return	
/*
	cUser := Subs(cUsuario,7,15)
	oProcess:ClientName(cUser)
	Mto:= u_MontaRec(CodRot)
 	oProcess:cTo  :=Mto


    cMailId := oProcess:Start()
    */
