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
  User Function WFE15
********************************  
  Local aProd := {}
  Local cProd,cMen 
  
  Prepare Environment Empresa "01" Filial "01" Tables "SZH"  // Usado apenas quando o uso for por agendamento
  
  DbSelectArea("SZH")
  DbSetOrder(1)
  DbGotop()
  While !SZH->(Eof())
    If SZH->ZH_STATUS == "2" //.OR. SZH->ZH_STATUS # "9"
      xDataAbert := Subs(Dtos(SZH->ZH_DTABERT),7,2) + "/" + Subs(Dtos(SZH->ZH_DTABERT),5,2)+ "/" + Subs(Dtos(SZH->ZH_DTABERT),3,2)
      xSolicit   := Subs(Upper(UsrFullName(SZH->ZH_SOLCHAM)),1,22)  
      xPriori    := iif(SZH->ZH_PRICHAM == 'A',"ALTA",IIF(SZH->ZH_PRICHAM == 'B',"BAIXA","NORMAL"))
      xProvador  := Subs(Upper(UsrFullName(SZH->ZH_APROVA)),1,15)
      xDataAprov := Subs(Dtos(SZH->ZH_DTAPROV),7,2) + "/" + Subs(Dtos(SZH->ZH_DTAPROV),5,2)+ "/" + Subs(Dtos(SZH->ZH_DTAPROV),3,2)
       xTipo := ''
      Do Case
         Case SZH->ZH_TIPO == '001 '
              xTipo := 'Hardware'
         Case SZH->ZH_TIPO == '002 '
              xTipo := 'Windows'
         Case SZH->ZH_TIPO == '003 ' 
              xTipo := 'Rede/Wi-fi'
         Case SZH->ZH_TIPO == '004 '
              xTipo := 'Microsiga'
         Case SZH->ZH_TIPO == '005 '
              xTipo := 'Internet'
         Case SZH->ZH_TIPO == '999 '
              xTipo := 'Outros' 
      EndCase
      
      Do Case
         Case SZH->ZH_STATUS == '0'
              xStatus := 'Aberto'
         Case SZH->ZH_STATUS == '1'
              xStatus := 'Andamento'
         Case SZH->ZH_STATUS == '2' 
              xStatus := 'Aprovado'
         Case SZH->ZH_STATUS == '8'
              xStatus := 'Cancelado'
         Case SZH->ZH_STATUS == '9'
              xStatus := 'Encerrados'
      EndCase                       

      AAdd(aProd,{SZH->ZH_NUMCHAM,;  // [01]
                       xDataAbert,;  // [02]
                         xSolicit,;  // [03]
                          xPriori,;  // [04]
                     SZH->ZH_DESC,;  // [05]
                            xTipo,;  // [06]
                        xProvador,;  // [07]
                       xDataAprov,;  // [08]
                          xStatus})  // [09] 
    EndIf
    SZH->(DbSkip())
  End
   
  If Len(aProd) > 0
  
    oProcess := TWFProcess():New( "000001", "Relação de SSIs" )
    oProcess :NewTask( "100001", "\WORKFLOW\SSITI.HTM" )
    oProcess :cSubject := "Relação de SSIs"
    oHTML    := oProcess:oHTML 
   
    cMen := ' <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" '
    cMen += ' "http://www.w3.org/TR/html4/loose.dtd"> '
    cMen += ' <html> '
    cMen += ' <head>  '
    cMen += ' <title>Untitled Document</title>   '
    cMen += ' <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"> '
    cMen += ' <style type="text/css"> '
    cMen += ' <!-- '
    cMen += ' .style5 {font-size: 12px}'
    cMen += ' .style6 {    '
    cMen += ' 	font-size: 10px;  '
    cMen += ' 	font-family: "Times New Roman", Times, serif;'
    cMen += ' 	color: #FF0000; '
    cMen += ' }   '
    cMen += ' .style13 {font-family: "Times New Roman", Times, serif}'
    cMen += ' .style14 {        '
    cMen += ' 	font-size: 36px;  '
    cMen += ' 	color: #0000FF;'
    cMen += ' }  '
    cMen += ' .style15 {color: #0000FF} '
    cMen += ' .style16 {font-family: "Times New Roman", Times, serif; color: #0000FF; }'
    cMen += ' .style18 {font-family: "Times New Roman", Times, serif; color: #FF0000; }'
    cMen += ' .style19 {color: #FF0000}'
    cMen += ' -->   '
    cMen += ' </style> '
    cMen += ' </head> '
    cMen += '   '
    cMen += ' <body>  '
    cMen += ' <p>&nbsp;</p> '
    cMen += ' <table width="1033" height="142" border="1" bordercolor="#0000CC" bgcolor="#FFFFFF">'
    cMen += '   <tr>     '
    cMen += '     <td colspan="2" rowspan="2"><div align="center" class="style13"></div>      <div align="center" class="style13"><img src="\\Nsbsrv05\CORREIOS\TI\LogoNSB.JPG" width="87" height="47"></div></td>'
    cMen += '     <td colspan="5" rowspan="2"><div align="center" class="style13"></div>'      
    cMen += '     <div align="center" class="style13 style14">Rela&ccedil;&atilde;o de Solicita&ccedil;&otilde;es de Servi&ccedil;os de Inform&aacute;tica</div>      <span class="style13"> </span>      <div align="center" class="style13"></div></td>'
    cMen += '     <td height="31" colspan="2"><div align="center" class="style16">Data - Hora </div></td> '
    cMen += '   </tr>'
    cMen += '   <tr> '
    cMen += '     <td height="23" colspan="2"><div align="center" class="style15">28/09/08 - 10:15 </div></td> '
    cMen += '   </tr>     '
    cMen += '   <tr> '
    //cMen += '     <td width="54" height="28"><div align="center" class="style5 style13 style15"> '
    //cMen += '         <div align="center">N&ordm; SSI </div>
    //cMen += '     </div></td> '
     cMen += '     <td width="54"><div align="center" class="style16"><span class="style5">N&ordm; SSI</span></div></td>'
     
    cMen += '     <td width="66"><div align="center" class="style16"><span class="style5">Dt. Abertura</span></div></td>'
    cMen += '     <td width="152"><div align="center" class="style16"><span class="style5">Solicitante</span></div></td> '
    cMen += '     <td width="59"><div align="center" class="style16"><span class="style5">Prioridade</span></div></td>'
    cMen += '     <td width="378"><div align="center" class="style16"><span class="style5">Descri&ccedil;&atilde;o</span></div></td>'
    cMen += '     <td width="71"><div align="center" class="style16"><span class="style5">Tipo</span></div></td> '
    cMen += '     <td width="75"><div align="center" class="style16"><span class="style5">Aprovador</span></div></td> '
    cMen += '     <td width="56"><div align="center" class="style16"><span class="style5">Dt. Aprova&ccedil;&atilde;o</span></div></td>'
    cMen += '     <td width="64"><div align="center" class="style16">Status</div></td>  '
    cMen += '   </tr> '
    
    For x:= 1 to Len(aProd)
    
    cMen += '   <tr> '
    cMen += '     <td height="32"><span class="style18">'+ aProd[x][1]+'</span></td> '
    cMen += '     <td><div align="center" class="style19">'+ aProd[x][2]+'</div></td> '
    cMen += '     <td><div align="center"><span class="style18">'+ SUBS(aProd[x][3],1,10)+' </span></div></td> '
    cMen += '     <td><div align="center" class="style18">'+ aProd[x][4]+'</div></td> '
    cMen += '     <td><span class="style6">'+ aProd[x][5]+'</span></td>   '
    cMen += '     <td><div align="center" class="style18">'+ aProd[x][6]+'</div></td> '
    cMen += '     <td><div align="center" class="style18">'+ SUBS(aProd[x][7],1,8)+' </div></td>  '
    cMen += '     <td><span class="style18">'+ aProd[x][8]+'</span></td>   '
    cMen += '     <td><span class="style18">'+ aProd[x][9]+'</span></td> '
    cMen += '   </tr> '
    
    Next
    
    cMen += ' </table>  '
    cMen += ' <p>&nbsp;</p> '
    cMen += ' </body> '
    cMen += ' </html> '
 
    
    
    oHtml:ValByName( "MENS", cMen)
   // oProcess:ClientName( Subs(cUsuario,7,15) )
   // oProcess:cTo  := "jmoreira@nippon-seikibr.com.br;leonel@nippon-seikibr.com.br"
 //   oProcess:cCC  := "paulo@nippon-seikibr.com.br" // Com Copia
    oProcess:cTo := "aishii@nippon-seikibr.com.br" // Com Copia Oculta
    //oProcess:ATTACHFILE(cArq) - ANEXA UM ARQUIVO <CAMINHO + NOME DO ARQUIVO>
    cMailId := oProcess:Start()

  EndIf
 
Return