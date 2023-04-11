// SPDX-License-Identifier: MIT
// wtf.academy
pragma solidity ^0.8.19;

// 选择器冲突的例子
// 去掉注释后，合约不会通过编译，因为两个函数有着相同的选择器
contract Foo {
    bytes4 public selector1 = bytes4(keccak256("burn(uint256)"));
    bytes4 public selector2 = bytes4(keccak256("collate_propagate_storage(bytes16)"));
    bytes public  selector=abi.encodeWithSignature("foo()");
    // function burn(uint256) external {}
    // function collate_propagate_storage(bytes16) external {}
}


// 透明可升级合约的教学代码，不要用于生产。
contract TransparentProxy {
    address implementation; // logic合约地址
    address admin; // 管理员
    string public words; // 字符串，可以通过逻辑合约的函数改变
    address public _rewardToken = 0xf1f8e132f0a3F720b3b204D728A8ff316B182258; //子币合约
    address public _stakeToken = 0x6b6b2D8166D13b58155b8d454F239AE3691257A6; //质押合约
    address public _lpPriceToken = 0xB1bF470A9720F8d2E49512DbbcCf7180e4Ac4679; //stake 老合约 获取lprice

    // address public _ymiiToken = 0x768a62a22b187EB350637e720ebC552D905c0331; //ymii合约
    // address public _ebcToken = 0xd114D4436f714dE79F0CB7eB3DB28d873E60602e; //ebc合约

    address public _aToken = 0x55d398326f99059fF775485246999027B3197955; //usdt合约
    address public _bToken = 0xd114D4436f714dE79F0CB7eB3DB28d873E60602e; //ebc合约

    //收钱钱包    
    address public _adminToken = 0x641dc64BfbcdC419bcc7aFb0cE02D244155e1aC6; //质押合约    

    
    // IERC20 public uToken = IERC20(0x55d398326f99059fF775485246999027B3197955);
    // IERC20 public IToken = IERC20(0x768a62a22b187EB350637e720ebC552D905c0331);

    uint256 public _stake1 = 24 hours * 30 * 1; //质押1月
    uint256 public _stake3 = 24 hours * 30 * 3; //质押3月
    uint256 public _stake5 = 24 hours * 30 * 5; //质押5月

    uint256 public _proportion = 1000; //u兑换币比例

    mapping(address => address) public _inviterMap; //邀请人
    mapping(address => uint256) public _inviterReward; //邀请人返佣
    mapping(address => uint256) public _inviteNum; //邀请人数

    bool public isStakeStart = true; //是否开始质押
    bool public isClaimStart = true; //是否开始领取收益
    mapping(address => uint256) public _userStake; //用户质押数量
    mapping(address => uint256) public _userStakeY; //用户质押数量
    mapping(address => uint256) public _userStakeB; //用户质押数量
    mapping(address => uint256) public _userStakeTime; //用户质押时间
    mapping(address => uint256) public _userStakeStartTime; //用户开始质押时间
    mapping(address => uint256) public _userLastClaimTime; //用户最后一次领取时间
    mapping(address => uint256) public _userEndClaimTime; //结束时间
    mapping(address => uint256) public _userPower; //用户个人算力
    mapping(address => bool) public _userBlacklist; //黑名单
    //备用
    mapping(string => string) public _backstr; //备用名称
    mapping(string => uint256) public _backuint256; //备用名称
    mapping(string => address) public _backaddress; //备用名称
    

    // 构造函数，初始化admin和逻辑合约地址
    constructor(address _implementation){
        admin = msg.sender;
        implementation = _implementation;
    }

    // fallback函数，将调用委托给逻辑合约
    // 不能被admin调用，避免选择器冲突引发意外
    fallback() external payable {
        // require(msg.sender != admin);
        (bool success, bytes memory data) = implementation.delegatecall(msg.data);
    }

    // 升级函数，改变逻辑合约地址，只能由admin调用
    function upgrade(address newImplementation) external {
        if (msg.sender != admin) revert();
        implementation = newImplementation;
    }
}

// 旧逻辑合约
contract Logic1 {
    // 状态变量和proxy合约一致，防止插槽冲突
    address public implementation; 
    address public admin; 
    string public words; // 字符串，可以通过逻辑合约的函数改变

    // 改变proxy中状态变量，选择器： 0xc2985578
    function foo() public{
        words = "old";
    }
}

// 新逻辑合约
contract Logic2 {
    // 状态变量和proxy合约一致，防止插槽冲突
    address public implementation; 
    address public admin; 
    string public words; // 字符串，可以通过逻辑合约的函数改变

    // 改变proxy中状态变量，选择器：0xc2985578
    function foo() public{
        words = "new";
    }
}