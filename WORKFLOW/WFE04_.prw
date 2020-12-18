#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"   // Problema com a janela inicial
#include "ap5mail.ch"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �WFE04     �Autor  �   � Data �    ���
�������������������������������������������������������������������������͹��
���Desc.     �Esse programa tem como objetivo enviar e-mails para cada    ���
���          �responsavel dos Centros de Custo com os ausentes do mesmo   ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

***************************************
User Function WFE04_()
***************************************

Local aEnvia := {}
Local cProd,cMen
Local oHtml

//_cEmp := SM0->M0_CODIGO
//_cFil := SM0->M0_CODFIL

//Prepare Environment Empresa "01" Filial "01" Tables "SP8"  // Usado apenas quando o uso for por agendamento                                                         JJ

dbSelectarea("SP8")

    
 cQuery := " SELECT SP8.P8_FILIAL, SP8.P8_DATA, SP8.P8_HORA, SP8.P8_MAT, SRA.RA_NOME, SRA.RA_CC, SRA.RA_TNOTRAB"
 cQuery += " FROM "+RetSqlName('SP8')+" SP8 "
 cQuery += " INNER JOIN "+RetSqlName('SRA')+" SRA ON  "
 cQuery += " (SRA.RA_FILIAL = SP8.P8_FILIAL "
 cQuery += " AND SRA.RA_MAT = SP8.P8_MAT)" 
 cQuery += " WHERE SP8.D_E_L_E_T_<>'*' "
 cQuery += " AND SRA.RA_SITFOLH <>'D' AND SRA.D_E_L_E_T_<>'*' "  
 cQuery += " AND SP8.P8_FILIAL ='"+xFilial('SP8')+"' "
 cQuery += " AND SP8.P8_DATA BETWEEN '"+dtos(dDataBase-1)+"' AND '"+dtos(dDataBase)+"'"
 cQuery += " AND SP8.P8_TPMARCA IN ('1E','2S')"  
 cQuery += " ORDER BY RA_CC,RA_MAT,P8_DATA"
 

 TCQUERY cQuery NEW Alias "TRA"
// nItem := 1
 
 DbSElectArea("TRA") 
 DbGotop()
                                       
 Do While TRA->(!Eof())
     cCC := Alltrim(TRA->RA_CC)
     cEmail := POSICIONE("ZWF",1,xFilial("ZWF")+"WFE04_  "+TRA->RA_CC,"ZWF_EMAIL")
     Do While TRA->(!Eof()) .AND. Alltrim(TRA->RA_CC) == cCC
		aadd(aEnvia, { TRA->P8_MAT,; 
		   			   TRA->RA_NOME,;
	                   TRA->P8_DATA ,; 		    			   
		               StrTran(Transform(TRA->P8_HORA,"99.99"),".",":"),;        //StrTran(SubStr(_CodProA,1,18),"-","")
	                   TRA->RA_CC  ,;  
	                   TRA->RA_TNOTRAB; 
	                    })
		TRA->(DBSKIP())
	 Enddo
	 //   
	 If Len(aEnvia) > 0
		 GeraWFE(aEnvia)		
	     aEnvia := {}      
     Endif
Enddo 
TRA->(dbClosearea())     
Return

Static Function GeraWFE(aENvia,cEmail)
/*
  Posicionar no CC -> ZWF
*/
If Len(aEnvia) > 0
	
	oProcess := TWFProcess():New( "000033", "WFE04_" )
	oProcess :NewTask( "100033", "\WORKFLOW\WF.HTM" )
	oProcess :cSubject := "WFE04_ - MONITORAMENTO DOS APONTAMENTOS DE MARCA��O"
	oHTML    := oProcess:oHTML
	

	cMen := " <html>"
	cMen += " <body>"
	cMen += ' <table border="1" width="950">'
	cMen += ' <tr width="800" align="center" >'

	cMen += ' <td colspan=09 >Rela��o dos apontamentos de Marca��e de Entrada e Saida dos funcionarios</td></tr>'
	cMen += ' <tr >'
	cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink> Matricula </Blink></font></td>'
	cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink> Nome </Blink></font></td>'
	cMen += ' <td align="center" width="30%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>   Data   </Blink></font></td>'
	cMen += ' <td align="center" width="15%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink> Hora </Blink></font></td>'	
	cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink> CC </Blink></font></td>'
	cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink> Turno</Blink></font></td>'

	cMen += ' </tr>'
	
	For x:= 1 to Len(aEnvia)
		cMen += ' <tr>'
		cMen += ' <td align="right"  width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+ aEnvia[x,01] +'</Blink></font></td>'
		cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+ aEnvia[x,02] +'</Blink></font></td>'
		cMen += ' <td align="left"   width="15%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+ aEnvia[x,03] +'</Blink></font></td>'
		cMen += ' <td align="left"   width="30%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+ aEnvia[x,04] +'</Blink></font></td>'
		cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+ aEnvia[x,05] +'</Blink></font></td>'
		cMen += ' <td align="right"  width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+ aEnvia[x,06] +'</Blink></font></td>'
	 			
		cMen += ' </tr>'
	Next
	//
	cMen += ' </table>'
	cMen += " </body>"
	cMen += " </html>"
	//
	oHtml:ValByName("MENS", cMen)
	CodRot := "WFE04_"  //tabela ZWF
	Mto := cEmail //u_MontaRec(CodRot)
	oProcess:cTo := Mto
	//oProcess:ATTACHFILE(cArq) - ANEXA UM ARQUIVO <CAMINHO + NOME DO ARQUIVO>
	cMailId := oProcess:Start()
	Qout("E-mail enviado com sucesso!!!")
else                
    //
    oProcess := TWFProcess():New( "000033", "WFE04_" )
	oProcess :NewTask( "100033", "\WORKFLOW\WF.HTM" )
	oProcess :cSubject := "WFE04_ - MONITORAMENTO DOS APONTAMENTOS DE MARCA��O"
	oHTML    := oProcess:oHTML
	//
	cMen := " <html>"
	cMen += " <body>"
	cMen += ' <table border="1" width="950">'
	cMen += ' <tr width="800" align="center" >'
	cMen += ' <td colspan=01 > N�o existem inda Marca��es Importadas para o Monitoramento</td></tr>'
	cMen += ' </table>'
	cMen += " </body>"
	cMen += " </html>"
    //
	oHtml:ValByName("MENS", cMen)
	CodRot := "WFE04_"  //tabela ZWF
	Mto := u_MontaRec(CodRot)
	oProcess:cTo := Mto
	cMailId := oProcess:Start()
	Qout("E-mail enviado com sucesso!!!")

EndIf
Return
 

              

