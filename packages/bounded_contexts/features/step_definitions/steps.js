const { Given, When, Then } = require('@cucumber/cucumber');
const {getSwaggerClients, getBaFactory, getUserFactory} = require("./global_hooks");
const {callSubgraph} = require("@gridql/server/lib/graph/callgraph");
const assert = require("assert");

// Use a function or a class to store shared state
function UtilityWorld() {
    this.user_id = null;
    this.user = null;
    this.account = null;
    this.account_id = null;
    this.account_link = null;
}

Given('I have a new user', async function () {
    let user = getUserFactory()();

    let userApi = getSwaggerClients()["/user/api"];

    const result = await userApi.create(null, user);

    UtilityWorld.user_id = result.request.path.slice(-36);
    UtilityWorld.user = result.data
});

Given('I have a new account', async function () {
    let billing_account = getBaFactory()()
    let swaggerClient = getSwaggerClients()["/billing_account/api"];

    const result = await swaggerClient.create(null, billing_account).catch((e) => {
        console.log("Account error: ", e)
        throw e
    });

    UtilityWorld.account_id = result.request.path.slice(-36);
    UtilityWorld.account = result.data
});

When('I bind the user to the account', async function () {
    let account_link = {
        user_id: UtilityWorld.user_id,
        billing_account_id: UtilityWorld.account_id
    }

    let swaggerClient = getSwaggerClients()["/account_link/api"];

    let result = await swaggerClient.create(null, account_link).catch((e) => {
        console.log("Account Link Error:", e);
        throw e;
    } );

    UtilityWorld.account_link = result.data;
});

Then('I should be able to query the user and account details via GraphQL', async function () {
    const query = `{
         getById(id: "${UtilityWorld.user_id}") {
               firstName
               accounts {
                billingAccount{
                    accountNumber
                }
               }
            }
        }`;

    const json = await callSubgraph("http://localhost:3000/user/graph", query, "getById");

    console.log(JSON.stringify(json, null, 4))
    assert.equal(json.firstName, UtilityWorld.user.firstName)
    assert.equal(json.accounts[0].billingAccount.accountNumber, UtilityWorld.account.accountNumber)
});
