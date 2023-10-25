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

contract VersionContraller{
    
    address dataStorageVersion;
    address WCBVersion;

    // 这些都是工厂
    address internal CBVersion;
    address internal BAVersion;
    address internal remitanceVersion;
    address internal letterOfCreditVersion;
    address internal collectionVersion;
    address internal voteVersion;

    constructor(address[] memory _owners){      
        dataStorageVersion = deployDS(_owners);
        WCBVersion = deployWCB();
        CBVersion = deployCBFactor();
        BAVersion = deployBAFactor();
        remitanceVersion = deployRemittanceFactor();
        letterOfCreditVersion = deployLOCFactor();
        collectionVersion = deployCollectionFactor();
        voteVersion = deployVoteFactor();
        
    }



    function deployDS(address[] memory _owners) private returns (address){
        DataStorage ds = new DataStorage(_owners);
        return address(ds);

    }

    function deployWCB() private returns (address){
        WorldCentralBank WCB = new WorldCentralBank(dataStorageVersion);
        return address(WCB);
    }

    function deployCBFactor() private returns (address){
        CentralBankFactory CBF = new CentralBankFactory(dataStorageVersion, WCBVersion);
        return address(CBF);
    }

    function deployBAFactor() private returns (address){
        BusinessAccountFactory BAF = new BusinessAccountFactory(dataStorageVersion, WCBVersion);
        return address(BAF);
    }

    function deployRemittanceFactor() private returns (address){
        RemittanceFactor RF = new RemittanceFactor();
        return address(RF);
    }

    function deployLOCFactor() private returns (address){
        LetterOfCreditFactor LCF = new LetterOfCreditFactor();
        return address(LCF);
    }

    function deployCollectionFactor() private returns (address){
        CollectionFactor CF = new CollectionFactor();
        return address(CF);
    }

    function deployVoteFactor() private returns (address){
        VoteFactor VF = new VoteFactor(WCBVersion);
        return address(VF);
    }

    function addVersion() external {

    }

    function updateVersion() external {

    }
}