#include "TOTVS.CH"
#include "Protheus.ch"
#include "topconn.ch"
#include 'dbtree.ch'

User Function nsbTree()          

local aStru := PEstru("HP1081001N0CE04")

  DEFINE DIALOG oDlg TITLE "Exemplo de DBTree" FROM 180,180 TO 550,700 PIXEL

    // Cria a Tree
    oTree := DbTree():New(0,0,160,260,oDlg,,,.T.)
    
  ACTIVATE DIALOG oDlg CENTERED 

  //Aadd(aStru, { TQRY->COD_PROD, COD_COMPONENTE, G1_COMP, COMPONENTE, NIVEL})  
  For i := 1 To Len(aStru)
    oTree:AddItem(aStru[i][3]+" - "+aStru[i][4],StrZero(i,3), "FOLDER5" ,,,,1)
  NEXT

  // Indica o término da contrução da Tree
  oTree:EndTree()

/*
  DEFINE DIALOG oDlg TITLE "Exemplo de DBTree" FROM 180,180 TO 550,700 PIXEL
	
    // Cria a Tree
    oTree := DbTree():New(0,0,160,260,oDlg,,,.T.)
		
  
    // Insere itens
    oTree:AddItem("Primeiro nível da DBTree","001", "FOLDER5" ,,,,1)
    If oTree:TreeSeek("001")
      oTree:AddItem("Segundo nível da DBTree","002", "FOLDER10",,,,2)	
      If oTree:TreeSeek("002") 
        oTree:AddItem("Subnível 01","003", "FOLDER6",,,,2)	
        oTree:AddItem("Subnível 02","004", "FOLDER6",,,,2)	 
        oTree:AddItem("Subnível 03","005", "FOLDER6",,,,2)	
      endif
    endif                     
    oTree:TreeSeek("001") // Retorna ao primeiro nível
    
    // Cria botões com métodos básicos
    TButton():New( 160, 002, "Seek Item 4", oDlg,{|| oTree:TreeSeek("004")};
       ,40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 160, 052, "Enable"	, oDlg,{|| oTree:SetEnable() };
       ,40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 160, 102, "Disable"	, oDlg,{|| oTree:SetDisable() };
       ,40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 160, 152, "Novo Item", oDlg,{|| TreeNewIt() };
       ,40,010,,,.F.,.T.,.F.,,.F.,,,.F. )

    TButton():New( 172,02,"Dados do item", oDlg,{|| ;
         Alert("Cargo: "+oTree:GetCargo()+chr(13)+"Texto: "+oTree:GetPrompt(.T.)) },;
		 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 172, 052, "Muda Texto", oDlg,{|| ;
         oTree:ChangePrompt("Novo Texto Item 001","001") },;
         40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 172, 102, "Muda Imagem", oDlg,{||;
         oTree:ChangeBmp("LBNO","LBTIK",,,"001") },;
         40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 172, 152, "Apaga Item", oDlg,{|| ;
         if(oTree:TreeSeek("006"),oTree:DelItem(),) },;
         40,010,,,.F.,.T.,.F.,,.F.,,,.F. )

    // Indica o término da contrução da Tree
    oTree:EndTree()

  ACTIVATE DIALOG oDlg CENTERED 
Return                                             
*/

//----------------------------------------
// Função auxiliar para inserção de item
//----------------------------------------
Static Function TreeNewIt()
  // Cria novo item na Tree
  oTree:AddTreeItem("Novo Item","FOLDER7",,"006")
  if oTree:TreeSeek("006") 
    oTree:AddItem("Sub-nivel 01","007", "FOLDER6",,,,2)	
    oTree:AddItem("Sub-nivel 02","008", "FOLDER6",,,,2)	
  endif
Return

//--Funcao para retornar a estrutura do produto.
Static Function PEstru(cProd)
local cQry:=""
local aStru :={}

cQry:="  WITH FILHOS  AS ( "
cQry+="	  SELECT SG.G1_COD AS COD_PROD,  "
cQry+="			 B1P.B1_GRUPO AS GRUPO_PAI, B1P.B1_TIPO AS TIPO, SB.B1_COD AS COD_COMPONENTE, "
cQry+="			 SB.B1_DESC AS COMPONENTE, SG.G1_COMP AS G1_COMP, SB.B1_GRUPO AS GRUPO_COMP, SB.B1_TIPO AS TIPO_COMP, SG.G1_QUANT AS QUANTIDADE, "
cQry+="			 2 AS NIVEL "
cQry+="	   FROM SG1010 (NOLOCK)SG INNER JOIN SB1010 (NOLOCK)SB  ON SB.B1_FILIAL=SG.G1_FILIAL AND SB.B1_COD=SG.G1_COMP "
cQry+="							  INNER JOIN SB1010 (NOLOCK)B1P ON B1P.B1_FILIAL=SG.G1_FILIAL AND B1P.B1_COD=SG.G1_COD "
cQry+="	   WHERE  SG.D_E_L_E_T_=' ' AND SB.D_E_L_E_T_=' ' AND B1P.D_E_L_E_T_=' '  "
cQry+="	   AND SG.G1_FIM > '20190430'   "
cQry+="	   GROUP BY SG.G1_COD, B1P.B1_DESC, B1P.B1_GRUPO, B1P.B1_TIPO, SB.B1_COD, SB.B1_DESC, SG.G1_COMP, SB.B1_GRUPO, SB.B1_TIPO, SG.G1_QUANT "
   
cQry+="    UNION ALL "

cQry+="		SELECT T2.COD_PROD,  "
cQry+="			   B1P.B1_GRUPO AS GRUPO_PAI, B1P.B1_TIPO  AS TIPO, X.G1_COD  AS COD_COMPONENTE, SB.B1_DESC AS COMPONENTE, "
cQry+="			   X.G1_COMP, SB.B1_GRUPO AS GRUPO_COMP, SB.B1_TIPO  AS TIPO_COMP, X.G1_QUANT AS QUANTIDADE, "
cQry+="			   NIVEL + 1 "
cQry+="		FROM SG1010 (NOLOCK)X INNER JOIN [FILHOS] T2 ON T2.G1_COMP=X.G1_COD  "
cQry+="							  INNER JOIN SB1010 (NOLOCK)SB ON SB.B1_FILIAL=X.G1_FILIAL AND SB.B1_COD=X.G1_COMP "
cQry+="							  INNER JOIN SB1010 (NOLOCK)B1P ON B1P.B1_COD=X.G1_COD "
cQry+="		WHERE X.D_E_L_E_T_=' ' AND B1P.D_E_L_E_T_=' '  "
cQry+="		AND X.G1_FIM > '20190430' "
cQry+=") 

cQry+="SELECT FILHOS.*,S.B1_UM AS UM_COMP --INTO ESTRUTURA "
cQry+="FROM FILHOS INNER JOIN SB1010 (NOLOCK)S ON FILHOS.G1_COMP=S.B1_COD  "
cQry+="WHERE S.D_E_L_E_T_ = ''  "
cQry+="   AND S.B1_UM <> ' '  "
cQry+="   AND S.B1_TIPO IN ('PI','PA') "
cQry+="   AND COD_PROD IN(  '"+ cProd+"'  ) "

cQry+="ORDER BY COD_PROD, COD_COMPONENTE, TIPO "

TCQUERY cQry NEW ALIAS TQRY
		
	While TQRY->(!EOF())
		//IncProc()
		//Aadd(aCampos, { TQRY->Z0_CC,Posicione("CTT",1,xFilial("CTT")+TQRY->Z0_CC,"CTT_DESC01"),TQRY->Z0_LOCAL,TQRY->FICHAS,TQRY->PRICON,PadL( AllTrim( Transform( (TQRY->PRICON / TQRY->FICHAS) * 100, "@E 999.99")) + "%", 07),TQRY->SEGCON,PadL( AllTrim( Transform( (TQRY->SEGCON / TQRY->FICHAS) * 100, "@E 999.99")) + "%", 07),TQRY->TERCON,PadL( AllTrim( Transform( (TQRY->TERCON / TQRY->FICHAS) * 100, "@E 999.99")) + "%", 07),PadL( AllTrim( Transform( (TQRY->TERCON / TQRY->FICHAS) * 100, "@E 999.99")) + "%", 07)})
		Aadd(aStru, { TQRY->COD_PROD, TQRY->CCOD_COMPONENTE, TQRY->CG1_COMP, TQRY->CCOMPONENTE, TQRY->CNIVEL})
    TQRY->(dbskip())
	End

	TQRY->(dbCloseArea())

return aStru
