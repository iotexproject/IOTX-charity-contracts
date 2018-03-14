pragma solidity ^0.4.19;

import "./Ownable.sol";

/**
 * @title Donate
 * @dev Donate is a base contract for managing a donation,
 */
contract Donate is Ownable {
  address public charity;
  uint256 public openingTime;
  uint256 public closingTime;
  uint256 public minWeiAmount;
  uint256 public maxWeiAmount;
  uint256 public maxNumDonors;

  address[] public donors;

  mapping(address => bool) public whitelist;

  bool paused;

  event Donated(address indexed donor, uint256 amount);

  /**
   * @param _charity Address where collected funds will be forwarded to
   * @param _openingTime Donate opening time
   * @param _closingTime Donate closing time
   * @param _minWeiAmount minimun donation amount
   * @param _maxWeiAmount maximum donation amount
   * @param _maxNumDonors maximum number of donors
  */
  function Donate(address _charity, uint256 _openingTime, uint256 _closingTime, uint256 _minWeiAmount, uint256 _maxWeiAmount, uint256 _maxNumDonors) public {
    require(_charity != address(0));
    require(_closingTime > _openingTime);
    require(_minWeiAmount > 0);
    require(_maxWeiAmount > _minWeiAmount);
    require(_maxNumDonors > 0);

    charity = _charity;
    openingTime = _openingTime;
    closingTime = _closingTime;
    minWeiAmount = _minWeiAmount;
    maxWeiAmount = _maxWeiAmount;
    maxNumDonors = _maxNumDonors;
  }

  // -----------------------------------------
  // External interface
  // -----------------------------------------

  /**
   * @dev fallback function ***DO NOT OVERRIDE***
   */
  function () external payable {
    donate(msg.sender);
  }

  /**
   * @dev low level donation
   * @param _donor Address performing the donation
   */
  function donate(address _donor) public payable {
    _preValidateDonate(_donor, msg.value);

    charity.transfer(msg.value);
    donors.push(_donor);

    Donated(msg.sender, msg.value);
  }

  /**
   * @dev Adds single address to whitelist.
   * @param _donor Address to be added to the whitelist
   */
  function addToWhitelist(address _donor) external onlyOwner {
    whitelist[_donor] = true;
  }
  
  /**
   * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing. 
   * @param _donors Addresses to be added to the whitelist
   */
  function addManyToWhitelist(address[] _donors) external onlyOwner {
    for (uint256 i = 0; i < _donors.length; i++) {
      whitelist[_donors[i]] = true;
    }
  }

  /**
   * @dev Removes single address from whitelist. 
   * @param _donor Address to be removed to the whitelist
   */
  function removeFromWhitelist(address _donor) external onlyOwner {
    whitelist[_donor] = false;
  }

  function pause() public onlyOwner {
    paused = true;
  }

  function unpause() public onlyOwner {
    paused = false;
  }

  // -----------------------------------------
  // Internal interface (extensible)
  // -----------------------------------------

  /**
   * @dev Validation of an incoming donation. Use require statemens to revert state when conditions are not met. Use super to concatenate validations.
   * @param _donor Address performing the donation
   * @param _weiAmount Value in wei involved in the donation
   */
  function _preValidateDonate(address _donor, uint256 _weiAmount) internal {
    require(now >= openingTime && now <= closingTime);
    require(!paused);
    require(donors.length <= maxNumDonors);
    require(whitelist[_donor]);
    require(_donor != address(0));
    require(minWeiAmount <= _weiAmount && _weiAmount <= maxWeiAmount);
  }
}
