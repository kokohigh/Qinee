// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Remittance {
    address immutable FROM;
    address payable TO;
    address immutable internal version;

    // 只有受益人可以提款
    modifier beneficiaryOnly(){
        require(msg.sender == TO, "Not beneficiary.");
        _;
    }

    modifier relevantOnly(){
        require(msg.sender == FROM|| msg.sender == TO, "Not relevant.");
        _;
    }

    constructor(address _to, address _version) payable {
        TO = payable(_to);
        FROM = msg.sender;
        version = _version;
    }

    receive() external payable {}

    function getValue() external view returns (uint) {
        return address(this).balance;
    }

    function withdraw(uint _v) external beneficiaryOnly{
        require(_v <= address(this).balance, "Insufficient balance.");
        TO.transfer(_v);
    }

    function checkVersion() external view returns(address) {
        return version;
    }
}

contract RemittanceFactor {
    Remittance remittance;
    address immutable VERSION = address(this); //这里是工厂的版本

    event logRemittance(
        Remittance indexed remittance,
        address indexed receiver
    );

    function createRemittance(address _to) public payable {
        remittance = new Remittance{value: msg.value}(_to, VERSION);
        emit logRemittance(remittance, _to);
    }
}
