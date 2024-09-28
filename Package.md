ETHClient Module

# Package Overview

This module provides functionality to interact with Ethereum smart contracts, including calling view functions,
executing state-changing functions, and estimating gas fees. It utilizes JSON-RPC to communicate with Ethereum nodes.

# Key Functions

    •	Get Accounts: Fetch the list of accounts available on the Ethereum node.

    •	Get Balance: Retrieve the balance of an Ethereum account.

    •	Get Block Number: Fetch the latest block number in the blockchain.

    •	Get Transaction Count: Retrieve the number of transactions sent from an Ethereum address.

    •	Get Block By Number: Get the details of a specific block by its number.

    •	Send Raw Transaction: Submit a signed transaction to the Ethereum network.

    •	Get Transaction Receipt: Fetch the transaction receipt by its hash.

    •	Get Gas Price: Retrieve the current gas price for transactions.

    •	Estimate Gas: Estimate the amount of gas required to execute a transaction.

    •	Get Code: Retrieve the smart contract bytecode at a specific address.

    •	Call methods: Call both view-only and setter methods.

For more information on the Ethereum JSON-RPC API, refer to:
[Ethereum JSON-RPC API Documentation](https://eth.wiki/json-rpc/API).
