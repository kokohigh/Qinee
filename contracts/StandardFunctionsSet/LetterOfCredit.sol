// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

//先开信用证，见证发货，符合条件时付款
//信用证是银行（即开证行）依照进口商（即开证申请人）的要求和指示，对出口商（即受益人）发出的、
//授权进口商签发以银行或进口商为付款人的汇票，保证在将来符合信用证条款规定的汇票和单据时，必定承兑和付款的保证文件。
contract LetterOfCredit {
    uint256 deadline;
    bool condition;
    address payable immutable owner;
    address payable immutable exporter;
    address oracle;
    address immutable VERSION;

    constructor(
        address _ex,
        address _im,
        address _oracle,
        uint _ddl,
        address _version
    ) payable {
        owner = payable(_im);
        exporter = payable(_ex);
        oracle = _oracle;
        deadline = _ddl;
        VERSION = _version;
    }

    modifier beneficiaryOnly() {
        require(msg.sender == exporter, "Error: You are not the beneficiary.");
        _;
    }

    modifier ownerOnly(){
        require(msg.sender == owner, "No Permission");
        _;
    }

    modifier relevantOnly(){
        require(msg.sender == exporter || msg.sender == owner, "Not relevant person.");
        _;
    }

    modifier finishedOnly() {
        require(
            condition == true,
            "Error: The transaction has not finished yet."
        );
        _;
    }

    modifier unfinishOnly() {
        require((block.timestamp > deadline) && (condition == false), "Transaction is pedding");
        _;
    }

    modifier oracleOnly() {
        require(msg.sender == oracle, "No permission to change status");
        _;
    }

    receive() external payable {}

    // Oracle用于改变交易状态
    function setCondition(bool _finished) public oracleOnly {
        condition = _finished;
    }

    // 延长DDL
    function extendDeadline(uint256 _newTime) external ownerOnly{
        require(msg.sender == owner, "No permission.");
        require(_newTime > deadline, "Cannot shorten time.");
        deadline = _newTime;
    }

    // 达成条件时，出口商提款
    function withdraw() external beneficiaryOnly finishedOnly {
        //require(_v <= address(this).balance, "Insufficient balance.");
        exporter.transfer(address(this).balance);
    }

    //交易失败时，退款给进口商
    function cancel() external ownerOnly unfinishOnly{
        owner.transfer(address(this).balance);
    }

    //查看合约中的代币数量
    function getValue() external view relevantOnly returns (uint) {
        return address(this).balance;
    }

    function checkVersion() external view returns (address) {
        return VERSION;
    }

    function checkDeadline() external view relevantOnly returns (uint) {
        return deadline;
    }
}

contract LetterOfCreditFactory {
    LetterOfCredit letterOfCredit;
    address immutable VERSION = address(this); //工厂版本
    address DS;

    event logLetterOfFactory(
        LetterOfCredit indexed letterOfCredit,
        address _ex,
        address _im,
        uint amount
    );

    modifier participantsOnly() {
        (bool success, bytes memory respond) = (DS).call(
            abi.encodeWithSignature("checkParticipants(address)", msg.sender)
        );
        bool result = abi.decode(respond, (bool));
        require(result, "Not Participants");
        _;
    }

    constructor(address _ds) {
        DS = _ds;
    }

    function createLetterOfCredit(
        address _ex,
        address _im,
        address _oracle,
        uint _ddl
    ) public payable participantsOnly{
        letterOfCredit = new LetterOfCredit{value: msg.value}(
            _ex,
            _im,
            _oracle,
            _ddl,
            VERSION
        );
        emit logLetterOfFactory(letterOfCredit, _ex, _im, msg.value);
    }
}
