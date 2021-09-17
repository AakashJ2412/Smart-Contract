const HelloWorld = artifacts.require("Marketplace");

module.exports = function (deployer) {
  deployer.deploy(Marketplace);
};
