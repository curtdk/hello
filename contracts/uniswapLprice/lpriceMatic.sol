
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import '../utils/HomoraMath.sol';
interface IPancakeRouter01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IUniswapV2Pair {
  event Approval(address indexed owner, address indexed spender, uint value);
  event Transfer(address indexed from, address indexed to, uint value);

  function name() external pure returns (string memory);

  function symbol() external pure returns (string memory);

  function decimals() external pure returns (uint8);

  function totalSupply() external view returns (uint);

  function balanceOf(address owner) external view returns (uint);

  function allowance(address owner, address spender) external view returns (uint);

  function approve(address spender, uint value) external returns (bool);

  function transfer(address to, uint value) external returns (bool);

  function transferFrom(
    address from,
    address to,
    uint value
  ) external returns (bool);

  function DOMAIN_SEPARATOR() external view returns (bytes32);

  function PERMIT_TYPEHASH() external pure returns (bytes32);

  function nonces(address owner) external view returns (uint);

  function permit(
    address owner,
    address spender,
    uint value,
    uint deadline,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) external;

  event Mint(address indexed sender, uint amount0, uint amount1);
  event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
  event Swap(
    address indexed sender,
    uint amount0In,
    uint amount1In,
    uint amount0Out,
    uint amount1Out,
    address indexed to
  );
  event Sync(uint112 reserve0, uint112 reserve1);

  function MINIMUM_LIQUIDITY() external pure returns (uint);

  function factory() external view returns (address);

  function token0() external view returns (address);

  function token1() external view returns (address);

  function getReserves()
    external
    view
    returns (
      uint112 reserve0,
      uint112 reserve1,
      uint32 blockTimestampLast
    );

  function price0CumulativeLast() external view returns (uint);

  function price1CumulativeLast() external view returns (uint);

  function kLast() external view returns (uint);

  function mint(address to) external returns (uint liquidity);

  function burn(address to) external returns (uint amount0, uint amount1);

  function swap(
    uint amount0Out,
    uint amount1Out,
    address to,
    bytes calldata data
  ) external;

  function skim(address to) external;

  function sync() external;

  function initialize(address, address) external;
}

contract Params is Initializable,OwnableUpgradeable {
     using SafeMath for uint;
  using HomoraMath for uint;    	

     function initialize(address token)public initializer{
		__Context_init_unchained();
		__Ownable_init_unchained(token);//初始化 管理者      
        _lpToken = 0x040185DeF03011d056a3D9beBcB8713f10303e70; //lp pancake  ymii/usdt  
        _pancakeRouter = 0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff;  //pancake Router 地址       
        _usdtPrice=1000000000000000000;
        t_wei=14;
	}       
    string public words; // 字符串，可以通过逻辑合约的函数改变   
    address public _lpToken; //ymii/usdt lp token    
    uint public t_wei;//去掉14位保留4位
    uint256 _usdtPrice;//代表 1u
    address _pancakeRouter ;//pancake Router 地址
    mapping(string => uint256) private uint256Params;
    event Uint256ParamSetted(string indexed _key,uint256 _value);
    function SetUint256Param(string memory _key,uint256 _value) external onlyOwner{
        uint256Params[_key] = _value;
        emit Uint256ParamSetted(_key,_value);
    }
    function GetUint256Param(string memory _key)public view returns(uint256){
        return uint256Params[_key];
    } 
     //_lpToken
    function set_lpToken(address t_addr) public onlyOwner {
        _lpToken = t_addr;
    }
    //设置usdtPrice
    function set_usdtPrice(uint256 t_Price) public onlyOwner {
        _usdtPrice = t_Price;
    }
    //设置pancakeRouter
    function set_pancakeRouter(address t_addr) public onlyOwner {
        _pancakeRouter = t_addr;
    } 

    //_LP_ymiiUsdt
    function set_t_wei(uint256 t_int) public onlyOwner {
        t_wei = t_int;
    }   

    function getTokenPriceLV(address t_pair) external view  returns (uint) {      
        (uint r0, uint r1, ) = IUniswapV2Pair(t_pair).getReserves();   
        //算出阿来 px0  px1   
        // address _pancakeRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
        uint px0=IPancakeRouter01(_pancakeRouter).getAmountOut(_usdtPrice,r0,r1); 
        return px0;
    }

    function getTokenPrice(address t_pair) external view  returns (uint) {  
    (uint r0, uint r1, ) = IUniswapV2Pair(t_pair).getReserves();  
    //算出阿来 px0  px1
    uint px0=IPancakeRouter01(_pancakeRouter).getAmountIn(_usdtPrice,r0,r1);    
    return px0;
  }

   function lpPrice() public view returns (uint256) {

    uint totalSupply = IUniswapV2Pair(_lpToken).totalSupply();
    (uint r0, uint r1, ) = IUniswapV2Pair(_lpToken).getReserves();
    uint sqrtK = HomoraMath.sqrt(r0.mul(r1)).fdiv(totalSupply); // in 2**112
    //算出阿来 px0  px1
    uint px0=IPancakeRouter01(_pancakeRouter).getAmountIn(_usdtPrice,r0,r1);
    uint px1=_usdtPrice;
    // uint px0 = base.getETHPx(token0); // in 2**112
    // uint px1 = base.getETHPx(token1); // in 2**112
    // fair token0 amt: sqrtK * sqrt(px1/px0)
    // fair token1 amt: sqrtK * sqrt(px0/px1)
    // fair lp price = 2 * sqrt(px0 * px1)
    // split into 2 sqrts multiplication to prevent uint overflow (note the 2**112)
    uint t_p= sqrtK.mul(2).mul(HomoraMath.sqrt(px0)).div(2**56).mul(HomoraMath.sqrt(px1)).div(2**56);
    uint t_p_1 = t_p/(10**t_wei);//0
    return t_p_1;
    // return sqrtK.mul(2).mul(HomoraMath.sqrt(px0)).div(2**56).mul(HomoraMath.sqrt(px1)).div(2**56);
  }

    //得到 去掉 t_wei 默认14位 的 LPPrice 
  function getETHPx(address pair) external view returns (uint) {    
    uint totalSupply = IUniswapV2Pair(pair).totalSupply();
    (uint r0, uint r1, ) = IUniswapV2Pair(pair).getReserves();
    uint sqrtK = HomoraMath.sqrt(r0.mul(r1)).fdiv(totalSupply); // in 2**112
    //算出阿来 px0  px1
    uint px0=IPancakeRouter01(_pancakeRouter).getAmountIn(_usdtPrice,r0,r1);
    uint px1=_usdtPrice;
    // uint px0 = base.getETHPx(token0); // in 2**112
    // uint px1 = base.getETHPx(token1); // in 2**112
    // fair token0 amt: sqrtK * sqrt(px1/px0)
    // fair token1 amt: sqrtK * sqrt(px0/px1)
    // fair lp price = 2 * sqrt(px0 * px1)
    // split into 2 sqrts multiplication to prevent uint overflow (note the 2**112)
    uint t_p= sqrtK.mul(2).mul(HomoraMath.sqrt(px0)).div(2**56).mul(HomoraMath.sqrt(px1)).div(2**56);
    uint t_p_1 = t_p/(10**t_wei);//0
    return t_p_1;
    // return sqrtK.mul(2).mul(HomoraMath.sqrt(px0)).div(2**56).mul(HomoraMath.sqrt(px1)).div(2**56);

  }

  function getTokenPriceYmii(address ymiiWpc,address wpcUsdt) external view  returns (uint) {   

       (uint r0, uint r1, ) = IUniswapV2Pair(ymiiWpc).getReserves();  

        // address _pancakeRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
        uint px0=IPancakeRouter01(_pancakeRouter).getAmountOut(_usdtPrice,r0,r1); 

        (uint L0, uint L1, ) = IUniswapV2Pair(wpcUsdt).getReserves();   
        //算出阿来 px0  px1   
        // address _pancakeRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
        uint Lpx0=IPancakeRouter01(_pancakeRouter).getAmountOut(_usdtPrice,L0,L1); 
        uint ymiiPrice=px0*Lpx0;
        return ymiiPrice;
    }

  




    
}









