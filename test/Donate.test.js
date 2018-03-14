const Donate = artifacts.require('Donate');

contract('Donate', function ([owner, donor, donor2, donor3, stranger, charity]) {
  beforeEach(async function () {
    this.donate = await Donate.new(charity, 1521006453, 1621904919, web3.toWei(0.2, 'ether'), web3.toWei(3, 'ether'), 2);
    await this.donate.addToWhitelist(donor);
    await this.donate.addToWhitelist(donor2);
  	await this.donate.addToWhitelist(donor3);
  });



  it('should accept donations from a whitelisted donor', async function () {
    balanceBefore = web3.eth.getBalance(charity).toNumber()

    await this.donate.sendTransaction({ value: 1e+18, from: donor });
    assert.equal(web3.eth.getBalance(charity).toNumber(), balanceBefore + 1e+18)

    await this.donate.sendTransaction({ value: 0.4e+18, from: donor2 });
    assert.equal(web3.eth.getBalance(charity).toNumber(), balanceBefore + 1e+18 + 0.4e+18)

    // can accept up to two donors
    try {
      await this.donate.sendTransaction({ value: 0.4e+18, from: donor3 });
      assert.fail()
	} catch (error) {}
  });

  it('should fail to accept donations to a stranger', async function () {
    try {
      await this.donate.sendTransaction({ value: 1e+18, from: stranger });
      assert.fail()
	} catch (error) {}
  });

  it('should fail to accept donations since it is too much', async function () {
    try {
      await this.donate.sendTransaction({ value: 8e+18, from: donor });
      assert.fail()
	} catch (error) {}
  });


  it('should fail to accept donations since it is too little', async function () {
    try {
      await this.donate.sendTransaction({ value: 0.1e+18, from: donor });
      assert.fail()
	} catch (error) {}
  });

  it('should fail to accept donations if the contract is paused', async function () {
  	await this.donate.pause()

    try {
      await this.donate.sendTransaction({ value: 0.4e+18, from: donor });
      assert.fail()
	} catch (error) {}

	await this.donate.unpause()
    await this.donate.sendTransaction({ value: 0.4e+18, from: donor });
  });

  it('should correctly report whitelisted addresses', async function () {
    assert.equal(await this.donate.whitelist("0x1234567890abcdef10234567890abcdef0123456"), false);

    await this.donate.addToWhitelist("0x1234567890abcdef10234567890abcdef0123456");
    assert.equal(await this.donate.whitelist("0x1234567890abcdef10234567890abcdef0123456"), true);

    await this.donate.removeFromWhitelist("0x1234567890abcdef10234567890abcdef0123456");
    assert.equal(await this.donate.whitelist("0x1234567890abcdef10234567890abcdef0123456"), false);
  });

});