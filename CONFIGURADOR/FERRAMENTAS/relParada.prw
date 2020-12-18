#INCLUDE "rwmake.ch"     
#Include "TOPCONN.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RelParada � Autor � William rodrigues  � Data �  04/01/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function relParada()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relat�rio de paradas da T.I"
Local cPict          := ""
Local titulo       := "Relat�rio de integridade da T.I"
Local nLin         := 80

Local Cabec1       := ""
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 180
Private tamanho          := "G"
Private nomeprog         := "relparada" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "relparada" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg       := "ZZPREL"
Private cString := "ZZP"

dbSelectArea("ZZP")
dbSetOrder(1)
pergunte(cPerg,.F.)


//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,"ZZPREL",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  04/01/12   ���
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

Local nOrdem
Local cTrueDoc 
dbSelectArea(cString)
dbSetOrder(1)
 
//���������������������������������������������������������������������Ŀ
//� Selecionando dados de acordo com os par�metros informados. �
//�����������������������������������������������������������������������  

CQuery:="  SELECT * FROM ZZP010 AS ZZP "
CQuery+="  WHERE  ZZP.D_E_L_E_T_=''"                                                                
CQuery+="  AND ZZP_DOC >='"+AllTrim(mv_par01)+"' AND ZZP_DOC <='"+AllTrim(mv_par02)+"'"
if (mv_par03 == '01')
CQuery+="  AND ZZP_TIPO = 'SINAL DE REDE'"
Elseif (mv_par03 == '02')
CQuery+="  AND ZZP_TIPO = 'THIN CLIENT'"
Elseif (mv_par03 == '03')    
CQuery+="  AND ZZP_TIPO = 'TELEFONIA'"
Elseif (mv_par03 == '04')    
CQuery+="  AND ZZP_TIPO = 'MICROSIGA'"
Elseif (mv_par03 == '05')    
CQuery+="  AND ZZP_TIPO = 'INTERNET'"
Elseif (mv_par03 == '06')    
CQuery+="  AND ZZP_TIPO = 'EMAIL'"
Elseif (mv_par03 == '07')    
CQuery+="  AND ZZP_TIPO = 'OUTROS'"   
Elseif (mv_par03 == 'ZZ')    
CQuery+="  AND ZZP_TIPO in('OUTROS','EMAIL','INTERNET','MICROSIGA','TELEFONIA','THIN CLIENT','SINAL DE REDE')"
ENDIF
CQuery+="  AND ZZP_CCUSTO >='"+AllTrim(mv_par04)+"'AND ZZP_CCUSTO <='"+AllTrim(mv_par05)+"'"        
CQuery +=" AND ZZP_DTSOL  >='"+Dtos(mv_par06)+"'   AND ZZP_DTSOL <='"+Dtos(mv_par07)+"'"   
CQuery+="  AND ZZP_MAT    >='"+AllTrim(mv_par08)+"'AND ZZP_MAT   <='"+AllTrim(mv_par09)+"'"
   	
    CQuery  += " Order by ZZP_DOC DESC "                       

TCQUERY cQuery NEW ALIAS "ZZZ"


//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(RecCount())
       
//���������������������������������������������������������������������Ŀ                           
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������       
                                   
   cabec1 := "|  Doc  |  Mat.  |       Nome          |  C.C |  Descri��o    |      Tipo     |    Data   |  Hora  |    Data   |  Hora  |     Tecnico    | Houve Setor | Houve Setor |              Comentario               |   Situa��o   |"  
   cabec2 := "|       |        |     Funcion�rio     |      |               |               |   Inicio  | Inicio |    Fim    |  Fim   |     Alocado    | beneficiado |   Afetados  |                Tecnico                |              |"
 //cabec3 := "|000000 | 123456 |Jorge william Rodrigies  |      |                    | Funcion�rio           | JWD-5200 |12/02/2011| 14:00 as 1600 | 14:00 as 16:00 |0000000000     00000000000|   1           0  | Em Andamento|             "
   //         999  999999  111111111122222222223333333333  HH:MM  HH:MM  HH:MM   01/01/08   123    Sim   Sim   ______________________________
   //         012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
   //                   1         2         3         4         5         6         7         8         9         10        11        12         13       14        15        16        17        18        19        20
      

dbSelectArea("ZZZ") 
dbGoTop()
While !EOF()

   //���������������������������������������������������������������������Ŀ
   //� Verifica o cancelamento pelo usuario...                             �
   //�����������������������������������������������������������������������

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
   
   @nLin,00         PSAY "|"+ZZZ->ZZP_DOC
   @nLin,PCOL()+1   PSAY Substr(("|"+ZZZ->ZZP_MAT),1,10)
   @nLin,PCOL()+2   PSAY Substr(("|"+ZZZ->ZZP_NOME),1,20)  
   @nLin,PCOL()+2   PSAY Substr(("|"+ZZZ->ZZP_CCUSTO),1,6)   
   @nLin,PCOL()+1   PSAY Substr(("|"+ZZZ->ZZP_CCDESC),1,15)     
   @nLin,PCOL()+1   PSAY Substr(("|"+ZZZ->ZZP_TIPO),1,16)+"|"     
   @nLin,PCOL()+2   PSAY Stod(ZZZ->ZZP_DTINI)                  
   @nLin,PCOL()+2   PSAY "| "+Transform(StrTran(StrZero(ZZZ->ZZP_HRINI,5,2),".",""),"@R !!:!!" )+" |"      
   @nLin,PCOL()+2   PSAY Stod(ZZZ->ZZP_DTFIM)                                                              
   @nLin,PCOL()+2   PSAY "| "+Transform(StrTran(StrZero(ZZZ->ZZP_HRFIM,5,2),".",""),"@R !!:!!" )+" |"      
   @nLin,PCOL()+1   PSAY Substr((ZZZ->ZZP_NOMETC),1,15)+"|"  
   @nLin,PCOL()+4   PSAY Substr((ZZZ->ZZP_SETBEN),1,5)+"      |"      
   
   cTrueDoc := alltrim(Posicione("ZZP",2,ZZZ->ZZP_DOC,"ZZP_LISAFE"))   
   if(AllTrim(cTrueDoc) == '' )
      @nLin,PCOL()+4   PSAY Substr(("NAO"),1,5)+"      |"   
   Else                                                     
      @nLin,PCOL()+4   PSAY Substr(("SIM"),1,5)+"      |"   
   ENDIF 
   
   cTrueDoc := alltrim(Posicione("ZZP",2,ZZZ->ZZP_DOC,"ZZP_COMTEC")) 
   
      @nLin,PCOL()+2   PSAY Substr((cTrueDoc+Space(35)),1,35)  +"  |"   
      
       IF ZZZ->ZZP_STATUS =='0'
       cstatusSol:="EM ABERTO"+Space(15)
      @nLin,PCOL()+1   PSAY Substr(cstatusSol,1,12)+" |"  
     ELSEIF ZZZ->ZZP_STATUS =='1'                       
     cstatusSol:="APROVADO"+Space(15)
       @nLin,PCOL()+1   PSAY Substr(cstatusSol,1,12)+" |"  
       ELSEIF ZZZ->ZZP_STATUS =='2'
       cstatusSol :="FINALIZADO"+Space(15)
         @nLin,PCOL()+1   PSAY Substr(cstatusSol,1,12)+" |"  
         ELSEIF ZZZ->ZZP_STATUS =='3'
         cstatusSol:="CENCELADO"+Space(15)
          @nLin,PCOL()+1   PSAY Substr(cstatusSol,1,12)+" |"  
            ELSEIF ZZZ->ZZP_STATUS =='4'       
            cstatusSol:="EM ANDAMENTO"+Space(15)
             @nLin,PCOL()+1   PSAY Substr(cstatusSol,1,12)+" |"  
   ENDIF
   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
   // @nLin,00 PSAY SA1->A1_COD

   nLin := nLin + 1 // Avanca a linha de impressao
   DbSelectArea("ZZZ")
   dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo             

DbCloseArea("ZZZ")
DbSelectArea("ZZP")
//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������

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

Return
