// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
interface IERC20 {
    function decimals() external view returns (uint8);

    function symbol() external view returns (string memory);

    function name() external view returns (string memory);

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
    external
    returns (bool);

    function allowance(address owner, address spender)
    external
    view
    returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

// 安全的数学计算库
library SafeMath {

     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = x < y ? x : y;
    }
    // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
    function sqrt(uint256 y) internal pure returns (uint256 z) {
        if (y > 3) {
            z = y;
            uint256 x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }

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


contract stakeCFA1 is Initializable,OwnableUpgradeable {
    function initialize()public initializer{
		__Context_init_unchained();
		__Ownable_init_unchained();//初始化 管理者
        _rewardToken = 0x0544Abf805dBF64cb96DE2Ac10b52784C0684220; //CFA
        _usdtToken = 0x55d398326f99059fF775485246999027B3197955; //usdt合约
        //收钱钱包    
        _adminToken = 0x7fb6748A37C93Dd9a04486EE9D59cA6291762183; //质押合约 dk1 
        _release24=  24 hours;        
        _stake1 = 24 hours * 30 * 1; //质押1月
        _stake3 = 24 hours * 30 * 3; //质押3月
        _stake5 = 24 hours * 30 * 5; //质押5月        
                 
        _wei=1000000000000000000;  //19个0 被除 去掉 18个0  
        // isStakeStart = true; //开始 质押
        // isClaimStart = true;// 开始 领取
        _isAdd = true;// 180天 加或减
        _day180=180;
        _day180Now=180;
        _cfa1180=1180000000000000000000;//初始化 1180枚
        _cfa1180Now=1180000000000000000000;
        _releaseAccountCounter=3;
        _releaseAccount[1]=0x0734aEC8d689f768855329835fBa77fA7E9EAf28; //基金会 100%% 千分
        _releaseAccount[2]=0xA376CF2e9f574F2B5E139c4C8c876cC3D7A92780; //开发者 50%% 千分
        _releaseAccount[3]=0x57c19028fC1A17854a309Fc38F4062716bFac8DB; //市场管理75%% 千分
        // _releaseAccount[4]=0x617F2E2fD72FD9D5503197092aC168c91465E7f2;
        _releasePercent[_releaseAccount[1]]=100;  //按照千分比算
        _releasePercent[_releaseAccount[2]]=50;
        _releasePercent[_releaseAccount[3]]=75;
        // _releasePercent[_releaseAccount[4]]=100;
        isReleaseNowDay = false;
	}
    address public _rewardToken ; //子币合约    
    address public _usdtToken; //stake 老合约 获取lprice
    //收钱钱包    
    address public _adminToken ; //收款账号    
    uint256 public _release24 ; //释放24小时        
    // uint256 public _releaseDay ; //释放开始日
    uint256 public _releaseNowDay ; //当前释放天
    bool public isReleaseNowDay ; //当前释放天是否释放

    uint256 public _stake1 ; //质押1月
    uint256 public _stake3 ; //质押3月
    uint256 public _stake5 ; //质押5月
    
    bool public isStakeStart = true; //是否开始质押
    bool public isClaimStart = true; //是否开始领取收益
    bool public _isAdd ; //是否开始领取收益
    uint256 public _day180 ; //180天 转换加减
    uint256 public _day180Now ; //180天 转换加减
    uint256 public _cfa1180; //cfa每日释放 1180   
    uint256 public _cfa1180Now; //cfa每日释放 1180   
    uint256 public _releaseAccountCounter; //平台释放账号 总数 

    mapping(uint256 => address) public _releaseAccount; //平台释放账号
    mapping(address => uint256) public _releaseNumber; //释放次数
    mapping(address => uint256) public _releaseTime; //释放时间  
    mapping(address => uint256) public _releasePercent; //释放百分比：按照千分比算
    mapping(address => bool) public _userBlacklist; //黑名单   

    uint256 public _wei ; //19个0 被除 去掉 18个0 
     

     //添加_平台释放账号
    function add_releaseAccount(address token,uint256 Percent) public onlyOwner {
        _releaseAccount[_releaseAccountCounter] = token;
        _releasePercent[_releaseAccount[_releaseAccountCounter]]=Percent;
        _releaseAccountCounter++;
    }
     //设置_平台释放账号
    function set_releaseAccount(address token,uint number,uint256 Percent) public onlyOwner {
        _releaseAccount[number] = token;
        _releasePercent[_releaseAccount[number]]=Percent;        
    }
    //设置_平台释放账号 总数
    function set_releaseAccountCounter(uint256 number) public  onlyOwner {
        _releaseAccountCounter = number;
    }
      //设置_平台释放开始时间 总数
    function set_releaseNowDay(uint256 number) public  onlyOwner {
        _releaseNowDay = number;
    }
    //设置_cfa1180
    function set_cfa1180(uint256 number) public onlyOwner {
        _cfa1180 = number;
    }
     //设置_cfa1180
    function set_cfa1180Now(uint256 number) public onlyOwner {
        _cfa1180Now = number;
    }
     //设置_rewardToken
    function set_rewardToken(address token) public onlyOwner {
        _rewardToken = token;
    }
    //设置_adminToken
    function set_adminToken(address token) public onlyOwner {
        _adminToken = token;
    }
   
    //设置黑名单
    function setUserBlacklist(address user) public onlyOwner {
        _userBlacklist[user] = !_userBlacklist[user];
    }
    //设置Usdt Token
    function set_usdtToken(address token) public onlyOwner {
        _usdtToken = token;
    }
    //设置开关
    function setStatus(bool stakeStart, bool claimStart) public onlyOwner {
        isStakeStart = stakeStart;
        isClaimStart = claimStart;
    }   
    //提现主币
    function withdraw() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }  
     //提出代币
    function withdraw(address _token, address _to, uint256 _amount) public onlyOwner {
        require(IERC20(_token).balanceOf(address(this)) >= _amount, "no balance");
        IERC20(_token).transfer(_to, _amount);
    }
    //提出全部代币
    function withdrawAll(address _token, address _to) public onlyOwner {
        IERC20(_token).transfer(_to, IERC20(_token).balanceOf(address(this)));
    }

    event ymiiFanhuan(uint256 indexed beishu, uint256 indexed ymii, uint256 base);
    // 质押  通过 amountA usdt 数量 计算 70是一份 等于100
    function releaseAccount() public {
        require(isClaimStart, "not start release");//关闭释放了  
        // require(_releaseDay>t_blocktime,"releaseDay no start");    
        uint256 t_blocktime = block.timestamp;        
        require(_releaseNowDay<t_blocktime,"releaseDay Less than");       

        //循环释放
        uint j=0;
        uint256 t_percent=0;
        uint256 t_cfa=0;
        
        for (j = 1; j <= _releaseAccountCounter; j++ ) {  //for循环的例子
            
            t_percent=_releasePercent[_releaseAccount[j]];//他要取千分之多少
            // _cfa1180Now/1000*t_percent  //今日释放100%量
            t_cfa=SafeMath.mul(
                    SafeMath.div(_cfa1180Now,1000),//1000千分比
                    t_percent);
            IERC20(_rewardToken).transfer( _releaseAccount[j], t_cfa);
        }
        //每日释放1180 每日-1  180天后 每天+1
         if(_isAdd==false)  //减法
        {
            _day180Now=_day180Now-1;
            _cfa1180Now=_cfa1180Now-_wei;
            if(_day180Now==0)
            {
                _isAdd=true;
            }
        }

        if(_isAdd==true) //加法
        {
            _day180Now=_day180Now+1;
             _cfa1180Now=_cfa1180Now+_wei;
             if(_day180Now==_day180)
            {
                _isAdd=false;
            }
        }
        _releaseNowDay=_releaseNowDay+_release24;
       emit ymiiFanhuan(_releaseNowDay, _day180Now, j);
    }
}
