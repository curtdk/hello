
pragma solidity >= 0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";



contract dkContract {
    IERC20 myToken;

  
    /**
     * Contract initialization.
     */
    constructor(address _tokenAddress) {
        myToken=IERC20(_tokenAddress);
        // balances[msg.sender] = totalSupply;
        // owner = msg.sender;
    }

    function transFrom(uint256 _amount) external {
        myToken.transferFrom(msg.sender,address(this),_amount);

    }
    function balanceOf(address account) external view returns (uint256) {
        return  myToken.balanceOf(account);
    }



    // function transfer(address to, uint256 amount) external {
    //     // Check if the transaction sender has enough tokens.
    //     // If `require`'s first argument evaluates to `false` then the
    //     // transaction will revert.
    //     require(balances[msg.sender] >= amount, "Not enough tokens");

    //     // We can print messages and values using console.log, a feature of
    //     // Hardhat Network:
    //     console.log(
    //         "Transferring from %s to %s %s tokens",
    //         msg.sender,
    //         to,
    //         amount
    //     );

    //     // Transfer the amount.
    //     balances[msg.sender] -= amount;
    //     balances[to] += amount;

    //     // Notify off-chain applications of the transfer.
    //     emit Transfer(msg.sender, to, amount);
    // }


}
