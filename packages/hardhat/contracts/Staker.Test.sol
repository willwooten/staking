//SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.7.0;

import "./test.sol";
import "./Staker.sol";

contract User {
    function doStake(Staker stake, address sender, uint256 amount) external returns (bool) {
        return stake.stake(sender,amount);
    }
}

contract StakerTest is DSTest {


    function stake() public payable timePassed {

        // require value sent into the contract is higher tha, .01 ETH.
        require(msg.value> (0.01*10**18), "enter amount > 0.01");

        // Emit Stake event with sender address and value
        emit Stake(msg.sender, msg.value);

        // track balance of senders stake in the contract
        balances[msg.sender] += msg.value;
        
    }
    
    function test_stake() public {
        stake.doStake(address(this), 2 ether);
        assertEq(balances(address(this)), 2 ether);
    }

}
