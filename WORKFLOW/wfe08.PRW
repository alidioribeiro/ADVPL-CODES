#INCLUDE "rwmake.ch"   
#include "ap5mail.ch"     
#Include "TOPCONN.CH"
#Include "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WFE08     ºAutor  ³Jefferson Moreira   º Data ³  06/09/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ ENVIA E-MAIL INFORMANDO OS MATERIAIS REJEITADOS PELO C.Q.  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8  - Esse grava o e-mail enviado                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

************************************** 
  User Function MT175ATU   //WFE08 
**************************************  
  
  
  Local xRej := {}
  Local xDesc,cMen  
  Local xProd := SD7->D7_PRODUTO 
  Local xDoc  := SD7->D7_DOC
  Local xForn := SD7->D7_FORNECE
  Local xLote := SD7->D7_LOTECTL
     
  xDesc   := Posicione("SB1",1,xFilial("SB1")+ xProd,"B1_DESC") 
  xNomFor := Posicione("SA2",1,xFilial("SA2")+ xForn,"A2_NOME")
  xSaldo  := Transform(SD7->D7_SALDO,"@E 999,999")                                                
  DbSelectArea("SD7") 
  
  For x:=1 to len (aCols)
   
     If aCols[x][7] == 2 .and. aCols[x][2]== "  " // If aCols[x][7] == 2
      
      xQuant:= Transform(aCols[x][9],"@E 999,999")
      xData := Subs(Dtos(aCols[x][13]),7,2) + "/" + Subs(Dtos(aCols[x][13]),5,2)+ "/" + Subs(Dtos(aCols[x][13]),3,2)
      xDef  := Posicione("SZC",1,xFilial("SZC")+ aCols[x][21],"ZC_TIPODEF")
      yDef  := Iif (!Empty(aCols[x][21]),xDef,"NÃO INFORMADO")
      zDef  := Iif (!Empty(xDef),aCols[x][21],"X")
      
      AAdd(xRej,{xQuant,;       // Quantidade
                 aCols[x][12],; // Usuario
                 zDef,;         // Motivo da rejeição
                 yDef,;         // Desc do Motivo 
                 aCols[x][16]}) // Loc destino
                    
      ENDIF
 
  Next 
  

  If Len(xRej) > 0
  
    oProcess := TWFProcess():New( "000001", "REJEICAO" )
    oProcess :NewTask( "100001", "\WORKFLOW\REJEICAO.HTM" )
    oProcess :cSubject := "WFE08 - MATERIAL REJEITADO NO ARMAZEM 98"
    oHTML    := oProcess:oHTML 
    
    
    cMen := " <html>"
    cMen := " <head>"
    cMen := " <title></title>"
    cMen := " </head>"    
    cMen += " <body>"
    cMen += ' <table border="1" width="1250">'
    cMen += ' <tr width="1250" align="center" >
 //   cMen += ' <TD ><IMG src="\\Nsbsrv01\CORREIO\Workflow\Imagens\LogoNSB.JPG"></TD>'
    cMen += ' <td colspan=12 > MATERIAL REJEITADO NO ARMAZEM 98</td></tr>' 
    cMen += ' <tr >'
    cMen += ' <td align="center" width="4%"  bgcolor="#FFFFFF"><font size="1" face="Times">Data       </font></td>'  //[1]
    cMen += ' <td align="center" width="7%"  bgcolor="#FFFFFF"><font size="1" face="Times">Produto    </font></td>'  //[2]
    cMen += ' <td align="center" width="20%" bgcolor="#FFFFFF"><font size="1" face="Times">Descrição  </font></td>'  //[3]
    cMen += ' <td align="center" width="3%"  bgcolor="#FFFFFF"><font size="1" face="Times">NF         </font></td>'  //[4]
    cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">Lote       </font></td>'  //[5]
    cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">Quant Total</font></td>'  //[6] 
    cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">Usuario    </font></td>'  //[7]
    cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">Quant Rej. </font></td>'  //[8]
    cMen += ' <td align="center" width="2%"  bgcolor="#FFFFFF"><font size="1" face="Times">Loc. Dest. </font></td>'  //[9]
    cMen += ' <td align="center" width="2%"  bgcolor="#FFFFFF"><font size="1" face="Times">Motivo     </font></td>'  //[10]
    cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times">Des.Mot    </font></td>'  //[11]
    cMen += ' <td align="center" width="15%" bgcolor="#FFFFFF"><font size="1" face="Times">Fornecedor </font></td>'  //[12]
    cMen += ' </tr>'
    For x:= 1 to Len(xRej) 
      cMen += ' <tr>'
      cMen += ' <td align="center" width="4%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+xData+     '</font></td>'  //[1]
      cMen += ' <td align="center" width="7%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+xProd+     '</font></td>'  //[2]
      cMen += ' <td align="center" width="20%" bgcolor="#FFFFFF"><font size="1" face="Times">'+xDesc+     '</font></td>'  //[3]
      cMen += ' <td align="center" width="3%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+xDoc+      '</font></td>'  //[4]
      cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+xLote+     '</font></td>'  //[5]
      cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+xSaldo+    '</font></td>'  //[6] 
      cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+xRej[x][2]+'</font></td>'  //[7]
      cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+xRej[x][1]+'<//font></td>' //[8]
      cMen += ' <td align="center" width="2%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+xRej[x][5]+'<//font></td>' //[9]      
      cMen += ' <td align="center" width="2%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+xRej[x][3]+'</font></td>'  //[10]
      cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times">'+xRej[x][4]+'</font></td>'  //[11]
      cMen += ' <td align="center" width="15%" bgcolor="#FFFFFF"><font size="1" face="Times">'+xNomFor+   '</font></td>'  //[12]
      cMen += ' </tr>'
    Next 
    cMen += ' </table>'
    cMen += " </body>"
    cMen += " </html>" 
    
    oHtml:ValByName( "MENS", cMen)
   // oProcess:ClientName( Subs(cUsuario,7,15) )
    CodRot:="WFE08"   
    Mto:= u_MontaRec(CodRot)
    oProcess:cTo :=Mto
//    oProcess:cTo  := "walderez@nippon-seikibr.com.br;paulo@nippon-seikibr.com.br;rosicleide@nippon-seikibr.com.br;debora@nippon-seikibr.com.br;leonel@nippon-seikibr.com.br"
//    oProcess:cCC  := "edyikeoka@nippon-seikibr.com.br;ruthf@nippon-seikibr.com.br;joaquim@nippon-seikibr.com.br" // Com Copia
 //   oProcess:cBCC := "jmoreira@nippon-seikibr.com.br" // Com Copia Oculta
  
    cMailId := oProcess:Start()
    
  EndIf

Return 