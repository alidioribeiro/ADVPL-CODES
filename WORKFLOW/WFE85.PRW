#INCLUDE "rwmake.ch"   
#INCLUDE "Protheus.ch"   
#include "ap5mail.ch"     
#Include "TOPCONN.CH"
#Include "TBICONN.CH"

********************************
  User Function WFE85
********************************  
  Local cMen 
  Local CodRot:="WFE85"
  Local cUser := UsrRetName(RetCodUsr())
                                      
  
  Prepare Environment Empresa "01" Filial "01" Tables "SC7"
  
    oProcess := TWFProcess():New( "000001", "Pedidos Alterado" )
    oProcess :NewTask( "100001", "\WORKFLOW\wfe85.HTM" )
    oProcess :cSubject := "WFE85 - Pedidos Alterado: "+SC7->C7_NUM+""
    oHTML    := oProcess:oHTML 
    
    cMen := " <html>"
    cMen := " <head>"
    cMen := " <title> Pedido Alterado </title>"
    cMen := " </head>"    
    cMen += " <body>"
    cMen += " <h2>Pedido Numero: "+SC7->C7_NUM+" , Alterado por "+cUser+"<h2>"
    cMen += " </body>"
    cMen += " </html>" 
    
    oHtml:ValByName( "MENS", cMen)
    Mto:= u_MontaRec(CodRot)
    oProcess:cTo  := Mto
    cMailId := oProcess:Start()

 
Return
