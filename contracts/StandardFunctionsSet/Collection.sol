// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

//先发货，条件自然成立
//托收是出口商（债权人）为向国外进口商（债务人）收取货款，开具汇票委托出口地银行通过其在进口地银行的联行或代理行向进口商收款的结算方式。
//其基本做法是出口方先行发货，然后备妥包括运输单据（通常是海运提单）在内的货运单据并开出汇票，
//把全套跟单汇票交出口地银行（托收行），委托其通过进口地的分行或代理行（代收行）向进口方收取货款。
//托收按是否附带货运单据分为光票托收和跟单托收两种。
contract Collection {
    address payable owner;
    address importer;
    uint amount;
    address immutable VERSION;

    //bool condition;
    constructor(
        address _ex,
        address _im,
        uint _amount,
        address _version
    ) {
        owner = payable(_ex);
        importer = _im;
        amount = _amount;
        VERSION = _version;
    }

    modifier checkAmount() {
        require(msg.value == amount, "Error: transfer amount is wrong.");
        _;
    }

    modifier importerOnly() {
        require(msg.sender == importer, "Error: You are not the importer.");
        _;
    }

    modifier ownerOnly() {
        require(msg.sender == owner, "You are not the Owner.");
        _;
    }

    modifier relevantOnly() {
        require(msg.sender == owner || msg.sender == importer, "You are not relevant person.");
        _;
    }

    //向合约付款
    receive() external payable checkAmount importerOnly {}

    function getValue() external view relevantOnly returns (uint) {
        return address(this).balance;
    }

    function getAmount() external view relevantOnly returns(uint){
        return amount;
    }

    function withdraw(uint _v) external ownerOnly{
        require(_v <= address(this).balance, "Insufficient balance.");
        owner.transfer(_v);
    }

    function checkVersion() view external returns(address) {
        return VERSION;
    }
}

contract CollectionFactory {
    Collection collection;
    address immutable VERSION = address(this); //工厂版本

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
        collection = new Collection(_ex, _im, _amount, VERSION);
        emit logCollection(collection, _ex, _im, _amount);
    }
}