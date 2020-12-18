#INCLUDE "rwmake.ch"   
#include "ap5mail.ch"     
#Include "TOPCONN.CH"
#Include "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WFE07     ºAutor  ³Jefferson Moreira   º Data ³  21/08/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ ENVIA E-MAIL INFORMADO QUE UMA OP PARA NOVOS MODELOS FOI   º±±
±±º          ³ ABERTA                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8  - Esse grava o e-mail enviado                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

**************************
User Function MTA650I
**************************
  
  Local aProd := {}
  Local xDesc,cMen  
  Local xProd := SC2->C2_PRODUTO 
  
  DbSelectArea("SB1")
  xNovo := Posicione("SB1",1,xFilial("SB1")+ xProd,"B1_NOVO")
  
  DbSelectArea("SC2")
  
  If xNovo == "S"
  
      xOP   := C2_NUM+C2_ITEM+C2_SEQUEN
      xDesc := Posicione("SB1",1,xFilial("SB1")+ xProd,"B1_DESC")
      xCC   := C2_CC
      xQuant:= Transform(C2_QUANT,"@E 999,999")
      xData := Subs(Dtos(C2_DATPRI),7,2) + "/" + Subs(Dtos(C2_DATPRI),5,2)+ "/" + Subs(Dtos(C2_DATPRI),3,2)
      xRecur:= C2_RECURSO
      
      AAdd(aProd,{xData,;
                    xOP,;
                  xProd,;
                  xDesc,;
                 xQuant,;
                    xCC,;
                 xRecur})
   
  EndIf
     
  If Len(aProd) > 0
  
    oProcess := TWFProcess():New( "000001", "OP_ABERTA" )
    oProcess :NewTask( "100001", "\WORKFLOW\OP_ABERTA.HTM" )
    oProcess :cSubject := "WFE07 - OP ABERTA"
    oHTML    := oProcess:oHTML 
    
    
    cMen := " <html>"
    cMen := " <head>"
    cMen := " <title></title>"
    cMen := " </head>"    
    cMen += " <body>"
    cMen += ' <table border="1" width="800">'
    cMen += ' <tr width="800" align="center" >
 //   cMen += ' <TD ><IMG src="\\Nsbsrv01\CORREIO\Workflow\Imagens\LogoNSB.JPG"></TD>'
    cMen += ' <td colspan=7 > OP ABERTA </td></tr>' 
    cMen += ' <tr >'
    cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">Data     </font></td>'
    cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">OP       </font></td>'
    cMen += ' <td align="center" width="8%"  bgcolor="#FFFFFF"><font size="1" face="Times">Produto  </font></td>'
    cMen += ' <td align="center" width="20%" bgcolor="#FFFFFF"><font size="1" face="Times">Descrição</font></td>'
    cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">Quant    </font></td>'
    cMen += ' <td align="center" width="3%"  bgcolor="#FFFFFF"><font size="1" face="Times">CC       </font></td>'
    cMen += ' <td align="center" width="3%"  bgcolor="#FFFFFF"><font size="1" face="Times">Recurso  </font></td>'
    cMen += ' </tr>'
    For x:= 1 to Len(aProd) 
      cMen += ' <tr>'
      cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+aProd[x][1]+'</font></td>'
      cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+aProd[x][2]+'</font></td>'
      cMen += ' <td align="center" width="8%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+aProd[x][3]+'</font></td>'
      cMen += ' <td align="left  " width="20%" bgcolor="#FFFFFF"><font size="1" face="Times">'+aProd[x][4]+'</font></td>'
      cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+aProd[x][5]+'<//font></td>' 
      cMen += ' <td align="center" width="3%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+aProd[x][6]+'</font></td>'
      cMen += ' <td align="center" width="3%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+aProd[x][7]+'</font></td>'
      cMen += ' </tr>'
    Next 
    cMen += ' </table>'
    cMen += " </body>"
    cMen += " </html>" 
    
    oHtml:ValByName( "MENS", cMen)
//--------------------------------
	CodRot := "WFE07"  //tabela ZWF
	Mto    := u_MontaRec(CodRot)
	oProcess:cTo := Mto
	//oProcess:ATTACHFILE(cArq) - ANEXA UM ARQUIVO <CAMINHO + NOME DO ARQUIVO>
	cMailId := oProcess:Start()
//--------------------------------
//   oProcess:cTo  := "TI@nippon-seikibr.com.br"
//   oProcess:cCC  := "joaolisto@nippon-seikibr.com.br" // Com Copia
//   oProcess:cBCC := "jmoreira@nippon-seikibr.com.br" // Com Copia Oculta
//   oProcess:ATTACHFILE(cArq) - ANEXA UM ARQUIVO <CAMINHO + NOME DO ARQUIVO>
//    cMailId := oProcess:Start()
  EndIf
Return