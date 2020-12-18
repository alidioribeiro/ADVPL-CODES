#include "RWMAKE.ch"

/*
Funcao.....: xPrintEtq()
Autor......: Paulo Rogerio
Data.......: 28/10/2007
Descric....: Impress�o automatica da Etiqueta de identifica��o de produto, 
             durante o apontamento de produ��o.
*/

User Function xPrintEtq()
Local vlTexto := ""                
Local vlLayout := MemoRead("\Zebra\EtqProd.txt")

//MSCBPRINTER("S4M","LPT1",,,.f.,,,,,,.T.)
  MSCBPRINTER("S4M","LPT1",,,.T.,,"192.168.0.4",,,)


// Ajusta e executa a impress�o das etiquetas de volume.
	vlTexto := vlLayout
	vlTexto := Strtran(vlTexto, "@B1_DESC"   , Alltrim(SUBS(SB1->B1_DESC,1,40)))
	vlTexto := Strtran(vlTexto, "@B1_COD"    , Alltrim(SB1->B1_COD))
	vlTexto := Strtran(vlTexto, "@A7_CODCLI" , Alltrim(SA7->A7_CODCLI))
	vlTexto := Strtran(vlTexto, "@D3_LOTECTL", Alltrim(SD3->D3_LOTECTL))
	vlTexto := Strtran(vlTexto, "@D3_EMISSAO", dtoc(SD3->D3_EMISSAO))
	vlTexto := Strtran(vlTexto, "@B5_XCOR"   , UPPER(Alltrim(Posicione("SX5",1,xFilial("SX5")+"CR"+SB5->B5_XCOR,"X5_DESCRI"))))
	vlTexto := Strtran(vlTexto, "@B5_EAN141" , Alltrim(Str(SB5->B5_EAN141))+" "+SB1->B1_UM+"s")

	vlTexto := Strtran(vlTexto, "@B1_CODBAR" , Alltrim(SB1->B1_CODBAR))
	vlTexto := Strtran(vlTexto, "@D3_LOTE_OP", Subs(Alltrim(SD3->D3_LOTECTL),1,6))

	MSCBBEGIN( 1, 6 )
	MSCBWRITE(vlTexto)
	MSCBEND()

// Finaliza a conex�o com a impressora.
MSCBClosePrinter()

Return
