const {assert} = require("chai");
const KryptoBirdz = artifacts.require("KryptoBirdz");
// check for chai
require("chai").use(require("chai-as-promised")).should();

contract("KryptoBirdz", (accounts) => {
  let contract;

  beforeEach(async () => {
    contract = await KryptoBirdz.deployed();
  });

  //testing container - describe

  describe("deployment", async () => {
    it("deploys successfuly", async () => {
      const address = contract.address;
      assert.notEqual(address, "");
      assert.notEqual(address, null);
      assert.notEqual(address, undefined);
      assert.notEqual(address, 0x0);
    });
  });

  describe("#getters", async () => {
    it("Should name be 'KriptoBirdz'", async () => {
      const name = await contract.name();
      assert.equal(name, "KriptoBirdz");
    });
    it("Should symbol be 'KBIRDZ'", async () => {
      const name = await contract.symbol();
      assert.equal(name, "KBIRDZ");
    });
  });

  describe("minting", async () => {
    it("Should create a new token successfully", async () => {
      const result = await contract.mint("https...1");
      const totalSupply = await contract.totalSupply();
      assert.equal(totalSupply, 1);
      const event = result.logs[0].args;
      assert.equal(
        event._from,
        "0x0000000000000000000000000000000000000000",
        `from is zero address`
      );
      assert.equal(event._to, accounts[0], "to is msg.sender");
    });

    it("Should fail when try to creates a new token already created", async () => {
      await contract.mint("https...1");
      await contract.mint("https...1").should.be.rejected;
      const totalSupply = await contract.totalSupply();
      assert.equal(totalSupply, 1);
    });
  });

  describe("#indexing", async () => {
    it("Should list all KryptoBridz", async () => {
      await contract.mint("https...2");
      await contract.mint("https...3");
      await contract.mint("https...4");
      const totalSupply = await contract.totalSupply();

      let result = [];
      let bird;
      for (let i = 0; i < totalSupply; i++) {
        bird = await contract.kryptoBirdz(i);
        result.push(bird);
      }
      let expected = ["https...1", "https...2", "https...3", "https...4"];
      assert.equal(result.join(","), expected.join(","));
    });
  });
});
