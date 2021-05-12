const Arts = artifacts.require("Arts");
module.exports = function(deployer) {
  deployer.deploy(Arts);
};