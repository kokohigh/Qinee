// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./DataStorage.sol";
import "./WorldCentralBank.sol";
import "./CentralBank.sol";
import "./BusinessAccount.sol";
import "./StandardFunctionsSet/Remittance.sol";
import "./StandardFunctionsSet/LetterOfCredit.sol";
import "./StandardFunctionsSet/Collection.sol";
import "./Vote.sol";

contract VersionController2 {
    string updateVersionEvent = "UPDATEVERSION";
    
    // 这些都是工厂
    mapping(string => address) versions;
    mapping(string => address payable) SFSVersions;

    address VC = address(this);

    // event logNoFactory(address ds, address WCB);
    // event logFactory(
    //     address CBF,
    //     address BAF,
    //     address RF,
    //     address LCF,
    //     address CF,
    //     address VF
    // );

    constructor(address[] memory _owners) {
        // 自动部署合约，并初始化版本
        versions["dataStorageVersion"] = deployDS(_owners);
        versions["WCBVersion"] = deployWCB();
        versions["CBVersion"] = deployCBFactory();
        versions["BAVersion"] = deployBAFactory();
        SFSVersions["remittanceVersion"] = payable(deployRemittanceFactory());
        SFSVersions["letterOfCreditVersion"] = payable(deployLOCFactory());
        SFSVersions["collectionVersion"] = payable(deployCollectionFactory());
        versions["voteVersion"] = deployVoteFactory();
        // 打印各被部署合约的地址
        // emit logNoFactory(dataStorageVersion, WCBVersion);
        // emit logFactory(
        //     CBVersion,
        //     BAVersion,
        //     remittanceVersion,
        //     letterOfCreditVersion,
        //     collectionVersion,
        //     voteVersion
        // );
    }

    modifier passOnly(
        string memory _name,
        address _newVersion,
        uint _amount,
        uint256 _start,
        uint256 _over,
        address _vote
    ) {
        {bytes32 name = keccak256(
            abi.encodePacked(_name, _newVersion, _amount, _start, _over)
        );
        (bool success, bytes memory respond) = _vote.call(
            abi.encodeWithSignature("getName()")
        );
        bytes32 name1 = abi.decode(respond, (bytes32));
        require(name == name1, "Not correspond vote.");}
        (bool success1, bytes memory respond1) = _vote.call(
            abi.encodeWithSignature("checkPass()")
        );
        bool result = abi.decode(respond1, (bool));
        require(result == true, "Vote did not pass.");
        _;
    }

    function deployDS(address[] memory _owners) private returns (address) {
        DataStorage ds = new DataStorage(_owners, versions["WCBVersion"]);
        return address(ds);
    }

    function deployWCB() private returns (address) {
        WorldCentralBank WCB = new WorldCentralBank(
            versions["dataStorageVersion"],
            VC
        );
        return address(WCB);
    }

    function deployCBFactory() private returns (address) {
        CentralBankFactory CBF = new CentralBankFactory(
            versions["dataStorageVersion"],
            versions["WCBVersion"],
            VC
        );
        return address(CBF);
    }

    function deployBAFactory() private returns (address) {
        BusinessAccountFactory BAF = new BusinessAccountFactory(
            versions["dataStorageVersion"],
            versions["WCBVersion"]
        );
        return address(BAF);
    }

    function deployRemittanceFactory() private returns (address) {
        RemittanceFactory RF = new RemittanceFactory(
            versions["dataStorageVersion"]
        );
        return payable(address(RF));
    }

    function deployLOCFactory() private returns (address) {
        LetterOfCreditFactory LCF = new LetterOfCreditFactory(
            versions["dataStorageVersion"]
        );
        return payable(address(LCF));
    }

    function deployCollectionFactory() private returns (address) {
        CollectionFactory CF = new CollectionFactory(
            versions["dataStorageVersion"]
        );
        return payable(address(CF));
    }

    function deployVoteFactory() private returns (address) {
        VoteFactory VF = new VoteFactory(
            versions["WCBVersion"],
            versions["dataStorageVersion"]
        );
        return address(VF);
    }

    //function addVersion(string memory _name, address _newVersion, address _vote) external passOnly(_vote){}

    function updateVersion(
        string memory _name,
        address _newVersion,
        address _vote,
        uint256 _start,
        uint256 _over
    )
        external
        passOnly(updateVersionEvent, _newVersion, 0, _start, _over, _vote)
    {
        versions[_name] = _newVersion;
    }

    function updateSFSVersion(
        string memory _name,
        address _newVersion,
        address _vote,
        uint256 _start,
        uint256 _over
    ) external 
      passOnly(updateVersionEvent, _newVersion, 0, _start, _over, _vote) 
    {
        SFSVersions[_name] = payable(_newVersion);
    }

    //function checkVersion(string memory _name) external view returns(address) {
    //     return versions[_name];
    // }

    function checkDS() external view returns (address) {
        return versions["dataStorageVersion"];
    }

    function checkWCB() external view returns (address) {
        return versions["WCBVersion"];
    }

    function checkCB() external view returns (address) {
        return versions["CBVersion"];
    }

    function checkBA() external view returns (address) {
        return versions["BAVersion"];
    }

    function checkRemittance() external view returns (address) {
        return SFSVersions["remittanceVersion"];
    }

    function checkLOC() external view returns (address) {
        return SFSVersions["letterOfCreditVersion"];
    }

    function checkCollection() external view returns (address) {
        return SFSVersions["collectionVersion"];
    }

    function checkVote() external view returns (address) {
        return versions["voteVersion"];
    }
}
