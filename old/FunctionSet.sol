//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

// //The contract of LoC
// contract LetterOfCredit{

//     address IMPORTER;
//     address EXPORTER;

//     constructor(){

//     }

//     function LoC() external pure returns(uint){
//         return 0;
//     }
// }

// // The contract of Collection
// contract Collection{

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
// contract Remittance{

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