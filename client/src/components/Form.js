import * as React from 'react';
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

const theme = createTheme();

export default function Form() {
  const handleSubmit = (event) => {
    event.preventDefault();
    const data = new FormData(event.currentTarget);
    console.log({
      email: data.get('email'),
      password: data.get('password'),
    });
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
          <Box component="form" onSubmit={handleSubmit} noValidate sx={{ mt: 1 }}>
            <TextField
              margin="normal"
              required
              fullWidth
              id="walletAddres"
              label="Ethereum Address"
              name="walletAddress"
              autoFocus
            />
            <TextField
              margin="normal"
              required
              fullWidth
              name="purpose"
              label="Purpose"
              id="purpose"
            />
            <Typography component="h5" variant="h5">
                Requested data:
            </Typography>
            <FormControlLabel
              control={<Checkbox value="remember" color="primary" />}
              label="name"
            />
            <FormControlLabel
              control={<Checkbox value="remember" color="primary" />}
              label="birthday"
            />
            <FormControlLabel
              control={<Checkbox value="remember" color="primary" />}
              label="ZK-Proof of adulthood"
            />
            <Button
              type="submit"
              fullWidth
              variant="contained"
              sx={{ mt: 3, mb: 2 }}
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