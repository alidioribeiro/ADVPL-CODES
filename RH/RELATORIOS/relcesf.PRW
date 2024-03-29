#INCLUDE "rwmake.ch"       
#Include "TOPCONN.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �William Rodrigues                      � Data �  06/04/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/  

User Function relcesf()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relat�rio de entrada e sa�da de  funcion�rio."
Local cPict          := ""
Local titulo		 := "Relat�rio de entrada e sa�da de  funcion�rio."
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

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  06/04/11   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)


dbSelectArea(cString)
dbSetOrder(1)

//���������������������������������������������������������������������Ŀ
//� Selecionando dados de acordo com os par�metros informados. �
//�����������������������������������������������������������������������
CQuery:="  SELECT * FROM ZZI010 AS ZZI "
CQuery+="  WHERE  ZZI.D_E_L_E_T_=''"        
	If	 AllTrim(mv_par01)=="1"  
	                CQuery+="  AND ZZI_TIPO ='Atraso'" 
				ElseIf	AllTrim(mv_par01) =="2"  
					CQuery+="  AND ZZI_TIPO ='Licen�a Medica'"
				ElseIf	AllTrim(mv_par01) =="3"  
				    CQuery+="  AND ZZI_TIPO ='A trabalho'"
				ElseIf	AllTrim(mv_par01) =="4"  
				    CQuery+="  AND ZZI_TIPO ='Particular'"
				ElseIf	AllTrim(mv_par01) =="5"           
				    CQuery+=" AND ZZI_TIPO ='HR Extra'" 
				ElseIf	AllTrim(mv_par01) =="6"           
				    CQuery+=" AND ZZI_TIPO ='Sem Crach�'"  
				ElseIf	AllTrim(mv_par01) =="7"           
				    CQuery+=" AND ZZI_TIPO ='A Servi�o'"
				Else 
				    CQuery+=" AND ZZI_TIPO in('HR Extra','Particular','A trabalho','Licen�a Medica','Atraso','Sem Crach�','A Servi�o')"
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
alert("Aten��o:N�o foi encontrador nenhum registro! Por Favor ferifique os par�metros. T.I - 8913/8914")
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

   //���������������������������������������������������������������������Ŀ
   //� SETREGUA -> Indica quantos registros serao processados para a regua �
   //�����������������������������������������������������������������������       
   titulo := "Relat�rio de Entrada e Sa�da de funcion�rio"                                    
   cabec1 := "|Doc    |  Mat |         Nome            |  C.C |            Motivo                 |   Tipo   |Retorno|  Data  |               Hor�rio Real               |  Hora |   Aprovador       |   Status     |"  
   cabec2 := "|       | Func.|      Funcion�rio        |      |        da solicita��o             | Solici.  |       | Solic. | Data    Hr. Entrada -  Hr. Sa�da    Data |  Desc.|   Nome            |   Situa��o   |"
   //cabec3 := "Soli.   Soli.   Da a��o   Entrada  Sa�da    Chegada   Desconto.  Trabalho    Nome               Situa��o             "
   //         999  999999  111111111122222222223333333333  HH:MM  HH:MM  HH:MM   01/01/08   123    Sim   Sim   ______________________________
   //         012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
   //                   1         2         3         4         5         6         7         8         9         10        11        12         13       14        15        16        17        18        19        20
             

//���������������������������������������������������������������������Ŀ
//� Montando Dados ->Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������
dbSelectArea("ZZZ")
dbGoTop()
While !EOF()

   //���������������������������������������������������������������������Ŀ
   //� Verifica o cancelamento pelo usuario...                             �
   //�����������������������������������������������������������������������    
   
   nTReq++
   nTemT = SomaHoras (nTemT,ZZZ->ZZI_HRGAST)
   
   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //���������������������������������������������������������������������Ŀ
   //� Impressao do cabecalho do relatorio. . .                            �
   //�����������������������������������������������������������������������

   If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
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
   //horario padr�o                                          
   
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
   //N�o exibir o campo Hora da entrada.
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
              @nLin,PCOL()+1   PSAY Substr("SEM APROVA��O|",1,16)
   ENDIF

   
   nLin := nLin + 1 // Avanca a linha de impressao
   DbSelectArea("ZZZ")
   dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo

//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������
//linha
@nLin,000      PSAY Replicate("-",limite) 
nLin := nLin + 1     
@nLin,010      PSAY "TOTAL HORAS DESCONTADAS:"  
@nLin,038      PSAY nTemT  
@nLin,050      PSAY "TOTAL REQUISI��ES:"  
@nLin,070      PSAY nTReq 
DbCloseArea("ZZZ")
SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

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
   //���������������������������������������������������������������������Ŀ
   //� SETREGUA -> Indica quantos registros serao processados para a regua �
   //�����������������������������������������������������������������������       
   titulo := "Relat�rio de Entrada e Sa�da de funcion�rio"                                    
   cabec1 := "Relatorio Sint�tico Fu��o:RELCESF->rel2"
   cabec2 := "Hoje:"+Dtoc(Date())+" "+Time()+" "
   //cabec3 := "                                                                                           Soli.   Soli.   Da a��o   Entrada  Sa�da    Chegada   Desconto.  Trabalho    Nome               Situa��o             "
   //         999  999999  111111111122222222223333333333  HH:MM  HH:MM  HH:MM   01/01/08   123    Sim   Sim   ______________________________
   //         012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
   //                   1         2         3         4         5         6         7         8         9         10        11        12         13       14        15        16        17        18        19        20
             

//���������������������������������������������������������������������Ŀ
//� Montando Dados ->Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������
dbSelectArea("ZZZ")
dbGoTop()
While !EOF()

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //���������������������������������������������������������������������Ŀ
   //� Impressao do cabecalho do relatorio. . .                            �
   //�����������������������������������������������������������������������

   If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 10
   Endif

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
   // @nLin,00 PSAY SA1->A1_COD
   @nLin,00 PSAY "Documento:"+ZZZ->ZZI_DOC             
   @nLin,20   PSAY "Data e Hora da Solicita��o:" 
   @nLin,50   PSAY Stod(ZZZ->ZZI_DTSOL) 
   @nLin,60   PSAY "  "+ZZZ->ZZI_HRSOL
   @nLin+1,00   PSAY Substr(("Matricula:"+ZZZ->ZZI_MAT),1,20)
   @nLin+1,20   PSAY Substr(("Nome:"+ZZZ->ZZI_NOME),1,30)  
   @nLin+1,57   PSAY Substr(("C.C.:"+ZZZ->ZZI_CCUSTO),1,15)   
   @nLin+1,75   PSAY Substr(("C. Descri��o:"+ZZZ->ZZI_CNOME),1,30)
   
   @nLin+2,00   PSAY Substr(("Tipo:"+ZZZ->ZZI_TIPO),1,30)      
   @nLin+2,20   PSAY Substr(("Motivo:"+ZZZ->ZZI_MOTIVO),1,45)  
   @nLin+2,67   PSAY Substr(("Retorno:"+ZZZ->ZZI_RETORN),1,30)
   @nLin+2,85   PSAY Substr(("Aprovador:"+ZZZ->ZZI_NOMEA),1,30)
   
   @nLin+3,00   PSAY "Data das finaliza��es:"
   @nLin+3,25   PSAY Stod(ZZZ->ZZI_DTFIM)  
   @nLin+4,00   PSAY "Horario padr�o do funcion�rio:"            
   @nLin+4,75   PSAY "Horario Sa�da/Chegada:"                                                                          
   @nLin+4,130   PSAY "*Desconto:"
   //horario padr�o                                          
   
   nSaiAlm  := Posicione("SPJ",1,xFilial("SPJ") + Alltrim(ZZZ->ZZI_IDTURN),"PJ_ENTRA2")
   nEntraAlm:= Posicione("SPJ",1,xFilial("SPJ") + Alltrim(ZZZ->ZZI_IDTURN),"PJ_SAIDA1")    
   nHrEnt   := Posicione("SPJ",1,xFilial("SPJ") + Alltrim(ZZZ->ZZI_IDTURN),"PJ_ENTRA1")
   nHrSaiRel:= Posicione("SPJ",1,xFilial("SPJ") + Alltrim(ZZZ->ZZI_IDTURN),"PJ_SAIDA2")
   
   @nLin+4,35   PSAY Transform(StrTran(StrZero(nHrEnt,5,2),".",""),"@R !!:!!" )+"   "      
   @nLin+4,45   PSAY Transform(StrTran(StrZero(nEntraAlm,5,2),".",""),"@R !!:!!" )+"  ~ " 
   @nLin+4,55   PSAY Transform(StrTran(StrZero(nSaiAlm,5,2),".",""),"@R !!:!!" )+"   "     
   @nLin+4,65   PSAY Transform(StrTran(StrZero(nHrSaiRel,5,2),".",""),"@R !!:!!" )+"  "     
   //N�o exibir o campo Hora da entrada.   
   @nLin+4,100   PSAY Transform(StrTran(StrZero(ZZZ->ZZI_HRSAI,5,2),".",""),"@R !!:!!" )+"  "   
   @nLin+4,110   PSAY Transform(StrTran(StrZero(ZZZ->ZZI_HRCHEG,5,2),".",""),"@R !!:!!" )+" "     
   @nLin+4,150   PSAY Transform(StrTran(StrZero(ZZZ->ZZI_HRGAST,5,2),".",""),"@R !!:!!" )+" "     
                                                                                                         
   @nLin+5,00   PSAY "Situa��o da solicita��o:"
   
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
      @nLin+5,30   PSAY Substr("SEM APROVA��O ",1,16)
   ENDIF
  @nLin+6,00   PSAY "Seguran�a:"+ZZZ->ZZI_SEG                                     
  @nLin+7,00   PSAY "Observa��es da portaria:"+ZZZ->ZZI_OBSSEG
  // @nLin+8,00  PSAY "Elaborador da Solicita��o:"+ZZZ->ZZI_ACAO
  @nLin+8,00      PSAY Replicate("-",limite)    
  
  DbSelectArea("ZZZ")
  dbSkip() // Avanca o ponteiro do registro no arquivo    
  
  nLin := nLin +10
   
EndDo          


//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������
//linha


DbCloseArea("ZZZ")
SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

return               


