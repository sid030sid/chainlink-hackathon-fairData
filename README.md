# **FairData** - a Submission for the *Chainlink Fall Hackathon* (October 14 - November 18)

## The problem your project addresses.

## How you’ve addressed the problem.

## Which technologies you used to do so.
## Tech-Stack
- Solidity for the underlying smart contract of FairData: the FairDatat Manager (FDM)
- React.js for client of FDM (not yet connected to deployed FDM contract on Goerli)
- Ethers.js for web 3.0 functionality
- MongoDb Atlas for an examplary database storing personal data 
- Express.js and Mongoose for the API of the examplary database (click [here](https://fair-data.herokuapp.com/app/user/) for public get endpoint)
- Node.js for the underlying server of the API and the client
- Heroku for launching and maintaining server
- Chainlink's Any API service for enabling the FDM contract 
    - to transparently forward personal data stored off-chain in centralized storage
    - to transparently perform zero-knowledge proofs without forwarding personal data
    - to ulitmately be a trustless platform managing personal data

## Motivation
- 

## Alternative project
- MoodyElon is a dynamic NFT which changes baased on the sentiment of Elon's tweets
- To enable the dynamicness, one needs Chainlink's Automation service (Upkeeper)

## FairData's next steps
- create a MVP
- generalise smart contract so that anyone can sell personal data fairly by registering url 
- create an external adapter so that the fairData protocol firstly needs to authenticate before being able to send get reuqests
- connect web app to final FairDataManager smart contract
- solve problem of personal data being logged on public event logs

## Installation and set up
1. Clone repo
2. Run ```npm install``` in root and client folder respectively
3. Run ```npm run dev``` in root folder to get server and client running on localhost
4. Login with MetaMask into client (note: client is not yet connected to FDM contract on Goerli)
