const router = require('express').Router();
let User = require('../schemas/user-schema');

//test endpoint by calling: http://localhost:3001/app/user/
router.route("/").get((req, res)=>{
    User.find()
    .then(user => {
        res.send(user)
    })
    .catch(err => console.log(err))
});

//get personal data based on walletAddres
router.route("/:walletAddress").get((req, res)=>{
    console.log(req.query.walletAddress)
    User.find({walletAddress : req.query.walletAddress})
    .then(user => {
        res.send({
            param : req.query.walletAddress,
            personalData : user.personalData
        })
    })
    .catch(err => console.log(err))
});

router.route("/").post((req, res)=>{
    const newUser = new User({
        walletAddress : req.body.walletAddress,
        personalData : req.body.personalData
    })
    newUser.save()
    .then(user=> {
        if(user){
            res.send({
                success:true,
                newUser:user
            })
        }else{
            res.send({
                success:false,
                newUser:undefined
            })
        }
    })
    .catch(err => console.log(err))
});

module.exports = router;