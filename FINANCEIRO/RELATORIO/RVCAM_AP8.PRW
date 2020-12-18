#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 21/02/02
#IFNDEF WINDOWS
#DEFINE PSAY SAY
#ENDIF

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RVCAM     ³ Autor ³ Jefferson Moreira   ³ Data ³ 10.04.2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Relação Variação Cambial                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  

User Function RVCAM()
titulo  := PADC("Variação Cambial",74)
cString := "SB2"
cDesc1  := OemToAnsi("Este programa tem como objetivo, imprimir a relaçâo")
cDesc2  := OemToAnsi("da variação cambial, conforme parametros ")
cDesc3  := OemToAnsi("")
tamanho := "G"  // largura do relatorio --> P 80 pos - M 132 pos - G 220 pos
aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog:= "RVCAM"
aLinha  := {}
nLastKey:= 0
lEnd    := .f.
//6titulo  := Variação Cambial
cPerg   := "RVCAM"
m_pag   := 01 
li      := 80
VariCam := 00
TotalEnt:= 00
TotalSai:= 00
Totalcam:= 00
dTotPar := 00
rTotPar := 00
xVarCor := 00
cCancel := "***** CANCELADO PELO OPERADOR *****" 

Pergunte(cPerg,.F.)

// Mv_par01  Da Baixa
// Mv_par02  Ate Baixa
// Mv_par03  Da Natureza
// Mv_par04  Ate Natureza

wnrel   :="RVCAM"            //Nome Default do relatorio em Disco
wnrel   := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,) 

If nLastKey == 27
    Set Filter To
    Return
Endif

SetDefault(aReturn,cString)


titulo  := "                                                                              Variação Cambial De: "+ dtoc(mv_par01)+" a "+dtoc(mv_par02)+"   
cabec1  := "                                                                                        |                 ENTRADA              |                                    BAIXA DO TITULO                                     |"
cabec2  := "Fornecedor            Titulo        Emissão   Venc.      Natureza    Baixa              Valor U$         Taxa           Total R$  Seq  DATA      TP           Valor U$        Taxa             Total R$  Variação Cambial"
//          XXXXXXXXXXXXXXXXXXXX  XXX XXXXXX X  DD/MM/AA  DD/MM/AA   XXXXXXXXXX  DD/MM/AA  99,999,999,999.99  999.9999999  99,999,999,999.99  XX   DD/MM/AA  XX  99,999,999,999.99  999,9999999  99,999,999,999.99  99,999,999,999.99
//          01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                    1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21        22

//SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho)

nTipo  := IIF(aReturn[4]==1,15,18)

RptStatus({|| RptDetail() })
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RptDetail ³ Autor ³ Jefferson Moreira   ³ Data ³ 10.04.2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Impressao do corpo do relatorio                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  

Static Function RptDetail()

dbSelectArea("SE2")
cArqSD1:=CriaTrab(nil,.f.)
cIndSD1:="E2_FILIAL + DTOS(E2_BAIXA)"
IndRegua("SE2",cArqSD1,cIndSD1,,,"Selecionando Registro..." )
 
SetRegua(RecCount()) //Ajusta numero de elementos da regua de relatorios
Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo) //Impressao do cabecalho

dbSeek(xFilial("SE2") + DTOS(Mv_par01),.T.)
While !Eof() .And. (E2_BAIXA <= Mv_par02)  
      
    IncRegua() //Incrementa a posicao da regua de relatorios
    
    if (E2_NATUREZ < Mv_par03 .or. E2_NATUREZ > Mv_par04)
       dbSkip()
       loop 
    endif  
    
    if E2_MOEDA # 2
       dbSkip()
       loop 
    endif
    
    xTitulo  := E2_PREFIXO +" "+E2_NUM+" "+E2_PARCELA
//    TotalEnt += E2_VLCRUZ 
    
    @ li,000      PSAY SE2->E2_NOMFOR
    @ li,PCOL()+2 PSAY xTitulo
    @ li,PCOL()+2 PSAY SE2->E2_EMISSAO
    @ li,PCOL()+2 PSAY SE2->E2_VENCREA
    @ li,PCOL()+3 PSAY SE2->E2_NATUREZ    
    @ li,PCOL()+2 PSAY SE2->E2_BAIXA
    @ li,PCOL()+2 PSAY TRANSFORM(SE2->E2_VALOR  ,"@e 99,999,999,999.99")
    @ li,PCOL()+2 PSAY TRANSFORM(SE2->E2_TXORIG ,"@e 999.9999999")
    @ li,PCOL()+2 PSAY TRANSFORM(SE2->E2_VLCRUZ ,"@e 99,999,999,999.99")
      xCOL := PCOL()
                                
    dbSelectarea("SE5")
	dbSetOrder(7)
	dbSeek(xFilial("SE5")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE)
       	  
    WHILE !Eof() .And. (SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE == E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR)
	      
	      if !(E5_TIPODOC $ "VL/BA/ES") .OR. E5_SITUACA == "C" 
	          dbSkip()
              loop 
          endif    
          
          if E5_DATA < Mv_par01 .OR. E5_DATA > Mv_par02
              dbsKip()
              Loop
          endif    

         If E5_TIPODOC == "ES"
              dTotPar -= E5_VLMOED2
	          rTotPar -= E5_VALOR
	          xVarCor -= E5_VLCORRE
         else
              dTotPar += E5_VLMOED2
	          rTotPar += E5_VALOR

         ENDIF  
        
	          @ li,130      PSAY E5_SEQ
	          @ li,PCOL()+3 PSAY E5_DATA
	          @ li,PCOL()+2 PSAY E5_TIPODOC 
	          @ li,PCOL()+2 PSAY TRANSFORM(E5_VLMOED2,"@e 99,999,999,999.99")
              @ li,PCOL()+2 PSAY TRANSFORM(E5_TXMOEDA,"@e 999.9999999")
              @ li,PCOL()+2 PSAY TRANSFORM(E5_VALOR  ,"@e 99,999,999,999.99")

	           li += 1
          dbSkip()
     
    ENDDO
   	      
          If (SE2->E2_VALOR - dTotPar) # 00
             xVarCor := (dTotPar * E5_TXMOEDA) - (dTotPar * SE2->E2_TXORIG)
          else
             XVarCor := rTotPar - SE2->E2_VLCRUZ
          endif    
          
	dbSelectarea("SE2")
	 //     li += 1
	      @ li,127 PSAY "Total Parcial "
	      @ li,149 PSAY TRANSFORM(dTotPar ,"@e 99,999,999,999.99")
	      @ li,181 PSAY TRANSFORM(rTotPar ,"@e 99,999,999,999.99")
	      @ li,200 PSAY TRANSFORM(xVarCor ,"@e 99,999,999,999.99")
	       li += 1                 
	      @ li,000 PSAY replicate("-",220)
	       TotalEnt += SE2->E2_VLCRUZ 
	       TotalCam += xVarCor
           dTotPar := 00
           rTotPar := 00
           xVarCor := 00
                                 
 //   VariCam  := SE2->E2_VLCRUZ - SE5->E5_VALOR
 //   Totalcam += VariCam         
        
    li += 1
          
       if li >= 60
	      cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	   End

dbSkip()
          
EndDo

TotalSai := TotalEnt - TotalCam
li += 1
@ li,000 PSAY "Total do Periodo"
@ li,111 PSAY TRANSFORM(TotalEnt ,"@e 99,999,999,999.99")
@ li,181 PSAY TRANSFORM(TotalSai ,"@e 99,999,999,999.99")
@ li,200 PSAY TRANSFORM(TotalCam ,"@e 99,999,999,999.99")

Roda(0,"","G")
Set Device To Screen
Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
Return
