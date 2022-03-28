// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.13;

//Acuerdo de retirada de dinero con plazos de tiempo estipulado.
contract DeedMultipayout{
    //Dirección del abogado
    address public lawyer;
    //Dirección del beneficiario
    address payable public beneficiary;
    //Tiempo  estipulado
    uint public earliest;
    //Cantidad de dinero
    uint public amount;
    //Numero de pagos
    uint constant public PAYOUTS = 10;
    //Intervalo de pagos ("como mensualidades") puesto en segundos.
    uint constant public INTERVAL= 10;
    //Pagos ya pagados
    uint public paidPayouts;
    //Constructor del smart contract
    constructor(address _lawyer, address payable _beneficiary, uint fromNow)payable{
        lawyer = _lawyer;
        beneficiary= _beneficiary;
        earliest = block.timestamp + fromNow;
        amount = msg.value / PAYOUTS;
    }
    //Función para retirar el dinero dividido en varios pagos "10" e intervalos de tiempo "10s"
    function withdraw() public{
        require(msg.sender==beneficiary,"beneficiary only");
        require(block.timestamp>=earliest,"too early");
        require(paidPayouts<PAYOUTS, "No payouts left");
        uint elligiblePayouts = (block.timestamp - earliest) / INTERVAL;
        uint duePayouts = elligiblePayouts - paidPayouts;
        duePayouts = duePayouts + paidPayouts > PAYOUTS ? PAYOUTS - paidPayouts : duePayouts;
        paidPayouts += duePayouts;
        beneficiary.transfer(duePayouts*amount);
    }
}