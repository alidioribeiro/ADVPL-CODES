#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#include "ap5mail.ch"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"

********************************
User Function WFSTRUA1()
********************************
Local aEnvia := {}
Local cProd,cMen
Local cPerg := "WFSTRUA1"
Local x

//Prepare Environment Empresa "01" Filial "01" Tables "SG1"  // Usado apenas quando o uso for por agendamento                                                       


//Se cancelar o pergunte
if !Pergunte(cPerg)
   return
Endif

dbSelectarea("SG1") 
       
//marcio macedo 13/05/2019
//cQuery := " SELECT * FROM (
//--------
cQuery := " SELECT "
cQuery += " A.G1_COD AS PAI,"
cQuery += " B.B1_DESC AS DESCPAI,"
cQuery += " A.G1_COMP AS FILHO,"
cQuery += " C.B1_DESC AS DESCFILHO,"
cQuery += " CAST(ISNULL(A.G1_QUANT,0) AS DECIMAL(12,06)) AS QTUSADA,"
cQuery += " SUBSTRING(A.G1_INI,7,2)+'/'+SUBSTRING(A.G1_INI,5,2)+'/'+SUBSTRING(A.G1_INI,1,4) AS INICIO,"
cQuery += " SUBSTRING(A.G1_FIM,7,2)+'/'+SUBSTRING(A.G1_FIM,5,2)+'/'+SUBSTRING(A.G1_FIM,1,4) AS FINAL,"
cQuery += " A.G1_OBSERV AS OBS,"
cQuery += " CAST(ISNULL(DATEDIFF(DAY,GETDATE(),A.G1_INI),0) AS DECIMAL(5,0)) AS DIAS,"
cQuery += " ' ITEM A ENTRAR' AS STS"
//cQuery += " ,A.G1_INI "  //marcio macedo 13/05/2019
cQuery += " FROM SG1010 A"
cQuery += " LEFT JOIN (SELECT B1_FILIAL,B1_COD,B1_DESC FROM SB1010 WHERE D_E_L_E_T_<>'*' ) B ON A.G1_COD = B.B1_COD AND A.G1_FILIAL = B.B1_FILIAL "
cQuery += " LEFT JOIN (SELECT B1_FILIAL,B1_COD,B1_DESC FROM SB1010 WHERE D_E_L_E_T_<>'*' ) C ON A.G1_COMP = C.B1_COD AND A.G1_FILIAL = C.B1_FILIAL "
cQuery += " WHERE  GETDATE()<A.G1_INI AND A.D_E_L_E_T_<>'*' "
//cQuery += " AND DATEDIFF(DAY,GETDATE(),A.G1_INI) <=46"
cQuery += " AND G1_INI BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
cQuery += " UNION ALL "
cQuery += " SELECT "
cQuery += " A.G1_COD AS PAI,"
cQuery += " B.B1_DESC AS DESCPAI,"
cQuery += " A.G1_COMP AS FILHO,"
cQuery += " C.B1_DESC AS DESCFILHO,"
cQuery += " CAST(ISNULL(A.G1_QUANT,0) AS DECIMAL(12,06)) AS QTUSADA,"
cQuery += " SUBSTRING(A.G1_INI,7,2)+'/'+SUBSTRING(A.G1_INI,5,2)+'/'+SUBSTRING(A.G1_INI,1,4) AS INICIO,"
cQuery += " SUBSTRING(A.G1_FIM,7,2)+'/'+SUBSTRING(A.G1_FIM,5,2)+'/'+SUBSTRING(A.G1_FIM,1,4) AS FINAL,"
cQuery += " A.G1_OBSERV AS OBS,"
cQuery += " CAST(ISNULL(DATEDIFF(DAY,GETDATE(),A.G1_FIM),0) AS DECIMAL(5,0)) AS DIAS,"
cQuery += " ' ITEM A SAIR' AS STS"
//cQuery += " ,A.G1_INI "   //marcio macedo 13/05/2019
cQuery += " FROM SG1010 A"
cQuery += " LEFT JOIN (SELECT B1_FILIAL,B1_COD,B1_DESC FROM SB1010 WHERE D_E_L_E_T_<>'*' ) B ON A.G1_COD = B.B1_COD AND A.G1_FILIAL = B.B1_FILIAL "
cQuery += " LEFT JOIN (SELECT B1_FILIAL,B1_COD,B1_DESC FROM SB1010 WHERE D_E_L_E_T_<>'*' ) C ON A.G1_COMP = C.B1_COD AND A.G1_FILIAL = C.B1_FILIAL "
cQuery += " WHERE  GETDATE()<A.G1_FIM AND A.D_E_L_E_T_<>'*' "
cQuery += " AND G1_FIM BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
//cQuery += " AND DATEDIFF(DAY,GETDATE(),A.G1_FIM) <=45"  
//marcio macedo 13/05/2019
//cQuery += " ) AS TEMP "
//cQuery += " WHERE G1_INI  BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "


TCQUERY cQuery NEW ALIAS "SG1TMP"

nItem := 1            

dbSelectArea("SG1TMP")
dbGoTop()
Do While SG1TMP->(!Eof())                            
    //
	aadd(aEnvia, {     SG1TMP->PAI,; 
					   SG1TMP->DESCPAI,;
	 				   SG1TMP->FILHO,; 
					   SG1TMP->DESCFILHO,;
   					   TRANSFORM(SG1TMP->QTUSADA,"@E 99,999.999999"),;
   					   SG1TMP->INICIO,;   					   
   					   SG1TMP->FINAL,;   					   
   					   SG1TMP->OBS,;					   
   					   TRANSFORM(SG1TMP->DIAS,"@E 99,999"),;
   					   SG1TMP->STS})
	nItem ++   	               
	SG1TMP->(dbSkip())
Enddo
SG1TMP->(dbClosearea())
//
If Len(aEnvia) > 0
	            
	oProcess := TWFProcess():New( "W00024", "WFSTRUAL PROGRAMACAO ALTERACAO DE ESTRUTURAS" )
	oProcess :NewTask( "100024", "\WORKFLOW\WFSTRUAL.HTM" )
	oProcess :cSubject := "WFSTRUAL - Programacao Alteracao de Estruturas"
	oHTML    := oProcess:oHTML
	
	//Qout("Entrou no Html")	
	cMen := " <html>"
	cMen += " <body>"
	cMen += ' <table border="1" width="1200">'
	cMen += ' <tr width="1200" align="center" >'
	//   cMen += ' <TD ><IMG src="\\Nsbsrv01\CORREIO\Workflow\Imagens\LogoNSB.JPG"></TD>'
	cMen += ' <td colspan=09 >Programacao de Alteracao de Estruturas</td></tr>'
	cMen += ' <tr >'
	cMen += ' <td align="center" width="15%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman">COD.PRODUTO></font></td>'
	cMen += ' <td align="center" width="30%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman">DESC. PRODUTO</font></td>'
	cMen += ' <td align="center" width="15%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman">COD.COMPONENTE</font></td>'
	cMen += ' <td align="center" width="30%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman">DESC. COMPONENTE</font></td>'
	cMen += ' <td align="center" width="16%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman">QTDE</font></td>'
	cMen += ' <td align="center" width="08%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman">INICIO</font></td>'
	cMen += ' <td align="center" width="08%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman">FINAL</font></td>'
	cMen += ' <td align="center" width="45%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman">OBS</font></td>'
	cMen += ' <td align="center" width="07%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman">DIAS</font></td>'		
	cMen += ' <td align="center" width="20%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman">STS</font></td>'	
	cMen += ' </tr>'

	For x:= 1 to Len(aEnvia)
		cMen += ' <tr>'
		cMen += ' <td align="right"  width="15%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman">'+ aEnvia[x,01] +'</font></td>'
		cMen += ' <td align="center" width="30%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman">'+ aEnvia[x,02] +'</font></td>'
		cMen += ' <td align="right"  width="15%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman">'+ aEnvia[x,03] +'</font></td>'
		cMen += ' <td align="center" width="30%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman">'+ aEnvia[x,04] +'</font></td>'
		cMen += ' <td align="left"   width="16%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman">'+ aEnvia[x,05] +'</font></td>'
		cMen += ' <td align="right"  width="08%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman">'+ aEnvia[x,06] +'</font></td>'
		cMen += ' <td align="right"  width="08%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman">'+ aEnvia[x,07] +'</font></td>'
		cMen += ' <td align="right"  width="45%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman">'+ aEnvia[x,08] +'</font></td>'
		cMen += ' <td align="right"  width="07%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman">'+ aEnvia[x,09] +'</font></td>'				
		cMen += ' <td align="right"  width="20%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman">'+ aEnvia[x,10] +'</font></td>'						
		cMen += ' </tr>'
	Next
	//
	cMen += ' </table>'
	cMen += " </body>"
	cMen += " </html>"
	//
	oHtml:ValByName("MENS", cMen)
	CodRot := "WFSTRUA1"  //tabela ZWF
	Mto := u_MontaRec(CodRot)
	oProcess:cTo := Mto
	//oProcess:ATTACHFILE(cArq) - ANEXA UM ARQUIVO <CAMINHO + NOME DO ARQUIVO>
	cMailId := oProcess:Start()
	Qout("E-mail enviado com sucesso!!!")
else                
    //
	oProcess := TWFProcess():New( "000024", "WFSTRUAL - PROGRAMACAO DE ALTERACAO DE ESTRUTURAS" )
	oProcess :NewTask( "100024", "\WORKFLOW\WFSTRUAL.HTM" )
	oProcess :cSubject := "WFSTRUA1 - Programacao de Alteracao de Estruturas"
	oHTML    := oProcess:oHTML
	//
	cMen := " <html>"
	cMen += " <body>"
	cMen += ' <table border="1" width="1200">'
	cMen += ' <tr width="1200" align="center" >'
	cMen += ' <td colspan=01 > Não ha Alteracao de Estrututas</td></tr>'
	cMen += ' </table>'
	cMen += " </body>"
	cMen += " </html>"
    //
	oHtml:ValByName("MENS", cMen)
	CodRot := "WFSTRUA1"  //tabela ZWF
	Mto := u_MontaRec(CodRot)
	oProcess:cTo := Mto
	cMailId := oProcess:Start()
	Qout("E-mail enviado com sucesso!!!")

EndIf

Return