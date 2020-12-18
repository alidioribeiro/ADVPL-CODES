/******Rela็ใo de contrato de parceria a vencer***/
#INCLUDE "rwmake.ch"
//#INCLUDE "Protheus.ch"   // Problema com a janela inicial
#include "ap5mail.ch"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWFE04     บAutor  ณJefferson Moreira   บ Data ณ  08/07/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function WFE22
********************************  
  Local aProd := {}
  Local cProd,cMen 
  Local CodRot:="WFE22"
  Local CCusto:=""                                     
  
 Prepare Environment Empresa "01" Filial "01" Tables "SC3","SA2"  // Usado apenas quando o uso for por agendamento
// Prepare Environment Empresa "02" Filial "01" Tables "SRA","CTT"
  
 
CQuery:=" select C3_NUM,C3_FORNECE,C3_LOJA, A2_NOME,"
CQuery+=" SUBSTRING(C3_DATPRI,7,2)+'/'+SUBSTRING(C3_DATPRI,5,2)+'/'+SUBSTRING(C3_DATPRI,1,4)as DataIni,"
CQuery+=" SUBSTRING(C3_DATPRF,7,2)+'/'+SUBSTRING(C3_DATPRF,5,2)+'/'+SUBSTRING(C3_DATPRF,1,4)as DataFim "
CQuery+=" from SC3010,SA2010 "
CQuery+=" WHERE C3_FORNECE+C3_LOJA=A2_COD+A2_LOJA "
CQuery+=" AND SC3010.D_E_L_E_T_='' AND SA2010.D_E_L_E_T_='' " 
CQuery+=" AND datediff(day,getdate(),C3_DATPRF)<=60  "
cQuery+=" ORDER BY C3_NUM,C3_FORNECE,C3_LOJA, A2_NOME "

TCQUERY cQuery NEW ALIAS "TRB"
DbSelectArea("TRB")
DbGotop()
While !Eof()                                                          

	CQuery:=" select C3_NUM,C3_FORNECE,C3_LOJA, A2_NOME,"
	CQuery+=" SUBSTRING(C3_DATPRI,7,2)+'/'+SUBSTRING(C3_DATPRI,5,2)+'/'+SUBSTRING(C3_DATPRI,1,4)as DataIni,"
	CQuery+=" SUBSTRING(C3_DATPRF,7,2)+'/'+SUBSTRING(C3_DATPRF,5,2)+'/'+SUBSTRING(C3_DATPRF,1,4)as DataFim "

	AaDD(Aprod,{ TRB->C3_NUM,TRB->C3_FORNECE, TRB->C3_LOJA,TRB->A2_NOME,TRB->DATAINI, TRB->DATAFIM})
    DbSkip()
EndDo 
If Len(Aprod)>0
	EnviaEmail(Aprod,CodRot)
Endif
DbSelectArea("TRB")
DbCloseArea()
Return 

/***************************************************************************************************/
/***************************************************************************************************/
/***************************************************************************************************/

Static Function 	EnviaEmail(Aprod,CodRot)
Local _cTo:=""  
  
 oProcess := TWFProcess():New( "000001", "Contrato de Parceria a vencer no prazo de 60 dias " )
 oProcess :NewTask( "100001", "\WORKFLOW\CONTP.HTM" )
 oProcess :cSubject := "WFE22- Contrato de Parceria a Vencer. "//+ aProd[1][7]+""
 oHTML    := oProcess:oHTML 
    
    //qout("Entrou no Html")
    
 cMen := " <html>"
 cMen := " <head>"
 cMen := " <title> Contrato de Parceria a vencer no prazo de 60 dias </title>"
 cMen := " </head>"    
 cMen += " <body>"
 cMen += ' <table border="1" width="750">'
 cMen += ' <tr width="750" align="center" >'
 //   cMen += ' <TD ><IMG src="\\Nsbsrv01\CORREIO\Workflow\Imagens\LogoNSB.JPG"></TD>'
 cMen += ' <td colspan=5 >Rela็ใo de contrato de parceria a vencer </td></tr>' 
 cMen += ' <tr >'
 cMen += ' <td align="center" width="06%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Contrato </Blink></font></td>'
 cMen += ' <td align="center" width="06%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Fornecedor</Blink></font></td>'
 cMen += ' <td align="center" width="40%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Nome      </Blink></font></td>'
 cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Inicio do Contrato</Blink></font></td>'
 cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Vencto do Contrato</Blink></font></td>'
//    cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>C.Custo   </Blink></font></td>'
//    cMen += ' <td align="center" width="40%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Descri็ใo do C.Custo</Blink></font></td>'
 cMen += ' </tr>'
 For x:= 1 to Len(aProd) 
    cMen += ' <tr>'
    cMen += ' <td align="center" width="06%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+aProd[x][1]+'</Blink></font></td>'
    cMen += ' <td align="center" width="06%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+aProd[x][2]+'-'+aProd[x][3]+'</Blink></font></td>'
    cMen += ' <td align="center" width="40%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+aProd[x][4]+'</Blink></font></td>'
    cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+aProd[x][5]+'</Blink></font></td>'
    cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+aProd[x][6]+'</Blink></font></td>'
    cMen += ' </tr>'
 Next 
 cMen += ' </table>'
 cMen += " </body>"
 cMen += " </html>" 
    
 oHtml:ValByName( "MENS", cMen)
  // oProcess:ClientName( Subs(aProd[1][8],7,15) )

//  _cTo := alltrim(UsrRetMail(aProd[1][9]))
  Mto:= u_MontaRec(CodRot)
  Mto:=Mto+";"+_cTo
  oProcess:cTo  := Mto
 //   oProcess:cTo := "jmoreira@nippon-seikibr.com.br" // Com Copia Oculta
    //oProcess:ATTACHFILE(cArq) - ANEXA UM ARQUIVO <CAMINHO + NOME DO ARQUIVO>
  cMailId := oProcess:Start()
 
Return