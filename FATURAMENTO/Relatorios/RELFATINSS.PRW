#INCLUDE "rwmake.ch"    
#Include "TOPCONN.CH"



User Function RFatInss() 


#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 07/03/02 ==> 	#DEFINE PSAY SAY
#ENDIF
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ RelImHE  ³ Autor ³ JEFFERSON MOREIRA     ³ Data ³ 16/04/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Relatorio de Solicitacao de horas extras                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

titulo    := PADC("RELATORIO DE FATURAMENTO PARA INSS",74)
cDesc1    := PADC("Este programa tem como objetivo emitir o relatorio p/calculo do INSS ",74)
cDesc2    := ""
cDesc3    := ""
aORD      := {}//{"OP","PRODUTO","RECURSO"}
tamanho   := "G" // largura do relatorio --> P 80 pos - M 132 pos - G 220 pos
//limite    := 132
limite    := 220
cString   := "SD2"
lContinua := .T.
cUM       := ""
lEnd      := .F.
aReturn   := { "Zebrado", 1,"Contabilidade", 2, 2, 1, "",1 }
nomeprog  := "RelFat"
nLastKey  := 0
cPerg := "FATINSS"


m_pag     := 01     
Li:=0


/*TESTE DE INTEGRAÇÃO COM O PONTO*/
//U_INTPONHE()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

pergunte(cPerg,.F.)
//if mv_par06= 2
//	tamanho   := "P" // largura do relatorio --> P 80 pos - M 132 pos - G 220 pos
//	limite    := 220
//EndIF   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                                           ³
//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³   mv_par01  - Da Data ?                                                        ³
//³   mv_par02  - Ate a Data ?                                                     ³
//³   mv_par03  - Do Doc ?                                                         ³
//³   mv_par04  - Ate o Doc ?                                                      ³
//³   mv_par05  - Da Matricula ?                                                   ³
//³   mv_par06  - Ate a Matricula ?                                                ³
//³   mv_par07  - Do CCusto ?                                                      ³
//³   mv_par08  - Ate o CCusto ?                                                   ³
//³                                                                                |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel  := "RFatInss"

wnrel  := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd)

If nLastKey==27
	Return
Endif

SetDefault(aReturn,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem := aReturn[8]
cbtxt  := Space(10)
cbcont := 00

 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

 Tipo:=IIf(mv_par06=1,"Analítico","Sintético")
 titulo := " Demonstrativo do Faturamento  p/ Calculo INSS "+Tipo
 if mv_par06=1
	 cabec1 :="Emp|TP|Emissao|Nota     |Cliente|Apelido    |CFOP |Desc. CFOP                     | NCM     |REC |Produto          |Descricao                     |Quantidade|Preço Unit.|Total  "
     cabec2 :="                                                                                              |INSS|                                                                               "
 Else 	 
	 cabec1 :="Emp|TP|CFOP|Desc. CFOP                               |NCM     |Desc. NCM                               |Trib |Vr.Tot Fat "
 	 cabec2 :="                                                                                                       |Inss?|            " 
 EndIf 




If nLastKey == 27
   Return
Endif

nTipo  := IIF(aReturn[4]==1,15,18)

cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
Group:=""
If mv_par06=1 
	cQuery:=" select D2_TIPO AS TIPO,D2_FILIAL,D2_DOC,D2_EMISSAO,D2_SERIE,D2_CLIENTE,A1_NREDUZ,"
	cQuery+=" D2_CF,X5_DESCRI, B5_CODATIV,B5_INSPAT, "
	cQuery+=" D2_COD,E.B1_DESC,D2_PRCVEN,SUM(D2_QUANT) as D2_QUANT,SUM(D2_QUANT*D2_PRCVEN) AS D2_TOTAL "
	cQuery+=" from SD2010 AS A "
	cQuery+=" LEFT JOIN SB5010 B ON ( B.D_E_L_E_T_='' AND A.D2_COD=B.B5_COD AND A.D2_FILIAL=B.B5_FILIAL ) "
	cQuery+=" LEFT JOIN SYD010 C ON ( C.D_E_L_E_T_='' AND B.B5_CODATIV=C.YD_TEC )"
	cQuery+=" LEFT JOIN SX5010 D ON ( D.D_E_L_E_T_='' AND D.X5_TABELA='13'AND A.D2_CF=D.X5_CHAVE ) "
	cQuery+=" INNER JOIN SB1010 E ON ( E.D_E_L_E_T_='' AND A.D2_FILIAL=E.B1_FILIAL AND A.D2_COD=E.B1_COD) "
	cQuery+=" INNER JOIN SA1010 F ON ( F.D_E_L_E_T_='' AND A.D2_CLIENTE=F.A1_COD AND A.D2_LOJA=F.A1_LOJA) "
Else  
	cQuery:= " select D2_TIPO AS TIPO, D2_FILIAL,D2_CF,X5_DESCRI, B5_CODATIV,ISNULL(YD_DESC_P,'')AS DNCM,B5_INSPAT,sum(D2_QUANT*D2_PRCVEN) AS TOT "
	cQuery+= " from "
	cQuery+= " SD2010 A "
	cQuery+= " LEFT JOIN SB5010 B ON ( B.D_E_L_E_T_='' AND A.D2_COD=B.B5_COD AND A.D2_FILIAL=B.B5_FILIAL )
	cQuery+= " LEFT JOIN SYD010 C ON ( C.D_E_L_E_T_='' AND B.B5_CODATIV=C.YD_TEC )
	cQuery+= " LEFT JOIN SX5010 D ON ( D.D_E_L_E_T_='' AND D.X5_TABELA='13'AND A.D2_CF=D.X5_CHAVE )
EndIF 	

cQuery+=" WHERE  "
cQuery+=" A.D_E_L_E_T_='' AND "
cQuery+="  A.D2_EMISSAO>='"+Dtos(mv_par01)+"' AND "
cQuery+="  A.D2_EMISSAO<='"+Dtos(mv_par02)+"' AND "
cQuery+="  B.B5_CODATIV>='"+mv_par03+"' AND "
cQuery+="  B.B5_CODATIV<='"+mv_par04+"' AND "
//Relação de CFOPs de Faturamento Estadual
cQuery+="  ( "
cQuery+=" A.D2_CF IN('5101','5102','5103','5104','5105','5106','5109','5110','5111', "
cQuery+="'5112','5113','5114','5115','5116','5117','5118','5119','5120', "
cQuery+="'5122','5123','5124','5125','5251','5525','5253','5254','5255', "
cQuery+="'5256','5257','5301','5302','5303','5304','5305','5306','5307', "
cQuery+="'5351','5352','5353','5354','5305','5306','5307','5351','5352', "
cQuery+="'5353','5354','5355','5356','5357','5359','5401','5402','5403', "
cQuery+="'5405','5651','5652','5653','5654','5655','5656') "
 //--Relação de CFOPs de Faturamento InterEstadual
cQuery+=" or  "
cQuery+=" A.D2_CF IN('6101','6102','6103','6104','6105','6106','6107','6108','6109', "
cQuery+="'6110','6111','c6112','6113','6114','6115','6116','6117','6118', "
cQuery+="'6119','6120','6122','6123','6124','6125','6251','6252','6253', "
cQuery+="'6254','6255','6256','6257','6258','6301','6302','6303','6304', "
cQuery+="'6306','6307','6351','6352','6353','6354','6355','6356','6357', "
cQuery+="'6359',' 6401','6402','6403','6404','6501','6502','6651','6652', "
cQuery+="'6653','6654','6655','6656') "
//--Relação de CFOPs de Faturamento Exterior
cQuery+=" or "
cQuery+=" A.D2_CF IN('7101','7102','7105','7106','7127','7251','7301','7358','7501','7651','7664') "
cQuery+=" ) "
//Adicionando os dados da Devolução    
If mv_par06=1
	cQuery+=" GROUP BY D2_TIPO,D2_FILIAL,D2_DOC,D2_EMISSAO,D2_SERIE,D2_CLIENTE,A1_NREDUZ,"
	cQuery+=" D2_CF,X5_DESCRI, B5_CODATIV,B5_INSPAT, "
	cQuery+=" D2_COD,E.B1_DESC,D2_PRCVEN "
    cQuery+=" UNION "
    cQuery+=" SELECT D1_TIPO AS TIPO, D1_FILIAL as D2_FILIAL,D1_DOC AS D2_DOC , "
 	cQuery+=" D1_EMISSAO AS D2_EMISSAO,"
    cQuery+=" D1_SERIE AS D2_SERIE ,"
    cQuery+=" D1_FORNECE AS D2_CLIENTE, A1_NREDUZ, D1_CF AS D2_CF,X5_DESCRI, B5_CODATIV, B5_INSPAT,D1_COD AS D2_COD,E.B1_DESC,D1_VUNIT AS D2_PRCVEN,D1_QUANT, SUM(D1_QUANT*D1_VUNIT ) AS TOT "
    cQuery+= " from "
	cQuery+= " SD1010 A
	cQuery+= " LEFT JOIN SB5010 B ON ( B.D_E_L_E_T_='' AND A.D1_COD=B.B5_COD AND A.D1_FILIAL=B.B5_FILIAL )
	cQuery+= " LEFT JOIN SYD010 C ON ( C.D_E_L_E_T_='' AND B.B5_CODATIV=C.YD_TEC )
	cQuery+= " LEFT JOIN SX5010 D ON ( D.D_E_L_E_T_='' AND D.X5_TABELA='13'AND A.D1_CF=D.X5_CHAVE )
	cQuery+= " INNER JOIN SB1010 E ON ( D.D_E_L_E_T_='' AND A.D1_COD=E.B1_COD  )
	cQuery+=" INNER JOIN SA1010 F ON ( F.D_E_L_E_T_='' AND A.D1_FORNECE=F.A1_COD AND A.D1_LOJA=F.A1_LOJA) "
	cQuery+= " WHERE  "
	cQuery+= " A.D_E_L_E_T_='' AND "
	cQuery+= "  A.D1_NFORI<>''  AND  " 
	cQuery+="  A.D1_EMISSAO>='"+Dtos(mv_par01)+"' AND "
	cQuery+="  A.D1_EMISSAO<='"+Dtos(mv_par02)+"' AND "
	cQuery+="  B.B5_CODATIV>='"+mv_par03+"' AND "
	cQuery+="  B.B5_CODATIV<='"+mv_par04+"' AND "
    cQuery+="  SUBSTRING(A.D1_CF,2,3) IN ('101','102','201','202') "
	cQuery+="  GROUP BY D1_TIPO,  D1_FILIAL ,D1_DOC ,D1_EMISSAO,D1_SERIE, D1_FORNECE , A1_NREDUZ, D1_CF ,X5_DESCRI, B5_CODATIV,B5_INSPAT, D1_COD ,E.B1_DESC,D1_VUNIT,D1_QUANT "
 	cQuery+=" order by D2_EMISSAO "
Else	
	cQuery+=" GROUP BY  D2_TIPO,D2_FILIAL,D2_CF,X5_DESCRI, B5_CODATIV,YD_DESC_P,B5_INSPAT "
	cQuery+= " UNION "
	cQuery+= " SELECT D1_TIPO AS TIPO, "
	cQuery+= " D1_FILIAL as D2_FILIAL,D1_CF AS D2_CF,X5_DESCRI, B5_CODATIV,ISNULL(YD_DESC_P,'')AS DNCM,B5_INSPAT,sum(D1_VUNIT*D1_QUANT)AS D2_TOTAL "
	cQuery+= " from "
	cQuery+= " SD1010 A
	cQuery+= " LEFT JOIN SB5010 B ON ( B.D_E_L_E_T_='' AND A.D1_COD=B.B5_COD AND A.D1_FILIAL=B.B5_FILIAL )
	cQuery+= " LEFT JOIN SYD010 C ON ( C.D_E_L_E_T_='' AND B.B5_CODATIV=C.YD_TEC )
	cQuery+= " LEFT JOIN SX5010 D ON ( D.D_E_L_E_T_='' AND D.X5_TABELA='13'AND A.D1_CF=D.X5_CHAVE )
	cQuery+= " WHERE  "
	cQuery+= " A.D_E_L_E_T_='' AND "
	cQuery+= "  A.D1_NFORI<>''  AND  " 
	cQuery+="  A.D1_EMISSAO>='"+Dtos(mv_par01)+"' AND "
	cQuery+="  A.D1_EMISSAO<='"+Dtos(mv_par02)+"' AND "
	cQuery+="  B.B5_CODATIV>='"+mv_par03+"' AND "
	cQuery+="  B.B5_CODATIV<='"+mv_par04+"' AND "
    cQuery+="  SUBSTRING(A.D1_CF,2,3) IN ('101','102','201','202') "
    cQuery+=" GROUP BY  D1_TIPO,D1_FILIAL,D1_CF,X5_DESCRI, B5_CODATIV,YD_DESC_P,B5_INSPAT "
	
Endif



TCQUERY cQuery NEW ALIAS "TRB"

dbSelectArea("TRB")
DbGotop()
While !EOF ()       
	DbSelectArea("TRB")
    if mv_par06=1  
		Emissao:=Substr(D2_EMISSAO,7,2)+'/'+Substr(D2_EMISSAO,5,2)+'/'+Substr(D2_EMISSAO,3,2)
	    @ li,002      PSAY IIF(D2_FILIAL=="01","IND","COM")+"|"
		@ li,Pcol()   PSAY TIPO+"|"
		@ li,Pcol()   PSAY Emissao+"|"
	    @ li,Pcol()   PSAY Alltrim(D2_DOC)+"-"
    	@ li,Pcol()   PSAY Alltrim(D2_SERIE)+"|"
	   	@ li,Pcol()   PSAY D2_CLIENTE+"|"
	   	@ li,Pcol()   PSAY SUBSTR(A1_NREDUZ,1,10)+"|"
		@ li,Pcol()+1 PSAY ALLTRIM(D2_CF)+"|"
	    @ li,Pcol()+1 PSAY SUBSTR(X5_DESCRI,1,30)+"|"
	    @ li,Pcol()+1 PSAY Alltrim(B5_CODATIV)+"|"
	    @ li,Pcol()+1 PSAY IIF(B5_INSPAT=="1","SIM","NAO")+"|"
  	    @ li,Pcol()+1 PSAY D2_COD+'|'
   	    @ li,Pcol()+1 PSAY SUBSTR(B1_DESC,1,30)+'|'
  	    @ li,Pcol()   PSAY Transform(D2_QUANT ,"@E 999,999.99")+"|"
   	    @ li,Pcol()   PSAY Transform(D2_PRCVEN,"@E 9,999,999.99" )+"|"
  	    @ li,Pcol()   PSAY Transform(D2_TOTAL , "@E 9,999,999.99" )
//  	    @ li,Pcol()+1 PSAY SUBSTR(DNCM,1,40)+'|'
    Else
	    @ li,002      PSAY IIF(D2_FILIAL=="01","IND","COM")+"|"
    	@ li,Pcol()   PSAY TIPO+"|"
    	@ li,Pcol()   PSAY Alltrim(D2_CF)+"|"
	    @ li,Pcol()   PSAY SUBSTR(X5_DESCRI,1,40)+"|"
	    @ li,Pcol()+1 PSAY Alltrim(B5_CODATIV)+"|"
	    @ li,Pcol()+1 PSAY SUBSTR(DNCM,1,40)+'|'
	    @ li,Pcol()   PSAY IIF(B5_INSPAT=="1","SIM","NAO")+"|"
	    @ li,Pcol()   PSAY Transform(TOT , "@E 9,999,999.99" ) 
    EndIF 
    li++   
    If Li > 60
	    Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
    Endif  
	dbSelectArea("TRB")
	dbSkip()

Enddo          
DbSelectArea("TRB")
DbCloseArea("TRB") 
//IF li != 80
//       roda(cbcont,cbtxt,tamanho)
//EndIF

Set Device To Screen

If aReturn[5] == 1
   Set Printer to
   dbCommitAll()
   OurSpool(wnrel)
End

MS_FLUSH()      
Return 
/********************************************************************************/
/********************************************************************************/

