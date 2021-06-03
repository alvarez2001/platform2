const FactoryAuctionsAndToken = artifacts.require("FactoryAuctionsAndToken");
module.exports = function(deployer) {
  deployer.deploy(FactoryAuctionsAndToken, 'Slipstream', 'ST');
};