#Include "TOPCONN.CH"
#Include "TBICONN.CH"            
#INCLUDE "rwmake.ch"
/*************************************************************************/
/* Rotina que corrige o recurso conforme o dado da OP ********************/  
/*************************************************************************/
/*************************************************************************/

User Function CorRecur() 
Local DataRef:=""

  
Prepare Environment Empresa "01" Filial "01" Tables "SD3,SZ6,SZ7"  // Usado apenas quando o uso for por agendamento
  

//DataRef:=Dtos(dDatabase)

/*Corrige a movimentação SD3*/
cQuery:=" UPDATE DADOSAP10..SD3010 "
cQuery+=" SET D3_RECURSO=C2_RECURSO "
cQuery+=" FROM "
cQuery+=" DADOSAP10..SD3010 AS A, "
cQuery+=" DADOSAP10..SC2010 AS B  "
cQuery+=" WHERE D3_RECURSO='' AND D3_TM='400'  "
cQuery+=" AND A.D_E_L_E_T_='' "
cQuery+=" AND B.C2_FILIAL=A.D3_FILIAL "
cQuery+=" AND B.D_E_L_E_T_='' "
cQuery+=" AND D3_OP=C2_NUM+C2_ITEM+C2_SEQUEN "

//cQuery+=" AND D3_EMISSAO='"+DataRef+"' AND D3_OP=C2_NUM+C2_ITEM+C2_SEQUEN "

TCSQLEXEC(Cquery)


cQuery:=" UPDATE DADOSAP10..SZ6010 "
cQuery+=" SET Z6_RECURSO=C2_RECURSO "
cQuery+=" FROM  "
cQuery+=" DADOSAP10..SZ6010 AS A, "
cQuery+=" DADOSAP10..SC2010 AS B "
cQuery+=" WHERE Z6_RECURSO='' "
cQuery+=" AND A.D_E_L_E_T_='' "
cQuery+=" AND B.D_E_L_E_T_='' "
cQuery+=" AND A.Z6_FILIAL=B.C2_FILIAL "
//cQuery+=" AND C2_EMISSAO='"+DataRef+"' AND Z6_OP=C2_NUM+C2_ITEM+C2_SEQUEN

TCSQLEXEC(Cquery)


cQuery:=" UPDATE DADOSAP10..SZ8010 "
cQuery+=" SET Z8_RECURSO=C2_RECURSO "
cQuery+=" FROM DADOSAP10..SZ8010 AS A, "
cQuery+=" DADOSAP10..SC2010 AS B "
cQuery+=" WHERE Z8_RECURSO='' "
cQuery+=" AND A.D_E_L_E_T_='' "
cQuery+=" AND B.D_E_L_E_T_='' "
cQuery+=" AND A.Z8_FILIAL=B.C2_FILIAL "
//cQuery+=" AND C2_EMISSAO like '"+DataRef+"' AND Z8_OP=C2_NUM+C2_ITEM+C2_SEQUEN
TCSQLEXEC(Cquery)


Return 




