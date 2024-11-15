# ETHClient Module

The **ETHClient Module** provides a comprehensive set of functions to interact with Ethereum smart contracts using the JSON-RPC protocol. This module allows developers to call view functions, execute state-changing transactions, and estimate gas fees, among other functionalities.

## Features

- **Call Smart Contract Methods**  
  - View functions (read-only)  
  - Setter functions (state-changing)

- **Fetch Blockchain Information**  
  - Get account balances  
  - Retrieve the latest block number  
  - Fetch transaction details  

- **Transaction Management**  
  - Send raw transactions  
  - Estimate gas fees  
  - Get transaction receipts  

- **Smart Contract Interactions**  
  - Retrieve smart contract bytecode  
  - Execute smart contract functions using function selectors and encoded parameters  

## Key Functions

1. **Get Accounts**  
   Fetch the list of available accounts on the Ethereum node.
   
2. **Get Balance**  
   Retrieve the balance of a specific Ethereum account.

3. **Get Block Number**  
   Get the latest block number in the Ethereum blockchain.

4. **Get Transaction Count**  
   Retrieve the number of transactions sent from a specific Ethereum address.

5. **Get Block By Number**  
   Fetch details of a specific block using its block number.

6. **Send Raw Transaction**  
   Submit a signed transaction to the Ethereum network.

7. **Get Transaction Receipt**  
   Fetch the transaction receipt using its hash.

8. **Get Gas Price**  
   Retrieve the current gas price for transactions.

9. **Estimate Gas**  
   Estimate the gas required to execute a transaction.

10. **Get Code**  
    Retrieve the smart contract bytecode at a specific address.

11. **Call Methods**  
    - Call view-only functions (`eth_call`)  
    - Execute state-changing transactions (`eth_sendTransaction`)  

## Usage

```ballerina
import ballerina/http;
import ETHClient;

http:Client rpcClient = check new("https://your-ethereum-node-url");

ETHClient:Contract contract = check new(rpcClient, "path/to/contract-abi.json", "0xYourSmartContractAddress");

// Call a view function
json result = check contract.callViewFunction("functionHash", [params]);

// Execute a state-changing function
json txnHash = check contract.callSetFunction("functionHash", "0xYourAccountAddress", [params], "gasLimit", "gasPrice");
