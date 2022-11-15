//SPDX-License-Identifier: MIT

//uploaded as 0x3616803401ebcb8dd110bb81f8da51148cd669ef
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/utils/Strings.sol";
import '@chainlink/contracts/src/v0.8/ChainlinkClient.sol';
import '@chainlink/contracts/src/v0.8/ConfirmedOwner.sol';

contract FairDataProtocolTest is ChainlinkClient, ConfirmedOwner {

    //for testing purposes:
    string public name;
    string public birthday;

    event AdulthoodProof(bool adult);

    //real contract code
    address creator = msg.sender; //uploader of contract gets facilitation fee
    
    //for chainlink's any api serivce
    using Chainlink for Chainlink.Request;
    bytes32 private jobId;
    uint256 private fee;

    event RequestMultipleFulfilled(bytes32 indexed requestId, string name, string birthday);

    /**
     * @notice Initialize the link token and target oracle
     *
     * Goerli Testnet details:
     * Link Token: 0x326C977E6efc84E512bB9C30f76E30c160eD06FB
     * Oracle: 0xCC79157eb46F5624204f47AB42b3906cAA40eaB7 (Chainlink DevRel)
     * jobId: 7d80a6386ef543a3abb52817f6707e3b
     *
     */
    constructor() ConfirmedOwner(msg.sender) {
        setChainlinkToken(0x326C977E6efc84E512bB9C30f76E30c160eD06FB);
        setChainlinkOracle(0xCC79157eb46F5624204f47AB42b3906cAA40eaB7); //chainlink's testnet oracle on goerli 
        jobId = '7d80a6386ef543a3abb52817f6707e3b'; //jobID which can get string values from get request
        fee = (1 * LINK_DIVISIBILITY) / 10; // 0,1 * 10**18 (Varies by network and job)
    }

    /**
     * Create a Chainlink request to retrieve API response, find the target
     * data which is located in a list
     */

      //test with _fromWalletAddress =  "0xDD098205cA88D22ef9dCf666d9590c5E065e37B7"
    function requestPersonalData() public payable returns (bytes32 requestId) {

        //get personal data if owner of said personal data signs transaction
        Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.fulfillMultipleParameters.selector);
        req.add('urlName', 'https://fair-data.herokuapp.com/app/user/0xd04a70063a8383F1142737fFb8C53527907C88eC');
        req.add('pathName', 'name');
        req.add('urlBirthday', 'https://fair-data.herokuapp.com/app/user/0xd04a70063a8383F1142737fFb8C53527907C88eC');
        req.add('pathBirthday', 'birthday');

        //Sends the request
        return sendChainlinkRequest(req, fee);
    }

    /**
     * Receive the response in the form of string
     */
    function fulfillMultipleParameters (bytes32 _requestId, string memory _name, string memory _birthday) public recordChainlinkFulfillment(_requestId) {
        emit RequestMultipleFulfilled(_requestId, _name, _birthday);
        name = _name;
        birthday = _birthday;
    }

    function zkProofAdulthood () public returns (bytes32 requestId) {
        address memory jobIdUint = "ca98366cc7314957b8c012c72f05aeeb";
        Chainlink.Request memory req = buildChainlinkRequest(jobIdUint, address(this), this.fulfillZkProofAdulthood.selector);
        req.add('get', 'https://fair-data.herokuapp.com/app/user/0xd04a70063a8383F1142737fFb8C53527907C88eC');
        req.add('path', 'birthday');

        // Sends the request
        return sendChainlinkRequest(req, fee);
    }

    function fulfillZkProofAdulthood (bytes32 _requestId, uint _birthday) public recordChainlinkFulfillment(_requestId) {
        if(_birthday + 18 * 365 days > block.timestamp){
            emit AdulthoodProof(true);
        }else{
            emit AdulthoodProof(false);
        }
    }

    //_birthday should be in unix epoch format format (=seconds after 1970-01-01 till _birthday date)
    function checkAdulthood(uint _birthday) public {
        if(uint(_birthday) + 18 * 365 days > block.timestamp){
            emit Adulthood(true);
        }else{
            emit Adulthood(false);
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
