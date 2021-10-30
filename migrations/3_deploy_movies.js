var MovieRater = artifacts.require("./MovieRater.sol");

module.exports = function(deployer) {
  deployer.deploy(MovieRater);
};
