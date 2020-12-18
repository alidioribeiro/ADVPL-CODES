#INCLUDE "rwmake.ch"
//#INCLUDE "Protheus.ch"   // Problema com a janela inicial
#include "ap5mail.ch"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
Contrato de parceir
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function WFE201
********************************  
  Local vFunc := {}
  Local cProd,cMen 
  Local CodRot:="WFE201"
  Local CCusto:=""                                     
  
 Prepare Environment Empresa "01" Filial "01" Tables "SRA","CTT"  // Usado apenas quando o uso for por agendamento
 Prepare Environment Empresa "02" Filial "01" Tables "SRA","CTT"
  
 
 cQuery:=" SELECT RA_MAT,RA_NOME,substring(RA_ADMISSA,7,2)+'/'+substring(RA_ADMISSA,5,2)+'/'+substring(RA_ADMISSA,1,4) as RA_ADMISSA,"
 cQuery+="  RA_CC,CTT_DESC01,CTT_GER,RJ_DESC,RA_SALARIO,RA_SALINI "
 cQuery+=" FROM SRA010  AS SRA, CTT010   AS CTT ,SRJ010 AS SRJ   "
 cQuery+=" where 
 cQuery+=" RA_CC=CTT_CUSTO and  RA_CODFUNC=RJ_FUNCAO AND "
 cQuery+=" SRA.D_E_L_E_T_='' and RA_CC=CTT_CUSTO AND SRJ.D_E_L_E_T_=''  AND CTT.D_E_L_E_T_='' "
 cQuery+=" AND RA_ADMISSA ='"+Dtos(DDatabase-1)+"'"
// cQuery+=" AND substring(RA_ADMISSA,1,6)='201108'"
 cQuery+=" UNION "
 cQuery+=" SELECT RA_MAT,RA_NOME,substring(RA_ADMISSA,7,2)+'/'+substring(RA_ADMISSA,5,2)+'/'+substring(RA_ADMISSA,1,4) as RA_ADMISSA,"
 cQuery+="  RA_CC,CTT_DESC01,CTT_GER,RJ_DESC,RA_SALARIO,RA_SALINI "
 cQuery+=" FROM SRA020  AS SRA, CTT010   AS CTT ,SRJ010 AS SRJ   "
 cQuery+=" where 
 cQuery+=" RA_CC=CTT_CUSTO and  RA_CODFUNC=RJ_FUNCAO  "
 cQuery+=" AND SRA.D_E_L_E_T_='' and RA_CC=CTT_CUSTO AND SRJ.D_E_L_E_T_=''  AND CTT.D_E_L_E_T_='' "
 cQuery+=" AND RA_ADMISSA ='"+Dtos(DDatabase-1)+"'"
// cQuery+=" AND substring(RA_ADMISSA,1,6)='201108'"
 cQuery +=" ORDER BY RA_ADMISSA  "


 TCQUERY cQuery NEW ALIAS "TRB"

  
  DbSelectArea("TRB")
//  DbSetOrder(1)
  DbGotop()
  While !Eof()                                                          
       AaDD(vFunc,{ TRB->RA_MAT,TRB->RA_NOME, TRB->RA_ADMISSA,TRB->RA_CC,TRB->CTT_DESC01,TRB->RA_SALARIO,TRB->RA_SALINI})
       DbSkip()
  EndDo 

If Len(vFunc)>0
	EnvEmFunc(vFunc,CodRot)
Endif
DbSelectArea("TRB")
DbCloseArea()
Return 
//*******************************************************************************************************************/
//*******************************************************************************************************************/
//*ADMISSÃO
//*******************************************************************************************************************/

Static Function EnvEmFunc(vFunc,CodRot)
Local _cTo:=""  
  
    oProcess := TWFProcess():New( "000001", "Funcionários admitidos no periodo "+DtoC(DDataBase-1) )
    oProcess :NewTask( "100001", "\WORKFLOW\ADMSRA.HTML" )
    oProcess :cSubject := "WFE201-Funcionários admitidos no dia "+DtoC(DDataBase-1)+"."
    oHTML    := oProcess:oHTML 
    
    //qout("Entrou no Html")
    
    cMen := " <html>"
    cMen := " <head>"
    cMen := " <title> Funcionários admitidos no período</title>"
    cMen := " </head>"    
    cMen += " <body>"
    cMen += ' <table border="1" width="750">'
    cMen += ' <tr width="750" align="center" >'
 //   cMen += ' <TD ><IMG src="\\Nsbsrv01\CORREIO\Workflow\Imagens\LogoNSB.JPG"></TD>'
//       AaDD(vFunc,{ TRB->RA_MAT,TRB->RA_NOME, TRB->RA_ADMISSA,TRB->RA_CC,TRB->CTT_DESC01, TRB->CTT_GER,TRB->RJ_DESC,TRB->RA_SALARIO,TRB->RA_SALINI})

    cMen += ' <td colspan=7 >Relação de funcionários admitidos no dia</td></tr>' 
    cMen += ' <tr >'
    cMen += ' <td align="center" width="06%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Matricula </Blink></font></td>'
    cMen += ' <td align="center" width="40%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Nome     </Blink></font></td>'
    cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Data Admissão</Blink></font></td>'
    cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>CCusto</Blink></font></td>'
    cMen += ' <td align="center" width="40%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Desc.Custo</Blink></font></td>'
    cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Salário </Blink></font></td>'
    cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Salário Inicial</Blink></font></td>'
    cMen += ' </tr>'
    For x:= 1 to Len(vFunc) 
      cMen += ' <tr>'
      cMen += ' <td align="center" width="06%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+vFunc[x][1]+'</Blink></font></td>'
      cMen += ' <td align="center" width="40%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+vFunc[x][2]+'</Blink></font></td>'
      cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+vFunc[x][3]+'</Blink></font></td>'
      cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+vFunc[x][4]+'</Blink></font></td>'
      cMen += ' <td align="center" width="40%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+vFunc[x][5]+'</Blink></font></td>'
      cMen += ' <td align="center" width="15%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+Transform(vFunc[x][6],"@E 9,999,999.99")+'</Blink></font></td>'
       cMen += ' <td align="center" width="15%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+Transform(vFunc[x][7],"@E 9,999,999.99")+'</Blink></font></td>'
//      cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+Transform(vFunc[x][8],"@E 9,999,999.99")+'</Blink></font></td>'
 //     cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+aProd[x][6]+'</Blink></font></td>'
//      cMen += ' <td align="center" width="40%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+aProd[x][7]+'</Blink></font></td>'
      cMen += ' </tr>'
    Next 
    cMen += ' </table>'
    cMen += " </body>"
    cMen += " </html>" 
    
    oHtml:ValByName( "MENS", cMen)
  // oProcess:ClientName( Subs(aProd[1][8],7,15) )
    Mto:= u_MontaRec(CodRot)
    Mto:=Mto+";"+_cTo
    oProcess:cTo  := Mto

 //   oProcess:cTo := "jmoreira@nippon-seikibr.com.br" // Com Copia Oculta
    //oProcess:ATTACHFILE(cArq) - ANEXA UM ARQUIVO <CAMINHO + NOME DO ARQUIVO>
    cMailId := oProcess:Start()
 
Return


