// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract RemittanceFactor{
    Remittance remittance;
    event logRemittance(Remittance indexed remittance, address indexed receiver);
    
    function createRemittance(address _to) public payable{
        remittance = new Remittance{value:msg.value}(_to);
        emit logRemittance(remittance, _to);
    }
}

contract Remittance{

    address payable TO;

    constructor(address _to) payable{

        TO = payable(_to);
    }

    receive() external payable{}

    function getValue() external view returns(uint){
        return address(this).balance;
    }

    function withdraw(uint _v) external {
        require(_v <= address(this).balance,"Insufficient balance.");
        TO.transfer(_v);
    }

}