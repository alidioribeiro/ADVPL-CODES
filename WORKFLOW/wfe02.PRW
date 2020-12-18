#include "rwmake.ch"
#INCLUDE "Protheus.ch"   
#include "ap5mail.ch"     
#Include "TOPCONN.CH"
#Include "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WFE02     ºAutor  ³Jefferson Moreira   º Data ³  24/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Envia e-mail´s para cada responsavel de CC respectivamente  º±±
±±º          ³a relação de itens que acabaram de ser movimentados         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß  
Alterado em 21/09/2016 por Robson Lee / Adson
*/

**********************
User Function WFE02(_Chave)
**********************
//Local aProd := {}
cMen := ""     
//Default _Chave := xOP+xNumSeq
  
dbSelectArea("SBC")
dbSetOrder(1)
dbSeek(_Chave) 

While !Eof() .and. xOP == SBC->BC_OP
  cProd := Posicione("SB1",1,xFilial("SB1")+SBC->BC_PRODUTO,"B1_DESC")
  xObs  := Posicione("SZC",1,xFilial("SZC")+SBC->BC_MOTIVO ,"ZC_TIPODEF")
  xData := Subs(Dtos(BC_DTRM),7,2) + "/" + Subs(Dtos(BC_DTRM ),5,2)+ "/" + Subs(Dtos(BC_DTRM ),3,2)
  xQuant:= Transform(BC_QUANT,"@E 99999.999999")
 xObs_ := IIF(Empty(BC_OBS),xObs,BC_OBS)
 
  AAdd(aProd,{xOP  ,;    // [1]Nº da OP 
         BC_PRODUTO,;    // [2] Produto
            BC_TIPO,;    // [3] Tipo da movimentação 
           BC_APLIC,;    // [4] Centro de Custo
          BC_MOTIVO,;    // [5] Motivo da perda
             xQuant,;    // [6] Quantidade 
         BC_RECURSO,;    // [7] Recurso
         BC_LOTECTL,;    // [8] Lote
         BC_LOCORIG,;    // [9] Local de origem
           BC_LOCAL,;    // [10]Local de destino
              xObs_,;    // [11]Descrição do motivo
              cProd,;    // [12]Descrição do produto
          cUserName})    // [13]Usuario 
 	dbSkip()    
ENDDO


vRespCC:={}

vRespCC:= U_getVecResp("612") 
sendMsg("612")
                
vRespCC:= U_getVecResp("211") 
sendMsg("211")
        
vRespCC:= U_getVecResp("241") 
sendMsg("241")

vRespCC:= U_getVecResp("221") 
sendMsg("221")
        
vRespCC:= U_getVecResp("231") 
sendMsg("231")
        
vRespCC:= U_getVecResp("616") 
sendMsg("616") 

Return

//#########################################################
//########### FUNÇÕES DE FILTRO E ENVIO DE E-MAIL #########
//#########################################################

//****************************************
//* Função para filtro do Centro de Custo*
//****************************************

********************************
User Function getVecResp(CC) 
********************************

xFilter:= {}

For i:=1 to Len(aProd)   
 
    If CC # alltrim(aProd [i][4])       
       Loop
    Else
    If CC="223" .and. Substr(Alltrim(aProd[i][7]),1,4) <>"INJP"
    	Loop
    EndIf
       
        AAdd(xFilter,{aProd[i][1],;    // [1] Nº da OP
                      aProd[i][2],;    // [2] Produto
                      aProd[i][3],;    // [3] Tipo da movimentação 
                      aProd[i][4],;    // [4] Centro de Custo
                      aProd[i][5],;    // [5] Motivo da perda
                      aProd[i][6],;    // [6] Quantidade 
                      aProd[i][7],;    // [7] Recurso
                      aProd[i][8],;    // [8] Lote
                      aProd[i][9],;    // [9] Local de origem
                     aProd[i][10],;    // [10]Local de destino
                     aProd[i][11],;    // [11]Descrição do motivo
                     aProd[i][12],;    // [12]Descrição do produto
                     aProd[i][13]})    // [12]Usuario
 
    Endif 
Next
Return xFilter

//*********************************
//* Função para envio de messagens*
//*********************************

***************************    
Static Function sendMsg()
***************************

  If Len(vRespCC) > 0 
  
    oProcess := TWFProcess():New( "000003", "" )
    oProcess :NewTask( "100003", "\WORKFLOW\EMAIL2.HTM" )
    oProcess :cSubject := "WFE02 - Movimentação"
    oHTML    := oProcess:oHTML
        
    cMen := " <html>"
    cMen := " <head>"
    cMen := " <title> Produtos  Movimentados </title>"
    cMen := " </head>"  
    cMen += " <body>"
    cMen += ' <table border="1" width="1200">'
    cMen += ' <td colspan=13 align="center" >Relação de Produtos Movimentados em ' + xData +' </td></tr>'
    cMen += ' <tr >'
    cMen += ' <td align="center" width="2%" ><font size="1" face="Times">Nº da OP        </td>'
    cMen += ' <td align="center" width="2%" ><font size="1" face="Times">Produto         </td>'
    cMen += ' <td align="center" width="10%"><font size="1" face="Times">Descrição       </td>'
    cMen += ' <td align="center" width="2%" ><font size="1" face="Times">Quantidade      </td>'
    cMen += ' <td align="center" width="2%" ><font size="1" face="Times">CC              </td>'
    cMen += ' <td align="center" width="2%" ><font size="1" face="Times">Recurso         </td>'
    cMen += ' <td align="center" width="2%" ><font size="1" face="Times">Tp do Movi.     </td>'
    cMen += ' <td align="center" width="2%" ><font size="1" face="Times">Motivo          </td>'
    cMen += ' <td align="center" width="10%"><font size="1" face="Times">Observação      </td>'
    cMen += ' <td align="center" width="2%" ><font size="1" face="Times">Lote            </td>'
    cMen += ' <td align="center" width="2%" ><font size="1" face="Times">Local de Origem </td>'
    cMen += ' <td align="center" width="2%" ><font size="1" face="Times">Local de Destino</td>'
    cMen += ' <td align="center" width="2%" ><font size="1" face="Times">Usuario         </td>'
    cMen += ' </tr>'
       For x:= 1 to Len(vRespCC)
       cMen += ' <tr>'
       cMen += ' <td align="center" width="2%" ><font size="1" face="Times">'+ vRespCC[x][1] +'</td>'
       cMen += ' <td align="center" width="2%" ><font size="1" face="Times">'+ vRespCC[x][2] +'</td>'
       cMen += ' <td align="left  " width="10%"><font size="1" face="Times">'+ vRespCC[x][12]+'</td>'
       cMen += ' <td align="center" width="2%" ><font size="1" face="Times">'+ vRespCC[x][6] +'</td>'
       cMen += ' <td align="center" width="2%" ><font size="1" face="Times">'+ vRespCC[x][4] +'</td>'
       cMen += ' <td align="center" width="2%" ><font size="1" face="Times">'+ vRespCC[x][7] +'</td>'
       cMen += ' <td align="center" width="2%" ><font size="1" face="Times">'+ vRespCC[x][3] +'</td>'
       cMen += ' <td align="center" width="2%" ><font size="1" face="Times">'+ vRespCC[x][5] +'</td>'
       cMen += ' <td align="left  " width="10%"><font size="1" face="Times">'+ vRespCC[x][11]+'</td>'
       cMen += ' <td align="center" width="2%" ><font size="1" face="Times">'+ vRespCC[x][8] +'</td>'
       cMen += ' <td align="center" width="2%" ><font size="1" face="Times">'+ vRespCC[x][9] +'</td>'
       cMen += ' <td align="center" width="2%" ><font size="1" face="Times">'+ vRespCC[x][10]+'</td>'
       cMen += ' <td align="center" width="2%" ><font size="1" face="Times">'+ vRespCC[x][13]+'</td>'
       cMen += ' </tr>'
       
       Next
    cMen += ' </table>'
    cMen += " </body>"
    cMen += " </html>" 

    codRot:="WFE02"
    aDados:= u_MRecECC(CodRot)

    For i:=1 to Len(aDados)
      		If Alltrim(vRespCC[1][4]) = Alltrim(aDados[i][1])
      				oHtml:ValByName("MENS", cMen)
			    	oProcess:cTo  :=aDados[i][2]
				   cMailId := oProcess:Start()
			       ConOut("E-mail enviado com sucesso...")			  	  			
      		Endif
    Next

 EndIf

ConOut("Finalizou")

Return