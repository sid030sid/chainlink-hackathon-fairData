//SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

//deployed at goerli: 0x1358c6dad9762722af1e6ae8a25ca78a4ce98cc1 (with localhost as url)
//deployed contract with general url: 0x02a5e6ae9e7cd22ec08b31f4433095344b9f76dd
//checksummed version: 0x02a5e6Ae9e7cD22eC08b31F4433095344b9f76dD

//newest contract with certification code: 0xb821e9b9853ca5ca71d20a853aff0dd1f864d50e --> checksummed: 0xb821E9B9853CA5ca71D20A853AfF0dD1F864d50e
import "@openzeppelin/contracts/utils/Strings.sol";
import '@chainlink/contracts/src/v0.8/ChainlinkClient.sol';
import '@chainlink/contracts/src/v0.8/ConfirmedOwner.sol';

contract FairDataProtocol is ChainlinkClient, ConfirmedOwner {
    address creator = msg.sender; //uploader of contract gets facilitation fee

    struct FairDataCertificate {
        address dataSeeker; //third party which rightfully gets access to personal data
        address dataOwner; //user who owns personal data
        bytes32 requestId;
    }
    uint certificateCount = 0;
    mapping (uint => FairDataCertificate) certificates;
    
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
        setChainlinkOracle(0xCC79157eb46F5624204f47AB42b3906cAA40eaB7);
        jobId = '7d80a6386ef543a3abb52817f6707e3b';
        fee = (1 * LINK_DIVISIBILITY) / 10; // 0,1 * 10**18 (Varies by network and job)
    }

    /**
     * Create a Chainlink request to retrieve API response, find the target
     * data which is located in a list
     */

      //test with _fromWalletAddress =  "0xDD098205cA88D22ef9dCf666d9590c5E065e37B7"
    function requestPersonalData(address _from, string memory _url) public payable returns (bytes32 requestId) {

        (bool paymentAccepted, ) = _from.call{value: msg.value}("");
       
        require(paymentAccepted == true, "Request on personal data denied!");

        //issue first half of certificate
        certificates[certificateCount] = FairDataCertificate(msg.sender, _from, 0);
        certificateCount++;

        //get personal data if owner of said personal data signs transaction
        Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.fulfillMultipleParameters.selector);
        req.add('urlName', _url);
        req.add('pathName', 'name');
        req.add('urlBirthday', _url);
        req.add('pathBirthday', 'birthday');

        //Sends the request
        return sendChainlinkRequest(req, fee);
    }

    /**
     * Receive the response in the form of string
     */
    function fulfillMultipleParameters (bytes32 _requestId, string memory _name, string memory _birthday) public recordChainlinkFulfillment(_requestId) {
        emit RequestMultipleFulfilled(_requestId, _name, _birthday);
        certificates[certificateCount].requestId = _requestId;
    }

    /**
     * Allow withdraw of Link tokens from the contract
     */
    function withdrawLink() public onlyOwner {
        LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
        require(link.transfer(msg.sender, link.balanceOf(address(this))), 'Unable to transfer');
    }
}
