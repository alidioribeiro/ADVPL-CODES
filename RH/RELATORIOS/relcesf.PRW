#INCLUDE "rwmake.ch"       
#Include "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³William Rodrigues                      º Data ³  06/04/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/  

User Function relcesf()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatório de entrada e saída de  funcionário."
Local cPict          := ""
Local titulo		 := "Relatório de entrada e saída de  funcionário."
Local nLin         	 := 80
Local Cabec1         := ""
Local Cabec2         := ""                                                                                   
Local imprime        := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "ESF" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg      	 := "ZZICESF"
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "relcesf" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString 	 := "ZZI"

dbSelectArea("ZZI")
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

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  06/04/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)


dbSelectArea(cString)
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Selecionando dados de acordo com os parâmetros informados. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CQuery:="  SELECT * FROM ZZI010 AS ZZI "
CQuery+="  WHERE  ZZI.D_E_L_E_T_=''"        
	If	 AllTrim(mv_par01)=="1"  
	                CQuery+="  AND ZZI_TIPO ='Atraso'" 
				ElseIf	AllTrim(mv_par01) =="2"  
					CQuery+="  AND ZZI_TIPO ='Licença Medica'"
				ElseIf	AllTrim(mv_par01) =="3"  
				    CQuery+="  AND ZZI_TIPO ='A trabalho'"
				ElseIf	AllTrim(mv_par01) =="4"  
				    CQuery+="  AND ZZI_TIPO ='Particular'"
				ElseIf	AllTrim(mv_par01) =="5"           
				    CQuery+=" AND ZZI_TIPO ='HR Extra'" 
				ElseIf	AllTrim(mv_par01) =="6"           
				    CQuery+=" AND ZZI_TIPO ='Sem Crachá'"  
				ElseIf	AllTrim(mv_par01) =="7"           
				    CQuery+=" AND ZZI_TIPO ='A Serviço'"
				Else 
				    CQuery+=" AND ZZI_TIPO in('HR Extra','Particular','A trabalho','Licença Medica','Atraso','Sem Crachá','A Serviço')"
	EndIf
				   
				/*
				If mv_par02 == 1  // Aberto
				     CQuery+=" AND ZZI_RETORN ='SIM'"  				
				ElseIf	mv_par02 == 2  // Aprovado
					CQuery+=" AND ZZI_RETORN ='NAO'" 
				Else     
			     	CQuery+=" AND ZZI_RETORN in('NAO','SIM','')" 
				EndIf
                  */
CQuery+="  AND ZZI_DTSOL >= '"+Dtos(mv_par03)+"' AND ZZI_DTSOL  <= '"+Dtos(mv_par04)+"'"  
CQuery+="  AND ZZI_CCUSTO >='"+mv_par05+"'AND ZZI_CCUSTO <='"+mv_par06+"'"    
CQuery+="  AND ZZI_MAT >='"+mv_par07+"'"     
CQuery+="  AND ZZI_MAT <='"+mv_par08+"' "
if mv_par09 <> '6'
    CQuery+="  AND ZZI_STATUS = '"+mv_par09+"'"
   	Else
	CQuery+="  AND ZZI_STATUS in('0','1','2','3','4','5')"
EndiF   
   CQuery  += " Order by ZZI_MAT"                       

TCQUERY cQuery NEW ALIAS "ZZZ"
  
SetRegua(RecCount())            
if empty(ZZZ->ZZI_DOC)
alert("Atenção:Não foi encontrador nenhum registro! Por Favor ferifique os parâmetros. T.I - 8913/8914")
EndIF


IF mv_par10 ==1
rel1(Cabec1,Cabec2,Titulo,nLin)                
Else 
rel2(Cabec1,Cabec2,Titulo,nLin)
EndIF
Return                


static function rel1(Cabec1,Cabec2,Titulo,nLin)        
Local nOrdem         
Local nTemT    :=0 
lOCAL nTReq    :=0
Local cCont    :=1    

Local nSaiAlm  :=0
Local nEntraAlm:=0
Local nHrEnt   :=0
Local nHrSaiRel:=0

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ SETREGUA -> Indica quantos registros serao processados para a regua ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ       
   titulo := "Relatório de Entrada e Saída de funcionário"                                    
   cabec1 := "|Doc    |  Mat |         Nome            |  C.C |            Motivo                 |   Tipo   |Retorno|  Data  |               Horário Real               |  Hora |   Aprovador       |   Status     |"  
   cabec2 := "|       | Func.|      Funcionário        |      |        da solicitação             | Solici.  |       | Solic. | Data    Hr. Entrada -  Hr. Saída    Data |  Desc.|   Nome            |   Situaçâo   |"
   //cabec3 := "Soli.   Soli.   Da ação   Entrada  Saída    Chegada   Desconto.  Trabalho    Nome               Situaçâo             "
   //         999  999999  111111111122222222223333333333  HH:MM  HH:MM  HH:MM   01/01/08   123    Sim   Sim   ______________________________
   //         012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
   //                   1         2         3         4         5         6         7         8         9         10        11        12         13       14        15        16        17        18        19        20
             

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
   nTemT = SomaHoras (nTemT,ZZZ->ZZI_HRGAST)
   
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
   @nLin,00 PSAY "|"+ZZZ->ZZI_DOC
   @nLin,PCOL()+1   PSAY Substr(("|"+ZZZ->ZZI_MAT),1,10)
   @nLin,PCOL()+1   PSAY Substr(("|"+ZZZ->ZZI_NOME),1,23)  
   @nLin,PCOL()+2   PSAY Substr(("|"+ZZZ->ZZI_CCUSTO),1,6)   
   @nLin,PCOL()+1   PSAY Substr(("|"+ZZZ->ZZI_MOTIVO),1,35)   
   @nLin,PCOL()+1   PSAY Substr(("|"+ZZZ->ZZI_TIPO+"|"),1,12)      
   @nLin,PCOL()+2   PSAY Substr((ZZZ->ZZI_RETORN),1,5)+"  |"
    
   @nLin,PCOL()   PSAY Stod(ZZZ->ZZI_DTSOL)  
   @nLin,PCOL()   PSAY "|"                                           
   //horario padrão                                          
   
   nSaiAlm  := Posicione("SPJ",1,xFilial("SPJ") + Alltrim(ZZZ->ZZI_IDTURN),"PJ_ENTRA2")
   nEntraAlm:= Posicione("SPJ",1,xFilial("SPJ") + Alltrim(ZZZ->ZZI_IDTURN),"PJ_SAIDA1")    
   nHrEnt   := Posicione("SPJ",1,xFilial("SPJ") + Alltrim(ZZZ->ZZI_IDTURN),"PJ_ENTRA1")
   nHrSaiRel:= Posicione("SPJ",1,xFilial("SPJ") + Alltrim(ZZZ->ZZI_IDTURN),"PJ_SAIDA2")
   
   @nLin,PCOL()+1   PSAY Stod(ZZZ->ZZI_DTCHEG)     
   IF Alltrim(ZZZ->ZZI_TIPO) == "A trabalho" .Or. Alltrim(ZZZ->ZZI_TIPO) == "Particular"
   @nLin,PCOL()+1   PSAY Transform(StrTran(StrZero(00.00,5,2),".",""),"@R !!:!!" )+"     - "             
   ELSEIF !Empty(ZZZ->ZZI_HRENT) 
   @nLin,PCOL()+1   PSAY Transform(StrTran(StrZero(ZZZ->ZZI_HRENT,5,2),".",""),"@R !!:!!" )+ "     - "       
   ELSE
   @nLin,PCOL()+1   PSAY Transform(StrTran(StrZero(ZZZ->ZZI_HRCHEG,5,2),".",""),"@R !!:!!" )+"     - " 
   ENDIF                   
   
   @nLin,PCOL()+3   PSAY Transform(StrTran(StrZero(ZZZ->ZZI_HRSAI,5,2),".",""),"@R !!:!!" )+"  "    
   @nLin,PCOL()+1   PSAY Stod(ZZZ->ZZI_DTFIM)                        
   @nLin,PCOL()   PSAY "|"                                           
   @nLin,PCOL()+1   PSAY Transform(StrTran(StrZero(ZZZ->ZZI_HRGAST,5,2),".",""),"@R !!:!!" )+" |"     
   
   /*
   @nLin,PCOL()+1   PSAY Transform(StrTran(StrZero(nHrEnt,5,2),".",""),"@R !!:!!" )+"   "      
   @nLin,PCOL()+1   PSAY Transform(StrTran(StrZero(nEntraAlm,5,2),".",""),"@R !!:!!" )+"  ~ " 
   @nLin,PCOL()+1   PSAY Transform(StrTran(StrZero(nSaiAlm,5,2),".",""),"@R !!:!!" )+"   "     
   @nLin,PCOL()+1   PSAY Transform(StrTran(StrZero(nHrSaiRel,5,2),".",""),"@R !!:!!" )+" |"     
   */
   //Não exibir o campo Hora da entrada.
   /*
   IF Alltrim(ZZZ->ZZI_TIPO) == "A trabalho" .Or. Alltrim(ZZZ->ZZI_TIPO) == "Particular"
   @nLin,PCOL()+1   PSAY Transform(StrTran(StrZero(00.00,5,2),".",""),"@R !!:!!" )+"  "            
   ELSE 
   @nLin,PCOL()+1   PSAY Transform(StrTran(StrZero(ZZZ->ZZI_HRENT,5,2),".",""),"@R !!:!!" )+"  "      
   ENDIF                   
   
   @nLin,PCOL()+3   PSAY Transform(StrTran(StrZero(ZZZ->ZZI_HRSAI,5,2),".",""),"@R !!:!!" )+"  "   

   @nLin,PCOL()+3   PSAY Transform(StrTran(StrZero(ZZZ->ZZI_HRCHEG,5,2),".",""),"@R !!:!!" )+" |"     
   @nLin,PCOL()+1   PSAY Transform(StrTran(StrZero(ZZZ->ZZI_HRGAST,5,2),".",""),"@R !!:!!" )+" |"     
       */
   @nLin,PCOL()+1   PSAY Substr((ZZZ->ZZI_NOMEA),1,18)+"|"  
   IF ZZZ->ZZI_STATUS =='0'
      @nLin,PCOL()+1   PSAY Substr("EM ABERTO  |",1,16)
     ELSEIF ZZZ->ZZI_STATUS =='1'
       @nLin,PCOL()+1   PSAY Substr("APROVADO     |",1,16)
       ELSEIF ZZZ->ZZI_STATUS =='2'
         @nLin,PCOL()+1   PSAY Substr("FINALIZADO   |",1,16)
         ELSEIF ZZZ->ZZI_STATUS =='3'
          @nLin,PCOL()+1   PSAY Substr("CENCELADO   |",1,16)
            ELSEIF ZZZ->ZZI_STATUS =='4'       
             @nLin,PCOL()+1   PSAY Substr("EM ANDAMENTO |",1,16)   
             ELSEIF ZZZ->ZZI_STATUS =='5'       
              @nLin,PCOL()+1   PSAY Substr("SEM APROVAÇÂO|",1,16)
   ENDIF

   
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
@nLin,010      PSAY "TOTAL HORAS DESCONTADAS:"  
@nLin,038      PSAY nTemT  
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

return                

static function rel2(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem         
Local nTemT    :=0 
lOCAL nTReq    :=0
Local cCont    :=1    

Local nSaiAlm  :=0
Local nEntraAlm:=0
Local nHrEnt   :=0
Local nHrSaiRel:=0
Tamanho="M"
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ SETREGUA -> Indica quantos registros serao processados para a regua ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ       
   titulo := "Relatório de Entrada e Saída de funcionário"                                    
   cabec1 := "Relatorio Sintético Fução:RELCESF->rel2"
   cabec2 := "Hoje:"+Dtoc(Date())+" "+Time()+" "
   //cabec3 := "                                                                                           Soli.   Soli.   Da ação   Entrada  Saída    Chegada   Desconto.  Trabalho    Nome               Situaçâo             "
   //         999  999999  111111111122222222223333333333  HH:MM  HH:MM  HH:MM   01/01/08   123    Sim   Sim   ______________________________
   //         012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
   //                   1         2         3         4         5         6         7         8         9         10        11        12         13       14        15        16        17        18        19        20
             

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montando Dados ->Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("ZZZ")
dbGoTop()
While !EOF()

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do cabecalho do relatorio. . .                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 10
   Endif

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
   // @nLin,00 PSAY SA1->A1_COD
   @nLin,00 PSAY "Documento:"+ZZZ->ZZI_DOC             
   @nLin,20   PSAY "Data e Hora da Solicitação:" 
   @nLin,50   PSAY Stod(ZZZ->ZZI_DTSOL) 
   @nLin,60   PSAY "  "+ZZZ->ZZI_HRSOL
   @nLin+1,00   PSAY Substr(("Matricula:"+ZZZ->ZZI_MAT),1,20)
   @nLin+1,20   PSAY Substr(("Nome:"+ZZZ->ZZI_NOME),1,30)  
   @nLin+1,57   PSAY Substr(("C.C.:"+ZZZ->ZZI_CCUSTO),1,15)   
   @nLin+1,75   PSAY Substr(("C. Descrição:"+ZZZ->ZZI_CNOME),1,30)
   
   @nLin+2,00   PSAY Substr(("Tipo:"+ZZZ->ZZI_TIPO),1,30)      
   @nLin+2,20   PSAY Substr(("Motivo:"+ZZZ->ZZI_MOTIVO),1,45)  
   @nLin+2,67   PSAY Substr(("Retorno:"+ZZZ->ZZI_RETORN),1,30)
   @nLin+2,85   PSAY Substr(("Aprovador:"+ZZZ->ZZI_NOMEA),1,30)
   
   @nLin+3,00   PSAY "Data das finalizações:"
   @nLin+3,25   PSAY Stod(ZZZ->ZZI_DTFIM)  
   @nLin+4,00   PSAY "Horario padrão do funcionário:"            
   @nLin+4,75   PSAY "Horario Saída/Chegada:"                                                                          
   @nLin+4,130   PSAY "*Desconto:"
   //horario padrão                                          
   
   nSaiAlm  := Posicione("SPJ",1,xFilial("SPJ") + Alltrim(ZZZ->ZZI_IDTURN),"PJ_ENTRA2")
   nEntraAlm:= Posicione("SPJ",1,xFilial("SPJ") + Alltrim(ZZZ->ZZI_IDTURN),"PJ_SAIDA1")    
   nHrEnt   := Posicione("SPJ",1,xFilial("SPJ") + Alltrim(ZZZ->ZZI_IDTURN),"PJ_ENTRA1")
   nHrSaiRel:= Posicione("SPJ",1,xFilial("SPJ") + Alltrim(ZZZ->ZZI_IDTURN),"PJ_SAIDA2")
   
   @nLin+4,35   PSAY Transform(StrTran(StrZero(nHrEnt,5,2),".",""),"@R !!:!!" )+"   "      
   @nLin+4,45   PSAY Transform(StrTran(StrZero(nEntraAlm,5,2),".",""),"@R !!:!!" )+"  ~ " 
   @nLin+4,55   PSAY Transform(StrTran(StrZero(nSaiAlm,5,2),".",""),"@R !!:!!" )+"   "     
   @nLin+4,65   PSAY Transform(StrTran(StrZero(nHrSaiRel,5,2),".",""),"@R !!:!!" )+"  "     
   //Não exibir o campo Hora da entrada.   
   @nLin+4,100   PSAY Transform(StrTran(StrZero(ZZZ->ZZI_HRSAI,5,2),".",""),"@R !!:!!" )+"  "   
   @nLin+4,110   PSAY Transform(StrTran(StrZero(ZZZ->ZZI_HRCHEG,5,2),".",""),"@R !!:!!" )+" "     
   @nLin+4,150   PSAY Transform(StrTran(StrZero(ZZZ->ZZI_HRGAST,5,2),".",""),"@R !!:!!" )+" "     
                                                                                                         
   @nLin+5,00   PSAY "Situação da solicitação:"
   
   IF ZZZ->ZZI_STATUS =='0'
      @nLin+5,30   PSAY Substr("EM ABERTO  ",1,16)
   ELSEIF ZZZ->ZZI_STATUS =='1'
      @nLin+5,30   PSAY Substr("APROVADO     ",1,16)
   ELSEIF ZZZ->ZZI_STATUS =='2'
      @nLin+5,30   PSAY Substr("FINALIZADO   ",1,16)
   ELSEIF ZZZ->ZZI_STATUS =='3'
      @nLin+5,30  PSAY Substr("CENCELADO   ",1,16)
   ELSEIF ZZZ->ZZI_STATUS =='4'       
      @nLin+5,30   PSAY Substr("EM ANDAMENTO ",1,16)   
   ELSEIF ZZZ->ZZI_STATUS =='5'       
      @nLin+5,30   PSAY Substr("SEM APROVAÇÂO ",1,16)
   ENDIF
  @nLin+6,00   PSAY "Segurança:"+ZZZ->ZZI_SEG                                     
  @nLin+7,00   PSAY "Observações da portaria:"+ZZZ->ZZI_OBSSEG
  // @nLin+8,00  PSAY "Elaborador da Solicitação:"+ZZZ->ZZI_ACAO
  @nLin+8,00      PSAY Replicate("-",limite)    
  
  DbSelectArea("ZZZ")
  dbSkip() // Avanca o ponteiro do registro no arquivo    
  
  nLin := nLin +10
   
EndDo          


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//linha


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

return               


