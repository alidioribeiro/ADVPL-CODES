#INCLUDE "URZUM.CH"

/*/{Protheus.doc} MT235G2
Ponto de entrada de validacao antes de executar a eliminacao de residuo
@author tiago.leao
@since 26/03/2018
@version 1.0
@return ${return}, ${return_description}
@type function
/*/
User function MT235G2()

	Local lRet := U_UzxPCBrow("RES",PARAMIXB)

Return(lRet)