pragma solidity >=0.6.0 <0.7.0;

contract ExampleExternalContract {
  
  address public owner;
  bool public completed;

  constructor() public {
  	owner = msg.sender;
    completed = false;
  }

  function complete() public payable {
    completed = true;
  }

  function withdraw() public payable onlyOwner {
    require(completed, "Cant withdraw until completed is true");
    uint256 amount = address(this).balance;
    require(amount>0, "Cant withdraw this address didnt have stake");
    msg.sender.transfer(amount);
  }

  function reset() public onlyOwner {
    completed = false;
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

}
