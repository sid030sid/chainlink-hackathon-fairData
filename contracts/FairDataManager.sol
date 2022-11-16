//SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/utils/Strings.sol";
import '@chainlink/contracts/src/v0.8/ChainlinkClient.sol';
import '@chainlink/contracts/src/v0.8/ConfirmedOwner.sol';

contract ZkAdultProof is ChainlinkClient, ConfirmedOwner {

    event PersonalData (string name);
    event AdulthoodProof(bool adult);

    //for chainlink's any api serivce
    using Chainlink for Chainlink.Request;
    uint256 private fee;

    constructor() ConfirmedOwner(msg.sender) {
        setChainlinkToken(0x326C977E6efc84E512bB9C30f76E30c160eD06FB);
        setChainlinkOracle(0xCC79157eb46F5624204f47AB42b3906cAA40eaB7); //chainlink's testnet oracle on goerli 
        fee = (1 * LINK_DIVISIBILITY) / 10; // 0,1 * 10**18 (Varies by network and job)
    }

    //_from and _address is the same. hoewver the latter is the string of the address --> this is so due to casting to string from address is difficult
    //test function with address: 0xd04a70063a8383F1142737fFb8C53527907C88eC
    function requestPersonalData(address _from, string memory _address, string memory _url) public payable returns (bytes32 requestId) {

        //alternative: (bool paymentAccepted, ) = _from.call{value: msg.value}("");
        bool paymentAccepted = payable(_from).send(msg.value); //TODO use "send" or "transfer" to give receiver choice to decline request on buying personal data
        require(paymentAccepted == true, "Request on personal data denied!");

        //get personal data (i.e. name) if owner of said personal data signs transaction
        Chainlink.Request memory req = buildChainlinkRequest("7d80a6386ef543a3abb52817f6707e3b", address(this), this.fulfillRequestPersonalData.selector);
        req.add('get', 'https://fair-data.herokuapp.com/app/user/', _address);
        req.add('path', 'name');

        //Sends the request
        return sendChainlinkRequest(req, fee);
    }

    function fulfillRequestPersonalData (bytes32 _requestId, string memory _name) public recordChainlinkFulfillment(_requestId) {
        emit PersonalData(_name);
    }

    //test function with address: 0xd04a70063a8383F1142737fFb8C53527907C88eC (minor) and 0xdfaB538a677F7c84B43d379f7bFE90B85Cc18539 (adult)
    function zkProofAdulthood (string memory _address) public returns (bytes32 requestId) {
        Chainlink.Request memory req = buildChainlinkRequest("ca98366cc7314957b8c012c72f05aeeb", address(this), this.fulfillZkProofAdulthood.selector);
        req.add('get', string.concat('https://fair-data.herokuapp.com/app/user/', _address));
        req.add('path', 'birthday');

        // Sends the request
        return sendChainlinkRequest(req, fee);
    }

    //note: birthday is uint as it is in unix epoch format
    function fulfillZkProofAdulthood (bytes32 _requestId, uint _birthday) public recordChainlinkFulfillment(_requestId) {
        if(_birthday + 18 * 365 days < block.timestamp){
            emit AdulthoodProof(true);
        }else{
            emit AdulthoodProof(false);
        }
    }

    /**
     * Allow withdraw of Link tokens from the contract
     */
    function withdrawLink() public onlyOwner {
        LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
        require(link.transfer(msg.sender, link.balanceOf(address(this))), 'Unable to transfer');
    }
}

/* add:
event Adulthood(bool adult);
    event PaymentAccepted(bool accepted);
    event RequestAccepted(address from, address to);
    event RequestDenied(address from, address to);

    struct Request {
        address from;
        address to;
        uint amount;
        bool accepted;
    }
    uint public requestCount=0;
    mapping(uint => Request) public requests;
    mapping(address => uint[]) private personalRequests;
    mapping(uint => bool) public requestProcessed;

    //amount in ETH
    function makeRequest(address _to, uint _amount) public {
        requests[requestCount] = Request(msg.sender, _to, _amount, false);
        personalRequests[_to].push(requestCount);
        requestCount++;

        //TODO allow smart contract to send _amount either via apporva function or via locking in the money
    }

    function getPersonalRequests() public view returns (uint[] memory) {
        return personalRequests[msg.sender];
    }

    function approveRequest(uint _requestId) public {
        require(requests[_requestId].to == msg.sender, "Not eligable to approve request");
        require(requestProcessed[_requestId] == false, "Requeyt was already processed");
        (bool paymentSuccess, ) = requests[_requestId].from.call{value: requests[_requestId].amount}("");
        require(paymentSuccess);
        requests[_requestId].accepted = true;
        emit RequestAccepted(requests[_requestId].from, requests[_requestId].to);

        //TODO emit event that gives personal data to requester --> CHainlink
    }

    function declineRequest(uint _requestId) public {
        require(requests[_requestId].to == msg.sender, "Not eligable to approve request");
        require(requestProcessed[_requestId] == false, "Requeyt was already processed");
        //TODO eventually send locked ether back to receiver
        emit RequestDenied(requests[_requestId].from, requests[_requestId].to);
    }
*/