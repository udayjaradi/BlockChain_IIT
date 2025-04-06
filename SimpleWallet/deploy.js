const Web3 = require("web3");
const fs = require("fs");
const solc = require("solc");

const web3 = new Web3("http://127.0.0.1:8000"); // Connect to Ganache

const source = fs.readFileSync("SimpleWallet.sol", "utf8");
const input = {
  language: "Solidity",
  sources: {
    "SimpleWallet.sol": { content: source },
  },
  settings: { outputSelection: { "*": { "*": ["abi", "evm.bytecode"] } } },
};

const output = JSON.parse(solc.compile(JSON.stringify(input)));
const contractData = output.contracts["SimpleWallet.sol"]["SimpleWallet"];
const abi = contractData.abi;
const bytecode = contractData.evm.bytecode.object;

const deploy = async () => {
  const accounts = await web3.eth.getAccounts();
  const contract = new web3.eth.Contract(abi);

  contract
    .deploy({ data: "0x" + bytecode })
    .send({ from: accounts[0], gas: 1500000 })
    .then((newContract) => {
      console.log("Contract deployed at:", newContract.options.address);
    });
};

deploy();
