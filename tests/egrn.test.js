const { expect } = require('chai');
const { ethers } = require('hardhat');

describe("EGRN CONTRACT", function() {
  it("Should deploy EGRN contract", async function() {
    const EGRNContract = await ethers.getContractFactory("EGRN");
    const egrn = await EGRNContract.deploy();
    await egrn.deployed();
    expect(await egrn.name()).to.equal("EGRN");
  });
  it("Should get owner", async function() {
    [owner] = await ethers.getSigners();
    const EGRNContract = await ethers.getContractFactory("EGRN", owner);
    const egrn = await EGRNContract.deploy();
    await egrn.deployed();
    expect(await egrn.owner()).to.equal(owner.address);
  });
  it("Should add new object", async function() {
    const EGRNContract = await ethers.getContractFactory("EGRN");
    const egrn = await EGRNContract.deploy();
    await egrn.deployed();
    await egrn.addNewObject('TestId', 'TestRecordId', 'TestRecord');
    expect(await egrn.checkRecordIdentity('TestId', 'TestRecordId', 'TestRecord')).to.equal(true);
  });
  it("Should not to allow to add new object by not owner", async function() {
    [owner, addr1] = await ethers.getSigners();
    const EGRNContract = await ethers.getContractFactory("EGRN", owner);
    const egrn = await EGRNContract.deploy();
    await egrn.deployed();
    await expect(egrn.connect(addr1).addNewObject('TestId', 'TestRecordId', 'TestRecord')).to.be.revertedWith("NOT AUTHORIZED");
  });
  it("Should add new record", async function() {
    const EGRNContract = await ethers.getContractFactory("EGRN");
    const egrn = await EGRNContract.deploy();
    await egrn.deployed();
    await egrn.addNewObject('TestId', 'TestRecordId1', 'TestRecord');
    await egrn.addNewRecord('TestId', 'TestRecordId2', 'TestRecord');
    expect(await egrn.checkRecordIdentity('TestId', 'TestRecordId1', 'TestRecord')).to.equal(true);
  });
  it("Should check record identity", async function() {
    const EGRNContract = await ethers.getContractFactory("EGRN");
    const egrn = await EGRNContract.deploy();
    await egrn.deployed();
    await egrn.addNewObject('TestId', 'TestRecordId1', 'TestRecord');
    expect(await egrn.checkRecordIdentity('TestId', 'TestRecordId1', 'BadRecord')).to.equal(false);
  });
});