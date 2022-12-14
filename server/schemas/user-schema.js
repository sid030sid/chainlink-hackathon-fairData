//import essentail libraries
const mongoose =  require("mongoose")

//schema for mongoose model
const User = new mongoose.Schema({
    walletAddress : {
        type : String,
        required : true
    },
    personalData : {   
        type : {
            name : String,
            birthday : Number //in UNIX epoch format
        },
        required : true
    }
})

module.exports = mongoose.model("User", User)