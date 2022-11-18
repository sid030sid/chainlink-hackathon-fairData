# **FairData** (Chainlink Fall Hackathon 2022)

## About FairData 
FairData is world's first trustless data provider powered by Ethereum and Chainlink. It transparently records requests of data seekers on personal data of data owners. An example of such a request is a third party seeking personal data from you as a data owner for advertisment purposes. Unlike today's handling of personal data, FairData gives data owners the choice to say yes or no to requests on their personal data. If they say yes, they will be paid for sharing their personal data and data seekers benefit from an immutable and permanent FairData certificate, verifying their ethically correct obtainment of personal data. If data owners say no, no personal information is forwarded to the data seeker. As a result, FairData gives back control to every day people about their personal data, while maintaining the supply of data for businesses. 

### What inspired me to do FairData?
- the feeling of being controlless over own personal data
- the desire to contribute to the vision of web 3.0
- having fun while challenging yourself

### What I learned building the proof of concept for FairData as part of Chainlink Hackathon Fall 2023?
- got familiar with all services of Chainlink, especially Any API and External Adapters
- improved my Solidity skills around hybrid smart contracts
- extended my knowledge in use cases of Blockchain in general

## Installation and set up
1. Clone repo
2. Run ```npm install``` in root and client folder respectively
3. Run ```npm run dev``` in root folder to get server and client running on localhost
4. Login with MetaMask into client (note: client is not yet connected to FDM contract on Goerli)

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

## FairData's next steps
1. create MVP of FairData
    - solve all remaining TODOs of current Proof of Concept (e. g. solve problem of personal data being logged on public event logs)
    - generalise smart contract so that any central data keeper can sell personal data with consent of data owner
    - create an external adapter so that the fairData protocol firstly needs to authenticate before being able to send get reuqests
    - extend web app and connect it to final FairData Manager smart contract
2. create business plan of FairData
3. get funding to turn FairData into real product

## Author and owner
All code as well as intellectual and business property belongs to Sid Lamichhane. Feel free to reach out for collaboration and feedback: ```sid.lam@gmx.de```.
