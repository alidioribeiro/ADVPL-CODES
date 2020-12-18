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
User Function WF_TRF()
********************************
Local aEnvia := {}
Local cProd,cMen

//_cEmp := SM0->M0_CODIGO
//_cFil := SM0->M0_CODFIL

Prepare Environment Empresa "01" Filial "01" Tables "ZZ4"  // Usado apenas quando o uso for por agendamento                                                         JJ

//cPerg   := "VALTIN"
//Pergunte(cPerg,.F.)

dbSelectarea("ZZ4")
aStruZZ4 := ZZ4->(dbStruct())
//
cQuery := " SELECT * "
cQuery += " FROM "+RetSqlName("ZZ4")+" A " //INNER JOIN "+RetSqlName("ZZ2")+" B ON (A.ZZ4_CODMOT=B.ZZ2_COD) "
cQuery += " WHERE "
cQuery += " A.D_E_L_E_T_<>'*' "
cQuery += " AND A.ZZ4_FILIAL='"+xFilial("ZZ4")+"' "
cQuery += " AND ( ZZ4_DTAUT  = '' OR ZZ4_CODAUT = '' ) "	
cQuery += " ORDER BY ZZ4_DATA, ZZ4_COD, ZZ4_LOCAL, ZZ4_LOTECT, ZZ4_ETIQ "
TCQUERY cQuery NEW ALIAS "ZZ4TMP"
//
For nX := 1 To Len(aStruZZ4)
	If ( aStruZZ4[nX][2] <> "C" ) .And. FieldPos(aStruZZ4[nX][1]) > 0
		TcSetField("ZZ4TMP",aStruZZ4[nX][1],aStruZZ4[nX][2],aStruZZ4[nX][3],aStruZZ4[nX][4])
	EndIf
Next nX   
//
//
dbSelectArea("ZZ4TMP")
dbGoTop()
Do While ZZ4TMP->(!Eof())                            
    //
    //ZZ4_FILIAL ZZ4_DATA ZZ4_HORA ZZ4_CODUSR ZZ4_NOMEUS      ZZ4_CODIGO      ZZ4_LOCAL ZZ4_LOCALI      ZZ4_LOTECT 
    //ZZ4_NUMLOT ZZ4_QTDE               ZZ4_ETIQ   ZZ4_CODAUT ZZ4_NOMEAU      D_E_L_E_T_ R_E_C_N_O_  ZZ4_DTAUT 
    //ZZ4_HRAUT ZZ4_OP      ZZ4_CODMOT ZZ4_ORIGEM
    //
	aadd(aEnvia, {dToc(ZZ4TMP->ZZ4_DATA),; 
					   ZZ4TMP->ZZ4_HORA,;
		               ZZ4TMP->ZZ4_NOMEUS,;
		               ZZ4TMP->ZZ4_COD,;
		               ZZ4TMP->ZZ4_LOCAL,;
		               ZZ4TMP->ZZ4_LOCALI,;
		               ZZ4TMP->ZZ4_LOTECT,;
		               Transform(ZZ4TMP->ZZ4_QUANT,"@E 999,999,999.999999"),;
		               ZZ4TMP->ZZ4_ETIQ,;
		               ZZ4TMP->ZZ4_OP,;
		               ZZ4TMP->ZZ4_ORIGEM,;
	   	               POSICIONE("ZZ2",1,xFilial("ZZ2")+ZZ4TMP->ZZ4_CODMOT,"ZZ2_DESCRI"),;
	   	               Alltrim(ZZ4TMP->ZZ4_OBSERV) })
    //IIF(ZZ4TMP->ZZ4_ORIGEM=="CB0","COLETOR",IIF(ZZ4TMP->ZZ4_ORIGEM=="SD3","REQUISICAO",IIF(ZZ4TMP->ZZ4_ORIGEM=="SC6","FAT.MANUAL","OUTROS")))
	ZZ4TMP->(dbSkip())
Enddo
ZZ4TMP->(dbClosearea())
//
If Len(aEnvia) > 0
	
	oProcess := TWFProcess():New( "000022", "WF_TRF - CONTROLE DE TRANSFERENCIAS" )
	oProcess :NewTask( "100022", "\WORKFLOW\WF_TRF.HTM" )
	oProcess :cSubject := "WF_TRF - Monitoramento de transferencias"
	oHTML    := oProcess:oHTML
	
	//Qout("Entrou no Html")	
	cMen := " <html>"
	cMen += " <body>"
	cMen += ' <table border="1" width="950">'
	cMen += ' <tr width="800" align="center" >'
	//   cMen += ' <TD ><IMG src="\\Nsbsrv01\CORREIO\Workflow\Imagens\LogoNSB.JPG"></TD>'
	cMen += ' <td colspan=13 >Relação de Lotes pendentes para transferencia</td></tr>'
	cMen += ' <tr >'
	cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink> Data   </Blink></font></td>'
	cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink> Hora   </Blink></font></td>'
	cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Operador</Blink></font></td>'
	cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink> Codigo </Blink></font></td>'
	cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink> Local  </Blink></font></td>'
	cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink> Ender. </Blink></font></td>'
	cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink> Lote   </Blink></font></td>'
	cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink> Qtde   </Blink></font></td>'
	cMen += ' <td align="right"  width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Etiqueta</Blink></font></td>'
	cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Ord.Prod</Blink></font></td>'
	cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink> Origem </Blink></font></td>'				
	cMen += ' <td align="center" width="15%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink> Motivo </Blink></font></td>'					
	cMen += ' <td align="center" width="20%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Observacao</Blink></font></td>'						
	cMen += ' </tr>'
	//
	//Qout("Len: "+Str(Len(aEnvia)))	
	For x:= 1 to Len(aEnvia)
		cMen += ' <tr>'
		cMen += ' <td align="left"   width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+ aEnvia[x,01] +'</Blink></font></td>'
		cMen += ' <td align="left"   width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+ aEnvia[x,02] +'</Blink></font></td>'
		cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+ aEnvia[x,03] +'</Blink></font></td>'
		cMen += ' <td align="left"   width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+ aEnvia[x,04] +'</Blink></font></td>'
		cMen += ' <td align="right"  width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+ aEnvia[x,05] +'</Blink></font></td>'
		cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+ aEnvia[x,06] +'</Blink></font></td>'
		cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+ aEnvia[x,07] +'</Blink></font></td>'
		cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+ aEnvia[x,08] +'</Blink></font></td>'
		cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+ aEnvia[x,09] +'</Blink></font></td>'				
		cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+ aEnvia[x,10] +'</Blink></font></td>'				
		cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+ aEnvia[x,11] +'</Blink></font></td>'				
		cMen += ' <td align="center" width="15%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+ aEnvia[x,12] +'</Blink></font></td>'										
		cMen += ' <td align="center" width="20%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+ aEnvia[x,13] +'</Blink></font></td>'												
		cMen += ' </tr>'
	Next
	//
	cMen += ' </table>'
	cMen += " </body>"
	cMen += " </html>"
	//
	oHtml:ValByName("MENS", cMen)
	CodRot := "WF_TRF"  //tabela ZWF
	Mto := u_MontaRec(CodRot)
	oProcess:cTo := Mto
	//oProcess:ATTACHFILE(cArq) - ANEXA UM ARQUIVO <CAMINHO + NOME DO ARQUIVO>
	cMailId := oProcess:Start()
	Qout("E-mail enviado com sucesso!!!")
EndIf

Return