require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require('hardhat-contract-sizer');
const dotenv = require("dotenv");
dotenv.config({path: __dirname + '/.env'});
const { PRIVATE_KEY, URL_MUMBAI, URL_RINKEBY, MUMBAISCAN_APIKEY, RINKEBY_APIKEY } = process.env;

module.exports = {
  defaultNetwork: "hardhat",
  solidity: {
    version:"0.8.13",
    settings: {
    optimizer: {
      enabled: true,
      runs: 200
    },
  }
},
  networks: {
    hardhat: {
    },
    rinkeby:{
      url: URL_RINKEBY,
      accounts: [PRIVATE_KEY]
    },
    mumbai: {
      url: URL_MUMBAI,
      accounts: [PRIVATE_KEY]
    }
  },
  etherscan: {
    apiKey: {
      rinkeby: RINKEBY_APIKEY,
      polygonMumbai: MUMBAISCAN_APIKEY
    }
  }
};