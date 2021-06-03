require('dotenv').config();
const indexCtrl = {};
const Web3 = require('web3');
const web3 = new Web3(`${process.env.SERVER_NAME_ETH}${process.env.SERVER_PROJECT_ID_ETH}`);
const {abi} = require('./../../build/contracts/FactoryAuctionsAndToken.json');
const addressContract = process.env.CONTRACT_ADDRESS_FACTORY;

const contract = new web3.eth.Contract(abi,addressContract);

indexCtrl.renderIndex = (req,res) => {
    const titlePage = 'Home';
    console.log(contract.methods);
    res.render('index', { titlePage });
}

indexCtrl.dashboardwork = (req,res) => {
    const titlePage = 'Dashboard Works';
    res.render('dashboard/dashboardworks', { titlePage });
}


indexCtrl.createArt = (req,res) => {
    const titlePage = 'Create Art';
    res.render('dashboard/create-art', { titlePage });
}

module.exports = indexCtrl;