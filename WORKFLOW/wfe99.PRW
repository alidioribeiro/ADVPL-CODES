#INCLUDE "rwmake.ch"   
#INCLUDE "Protheus.ch"   
#include "ap5mail.ch"     
#Include "TOPCONN.CH"
#Include "TBICONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �WFE01     �Autor  �Jefferson Moreira   � Data �  21/06/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � ENVIA PARA OS RESPONSAVEIS A RELA��O DE ITENS EM INSPE��O  ���
���          � COM DE 24Hr DE SALDO NO ARMAZEM 98                         ���
�������������������������������������������������������������������������͹��
���Uso       � AP8  - Esse grava o e-mail enviado                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

********************************
  User Function WFE99
********************************  
  Local aProd := {}
  Local cProd,cMen 
  
  Prepare Environment Empresa "01" Filial "01" Tables "SC7"  // Usado apenas quando o uso for por agendamento
  qout("Entrou wfe99")
  DbSelectArea("SC7")
  DbSetOrder(1)
  DbGotop()
  While !Eof()
   //qout("Entrou no while")
    if EMPTY(C7_ENCER).AND. EMPTY(C7_RESIDUO) .AND. C7_DATPRF-dDataBase < 0 
        //.AND. SC7->C7_GRUPO = "MPI" 
  
      xDataPrev := Subs(Dtos(C7_DATPRF),7,2) + "/" + Subs(Dtos(C7_DATPRF),5,2)+ "/" + Subs(Dtos(C7_DATPRF),3,2)
      xDataReal := Subs(Dtos(C7_DTCHEGA),7,2) + "/" + Subs(Dtos(C7_DTCHEGA),5,2)+ "/" + Subs(Dtos(C7_DTCHEGA),3,2)
      xQuant:= Transform (SC7->C7_QUANT,"@e 999,999")
      xQuantEnt:= Transform (SC7->C7_QUJE,"@e 999,999")
      xDtDif:= Transform(C7_DTCHEGA-C7_DATPRF, "@e 999,999")
       qout("ACUMULANDO NO VETOR")     
      AAdd(aProd,{C7_NUM,C7_PRODUTO,C7_DESCRI,xDataPrev,xDataReal,xDtDif,xQuant,xQuantEnt,C7_UM})
    endif
    DbSkip()
  End
   
  If Len(aProd) > 0
  
    oProcess := TWFProcess():New( "000099", "Itens n�o Baixados" )
    oProcess :NewTask( "100099", "\WORKFLOW\EMAIL_mw.HTM" )
    oProcess :cSubject := "Itens n�o Baixados"
    oHTML    := oProcess:oHTML 
    
    qout("Entrou no Html")
    
    cMen := " <html>"
    cMen := " <head>"
    cMen := " <title> Rela��o de Pedidos de Compra am Aberto  </title>"
    cMen := " </head>"    
    cMen += " <body>"
    cMen += ' <table border="1" width="750">'
    cMen += ' <tr width="600" align="center" >'
 //   cMen += ' <TD ><IMG src="\\Nsbsrv01\CORREIO\Workflow\Imagens\LogoNSB.JPG"></TD>'
    cMen += ' <td colspan=9 > Rela��o de Pedidos de Compras em Aberto</td></tr>' 
    cMen += ' <tr >'
    cMen += ' <td align="center" width="5%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Pedido      </Blink></font></td>'
    cMen += ' <td align="center" width="5%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Cod Prod    </Blink></font></td>'
    cMen += ' <td align="center" width="50%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Produto     </Blink></font></td>'
    cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>DT Prev     </Blink></font></td>'
    cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>DT Real     </Blink></font></td>'
    cMen += ' <td align="center" width="8%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>DT Dif      </Blink></font></td>'
    cMen += ' <td align="center" width="8%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Quant       </Blink></font></td>'
    cMen += ' <td align="center" width="5%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Quant Ent   </Blink></font></td>'
        cMen += ' <td align="center" width="1%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Unidade </Blink></font></td>'    
    cMen += ' </tr>'
    For x:= 1 to Len(aProd) 
      cMen += ' <tr>'
      cMen += ' <td align="center" width="5%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+aProd[x][1]+'</Blink></font></td>'
      cMen += ' <td align="center" width="5%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+aProd[x][2]+'</Blink></font></td>'
      cMen += ' <td align="center" width="50%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+aProd[x][3]+'</Blink></font></td>'
      cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+aProd[x][4]+'</Blink></font></td>'
      cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+aProd[x][5]+'</Blink></font></td>'
      cMen += ' <td align="center" width="8%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+aProd[x][6]+'</Blink></font></td>'
      cMen += ' <td align="center" width="8%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+aProd[x][7]+'</Blink></font></td>'
      cMen += ' <td align="center" width="5%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+aProd[x][8]+'</Blink></font></td>'
      cMen += ' <td align="center" width="1%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+aProd[x][9]+'</Blink></font></td>'
      cMen += ' </tr>'
    Next 
    cMen += ' </table>'
    cMen += " </body>"
    cMen += " </html>" 
    
    oHtml:ValByName( "MENS", cMen)
   // oProcess:ClientName( Subs(cUsuario,7,15) )
    oProcess:cTo  := "marcus@nippon-seikibr.com.br"
 //   oProcess:cCC  := "paulo@nippon-seikibr.com.br" // Com Copia
 //   oProcess:cTo := "jmoreira@nippon-seikibr.com.br" // Com Copia Oculta
    //oProcess:ATTACHFILE(cArq) - ANEXA UM ARQUIVO <CAMINHO + NOME DO ARQUIVO>
    cMailId := oProcess:Start()

  EndIf
 
Return