// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import "./Vote.sol";
import "./DataStorage.sol";
import "./WorldCentralBank.sol";
import "./CentralBank.sol";
import "./BusinessAccount.sol";
import "./StandardFunctionsSet/Remittance.sol";
import "./StandardFunctionsSet/LetterOfCredit.sol";
import "./StandardFunctionsSet/Collection.sol";

contract VersionController {
    address dataStorageVersion;
    address WCBVersion;

    // 这些都是工厂
    address internal CBVersion;
    address internal BAVersion;
    address internal remitanceVersion;
    address internal letterOfCreditVersion;
    address internal collectionVersion;
    address internal voteVersion;

    address VC = address(this);

    event logNoFactory(address ds, address WCB);
    event logFactory(
        address CBF,
        address BAF,
        address RF,
        address LCF,
        address CF,
        address VF
    );

    constructor(address[] memory _owners) {
        // 自动部署合约，并初始化版本
        dataStorageVersion = deployDS(_owners);
        WCBVersion = deployWCB();
        CBVersion = deployCBFactory();
        BAVersion = deployBAFactory();
        remitanceVersion = deployRemittanceFactory();
        letterOfCreditVersion = deployLOCFactory();
        collectionVersion = deployCollectionFactory();
        voteVersion = deployVoteFactory();
        // 打印各被部署合约的地址
        emit logNoFactory(dataStorageVersion, WCBVersion);
        emit logFactory(
            CBVersion,
            BAVersion,
            remitanceVersion,
            letterOfCreditVersion,
            collectionVersion,
            voteVersion
        );
    }

    function deployDS(address[] memory _owners) private returns (address) {
        DataStorage ds = new DataStorage(_owners, WCBVersion);
        return address(ds);
    }

    function deployWCB() private returns (address) {
        WorldCentralBank WCB = new WorldCentralBank(dataStorageVersion, VC);
        return address(WCB);
    }

    function deployCBFactory() private returns (address) {
        CentralBankFactory CBF = new CentralBankFactory(
            dataStorageVersion,
            WCBVersion,
            VC
        );
        return address(CBF);
    }

    function deployBAFactory() private returns (address) {
        BusinessAccountFactory BAF = new BusinessAccountFactory(
            dataStorageVersion,
            WCBVersion
        );
        return address(BAF);
    }

    function deployRemittanceFactory() private returns (address) {
        RemittanceFactory RF = new RemittanceFactory();
        return address(RF);
    }

    function deployLOCFactory() private returns (address) {
        LetterOfCreditFactory LCF = new LetterOfCreditFactory();
        return address(LCF);
    }

    function deployCollectionFactory() private returns (address) {
        CollectionFactory CF = new CollectionFactory();
        return address(CF);
    }

    function deployVoteFactory() private returns (address) {
        VoteFactory VF = new VoteFactory(WCBVersion);
        return address(VF);
    }

    function addVersion() external {}

    function updateVersion() external {}

    function checkDS() external view returns (address) {
        return dataStorageVersion;
    }

    function checkWCB() external view returns (address) {
        return WCBVersion;
    }

    function checkCB() external view returns (address) {
        return CBVersion;
    }

    function checkBA() external view returns (address) {
        return BAVersion;
    }

    function checkRemittance() external view returns (address) {
        return remitanceVersion;
    }

    function checkLOC() external view returns (address) {
        return letterOfCreditVersion;
    }

    function checkCollection() external view returns (address) {
        return collectionVersion;
    }

    function checkVote() external view returns (address) {
        return voteVersion;
    }
    
}
