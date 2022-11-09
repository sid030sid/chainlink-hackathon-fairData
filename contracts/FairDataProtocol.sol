//SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/utils/Strings.sol";
import '@chainlink/contracts/src/v0.8/ChainlinkClient.sol';
import '@chainlink/contracts/src/v0.8/ConfirmedOwner.sol';

contract FairDataProtocol is ChainlinkClient, ConfirmedOwner {
    address creator = msg.sender; //uploader of contract gets facilitation fee
    
    //for chainlink's any api serivce
    using Chainlink for Chainlink.Request;

    string public id;

    bytes32 private jobId;
    uint256 private fee;

    event PersonalData(bytes32 indexed requestId, string name, string birthday);

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
        setChainlinkOracle(0xCC79157eb46F5624204f47AB42b3906cAA40eaB7);
        jobId = '7d80a6386ef543a3abb52817f6707e3b';
        fee = (1 * LINK_DIVISIBILITY) / 10; // 0,1 * 10**18 (Varies by network and job)
    }

    /**
     * Create a Chainlink request to retrieve API response, find the target
     * data which is located in a list
     */

      //test with _fromWalletAddress =  "0xDD098205cA88D22ef9dCf666d9590c5E065e37B7"
    function requestPersonalData(address _from) public payable returns (bytes32 requestId) {

        (bool paymentAccepted, ) = _from.call{value: msg.value}("");
       
        require(paymentAccepted == true, "Request on personal data denied!");

        //get personal data if owner of said personal data signs transaction
        Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.fulfillMultipleParameters.selector);
        req.add('urlName', string.concat('http://localhost:3001/app/user/', Strings.toHexString(uint160(_from), 20)));
        req.add('pathName', 'name');
        req.add('urlBirthday', string.concat('http://localhost:3001/app/user/', Strings.toHexString(uint160(_from), 20)));
        req.add('pathBirthday', 'birthday');

        //Sends the request
        return sendChainlinkRequest(req, fee);
    }

    /**
     * Receive the response in the form of string
     */
    function fulfillMultipleParameters (bytes32 _requestId, string memory _name, string memory _birthday) public recordChainlinkFulfillment(_requestId) {
        emit PersonalData(_requestId, _name, _birthday);
    }

    /**
     * Allow withdraw of Link tokens from the contract
     */
    function withdrawLink() public onlyOwner {
        LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
        require(link.transfer(msg.sender, link.balanceOf(address(this))), 'Unable to transfer');
    }
}
