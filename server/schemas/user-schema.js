//import essentail libraries
const mongoose =  require("mongoose")

//schema for mongoose model
const User = new mongoose.Schema({
    walletAddress : {
        type : String,
        required : true
    },
    personalData : {
        name : String,
        birthday : String
    }
})

module.exports = mongoose.model("User", User)