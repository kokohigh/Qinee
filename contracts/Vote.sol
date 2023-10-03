// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import "./Storage.sol";

contract EventVote is Storage{
    // mapping(bytes32 => mapping(address => bool)) eventVotes;
    function vote(string memory _eventName) internal {
        bytes32 name = keccak256(abi.encodePacked(_eventName));
        eventVotes[name][msg.sender] = true;
    }

    function revocation(string memory _eventName) internal{
        bytes32 name = keccak256(abi.encodePacked(_eventName));
        eventVotes[name][msg.sender] = false;
    }

    function checkPass(string memory _eventName) internal view returns(bool result){
        bytes32 name = keccak256(abi.encodePacked(_eventName));
        uint approval = 0;
        for (uint i =0; i<participants.length; i++){
            if (eventVotes[name][participants[i]] == true){
                approval += 1;
            }
        }
        if (approval > participants.length/2){
            return true;
        }else{
            return false;
        }
    }

    function checkVote(string memory _eventName) internal view returns(bool){
        bytes32 name = keccak256(abi.encodePacked(_eventName));
        return eventVotes[name][msg.sender];
    }


}