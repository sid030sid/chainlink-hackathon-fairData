import React, { useEffect, useState} from 'react';
import Avatar from '@mui/material/Avatar';
import Button from '@mui/material/Button';
import CssBaseline from '@mui/material/CssBaseline';
import TextField from '@mui/material/TextField';
import FormControlLabel from '@mui/material/FormControlLabel';
import Checkbox from '@mui/material/Checkbox';
import Link from '@mui/material/Link';
import Grid from '@mui/material/Grid';
import Box from '@mui/material/Box';
import LockOutlinedIcon from '@mui/icons-material/LockOutlined';
import Typography from '@mui/material/Typography';
import Container from '@mui/material/Container';
import { createTheme, ThemeProvider } from '@mui/material/styles';

//origin:https://github.com/mui/material-ui/blob/v5.10.13/docs/data/material/getting-started/templates/sign-in/SignIn.js
const theme = createTheme();

export default function Form() {

  //state variables
  const [walletAddress, setWalletAddress] = useState('')
  const [purpose, setPurpose] = useState('')
  const [nameRequest, setNameRequest] = useState(false)
  const [birthdayRequest, setBirthdayRequest] = useState(false)
  const [zkAdulthoodRequest, setZkAdulthoodRequest] = useState(false)

  const request = async () => {
    for (const [i, value] of [walletAddress, purpose, nameRequest, birthdayRequest, zkAdulthoodRequest].entries()) {
      console.log('%d: %s', i, value);
    }
  };

  return (
    <ThemeProvider theme={theme}>
      <Container component="main" maxWidth="xs">
        <CssBaseline />
        <Box
          sx={{
            marginTop: 8,
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
          }}
        >
          <Typography component="h1" variant="h5">
            FairData
          </Typography>
          <Typography component="h5" variant="h5">
            Transparently request personal data - directly from its owner - based on Ethereum wallet address. 
            If the owner of the requested personal data allows usage, you will get a fairData certificate.
          </Typography>
          <Box component="form" noValidate sx={{ mt: 1 }}>
            <TextField
              margin="normal"
              required
              fullWidth
              id="walletAddres"
              label="Ethereum Address"
              name="walletAddress"
              autoFocus
              onChange={(e)=>setWalletAddress(e.target.value)}
            />
            <TextField
              margin="normal"
              required
              fullWidth
              name="purpose"
              label="Purpose"
              id="purpose"
              onChange={(e)=>setPurpose(e.target.value)}
            />
            <Typography component="h5" variant="h5">
                Requested data:
            </Typography>
            <FormControlLabel
              control={<Checkbox value="remember" color="primary" onChange={(e)=>setNameRequest(e.target.checked)}/>}
              label="name"
            />
            <FormControlLabel
              control={<Checkbox value="remember" color="primary" onChange={(e)=>setBirthdayRequest(e.target.checked)}/>}
              label="birthday"
            />
            <FormControlLabel
              control={<Checkbox value="remember" color="primary" onChange={(e)=>setZkAdulthoodRequest(e.target.checked)}/>}
              label="ZK-Proof of adulthood"
            />
            <Button
              fullWidth
              variant="contained"
              sx={{ mt: 3, mb: 2 }}
              onClick={request}
            >
              Request
            </Button>
            <Grid container>
              <Grid item xs>
                <Link href="#" variant="body2">
                  More information about FairData
                </Link>
              </Grid>
            </Grid>
          </Box>
        </Box>
      </Container>
    </ThemeProvider>
  );
}