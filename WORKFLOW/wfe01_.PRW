#INCLUDE "rwmake.ch"   
#INCLUDE "Protheus.ch"   
#include "ap5mail.ch"     
#Include "TOPCONN.CH"
#Include "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WFE01     ºAutor  ³Jefferson Moreira   º Data ³  21/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ ENVIA PARA OS RESPONSAVEIS A RELAÇÃO DE ITENS EM INSPEÇÃO  º±±
±±º          ³ COM DE 24Hr DE SALDO NO ARMAZEM 98                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8 - Esse não grava o e-mail enviado                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/



User Function WFE01_
  Local aProd := {}
  Local cProd,cMen 
  
  Prepare Environment Empresa "01" Filial "01" Tables "SB1","SD7"
  
  DbSelectArea("SD7")
  DbSetOrder(1)
  DbGotop()
  While !SD7->(Eof())
    If SD7->D7_LIBERA # "S" .AND. (SD7->D7_DATA < dDataBase)
      cProd := Posicione("SB1",1,xFilial("SB1")+SD7->D7_PRODUTO,"B1_DESC")
      xSaldo:= Transform(SD7->D7_SALDO,"@E 999,999.99")
      xData := Subs(Dtos(D7_DATA),7,2) + "/" + Subs(Dtos(D7_DATA),5,2)+ "/" + Subs(Dtos(D7_DATA),3,2)
      xDoc  := IIF(Empty(D7_DOC),D7_LOTECTL,D7_DOC)
      AAdd(aProd,{xDoc,xData,D7_PRODUTO,cProd,xSaldo})
    EndIf
    SD7->(DbSkip())
  End
   
  If Len(aProd) > 0
      
    cMen := " <html>"
    cMen := " <head>"
    cMen := " <title> Relação de Produtos Não Baixados </title>"
    cMen := " </head>"    
    cMen += " <body>"
    cMen += ' <table border="1" width="600">'
    cMen += ' <tr width="600" align="center" >
    cMen += ' <TD ><IMG src="\\Nsbsrv01\correio\TI\IMG\Nippon2.JPG"></TD>'
    cMen += ' <td colspan=4 > Relação de Produtos Não Baixados no Armazem 98</td></tr>' 
    cMen += ' <tr >'
    cMen += ' <td align="center" width="8%"  bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Documento      </Blink></font></td>'
    cMen += ' <td align="center" width="8%"  bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Data da Entrada</Blink></font></td>'
    cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Produto        </Blink></font></td>'
    cMen += ' <td align="center" width="20%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Descrição      </Blink></font></td>'
    cMen += ' <td align="center" width="8%"  bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Saldo          </Blink></font></td>'
    cMen += ' </tr>'
    For x:= 1 to Len(aProd) 
      cMen += ' <tr>'
      cMen += ' <td align="center" width="8%"  bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+aProd[x][1]+'</Blink></font></td>'
      cMen += ' <td align="center" width="8%"  bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+aProd[x][2]+'</Blink></font></td>'
      cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+aProd[x][3]+'</Blink></font></td>'
      cMen += ' <td align="left  " width="20%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+aProd[x][4]+'</Blink></font></td>'
      cMen += ' <td align="center" width="8%"  bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+aProd[x][5]+'</Blink></font></td>'
      cMen += ' </tr>'
    Next 
    cMen += ' </table>'
    cMen += " </body>"
    cMen += " </html>" 
  
    CONNECT SMTP SERVER "mail.nippon-seikibr.com.br" ACCOUNT "workflow@nippon-seikibr.com.br" PASSWORD "wfl" RESULT cResult
    If cResult
       SEND MAIL FROM "WORKFLOW"   ;
       TO "jmoreira@nippon-seikibr.com.br";  //,"rmogi@nippon-seikibr.com.br";   
       SUBJECT  "Itens não baixados" ;
       BODY "Os itens abaixo ainda possuem saldo no armazem 98, favor tomar as devidas providencias" + cMen
      // ATTACHMENT cArq := cMen

    Else 
      GET MAIL ERROR cError
      ConOut("Error -> "+cError)
    EndIf  
      DISCONNECT SMTP SERVER
  EndIf
      ConOut("Finalizou")
Return