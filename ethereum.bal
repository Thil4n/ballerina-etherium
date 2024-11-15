import ballerina/http;

/// ETHClient is an Ethereum JSON-RPC client for interacting with an Ethereum node.
/// It provides methods to fetch account details, balances, transaction counts, 
/// and various other blockchain-related information via JSON-RPC.
public class ETHClient {

    // The base URL of the Ethereum JSON-RPC API.
    private final string api;

    // HTTP client to send JSON-RPC requests to the Ethereum node.
    private final http:Client rpcClient;

    /// Constructor to initialize the Ethereum client with the API URL and HTTP client configuration.
    ///
    /// # Parameters
    /// - `api`: The Ethereum JSON-RPC API URL.
    ///
    /// # Returns
    /// - `error?`: An optional error if there was an issue initializing the HTTP client.
    public function init(string api) returns error? {
        self.api = api;

        // Create a client configuration to disable HTTP/2 upgrades
        http:ClientConfiguration clientConfig = {
            httpVersion: http:HTTP_1_1
        };

        // Initialize the HTTP client with the given API URL and configuration
        self.rpcClient = check new (self.api, clientConfig);
    }

    /// Fetch the list of accounts available on the Ethereum node.
    ///
    /// # Returns
    /// - `json`: A JSON object containing the list of accounts.
    /// - `error`: Error if there was an issue making the request.
    public function getAccounts() returns json|error {
        json requestBody = {
            "jsonrpc": "2.0",
            "method": "eth_accounts",
            "params": [],
            "id": 1
        };

        json response = check self.rpcClient->post("/", requestBody);
        return response;
    }

    /// Create a smart contract instance by specifying the contract ABI file and address.
    ///
    /// # Parameters
    /// - `jsonFilePath`: Path to the contract's ABI JSON file.
    /// - `contractAddress`: The deployed contract's address.
    ///
    /// # Returns
    /// - `Contract`: A new contract instance.
    /// - `error`: Error if the contract could not be created.
    public function createContract(string jsonFilePath, string contractAddress) returns Contract|error {
        return new Contract(self.rpcClient, jsonFilePath, contractAddress);
    }

    /// Fetch the balance of a specific Ethereum address.
    ///
    /// # Parameters
    /// - `address`: The Ethereum address to query.
    ///
    /// # Returns
    /// - `json`: The balance in Wei.
    /// - `error`: Error if there was an issue making the request.
    public function getBalance(string address) returns json|error {
        json requestBody = {
            "jsonrpc": "2.0",
            "method": "eth_getBalance",
            "params": [address, "latest"],
            "id": 1
        };

        json response = check self.rpcClient->post("/", requestBody);
        return response;
    }

    /// Get the latest block number on the Ethereum blockchain.
    ///
    /// # Returns
    /// - `json`: The block number.
    /// - `error`: Error if there was an issue making the request.
    public function getBlockNumber() returns json|error {
        json requestBody = {
            "jsonrpc": "2.0",
            "method": "eth_blockNumber",
            "params": [],
            "id": 1
        };

        json response = check self.rpcClient->post("/", requestBody);
        return response;
    }

    /// Get the number of transactions sent from an address.
    ///
    /// # Parameters
    /// - `address`: The Ethereum address to query.
    ///
    /// # Returns
    /// - `json`: The number of transactions sent from the address.
    /// - `error`: Error if there was an issue making the request.
    public function getTransactionCount(string address) returns json|error {
        json requestBody = {
            "jsonrpc": "2.0",
            "method": "eth_getTransactionCount",
            "params": [address, "latest"],
            "id": 1
        };

        json response = check self.rpcClient->post("/", requestBody);
        return response;
    }

    /// Get details of a block by its block number.
    ///
    /// # Parameters
    /// - `blockNumber`: The block number to query (in hexadecimal format).
    /// - `fullTransactions`: Whether to include full transaction objects or only hashes.
    ///
    /// # Returns
    /// - `json`: The block details.
    /// - `error`: Error if there was an issue making the request.
    public function getBlockByNumber(string blockNumber, boolean fullTransactions) returns json|error {
        json requestBody = {
            "jsonrpc": "2.0",
            "method": "eth_getBlockByNumber",
            "params": [blockNumber, fullTransactions],
            "id": 1
        };

        json response = check self.rpcClient->post("/", requestBody);
        return response;
    }

    /// Send a raw, signed Ethereum transaction to the network.
    ///
    /// # Parameters
    /// - `signedTx`: The signed transaction data.
    ///
    /// # Returns
    /// - `json`: The transaction hash.
    /// - `error`: Error if there was an issue making the request.
    public function sendRawTransaction(string signedTx) returns json|error {
        json requestBody = {
            "jsonrpc": "2.0",
            "method": "eth_sendRawTransaction",
            "params": [signedTx],
            "id": 1
        };

        json response = check self.rpcClient->post("/", requestBody);
        return response;
    }

    /// Get the receipt of a transaction by its hash.
    ///
    /// # Parameters
    /// - `txHash`: The hash of the transaction to query.
    ///
    /// # Returns
    /// - `json`: The transaction receipt.
    /// - `error`: Error if there was an issue making the request.
    public function getTransactionReceipt(string txHash) returns json|error {
        json requestBody = {
            "jsonrpc": "2.0",
            "method": "eth_getTransactionReceipt",
            "params": [txHash],
            "id": 1
        };

        json response = check self.rpcClient->post("/", requestBody);
        return response;
    }

    /// Get the current gas price from the Ethereum network.
    ///
    /// # Returns
    /// - `json`: The current gas price in Wei.
    /// - `error`: Error if there was an issue making the request.
    public function getGasPrice() returns json|error {
        json requestBody = {
            "jsonrpc": "2.0",
            "method": "eth_gasPrice",
            "params": [],
            "id": 1
        };

        json response = check self.rpcClient->post("/", requestBody);
        return response;
    }

    /// Estimate the gas required to execute a transaction.
    ///
    /// # Parameters
    /// - `transactionObject`: The transaction object (as a JSON object) for which to estimate gas.
    ///
    /// # Returns
    /// - `json`: The estimated gas amount.
    /// - `error`: Error if there was an issue making the request.
    public function estimateGas(json transactionObject) returns json|error {
        json requestBody = {
            "jsonrpc": "2.0",
            "method": "eth_estimateGas",
            "params": [transactionObject],
            "id": 1
        };

        json response = check self.rpcClient->post("/", requestBody);
        return response;
    }

    /// Get the contract code stored at a specific Ethereum address.
    ///
    /// # Parameters
    /// - `address`: The contract address.
    ///
    /// # Returns
    /// - `json`: The contract code in hexadecimal.
    /// - `error`: Error if there was an issue making the request.
    public function getCode(string address) returns json|error {
        json requestBody = {
            "jsonrpc": "2.0",
            "method": "eth_getCode",
            "params": [address, "latest"],
            "id": 1
        };

        json response = check self.rpcClient->post("/", requestBody);
        return response;
    }

}
