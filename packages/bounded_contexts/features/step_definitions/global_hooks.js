const { BeforeAll, AfterAll, setDefaultTimeout } = require('@cucumber/cucumber');
const { DockerComposeEnvironment } = require("testcontainers");
const {MongoMemoryServer} = require("mongodb-memory-server");
const {init} = require("@gridql/server");
const {swagger} = require("@gridql/server/lib/swagger");
const {OpenAPIClientAxios} = require("openapi-client-axios");
const {builderFactory} = require("@gridql/payload-generator");
const fs = require('fs');
const assert = require("assert");

let environment;

let swagger_clients = {};

setDefaultTimeout(30000)

const getSwaggerClients = () => {
    return swagger_clients;
}


const readJSON = (path) => {
    try {
        // Read file synchronously
        const rawData = fs.readFileSync(path, 'utf8');
        // Parse the JSON data
        return  JSON.parse(rawData);
    } catch (error) {
        console.error('Error reading file:', error);
    }
}


const getUserFactory = () => {
    //pull the json file from config
    return builderFactory(readJSON(__dirname + "/../../config/json/user.schema.json"))
}

const getBaFactory = () => {
    //pull the json file from config
    return builderFactory(readJSON(__dirname + "/../../config/json/billing_account.schema.json"))
}
BeforeAll(async () => {
    environment = await new DockerComposeEnvironment(__dirname )
        .withBuild(true)
        .up();

    for(let restlette of ["user", "billing_account", "account_link"]){
        let rest = await fetch(`http://localhost:3000/${restlette}/api/api-docs/swagger.json`)
        let swaggerdoc = await rest.json();
        let api = new OpenAPIClientAxios({ definition: swaggerdoc });
        swagger_clients[`/${restlette}/api`] = await api.init()
    }
})

module.exports = {
   environment, getSwaggerClients, getUserFactory, getBaFactory
}