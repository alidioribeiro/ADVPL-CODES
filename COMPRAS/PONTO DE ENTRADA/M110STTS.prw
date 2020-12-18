
#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#include "ap5mail.ch"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"

/**********************************************************************************/
/*Desenvolvedor: Rodovaldo                                  ***********************/
/*Objetivo: Emitir WorkFlow da Solicitacao na Confirmacao da Solicitacao     ******/                     
/**********************************************************************************/
User Function M110STTS()
Local cQuery := "" 
Local cAlias := Alias()
Local lProcessa := .T. //.F.
Private aEnvia := {}      
Private cNumSol	:= Paramixb[1]
Private nOpt		:= Paramixb[2]

/*If nOpt == 3 .Or. nOpt == 4 .Or. nOpt == 2
   lProcessa := .T.
Endif*/
If lProcessa
		cQuery := " SELECT AK_COD AS CODAPROV,AK_USER AS CODAPRVUSR,AK_NOME AS NOMEAPROV,C1_SOLICIT,C1_USER,C1_EMISSAO,C1_NUM,C1_ITEM,C1_PRODUTO,C1_DESCRI,C1_UM,C1_QUANT,"
		cQuery += " SUBSTRING(C1_DATPRF,7,2)+'/'+SUBSTRING(C1_DATPRF,5,2)+'/'+SUBSTRING(C1_DATPRF,1,4) AS C1_DATPRF,C1_CONTA,C1_CC,C1_CONTA "
		cQuery += " FROM SC1010 SC1 "
		cQuery += " LEFT OUTER JOIN SAK010 SAK ON SAK.AK_COD = SC1.C1_CODAPRV "
		cQuery += " WHERE SAK.D_E_L_E_T_<>'*' AND SC1.D_E_L_E_T_<>'*' AND C1_APROV ='B' AND C1_NUM='"+cNumSol+"'"
		TCQUERY cQuery New Alias "TMOV" 
		
		DbSElectArea("TMOV")                                                      
		DbGotop()      
		cSolici            := TMOV->C1_SOLICIT
		cEmissao           := Substring(TMOV->C1_EMISSAO,7,2)+"/"+Substring(TMOV->C1_Emissao,5,2)+"/"+Substring(TMOV->C1_Emissao,1,4)
		_email_Solicitante := UsrRetMail(TMOV->C1_USER)
		_email_Aprovador   := UsrRetMail(TMOV->CODAPRVUSR)
		cAprovador         := TMOV->CODAPROV+'-'+TMOV->NOMEAPROV
		
		cTo := alltrim(_email_Solicitante)+';'+ alltrim(_email_Aprovador)
		
		While !TMOV->(Eof())      
			aadd(aEnvia, {     TMOV->C1_ITEM    ,;
			 				   TMOV->C1_PRODUTO ,; 
			 				   TMOV->C1_DESCRI  ,;
			 				   TMOV->C1_UM      ,;	 				   
				               Transform(TMOV->C1_QUANT,"@E 999,999,999.99"),;
				               TMOV->C1_DATPRF  ,;
   			 				   TMOV->C1_CC      ,;	 				      			 				   
   			 				   TMOV->C1_CONTA};
		                )
			TMOV->(dbSkip())
		Enddo
		// Inicio WorkFlow
		If Len(aEnvia) > 0
		   EnviaEmail()
		EndIf
		TMOV->(DbCloseArea())
		DbSelectArea(cAlias) 
Endif		
do case	
   case nOpt == 3		
      	msgalert("Solicitação "+alltrim(cNumSol)+" incluída com sucesso!")	
   case nOpt == 4		
    	msgalert("Solicitação "+alltrim(cNumSol)+" alterada com sucesso!")   	
   case nOpt == 5		
    	msgalert("Solicitação "+alltrim(cNumSol)+" excluída com sucesso!")    
endcase

Return .T.


//************************************************************/
Static Function  EnviaEmail()
//    _cTo:="aishii@nippon-seikibr.com.br"
    oProcess := TWFProcess():New( "000001", "Envia Email" )
    oProcess :NewTask( "100001", "\WORKFLOW\SC1.HTM" )
    oProcess :cSubject := "Solicitação de Compras - "+cNumSol+ " (Bloqueada)"
    oHTML    := oProcess:oHTML 
    cMen := " <html>"
    cMen += " <head>"
    cMen += '<h2 align="Left">' 
    cMen += '<td align="Left" width="1000" height="45"> '
//	cMen += '<font color="#FFFF00" size="4" face="Verdana, Arial, Helvetica, sans-serif"><strong>SOLICITA&Ccedil;&Atilde;O DE COMPRA </strong></font></h2></td>'
	cMen += '<font color="#000000" size="4" face="Verdana, Arial, Helvetica, sans-serif"><strong>SOLICITA&Ccedil;&Atilde;O DE COMPRA </strong></font></h2></td>'	
	cMen += '<font color="#CD6600" size="4" face="Verdana, Arial, Helvetica, sans-serif"><strong>PENDENTE DE APROVAÇÃO </font></h2></td>'	
	cMen += '<tr>'
	cMen += '</tr>
    cMen += ' <tr >'
    cMen += ' <table  border="1" width="1000" height="45"> '
    cMen += ' <td align="center" width="15%"   bgcolor="#FFFFFF"><font color="#CD6600" size="4" face="Courrier"><strong>No. Solicitacao</strong></font></td>'  //[2]
    cMen += ' <td align="center" width="30%"  bgcolor="#FFFFFF"><font size="3" face="Courrier"><strong>Solicitante</strong></font></td>'  //[3]
    cMen += ' <td align="center" width="40%"  bgcolor="#FFFFFF"><font size="3" face="Courrier"><strong>Aprovador</strong></font></td>'  //[4]
    cMen += ' <td align="center" width="10%"   bgcolor="#FFFFFF"><font size="3" face="Courrier"><strong>Emissao</strong></font></td>'  //[5]
    cMen += ' </tr>'     
   	cMen += ' <tr >'
	cMen += ' <td align="center" width="15%" bgcolor="#FFFFFF"><font color="#009900" size="3" face="Times New Roman"><strong>'+cNumSol+'</strong></font></td>'
	cMen += ' <td align="center" width="30%" bgcolor="#FFFFFF"><font size="2" face="Times New Roman"><Blink>'+cSolici+'</Blink></font></td>'
	cMen += ' <td align="center" width="30%" bgcolor="#FFFFFF"><font size="2" face="Times New Roman"><Blink>'+cAprovador+'</Blink></font></td>'
	cMen += ' <td align="center" width="30%" bgcolor="#FFFFFF"><font size="2" face="Times New Roman"><Blink>'+cEmissao+'</Blink></font></td>'
	cMen += ' </tr>'         
	cMen += " </table>"    
	cMen += " </head>"    
    cMen += " <body>"      
	cMen += ' <table  border="1" width="1000" height="45">'

      cMen += ' <tr>'
      cMen += ' <td align="center" width="5%"   bgcolor="#FFFFFF"><font size="2" face="Courrier"><strong>Item</strong></font></td>'  //[2]
      cMen += ' <td align="center" width="15%"  bgcolor="#FFFFFF"><font size="2" face="Courrier"><strong>Codigo</strong></font></td>'  //[3]
      cMen += ' <td align="center" width="25%"  bgcolor="#FFFFFF"><font size="2" face="Courrier"><strong>Descricao</strong></font></td>'  //[4]
      cMen += ' <td align="left  " width="2%"   bgcolor="#FFFFFF"><font size="2" face="Courrier"><strong>UM</strong></font></td>'  //[5]
      cMen += ' <td align="right" width="10%"   bgcolor="#FFFFFF"><font size="2" face="Courrier"><strong>Quantidade</strong></font></td>'  //[6] 
      cMen += ' <td align="center" width="10%"  bgcolor="#FFFFFF"><font size="2" face="Courrier"><strong>Necessidade</strong></font></td>'  //[6]       
      cMen += ' <td align="center" width="9%"   bgcolor="#FFFFFF"><font size="2" face="Courrier"><strong>CC</strong></font></td>'  //[6]                   
      cMen += ' <td align="center" width="20%"  bgcolor="#FFFFFF"><font size="2" face="Courrier"><strong>Conta</strong></font></td>'  //[6]           
      cMen += ' </tr>'
	
    For x:= 1 to Len(aEnvia) 
      cMen += ' <tr>'
      cMen += ' <td align="center" width="5%"   bgcolor="#FFFFFF"><font size="2" face="Courrier">'+aEnvia[x][1]+'</font></td>'  //[2]
      cMen += ' <td align="left" width="15%"    bgcolor="#FFFFFF"><font size="2" face="Courrier">'+aEnvia[x][2]+'</font></td>'  //[3]
      cMen += ' <td align="left" width="25%"    bgcolor="#FFFFFF"><font size="2" face="Courrier">'+aEnvia[x][3]+'</font></td>'  //[4]
      cMen += ' <td align="center" width="2%"   bgcolor="#FFFFFF"><font size="2" face="Courrier">'+aEnvia[x][4]+'</font></td>'  //[5]
      cMen += ' <td align="right" width="10%"   bgcolor="#FFFFFF"><font size="2" face="Courrier">'+aEnvia[x][5]+'</font></td>'  //[6] 
      cMen += ' <td align="center" width="10%"   bgcolor="#FFFFFF"><font size="2" face="Courrier">'+aEnvia[x][6]+'</font></td>'  //[6]       
      cMen += ' <td align="right" width="10%"   bgcolor="#FFFFFF"><font size="2" face="Courrier">'+aEnvia[x][7]+'</font></td>'  //[6] 
      cMen += ' <td align="center" width="10%"   bgcolor="#FFFFFF"><font size="2" face="Courrier">'+aEnvia[x][8]+'</font></td>'  //[6]       
      cMen += ' </tr>'
    Next 
    cMen += ' </table>'
    cMen += " </body>"
    cMen += " </html>" 
	
    oHtml:ValByName("MENS", cMen)
	oProcess:cTo  := cTo
	cMailId := oProcess:Start()
   // Alert("E-mail enviado para Liberacao da Chefia: "+ cTo)   
Return
