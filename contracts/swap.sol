pragma solidity 0.8.13;
// SPDX-License-Identifier: MIT

library Address {
    function isContract(address account) internal view returns (bool) {
        bytes32 codehash;
        // 空字符串hash值
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        //内联编译（inline assembly）语言，是用一种非常底层的方式来访问EVM
        assembly {codehash := extcodehash(account)}
        return (codehash != accountHash && codehash != 0x0);
    }
}

library SafeERC20 {
    using Address for address;
    function safeTransfer(ERC20 token, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(ERC20 token, address spender, uint256 value) internal {
        require((value == 0) || (token.allowance(address(this), spender) == 0), "SafeERC20: approve from non-zero to non-zero allowance");
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function callOptionalReturn(ERC20 token, bytes memory data) private {
        require(address(token).isContract(), "SafeERC20: call to non-contract");
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");
        if (returndata.length > 0) {
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

interface ERC20 {
    function decimals() external view returns (uint8);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
// 安全的数学计算库
library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;
        assert(c >= a);
        return c;
    }
}

contract swap {
    using SafeERC20 for ERC20;
    address private owner;
    //a代币合约地址
    ERC20 public _aToken = ERC20(0x1C01B630E32303a03d04F52c4bE944ba04706BDF);
    //b代币合约地址
    ERC20 public _toToken = ERC20(0x03842fB1DA26647F5bEeF727d5Ec73bfaDAEA7a2);
    //u最少数量
    uint256 public _minAmount = 1000;
    //设置兑换黑名单
    mapping(address => bool) private blacklist;
    //设置价格
    uint public price;

    event swapToken(address from, uint amount, uint price);
    constructor ()  {
        owner = msg.sender;
        price = 1000;
    }
    //兑换approve方法 获取授权
    event exchangeTokenlgo(uint _id,address from, uint balance);

    function exchangeToken(uint256 _amount) public {
        require(_amount >= _minAmount, "amount too little");
        require(_amount >= price, "amount too little");
        //将a转入合约
        _aToken.transferFrom(msg.sender, address(this), SafeMath.mul(_amount, 10**_aToken.decimals()));
         
        //查询b余额
        uint balance = _toToken.balanceOf(address(this));
        //计算应支付数量乘精度
        uint toAmount = SafeMath.mul(SafeMath.div(_amount, price), 10**_toToken.decimals());
        //判断余额是否充足
        require(balance > toAmount, 'Insufficient balance');
        //发送代币
        _toToken.safeTransfer(address(msg.sender), toAmount);
        //记录事件
        emit swapToken(msg.sender, _amount, price);
        emit exchangeTokenlgo(1, address(this), balance);
    }
    function setOwner(address paramOwner) public onlyOwner {
        owner = paramOwner;
    }
    function setPrice(uint256 _price) public onlyOwner {
        price = _price;
    }
    function setMinAmount (uint256 minAmount_) public onlyOwner {
        _minAmount = minAmount_;
    }
    //提出代币
    function withdraw(address _token, address _to, uint256 _amount) public onlyOwner {
        require(ERC20(_token).balanceOf(address(this)) >= _amount, "no balance");
        ERC20(_token).safeTransfer(_to, _amount);
    }
    //提出全部代币
    function withdrawAll(address _token, address _to) public onlyOwner {
        ERC20(_token).safeTransfer(_to, ERC20(_token).balanceOf(address(this)));
    }
    //提现主币
    function withdraw() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }


    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }
    function getOwner() public view returns (address) {
        return owner;
    }

}