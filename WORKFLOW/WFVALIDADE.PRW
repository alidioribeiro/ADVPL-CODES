#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#include "ap5mail.ch"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"

/*
GIT
14/06/2013
*/

********************************
User Function WFTINTA()
********************************
Local aEnvia := {}
Local cProd,cMen


Prepare Environment Empresa "01" Filial "01" Tables "SB8"  // Usado apenas quando o uso for por agendamento                                                         JJ

//cPerg   := "VALTIN"
//Pergunte(cPerg,.F.)


cQuery  := " SELECT DATEDIFF(DD, GETDATE(),convert(date, B8_DTVALID)) AS DIAS, * "
cQuery  += " FROM "+RetSqlName("SB8")+" A INNER JOIN "+RetSqlName("SB1")+" B ON (B8_FILIAL+B8_PRODUTO=B1_FILIAL+B1_COD) "
cQuery  += " WHERE A.D_E_L_E_T_<>'*' AND B.D_E_L_E_T_<>'*' "
cQuery  += " AND B8_FILIAL = '"+xFilial("SB8")+"' "
cQuery  += " AND B1_FILIAL = '"+xFilial("SB1")+"' "
cQuery  += " AND B1_TIPO = 'MP' "
cQuery  += " AND B8_LOCAL = '01' "
cQuery  += " AND B8_SALDO > 0 AND B1_PRVALID>0"
cQuery  += " AND ( "
//cQuery  += "       DATEDIFF(DD, GETDATE(), convert(date, B8_DTVALID)) < 0 OR "
cQuery  += "       DATEDIFF(DD, GETDATE(), convert(date, B8_DTVALID)) < B1_PRVALID -30 ) "
//cQuery  += " AND B1_DESC LIKE '%TINTA%' "
cQuery  += " ORDER BY DIAS, B1_DESC "
TCQUERY cQuery ALIAS TMP New
//
dbSelectArea("TMP")
dbGoTop()
Do While TMP->(!Eof())
	aadd(aEnvia, {TMP->DIAS, TMP->B8_PRODUTO, TMP->B1_DESC, TMP->B8_LOCAL, TMP->B8_LOTECTL, TMP->B8_SALDO, TMP->B1_UM, TMP->B8_DTVALID })
	TMP->(dbSkip())
Enddo
TMP->(dbClosearea())
//
//
If Len(aEnvia) > 0
	
	oProcess := TWFProcess():New( "000021", "WFE13 - Validade das Tintas" )
	oProcess :NewTask( "100021", "\WORKFLOW\WFTINTA.HTM" )
	oProcess :cSubject := "WFE13 - Monitoramento de Tinta / Validade"
	oHTML    := oProcess:oHTML
	
	//Qout("Entrou no Html")	
	cMen := " <html>"
	cMen += " <body>"
	cMen += ' <table border="1" width="750">'
	cMen += ' <tr width="600" align="center" >'
	//   cMen += ' <TD ><IMG src="\\Nsbsrv01\CORREIO\Workflow\Imagens\LogoNSB.JPG"></TD>'
	cMen += ' <td colspan=8 >Relação de Lote com validade </td></tr>'
	cMen += ' <tr >'
	cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink> Qt.Dias </Blink></font></td>'
	cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink> Produto </Blink></font></td>'
	cMen += ' <td align="center" width="30%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Descrição</Blink></font></td>'
	cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink> Armazem </Blink></font></td>'
	cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>  Lote   </Blink></font></td>'
	cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Sld. Lote</Blink></font></td>'
	cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>  Unid.  </Blink></font></td>'
	cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Dt.Valid.</Blink></font></td>'
	cMen += ' </tr>'
	
	//Qout("Len: "+Str(Len(aEnvia)))	
	For x:= 1 to Len(aEnvia)
		//aadd(aEnvia, {TMP->DIAS, TMP->B8_PRODUTO, TMP->B1_DESC, TMP->B8_LOCAL, TMP->B8_LOTECTL, TMP->B8_SALDO, TMP->B1_UM, TMP->B8_DTVALID })
		cMen += ' <tr>'
		cMen += ' <td align="right"  width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+ Str(aEnvia[x,1]) +'</Blink></font></td>'
		cMen += ' <td align="left"   width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+ 	aEnvia[x,2]	 +'</Blink></font></td>'
		cMen += ' <td align="left"   width="30%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+ 	aEnvia[x,3]	 +'</Blink></font></td>'
		cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+ 	aEnvia[x,4]	 +'</Blink></font></td>'
		cMen += ' <td align="left"   width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+    	aEnvia[x,5]	 +'</Blink></font></td>'
		cMen += ' <td align="right"  width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+Transform(aEnvia[x,6],"@E 999,999.999999") +'</Blink></font></td>'
		cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+     aEnvia[x,7]  +'</Blink></font></td>'
		cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+Right(aEnvia[x,8],2)+"/"+substr(aEnvia[x,8],5,2)+"/"+Left(aEnvia[x,8],4)+'</Blink></font></td>'
		cMen += ' </tr>'
	Next
	//
	cMen += ' </table>'
	cMen += " </body>"
	cMen += " </html>"
	//
	oHtml:ValByName( "MENS", cMen)
	//   oProcess:ClientName( Subs(cUsuario,7,15) )
	CodRot := "WFE31"  //LINDALVA  //tabela ZWF
	Mto := u_MontaRec(CodRot)
	oProcess:cTo := Mto
	//   oProcess:ATTACHFILE(cArq) - ANEXA UM ARQUIVO <CAMINHO + NOME DO ARQUIVO>
	cMailId := oProcess:Start()
	Qout("E-mail enviado com sucesso!!!")
EndIf

Return
