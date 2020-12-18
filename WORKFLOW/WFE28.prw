#include "rwmake.ch"
#INCLUDE "Protheus.ch"   
#include "ap5mail.ch"     
#Include "TOPCONN.CH"
#Include "TBICONN.CH"



**********************
User Function WFE28()
**********************   
  
    cMen := ""


	vRespCC:={}
	
	vRespCC:= U_getVecResp("612") 
	sendMsg("612")
	                
	vRespCC:= U_getVecResp("211") 
	sendMsg("211")
	        
	vRespCC:= U_getVecResp("221") 
	sendMsg("221")
	        
	vRespCC:= U_getVecResp("231") 
	sendMsg("231")         
	
	vRespCC:= U_getVecResp("241") 
    sendMsg("241")
	        
	vRespCC:= U_getVecResp("616") 
	sendMsg("616") 
	
Return

//#########################################################
//########### FUNÇÕES DE FILTRO E ENVIO DE E-MAIL #########
//#########################################################

//****************************************
//* Função para filtro do Centro de Custo*
//****************************************

Static Function sendMsg()
***************************
  xData:=Dtoc(Ddatabase)
  If Len(vRespCC) > 0 
  
    oProcess := TWFProcess():New( "000003", "" )
    oProcess :NewTask( "100003", "\WORKFLOW\EMAIL2.HTM" )
    oProcess :cSubject := "WFE02 - Estorno de Movimentação de Perdas"
    oHTML    := oProcess:oHTML
        
    cMen := " <html>"
    cMen := " <head>"
    cMen := " <title> Produtos  Movimentados </title>"
    cMen := " </head>"  
    cMen += " <body>"
    cMen += ' <table border="1" width="1200">'
    cMen += ' <td colspan=13 align="center" >Relação de Produtos Movimentados em ' + xData +' </td></tr>'
    cMen += ' <tr >'
    cMen += ' <td align="center" width="2%" ><font size="1" face="Times">Nº da OP        </td>'
    cMen += ' <td align="center" width="2%" ><font size="1" face="Times">Produto         </td>'
    cMen += ' <td align="center" width="10%"><font size="1" face="Times">Descrição       </td>'
    cMen += ' <td align="center" width="2%" ><font size="1" face="Times">Quantidade      </td>'
    cMen += ' <td align="center" width="2%" ><font size="1" face="Times">CC              </td>'
    cMen += ' <td align="center" width="2%" ><font size="1" face="Times">Recurso         </td>'
    cMen += ' <td align="center" width="2%" ><font size="1" face="Times">Tp do Movi.     </td>'
    cMen += ' <td align="center" width="2%" ><font size="1" face="Times">Motivo          </td>'
    cMen += ' <td align="center" width="10%"><font size="1" face="Times">Observação      </td>'
    cMen += ' <td align="center" width="2%" ><font size="1" face="Times">Lote            </td>'
    cMen += ' <td align="center" width="2%" ><font size="1" face="Times">Local de Origem </td>'
    cMen += ' <td align="center" width="2%" ><font size="1" face="Times">Local de Destino</td>'
    cMen += ' <td align="center" width="2%" ><font size="1" face="Times">Usuario         </td>'
    cMen += ' </tr>'
       For x:= 1 to Len(vRespCC)
       cMen += ' <tr>'
       cMen += ' <td align="center" width="2%" ><font size="1" face="Times">'+ vRespCC[x][1] +'</td>'
       cMen += ' <td align="center" width="2%" ><font size="1" face="Times">'+ vRespCC[x][2] +'</td>'
       cMen += ' <td align="left  " width="10%"><font size="1" face="Times">'+ vRespCC[x][12]+'</td>'
       cMen += ' <td align="center" width="2%" ><font size="1" face="Times">'+ vRespCC[x][6] +'</td>'
       cMen += ' <td align="center" width="2%" ><font size="1" face="Times">'+ vRespCC[x][4] +'</td>'
       cMen += ' <td align="center" width="2%" ><font size="1" face="Times">'+ vRespCC[x][7] +'</td>'
       cMen += ' <td align="center" width="2%" ><font size="1" face="Times">'+ vRespCC[x][3] +'</td>'
       cMen += ' <td align="center" width="2%" ><font size="1" face="Times">'+ vRespCC[x][5] +'</td>'
       cMen += ' <td align="left  " width="10%"><font size="1" face="Times">'+ vRespCC[x][11]+'</td>'
       cMen += ' <td align="center" width="2%" ><font size="1" face="Times">'+ vRespCC[x][8] +'</td>'
       cMen += ' <td align="center" width="2%" ><font size="1" face="Times">'+ vRespCC[x][9] +'</td>'
       cMen += ' <td align="center" width="2%" ><font size="1" face="Times">'+ vRespCC[x][10]+'</td>'
       cMen += ' <td align="center" width="2%" ><font size="1" face="Times">'+ vRespCC[x][13]+'</td>'
       cMen += ' </tr>'
       
       Next
    cMen += ' </table>'
    cMen += " </body>"
    cMen += " </html>" 

    codRot:="WFE02"
    aDados:= u_MRecECC(CodRot)

    For i:=1 to Len(aDados)
      		If Alltrim(vRespCC[1][4]) = Alltrim(aDados[i][1])
      				oHtml:ValByName("MENS", cMen)
			    	oProcess:cTo  :=aDados[i][2]
				   cMailId := oProcess:Start()
			       ConOut("E-mail enviado com sucesso...")			  	  			
      		Endif
    Next

 EndIf

ConOut("Finalizou")

Return