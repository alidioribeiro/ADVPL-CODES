#INCLUDE "rwmake.ch"   
#INCLUDE "Protheus.ch"   
#include "ap5mail.ch"     
#Include "TOPCONN.CH"
#Include "TBICONN.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WFE03     ºAutor  ³Jefferson Moreira   º Data ³  20/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relação de OP´s Abertas com mais de 48h                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/***************************************************************************/
User Function WFE03
***********************

  aProd := {}                                   
  cMen  := ""
  codRot:="WFE24"
  Tit :="OP'S AUTOMATICA PRECISAM SER FIRMADAS PARA IMPRESSAO "
  Prepare Environment Empresa "01" Filial "01" Tables "SB1","SC2" //TESTE
  
  DbSelectArea("SC2")
  DbSetOrder(1)
  DbGotop()
  While !SC2->(Eof())
    If Empty(C2_DATRF) .And.(C2_TPOP='P' .and. C2_CC='221' .and. C2_RECURSO='RT-IMP')
       xOP    := C2_NUM + C2_ITEM + C2_SEQUEN
       cCod   := C2_PRODUTO
       cProd  := Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_DESC")
       xData  := Subs(Dtos(C2_DATPRI),7,2) + "/" + Subs(Dtos(C2_DATPRI),5,2)+ "/" + Subs(Dtos(C2_DATPRI),3,2)
       xQuant := Transform(C2_QUANT,"@E 999,999")
       yQuant := Transform(C2_QUJE, "@E 999,999")
       jQuant := Transform(C2_QUANT-C2_QUJE, "@E 999,999")
       xCC    := C2_CC
    
       AAdd(aProd,{xData,xOp,cCod,cProd,xQuant,yQuant,jQuant,xCC})

    EndIf
    SC2->(DbSkip())
  Enddo
  

vRespCC := {}
      
vRespCC := getVecResp("221") 
sendMsg(Tit,codRot)


ConOut("Finalizou")  
Return  


/**************************************************************************/
***********************
User Function WFE03
***********************
  codRot:="WFE03"
  aProd := {}
  cMen  := ""
  Prepare Environment Empresa "01" Filial "01" Tables "SB1","SC2" //TESTE
  
  DbSelectArea("SC2")
  DbSetOrder(1)
  DbGotop()
  While !SC2->(Eof())
    If Empty(C2_DATRF) .And. C2_DATPRI < (dDataBase - 1)
       xOP    := C2_NUM + C2_ITEM + C2_SEQUEN
       cCod   := C2_PRODUTO
       cProd  := Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_DESC")
       xData  := Subs(Dtos(C2_DATPRI),7,2) + "/" + Subs(Dtos(C2_DATPRI),5,2)+ "/" + Subs(Dtos(C2_DATPRI),3,2)
       xQuant := Transform(C2_QUANT,"@E 999,999")
       yQuant := Transform(C2_QUJE, "@E 999,999")
       jQuant := Transform(C2_QUANT-C2_QUJE, "@E 999,999")
       xCC    := C2_CC
    
       AAdd(aProd,{xData,xOp,cCod,cProd,xQuant,yQuant,jQuant,xCC})

    EndIf
    SC2->(DbSkip())
  Enddo
Tit:="OP´s ABERTAS"   

vRespCC := {}
vRespCC := getVecResp("211") 
sendMsg(Tit,codRot)
        
vRespCC := getVecResp("221") 
sendMsg(Tit,codRot)
        
vRespCC := getVecResp("231") 
sendMsg(Tit,codRot)

vRespCC := getVecResp("241") 
sendMsg(Tit,codRot)

ConOut("Finalizou")  
Return  

//****************************************
//* Função para filtro do Centro de Custo*
//****************************************

Static Function getVecResp(CC)

xFilter := {}

For i:=1 to Len(aProd)   
 
    If CC # alltrim(aProd [i][8])       
       Loop
    Else
        AAdd(xFilter,{aProd[i][1],;    // [1] Data 
                      aProd[i][2],;    // [2] xOP
                      aProd[i][3],;    // [3] Codigo do Produto 
                      aProd[i][4],;    // [4] Descrição do Produto
                      aProd[i][5],;    // [5] Quantidade
                      aProd[i][6],;    // [6] Quantidade Entregue 
                      aProd[i][7],;    // [7] Saldo
                      aProd[i][8]})    // [8] CC
     
    Endif 
Next
Return xFilter

//*********************************
//* Função para envio de messagens*
//*********************************
   
Static Function sendMsg(Tit,CodRot)
  
  If Len(vRespCC) > 0 
  
    oProcess := TWFProcess():New( "000002", Tit )
    If Alltrim(CodRot)="WFE03"
	    oProcess :NewTask( "100002", "\WORKFLOW\OP.HTM" )
	Else
	    oProcess :NewTask( "100002", "\WORKFLOW\OP-A.HTM" )
	EndIF 
	    
//    oProcess :cSubject := "WFE03 - OPS ABERTAS"
   oProcess :cSubject :=CodRot+" "+Tit
	oHTML    := oProcess:oHTML 
    
    
    cMen := " <html>"
    cMen := " <head>"
    cMen := " <title>"+Tit +"</title>"
    cMen := " </head>"    
    cMen += " <body>"
    cMen += ' <table border="1" width="800">'
    cMen += ' <tr width="800" align="center" >'
    cMen += ' <td colspan=8 > Relação de OPs abertas </td></tr>' 
    cMen += ' <tr >'
    cMen += ' <td align="center" width="5%" ><font size="1" face="Times">Data             </td>'
    cMen += ' <td align="center" width="6%" ><font size="1" face="Times">OP               </td>'
    cMen += ' <td align="center" width="8%" ><font size="1" face="Times">Produto          </td>'
    cMen += ' <td align="center" width="30%"><font size="1" face="Times">Descrição        </td>'
    cMen += ' <td align="center" width="5%" ><font size="1" face="Times">Quantidade       </td>'
    cMen += ' <td align="center" width="5%" ><font size="1" face="Times">Quant.Entr.      </td>'
    cMen += ' <td align="center" width="5%" ><font size="1" face="Times">Saldo            </td>'
    cMen += ' <td align="center" width="3%" ><font size="1" face="Times">CC               </td>'
    cMen += ' </tr>'
    For x:= 1 to Len(vRespCC) 
       cMen += ' <tr>'
       cMen += ' <td align="center" width="5%"><font size="1" face="Times">' + vRespCC[x][1] +'</td>'
       cMen += ' <td align="center" width="6%"><font size="1" face="Times">' + vRespCC[x][2] +'</td>'
       cMen += ' <td align="center" width="8%"><font size="1" face="Times">' + vRespCC[x][3] +'</td>'
       cMen += ' <td align="left  " width="30%"><font size="1" face="Times">'+ vRespCC[x][4] +'</td>'
       cMen += ' <td align="center" width="5%" ><font size="1" face="Times">'+ vRespCC[x][5] +'</td>'
       cMen += ' <td align="center" width="5%" ><font size="1" face="Times">'+ vRespCC[x][6] +'</td>'
       cMen += ' <td align="center" width="5%" ><font size="1" face="Times">'+ vRespCC[x][7] +'</td>'
       cMen += ' <td align="center" width="3%" ><font size="1" face="Times">'+ vRespCC[x][8] +'</td>'
       cMen += ' </tr>'     
    Next 
    cMen += ' </table>'
    cMen += " </body>"
    cMen += " </html>"

    aDados:= u_MRecECC(CodRot)
                                             '
    For i:=1 to Len(aDados)
      	If Alltrim(vRespCC[1][8]) = Alltrim(aDados[i][1])
      	   oHtml:ValByName("MENS", cMen)
		   oProcess:cTo := aDados[i][2]
//			oProcess:cTo :="aishii@nippon-seikibr.com.br"
		   cMailId := oProcess:Start()
		   ConOut("E-mail enviado com sucesso...")			  	  			
      	Endif
    Next
/*Alterado pela Aglair 
    
    IF Alltrim(vRespCC[1][8]) == "211" 
       oHtml:ValByName("MENS", cMen)
       oProcess:cTo  := "ranierison@nippon-seikibr.com.br;allan@nippon-seikibr.com.br"
       oProcess:cCC  := "edyikeoka@nippon-seikibr.com.br;ruthf@nippon-seikibr.com.br"
       cMailId := oProcess:Start()
       ConOut("E-mail enviado com sucesso...")
    
    ElseIF Alltrim(vRespCC[1][8]) == "221"
       oHtml:ValByName("MENS", cMen)
       oProcess:cTo  := "msantos@nippon-seikibr.com.br;aurelio@nippon-seikibr.com.br"
       oProcess:cCC  := "edyikeoka@nippon-seikibr.com.br;ruthf@nippon-seikibr.com.br"
       cMailId := oProcess:Start()
       ConOut("E-mail enviado com sucesso...")
   
    ElseIF Alltrim(vRespCC[1][8]) == "231" 
       oHtml:ValByName("MENS", cMen)
       oProcess:cTo  := "wpacheco@nippon-seikibr.com.br;marco@nippon-seikibr.com.br"
       oProcess:cCC  := "edyikeoka@nippon-seikibr.com.br;ruthf@nippon-seikibr.com.br"
       cMailId := oProcess:Start()        
      ConOut("E-mail enviado com sucesso...")
 
    ElseIF Alltrim(vRespCC[1][8]) == "241" 
       oHtml:ValByName("MENS", cMen)
       oProcess:cTo  := "marcelo@nippon-seikibr.com.br;juliana@nippon-seikibr.com.br"
       oProcess:cCC  := "edyikeoka@nippon-seikibr.com.br;ruthf@nippon-seikibr.com.br"
       cMailId := oProcess:Start()        
      ConOut("E-mail enviado com sucesso...")
 
    EndIf
*/
  EndIf   
  
Return  

/************************************************************************************************************/
/*Monta os recebedores de e-mail do WorkFlow por Centro de Custo	                                  */
/************************************************************************************************************/

User Function MRecECC(CodRot)

Local RecEmail                 

aDados := {}

RecEmail := ""
CodRot := Alltrim(CodRot)+Replicate(" ",8-Len(CodRot))

DbSelectArea ("ZWF")
DbSetOrder(1)
Chave:="  "+CodRot
If DbSeek(Chave)  
		While Chave == ZWF->ZWF_FILIAL + ZWF->ZWF_ROT                                                                                                        
			  cCusto := ZWF->ZWF_CC  
			  RecEmail := ""
			  While Chave+CCusto==ZWF->ZWF_FILIAL + ZWF->ZWF_ROT+ ZWF->ZWF_CC
					RecEmail+=";"+Alltrim(ZWF->ZWF_EMAIL )
					DbSelectArea("ZWF")
					DbSkip()					
              EndDo
  			  Aadd(aDados,{cCusto,RecEmail} )				
		EndDo              
        //	RecEmail := SubStr(RecEmail,2,Len(RecEmail)-1)
Endif
Return aDados
/**********************************************************************************************************************************************/

