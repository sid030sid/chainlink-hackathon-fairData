//SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

//address: 0xcdd7a3bcfc6ccb8b6e7ef272b3b402efb06bbd72
//new test address: 0x63D9655eE025dE0Cd2b85c73cFcD4c7068127f5a
//new test address: 0x8fe1c59730F742766041e70F5edF05e488cC7f90
//0x4a3bE5254FA2CA4444d98De1f191524AE71C2616
import "@openzeppelin/contracts/utils/Strings.sol";
import '@chainlink/contracts/src/v0.8/ChainlinkClient.sol';
import '@chainlink/contracts/src/v0.8/ConfirmedOwner.sol';

contract ZkAdultProof is ChainlinkClient, ConfirmedOwner {
    event AdulthoodProof(bool adult);

    //for chainlink's any api serivce
    using Chainlink for Chainlink.Request;
    uint256 private fee;

    constructor() ConfirmedOwner(msg.sender) {
        setChainlinkToken(0x326C977E6efc84E512bB9C30f76E30c160eD06FB);
        setChainlinkOracle(0xCC79157eb46F5624204f47AB42b3906cAA40eaB7); //chainlink's testnet oracle on goerli 
        fee = (1 * LINK_DIVISIBILITY) / 10; // 0,1 * 10**18 (Varies by network and job)
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
        if(_birthday + 18 * 365 days > block.timestamp){
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
