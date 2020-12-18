#INCLUDE "rwmake.ch"   
#INCLUDE "Protheus.ch"   
#include "ap5mail.ch"     
#Include "TOPCONN.CH"
#Include "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WFE30     ºAutor  ³Jefferson Moreira   º Data ³  01/04/08   º±±
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
  User Function WFE30
********************************  
  Local aEnvia := {}
  Local cProd,cMen 
  
  Prepare Environment Empresa "01" Filial "01" Tables "SB6"  // Usado apenas quando o uso for por agendamento                                                         JJ
  
  DbSelectArea("SB6")
  DbSetOrder(1)
  DbGotop()
  
  MotaQry()
  
  While TMP->(!EOF())//
          
           AAdd(aEnvia,{TMP->B6_EMISSAO,TMP->VENCIMENTO,TMP->B6_CLIFOR,TMP->B6_LOJA, TMP->B6_PRODUTO, TMP->B6_LOCAL, TMP->B6_DOC, TMP->B6_SERIE, TMP->B6_TES, TMP->F4_TEXTO, TMP->B6_QUANT, TMP->B6_TIPO, TMP->B6_SALDO})
        
        TMP->(dbSkip())
  End
  TMP->(dbCloseArea()) 
  If Len(aEnvia) > 0
  
     oProcess := TWFProcess():New( "000001", "WFE30 - Validade Terceiros" ) //000019
     oProcess :NewTask( "100001", "\WORKFLOW\TERCEIROS.HTM" )
     oProcess :cSubject := "WFE30 - Validade Terceiros"
     oHTML    := oProcess:oHTML 
    
     // qout("Entrou no Html")
    
     cMen := " <html>"
    
     cMen += " <body>"
     cMen += ' <table border="1" width="900">'
     cMen += ' <tr width="750" align="center" >'
  //   cMen += ' <TD ><IMG src="\\Nsbsrv01\CORREIO\Workflow\Imagens\LogoNSB.JPG"></TD>'
     cMen += ' <td colspan=13 >Validade Terceiros </td></tr>' 
     cMen += ' <tr >'
     cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="3" face="Times New Roman"><Blink>Emissao   </Blink></font></td>'
     cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="3" face="Times New Roman"><Blink>Vencimento  </Blink></font></td>'
     cMen += ' <td align="center" width="08%" bgcolor="#FFFFFF"><font size="3" face="Times New Roman"><Blink>Cli/For   </Blink></font></td>'
     cMen += ' <td align="center" width="12%" bgcolor="#FFFFFF"><font size="3" face="Times New Roman"><Blink>Loja </Blink></font></td>'
     cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="3" face="Times New Roman"><Blink>Produto   </Blink></font></td>'
     cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="3" face="Times New Roman"><Blink>Armazem  </Blink></font></td>'
     cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="3" face="Times New Roman"><Blink>Documento   </Blink></font></td>'
     cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="3" face="Times New Roman"><Blink>Serie </Blink></font></td>'
     cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="3" face="Times New Roman"><Blink>TES   </Blink></font></td>'
     cMen += ' <td align="center" width="40%" bgcolor="#FFFFFF"><font size="3" face="Times New Roman"><Blink>Finalidade  </Blink></font></td>'
     cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="3" face="Times New Roman"><Blink>Qtde   </Blink></font></td>'
     cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="3" face="Times New Roman"><Blink>Tipo </Blink></font></td>'
     cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="3" face="Times New Roman"><Blink>Saldo </Blink></font></td>'
     
     cMen += ' </tr>'
     For x:= 1 to Len(aEnvia) 
         cMen += ' <tr>'
         cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="3" face="Times New Roman"><Blink>'+dtoc(stod(aEnvia[x][1]))+'</Blink></font></td>'
         cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="3" face="Times New Roman"><Blink>'+str(aEnvia[x][2])+'</Blink></font></td>'
         cMen += ' <td align="center" width="08%" bgcolor="#FFFFFF"><font size="3" face="Times New Roman"><Blink>'+aEnvia[x][3]+'</Blink></font></td>'
         cMen += ' <td align="center" width="12%" bgcolor="#FFFFFF"><font size="3" face="Times New Roman"><Blink>'+aEnvia[x][4]+'</Blink></font></td>'
         cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="3" face="Times New Roman"><Blink>'+aEnvia[x][5]+'</Blink></font></td>'
         cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="3" face="Times New Roman"><Blink>'+aEnvia[x][6]+'</Blink></font></td>'
         cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="3" face="Times New Roman"><Blink>'+aEnvia[x][7]+'</Blink></font></td>'
         cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="3" face="Times New Roman"><Blink>'+aEnvia[x][8]+'</Blink></font></td>'
         cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="3" face="Times New Roman"><Blink>'+aEnvia[x][9]+'</Blink></font></td>'
         cMen += ' <td align="center" width="40%" bgcolor="#FFFFFF"><font size="3" face="Times New Roman"><Blink>'+aEnvia[x][10]+'</Blink></font></td>'
         cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="3" face="Times New Roman"><Blink>'+str(aEnvia[x][11])+'</Blink></font></td>'
         cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="3" face="Times New Roman"><Blink>'+aEnvia[x][12]+'</Blink></font></td>'
         cMen += ' <td align="center" width="10%" bgcolor="#FFFFFF"><font size="3" face="Times New Roman"><Blink>'+str(aEnvia[x][13])+'</Blink></font></td>'
         
         cMen += ' </tr>'
     Next 
     cMen += ' </table>'
     cMen += " </body>"
     cMen += " </html>" 
    
     oHtml:ValByName( "MENS", cMen)
  //   oProcess:ClientName( Subs(cUsuario,7,15) )
	CodRot:="WFE30"
	Mto:= u_MontaRec(CodRot)
 	oProcess:cTo  :=Mto
      //   oProcess:ATTACHFILE(cArq) - ANEXA UM ARQUIVO <CAMINHO + NOME DO ARQUIVO>
     cMailId := oProcess:Start()
  // qout("E-mail enviado com sucesso!!!")
  EndIf
 
Return

Static Function MotaQry()
Local cQry := ""

cQry += " SELECT B6_EMISSAO, DATEDIFF(D, B6_EMISSAO, CURRENT_TIMESTAMP ) AS VENCIMENTO,"
cQry += " B6_CLIFOR, B6_LOJA, B6_PRODUTO, B6_LOCAL, B6_DOC, B6_SERIE, B6_TES, F4_TEXTO, B6_QUANT, B6_TIPO, B6_SALDO"
cQry += " FROM "+RetSQLName("SB6")+" B6 "
cQry += " INNER JOIN "+RetSQLName("SF4")+" SF4 ON "
cQry += " SF4.D_E_L_E_T_ = '' AND SF4.F4_CODIGO = B6.B6_TES"
cQry += " WHERE B6.D_E_L_E_T_ = ' '"
cQry += " AND B6_SALDO <> '0'"
cQry += " AND B6_EMISSAO >= '20190101'"
//cQry += " AND DATEDIFF(D, B6_EMISSAO, CURRENT_TIMESTAMP) IN (50, 70)"
cQry += " AND B6_TES NOT IN ('196','199','537')"
cQry += " AND DATEDIFF(D, B6_EMISSAO, CURRENT_TIMESTAMP) >= '40'"



TCQUERY cQry NEW ALIAS "TMP"
dbSelectArea("TMP")  

Return
