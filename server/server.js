const express = require("express");
const cors = require("cors");
const mongoose = require("mongoose");
const EventEmmiter = require('events')
const http = require('http');

require("dotenv").config(); // for the environment variable to store URI calling mongoDB
const PORT = process.env.PORT || 3001; //declare port to which server listens

//initialise middleware
const app = express(); //create express app
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors()); //for http request regarding API otuside javaScript project --> here: essentail for mongoDB endpoints

//connecting to unbiasedTwin's mongoDB data base
mongoose.connect(process.env.URI, {useNewUrlParser : true, useUnifiedTopology: true});
const connection = mongoose.connection;
connection.once("open", ()=>{
  console.log("MongoDB successfuly connected!");
});


//api endpoints
const userRouter = require("./routes/user-route");
app.use("/app/user", userRouter);

//for production
// getting and storing the current directory path
const path = __dirname + "/";

// once deployed all files need to be recognised by the app so that the node server can use them
if(process.env.NODE_ENV === "production"){
  app.use(express.static(path + 'node_modules/'))
  app.use(express.static(path + 'css/'));
  app.use(express.static(path + 'js/'));
  app.use(express.static(path +'../client/build/'));

  app.get("/", (req, res) => {
    res.status(200).sendFile(path + "../client/build/index.html");
  });

  app.get("/about", (req, res) => {
    res.status(200).sendFile(path + "../client/build/index.html");
  }); 

  app.get("/projects", (req, res) => {
    res.status(200).sendFile(path + "../client/build/index.html");
  }); 

  app.get("/unbiasedTwin/:jobId", (req, res) => {
    res.status(200).sendFile(path + "../client/build/index.html");
  }); 
};

if(process.env.NODE_ENV === "production"){
  app.get("*", (req, res) => {
    res.status(200).sendFile(path + "../client/build/index.html");
  });  
};

const emitter = new EventEmmiter()

//event stops the automation in case of error
emitter.on("stopHerokuApp", () => {
  clearInterval(pingHerokuApp)
  console.log("Pinging of HerokuApp stopped!")
})

// ping heroku app so that it is not put to sleep after 30 minutes of no call
var pingHerokuApp = setInterval(function() {
  http.get("http://fair-data.herokuapp.com/app/user/")
}, 300000); // every 5 minutes (300000)

app.listen(PORT, () => {
  console.log(`Server listening on ${PORT}. Follow link: `);
});