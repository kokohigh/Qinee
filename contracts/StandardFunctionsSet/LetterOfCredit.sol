// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

//先开信用证，见证发货，符合条件时付款
//信用证是银行（即开证行）依照进口商（即开证申请人）的要求和指示，对出口商（即受益人）发出的、
//授权进口商签发以银行或进口商为付款人的汇票，保证在将来符合信用证条款规定的汇票和单据时，必定承兑和付款的保证文件。
contract LetterOfCredit {
    bool condition;
    address owner;
    address payable exporter;
    address oracle;

    constructor(address _ex, address _im, address _oracle) payable {
        owner = _im;
        exporter = payable(_ex);
        oracle = _oracle;
    }

    modifier beneficiaryOnly() {
        require(msg.sender == exporter, "Error: You are not the beneficiary.");
        _;
    }

    modifier finishedOnly() {
        require(
            condition == true,
            "Error: The transaction has not finished yet."
        );
        _;
    }

    modifier oracleOnly(){
        require(msg.sender == oracle, "No permission to change status");
        _;
    }

    receive() external payable {}

    function setCondition(bool _finished) public oracleOnly{
        condition = _finished;
    }

    function getValue() external view returns (uint) {
        return address(this).balance;
    }

    function withdraw(uint _v) external beneficiaryOnly finishedOnly {
        require(_v <= address(this).balance, "Insufficient balance.");
        exporter.transfer(_v);
    }
}

contract LetterOfCreditFactor {
    LetterOfCredit letterOfCredit;
    event logLetterOfFactor(
        LetterOfCredit indexed letterOfCredit,
        address _ex,
        address _im,
        uint amount
    );

    function createLetterOfCredit(address _ex, address _im, address _oracle) public payable {
        letterOfCredit = new LetterOfCredit{value: msg.value}(_ex, _im, _oracle);
        emit logLetterOfFactor(letterOfCredit, _ex, _im, msg.value);
    }
}