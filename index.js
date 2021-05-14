const Web3 = require('web3');
const web3 = new Web3('https://ropsten.infura.io/v3/282792d7dd524d5d87e5b25d7382c31a');
const nftAddrss = '0xED9e6b87Efa409C4E3009d705B8064C29638b4D0';
const { abiArts } = require('./abi/Arts');
const micontrato = new web3.eth.Contract(abiArts, nftAddrss);

console.log(micontrato.methods)

