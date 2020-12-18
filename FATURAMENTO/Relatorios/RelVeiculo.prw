#INCLUDE "rwmake.ch"    
#Include "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Relatório    º Autor ³William Rodroguesº Data ³  08/07/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RelVeiculo()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatório de Entrada e Saída de Veiculo"
Local cPict          := ""
Local titulo       := "Relatório de Entrada e Saída de Veiculo"
Local nLin         := 80

Local Cabec1       := ""
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "RelVeiculo" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "ZZJ"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RelVeiculo" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "ZZJ"

dbSelectArea("ZZJ")
dbSetOrder(1)


pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem         
Local nTKm   :=0 
lOCAL nTReq  :=0
Local cCont  :=0        
Private cstatusSol  := Space(13)
dbSelectArea(cString)
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Selecionando dados de acordo com os parâmetros informados. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  

CQuery:="  SELECT * FROM ZZJ010 AS ZZJ "
CQuery+="  WHERE  ZZJ.D_E_L_E_T_=''"          

                If mv_par01=='01'  
	                CQuery+="  AND ZZJ_TIPOSO ='FUNCIONARIO'" 
				ElseIf	mv_par01=='02'  
					CQuery+="  AND ZZJ_TIPOSO ='FORNECEDOR'"
				ElseIf	mv_par01=='03' 
				    CQuery+="  AND ZZJ_TIPOSO ='TERCERIZADO'"
				ElseIf	mv_par01=='04'
				    CQuery+="  AND ZZJ_TIPOSO ='GERENTE'" 
				ElseIf	mv_par01=='05'
				    CQuery+="  AND ZZJ_TIPOSO ='CLIENTE'"
				Else 
				    CQuery+="  AND ZZJ_TIPOSO in('GERENTE','TERCERIZADO','FORNECEDOR','FUNCIONARIO','CLIENTE')"
	            EndIf
		   
				
CQuery+="  AND ZZJ_DTREG >= '"+Dtos(mv_par02)+"' AND ZZJ_DTREG <= '"+Dtos(mv_par03)+"'"  
		
CQuery+="  AND ZZJ_MATID >='"+AllTrim(mv_par04)+"'AND ZZJ_MATID <='"+AllTrim(mv_par05)+"'"    

CQuery+="  AND ZZJ_PLACA >='"+AllTrim(mv_par06)+"'AND ZZJ_PLACA <='"+AllTrim(mv_par07)+"'"  
  
CQuery+="  AND ZZJ_CCUSTO >='"+AllTrim(mv_par08)+"'AND ZZJ_CCUSTO <='"+AllTrim(mv_par09)+"'"  
 
if mv_par10='0'
    CQuery+="  AND ZZJ_STATUS ='0'"
    Elseif mv_par10='1' 
	CQuery+="  AND ZZJ_STATUS ='1'" 
	Elseif mv_par10='2' 
	CQuery+="  AND ZZJ_STATUS ='2'" 
	Elseif mv_par10='3' 
	CQuery+="  AND ZZJ_STATUS ='3'"
	Elseif mv_par10='4' 
	CQuery+="  AND ZZJ_STATUS ='4'"
	Else
	CQuery+="  AND ZZJ_STATUS in('0','1','2','3','4')"
EndiF
  
   CQuery += " AND ZZJ_EMPRES like '"+AllTrim(mv_par11)+"%'"
   
   CQuery  += " Order by ZZJ_DOC "                       

TCQUERY cQuery NEW ALIAS "ZZZ"

  
SetRegua(RecCount())            
if empty(ZZZ->ZZJ_DOC)
alert("Atenção:Não foi encontrado nenhum registro! Por Favor ferifique os parâmetros. T.I - 8913/8914")
EndIF


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                           
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ       
   titulo := "Relatório de Entrada e Saída de Veiculos"                                    
   cabec1 := "|   Doc   |   Mat.   |         Nome         |   Descrição    |  Data    |  Data    |    Tipo     |  Placa  |  Marca  |    Horário     |     Horário    |       KM        |        Destino         |  Status  | Seguraça    |"  
   cabec2 := "|         |   ID.    |       Condutor       |                | Registro.|  Saida   |   Solic.    |         |         |   Prevista     |    Realizado   |Inicio     Fim   |                        |          |             |"
   /*
   cabec1 := "|   Doc   |   Mat.   |         Nome          |  C.C |   Descrição    |  Data    |    Tipo     |  Placa  |  Marca  |    Horário     |     Horário    |       KM        |        Destino         |  Status     | Seguraça   |"  
   cabec2 := "|         |   ID.    |       Condutor        |      |                | Registro.|   Solic.    |         |         |   Prevista     |    Realizado   |Inicio     Fim   |                        |             |            |"
   */
 //cabec3 := "|000000 | 164589545 |Jorge william Rodrigies  |      |                    | Funcionário           | JWD-5200 |12/02/2011| 14:00 as 1600 | 14:00 as 16:00 |0000000000     00000000000|   1           0  | Em Andamento|             "
   //         999  999999  111111111122222222223333333333  HH:MM  HH:MM  HH:MM   01/01/08   123    Sim   Sim   ______________________________
   //         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
   //                   1         2         3         4         5         6         7         8         9         10        11        12         13       14        15        16        17        18        19        20        21        22
             

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montando Dados ->Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("ZZZ")
dbGoTop()
While !EOF()

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica o cancelamento pelo usuario...                             ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    
   
   nTReq++
   
   nTKm += ZZZ->ZZJ_NKMTT
   
   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do cabecalho do relatorio. . .                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
   
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 9
      
   Endif

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
   // @nLin,00 PSAY SA1->A1_COD
   @nLin,00 PSAY "|"+ZZZ->ZZJ_DOC
   @nLin,PCOL()     PSAY Substr(("|"+ZZZ->ZZJ_MATID),1,10)
   @nLin,PCOL()+1   PSAY Substr(("|"+ZZZ->ZZJ_SOLIC),1,22)  
// @nLin,PCOL()+2   PSAY Substr(("|"+ZZZ->ZZJ_CCUSTO),1,6)   
   @nLin,PCOL()+1   PSAY Substr(("|"+ZZZ->ZZJ_CNOME),1,17)+"|"   
   @nLin,PCOL()+1   PSAY dtoc(Stod(ZZZ->ZZJ_DTREG))+" |"
   @nLin,PCOL()+1   PSAY dtoc(Stod(ZZZ->ZZJ_DTEVT))
            
   @nLin,PCOL()+1   PSAY Substr(("|"+ZZZ->ZZJ_TIPOSO),1,13)    
   @nLin,PCOL()+1   PSAY Substr(("|"+ZZZ->ZZJ_PLACA),1,9)
   @nLin,PCOL()+1   PSAY Substr(("|"+ZZZ->ZZJ_MARCA),1,10)+"|"
    
   
   @nLin,PCOL()+1   PSAY Transform(StrTran(StrZero(ZZZ->ZZJ_HRSAIP,5,2),".",""),"@R !!:!!" )+" ás"      
   @nLin,PCOL()+1   PSAY Transform(StrTran(StrZero(ZZZ->ZZJ_HRCHPR,5,2),".",""),"@R !!:!!" )+" |" 
   @nLin,PCOL()+1   PSAY Transform(StrTran(StrZero(ZZZ->ZZJ_HRSAIR,5,2),".",""),"@R !!:!!" )+" ás"     
   @nLin,PCOL()+1   PSAY Transform(StrTran(StrZero(ZZZ->ZZJ_HRCHRE,5,2),".",""),"@R !!:!!" )+" |"     

   @nLin,PCOL()     PSAY Transform(ZZZ->ZZJ_KMSAI,"@R 999,999" ) 
   @nLin,PCOL()     PSAY " - "
   @nLin,PCOL()     PSAY Transform(ZZZ->ZZJ_KMCHEG,"@R 999,999" )  
   @nLin,PCOL()   PSAY Substr(("|"+ZZZ->ZZJ_DESTIN),1,24)


  
    IF ZZZ->ZZJ_STATUS =='0'
       cstatusSol:="EM ABERTO"
      @nLin,PCOL()+1   PSAY Substr("|"+cstatusSol,1,23)
     ELSEIF ZZZ->ZZJ_STATUS =='1'                       
     cstatusSol:="APROVADO"
       @nLin,PCOL()+1   PSAY Substr("|"+cstatusSol,1,23)
       ELSEIF ZZZ->ZZJ_STATUS =='2'
       cstatusSol :="FINALIZADO"
         @nLin,PCOL()+1   PSAY Substr("|"+cstatusSol,1,23)
         ELSEIF ZZZ->ZZJ_STATUS =='3'
         cstatusSol:="CENCELADO"
          @nLin,PCOL()+1   PSAY Substr("|"+cstatusSol,1,23)
            ELSEIF ZZZ->ZZJ_STATUS =='4'       
            cstatusSol:="EM ANDAMENTO"
             @nLin,PCOL()+1   PSAY Substr("|"+cstatusSol,1,23)
   ENDIF
   @nLin,PCOL()   PSAY Substr(("|"+ZZZ->ZZJ_SEG),1,15)+"|"
   
   nLin := nLin + 1 // Avanca a linha de impressao
   DbSelectArea("ZZZ")
   dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//linha
@nLin,000      PSAY Replicate("-",limite) 
nLin := nLin + 1     
@nLin,010      PSAY "TOTAL KM:"  
@nLin,038      PSAY nTKm  
@nLin,050      PSAY "TOTAL REQUISIÇÕES:"  
@nLin,070      PSAY nTReq 
DbCloseArea("ZZZ")
SET DEVICE TO SCREEN


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return
