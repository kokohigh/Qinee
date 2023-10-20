// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
// import "../CentralBank.sol";


// //The contract of WCB
// contract WorldCentralBank{

//     mapping(address => bool) members;
//     event logCentralBank(CentralBank);
//     event logLetterofcredit(LetterOfCredit);
//     event logCollection(Collection);
//     event logRemittance(Remittance);



//     modifier membersOnly(){
//         require(members[msg.sender] == true, "Menbership is needed.");
//         _;
//     }

//     function createCentralBank() external {
//         require(members[msg.sender] == false, "Already existed.");
//         CentralBank cb = new CentralBank(msg.sender);
//         members[msg.sender] = true;
//         emit logCentralBank(cb);


//     }
    

//     // function createLetterOfCredit() external {
//     //     LetterOfCredit loc = new LetterOfCredit();
//     // }

//     function createCollection() external{
//         Collection ct = new Collection();
//         emit logCollection(ct);
//     }

//     function createRemittance(address _to) external payable{
//         Remittance rt = new Remittance(_to);
//         emit logRemittance(rt);

//     }
// }



// //The contract of country's central bank
// contract CentralBank2 {
//     address Owner;

//     constructor(address _addr){
//         Owner = _addr;
//     }

//     modifier ownerOnly(){
//         require(msg.sender == Owner,"Ownership is needed.");
//         _;
//     }

//     function showOwner() external view returns(address){
//         return Owner;
//     }

//     // function createLetterOfCredit(address _addr) external ownerOnly{
//     //     WorldCentralBank(_addr).createLetterOfCredit();
//     // }

//     function createCollection(address _addr) external ownerOnly{
//         WorldCentralBank(_addr).createCollection();
        
//     }

//     function createRemittance(address _wcb, address _to) external payable ownerOnly{
//         WorldCentralBank(_wcb).createRemittance(_to);
//         //_wcb.transfer(address(this).address);
//     }


//     //我怀疑钱被卡在了这个合约， 用这个方法检查
//     //？？？
//     function getValue() external view returns(uint){
//         return address(this).balance;
//     }
// }


// //The contract of LoC
// contract LetterOfCredit2{

//     address IMPORTER;
//     address EXPORTER;

//     constructor(){

//     }

//     function LoC() external pure returns(uint){
//         return 0;
//     }
// }

// // The contract of Collection
// contract Collection2{

//     address IMPORTER;
//     address EXPORTER;

//     constructor(){
        
//     }

//     modifier exporterOnly(){
//         require(msg.sender == EXPORTER, "Permission Denied.");
//         _;
//     }

//     function collection() external pure returns(uint){
//         return 0;

//     }
// }

// // The contract of Remittance
// contract Remittance2{

//     address payable TO;

//     constructor(address _to) payable{

//         TO = payable(_to);
//     }

//     receive() external payable{}

//     function getValue() external view returns(uint){
//         return address(this).balance;
//     }

//     function withdraw(uint _v) external {
//         require(_v <= address(this).balance,"Insufficient balance.");
//         TO.transfer(_v);
//     }

// }