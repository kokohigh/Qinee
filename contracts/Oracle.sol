// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

// 用于改变信用证的状态
// 这里只是模仿实际工作流程，实际会复杂的多
contract Oracle{
    // use call to change status
    event logChangeStatus(bool success, bytes data);
    function changeStatus(address _addr, bool _status, string memory _signature) public {
        (bool success, bytes memory data) = _addr.call(
            abi.encodeWithSignature(_signature, _status)
        );
    emit logChangeStatus(success, data);
    }
    
}