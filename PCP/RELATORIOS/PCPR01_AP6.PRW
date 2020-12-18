#Include 'FiveWin.Ch'         
#Include 'Topconn.ch' 

User Function PCPR01()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CDESC1,CDESC2,CDESC3,CSTRING,AREGISTROS,CTITULO")
SetPrvt("CTAMANHO,ARETURN,CNOMPROG,NLASTKEY,WNREL,OPR")

cDesc1		:= "Movimentacao de Materiais (Producao)."
cDesc2 	    := ""
cDesc3 	    := ""
cString	    := "SC2" 
aRegistros	:= {}
ctitulo	    := "Relacao da OP´s."
ctamanho	:= "P"
lContinua   := .T.
aReturn     := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
cPerg       := "PCPR01"
cnomprog	:= "PCPR01"
nLastKey	:= 0

wnrel := "PCPR01"
wnrel:=SetPrint(cString,wnrel,cPerg,@ctitulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,cTamanho)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("PCPR01",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        //  Da OP                                    ³
//³ mv_par02        //  Ate a OP                                 ³
//³ mv_par03        //  Do Produto                               ³
//³ mv_par04        //  Ate o Produto                            ³
//³ mv_par05        //  Centro de Custo De                       ³
//³ mv_par06        //  Centro de Custo Ate                      ³
//³ mv_par07        //  Data De                                  ³
//³ mv_par08        //  Data Ate                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If nLastKey == 27
	Set Filter To
	Return
Endif
SetDefault(aReturn,cString)
If nLastKey == 27
	Set Filter To
Endif

RptStatus({|| ImpCodBar()})
Return .T.        

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ImpCodBar   ³ Autor ³ JORGE S. DA SILVA   ³ Data ³  06/99   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime codigo de barras                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 01 cTypeBar String com o tipo do codigo de barras          ³±± 
±±³          ³ 				"EAN13","EAN8","UPCA" ,"SUP5"   ,"CODE128"    ³±±
±±³          ³ 				"INT25","MAT25,"IND25","CODABAR","CODE3_9"    ³±±
±±³          ³ 02 nRow		Numero da Linha em centimentros               ³±±
±±³          ³ 03 nCol		Numero da coluna em centimentros			  ³±±
±±³          ³ 04 cCode		String com o conteudo do codigo               ³±±
±±³          ³ 05 oPr		Objecto Printer                               ³±±
±±³          ³ 06 lcheck	Se calcula o digito de controle               ³±±
±±³          ³ 07 Cor 		Numero  da Cor, utilize a "common.ch"         ³±±
±±³          ³ 08 lHort		Se imprime na Horizontal                      ³±±
±±³          ³ 09 nWidth	Numero do Tamanho da barra em centimetros     ³±±
±±³          ³ 10 nHeigth	Numero da Altura da barra em milimetros       ³±±
±±³          ³ 11 lBanner	Se imprime o linha em baixo do codigo         ³±±
±±³          ³ 12 cFont		String com o tipo de fonte                    ³±±
±±³          ³ 13 cMode		String com o modo do codigo de barras CODE128 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ImpressÆo de etiquetas c¢digo de Barras para HP e Laser    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImpCodBar()

dbSelectArea("SC2")
dbSetOrder(1)
SetRegua(RecCount())             
dbSeek(xFilial("SC2")+Mv_Par01,.T.)
While !Eof() .And. C2_Num+C2_Item+C2_Sequen <= Mv_par02 .And. lContinua

      IncRegua()

      #IFNDEF WINDOWS
              If LastKey() == 286
                       lEnd := .t.
              End
      #ENDIF

      If lEnd
              @PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
              lContinua := .F.
              Exit
      Endif
     
      If C2_Produto < MV_PAR03 .or. C2_Produto > MV_PAR04 .Or.;
         C2_CC < MV_PAR05 .or. C2_CC > MV_PAR06 .Or.;
         C2_DatPrI < MV_PAR07 .or. C2_DatPrF > MV_PAR08
         dbSkip()
         Loop
      End
      
      If C2_QUJE >= C2_QUANT
         dbSkip()
         Loop
      End     
       
      li:=00
      xSeq:=0 
      linbar := 3.0
      xNum := AllTrim(C2_Num)
      While !Eof() .And. C2_Num+C2_Item+C2_Sequen<=Mv_par02 .And. xNum==AllTrim(C2_Num) .And. lContinua
      
            IncRegua()
            
            #IFNDEF WINDOWS
                    If LastKey() == 286
                       lEnd := .t.
                    End
            #ENDIF

            If lEnd
               @PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
               lContinua := .F.
               Exit
            Endif
            
            If C2_Produto < MV_PAR03 .or. C2_Produto > MV_PAR04 .Or.;
               C2_CC < MV_PAR05 .or. C2_CC > MV_PAR06 .Or.;
               C2_DatPrI < MV_PAR07 .or. C2_DatPrF > MV_PAR08
               dbSkip()
               Loop
            End 
            
            If C2_QUJE >= C2_QUANT
               dbSkip()
               Loop
            End     
      
            dbSelectArea("SB1")
            dbSetOrder(1)
            dbSeek(xFilial("SB1")+SC2->C2_Produto)
      
            dbSelectArea("SI3")
            dbSetOrder(1)
            dbSeek(xFilial("SI3")+SC2->C2_CC)
            
            dbSelectArea("SC2")
            @ li,030 PSAY  "O R D E M  D E  P R O D U C A O" ; li:=li+1
            li:=li+1
            @ li,000 PSAY  "Numero: " + C2_Num+" "+C2_Item+" "+C2_Sequen
            @ li,027 PSAY  "Saldo: "+Transform(C2_QUANT-C2_QUJE,"@E 999,999")
            @ li,045 PSAY  "Localizacao: "+ALLTRIM(C2_CC)+" "+SI3->I3_DESC
            li:=li+1
            @ li,000 PSAY  "Produto: "+C2_PRODUTO+" - "+SB1->B1_DESC
            li:=li+1
            @ li,000 PSAY  "Lote Nr..: [___________] Prev.Inicio: "+dtoc(C2_DatPrI)+"       Prev.Fim: "+dtoc(C2_DatPrF)
            li:=li+1
            @ li,000 PSAY  "Data Mov.: ___/___/___   Turno: 1o.[ ] 2o.[ ] 3o.[ ]   Recurso: [_______________]"
            li:=li+2
            @ li,000 PSAY  "Quant.Produzida: [____________]   Quant.Aprovada: [____________]"
            li:=li+2 
            @ li,000 PSAY  "          ________________________           ________________________"
            li:=li+2 
            @ li,000 PSAY  "                   Visto                              Visto   "
            li:=li+1
           // oPr := ReturnPrtObj()
           // MSBAR("CODE128",  linbar ,  4 ,C2_Num+C2_Item+C2_Sequen ,oPr,NIL,NIL,NIL,NIL,0.6,NIL,NIL,NIL)
            li:=li+1
            @ li,000 PSAY  "________________________________________________________________________________" 
            li:=li+1
            @ li,000 PSAY  "           1a. Via do Setor - 2a. Via Segue com produto ate expedicao"
            li:=li+1
            @ li,000 PSAY  "................................................................................" 
            li:=li+1
            xSeq:=xSeq+1  
            If xSeq==4
               xSeq:=0 
               li:=0
            End  
            dbSkip()
      EndDo

EndDo

Set device to Screen

If aReturn[5] == 1
	Set Printer To 
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()
Return .T.
