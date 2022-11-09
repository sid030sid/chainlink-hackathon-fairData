import * as React from 'react';
import AppBar from '@mui/material/AppBar';
import Box from '@mui/material/Box';
import Toolbar from '@mui/material/Toolbar';
import Typography from '@mui/material/Typography';
import Button from '@mui/material/Button';

export default function Navbar(props) {
  return (
    <Box sx={{ flexGrow: 1 }}>
      <AppBar position="static">
        <Toolbar>
          <Typography variant="h6" component="div" sx={{ flexGrow: 1 }}>
            FairData
          </Typography>
          <Button color="inherit" onClick={props.user ? undefined : props.login}>
            {props.user ? props.user : "Login"}
          </Button>
        </Toolbar>
      </AppBar>
    </Box>
  );
}
