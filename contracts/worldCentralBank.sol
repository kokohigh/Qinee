// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import "./DataStorage.sol";
import "./CentralBank.sol";
import "./BusinessAccount.sol";
import "./Vote.sol";

//The contract of WCB
contract WorldCentralBank {
    uint constant ZERO = 0;
    string constant ADDOWNER = "ADDOWNER";
    string constant ADDMEMBER = "ADDMEMBER";

    // 数据储存
    DataStorage dataStorage;
    address VC;

    constructor(address _ds, address _vc) {
        dataStorage = DataStorage(_ds);
        VC = _vc;
    }

    modifier ownerOnly() {
        require(dataStorage.checkOwner(msg.sender), "Ownership is needed.");
        _;
    }

    modifier membersOnly() {
        require(dataStorage.checkMember(msg.sender), "Menbership is needed.");
        _;
    }

    modifier newCBFactoryOnly(address _CBFactory) {
        (bool success, bytes memory respond) = VC.call(
            abi.encodeWithSignature("checkCB()")
        );
        address CB = abi.decode(respond, (address));
        require(CB == _CBFactory, "Version deny.");
        _;
    }

    modifier newBAFactoryOnly(address _BAFactory) {
        (bool success, bytes memory respond) = VC.call(
            abi.encodeWithSignature("checkBA()")
        );
        address BA = abi.decode(respond, (address));
        require(BA == _BAFactory, "Version deny.");
        _;
    }

    modifier newVoteFactoryOnly(address _voteFactory) {
        (bool success, bytes memory respond) = VC.call(
            abi.encodeWithSignature("checkVote()")
        );
        address voteFactory = abi.decode(respond, (address));
        require(voteFactory == _voteFactory, "Version deny.");
        _;
    }

    modifier passOnly(
        address _vote,
        string memory _name,
        address _addr,
        uint _amount,
        uint _start,
        uint _over
    ) {
        Vote vote = Vote(_vote);
        require(
            vote.getName() ==
                keccak256(
                    abi.encodePacked(_name, _addr, _amount, _start, _over)
                ),
            "Not this proposal."
        );
        require(vote.checkPass(), "Not pass.");
        _;
    }

    modifier noInstanceOnly(address _uaddr) {
        (
            dataStorage.checkHasCB(_uaddr) == address(0) &&
                dataStorage.checkHasBA(_uaddr) == address(0),
            "Already has instance."
        );
        _;
    }

    function addOwner(
        address _uaddr,
        address _vote,
        uint _start,
        uint _over
    )
        external
        ownerOnly
        passOnly(_vote, ADDOWNER, _uaddr, ZERO, _start, _over)
    {
        dataStorage.addOwner(_uaddr);
    }

    function addMember(
        address _uaddr,
        address _vote,
        uint _start,
        uint _over
    )
        external
        ownerOnly
        passOnly(_vote, ADDMEMBER, _uaddr, ZERO, _start, _over)
    {
        dataStorage.addMember(_uaddr);
    }

    function checkSender() external view returns (address user){
        user = dataStorage.checkSender();
    }

    function createCentralBank(address _CBFactory)
        external
        ownerOnly
        newCBFactoryOnly(_CBFactory)
        noInstanceOnly(msg.sender)
    {
        // require(dataStorage.checkOwner(msg.sender) == true, "Need ownership.");
        CentralBankFactory(_CBFactory).createCentralBank(msg.sender);
    }

    function createBusinessAccount(address _BAFactory)
        external
        membersOnly
        newBAFactoryOnly(_BAFactory)
        noInstanceOnly(msg.sender)
    {
        // require(
        //     dataStorage.checkMember(msg.sender) == true,
        //     "Need membership."
        // );
        BusinessAccountFactory(_BAFactory).createBusinessAccount(msg.sender);
    }

    function createVote(
        address _vote,
        string memory _name,
        address _uaddr,
        uint256 _amount,
        uint256 _start,
        uint256 _over
    ) external ownerOnly newVoteFactoryOnly(_vote) {
        // require(
        //     dataStorage.checkOwner(msg.sender),
        //     "You need Owner Permission."
        // );
        VoteFactory(_vote).createVote(_name, _uaddr, _amount, _start, _over);
    }

    function checkDataStoage() external view returns (address) {
        return (address(dataStorage));
    }

    // function checkCentralBank() external view returns (address) {
    //     return address(this); // TODO
    // }
}
