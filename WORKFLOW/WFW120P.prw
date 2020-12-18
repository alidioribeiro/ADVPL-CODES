#include "rwmake.ch"  
#Include "TOPCONN.CH"


/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ponto de entrada excutado apos a confirmação do pedido³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ENDDOC*/
User Function WFW120P
Local Chave:="",cForn:="",cLoja:=""
Local LPedido:=""
Local VrPed:=0
Local Lista:={}

   Chave:=SC7->C7_FILIAL+SC7->C7_FORNECE+SC7->C7_LOJA+SC7->C7_NUM
   Chave1:=SC7->C7_FILIAL+SC7->C7_FORNECE+SC7->C7_LOJA
   DbSelectArea("SC7")                       
   DbSetOrder(3)                             
   DbSeek(Chave)
   Chave:=C7_FILIAL+C7_FORNECE+C7_LOJA+C7_NUM
   cForn:=C7_FORNECE
   cLoja:=C7_LOJA
   cNum:=C7_NUM
   NFor:=cForn+"/"+cLoja+"-"+Posicione("SA2",1,xFilial("SA2")+cForn+cLoja,"A2_NOME")
   AnoMes:=Alltrim(Str(Year(C7_EMISSAO))+Strzero(Month(C7_EMISSAO),2))
   While !Eof() .and. Chave==C7_FILIAL+C7_FORNECE+C7_LOJA+C7_NUM
	    If Empty(C7_USERINC)
		   	RecLock("SC7",.F.)
   			SC7->C7_USERINC=CUSERNAME //Alteração efetuada para cadastrar o usuário que incluiu o pedido
   			MsunLock()
   		EndIF	
		VrPed+=SC7->C7_TOTAL 
		DbSkip()
   End 
   //Verifica os pedidos que possuem o valor total igual ao pedido incluído para o fornecedor
   LPedido:=""
   VrPC:=0
   DbSelectArea("SC7")                       
   DbSetOrder(3)
   DbSeek(Chave1)		
   While !Eof() .and. Chave1==C7_FILIAL+C7_FORNECE+C7_LOJA
        if AnoMes==Alltrim(Str(Year(C7_EMISSAO))+Strzero(Month(C7_EMISSAO),2))
	   		if cNum==C7_NUM
	   			VrPC+=SC7->C7_TOTAL 
	   	    Else 
	   			if VrPc=VrPed
                    aaDD(Lista,{NFor,C7_CC,C7_NUM,Dtoc(C7_EMISSAO),Transform(VrPc,"@ 99.999.999.99" )})
	   			EndIf  
			    CNum:=C7_NUM
				VrPC:=SC7->C7_TOTAL 
	   		EndIf
	   	EndIf	
	   	DbSelectArea("SC7")
   		DbSkip() 
 		
   End
   if Len(Lista)>1 //Se for menor só há o pedido atual 
		GeraWorkFlow(Lista,AnoMes)
   End	
 
 Return 
                 
////////         
Static Function GeraWorkflow(Lista,AnoMes)
Local NFor:=""
Local CodRot:="WFE23"                    
    Periodo:=Substr(AnoMes,5,2)+'/'+Substr(AnoMes,1,4)
	oProcess := TWFProcess():New( "000098", "WFE23-Pedidos de compra com valores iguais do mesmo fornecedor." )
	oProcess :NewTask( "100098", "\WORKFLOW\PedI.htm" )
	oProcess :cSubject := "WFE23-Pedidos de compra com valores iguais do mesmo fornecedor"
	oHTML    := oProcess:oHTML 
	    
	    
	cMen := " <html>"
	cMen += " <head>"
    cMen += " <title></title>"
    cMen += " </head>"    
    cMen += " <body>"
    cMen := ' <table border="1" width="1250">'
    cMen += ' <tr width="1250" align="center" >  '                                     
 //   cMen += ' <TD ><IMG src="\\Nsbsrv01\CORREIO\Workflow\Imagens\LogoNSB.JPG"></TD>'
    cMen += ' <td colspan=5 >Pedidos com o mesmo fornecedor com valores iguais no periodo</td></tr>' 
    cMen += ' <tr >'
    cMen += ' <td align="center" width="35%"bgcolor="#FFFFFF"><font size="1" face="Times">FORNECEDOR</font></td>'       //[2]
    cMen += ' <td align="center" width="5%"bgcolor="#FFFFFF"><font size="1" face="Times">C.CUSTO</font></td>'        //[1]
    cMen += ' <td align="center" width="6%"bgcolor="#FFFFFF"><font size="1" face="Times">PEDIDO </font></td>'       //[2]
    cMen += ' <td align="center" width="10%"bgcolor="#FFFFFF"><font size="1" face="Times">DATA EMISSAO</font></td>'            //[3]
    cMen += ' <td align="center" width="10%"bgcolor="#FFFFFF"><font size="1" face="Times">VALOR</font></td>'    //[4]
	cMen += ' </tr>'
    For x:= 1 to Len(Lista) 
      cMen += ' <tr>'
      cMen += ' <td align="center" width="35%"bgcolor="#FFFFFF"><font size="1" face="Times">'+Lista[x][1]+'</font></td>'  //[1]
      cMen += ' <td align="center" width="5%"bgcolor="#FFFFFF"><font size="1" face="Times">'+Lista[x][2]+'</font></td>'  //[2]
	  cMen += ' <td align="center" width="6%"bgcolor="#FFFFFF"><font size="1" face="Times">'+Lista[x][3]+'</font></td>'  //[3]
	  cMen += ' <td align="center" width="10%"bgcolor="#FFFFFF"><font size="1" face="Times">'+Lista[x][4]+'</font></td>' //[4]
      cMen += ' <td align="center" width="10%"bgcolor="#FFFFFF"><font size="1" face="Times">'+Lista[x][5]+'</font></td>'  //[5]
      cMen += ' </tr>'
    Next 
    cMen += ' </table>'
    cMen += " </body>"
    cMen += " </html>"   
    oHtml:ValByName( "MENS", cMen)
  // oProcess:ClientName( Subs(aProd[1][8],7,15) )

//  _cTo := alltrim(UsrRetMail(aProd[1][9]))
  Mto:= u_MontaRec(CodRot)
  oProcess:cTo  := Mto
 //   oProcess:cTo := "jmoreira@nippon-seikibr.com.br" // Com Copia Oculta
    //oProcess:ATTACHFILE(cArq) - ANEXA UM ARQUIVO <CAMINHO + NOME DO ARQUIVO>
  cMailId := oProcess:Start()                    
    
Return 
/***************/
