const EGRNContract = artifacts.require("EGRN.sol");
module.exports = function(deployer) {
  deployer.deploy(EGRNContract);
};