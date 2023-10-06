// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Remittance {
    address payable TO;

    constructor(address _to) payable {
        TO = payable(_to);
    }

    receive() external payable {}

    function getValue() external view returns (uint) {
        return address(this).balance;
    }

    function withdraw(uint _v) external {
        require(_v <= address(this).balance, "Insufficient balance.");
        TO.transfer(_v);
    }
}

//托收是出口商（债权人）为向国外进口商（债务人）收取货款，开具汇票委托出口地银行通过其在进口地银行的联行或代理行向进口商收款的结算方式。
//其基本做法是出口方先行发货，然后备妥包括运输单据（通常是海运提单）在内的货运单据并开出汇票，
//把全套跟单汇票交出口地银行（托收行），委托其通过进口地的分行或代理行（代收行）向进口方收取货款。
//托收按是否附带货运单据分为光票托收和跟单托收两种。
contract Collection {
    address payable owner;
    address importer;
    uint amount;

    //bool condition;
    constructor(
        address _ex,
        address _im,
        uint _amount
    ) {
        owner = payable(_ex);
        importer = _im;
        amount = _amount;
    }

    modifier checkAmount() {
        require(msg.value == amount, "Error: transfer amount is wrong.");
        _;
    }

    modifier importerOnly() {
        require(msg.sender == importer, "Error: You are not the importer.");
        _;
    }

    //向合约付款
    receive() external payable checkAmount importerOnly {}

    function getValue() external view returns (uint) {
        return address(this).balance;
    }

    function withdraw(uint _v) external {
        require(_v <= address(this).balance, "Insufficient balance.");
        owner.transfer(_v);
    }
}

//信用证是银行（即开证行）依照进口商（即开证申请人）的要求和指示，对出口商（即受益人）发出的、
//授权进口商签发以银行或进口商为付款人的汇票，保证在将来符合信用证条款规定的汇票和单据时，必定承兑和付款的保证文件。
contract LetterOfCredit {
    bool condition;
    address owner;
    address payable exporter;

    constructor(address _ex, address _im) payable {
        owner = _im;
        exporter = payable(_ex);
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

    receive() external payable {}

    function setCondition(bool _finished) public {
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

contract RemittanceFactor {
    Remittance remittance;
    event logRemittance(
        Remittance indexed remittance,
        address indexed receiver
    );

    function createRemittance(address _to) public payable {
        remittance = new Remittance{value: msg.value}(_to);
        emit logRemittance(remittance, _to);
    }
}

contract CollectionFactor {
    Collection collection;
    event logCollection(
        Collection indexed collection,
        address owner,
        address importer,
        uint amount
    );

    function createCollection(
        address _ex,
        address _im,
        uint _amount
    ) public payable {
        collection = new Collection(_ex, _im, _amount);
        emit logCollection(collection, _ex, _im, _amount);
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

    function createLetterOfCredit(address _ex, address _im) public payable {
        letterOfCredit = new LetterOfCredit{value: msg.value}(_ex, _im);
        emit logLetterOfFactor(letterOfCredit, _ex, _im, msg.value);
    }
}
