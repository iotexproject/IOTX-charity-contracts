var MyDonate = artifacts.require("Donate");

module.exports = function(deployer) {
  // deployment steps
  deployer.deploy(MyDonate, "0x5aeda56215b167893e80b4fe645ba6d5bab767de", 1521155231, 1521159231, 200000000000000000, 1000000000000000000, 5);  
};
