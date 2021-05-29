pragma solidity >=0.6.0 <0.7.0;

import "hardhat/console.sol";
import "./ExampleExternalContract.sol"; //https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
import "@openzeppelin/contracts/math/SafeMath.sol";

contract Staker {

  ExampleExternalContract public exampleExternalContract;
  address public owner;
  uint256 public threshold;
  uint256 public deadline;
  mapping ( address => uint256 ) public balances;

  constructor(address exampleExternalContractAddress) public {
    owner = msg.sender;
    exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
    threshold = 1 ether;
    deadline = now + 1 minutes;
    start = true;
  }

  // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
  //  ( make sure to add a `Stake(address,uint256)` event and emit it for the frontend <List/> display )
  event Stake(address _add,uint256 _amount);

  function stake() public payable timePassed {
    require(msg.value> (0.01*10**18), "enter amount > 0.01");
    emit Stake(msg.sender, msg.value);
    balances[msg.sender] += msg.value;
  }

  // After some `deadline` allow anyone to call an `execute()` function
  //  It should either call `exampleExternalContract.complete{value: address(this).balance}()` to send all the value
  
  bool public completed;
  bool public failed;
  bool public start;

  function execute() public notFailed notCompleted timeInProgress{
    if( address(this).balance >= threshold ){
      exampleExternalContract.complete{value: address(this).balance}();
      completed = true;
    } else {
      failed = true;
    }
    start = false;
  }

  // if the `threshold` was not met, allow everyone to call a `withdraw()` function
  function withdraw(address payable _add) public notCompleted timeInProgress{
    // require(failed, "Cant withdraw until execute fails");
    uint256 amount = balances[_add];
    require(amount>0, "Cant withdraw this address didnt have stake");
    balances[_add] = 0;
    _add.transfer(amount);
  }


  // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend
  function timeLeft() public view returns (uint256) {
    if(now>deadline) return 0;
    return deadline - now;
  }

  function reStart(uint _m, uint _t) public notStart {
    require(_m >= 1 && _m<=120, "time >= 1 and <= 120minutes");
    require(_t >=1 && _t<=5, " threshold >=1 and <=5");
    completed = false;
    failed = false;
    start = true;
    threshold = _t * 1 ether;
    deadline = now + _m * 1 minutes;
  }

  // Modifier to check that the caller is the owner of
  // the contract.
  modifier onlyOwner() {
      require(msg.sender == owner, "Not owner");
      // Underscore is a special character only used inside
      // a function modifier and it tells Solidity to
      // execute the rest of the code.
      _;
  }

  // Modifiers can take inputs. This modifier checks that the
  // address passed in is not the zero address.
  modifier validAddress(address _addr) {
      require(_addr != address(0), "Not valid address");
      _;
  }

  // Can you implement your own modifier that checks whether deadline was passed or not? 
  // Where can you use it?
  modifier timePassed() {
    require(now<=deadline, "deadline Passed");
     _;
  }
  modifier timeInProgress() {
    require(now>=deadline, "staking is still on");
     _;
  }

  // Try to create a modifier called notCompleted. 
  // It will check that ExampleExternalContract is not completed yet. 
  // Use it to protect your execute and withdraw functions.
  modifier notFailed() {
    require(!failed, "staking failed");
    _;
  }
  modifier notCompleted() {
    require(!completed, "staking completed");
    _;
  }
  modifier notStart() {
    require(!start, "start completed");
    _;
  }

  fallback() external payable {

  }

  receive() external payable  {

  }

}
