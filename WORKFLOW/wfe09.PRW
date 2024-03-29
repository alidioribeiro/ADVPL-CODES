#INCLUDE "rwmake.ch"   
#include "ap5mail.ch"     
#Include "TBICONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �WFE09     �Autor  �Jefferson Moreira   � Data �  23/02/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � ENVIA E-MAIL INFORMANDO O APONTAMENTO DE PRODU��O.         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP8  - Esse grava o e-mail enviado                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

************************************** 
  User Function WFE09 
**************************************  

       
        xOP  := M->D3_OP
       xProd := M->D3_COD
      xQuant := Transform(M->D3_QUANT,"@E 999,999")
      xLocal := M->D3_LOCAL
       xDoc  := M->D3_DOC
    xRecurso := Posicione("SC2",1,xFilial("SC2")+ xOP,"C2_RECURSO")
    xEmissao := Subs(Dtos(M->D3_EMISSAO),7,2) + "/" + Subs(Dtos(M->D3_EMISSAO),5,2)+ "/" + Subs(Dtos(M->D3_EMISSAO),3,2)
        xCC  := Posicione("SC2",1,xFilial("SC2")+ xOP,"C2_CC")
       xUser := Subs(cUsuario,7,15)     
       xDesc := Posicione("SB1",1,xFilial("SB1")+ xProd,"B1_DESC") 

  if alltrim(xCC) = "211"
    
    oProcess := TWFProcess():New( "000001", "Apontamento de Produ��o" )
    oProcess :NewTask( "100001", "\WORKFLOW\Apontamento.HTM" )
    oProcess :cSubject := "WFE09 - Apontamento de Produ��o"
    oHTML    := oProcess:oHTML 
    
    
    cMen := " <html>"
    cMen += " <head>"
    cMen += " <title></title>"
    cMen += " </head>"    
    cMen += " <body>"
    cMen += ' <table border="1" width="1000">'
    cMen += ' <tr width="1000" align="center" >
 //   cMen += ' <TD ><IMG src="\\Nsbsrv01\CORREIO\Workflow\Imagens\LogoNSB.JPG"></TD>'
    cMen += ' <td colspan=10 > MATERIAL APONTADO </td></tr>' 
    cMen += ' <tr >'
    cMen += ' <td align="center" width="4%"  bgcolor="#FFFFFF"><font size="1" face="Times">Op         </font></td>'  //[1]
    cMen += ' <td align="center" width="7%"  bgcolor="#FFFFFF"><font size="1" face="Times">Produto    </font></td>'  //[2]
    cMen += ' <td align="center" width="20%" bgcolor="#FFFFFF"><font size="1" face="Times">Descri��o  </font></td>'  //[3]
    cMen += ' <td align="center" width="2%"  bgcolor="#FFFFFF"><font size="1" face="Times">Local      </font></td>'  //[4]
    cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">Recurso    </font></td>'  //[5]
    cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">Documento  </font></td>'  //[6] 
    cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">C.Custo    </font></td>'  //[7]
    cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">Quantidade </font></td>'  //[8]
    cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">Emiss�o    </font></td>'  //[9]
    cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">Usuario    </font></td>'  //[10]
    cMen += ' </tr>'

    cMen += ' <tr>'
    cMen += ' <td align="center" width="4%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+xOP+      '</font></td>'  //[1]
    cMen += ' <td align="center" width="7%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+xProd+    '</font></td>'  //[2]
    cMen += ' <td align="center" width="20%" bgcolor="#FFFFFF"><font size="1" face="Times">'+xDesc+    '</font></td>'  //[3]
    cMen += ' <td align="center" width="2%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+xLocal+   '</font></td>'  //[4]
    cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+xRecurso+ '</font></td>'  //[5]
    cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+xDoc+     '</font></td>'  //[6] 
    cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+xCC+      '</font></td>'  //[7]
    cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+xQuant+   '<//font></td>' //[8]
    cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+xEmissao+ '<//font></td>' //[9]      
    cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+xUser+    '</font></td>'  //[10]
    cMen += ' </tr>'

    cMen += ' </table>'
    cMen += " </body>"
    cMen += " </html>" 
    
    oHtml:ValByName( "MENS", cMen)
   CodRot:="WFE09"   
    Mto:= u_MontaRec(CodRot)
    oProcess:cTo :=Mto
   // oProcess:ClientName( Subs(cUsuario,7,15) )
//    oProcess:cTo  := "paulo@nippon-seikibr.com.br;wagner@nippon-seikibr.com.br;allan@nippon-seikibr.com.br"
//    oProcess:cCC  := "edyikeoka@nippon-seikibr.com.br;ruthf@nippon-seikibr.com.br" // Com Copia
 //   oProcess:cBCC := "jmoreira@nippon-seikibr.com.br" // Com Copia Oculta
  
    cMailId := oProcess:Start()
    
  EndIf

Return 