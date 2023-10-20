// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
// import "./Vote.sol";

// //通过代理调用的方式将 投票功能和管理Owner的功能结合
// contract OwnerOperator{  
//     address userAddr;
//     address[] internal owners;
//     Vote vote;

//     constructor(address _v, address _user){
//         vote = Vote(_v);
//         userAddr=_user;
//     }

//     modifier passOnly(){
//         require(vote.checkPass(),"Not pass.");
//         _;
//     }

//     function addOwner(address _addr) external {
//         owners.push(_addr);
//     }

//     function deleteOwner() external {
        
//     }
// }