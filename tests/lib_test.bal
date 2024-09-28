import ballerina/io;
import ballerina/test;

ETHClient|error ethClient = check new ("http://127.0.0.1:7545");

// Before Suite Function
@test:BeforeSuite
function beforeSuiteFunc() {
    io:println("Starting ETHClient tests.");
}

// Test function for getting accounts
@test:Config {}
function testGetAccounts() returns error? {

    if ethClient is error {
        return error("Failed to create ETHClient.");

    }

}

// After Suite Function
@test:AfterSuite
function afterSuiteFunc() {
    io:println("ETHClient tests completed.");
}
