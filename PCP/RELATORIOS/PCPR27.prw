#INCLUDE "rwmake.ch"
#Include "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PCPR27      º Autor ³ Jefferson Moreiraº Data ³  31/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Esse programa tem como objetivo mostrar o relatorio de     º±±
±±º          ³ Horas parada por Ordem de produção                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Plan.Controle Produção                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PCPR27


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1    := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2    := "de acordo com os parametros informados pelo usuario."
Local cDesc3    := "Relatorio de Horas Paradas por OP"
Local cPict     := ""
Local titulo    := "Relatório de Produção"
local Li        := 80

Local Cabec1    := "|I N F O R M A Ç Õ E S   DA    O R D E M    D E    P R O D U Ç Ã O                                                                            | I N F O R M A Ç Õ E S   DE   H O R A S   P A R A D A S "
Local Cabec2    := "Op           Produto          Descrição                                           TP  C.C. Prev.Ini  Real      Recurso  Quant.Ori   QuantPro  Data      Doc     Hr.Ini  Hr.Fin  Hr.Par  Cod  Descrição "
         //         XXXXXXXXXXX  XXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XX  XXX  99/99/99  99/99/99  XXXXXX  999.999,99 999.999,99  99/99/99  XXXXXX  99:99   99:99   99:99   99   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
         //         012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
         //                   1         2         3         4         5         6         7         8         9         10        11        12         13       14        15        16        17        18        19        20        21        22
Local imprime   := .T.
Local aOrd := {}
Private lEnd     := .F.
Private lAbortPrint  := .F.
Private CbTxt    := ""
Private limite   := 220
Private tamanho  := "G"  // largura do relatorio --> P 80 pos - M 132 pos - G 220 pos
Private nomeprog := "PCPR27" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo    := 18
Private aReturn  := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey := 0
Private cPerg    := "PCPR27"
Private cbtxt    := Space(10)
Private cbcont   := 00
Private CONTFL   := 01
Private m_pag    := 01
Private wnrel    := "PCPR27" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SC2"

dbSelectArea("SC2")
dbSetOrder(1)


pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,Li) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  31/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,titulo,Li)

nOrdem := aReturn[8]
cbtxt  := Space(10)         
cbcont := 00
li     := 80
ghMaq  := 0
gmMaq  := 0
_ghMaq := 0
_gmMaq := 0
xTHr   := 0 
xTMin  := 0 
xTotHoras:=0

If nLastKey == 27
   Return
Endif

nTipo  := IIF(aReturn[4]==1,15,18)

If Li > 65
   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   Li := 10
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

 SetRegua(RecCount())
cQuery := " "
cQuery := " Select "
 
cQuery += " C2_NUM,C2_ITEM,C2_SEQUEN,C2_PRODUTO,B1_DESC,B1_TIPO,C2_CC,C2_EMISSAO,C2_DATPRI,C2_DATRF,C2_RECURSO,C2_QUANT,C2_OBS,C2_QUJE,B1_CODNBB,Z7_CODMOT,Z7_MOTIVO,Z7_EMISSAO,Z7_DOC,Z7_HINI,Z7_HFIN,Z7_TDEC,C2_TURNO "

cQuery += " From DADOSAP10..SC2010 "
cQuery += " INNER JOIN DADOSAP10..SB1010 ON C2_PRODUTO = B1_COD "
cQuery += " LEFT  JOIN DADOSAP10..SZ7010 ON C2_NUM+C2_ITEM+C2_SEQUEN = Z7_OP "
 
cQuery += " WHERE "
cQuery += " SC2010. D_E_L_E_T_ <> '*'  AND "
cQuery += " SB1010. D_E_L_E_T_ <> '*'  AND "
cQuery += " SZ7010. D_E_L_E_T_ <> '*'  AND "

cQuery += " Z7_TDEC <> '0000' AND "  
cQuery += " C2_NUM+C2_ITEM+C2_SEQUEN >='"+ mv_par01 + "' AND "  
cQuery += " C2_NUM+C2_ITEM+C2_SEQUEN <='"+ mv_par02 + "' AND "
cQuery += " C2_EMISSAO >='"+ DTOS(mv_par03) + "' AND "
cQuery += " C2_EMISSAO <='"+ DTOS(mv_par04) + "' AND "
cQuery += " C2_RECURSO >='"+ mv_par05 + "' AND "
cQuery += " C2_RECURSO <='"+ mv_par06 + "' AND "

cQuery += " C2_CC >='"+ mv_par07 + "' AND "
cQuery += " C2_CC <='"+ mv_par08 + "' "
if !Empty(mv_par09) 
cQuery += " AND Z7_CODMOT >='"+ mv_par09 + "' "
cQuery += " AND Z7_CODMOT <='"+ mv_par10 + "' "  
Endif
do case  
   case mv_par11 = 1
        cQuery += " AND B1_TIPO = 'PA' "
   case mv_par11 = 2
        cQuery += " AND B1_TIPO = 'PI' "
endcase
do case 
   case mv_par12 = 1
        cQuery += " AND C2_TPOP = 'F' "
   case mv_par12 = 2
        cQuery += " AND C2_TPOP = 'P' "
   case mv_par12 = 3
        cQuery += " AND C2_TPOP = 'R' "
   case mv_par12 = 4
        cQuery += " AND C2_TPOP = 'I' "
endcase
do case 
   case mv_par13 = 1
        cQuery += " AND C2_DATRF = '' "
   case mv_par13 = 2
        cQuery += " AND C2_DATRF <> '' "
endcase

cQuery += " Order By "
cQuery += " C2_EMISSAO,C2_NUM,C2_ITEM,C2_SEQUEN ASC "

cQuery := ChangeQuery(cQuery)

TCQUERY cQuery Alias TAA New 
li ++
dbSelectArea("TAA")
dbGoTop()
SetRegua(RecCount())
While !EOF()

       xOP   := Subs(C2_NUM+C2_ITEM+C2_SEQUEN,1,13) 
       ThMaq := 0
       TmMaq := 0
       
       @ li,000           PSAY xOP
       @ li,PCOL()+2      PSAY C2_PRODUTO
       @ li,PCOL()+2      PSAY Subs(B1_DESC,1,50)
       @ li,PCOL()+2      PSAY Subs(B1_TIPO,1,2)
       @ li,PCOL()+2      PSAY Subs(C2_CC,1,3)
       @ li,PCOL()+2      PSAY Subs(C2_DATPRI,7,2) + "/" + Subs(C2_DATPRI,5,2)+ "/" + Subs(C2_DATPRI,3,2)
       @ li,PCOL()+2      PSAY iif (!Empty(C2_DATRF),Subs(C2_DATRF,7,2) + "/" + Subs(C2_DATRF,5,2)+ "/" + Subs(C2_DATRF,3,2),space(8))
       @ li,PCOL()+2      PSAY C2_RECURSO
  //     @ li,PCOL()+2      PSAY "Turno: "+alltrim(transform(C2_TURNO,"@E 9"))+"º" 
       @ li,PCOL()+2      PSAY Transform (C2_QUANT,"@E 999,999.99")
       @ li,PCOL()+1      PSAY Transform (C2_QUJE, "@E 999,999.99")
                                 
       xPcol := PCOL()
       While !EOF().and. xOP  == C2_NUM+C2_ITEM+C2_SEQUEN
        
            
        ThMaq += Val(Subs(Z7_TDEC,1,2))
		TmMaq += Val(Subs(Z7_TDEC,3,2))
	   
		ghMaq += Val(Subs(Z7_TDEC,1,2))
		gmMaq += Val(Subs(Z7_TDEC,3,2))
	   
  //   	ghMaq += Int(gmMaq/60)
 //       gmMaq := Mod(gmMaq,60)
        
          @ li,xPcol+2  PSAY iif (!Empty(Z7_EMISSAO),Subs(Z7_EMISSAO,7,2) + "/" + Subs(Z7_EMISSAO,5,2)+ "/" + Subs(Z7_EMISSAO,3,2),space(8))
          @ li,xPcol+12 PSAY Z7_DOC
          @ li,xPcol+20 PSAY iif (!Empty(Z7_HINI),Transform (Z7_HINI,"@R !!:!!"),space(5))
          @ li,xPcol+28 PSAY iif (!Empty(Z7_HFIN),Transform (Z7_HFIN,"@R !!:!!"),space(5))
          @ li,xPcol+36 PSAY iif (!Empty(Z7_TDEC),Transform (Z7_TDEC,"@R !!:!!"),space(5))          
          @ li,xPcol+44 PSAY Z7_CODMOT
          @ li,xPcol+49 PSAY Z7_MOTIVO
                    
          li ++
          If lAbortPrint
             @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
             Exit
          Endif
          If Li > 65
 	         Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
 	         Li := 10
          End
            
          TAA->(dbSkip())
       
          
       Enddo  
          if !Empty(TmMaq) .or. !Empty(ThMaq)
                ThMaq += Int(TmMaq/60)       
            	@ li,xPcol+12 PSAY "Total de Horas Paradas: "+ Transform(StrZero(ThMaq,2),"99")+":"+StrZero(Mod(TmMaq,60),2)
            li++
          Endif  
          @ li,000      PSAY Replicate("-",limite)
        li++
  
        If Li > 65
 	       Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
 	       Li := 10
        End
Enddo   

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Total Geral de Horas Parads...                                      ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        li++  
        ghMaq += Int(gmMaq/60)
        gmMaq1 := Mod(gmMaq,60)
    //    ghMaq += Int(gmMaq/60)
		@ li,144 PSAY "Total Geral de Horas Paradas: "+Transform(StrZero(ghMaq,4),"9999")+":"+StrZero(gmMaq1,2)
     // @ li,PCOL()+2      PSAY Transform(StrZero(_ghMaq,4),"9999") +":"+ StrZero(Mod(_gmMaq,60),2)
dbClearFil(NIL)
dbCloseArea() 

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressão de Paradas por Motivo...                                  ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   
  If mv_par14 = 1
     li++
     @ li,000      PSAY Replicate("-",limite)
     li++
     @ li,000      PSAY " Resumo de Geral de Horas Paradas por Motivo "
     Li++
     li++ 
     
    
     cQuery1 := " "
   //  cQuery1 := " Select "
 
     cQuery1 += " Select Z7_CODMOT,Z7_MOTIVO,SUM(cast(Substring(Z7_TDEC,3,2) as numeric))AS Z7_MIN,SUM(cast(Substring(Z7_TDEC,1,2) as numeric))AS Z7_HORA "

     cQuery1 += " From DADOSAP10..SZ7010 "
     cQuery1 += " INNER JOIN DADOSAP10..SC2010 ON C2_NUM+C2_ITEM+C2_SEQUEN = Z7_OP "
     cQuery1 += " INNER JOIN DADOSAP10..SB1010 ON C2_PRODUTO = B1_COD "
 
     cQuery1 += " WHERE "
     cQuery1 += " SC2010. D_E_L_E_T_ <> '*'  AND "
     cQuery1 += " SZ7010. D_E_L_E_T_ <> '*'  AND "
     cQuery1 += " SB1010. D_E_L_E_T_ <> '*'  AND "
     
     cQuery1 += " Z7_TDEC <> '0000' AND "  
     cQuery1 += " C2_NUM+C2_ITEM+C2_SEQUEN >='"+ mv_par01 + "' AND "  
     cQuery1 += " C2_NUM+C2_ITEM+C2_SEQUEN <='"+ mv_par02 + "' AND "
     cQuery1 += " C2_EMISSAO >='"+ DTOS(mv_par03) + "' AND "
     cQuery1 += " C2_EMISSAO <='"+ DTOS(mv_par04) + "' AND "
     cQuery1 += " C2_RECURSO >='"+ mv_par05 + "' AND "
     cQuery1 += " C2_RECURSO <='"+ mv_par06 + "' AND "

     cQuery1 += " C2_CC >='"+ mv_par07 + "' AND "
     cQuery1 += " C2_CC <='"+ mv_par08 + "' "
     if !Empty(mv_par09) 
     cQuery1 += " AND Z7_CODMOT >='"+ mv_par09 + "' "
     cQuery1 += " AND Z7_CODMOT <='"+ mv_par10 + "' "  
     Endif
     do case  
        case mv_par11 = 1
             cQuery1 += " AND B1_TIPO = 'PA' "
        case mv_par11 = 2
             cQuery1 += " AND B1_TIPO = 'PI' "
     endcase
     do case 
        case mv_par12 = 1
             cQuery1 += " AND C2_TPOP = 'F' "
        case mv_par12 = 2
             cQuery1 += " AND C2_TPOP = 'P' "
        case mv_par12 = 3
             cQuery1 += " AND C2_TPOP = 'R' "
        case mv_par12 = 4
             cQuery1 += " AND C2_TPOP = 'I' "
     endcase
     do case 
        case mv_par13 = 1
             cQuery1 += " AND C2_DATRF = '' "
        case mv_par13 = 2
             cQuery1 += " AND C2_DATRF <> '' "
     endcase
     

     cQuery1 += " GROUP BY "
     cQuery1 += " Z7_CODMOT,Z7_MOTIVO "
     cQuery1 += " Order By "
     cQuery1 += " Z7_CODMOT "

     cQuery1 := ChangeQuery(cQuery1)

     TCQUERY cQuery1 Alias TAB New 
     
     dbSelectArea("TAB")
     dbGoTop()
     SetRegua(RecCount())
     While !EOF()
    
     
	    
	    _ghMaq += Z7_HORA
		_gmMaq += Z7_MIN
		       
        HORA := Z7_HORA + Int(Z7_MIN/60)
       
       @ li,000           PSAY Z7_CODMOT
       @ li,PCOL()+2      PSAY Z7_MOTIVO
 //      @ li,PCOL()+2      PSAY Z7_HORA
       @ li,PCOL()+2      PSAY Transform(StrZero(HORA,4),"9999") +":"+ StrZero(Mod(Z7_MIN,60),2)
       Li++
       If Li > 65
 	      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
 	      Li := 10
       EndIF
       If lAbortPrint
             @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
             Exit
       Endif
     
     TAB->(dbSkip())
     
     Enddo
     Li++
    
     xTotHr := _ghMaq + Int(_gmMaq/60)       
     @ li,012 PSAY "Total de Horas Paradas: "+ Transform(StrZero(xTotHr,4),"9999")+":"+StrZero(Mod(_gmMaq,60),2)
     
  Endif 

   dbClearFil(NIL)
   dbCloseArea()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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