const {build_app, parse} = require("@gridql/server");
const {swagger} = require("@gridql/server/lib/swagger");
const {OpenAPIClientAxios} = require("openapi-client-axios");
const {builderFactory} = require("@gridql/payload-generator")
const assert = require("assert");
const {MongoMemoryServer} = require("mongodb-memory-server");
const {callSubgraph} = require("@gridql/server/lib/graph/callgraph");


let mongod;
let server;
let swagger_clients = {};
let config;

let user_id;
let billing_account_id;
let user;
let billing_account;

before(async function (){
    this.timeout(10000);

    mongod = await MongoMemoryServer.create();

    process.env.MONGO_URI = mongod.getUri();

    let configFile = __dirname + "/../config/config.conf";

    config = await parse(configFile);
    let app = await build_app(config);

    server = app.listen(config.port)

    for(let restlette of config.restlettes){
        let swaggerdoc = swagger(restlette.path, restlette.schema, config.url)
        let api = new OpenAPIClientAxios({ definition: swaggerdoc });
        swagger_clients[restlette.path] = await api.init()
    }

});

describe("Linking an account to a user", function(){

    it("should create a user", async () =>{

        let user_factory = builderFactory(config.restlettes[0].schema)
        user = user_factory()

        const result = await swagger_clients["/user/api"].create(null, user);

        assert.equal(result.status, 200);
        assert.equal(result.data.firstName, user.firstName);

        user_id = result.request.path.slice(-36);
    })

    it("should create a billing account", async () =>{

        let ba_factory = builderFactory(config.restlettes[1].schema)
        billing_account = ba_factory()

        const result = await swagger_clients["/billing_account/api"].create(null, billing_account);

        assert.equal(result.status, 200);
        assert.equal(result.data.accountNumber, billing_account.accountNumber);

        billing_account_id = result.request.path.slice(-36);
    })

    it("should create an account link", async () =>{

        let account_link = {
            user_id, billing_account_id
        }

        const result = await swagger_clients["/account_link/api"].create(null, account_link);

        assert.equal(result.status, 200);
        assert.equal(result.data.user_id, account_link.user_id);
    })

    it("should query the user graph", async () => {
        const query = `{
         getById(id: "${user_id}") {
               firstName
               accounts {
                billingAccount{
                    accountNumber
                }
               }
            }
        }`;

        const json = await callSubgraph("http://localhost:3000/user/graph", query, "getById");

        assert.equal(json.firstName, user.firstName)
        assert.equal(json.accounts[0].billingAccount.accountNumber, billing_account.accountNumber)
    })

    it("should query the billing graph", async () => {
        const query = `{
         getById(id: "${billing_account_id}") {
               accountNumber
               users {
                user{
                    firstName
                }
               }
            }
        }`;

        const json = await callSubgraph("http://localhost:3000/billing_account/graph", query, "getById");

        assert.equal(json.users[0].user.firstName, user.firstName)
        assert.equal(json.accountNumber, billing_account.accountNumber)
    })
});

