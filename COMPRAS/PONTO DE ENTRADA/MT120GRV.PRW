//+-----------------------------------------------------------------------------------//
//|Descricao.: PE para validação na gravação do Pedido
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
User Function MT120GRV()
*-----------------------------------------*
Local lRet := .T.
//Marcio Macedo 15/12/2020 Envio de email quando alterarem o pedido de compra
if lRet .And. PARAMIXB[3] // parametro de alteracao
     u_WFE85()
Endif

Return(lRet) 

