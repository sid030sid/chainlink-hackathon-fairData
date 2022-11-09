import React, { useEffect, useState} from 'react';
import axios from 'axios';

import Form from '../components/Form'


function Home(props) {

    //state variables
    const [walletAddress, setWalletAddress] = useState('')
    const [purpose, setPurpose] = useState('')
    const [nameRequest, setNameRequest] = useState(false)
    const [birthdayRequest, setBirthdayRequest] = useState(false)
    
    return(
        <div>
            <Form></Form>
        </div>
    );
}

export default Home;