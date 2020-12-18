#INCLUDE "rwmake.ch"
//#INCLUDE "Protheus.ch"   // Problema com a janela inicial
#include "ap5mail.ch"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"


//Workflow de funcionários admimitidos no mês
User Function WFE202
********************************  
  Local vFunc := {}
  Local cProd,cMen 
  Local CodRot:="WFE202"
  Local CCusto:=""                                     
  
// Prepare Environment Empresa "01" Filial "01" Tables "SRA","CTT"  // Usado apenas quando o uso for por agendamento
// Prepare Environment Empresa "02" Filial "01" Tables "SRA","CTT"
  
 
 cQuery:= " SELECT RA_MAT,RA_NOME,SUBSTRING(RA_ADMISSA,7,2)+'/'+SUBSTRING(RA_ADMISSA,5,2)+'/'+SUBSTRING(RA_ADMISSA,1,4) AS ADM,RA_CC,CTT_DESC01,CTT_GER, " 
 cQuery+="  RJ_DESC,RA_SALARIO,' ' AS RA_DTEFIC  "
 cQuery+= " FROM SRA010  AS SRA, CTT010   AS CTT ,SRJ010 AS SRJ   "
 cQuery+=" where   " 
 cQuery+=" datediff(day, RA_ADMISSA, getdate())>=344 and "
 cQuery+=" datediff(day, RA_ADMISSA, getdate())<360 and " 
 cQuery+=" RA_DEMISSA='' and   "  
 cQuery+=" (RA_CC=CTT_CUSTO) and  (RA_CODFUNC=RJ_FUNCAO) and "
 cQuery+=" CTT.D_E_L_E_T_='' AND SRA.D_E_L_E_T_='' and RA_CC=CTT_CUSTO AND SRJ.D_E_L_E_T_=''   "

// cQuery +=" order BY RA_CC  "
 cQuery +=" ORDER BY RA_CC  "


 TCQUERY cQuery NEW ALIAS "TRB"

  

  DbSelectArea("TRB")
//  DbSetOrder(1)
  DbGotop()
  if !Eof()
  	CCusto:=TRB->RA_CC
  Endif 
  While !Eof()                                                          
       IF cCusto<>TRB->RA_CC	
	      EnviaEmail(vFunc,CodRot)
	      vFunc:={}
	      cCusto:=TRB->RA_CC
       EndIf
       AaDD(vFunc,{ TRB->RA_MAT,TRB->RA_NOME, TRB->RJ_DESC,TRB->ADM, TRB->RA_CC,TRB->CTT_DESC01,TRB->RA_SALARIO,TRB->CTT_GER})
       DbSelectArea("TRB")
       DbSkip()
  EndDo 

If Len(vFunc)>0
	EnviaEmail(vFunc,CodRot)
Endif
DbSelectArea("TRB")
DbCloseArea()
Return 



Static Function 	EnviaEmail(vFunc,CodRot)
Local _cTo:=""  
  
    oProcess := TWFProcess():New( "000202", "Funcionario prestes a fazer 1 ano de empresa " )
    oProcess :NewTask( "100001", "\WORKFLOW\ANOSADM.HTML" )
    oProcess :cSubject := "WFE202 - Relação de funcionários. "+ vFunc[1][6]+""
    oHTML    := oProcess:oHTML 
    
    //qout("Entrou no Html")
    
    cMen := " <html>"
    cMen := " <head>"
    cMen := " <title> Contrato de Experiencia  Vencendo </title>"
    cMen := " </head>"    
    cMen += " <body>"
    cMen += ' <table border="1" width="750">'
    cMen += ' <tr width="750" align="center" >'
 //   cMen += ' <TD ><IMG src="\\Nsbsrv01\CORREIO\Workflow\Imagens\LogoNSB.JPG"></TD>'
    cMen += ' <td colspan=4 >Relação de funcionários com contrato de experiência vencendo</td></tr>' 
    cMen += ' <tr >'
    cMen += ' <td align="center" width="06%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Matricula </Blink></font></td>'
    cMen += ' <td align="center" width="40%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Nome     </Blink></font></td>'
    cMen += ' <td align="center" width="40%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Funcao    </Blink></font></td>'
    cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Admissão </Blink></font></td>'
//    cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Salario </Blink></font></td>'
//    cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>C.Custo   </Blink></font></td>'
//    cMen += ' <td align="center" width="40%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Descrição do C.Custo</Blink></font></td>'
    cMen += ' </tr>'
    For x:= 1 to Len(vFunc) 
      cMen += ' <tr>'
      cMen += ' <td align="center" width="06%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+vFunc[x][1]+'</Blink></font></td>'
      cMen += ' <td align="center" width="40%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+vFunc[x][2]+'</Blink></font></td>'
      cMen += ' <td align="center" width="40%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+vFunc[x][3]+'</Blink></font></td>'
      cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+vFunc[x][4]+'</Blink></font></td>'
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

    _cTo := alltrim(UsrRetMail(vFunc[1][8]))
    Mto:= u_MontaRec(CodRot)
    Mto:=Mto+";"+_cTo
    oProcess:cTo  := Mto

 //   oProcess:cTo := "jmoreira@nippon-seikibr.com.br" // Com Copia Oculta
    //oProcess:ATTACHFILE(cArq) - ANEXA UM ARQUIVO <CAMINHO + NOME DO ARQUIVO>
    cMailId := oProcess:Start()
 
Return