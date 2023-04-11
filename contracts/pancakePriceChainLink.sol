// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.7;

// import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";



// contract PriceConsumerV3 is Ownable {
//     mapping(address => AggregatorV3Interface) internal priceFeedMap;

//     function setPriceFeed(address token, address priceFeed) external onlyOwner {
//         priceFeedMap[token] = AggregatorV3Interface(priceFeed);
//     }

//     /**
//      * Returns the latest price
//      */
//     function getLatestPrice(address token) public view returns (int) {
//         (
//             uint80 roundID, 
//             int price,
//             uint startedAt,
//             uint timeStamp,
//             uint80 answeredInRound
//         ) = priceFeedMap[token].latestRoundData();
//         return price;
//     }



//     function createPair(address tokenA, address tokenB) external returns (address pair) {
//     require(tokenA != tokenB, 'UniswapV2: IDENTICAL_ADDRESSES');
//     (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
//     require(token0 != address(0), 'UniswapV2: ZERO_ADDRESS');
//     require(getPair[token0][token1] == address(0), 'UniswapV2: PAIR_EXISTS'); // single check is sufficient
//     bytes memory bytecode = type(UniswapV2Pair).creationCode;
//     bytes32 salt = keccak256(abi.encodePacked(token0, token1));
//     assembly {
//         pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
//     }
//     IUniswapV2Pair(pair).initialize(token0, token1);
//     getPair[token0][token1] = pair;
//     getPair[token1][token0] = pair; // populate mapping in the reverse direction
//     allPairs.push(pair);
//     emit PairCreated(token0, token1, pair, allPairs.length);
// }



// }