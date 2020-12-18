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
±±ºUso       ³ AP8  - Esse grava o e-mail enviado                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

********************************
  User Function WFE01
********************************  
  Local aProd := {}
  Local cProd,cMen 
  Local CodRot:="WFE01"
                                      
  
  Prepare Environment Empresa "01" Filial "01" Tables "SB1"  // Usado apenas quando o uso for por agendamento
  
  DbSelectArea("SD7")
  DbSetOrder(1)
  DbGotop()
  While !SD7->(Eof())
    If SD7->D7_LIBERA # "S" .AND. SD7->D7_TIPO == 0 .AND. (SD7->D7_DATA < dDataBase)
      cProd := Posicione("SB1",1,xFilial("SB1")+ SD7->D7_PRODUTO,"B1_DESC")
      xSaldo:= Transform (SD7->D7_SALDO,"@! 999,999")
      xData := Subs(Dtos(D7_DATA),7,2) + "/" + Subs(Dtos(D7_DATA),5,2)+ "/" + Subs(Dtos(D7_DATA),3,2)
      //xDoc  := IIF(Empty(D7_DOC),Space(6),D7_DOC)
      //xLote := D7_LOTECTL
      //xUser := D7_USUARIO
      AAdd(aProd,{D7_DOC,xData,D7_PRODUTO,cProd,xSaldo,D7_LOTECTL,D7_USUARIO})
    EndIf
    SD7->(DbSkip())
  End
   
  If Len(aProd) > 0
  
    oProcess := TWFProcess():New( "000001", "Itens não Baixados" )
    oProcess :NewTask( "100001", "\WORKFLOW\EMAIL.HTM" )
    oProcess :cSubject := "WFE01 - Itens não Baixados"
    oHTML    := oProcess:oHTML 
    
    //qout("Entrou no Html")
    
    cMen := " <html>"
    cMen := " <head>"
    cMen := " <title> Relação de Produtos com Saldo com mais de 24 Hrs </title>"
    cMen := " </head>"    
    cMen += " <body>"
    cMen += ' <table border="1" width="750">'
    cMen += ' <tr width="600" align="center" >'
 //   cMen += ' <TD ><IMG src="\\Nsbsrv01\CORREIO\Workflow\Imagens\LogoNSB.JPG"></TD>'
    cMen += ' <td colspan=7 >Relação de Produtos com mais de 24 Hrs no Armazem 98</td></tr>' 
    cMen += ' <tr >'
    cMen += ' <td align="center" width="02%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Documento </Blink></font></td>'
    cMen += ' <td align="center" width="06%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Data      </Blink></font></td>'
    cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Produto   </Blink></font></td>'
    cMen += ' <td align="center" width="30%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Descrição </Blink></font></td>'
    cMen += ' <td align="center" width="04%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Quant     </Blink></font></td>'
    cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Lote      </Blink></font></td>'
    cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Usuario   </Blink></font></td>'
    cMen += ' </tr>'
    For x:= 1 to Len(aProd) 
      cMen += ' <tr>'
      cMen += ' <td align="center" width="02%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+aProd[x][1]+'</Blink></font></td>'
      cMen += ' <td align="center" width="06%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+aProd[x][2]+'</Blink></font></td>'
      cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+aProd[x][3]+'</Blink></font></td>'
      cMen += ' <td align="center" width="30%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+aProd[x][4]+'</Blink></font></td>'
      cMen += ' <td align="center" width="04%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+aProd[x][5]+'</Blink></font></td>'
      cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+aProd[x][6]+'</Blink></font></td>'
      cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+aProd[x][7]+'</Blink></font></td>'
      cMen += ' </tr>'
    Next 
    cMen += ' </table>'
    cMen += " </body>"
    cMen += " </html>" 
    
    oHtml:ValByName( "MENS", cMen)
   // oProcess:ClientName( Subs(cUsuario,7,15) )
    Mto:= u_MontaRec(CodRot)
    oProcess:cTo  := Mto
 //   oProcess:cTo := "jmoreira@nippon-seikibr.com.br" // Com Copia Oculta
    //oProcess:ATTACHFILE(cArq) - ANEXA UM ARQUIVO <CAMINHO + NOME DO ARQUIVO>
    cMailId := oProcess:Start()

  EndIf
 
Return