var MyDonate = artifacts.require("Donate");

module.exports = function(deployer) {
  deployer.deploy(MyDonate, "0xfB6916095ca1df60bB79Ce92cE3Ea74c37c5d359", 1521220200, 1521223800, 200000000000000000, 1000000000000000000, 2593);  
};
