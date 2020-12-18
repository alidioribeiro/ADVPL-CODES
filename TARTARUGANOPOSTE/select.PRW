#include "RwMake.ch"
#include "TopConn.ch"

*------------------------* 
User Function OrdArq()
*------------------------*
 Private nRadio,aRadio:={"Ordens Soltas","Ordens com Pedidos","Todas"}
  
  nOpcao:=0
  
  Define MsDialog oDlg Title "Geração de Arquivo de Ordens" From 8,0 To 15,35

  @ 20,30 Radio aRadio var nRadio

  bOk:={||nOpcao:=1,oDlg:End()}
  bCancel:={||nOpcao:=0,oDlg:End()}

  Activate MsDialog oDlg On Init EnchoiceBar(oDlg,bOk,bCancel) Centered

  If nOpcao == 1
     Processa({||Gera_Arq()})
  Else 
     Exit
  EndIf

Return                 

*------------------------*
Static Function Gera_Arq()
*------------------------*
 Local cSql := " ",cArq,cNome, cCompl
 
 cSW0 := "SW0"+SM0->M0_CODIGO+"0"
 cSW1 := "SW1"+SM0->M0_CODIGO+"0"
 cSW3 := "SW3"+SM0->M0_CODIGO+"0"
 cEI2 := "EI2"+SM0->M0_CODIGO+"0"
 
 ProcRegua(10)
 
 cArq := "J:\easy\"

 If Select("SI") <> 0
    SI->(dbCloseArea())
 EndIf
 
 Do Case
  Case nRadio == 1
     cCompl := " NOT EXISTS(SELECT * FROM "+cSW3+" WHERE W3_SI_NUM = W0__NUM AND D_E_L_E_T_ <> '*') AND"
     cNome := "OSP"
  Case nRadio == 2
     cCompl := " EXISTS(SELECT * FROM "    +cSW3+" WHERE W3_SI_NUM = W0__NUM AND D_E_L_E_T_ <> '*') AND"
     cCompl += " NOT EXISTS(SELECT * FROM "+EI2 +" WHERE EI2_SI_NUM = W0__NUM AND D_E_L_E_T_ <> '*') AND"
     cNome := "OCP"
  Case nRadio == 3
     cCompl := " " 
     cNome := "TOP"
 EndCase           
 
 cArq += cNome + ".TXT"
 
 cSql += " SELECT DISTINCT W0__NUM AS SI,W0__DT AS EMISSAO,W1_COD_I AS ITEM,STR(W1_QTDE,9,2) AS QTDE,STR(W1_SALDO_Q,9,2) AS SALDO FROM "+cSW0
 cSql += " LEFT JOIN "+cSW1+" ON (W1_SI_NUM = W0__NUM) WHERE "+cCompl
 cSql += " "+cSW0+".D_E_L_E_T_ <> '*' AND "+cSW1+".D_E_L_E_T_ <> '*'"
 
 TCQuery cSql ALIAS SI NEW
 TCSetField("SI","EMISSAO","D")
// TCSetField("SI","QTDE","N",09,02)
// TCSetField("SI","SALDO","N",09,02)
 
 dbSelectArea("SI")
 Copy to (cArq) Sdf
 dbCloseArea() 
 
 IncProc("Gerando Arquivo...")
 
 MsgInfo("Arquivo gerado com sucesso: " + cArq)
 
Return
