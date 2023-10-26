// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import "../VersionController.sol";

contract Remittance {
    address immutable FROM;
    address payable immutable TO;
    address internal immutable version;

    // 只有受益人可以提款
    modifier beneficiaryOnly() {
        require(msg.sender == TO, "Not beneficiary.");
        _;
    }

    modifier relevantOnly() {
        require(msg.sender == FROM || msg.sender == TO, "Not relevant.");
        _;
    }

    constructor(
        address _from,
        address _to,
        address _version
    ) payable {
        TO = payable(_to);
        FROM = _from;
        version = _version;
    }

    receive() external payable {}
    fallback() external payable{}

    function getValue() external view relevantOnly returns (uint) {
        return address(this).balance;
    }

    function withdraw(uint _v) external beneficiaryOnly {
        require(_v <= address(this).balance, "Insufficient balance.");
        TO.transfer(_v);
    }

    function checkVersion() external view returns (address) {
        return version;
    }
}

contract RemittanceFactory {
    Remittance remittance;
    address immutable VERSION = address(this); //这里是工厂的版本

    event logRemittance(
        Remittance indexed remittance,
        address indexed receiver
    );

    modifier participantsOnly(address _ds) {
        (bool success, bytes memory respond) = (_ds).call(
            abi.encodeWithSignature("checkParticipants(address)", msg.sender)
        );
        bool result = abi.decode(respond, (bool));
        require(result, "Not Participants");
        _;
    }

    function createRemittance(
        address _from,
        address _to,
        address _ds
    ) public payable participantsOnly(_ds) {
        remittance = new Remittance{value: msg.value}(_from, _to, VERSION);
        emit logRemittance(remittance, _to);
    }
}
