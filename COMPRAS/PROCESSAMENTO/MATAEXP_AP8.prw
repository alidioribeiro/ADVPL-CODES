#include "rwmake.ch"       
#Include "TOPCONN.CH" 
#include "ap5mail.ch"
#Include "TBICONN.CH"

User Function MataExp()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("ODLG,_CPERG,CARQTXT,NHDLARQ,CARQSE2")
SetPrvt("CKEYSE2,CFILSE2,NINDEX1,_CGRAVA,MES01,MES02")
SetPrvt("MES03,MES04,MES05,MES06,MES07,MES08")
SetPrvt("MES09,MES10,MES11,MES12,XTGFOR,XFORNEC")
SetPrvt("XLOJA,XMES,XANO,XTOTVAL,XTOTIRF,XVAL01")
SetPrvt("XVAL02,XVALOR,XIRRF,XDED,")

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
// Data Inicial                mv_par01    D  8
// Data Final                  mv_par02    D  8
// 01) Fornecedore             mv_par03    N  1   0
// 02) Cliente                 mv_par04    N  1   0   
// 03) Produtos                mv_par05    N  1   0
// 04) Fornecedore             mv_par06    N  1   0
// 05) Cliente                 mv_par07    N  1   0
// 06) Produtos                mv_par08    N  1   0
// 07) Fornecedore             mv_par09    N  1   0
// 08) Cliente                 mv_par10    N  1   0
// 09) Produtos                mv_par11    N  1   0
// 10) Fornecedore             mv_par12    N  1   0
// 11) Cliente                 mv_par13    N  1   0
// 12) Produtos                mv_par14    N  1   0
// 13) Cliente                 mv_par15    N  1   0
// 14) Produtos                mv_par16    N  1   0
// 15) Fornecedore             mv_par17    N  1   0
// 16) Cliente                 mv_par18    N  1   0
// 17) Produtos                mv_par19    N  1   0
// 18) Produtos                mv_par20    N  1   0
// ------------------------------------------------

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega as Perguntas.                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDlg   := ""
_cPerg     := "MTAEXP"
Pergunte(_cPerg, .F.)

@ 96,13 To 310,592 DIALOG oDlg TITLE "Geracao da Tabelas para Precos de Transferencia."
@ 06,6 To 66,284
@ 13,15 SAY OemToAnsi("Este programa tem como objetivo Gerar as Tabelas de Solicitações de Dados Necessários")
@ 23,15 SAY OemToAnsi("para cálculo dos Precos de Transferencia. Conforme Lay Out fornecido pela Deloitte.")
                                      
@ 090,185 BUTTON "Exportar" SIZE 34,11 ACTION TabExp()
@ 090,225 BMPBUTTON TYPE 5             ACTION Pergunte(_cPerg)
@ 090,260 BMPBUTTON TYPE 2             ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ TabExp   ³ Autor ³ Jorge S.da Silva      ³ Data ³ 19/02/2002 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Processamento.                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TabExp()                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function TabExp()

// Close(oDlg)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Nome e Diretorio dos Arquivos que devem ser gravados.        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        
cArqTxt := ""
xSeq    := 0
If Mv_par03 == 1
        xSeq := xSeq + 1
        cArqTxt := "C:\TP\Tabela_01"
      	Processa( { || GerTab01() }, "01)Tabela de Fornecedores.")
End      	
If Mv_par04 == 1
        xSeq := xSeq + 1
        cArqTxt := "C:\TP\Tabela_02"
    	Processa( { || GerTab02() }, "02)Tabela de Clientes.")
End    	
If Mv_par05 == 1
        xSeq := xSeq + 1
        cArqTxt := "C:\TP\Tabela_03"
    	Processa( { || GerTab03() }, "03)Tabela de Produtos.")
End    	
IF Mv_par06 == 1
        xSeq := xSeq + 1
        cArqTxt := "C:\TP\Tabela_04"
    	Processa( { || GerTab04() }, "04)Tabela de Divisoes.")
End    	
If Mv_par07 == 1
        xSeq := xSeq + 1
        cArqTxt := "C:\TP\Tabela_05"
    	Processa( { || GerTab05() }, "05)Tabela de Saldos.")
End    	
If Mv_par08 == 1
        xSeq := xSeq + 1
        cArqTxt := "C:\TP\Tabela_06"
    	Processa( { || GerTab06() }, "06)Tabela de Insumo Produto.")
End    	
If Mv_par09 == 1 .Or. Mv_par09 == 3
        xSeq := xSeq + 1
    	cArqTxt := "C:\TP\Tabela_07"
    	Processa( { || GerTab07() }, "07)Tabela de Compras.")
End    	
If Mv_par09 == 2 .Or. Mv_par09 == 3
        xSeq := xSeq + 1
    	cArqTxt := "C:\TP\Tabela_071"
    	Processa( { || GerTab071()}, "07.1)Devolucao de Compras.")
End    	
If Mv_par10 == 1
        xSeq := xSeq + 1
    	cArqTxt := "C:\TP\Tabela_08"
    	Processa( { || GerTab08() }, "08)Tabela de Vendas.")
End    	
If Mv_par11 == 1
        xSeq := xSeq + 1
    	cArqTxt := "C:\TP\Tabela_09"
    	Processa( { || GerTab09() }, "09)Tabela de Custo Medio.")
End    	
If Mv_par12 == 1
        xSeq := xSeq + 1
    	cArqTxt := "C:\TP\Tabela_10"
    	Processa( { || GerTab10() }, "10)Tabela de Equivalencia Produtos.")
End    	
If Mv_par13 == 1
        xSeq := xSeq + 1
    	cArqTxt := "C:\TP\Tabela_11"
    	Processa( { || GerTab11() }, "11)Tabela de PIC.")
End    	
IF Mv_par14 == 1
        xSeq := xSeq + 1
    	cArqTxt := "C:\TP\Tabela_12"
    	Processa( { || GerTab12() }, "12)Tabela de Demo. Resultado Exercicio.")
End    	
If Mv_par15 == 1
        xSeq := xSeq + 1
    	cArqTxt := "C:\TP\Tabela_13"
    	Processa( { || GerTab13() }, "13)Movimentacao.")
End    	
IF Mv_par16 == 1
        xSeq := xSeq + 1
    	cArqTxt := "C:\TP\Tabela_14"
    	Processa( { || GerTab14() }, "14)Tabela de Unidades de Medidas.")
End    	
If Mv_par17 == 1
        xSeq := xSeq + 1
    	cArqTxt := "C:\TP\Tabela_15"
    	Processa( { || GerTab15() }, "15)Tabela de Países.")
End    	
If Mv_par18 == 1
        xSeq := xSeq + 1
    	cArqTxt := "C:\TP\Tabela_16"
    	Processa( { || GerTab16() }, "16)Tabela de Moedas.")
End    	
If Mv_par19 == 1
        xSeq := xSeq + 1
    	cArqTxt := "C:\TP\Tabela_17"
    	Processa( { || GerTab17() }, "17)Tabela de Motivo de Saída.")
End    	
If Mv_par20 == 1
        xSeq := xSeq + 1
    	cArqTxt := "C:\TP\Tabela_18"
    	Processa( { || GerTab18() }, "18)Tabela de Movimentação de Estoque.")
End    	
//If Mv_par21 == 1
//        xSeq := xSeq + 1
//    	cArqTxt := "C:\TP\RegEsti"
//    	Processa( { || GerTab20() }, "19)Previsão de Vendas.")
//End    	


If xSeq == 0
    	MsgAlert("Nenhuma Tabela Selecionada. Selecione as Tabelas Desejadas.")
EndIf

Return

***************************
Static Function GerTab01() // 01) Fornecedores
***************************

 _cGrava  := ""
 nHdlArq := FCreate(cArqTxt)

 dbSelectArea("SA2")
 dbSetOrder(1)

 ProcRegua(RecCount())
 dbGoTop()        
 
 While !Eof() .And. xFilial()==A2_Filial

      IncProc("Exportando Tabelas de Fornecedores...")
    
      CcodPais:=SA2->A2_Pais
      If Empty(cCodPais)
         cCodPais:="105"
      EndIF
      //Conf. solicitação da Delloite 18/01/2012                     
     //
	//1883- SHANGHAI NISSEI DISPLAY SYSTEM CO.,LTD.
	//1883- NS ADUANTECH

 
      If  ('NIPPON'$ SA2->A2_Nome .and. 'SEIKI' $ SA2->A2_Nome) .or. Alltrim(SA2->A2_COD)='1883' .or. Alltrim(SA2->A2_COD)='2472' 
        	lEmpV:='S'
      Else 	
	       	lEmpV:='N'
      Endif 


      If !Empty(SA2->A2_PRICOM)
         _cGrava := RetCampo(SA2->A2_Cod+SA2->A2_Loja,14)       // Cód.do Fornecedor    (14;001-014)
         _cGrava := _cGrava + RetCampo(SA2->A2_Nome,70)         // Nome do Fornecedor   (70;015-084)
//         _cGrava := _cGrava + RetCampo(SA2->A2_Pais,3)   // Alterado conf. a base (Aglair) Código do País       (03;085-087)
 		 _cGrava := _cGrava + RetCampo(cCodPais,3)
//         _cGrava := _cGrava + RetNum(SA2->A2_CodPais,3)         // Código do País       (03;085-087)
//         _cGrava := _cGrava + Iif(SA2->A2_Grupo=="EMD","S","N") // Vínculo (S/N)        (01;088-088)
         //alt. conforme sol. da delloite 18/01/12
		 _cGrava := _cGrava +lEmpV// Vínculo (S/N)        (01;088-088)
         _cGrava := _cGrava + Stod(SA2->A2_PRICOM)              // Data Vínculo Inicial (10;089-098)
         _cGrava := _cGrava + SPACE(10)                         // Data Vínculo Final   (10;099-108)
         _cGrava := _cGrava + SA2->A2_CGC                       // CNPJ                 (14;109-122)
         _cGrava := _cGrava + Chr(13) + Chr(10)                 // Caracteres de Fim de Linha
         FWrite(nHdlArq,_cGrava,Len(_cGrava))
      End
           
      dbSkip()
      
 EndDo

 FClose(nHdlArq)   
 

***************************
Static Function GerTab02() // 01) Clientes
***************************

 _cGrava  := ""
 nHdlArq := FCreate(cArqTxt)

 dbSelectArea("SA1")
 dbSetOrder(1)

 ProcRegua(RecCount())
 dbGoTop()        
 
 While !Eof()

      IncProc("Exportando Tabelas de Clientes...")
      
      If !Empty(SA1->A1_PRICOM)
        //Condição inclusa pela Aglair atender a situação de empresa vinculada
        //Solicitação da Deloitte no dia 18/01/2011
//041   01	SHANGHAI NISSEI DISPLAY SYSTEM CO. LTD.
//047   01	SHANGAI NISSEI DISPLAY SYSTEM  CO., LTD.

        If ( 'NIPPON'$ SA1->A1_Nome .and. 'SEIKI' $ SA1->A1_Nome) .or. (SA1->A1_COD='041' .OR. SA1->A1_COD='047' )
        	lEmpV:='S'
        Else 	
	       	lEmpV:='N'
        Endif 
        CcodPais:=SA1->A1_Pais
        If Empty(cCodPais) .and. SA1->A1_EST<>'EX'
          cCodPais:="105"
        EndIF
         _cGrava := RetCampo(SA1->A1_Cod+SA1->A1_Loja,14)        // Cód.do Cliente       (14;001-014)
         _cGrava := _cGrava + RetCampo(SA1->A1_Nome,70)          // Nome do Cliente      (70;015-084)
//         _cGrava := _cGrava + RetCampo(SA1->A1_Pais,3)       // Alterado conf. a base (Aglair) Código do País       (03;085-087)
		 _cGrava := _cGrava + RetCampo(cCodPais,3)
//         _cGrava := _cGrava + RetNum(SA1->A1_CodPais,3)          // Código do País       (03;085-087)

        // Conf. solicitação da auditoria uma empresa vinculada ao grupo seria a que possue O termo 
        // NIPPON SEIKI  Alt pela Aglair   17/01/2012                                                                      
        //_cGrava := _cGrava + Iif(SA1->A1_CodPais=="399","S","N")  // Vínculo (S/N)        (01;088-088)
	     _cGrava := _cGrava +lEmpV
         _cGrava := _cGrava + Stod(SA1->A1_PRICOM)               // Data Vínculo Inicial (10;089-098)
         _cGrava := _cGrava + SPACE(10)                          // Data Vínculo Final   (10;099-108)
         _cGrava := _cGrava + SA1->A1_CGC                        // CNPJ                 (14;109-122)
         _cGrava := _cGrava + Chr(13) + Chr(10)                  // Caracteres de Fim de Linha
         FWrite(nHdlArq,_cGrava,Len(_cGrava))
      End
           
      dbSkip()
      
 EndDo

 FClose(nHdlArq)   
 
***************************
Static Function GerTab03() // 03) Produtos
***************************

 _cGrava  := ""
 nHdlArq := FCreate(cArqTxt)

 dbSelectArea("SB1")
 dbSetOrder(1)

 ProcRegua(RecCount())
 dbGoTop()        
 
 While !Eof()
 
      IncProc("Exportando Tabelas de Produtos...")
       If SB1->B1_FILIAL=xFilial("SB1")
          dbSkip()
          Loop
       End 

      If !(B1_Tipo $ "MP/MS/PA/PI/MC/AT/BN/GG/PR/RT")
         dbSkip()
         Loop
      End
      
      dbSelectArea("SAH")
      dbSetOrder(1)
      dbSeek(xFilial("SAH")+SB1->B1_UM)
                    
      dbSelectArea("SB1")
      _cGrava := RetCampo(SB1->B1_Cod,15)                         // Cód.do Produto       (14;001-014)
      _cGrava := _cGrava + RetCampo(SB1->B1_Desc,45)              // Descricao            (45;015-059)
      _cGrava := _cGrava + SAH->AH_SIS_MER                        // Unidade Medida       (02;060-061)
      _cGrava := _cGrava + RetCampo(TiraCarac(SB1->B1_PosIpi),8)  // Classificação Fiscal (08;062-069)
      _cGrava := _cGrava + RetNum(B1_IndPer,17,3)                 // Percentual quebras   (17;070-086)
      _cGrava := _cGrava + Chr(13) + Chr(10)                      // Caracteres de Fim de Linha
      FWrite(nHdlArq,_cGrava,Len(_cGrava))
           
      dbSkip()
      
 EndDo

 FClose(nHdlArq)
 

***************************
Static Function GerTab04() // 04) Divisoes
***************************

 _cGrava  := ""
 nHdlArq := FCreate(cArqTxt)

 ProcRegua(1)
 IncProc("Exportando Tabelas de Divisoes...")
      
 _cGrava := TiraCarac(SM0->M0_CGC)                     // Cód.da Empresa       (14;001-014)
 _cGrava := _cGrava + RetCampo(SM0->M0_NOMECOM,70)     // Razao Social         (70;015-084)
 _cGrava := _cGrava + TiraCarac(SM0->M0_CGC)           // CNPJ                 (14;085-098)
 _cGrava := _cGrava + Chr(13) + Chr(10)                // Caracteres de Fim de Linha
 FWrite(nHdlArq,_cGrava,Len(_cGrava))
           
 FClose(nHdlArq)
 

***************************
Static Function GerTab05() // 05) Tabela de Saldos
***************************

 _cGrava  := ""
 nHdlArq := FCreate(cArqTxt)

 dbSelectArea("SB1")
 dbSetOrder(1)          
 

 ProcRegua(RecCount())
 dbGoTop()        
 
 While !Eof()
 
       IncProc("Exportando Tabelas de Saldos...")
       If SB1->B1_FILIAL#xFilial("SB1")
          dbSkip()
          Loop
       End 

       If !(B1_Tipo $ "MP/MS/PA/PI/PR/RT")
          dbSkip()
          Loop
       End
       dbSelectArea("SAH")  // Tab. de Unidade de Medidas
       dbSetOrder(1)
       dbSeek(xFilial("SAH")+SB1->B1_UM)
      
       dbSelectArea("SB9")
       dbSetOrder(1)
       
       xDatIni := mv_par01 - 1
       xQtdIni := 0
       xValIni := 0
       xDatFin := mv_par02
       xQtdFin := 0
       xValFin := 0
       
       If dbSeek(xFilial("SB9") + SB1->B1_Cod)  // +"01"+dtos(mv_par01-1),.T.)
       
          While !Eof() .And. SB1->B1_Cod == SB9->B9_Cod
             If Dtos(B9_Data) == Dtos(xDatIni)
                xQtdIni := xQtdIni + SB9->B9_qIni
                xValIni := xValIni + SB9->B9_vIni1
             ElseIf Dtos(B9_Data) == Dtos(xDatFin)
                xQtdFin := xQtdFin + SB9->B9_qIni
                xValFin := xValFin + SB9->B9_vIni1   
             End
             dbSkip()
          EndDo      
          
          // Primeito Registro: Data Inicial
          _cGrava := RetCampo(SB1->B1_Cod,15)                    // Cód.do Produto       (14;001-014)
          _cGrava := _cGrava + Stod(xDatIni)                     // Data Inventario      (45;015-024)
          _cGrava := _cGrava + RetNum(xQtdIni,17,3)              // Quant.Em Estoque     (17;025-041)
          _cGrava := _cGrava + RetNum(xValIni,17,3)              // Valor Em Estoque     (17;042-058)
          _cGrava := _cGrava + RetCampo(SAH->AH_SIS_MER,2)       // Unidade Medida       (02;059-060)
          _cGrava := _cGrava + Chr(13) + Chr(10)                 // Caracteres de Fim de Linha
          FWrite(nHdlArq,_cGrava,Len(_cGrava))
          
          // Segundo Registro: Data Final
          _cGrava := RetCampo(SB1->B1_Cod,15)                    // Cód.do Produto       (14;001-014)
          _cGrava := _cGrava + Stod(xDatFin)                     // Data Inventario      (45;015-024)
          _cGrava := _cGrava + RetNum(xQtdFin,17,3)              // Quant.Em Estoque     (17;025-041)
          _cGrava := _cGrava + RetNum(xValFin,17,3)              // Valor Em Estoque     (17;042-058)
          _cGrava := _cGrava + RetCampo(SAH->AH_SIS_MER,2)       // Unidade Medida       (02;059-060)
          _cGrava := _cGrava + Chr(13) + Chr(10)                 // Caracteres de Fim de Linha
          FWrite(nHdlArq,_cGrava,Len(_cGrava))
       
       EndIf
       
       dbSelectArea("SB1")
       dbSkip()
      
 EndDo

 FClose(nHdlArq)

***************************
Static Function GerTab06() // 06) Tabela de Insumo Produto
***************************

 _cGrava  := ""
 nHdlArq := FCreate(cArqTxt)

 dbSelectArea("SC2")
 cArqSC2 := CriaTrab(NIL,.F. )
 cKeySC2 := "C2_Filial+C2_Num+C2_Item+C2_Sequen"
 cFilSC2 := "C2_Filial='"+xFilial("SC2")+"'.And.DTOS(C2_DATPRI)>='"+DTOS(Mv_par01)+"'.And.DTOS(C2_DATPRI)<='"+DTOS(Mv_par02)+"'"
 IndRegua("SC2",cArqSC2,cKeySC2,,cFilSC2,"Selecionando Registros...")

 ProcRegua(RecCount())
 dbGoTop()        
 
 While !Eof()
 
       IncProc("Exportando Tabelas de Insumo Produto...")
      
       xOP := C2_Num+C2_Item+C2_Sequen
       
       If SC2->C2_QUJE > 0 .And. SC2->C2_TPOP # "R"
          dbSelectArea("SD3")
          dbSetOrder(1)
          dbSeek(xFilial("SD3")+xOP)
          While !Eof() .And. AllTrim(D3_OP) == xOP
       
             If D3_Estorno == "S" .Or. D3_TM == "400"
                dbSkip()
                Loop
             End

             dbSelectArea("SAH")  // Tab. de Unidade de Medidas
             dbSetOrder(1)
             dbSeek(xFilial("SAH")+SD3->D3_UM)
             xUMMP   := SAH->AH_SIS_MER // D3_UM
             dbSeek(xFilial("SAH")+SC2->C2_UM)
             xUMPA   := SAH->AH_SIS_MER // D3_UM
             
             dbSelectArea("SD3")
             xToProd := 0
             xCod    := D3_Cod
             While !Eof() .And. AllTrim(D3_OP)==xOP .And. D3_Cod==xCod
             
                   If D3_Estorno == "S" .Or. !(D3_CF $ "RE1/RE2/RE5") // D3_TM == "400" P
                      dbSkip()                                   // Incluso o TM=RE1 itens que são produzidos e consumido dentro do proprio processo da IA
                      Loop                                       //Alterado pela Aglair  21/01/10
                   End
                   
                   xToProd := xToProd + D3_Quant

                   If Alltrim(D3_Grupo) == "GGF"     // Jorge Em: 13/02/2007
                      xToProd := SC2->C2_QUJE
                   End
                   dbSkip()
             EndDo
             If xToProd > 0
                //B50206591900103 00000000029080000 11 99000069000     00000000000001760 10 01100105001   10/01/2005
                _cGrava := RetCampo(SC2->C2_Produto,15)          // Cód.do Produto Acabado   (14;001-014)
                _cGrava := _cGrava + RetNum(SC2->C2_QUJE,17,4)   // Quantidade Produzida     (14;015-028)
                _cGrava := _cGrava + xUMPA                       // Unid.Medida Prod.Acabado (02;029-030)
                _cGrava := _cGrava + xCod                        // Cód.da Materia Prima     (14;031-044)
                _cGrava := _cGrava + RetNum(xToProd,17,4)        // Quantidade Requisitada   (17;045-061)
                _cGrava := _cGrava + xUMMP                       // Unid.Medida Mat.Prima    (02;062-063)
                _cGrava := _cGrava + RetCampo(xOP,14)            // Nr.Ordem de Producao     (14;064-077)
                _cGrava := _cGrava + Stod(SC2->C2_Emissao)       // Data da Ordem Producao   (10;078-087)
                _cGrava := _cGrava + Stod(SC2->C2_DatRF)         // Data da Encer. da OP     (10;088-097)
                _cGrava := _cGrava + Chr(13) + Chr(10)           // Caracteres de Fim de Linha
                FWrite(nHdlArq,_cGrava,Len(_cGrava))
             End
          EndDo
       End   
       dbSelectArea("SC2")
       dbSkip()
 EndDo

 FClose(nHdlArq) 
 
***************************
Static Function GerTab07() // 07) Tabela de Compras
***************************

 _cGrava := ""
 nHdlArq := FCreate(cArqTxt)

 dbSelectArea("SF1")
 cArqSF1 := CriaTrab(NIL,.F. )
 cKeySF1 := "F1_Filial + DtoS(F1_DtDigit) + F1_Doc "
 cFilSF1 := "F1_Filial='"+xFilial("SF1")+"'.And.DTOS(F1_DTDIGIT)>='"+DTOS(Mv_par01)+"'.And.DTOS(F1_DTDIGIT)<='"+DTOS(Mv_par02)+"'"
 IndRegua("SF1",cArqSF1,cKeySF1,,cFilSF1,"Selecionando Registros...")

 ProcRegua(RecCount())
 dbGoTop()        
 
 While !Eof()
 
       IncProc("Exportando Tabelas Compras...")
       
       If !(AllTrim(F1_Tipo) $ "N")
          dbSkip()
          Loop
       End
       
       dbSelectArea("SE4")
       dbSetOrder(1)
       dbSeek(xFilial("SE4")+SF1->F1_Cond)
             
       dbSelectArea("SE2")
       dbSetOrder(6)
       dbSeek(xFilial("SE2")+SF1->F1_Fornece+SF1->F1_Loja+SF1->F1_Serie+SF1->F1_Doc)

       xDoc := (SF1->F1_Doc+SF1->F1_Serie+SF1->F1_Fornece+SF1->F1_Loja)
       
       dbSelectArea("SD1")
       dbSetOrder(1)
       dbSeek(xFilial("SD1")+xDoc)
       While !Eof() .And. SD1->D1_Doc+SD1->D1_Serie+SD1->D1_Fornece+SD1->D1_Loja == xDoc
              
            // If !(AllTrim(SD1->D1_Grupo) $ "MPI/MPN") .Or. !(SD1->D1_Tipo $ "N") .Or. SD1->D1_Cod=="Desp001"
            // Ajustado conforme determinacao do Sr. Diego (Auditor da Deloite) em 14/04/2009.
             If !(SD1->D1_Tipo $ "N") .Or. D1_TES $ "300/301/302/313/398"   // SD1->D1_Cod=="Desp001"
                dbSkip()
                Loop
             End
             
             dbSelectArea("SZB")
             dbSetOrder(1)
             dbSeek(xFilial("SZB")+SD1->D1_Invoice+SD1->D1_Pedido)

             dbSelectArea("SC7")
             dbSetOrder(4)
//             xMoeda := "   "
             xMoeda := "790"
             xValor := 0        
			 xPreco := 0 	
             If !(dbSeek(xFilial("SC7")+SD1->D1_Cod+SD1->D1_Pedido+SD1->D1_ItemPc))
                xMoeda := "790"
                xPreco := RetNum(SD1->D1_TOTAL,17,2)
             Else
                xMoeda := Iif(SC7->C7_MOEDA==1,"790",Iif(SC7->C7_MOEDA==2,"220","470"))
                xPreco := RetNum((SD1->D1_QUANT*SC7->C7_PRECO),17,2) //O preco unitário do pedido é diferente  alterado pela Aglair
				if xMoeda<>"790" .and. SD1->D1_TX>0      //Condicao Inclusa pela Aglair
	                PrecNf:=SD1->D1_TOTAL/SD1->D1_TX
	                xPreco := RetNum(PrecNf,17,2)// O preco unitário passa a ser o informado da DI
				EndIF
             End
            
             dbSelectArea("SF4")
             dbSetOrder(1)
             dbSeek(xFilial("SF4")+SD1->D1_TES)

             dbSelectArea("SD1")

             If /*SF4->F4_Estoque == "S" .And. */SF4->F4_Duplic == "S"
                _cGrava := RetCampo(SD1->D1_Cod,15)                      // Código do Produto        (14;001-014)
                _cGrava := _cGrava + RetCampo(SM0->M0_NOMECOM,14)        // Nome da Divisao          (14;015-028)
                _cGrava := _cGrava + RetCampo(SD1->D1_FORNECE+SD1->D1_LOJA,14) // Codigo do Fornecedor     (14;029-042)
                _cGrava := _cGrava + Space(14)                           // Nr. Lanc. Contabil       (14;043-056)
                _cGrava := _cGrava + RetCampo(SD1->D1_INVOICE,14)        // Nr. Fatura Comercial     (14;057-070)
                _cGrava := _cGrava + STOD(SZB->ZB_DATABL)                // Data da BL               (10;071-080)
                _cGrava := _cGrava + Transform(SD1->D1_DI,"@R !!/!!!!!!!-!  ") // Numero da DI       (14;081-094)
                _cGrava := _cGrava + STOD(SZB->ZB_DATADI)                // Data da DI               (10;095-104)
                _cGrava := _cGrava + RetCampo(SD1->D1_DOC,14)            // NR. NFISCAL ENTRADA      (14;105-118)
                _cGrava := _cGrava + STOD(SD1->D1_DTDIGIT)               // Data da Entrada          (10;119-128)
                _cGrava := _cGrava + RetCampo(SD1->D1_CF,5)              // Nr. Cod.Fiscal Operacao  (05;129-133)
                _cGrava := _cGrava + STOD(SE2->E2_VENCREA)               // Data de Vencimento       (10;134-143)
                _cGrava := _cGrava + RetCampo(SE4->E4_COND,4)            // Prazo de Vencimento      (04;144-147)
                _cGrava := _cGrava + RetNum(SD1->D1_QUANT,17,3)          // Quantidade               (17;148-164)
               // _cGrava := _cGrava + RetNum((SD1->D1_QUANT*SC7->C7_PRECO),17,2) // Valor FOB(Moeda estrang.)(17;165-181)
               // _cGrava := _cGrava + Iif(SC7->C7_MOEDA==1,"790",Iif(SC7->C7_MOEDA==2,"220","   "))   // Cod.Moeda estrangeira    (03;182-184) 
                _cGrava := _cGrava + xPreco                              // Valor FOB(Moeda estrang.)(17;165-181)
                _cGrava := _cGrava + xMoeda                              // Cod.Moeda estrangeira    (03;182-184)
                _cGrava := _cGrava + RetNum(SZB->ZB_FRETE,17,2)          // Frete                    (17;185-201)
                _cGrava := _cGrava + RetNum(SZB->ZB_SEGURO,17,2)         // Seguro                   (17;202-218)
                _cGrava := _cGrava + "   "                               // Cod. Moeda Frete         (03;219-221)
                _cGrava := _cGrava + "   "                               // Cod. Moeda Seguro        (03;222-224)
              //  _cGrava := _cGrava + RetNum(SD1->D1_TOTAL,17,2)          // Valor CIF                (17;225-241)
              //  _cGrava := _cGrava + "   "                               // Cod. Moeda Valor CIF     (03;242-244)
                _cGrava := _cGrava + RetNum(SD1->D1_II,17,2)             // Valor de Importação      (17;245-261)
                _cGrava := _cGrava + RetNum(SD1->D1_VALICM,17,2)         // ICMS (Reais)             (17;262-278)
                _cGrava := _cGrava + RetNum(SD1->D1_VALIMP5,17,2)        // PIS (Reais)              (17;279-295)
                _cGrava := _cGrava + RetNum(SD1->D1_VALIMP6,17,2)        // COFINS (Reais)           (17;296-312)
                _cGrava := _cGrava + RetCampo(SD1->D1_UM,2)              // Valor de Importação      (17;313-314)
                _cGrava := _cGrava + RetNum(SD1->D1_VALDESC,17,2)        // Valor de Desconto        (17;315-331)
                _cGrava := _cGrava + Space(14)                           // Centro de Lucro          (14;332-345)
                _cGrava := _cGrava + RetCampo(SD1->D1_CC,14)             // Centro de Custo          (14;346-359)
                _cGrava := _cGrava + Chr(13) + Chr(10)                   // Caracteres de Fim de Linha
                FWrite(nHdlArq,_cGrava,Len(_cGrava))
             End   
             dbSkip()
       EndDo
       
       dbSelectArea("SF1")
       dbSkip()
       
 EndDo

 FClose(nHdlArq) 
 

***************************
Static Function GerTab071() // 071) Devolucao de Compras
***************************

 _cGrava  := ""
 nHdlArq := FCreate(cArqTxt)

 dbSelectArea("SD2")
 cArqSD2 := CriaTrab(NIL,.F. )
 cKeySD2 := "D2_Filial+D2_Doc+D2_Cod+DtoS(D2_Emissao)"
 cFilSD2 := "D2_Filial='"+xFilial("SD2")+"'.And.DTOS(D2_Emissao)>='"+DTOS(Mv_par01)+"'.And.DTOS(D2_Emissao)<='"+DTOS(Mv_par02)+"'"
 IndRegua("SD2",cArqSD2,cKeySD2,,cFilSD2,"Selecionando Registros...")

 ProcRegua(RecCount())
 dbGoTop()        
 
 While !Eof()
 
       IncProc("Exportando Develocao de Compras...")
      
       If !(D2_Tipo $ "D")
          dbSkip()
          Loop
       End
       
       _cGrava := RetCampo(SD2->D2_Cod,15)                       // Código do Produto        (14;001-014)
       _cGrava := _cGrava + RetNum(SD2->D2_QUANT,17,3)           // Quantidade Devolvida     (17;015-031)
       _cGrava := _cGrava + RetCampo(SD2->D2_UM,2)               // Unidade de Medida        (02;032-033)
       _cGrava := _cGrava + RetCampo(SD2->D2_Doc,14)             // Numero Nota Fiscal       (14;034-047)
       _cGrava := _cGrava + Space(14)                            // Numero R.E.              (14;048-061)
       _cGrava := _cGrava + Chr(13) + Chr(10)                    // Caracteres de Fim de Linha
       FWrite(nHdlArq,_cGrava,Len(_cGrava))

       dbSkip()
 
 EndDo

 FClose(nHdlArq)
 
***************************
Static Function GerTab08() // 08) Vendas de Produtos Acabados.
***************************

 _cGrava := ""
 nHdlArq := FCreate(cArqTxt)

 dbSelectArea("SF2")
 cArqSF2 := CriaTrab(NIL,.F. )
 cKeySF2 := "F2_Filial + DtoS(F2_Emissao) + F2_Doc "
 cFilSF2 := "F2_Filial='"+xFilial("SF2")+"'.And.DTOS(F2_Emissao)>='"+DTOS(Mv_par01)+"'.And.DTOS(F2_Emissao)<='"+DTOS(Mv_par02)+"'"
 IndRegua("SF2",cArqSF2,cKeySF2,,cFilSF2,"Selecionando Registros...")

 ProcRegua(RecCount())
 dbGoTop()        
 
 While !Eof()
 
       IncProc("Exportando Vendas de Produto Acabado...")
       
       If !(Alltrim(F2_Tipo) $ "N")
          dbSkip()
          Loop
       End
       
       dbSelectArea("SE4")
       dbSetOrder(1)
       dbSeek(xFilial("SE4")+SF2->F2_Cond)
             
       dbSelectArea("SE1")
       dbSetOrder(1)
       dbSeek(xFilial("SE1")+SF2->F2_Serie+SF2->F2_Doc)

       dbSelectArea("SD2")
       dbSetOrder(3)
       dbSeek(xFilial("SD2")+SF2->F2_Doc+SF2->F2_Serie+SF2->F2_Cliente+SF2->F2_Loja)
       While !Eof() .And. SD2->D2_Doc+SD2->D2_Serie+SD2->D2_Cliente+SD2->D2_Loja == SF2->F2_Doc+SF2->F2_Serie+SF2->F2_Cliente+SF2->F2_Loja
              
             // Ajustado conforme determinacao do Sr. Diego (Auditor da Deloite) em 14/04/2009.
             //If !(AllTrim(SD2->D2_Tp) $ "PA")
             //   dbSkip()
             //   Loop
             //End
             
             dbSelectArea("SF4")
             dbSetOrder(1)
             dbSeek(xFilial("SF4")+SD2->D2_TES)

             dbSelectArea("SD2")

             If SF4->F4_Estoque == "S" .And. SF4->F4_Duplic == "S"
                _cGrava := RetCampo(SD2->D2_Cliente+SD2->D2_Loja,14)     // Código do Cliente        (14;001-014)
                _cGrava := _cGrava + RetCampo(SD2->D2_DOC,14)            // Nr. da Nota Fiscal       (14;015-028)
                _cGrava := _cGrava + RetCampo(SD2->D2_Serie,14)          // Série da Nota Fiscal     (14;029-042)
                _cGrava := _cGrava + RetCampo(SM0->M0_NOMECOM,14)        // Nome da Divisao          (14;043-056)
                _cGrava := _cGrava + RetCampo(SD2->D2_CF,5)              // C.F.O.P.                 (05;057-061)
                _cGrava := _cGrava + STOD(SD2->D2_EMISSAO)               // Data de Emissao          (10;062-071)
                _cGrava := _cGrava + STOD(SE1->E1_VENCREA)               // Data de Vencimento       (10;072-081)
                _cGrava := _cGrava + RetCampo(SE4->E4_COND,4)            // Prazo de Vencimento      (04;082-085)
                _cGrava := _cGrava + RetCampo(SD2->D2_ITEM,14)           // Item da Nota Fiscal      (14;086-099)
                _cGrava := _cGrava + RetCampo(SD2->D2_COD,15)            // Cod.do Produto           (14;100-113)
                _cGrava := _cGrava + RetNum(SD2->D2_QUANT,17,3)          // Quantidade               (17;114-130)
                _cGrava := _cGrava + RetNum(SD2->D2_TOTAL,17,2)          // Valor Sem o IPI          (17;131-147)
                _cGrava := _cGrava + RetNum(SD2->D2_DESCON,17,2)         // Valor de Descontos       (17;148-164)
                _cGrava := _cGrava + RetNum(SD2->D2_VALICM,17,2)         // Valor de ICMS            (17;165-181)
                _cGrava := _cGrava + RetNum(SF2->F2_VALPIS,17,2)         // Valor do PIS             (17;182-198)
                _cGrava := _cGrava + RetNum(SF2->F2_VALCOFI,17,2)        // Valor do COFINS          (17;199-215)
                _cGrava := _cGrava + RetNum(SF2->F2_VALISS,17,2)         // Valor do ISS             (17;216-232)
                _cGrava := _cGrava + "00000000000000000"                 // Valor da Comissao        (17;233-249)
                _cGrava := _cGrava + RetNum(SF2->F2_FRETE,17,2)          // Valor do FRETE           (17;250-266)
                _cGrava := _cGrava + RetNum(SF2->F2_SEGURO,17,2)         // Valor do SEGURO          (17;267-283)
                _cGrava := _cGrava + STOD(SD2->D2_EMISSAO)               // Data de Embarque         (10;284-293)
                _cGrava := _cGrava + "790"                               // Cod.Moeda estrangeira    (03;294-296)
                _cGrava := _cGrava + RetNum(SD2->D2_TOTAL,17,2)          // Valor Moeda Estrangeira  (17;297-313)
                _cGrava := _cGrava + RetNum(SD2->D2_Custo1,17,2)         // Custo da Venda (CPV)     (17;314-330)
                _cGrava := _cGrava + Space(14)                           // Numero R.E.              (14;331-344)
                _cGrava := _cGrava + RetCampo(SF4->F4_CODIGO,14)         // Cod.Motivo de Saída      (14;345-358)
                _cGrava := _cGrava + Chr(13) + Chr(10)                   // Caracteres de Fim de Linha
                FWrite(nHdlArq,_cGrava,Len(_cGrava))
             End   
             dbSkip()
       EndDo
       
       dbSelectArea("SF2")
       dbSkip()
       
 EndDo

 FClose(nHdlArq) 
 

***************************
Static Function GerTab09() // 09) Tabela de Custo Medio
***************************

 _cGrava  := ""
 nHdlArq := FCreate(cArqTxt)

 dbSelectArea("SD2")
 cArqSD2 := CriaTrab(NIL,.F. )
 cKeySD2 := "D2_Filial+D2_Cod+DtoS(D2_Emissao)"
 cFilSD2 := "D2_Filial='"+xFilial("SD2")+"'.And.DTOS(D2_Emissao)>='"+DTOS(Mv_par01)+"'.And.DTOS(D2_Emissao)<='"+DTOS(Mv_par02)+"'" 
//INCLUI NO FILTRO APENAS O ARMAZEM 20 CONFORME O RELATORIO GGF007
//Aglair Ishii  21/01/2011
// cFilSD2 := "D2_Filial='"+xFilial("SD2")+"'.And.DTOS(D2_Emissao)>='"+DTOS(Mv_par01)+"'.And.DTOS(D2_Emissao)<='"+DTOS(Mv_par02)+"' .AND. D2_LOCAL='20' " 

 IndRegua("SD2",cArqSD2,cKeySD2,,cFilSD2,"Selecionando Registros...")

 ProcRegua(RecCount())
 dbGoTop()        
 
 While !Eof()
 
       IncProc("Exportando Tabelas Custo Medio dos PA's...")
      
       If !(D2_TP $ "PA")
          dbSkip()
          Loop
       End
      
       xCod := D2_Cod
       While !Eof() .And. D2_Cod==xCod
       
             If !(D2_TP $ "PA")
                dbSkip()
                Loop
             End
             tQuant := 0
             tCusto := 0
             xCusto := 0
             xMes := Strzero(Month(SD2->D2_Emissao),2)
             While !Eof() .And. D2_Cod==xCod .And. xMes==Strzero(Month(SD2->D2_Emissao),2)
                   
                   dbSelectArea("SF4")             
                   dbSetOrder(1)
                   dbSeek(xfilial("SF4")+SD2->D2_Tes)
      
                   dbSelectArea("SD2")
             
                   If !(D2_TP $ "PA") .Or. SF4->F4_Duplic<>"S"
                      dbSkip()
                      Loop
                   End
                   
                   tQuant := tQuant + SD2->D2_Quant
                   tCusto := tCusto + SD2->D2_Custo1
                   
                   xAno   := Strzero(Year(SD2->D2_Emissao),4)
                 //  xCusto := (SD2->D2_Custo1 / SD2->D2_Quant)
                   dbSkip()
             EndDo 
             If tCusto > 0    
                _cGrava := RetCampo(xCod,15)                           // Cód.do Produto       (14;001-014)
                _cGrava := _cGrava + xMes                              // Mês                  (02;015-016)
                _cGrava := _cGrava + xAno                              // Ano                  (04;017-020)
                _cGrava := _cGrava + RetNum(tCusto/tQuant,17,3)               // Custo Médio Unitário (17;021-037)
                _cGrava := _cGrava + Chr(13) + Chr(10)                 // Caracteres de Fim de Linha
                FWrite(nHdlArq,_cGrava,Len(_cGrava))
             Endif   
       EndDo
       
 EndDo

 FClose(nHdlArq)

***************************
Static Function GerTab10() // 10) Equivalencia de Produtos
***************************

 _cGrava  := ""
 nHdlArq := FCreate(cArqTxt)

 ProcRegua(RecCount())
 IncProc("Exportando Tabelas de Equivalencia de Produtos...")
      
 FWrite(nHdlArq,_cGrava,Len(_cGrava))
           
 FClose(nHdlArq)
 
***************************
Static Function GerTab11() // 11) Tabela PIC
***************************

 _cGrava  := ""
 nHdlArq := FCreate(cArqTxt)

 ProcRegua(RecCount())
 IncProc("Exportando Tabelas PIC...")
      
 FWrite(nHdlArq,_cGrava,Len(_cGrava))
           
 FClose(nHdlArq)
 
***************************
Static Function GerTab12() // 12) Demonstrativo do Resultado
***************************

 _cGrava  := ""
 nHdlArq := FCreate(cArqTxt)

 ProcRegua(RecCount())
 IncProc("Exportando Demonstrativo do Resultado...")
      
 FWrite(nHdlArq,_cGrava,Len(_cGrava))
           
 FClose(nHdlArq)

***************************
Static Function GerTab13() // 13) Movimentação
***************************

 _cGrava  := ""
 nHdlArq := FCreate(cArqTxt)

 ProcRegua(RecCount())
 IncProc("Exportando Tabelas de Movimentação...")
      
 FWrite(nHdlArq,_cGrava,Len(_cGrava))
           
 FClose(nHdlArq)


***************************
Static Function GerTab14() // 14) Unidades de Medidas
***************************

 _cGrava  := ""
 nHdlArq := FCreate(cArqTxt)

 dbSelectArea("SAH")
 dbSetOrder(1)

 ProcRegua(RecCount())
 dbGoTop()        
 
 While !Eof()
 
      IncProc("Exportando Tabelas de Unidades de Medidas...")
      
      _cGrava := RetCampo(SAH->AH_UNIMED,2)                       // Código da Unidade    (02;001-002)
      _cGrava := _cGrava + RetCampo(SAH->AH_Descpo,45)            // Descricao            (45;003-047)
      _cGrava := _cGrava + Chr(13) + Chr(10)                      // Caracteres de Fim de Linha
      FWrite(nHdlArq,_cGrava,Len(_cGrava))
           
      dbSkip()
      
 EndDo

 FClose(nHdlArq)


***************************
Static Function GerTab15() // 15) Tabela de Países
***************************

 _cGrava  := ""
 nHdlArq := FCreate(cArqTxt)

 ProcRegua(RecCount())
 IncProc("Exportando Tabelas de Paises...")
      
 FWrite(nHdlArq,_cGrava,Len(_cGrava))
           
 FClose(nHdlArq)
 

***************************
Static Function GerTab16() // 16) Moedas
***************************

 _cGrava  := ""
 nHdlArq := FCreate(cArqTxt)

 ProcRegua(RecCount())
 IncProc("Exportando Tabelas de Moedas...")
      
 FWrite(nHdlArq,_cGrava,Len(_cGrava))
           
 FClose(nHdlArq)
 
***************************
Static Function GerTab17() // 17) Motivo de Saída
***************************

 _cGrava  := ""
 nHdlArq := FCreate(cArqTxt)

 dbSelectArea("SF4")
 dbSetOrder(1)

 ProcRegua(RecCount())
 dbGoTop()        
 
 While !Eof()
 
       IncProc("Exportando Tabelas de Motivo de Saida...")
       
       If SF4->F4_CODIGO < "500" .Or. SF4->F4_ESTOQUE <> "S"
          dbSkip()
          Loop
       End   
                                                                   //                            T  INI FIM
       _cGrava := RetCampo(SF4->F4_CODIGO,14)                      // Código Motivo da Saída    (14;001-014)
       _cGrava := _cGrava + RetCampo(SF4->F4_TEXTO,45)             // Descricao                 (45;015-059)
       _cGrava := _cGrava + Chr(13) + Chr(10)                      // Caracteres de Fim de Linha
       FWrite(nHdlArq,_cGrava,Len(_cGrava))
           
       dbSkip()
      
 EndDo
           
 FClose(nHdlArq)

***************************
Static Function GerTab18() // 18) Movimentacao de Estoque
***************************

 _cGrava  := ""
 nHdlArq := FCreate(cArqTxt)

 ProcRegua(RecCount())
 IncProc("Exportando Tabelas de Movimentacao de Estoque...")
      
 FWrite(nHdlArq,_cGrava,Len(_cGrava))
           
 FClose(nHdlArq)

***************************
Static Function GerTab19() // 19) Tabelas Auxiliares
***************************

 _cGrava  := ""
 nHdlArq := FCreate(cArqTxt)

 ProcRegua(RecCount())
 IncProc("Exportando Tabelas Auxiliares...")
      
 FWrite(nHdlArq,_cGrava,Len(_cGrava))
           
 FClose(nHdlArq)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim de geração das Tabelas.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

MsgBox ("Tabelas geradas com sucesso!","Informaçäo","INFO")
Return

dbSelectArea("SA2")
RetIndex("SA2")

dbSelectArea("SA1")
RetIndex("SA1")

dbSelectArea("SC2")
RetIndex("SC2")

dbSelectArea("SD3")
RetIndex("SD3")


Set Filter to

Return Nil

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

