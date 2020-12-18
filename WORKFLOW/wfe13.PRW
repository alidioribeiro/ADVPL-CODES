#INCLUDE "rwmake.ch"   
#INCLUDE "Protheus.ch"   
#include "ap5mail.ch"     
#Include "TOPCONN.CH"
#Include "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WFE13     ºAutor  ³Jefferson Moreira   º Data ³  01/04/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ ENVIA PARA O SGI A RELACAO DOS FORNECEDORES QUE ESTAM      º±±
±±º          ³ PRESTES A VENCER A LICENCA DE LO E LFP                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8  - Esse grava o e-mail enviado                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

********************************
  User Function WFE13
********************************  
  Local aEnvia := {}
  Local cProd,cMen 
  Local x
  
  Prepare Environment Empresa "01" Filial "01" Tables "SZL"  // Usado apenas quando o uso for por agendamento                                                         JJ
  
  DbSelectArea("SZL")
  DbSetOrder(1)
  DbGotop()
  While !SZL->(Eof())
//        If ZL_DATVAL < (dDataBase+30)
        If ZL_DATVAL < (Date() + 30)
           cFor  := Posicione("SA2",1,xFilial("SA2")+ ZL_CODFOR,"A2_NOME")
           cData := Subs(Dtos(ZL_DATVAL),7,2) + "/" + Subs(Dtos(ZL_DATVAL),5,2)+ "/" + Subs(Dtos(ZL_DATVAL),3,2)
           AAdd(aEnvia,{ZL_CODFOR,cFor,ZL_CODVAL,cData,RetField("SX5",1,xFilial("SX5")+"ZL"+ZL_CODVAL,"X5_DESCRI")})
        EndIf
        SZL->(DbSkip())
  End
   
  If Len(aEnvia) > 0
  
     oProcess := TWFProcess():New( "000001", "WFE13 - Validade dos Fornecedores" ) //000019
     oProcess :NewTask( "100001", "\WORKFLOW\LICFOR.HTM" )
     oProcess :cSubject := "WFE13 - Monitoramento de Fornecedores"
     oHTML    := oProcess:oHTML 
    
     // qout("Entrou no Html")
    
     cMen := " <html>"
    
     cMen += " <body>"
     cMen += ' <table border="1" width="750">'
     cMen += ' <tr width="600" align="center" >'
  //   cMen += ' <TD ><IMG src="\\Nsbsrv01\CORREIO\Workflow\Imagens\LogoNSB.JPG"></TD>'
     cMen += ' <td colspan=4 >Relação de Fornecedores </td></tr>' 
     cMen += ' <tr >'
     cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>CodFor   </Blink></font></td>'
     cMen += ' <td align="center" width="30%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>NomeFor  </Blink></font></td>'
     cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>CodLic   </Blink></font></td>'
     cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Validade </Blink></font></td>'
     cMen += ' <td align="center" width="30%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Descri.Lic </Blink></font></td>'
     cMen += ' </tr>'
     For x:= 1 to Len(aEnvia) 
         cMen += ' <tr>'
         cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+aEnvia[x][1]+'</Blink></font></td>'
         cMen += ' <td align="center" width="30%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+aEnvia[x][2]+'</Blink></font></td>'
         cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+aEnvia[x][3]+'</Blink></font></td>'
         cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+aEnvia[x][4]+'</Blink></font></td>'
         cMen += ' <td align="center" width="30%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+aEnvia[x][5]+'</Blink></font></td>'
         cMen += ' </tr>'
     Next 
     cMen += ' </table>'
     cMen += " </body>"
     cMen += " </html>" 
    
     oHtml:ValByName( "MENS", cMen)
  //   oProcess:ClientName( Subs(cUsuario,7,15) )
	CodRot:="WFE13"
	Mto:= u_MontaRec(CodRot)
 	oProcess:cTo  :=Mto
      //   oProcess:ATTACHFILE(cArq) - ANEXA UM ARQUIVO <CAMINHO + NOME DO ARQUIVO>
     cMailId := oProcess:Start()
  // qout("E-mail enviado com sucesso!!!")
  EndIf
 
Return