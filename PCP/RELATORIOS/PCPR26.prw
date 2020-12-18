#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#Include "TOPCONN.CH"         
//#INCLUDE "OPERADOR.CH" 
//#INCLUDE "Protheus.ch"   // Problema com a janela inicial
#include "ap5mail.ch"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"


User Function PCPR26() 
            
Local cPathDot     :=     "PATCH DO FTP" 

_cFile := "ORC"+ZR_NUM+".DOC"

Private cWord     := OLE_CreateLink()                   

cnomeorc := cPathDot+"ORC"+ZR_NUM+".DOC"

OLE_SetProperty(cWord, oleWdVisible ,.F. )    

If (cWord >= "0")          
     OLE_CloseLink(cWord) //fecha o Link com o Word     
     cWord:= OLE_CreateLink()     
     
     OLE_OpenFile(cWord,cnomeorc) 

     //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿     
     //³Funcao que faz o Word aparecer na Area de Transferencia do Windows,     ³     
     //³sendo que para habilitar/desabilitar e so colocar .T. ou F.            ³     
     //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ     

     OLE_SetProperty(cWord, oleWdVisible ,.T. )
     OLE_SetProperty(cWord, oleWdPrintBack,.T. )
Endif          

RETURN()

/*Aglair
User Function PCPR26a()
aprod:=ARRAY(2)
//oSoma1:=Produto():New("HP0582002A0C003")
aprod[1]:=Produto():New("HP0582002A0C003")
aprod[2]:=Produto():New("HP0487002B0C00A")
//oSoma1:montaTela("Resultado das Somas") 
//aadd(aProp,{G1_COMP,G1_QUANT})

For p:=1 to len(aprod) 
    msgstop("Produto " + aprod[p]:cCodigo+" - "+aprod[p]:cDescricao) 
    aprod[p]:pertenceEstr()
    For i:=1 to len(aprod[p]:aEstrutura)
        msgstop("Estrutura "+aprod[p]:aEstrutura[i][1])
        msgstop(aprod[p]:aEstrutura[i][2])
    Next 
Next 

/*
For i:=1 to len(oSoma1:aEstrutura)
    msgstop("Estrutura "+oSoma1:aEstrutura[i][1])
    msgstop(oSoma1:aEstrutura[i][2])
Next
*/ 
    //msgstop(oSoma1:cTipo)
//Return 







