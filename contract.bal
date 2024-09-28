import ballerina/http;
import ballerina/io;

public class Contract {
    private final string address;
    private final http:Client rpcClient;
    private final map<string> methods = {};

    public function init(http:Client rpcClient, string jsonFilePath, string address) returns error? {
        self.rpcClient = rpcClient;
        self.address = address;
    }

    // Call view function (read-only, eth_call)
    public function callViewFunction(string functionHash, json[] params) returns json|error {
        string functionSelector = functionHash.substring(0, 8);

        string encodedParams = self.encodeParameters(params);

        string data = "0x" + functionSelector + encodedParams;

        io:println("data: ", data);

        json requestBody = {
            "jsonrpc": "2.0",
            "method": "eth_call",
            "params": [
                {
                    "to": self.address,
                    "data": data
                },
                "latest"
            ],
            "id": 1
        };

        json response = check self.rpcClient->post("/", requestBody);
        map<json>|error responseMap = response.ensureType();
        if responseMap is error {
            return error("Invalid response.");
        }

        string|error result = responseMap.get("result").ensureType(string);

        if result is error {
            return error("Invalid response.");
        }

        return result;
    }

    // Call state-changing function (eth_sendTransaction)
    public function callSetFunction(string functionHash, string fromAddress, json[] params, string gas, string gasPrice) returns json|error {
        string functionSelector = functionHash.substring(0, 8);

        string encodedParams = self.encodeParameters(params);

        string data = "0x" + functionSelector + encodedParams;

        io:println("data: ", data);

        json requestBody = {
            "jsonrpc": "2.0",
            "method": "eth_sendTransaction",
            "params": [
                {
                    "from": fromAddress,
                    "to": self.address,
                    "gas": gas,
                    "data": data
                }
            ],
            "id": 1
        };

        json response = check self.rpcClient->post("/", requestBody);

        map<json>|error responseMap = response.ensureType();
        if responseMap is error {
            return error("Invalid response.");
        }

        io:println("response: ", responseMap);

        string|error result = responseMap.get("result").ensureType(string);

        if result is error {
            return error("Invalid response.");
        }

        return result;
    }

    // Function to estimate gas fee (eth_estimateGas)
    public function estimateGasFee(string functionHash, string fromAddress, json[] params) returns int|error {
        string functionSelector = functionHash.substring(0, 8);

        string encodedParams = self.encodeParameters(params);

        string data = functionSelector + encodedParams;

        json requestBody = {
            "jsonrpc": "2.0",
            "method": "eth_estimateGas",
            "params": [
                {
                    "from": fromAddress,
                    "to": self.address,
                    "data": data
                }
            ],
            "id": 1
        };

        json|error response = check self.rpcClient->post("/", requestBody);

        map<json>|error responseMap = response.ensureType();
        if responseMap is error {
            return error("Invalid response.");
        }

        string|error result = responseMap.get("result").ensureType(string);

        if result is error {
            return error("Invalid response.");
        }

        return int:fromHexString(result);

    }

    // Function to encode parameters
    function encodeParameters(json[] params) returns string {
        string encodedParams = "";
        foreach var param in params {
            string paramEncoded = "";
            if param is int {
                // Encode integer as 64-character hex string
                paramEncoded = param.toHexString().padStart(64, "0");
            } else if param is string {
                if param.startsWith("0x") && param.length() == 42 {
                    // Address (20-byte) encoding
                    paramEncoded = param.substring(2).padStart(64, "0");
                } else {
                    // String encoding
                    paramEncoded = self.stringToHex(param).padStart(64, "0");
                }
            } else if param is boolean {
                // Encode boolean as 1 (true) or 0 (false)
                paramEncoded = param ? "1".padStart(64, "0") : "0".padStart(64, "0");
            } else {
                io:println("Unsupported parameter type");
            }

            encodedParams += paramEncoded;
        }
        return encodedParams;
    }

    // Helper function to convert a string to hexadecimal (UTF-8 encoding)
    function stringToHex(string value) returns string {
        string hexString = "";
        foreach var ch in value {
            hexString += int:toHexString(ch.toCodePointInt());
        }
        return hexString;
    }
}
