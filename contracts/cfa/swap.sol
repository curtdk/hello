// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;
interface ERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address account, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

}

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
    address private owner;
  
    //b代币合约地址                
    ERC20 public _toToken = ERC20(0x7e70cF957E13EF83261b269E3DA8DF5811d4C989);
    //u最少数量
    uint256 public _minAmount = 1;
    //key
    uint256 private _keyValue = 135246789;   

    //设置兑换黑名单
    // mapping(address => bool) private blacklist;
    mapping(address => bool) public _userBlacklist; //黑名单
    event swapToken(address from, uint amount, uint price);
    constructor ()  {
        owner = msg.sender;
    }
     //兑换approve方法 获取授权
    event sendTokenlgo(address send,uint toAmount, uint balance);
    function sendToken(address send,uint256 _amount,uint256 keyValue ) public onlyOwner {
        require(_amount >= _minAmount, "amount too little");      
           //黑名单 
        require(!_userBlacklist[msg.sender], "user is in blacklist");
         require(keyValue==_keyValue, "keyValue is err");
      
        //查询b余额
        uint balance = _toToken.balanceOf(address(this));
        //计算应支付数量乘精度
        // uint toAmount = SafeMath.mul(_amount, 10**_toToken.decimals());
        // uint toAmount = SafeMath.mul(SafeMath.div(_amount, price), 10**_toToken.decimals());
        //判断余额是否充足
        require(balance > _amount, 'Insufficient balance');
        //发送代币
        ERC20(_toToken).transfer(send, _amount);
        //记录事件
        emit sendTokenlgo(send ,_amount, balance);   
      
    }   
    function setOwner(address paramOwner) public onlyOwner {
        owner = paramOwner;
    }
    function setMinAmount (uint256 minAmount_) public onlyOwner {
        _minAmount = minAmount_;
    }  
    //提出代币
    function withdraw(address _token, address _to, uint256 _amount) public onlyOwner {
        require(ERC20(_token).balanceOf(address(this)) >= _amount, "no balance");
        ERC20(_token).transfer(_to, _amount);
    }
    //提出全部代币
    function withdrawAll(address _token, address _to) public onlyOwner {
        ERC20(_token).transfer(_to, ERC20(_token).balanceOf(address(this)));
    }
     //提出全部代币
    function balanceOfThis(address _token)  public view returns (uint256){
       return ERC20(_token).balanceOf(address(this));
    }
    //提现主币
    function withdraw() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }
      //设置黑名单
    function setUserBlacklist(address user) public onlyOwner {
        _userBlacklist[user] = !_userBlacklist[user];
    }
    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }
    function getOwner() public view returns (address) {
        return owner;
    }
    //dk 设置usdt 
     function set_usdt(address paramErc20) public onlyOwner {
         _toToken = ERC20(paramErc20);
    }
    //dk 设置key 
     function set_keyValue(uint256 key) public onlyOwner {
         _keyValue = key;
    }    
}