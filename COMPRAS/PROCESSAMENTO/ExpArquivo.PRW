#include "rwmake.ch"       
#Include "TOPCONN.CH" 
#include "ap5mail.ch"
#Include "TBICONN.CH"

User Function ExpArq()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATAEXP  ³ Autor ³ Jorge Silveira        ³ Data ³ 18.10.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Geracao das Tabelas de Solicitações de Dados Necessários p/³±±
±±³          ³ cálculo dos Precos de Transferencia.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RDMAKE MATAEXP -X                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico - NIPPON SEIKI                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// Perguntas ( MTAEXP )
// ------------------------------------------------
// 01) Previsao de Vendas      mv_par03    N  1   0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega as Perguntas.                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDlg   := ""
_cPerg     := "EXPARQ"
Pergunte(_cPerg, .F.)

@ 96,13 To 310,592 DIALOG oDlg TITLE "Geracao de arquivo conf. leiaute definidos."
@ 06,6 To 66,284
@ 13,15 SAY OemToAnsi("Este programa tem como objetivo Gerar as arquivos textos com Dados Necessários a Legislações")
@ 23,15 SAY OemToAnsi("Conforme Lay out informados pelos usuários.")
                                      
@ 090,185 BUTTON "Exportar" SIZE 34,11 ACTION TabExp()
@ 090,225 BMPBUTTON TYPE 5             ACTION Pergunte(_cPerg)
@ 090,260 BMPBUTTON TYPE 2             ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED

Return Nil

Static Function TabExp()

cArqTxt := ""
xSeq    := 0
If Mv_par01 == 1
        xSeq := xSeq + 1
        cArqTxt := "C:\dci\RegEst.txt"
      	Processa( { || GerTab01() }, "01)Tabela de Previsao .")
End      	
If Mv_par04 == 1
        xSeq := xSeq + 1
        cArqTxt := "C:\dci\RegMerc.txt"
      	Processa( { || GerTab02() }, "02)Tabela de Mercadoria.")
End      	

If Mv_par05 == 1
        xSeq := xSeq + 1
        cArqTxt := "C:\dci\RegIns.txt"
      	Processa( { || GerTab03() }, "03)Tabela de Insumos.")
End      	


//If xSeq>0
//	Alert("Geração do arquivo concluida C:\dci\")
//EndIF       



Return 


***************************
Static Function GerTab01() // 01) Gera previsao de vendas
***************************

 _cGrava  := ""
 nHdlArq := FCreate(cArqTxt)

 //Verifica qual é o plano vigente
// cQuery:= " select MAX(HC_DTVIGEN) as DATAVIG ,MAX(HC_NUMPLAN) AS NUMPLAN,MAX(HC_REVISAO) AS REV "
// cQuery+= " FROM SHC010 "
// cQuery+= " WHERE HC_FILIAL='01' AND D_E_L_E_T_='' AND  HC_DATA>='"+Dtos(mv_par02)+"' and HC_DATA<='"+Dtos(mv_par03)+"' "
// TcQuery cQuery Alias "TRB"
 
// DbSelectArea("TRB")
// DbGotop()
// If !Eof()
     cQuery:= " select HC_NUMPLAN,HC_REVISAO, HC_PRODUTO,B1_UM,DA1_PRCVEN,SUM(HC_QUANT) QTD  "
	 cQuery+=" FROM SHC010,SB1010,DA1010  "
	 cQuery+=" WHERE "
     cQuery+=" HC_FILIAL='01' "
	 cQuery+="AND SB1010.D_E_L_E_T_=''  "
	 cQuery+="AND DA1010.D_E_L_E_T_=''  "
	 cQuery+="AND DA1_CODPRO=HC_PRODUTO	"
	 cQuery+="AND SHC010.D_E_L_E_T_='' "
	 cQuery+="AND SB1010.D_E_L_E_T_='' "
	 cQuery+="AND B1_COD=HC_PRODUTO "
	 cQuery+="AND B1_FILIAL=HC_FILIAL "
	 //apenas os itens que sofreram internacao
     cQuery+=" and  (B1_COD  LIKE 'HR%' OR B1_COD  LIKE '053%') "
     cQuery+=" AND B1_TIPO='PA' "
	 //apenas os itens que sofreram internacao	 
	 
//	 cQuery+="AND HC_NUMPLAN='"+TRB->NUMPLAN+"' AND HC_REVISAO='"+TRB->REV +"'"  //SERÁ GERADO UMA UNICA VEZ O ARQUVIVO
	 cQuery+="AND HC_NUMPLAN='10' AND HC_REVISAO='004'"  //SERÁ GERADO UMA UNICA VEZ O ARQUVIVO
     cQuery+="	 AND  HC_DATA>='"+Dtos(mv_par02)+"' and HC_DATA<='"+Dtos(mv_par03)+"' "
     cQuery+="	 AND  DA1_CODTAB IN (SELECT DA0_CODTAB FROM DA0010 WHERE D_E_L_E_T_='' AND DA0_DATATE='') "
     cQuery+="	GROUP BY HC_NUMPLAN,HC_REVISAO, HC_PRODUTO,B1_UM,DA1_PRCVEN "
//SELECT * FROM DA0010 WHERE DA0_DATATE='' AND D_E_L_E_T_=''
// EndIf 
// DbSelectArea("TRB") 
// DbCloseArea()
 TcQuery cQuery Alias "TRB"
 
 dbSelectArea("TRB")
 ProcRegua(RecCount())
 dbGoTop()        
 While !Eof()
     VrVenda:=TRB->QTD*TRB->DA1_PRCVEN
    _cGrava := RetCampo(TRB->HC_PRODUTO,20)                 // Codigo do Produto (01;001-020)
    _cGrava := _cGrava + RetNum(TRB->QTD,17,2)              // Quantidade        (02;021-037)
    _cGrava := _cGrava + RetNum(VrVenda,17,2)               // Valor das Venda   (03;038-017)
    _cGrava := _cGrava +RetCampo(TRB->B1_UM,3)              // Unidade de Medida (04;055-003)  
    _cGrava := _cGrava + Chr(13) + Chr(10)                      // Caracteres de Fim de Linha
    FWrite(nHdlArq,_cGrava,Len(_cGrava))
 
 	DbSelectArea("TRB")
 	DbSkip() 
 EndDo 
 FClose(nHdlArq)

 DbSelectArea("TRB") 
 DbCloseArea()
 Close(oDlg)
Return 
***************************
***************************
Static Function GerTab02() // 01) Gera previsao de vendas
***************************

 _cGrava  := ""
 nHdlArq := FCreate(cArqTxt)

 //Verifica qual é o plano vigente
 cQuery:=" select * from SB1010 WHERE B1_COD in (Select G1_COD from BaseTemp..AuxSG1) and D_E_L_E_T_='' "
 TcQuery cQuery Alias "TRB"

 DbSelectArea("TRB")
 ProcRegua(RecCount())
 dbGoTop()        
 While !Eof()
    DataRef:="02012002"
//    If Empty(TRB->B1_DATREF)
//    	DataRef:="01012000"
//    Else 	
//        DataRef :=substr(TRB->B1_DATREF,7,2)+substr(TRB->B1_DATREF,5,2)+substr(TRB->B1_DATREF,1,4)
//    EndIf 
    _cGrava := DataRef
    _cGrava := _cGrava+ RetCampo(TRB->B1_COD ,20)                 // Codigo do Produto (01;001-020)
    _cGrava := _cGrava + RetCampo(TRB->B1_DESC ,45)              // Quantidade        (02;021-037)
    _cGrava := _cGrava + TRB->B1_POSIPI               // Valor das Venda   (03;038-017)
    _cGrava := _cGrava + Chr(13) + Chr(10)                      // Caracteres de Fim de Linha
    FWrite(nHdlArq,_cGrava,Len(_cGrava))
 
 	DbSelectArea("TRB")
 	DbSkip() 
 EndDo 
 FClose(nHdlArq)

 DbSelectArea("TRB") 
 DbCloseArea()
 Close(oDlg)
Return 
***************************

***************************
***************************
Static Function GerTab03() // 01) Gera arquivo com a estrutura de produtos
***************************

 _cGrava  := ""
 nHdlArq := FCreate(cArqTxt)

 //Verifica qual é o plano vigente
 cQuery:=" select CONVERT(INT,G1_QUANT*1000)as QTDEST, "
 cQuery+="DATEDIFF(DAY, "
 cQuery+="convert(datetime,SUBSTRING(G1_INI,7,2)+'/'+SUBSTRING(G1_INI,5,2)+'/'+SUBSTRING(G1_INI,1,4), 104),"
 cQuery+="convert(datetime,SUBSTRING(G1_FIM,7,2)+'/'+SUBSTRING(G1_FIM,5,2)+'/'+SUBSTRING(G1_FIM,1,4), 104)) AS DIF, "
 cQuery+=" CONVERT(INT,G1_PERDA*100) AS PER,B.B1_UM AS UNPROD,C.B1_UM as UNIT , * "
 cQuery+=" from DADOSAP10..SG1010 as A,DADOSAP10..SB1010 B, DADOSAP10..SB1010 C "
 cQuery+=" WHERE A.D_E_L_E_T_='' AND B.D_E_L_E_T_='' AND C.D_E_L_E_T_='' "
 CQuery+=" AND A.G1_COD=B.B1_COD  AND A.G1_COMP=C.B1_COD"
 cQuery+=" AND CONVERT(INT,G1_QUANT*1000)<>0 "
 cQuery+=" AND A.G1_COMP=C.B1_COD "
 TcQuery cQuery Alias "TRB"

/*Leiaute 
CodProduto C 020 0 RIGHT(Trim(SG1->G1_COD),20)
Unidade    C 003 0 Subs(_aTotal[057],1,3)
Cod_Insumo C 020 0 SG1->G1_COMP
Quantidade N 017 3 SG1->G1_QUANT
PerclPerd  N 005 2 SG1->G1_PERDA
Unidade2   C 003 0 Subs(SB1->B1_UM,1,3)
Dt_Inicial C 008 0 DataInt(SG1->G1_INI)
Dt_Final   C 008 0 DataInt(SG1->G1_FIM)
*/

 DbSelectArea("TRB")
 ProcRegua(RecCount())
 dbGoTop()        

 While !Eof()
    If TRB->DIF> 0 //Retira da Estrutura os itens vencidos.
	    aG1_INI:=substr(TRB->G1_INI,7,2)+substr(TRB->G1_INI,5,2)+substr(TRB->G1_INI,1,4)
	    aG1_FIM:=substr(TRB->G1_FIM,7,2)+substr(TRB->G1_FIM,5,2)+substr(TRB->G1_FIM,1,4)
	    _cGrava := RetCampo(TRB->G1_COD ,20)
	    _cGrava := _cGrava+RetCampo(TRB->UNPROD,3)     
	    _cGrava := _cGrava+RetCampo(TRB->G1_COMP,20)     
	    _cGrava := _cGrava+Strzero(TRB->QTDEST,17)     
	    _cGrava := _cGrava+Strzero(TRB->PER,5)     
	    _cGrava := _cGrava+RetCampo(TRB->UNIT,3)     
	    _cGrava := _cGrava+aG1_ini  
	    _cGrava := _cGrava+aG1_Fim
	    _cGrava := _cGrava + Chr(13) + Chr(10)                      // Caracteres de Fim de Linha
	    FWrite(nHdlArq,_cGrava,Len(_cGrava))
	EndIf 
 	DbSelectArea("TRB")
 	DbSkip() 
 EndDo 
 FClose(nHdlArq)

 DbSelectArea("TRB") 
 DbCloseArea()
 Close(oDlg)
Return 
***************************


Static Function TiraCarac(cCarac)
   Local cRet := cCarac, nTam := Len(cCarac)
   
   cRet := StrTran(cRet,"-","")
   cRet := StrTran(cRet,"/","")
   cRet := StrTran(cRet,".","")
   cRet := StrTran(cRet,"(","")
   cRet := StrTran(cRet,")","")
   cRet := cRet + Space(nTam - Len(cRet))

Return(cRet)

Static Function RetCampo(cCampo,nTam)
   Local cRet
   
   cRet := SubStr(AllTrim(cCampo),1,nTam)
   cRet := cRet + Space(nTam-Len(cRet))

Return(cRet)

Static Function RetNum(nCampo,nTam,nDec)
   Local cRet
   
   cRet := StrZero(nCampo * If(nDec==Nil,1,10**nDec),nTam)

Return(cRet)

Static Function Stod(cData)
   Local dRet
   xRet := DtoS(cData)
   dRet := SubStr(xRet,7,2)+"/"+SubStr(xRet,5,2)+"/"+SubStr(xRet,1,4)

Return(dRet)


