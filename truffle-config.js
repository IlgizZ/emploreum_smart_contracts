module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*", // Match any network id
      gasPrice: 1000000000
    },
    ropsten:  {
      network_id: 3,
      host: "localhost",
      port:  8545,
      gas:  4700035
    }
  },
   rpc: {
     host: 'localhost',
     post:8080
   }
};
