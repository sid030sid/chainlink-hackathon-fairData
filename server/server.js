const express = require("express");
const cors = require("cors");
const mongoose = require("mongoose");

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
const userRouter = require("./routes/user");
app.use("/app/user", userRouter);

app.listen(PORT, () => {
  console.log(`Server listening on ${PORT}. Follow link: `);
});