import ballerina/http;

// Function to send a responce with JSON
public function jsonResponse(http:Caller caller, json payload, int statusCode) returns error? {
    http:Response resp = new;
    resp.setJsonPayload(payload);
    resp.statusCode = statusCode;
    check caller->respond(resp);
}

// Function to convert a hexadecimal string to a regular string
function hexToString(string hex) returns string|error {
    string result = "";
    foreach int i in int:range(0, hex.length(), 2) {
        string hexPair = hex.substring(i, i + 2);
        int byteValue = check int:fromHexString(hexPair);
        result += check string:fromCodePointInt(byteValue);
    }
    return result;
}

public function decodeData(string response) returns json|error {
    json[] listedNFTs = [];

    // Remove the leading '0x'
    string abiResponse = response.substring(2);

    // Extract the number of NFTs
    string numberOfNFTsHex = abiResponse.substring(64, 128);

    int numberOfNFTs = check int:fromString(numberOfNFTsHex.trim());

    int offset = 128 + 64 * numberOfNFTs; // skip metadata

    // Iterate over each NFT
    foreach int i in 0 ... numberOfNFTs - 1 {

        // Extract Token ID
        string tokenIDHex = abiResponse.substring(offset, offset + 64);
        int tokenID = check int:fromString(tokenIDHex.trim());

        // // Move to next field (Price)
        offset += 128;

        // // Extract Price
        string priceHex = abiResponse.substring(offset, offset + 64);
        int priceWei = check int:fromHexString(priceHex.trim());

        // Move to next field (URI length + URI)
        offset += 64;

        // // Extract Token URI length
        string uriLengthHex = abiResponse.substring(offset, offset + 64);
        int uriLength = check int:fromHexString(uriLengthHex.trim());

        // Move to the actual URI data (hex encoded string)
        offset += 64;
        string tokenURIHex = abiResponse.substring(offset, offset + (uriLength * 2));

        string tokenURI = check hexToString(tokenURIHex);

        json nftData = {
            "tokenID": tokenID,
            "priceWei": priceWei,
            "tokenURI": tokenURI
        };

        listedNFTs.push(nftData);

        offset += (uriLength * 2 + 56);
    }

    return listedNFTs;
}
