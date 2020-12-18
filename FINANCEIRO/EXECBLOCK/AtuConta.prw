#Include 'Protheus.ch'
#INCLUDE "rwmake.ch"
#Include 'Topconn.ch'

User Function AtuConta() 
Local posSep := 0;

	if (M->E2_LD == 'N')
		SE2->(dbSetOrder(1))
		SA2->(dbSeek(xFilial("SA2")+M->E2_FORNECE+E2_LOJA))
		M->E2_NBANCO   := SA2->A2_BANCO
		M->E2_NAGENCIA := PADR(SUBSTR(SA2->A2_AGENCIA,1,4),5)
		M->E2_NDVAGEN  := PADR(SUBSTR(SA2->A2_AGENCIA,5,1),1)
		posSep := AT("-",SA2->A2_NUMCON)
		if(posSep >0 )
			M->E2_NCONTA   := PADR(SUBSTR(SA2->A2_NUMCON,1,posSep-1),10)
			M->E2_NDVCC    := PADR(SUBSTR(SA2->A2_NUMCON,posSep+1,len(SA2->A2_NUMCON)),2)
		Else
			M->E2_NCONTA   := PADR(SA2->A2_NUMCON,10)
			M->E2_NDVCC    := SPACE(2)
		Endif		
	Else
		M->E2_NBANCO   := ""
		M->E2_NAGENCIA := ""
		M->E2_NDVAGEN  := ""
		M->E2_NCONTA   := ""
		M->E2_NDCONTA  := ""
		M->E2_NDVCC    := ""
	Endif
	     
Return M->E2_LD
