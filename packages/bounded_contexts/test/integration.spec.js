const {init, start} = require("@gridql/server");
const {swagger} = require("@gridql/server/lib/swagger");
const {OpenAPIClientAxios} = require("openapi-client-axios");
const {builderFactory} = require("@gridql/payload-generator")
const assert = require("assert");
const {MongoMemoryServer} = require("mongodb-memory-server");


let mongod;
let server;
let swagger_clients = {};
let config;

let user_id;

before(async function (){
    this.timeout(10000);

    mongod = await MongoMemoryServer.create();

    process.env.MONGO_URI = mongod.getUri();

    let configFile = __dirname + "/../config/config.conf";

    config = await init(configFile);

    server = await start(
        config.url,
        config.port,
        config.graphlettes,
        config.restlettes
    );

    for(let restlette of config.restlettes){
        let swaggerdoc = swagger(restlette.path, restlette.schema, config.url)
        let api = new OpenAPIClientAxios({ definition: swaggerdoc });
        swagger_clients[restlette.path] = await api.init()
    }

});

describe("Linking an account to a user", function(){

    it("should create a user", async () =>{

        let user_factory = builderFactory(config.restlettes[0].schema)
        let user = user_factory()

        const result = await swagger_clients["/user/api"].create(null, user);

        assert.equal(result.status, 200);
        assert.equal(result.data.firstName, user.firstName);
        assert(result.data._id !== undefined);

        user_id = result.data._id;
    })

    it("should create a billing account", async () =>{

        let ba_factory = builderFactory(config.restlettes[1].schema)
        let billing_account = ba_factory()

        const result = await swagger_clients["/billing_account/api"].create(null, billing_account);

        assert.equal(result.status, 200);
        assert.equal(result.data.accountNumber, billing_account.accountNumber);
        assert(result.data._id !== undefined);

        user_id = result.data._id;
    })

});

