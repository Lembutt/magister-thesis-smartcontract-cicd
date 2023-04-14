module.exports = {
  compilers: {
    solc: {
      version: "0.8.0"
    }
  },
  networks: {
    development: {
     host: "127.0.0.1",   // Localhost (default: none)
     port: 8545,            // Standard Ethereum port (default: none)
     network_id: "*"        // Any network (default: none)
    }
  }
}