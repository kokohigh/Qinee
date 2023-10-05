//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
import "./StandardFunctionsSet/Remittance.sol";
import "./DataStorage.sol";

//The contract of country's central bank
contract CentralBank {
    address immutable Owner;

    constructor(address _addr){
        Owner = _addr;
    }

    modifier ownerOnly(){
        require(msg.sender == Owner,"Ownership is needed.");
        _;
    }

    function showOwner() external view returns(address){
        return Owner;
    }

    // function createLetterOfCredit(address _addr) external ownerOnly{
    //     WorldCentralBank(_addr).createLetterOfCredit();
    // }

    // function createCollection(address _addr) external ownerOnly{
    //     WorldCentralBank(_addr).createCollection();
        
    // }

    function createRemittance(address _rem, address _to) public payable ownerOnly{
        RemittanceFactor(_rem).createRemittance(_to);
        //_wcb.transfer(address(this).address);
    }


    // //我怀疑钱被卡在了这个合约， 用这个方法检查
    // //？？？
    // function getValue() external view returns(uint){
    //     return address(this).balance;
    // }
}

contract CentralBankFactory{
    CentralBank centralbank;
    DataStorage dataStorage;
    CentralBank[] centralbanks;
    constructor(address _ds){
        dataStorage = DataStorage(_ds);
    }
    event logCentralBank(CentralBank indexed centralbank, address indexed owner, uint timestamp);
    function creatCentralBank(address _owner) public {
        centralbank = new CentralBank(_owner);
        dataStorage.addCentralBank(centralbank);
        emit logCentralBank(centralbank, _owner, block.timestamp);
    }
}