#include "rwmake.ch"
#INCLUDE "Protheus.ch"   
#include "ap5mail.ch"     
#Include "TOPCONN.CH"
#Include "TBICONN.CH" 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WFE06     ºAutor  ³Jefferson Moreira   º Data ³  25/08/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Aviso de recebimento de MP/Equi/Disp. para modelos novos   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


********************************
User Function WFE06
********************************

aProd  := {}
cMen   := ""

 
dbSelectArea("SD1")
dbSetOrder(1)
dbSeek(xFilial("SD1")+xDoc+xSerie+xFornec+xLoja)

WHILE D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA == xDoc+xSerie+xFornec+xLoja
     
     xProd  := D1_COD
     xCod   := D1_COD
     xQuant := Transform(D1_QUANT,"@E 999,999.999")
     xNomFor:= Posicione("SA2",1,xFilial("SA2")+D1_FORNECE,"A2_NOME")
     xDesc  := Posicione("SB1",1,xFilial("SB1")+D1_COD,"B1_DESC")
         

     dbSelectArea("SB1")
     dbSetOrder(1)
     dbSeek(xFilial("SB1")+xProd) 
     
     IF B1_NOVO == "S"
              
            AAdd(aProd,{xDoc ,;    // [1] NF
                        xCod ,;    // [2] Codigo 
                        xDesc,;    // [3] Descrição
                       xQuant,;    // [4] Quantidade
                      xNomFor})    // [5] Fornecedor
                              
     ENDIF
     
    dbSelectArea("SD1")        
   
   dbSkip()    
ENDDO


//*********************************
//* Função para envio de messagens*
//*********************************
    
//Static Function sendMsg()

  If Len(aProd) > 0 
    
    oProcess := TWFProcess():New( "000003", "" )
    oProcess :NewTask( "100004", "\WORKFLOW\MODNOVO.HTM" )
    oProcess :cSubject := "WF06 - ENTRADA"
    oHTML    := oProcess:oHTML
        
    aMen := " <html>"
    cMen := " <head>"
    cMen := " <title></title>"
    cMen := " </head>"  
    cMen += " <body>"
    cMen += ' <table border="1" width="800">'
    cMen += ' <td colspan=5 align="center"> WFE06 - EQUIPAMENTOS / DISPOSITIVOS / MATERIA-PRIMA </td></tr>'
    cMen += ' <tr >'
    cMen += ' <td align="center" width="03%"><font size="1" face="Times">Nota Fiscal</td>'
    cMen += ' <td align="center" width="03%"><font size="1" face="Times">Codigo     </td>'
    cMen += ' <td align="center" width="15%"><font size="1" face="Times">Descrição  </td>'
    cMen += ' <td align="center" width="03%"><font size="1" face="Times">Quantidade </td>'
    cMen += ' <td align="center" width="15%"><font size="1" face="Times">Fornecedor </td>'
    cMen += ' </tr>'
      For x:= 1 to Len(aProd)
        cMen += ' <tr>'
        cMen += ' <td align="center" width="03%"><font size="1" face="Times">'+ aProd[x][1] +'</td>'
        cMen += ' <td align="center" width="03%"><font size="1" face="Times">'+ aProd[x][2] +'</td>'
        cMen += ' <td align="left  " width="15%"><font size="1" face="Times">'+ aProd[x][3] +'</td>'
        cMen += ' <td align="center" width="03%"><font size="1" face="Times">'+ aProd[x][4] +'</td>'
        cMen += ' <td align="left  " width="15%"><font size="1" face="Times">'+ aProd[x][5] +'</td>'
        cMen += ' </tr>'
    
      Next
    cMen += ' </table>'
    cMen += " </body>"
    cMen += " </html>" 

   CodRot:="WFE06"   
   Mto:= u_MontaRec(CodRot)
       
   oHtml:ValByName( "MENS", cMen)
   oProcess:cTo  := Mto
   cMailId := oProcess:Start()
     
  EndIf

  ConOut("Finalizou")

Return