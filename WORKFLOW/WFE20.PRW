#INCLUDE "rwmake.ch"
//#INCLUDE "Protheus.ch"   // Problema com a janela inicial
#include "ap5mail.ch"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
Contrato de parceir
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function WFE20
********************************  
  Local vFunc := {}
  Local cProd,cMen 
  Local CodRot:="WFE20"
  Local CCusto:=""                                     
  
 Prepare Environment Empresa "01" Filial "01" Tables "SRA","CTT"  // Usado apenas quando o uso for por agendamento
 Prepare Environment Empresa "02" Filial "01" Tables "SRA","CTT"
  
 
 cQuery:= " SELECT RA_MAT,RA_NOME,SUBSTRING(RA_VCTOEXP,7,2)+'/'+SUBSTRING(RA_VCTOEXP,5,2)+'/'+SUBSTRING(RA_VCTOEXP,1,4) AS VENCEX,RA_CC,CTT_DESC01,CTT_GER, " 
 cQuery+=" SUBSTRING(RA_VCTEXP2,7,2)+'/'+SUBSTRING(RA_VCTEXP2,5,2)+'/'+SUBSTRING(RA_VCTEXP2,1,4) AS VENCEX2, RJ_DESC,RA_SALARIO,' ' AS RA_DTEFIC  "
 cQuery+= " FROM SRA010  AS SRA, CTT010   AS CTT ,SRJ010 AS SRJ   "
 cQuery+=" where ( (datediff(day,getdate(),RA_VCTOEXP) <16  and Datediff(day,getdate(),RA_VCTOEXP) >5 )  or  " 
 cQuery+="  (datediff(day,getdate(),RA_VCTEXP2) <16  and Datediff(day,getdate(),RA_VCTEXP2) >5 ) ) and RA_DEMISSA='' AND  "  
 cQuery+=" (RA_CC=CTT_CUSTO) and  (RA_CODFUNC=RJ_FUNCAO) AND "
 cQuery+=" RA_VCTOEXP<>'' and CTT.D_E_L_E_T_='' AND SRA.D_E_L_E_T_='' and RA_CC=CTT_CUSTO AND SRJ.D_E_L_E_T_=''   "
// cQuery +=" order BY RA_CC  "
 cQuery+=" UNION "
 cQuery+= " SELECT RA_MAT,RA_NOME,SUBSTRING(RA_VCTOEXP,7,2)+'/'+SUBSTRING(RA_VCTOEXP,5,2)+'/'+SUBSTRING(RA_VCTOEXP,1,4) AS VENCEX,RA_CC,CTT_DESC01,CTT_SUP, " 
 cQuery+=" SUBSTRING(RA_VCTEXP2,7,2)+'/'+SUBSTRING(RA_VCTEXP2,5,2)+'/'+SUBSTRING(RA_VCTEXP2,1,4) AS VENCEX2, RJ_DESC,RA_SALARIO,RA_DTEFIC"
 cQuery+= " FROM SRA020  AS SRA, CTT010   AS CTT ,SRJ020 AS SRJ   "
 cQuery+=" where ( (datediff(day,getdate(),RA_VCTOEXP) <16  and Datediff(day,getdate(),RA_VCTOEXP) >5 )  or  " 
 cQuery+="  (datediff(day,getdate(),RA_VCTEXP2) <16  and Datediff(day,getdate(),RA_VCTEXP2) >5 ) ) and   RA_DEMISSA ='' AND  "  
 cQuery+=" (RA_CC=CTT_CUSTO) and  (RA_CODFUNC=RJ_FUNCAO) AND "
 cQuery+=" RA_VCTOEXP<>'' and CTT.D_E_L_E_T_='' AND SRA.D_E_L_E_T_='' and RA_CC=CTT_CUSTO AND SRJ.D_E_L_E_T_=''   "

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
       AaDD(vFunc,{ TRB->RA_MAT,TRB->RA_NOME, TRB->RJ_DESC,TRB->VENCEX,TRB->VENCEX2, TRB->RA_CC,TRB->CTT_DESC01,TRB->RA_SALARIO,TRB->CTT_GER})
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
lOCAL x 
  
    oProcess := TWFProcess():New( "000005", "Funcionario com Experi๊ncia a vencer do departamento " )
    oProcess :NewTask( "100005", "\WORKFLOW\CONTV.HTM" )
    oProcess :cSubject := "WFE20- Contrato de Experi๊ncia  Vencendo. "+ vFunc[1][7]+""
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
    cMen += ' <td colspan=6 >Rela็ใo de funcionแrios com contrato de experi๊ncia vencendo</td></tr>' 
    cMen += ' <tr >'
    cMen += ' <td align="center" width="06%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Matricula </Blink></font></td>'
    cMen += ' <td align="center" width="40%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Nome     </Blink></font></td>'
    cMen += ' <td align="center" width="40%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Funcao    </Blink></font></td>'
    cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Vencto da 1. Exp </Blink></font></td>'
    cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Vencto da 2. Exp </Blink></font></td>'
//    cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Salario </Blink></font></td>'
//    cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>C.Custo   </Blink></font></td>'
//    cMen += ' <td align="center" width="40%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Descri็ใo do C.Custo</Blink></font></td>'
    cMen += ' </tr>'
    For x:= 1 to Len(vFunc) 
      cMen += ' <tr>'
      cMen += ' <td align="center" width="06%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+vFunc[x][1]+'</Blink></font></td>'
      cMen += ' <td align="center" width="40%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+vFunc[x][2]+'</Blink></font></td>'
      cMen += ' <td align="center" width="40%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+vFunc[x][3]+'</Blink></font></td>'
      cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+vFunc[x][4]+'</Blink></font></td>'
      cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+vFunc[x][5]+'</Blink></font></td>'
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

    _cTo := alltrim(UsrRetMail(vFunc[1][9]))
    Mto:= u_MontaRec(CodRot)
    Mto:=Mto //+";"+_cTo
    oProcess:cTo  := Mto

 //   oProcess:cTo := "jmoreira@nippon-seikibr.com.br" // Com Copia Oculta
    //oProcess:ATTACHFILE(cArq) - ANEXA UM ARQUIVO <CAMINHO + NOME DO ARQUIVO>
    cMailId := oProcess:Start()

 
Return