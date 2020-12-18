#INCLUDE "rwmake.ch"   
#INCLUDE "Protheus.ch"   
#include "ap5mail.ch"     
#Include "TOPCONN.CH"
#Include "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WFE01     ºAutor  ³Jefferson Moreira   º Data ³  21/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ ENVIA PARA OS RESPONSAVEIS A RELAÇÃO DE ITENS EM INSPEÇÃO  º±±
±±º          ³ COM DE 24Hr DE SALDO NO ARMAZEM 98                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8  - Esse grava o e-mail enviado                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

********************************
  User Function TESTE
  Local cServer  := "nsb43" 
//  Local cServer  := "nsbsrv03.nsb.br"
//  Local cServer  := "smtp.mail.yahoo.com.br 465"
///  Local cAccount := "workflow"
  Local cAccount := "jmoreira"
  Local cPass    := "advpl"     
  Local cMsg     := "Teste"
  Local cEmail   := "jmoreira@nippon-seikibr.com.br"   
  Local cTitulo  := "teste"   
  
  Prepare Environment Empresa "01" Filial "01" Tables "SB1","SD7"   // Usado apenas quando o uso for por agendamento
  
  CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPass RESULT lResult 
    //- Se a conexao com o SMPT esta ok
  If lResult
    qout("...................................CONECTADO.............................")
     //- Se existe autenticacao para envio valida pela funcao MAILAUTH                
  //  If (GetMv("MV_RELAUTH")) //lRelauth
  //    qout("...................................AUTENTICANDO.............................")
    lRet:= Mailauth("jeffersonbcm","jesus22")
    //Else
      lRet:= .T.
    //Endif
    If lRet
      qout("...................................ENVIANDO.............................")
      cSubject := "TESTE"
      cSubject:= cTitulo
           SEND MAIL FROM cAccount   ;
                     TO cEmail;
	                 SUBJECT cSubject ;
	                 BODY cMsg
	    DISCONNECT SMTP SERVER
      qout("...................................FINALIZOU.............................")
      qout("De : "+cAccount+" Para :"+cEmail+" Assunto : "+cSubject)
     EndIf  
  Else
    qout("...................................NAO CONECTOU.............................")
    
  EndIf
Return .T.
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MITA001   ³ Autor ³ Ricardo Mansano       ³ Data ³01/03/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³ Fabr.Tradicional ³Contato ³ mansano@microsiga.com.br       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Bops ³ Manutencao Efetuada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³      ³                                        ³±±
±±³              ³  /  /  ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/  
**********************************************************************************
User Function exempl()
**********************************************************************************

cQuery := " SELECT D3_COD,B1_DESC,D3_UM,D3_LOCAL,D3_COD,B1_DESC,D3_UM,D3_LOCAL,D3_NUMSERI,D3_LOTECTL,D3_NUMLOTE,D3_DTVALID,D3_POTENCI,D3_QUANT,D3_QTSEGUM,D3_ESTORNO,D3_NUMSEQ,D3_LOTECTL,D3_DTVALID "
cQuery += " FROM SD3010 "
cQuery += " INNER JOIN SB1010 ON D3_COD = B1_COD "
cQuery += " WHERE D3_DOC = '135876' "  

cQuery := ChangeQuery(cQuery)
TCQUERY cQuery Alias TRB New  

U_exempl_()

RETURN
 
**********************************************************************************
User Function exempl_()
**********************************************************************************
Local lOk := .T.
Local aCab := {}
LOCAL LOCALANT:="01"
Local aItem:= {}
Local aArray := {}
PRIVATE N:=1
PRIVATE lMsErroAuto := .F.
Private lMsHelpAuto     := .F.           
DBSELECTAREA("TRB") 
TRB->(DBGOBOTTOM()) 
_nreg := TRB->(RECNO())
TRB->(DBGOTOP())       

aArray := {{     "",;                              // 01.Numero do Documento
                    DATE()}}                    // 02.Data da Transferencia     
PROCREGUA(_nreg)
WHILE TRB->(!EOF()) 
   INCPROC()
 //  IF !( TRB->RB_OK = ' ')

  //   IF VerifItem(999.999,.T.,D3_COD , "01") // verifica item
          MSGSTOP("ENTROU")
          aAdd(aArray,{       D3_COD,;                         // 01.Produto Origem
                              B1_DESC,;                     // 02.Descricao
                              D3_UM,;                     // 03.Unidade de Medida
                              D3_LOCAL,;                     // 04.Local Origem
                              "10",;                  // 05.Endereco Origem
                              D3_COD,;                         // 06.Produto Destino
                              B1_DESC,;                         // 07.Descricao
                              D3_UM,;                         // 08.Unidade de Medida
                              D3_LOCAL,;                                   // 09.Armazem Destino
                              "01",;     // 10.Endereco Destino
                              CriaVar("D3_NUMSERI",.F.),;     // 11.Numero de Serie
                              CriaVar("D3_LOTECTL",.F.),;                         // 12.Lote Origem
                              CriaVar("D3_NUMLOTE",.F.),;     // 13.Sublote
                              CriaVar("D3_DTVALID",.F.),;     // 14.Data de Validade
                              CriaVar("D3_POTENCI",.F.),;     // 15.Potencia do Lote
                              999.999,;                                   // 16.Quantidade
                              CriaVar("D3_QTSEGUM",.F.),;     // 17.Quantidade na 2 UM                  
                              CriaVar("D3_ESTORNO",.F.),;     // 18.Estorno
                              CriaVar("D3_NUMSEQ",.F.),;          // 19.NumSeq
                              CriaVar("D3_LOTECTL",.F.),;                         // 20.Lote Destino
                              CriaVar("D3_DTVALID",.F.),;                         // 21 DATA VALIDADE
                              10109907001 })                         // 22 OP


 //    ENDIF // Fim da verificação      
 //  ENDIF // fim campo OK em branco
        TRB->(DBSKIP())
      // closebrowse()
ENDDO

                    
     MSExecAuto({|x,y| MATA261(x,y)},aArray,3) //Inclusao

          If lMsErroAuto
                         If lMsErroAuto
                              mostraerro()
                            DisarmTransaction()
                            break
               
                         EndIf
          Else
               Alert("Ok")
          Endif
   DBSELECTAREA("TRB")
Return 
        
#include "RWMAKE.CH"
#include "TBICONN.CH"

User Function Auto261()
     Local aItem := {}                   
     Private lMsErroAuto := .F.
     
     PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"
          
     Begin Transaction          
          aAdd(aItem, {"", ""})
          aAdd(aItem, {;
                                   "PRDAUTO        ",;                          
                                   "",;                                        
                                   "UN",;                                        
                                   "01",;                                   
                                   "",;                                        
                                   "PRDAUTO        ",;                              
                                   "",;
                                   "UN",;
                                   "02",;
                                   "",;
                                   "",;
                                   "",;
                                   "",;
                                   SToD(" / / "),;
                                   0,;
                                   1,;
                                   0,;
                                   "",;
                                   "",;
                                   "",;
                                   SToD(" / / ");
                                   })                                        
            
/*
D3_COD
D3_DESCRI
D3_UM
D3_LOCAL
D3_LOCALIZ
D3_COD
D3_DESCRI
D3_UM
D3_LOCAL
D3_LOCALIZ
D3_NUMSERI            
D3_LOTECTL
D3_NUMLOTE
D3_DTVALID
D3_POTENCI
D3_QUANT             
D3_QTSEGUM
D3_ESTORNO
D3_NUMSEQ                                   
D3_LOTECTL
D3_DTVALID
*/       
                                                  
          msExecAuto({|x,y| Mata261(x,y)}, aItem, 3)

          If lMsErroAuto
               lRet := .F.
               MostraErro()
               DisarmTransaction()
          Else
               Alert("OK")
          Endif

          SD3->(DbCloseArea()) 
End Transaction

Return           


User Function Tmata650()
Local aVetor := {}

lMsErroAuto := .F.

aVetor:={ {"C2_NUM","000001",NIL},; 
                     {"C2_ITEM","01",NIL},;
                     {"C2_SEQUEN","001",NIL},;
                     {"C2_PRODUTO",SB1->B1_COD,NIL},;
                     {"C2_QUANT",20,NIL},;
                     {"C2_DATPRI",ddatabase,NIL},;
                     {"C2_DATPRF",ddatabase,NIL}} 
/*                     
aadd(aVetor,{ {"C2_NUM","000002",NIL},; 
                     {"C2_ITEM","01",NIL},;
                     {"C2_SEQUEN","001",NIL},;
                     {"C2_PRODUTO",SB1->B1_COD,NIL},;
                     {"C2_QUANT",20,NIL},;
                     {"C2_DATPRI",ddatabase,NIL},;
                     {"C2_DATPRF",ddatabase,NIL}})
                     
*/                                          
MSExecAuto({|x,y| mata650(x,y)},aVetor,3) //Inclusao

/*
aVetor:={     {"C2_NUM","000001",NIL},; 
                    {"C2_QUANT",31,NIL},;
                    {"C2_DATPRF",ddatabase+2,NIL}}
MSExecAuto({|x,y| mata650(x,y)},aVetor,4) //Alteracao
*/
/*
aVetor:={ {"C2_NUM","000001",NIL}}
MSExecAuto({|x,y| mata650(x,y)},aVetor,5) //Exclusao
*/
If lMsErroAuto
     Alert("Erro")
Else
     Alert("Ok")
Endif
Return
