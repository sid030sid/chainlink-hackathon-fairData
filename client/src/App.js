import React, { useEffect, useState} from 'react';
import './App.css';

import Home from './pages/Home';
import Navbar from './components/Navbar';

const ethers = require('ethers');

function App() {

  // comonent's state variables
  const [provider, setProvider] = useState("")
  const [user, setUser] = useState("")
  
  // component's onMount, didMount etc.
  useEffect(() => {
    const createProvider = async () => {
      try {
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        await provider.send("eth_requestAccounts", []);
        setProvider(provider)
      } catch (error) {
        console.log(error)
      }
    }
  
    createProvider()
  }, []);

  // component's functions
  const login = async () => {
    try {
      if (!provider) {
        return;
      }

      // Load the user's accounts.
      const accounts = await provider.listAccounts();
      setUser(accounts[0]);

    } catch (err) {
      setUser("");
      console.error(err);
    }
  }

  //rendering of component
  return (
    <div className="App">
      <Navbar login={login} user={user}></Navbar>
      <Home></Home>
      {/*
      <Navbar bg="light" expand="lg">
        <Container>
          <Navbar.Brand>FairData</Navbar.Brand>
          <Navbar.Toggle aria-controls="basic-navbar-nav" />
          <Button variant="primary" type="submit" onClick={user ? undefined : connectSSI}>
            {user ? "Logged in as "+user : "Login"}
          </Button>
        </Container>
      </Navbar>
      <Home user={user} provider={provider}/>
      */}
    </div>
  );
}

export default App;