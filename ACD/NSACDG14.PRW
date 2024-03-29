#Include "RwMake.CH"
#include "tbiconn.ch"

User Function ESTENDER()
Local aCabSDA    := {}
Local aItSDB     := {}
Local _aItensSDB := {} 
Private	lMsErroAuto := .F. 

//Cabe�alho com a informa��o do item e NumSeq que sera endere�ado.
aCabSDA := {{"DA_PRODUTO" ,"B5330166190A10Z",Nil},;	  
            {"DA_NUMSEQ"  ,"99OWBK"         ,Nil}}

//Dados do item que ser� endere�ado
aItSDB := {{"DB_ITEM"	  ,"0001"	    ,Nil},;
           {"DB_ESTORNO"  ,"S"	        ,Nil},;                   
           {"DB_LOCALIZ"  ,"EXPEDICAO"  ,Nil},;                   
           {"DB_DATA"	  ,dDataBase    ,Nil},;                   
           {"DB_QUANT"    ,50           ,Nil}}       

aadd(_aItensSDB,aItSDB)

//Executa o estorno do item
//MATA265( aCabSDA, _aItensSDB, 4)

MsexecAuto({|x,y| mata265(x,y)}, aCabSDA, _aItensSDB, 4)  //3 Distribui

If lMsErroAuto    
   MostraErro()
Else    
   MsgAlert("Processamento Ok!")
Endif
Return