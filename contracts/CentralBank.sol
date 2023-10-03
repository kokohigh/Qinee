//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
import "./WorldCentralBank.sol";

//The contract of country's central bank
contract CentralBank2 {
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

    function createCollection(address _addr) external ownerOnly{
        WorldCentralBank(_addr).createCollection();
        
    }

    function createRemittance(address _wcb, address _to) external payable ownerOnly{
        WorldCentralBank(_wcb).createRemittance(_to);
        //_wcb.transfer(address(this).address);
    }


    //我怀疑钱被卡在了这个合约， 用这个方法检查
    //？？？
    function getValue() external view returns(uint){
        return address(this).balance;
    }
}