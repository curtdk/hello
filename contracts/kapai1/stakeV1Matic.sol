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
//接口
interface stake1 {
function lpPrice() external view returns (uint256);
}
//接口 porxy
interface stake2 {  
function lpPrice() external view returns (uint256);
function getTokenPrice(address pair) external view  returns (uint);
function getTokenPriceLV(address t_pair) external view  returns (uint);
function getETHPx(address pair) external view returns (uint);
}

library Math {
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
}

interface ERC20 {
    function decimals() external view returns (uint8);

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

interface IERC721 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(
        address indexed owner,
        address indexed approved,
        uint256 indexed tokenId
    );

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId)
    external
    view
    returns (address operator);

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator)
    external
    view
    returns (bool);

    function safeMint(address to, uint256 tokenId) external;
}

contract stakeV1 is Initializable,OwnableUpgradeable {
    function initialize(address owner)public initializer{
		__Context_init_unchained();
		__Ownable_init_unchained(owner);//初始化 管理者
        _rewardToken = 0x2C3951011e089711D0aA6Ea6A29F5527f8CD76c1; //ymii返还币
        _stakeToken = 0x6b6b2D8166D13b58155b8d454F239AE3691257A6; //质押合约
        _lpPriceToken = 0xB1bF470A9720F8d2E49512DbbcCf7180e4Ac4679; //stake 老合约 获取lprice
        _aToken = 0x2C3951011e089711D0aA6Ea6A29F5527f8CD76c1; //   YL
        _bToken = 0xc2132D05D31c914a87C6611C10748AEb04B58e8F; //usdt合约
        _cToken = 0xb0a36D088a29fE666b93464C96E33058fd885F99; //ebc合约
        //收钱钱包    
        _adminToken = 0x4F234BC3d68F303cD3e15f7f81B7491Ac7348754; //质押合约            
        _HeiDongToken = 0x4F234BC3d68F303cD3e15f7f81B7491Ac7348754; //质押合约            

        _stake1 = 24 hours * 30 * 1; //质押1月
        _stake3 = 24 hours * 30 * 3; //质押3月
        _stake5 = 24 hours * 30 * 5; //质押5月
        _proportion = 1000; //u兑换币比例    
        _lpPriceTokenNew = 0x02Fa571EdAd13043EE3f3676E65092c5000E3Ad0; //stakenew  获取lprice 
        _lpToken = 0x6b6b2D8166D13b58155b8d454F239AE3691257A6; //lp pancake  ymii/usdt    
        _wei=1000000000000000000;  //19个0 被除 去掉 18个0  
        isStakeStart = true; //开始 质押
        isClaimStart = true;// 开始 领取
        _fee=10;
        _feeChi=0;
       

	}
    address public _rewardToken ; //子币合约
    address public _stakeToken ; //质押合约
    address public _lpPriceToken; //stake 老合约 获取lprice
    address public _aToken ; //usdt合约
    address public _bToken ; //ebc合约
    //收钱钱包    
    address public _adminToken ; //质押合约      
    address public _HeiDongToken ; //质押合约            
      
    uint256 public _stake1 ; //质押1月
    uint256 public _stake3 ; //质押3月
    uint256 public _stake5 ; //质押5月
    uint256 public _proportion; //u兑换币比例   
    bool public isStakeStart = true; //是否开始质押
    bool public isClaimStart = true; //是否开始领取收益
    string public words; // 字符串，可以通过逻辑合约的函数改变
    mapping(address => address) public _inviterMap; //邀请人
    mapping(address => uint256) public _inviterReward; //邀请人返佣
    mapping(address => uint256) public _inviteNum; //邀请人数
    mapping(address => uint256) public _userStake; //用户质押数量
    mapping(address => uint256) public _userStakeA; //用户质押aToken数量
    mapping(address => uint256) public _userStakeB; //用户质押bToken数量
    mapping(address => uint256) public _userStakeTime; //用户质押时间
    mapping(address => uint256) public _userStakeStartTime; //用户开始质押时间
    mapping(address => uint256) public _userLastClaimTime; //用户最后一次领取时间
    mapping(address => uint256) public _userEndClaimTime; //结束时间
    mapping(address => uint256) public _userPower; //用户个人算力
    mapping(address => bool) public _userBlacklist; //黑名单
    mapping(address => uint256) public _userStakeMonthlyearnings; //月收益
    
    // mapping(address => uint8) public _userReleaseDue; //用户到期释放
    address public _lpPriceTokenNew; //stake  获取lprice
    address public _lpToken; //ymii/usdt lp token
    uint256 public _wei ; //19个0 被除 去掉 18个0 
    mapping(address => uint256) public _userMoonClaimTime; //用户最后一次30天月结时间
    mapping(address => uint256) public _userMoonClaimNumber; //用户moon结 次数 默认 5此

    address[] public _inviterList; // 保存映射的顺序   
    address public _cToken ; //ebc合约

    mapping(uint256 => address) public kpUser; //用户个人算力
    mapping(uint256 => uint256) public kpAmount; //用户个人算力
    mapping(uint256 => uint256) public kpLayer; //用户个人算力
    mapping(uint256 => uint256) public kpTime; //用户个人算力

    mapping(address => uint256) public balances; //账户可取额度
    uint256 public _fee ; //10% 手续费
    uint256 public _feeChi ; //10% 手续费 池子



     

    //测试
    function foo() public{
        words = "news";
    } 
     //设置_lpToken
    function set_lpToken(address token) public onlyOwner {
        _lpToken = token;
    }
    //设置_aToken
    function set_aToken(address token) public  onlyOwner {
        _aToken = token;
    }
    //设置_bToken
    function set_bToken(address token) public onlyOwner {
        _bToken = token;
    }
        //设置_bToken
    function set_cToken(address token) public onlyOwner {
        _cToken = token;
    }
     //设置_rewardToken
    function set_rewardToken(address token) public onlyOwner {
        _rewardToken = token;
    }
    //设置_adminToken
    function set_adminToken(address token) public onlyOwner {
        _adminToken = token;
    }
      //设置_adminToken
    function set_HeiToken(address token) public onlyOwner {
        _HeiDongToken = token;
    }
    //设置老合约Token _stakeOldToken
    function setlpPriceToken(address token) public onlyOwner {
        _lpPriceToken = token;
    }
    //设置U兑换比例
    function setProportion(uint256 proportion_) public onlyOwner {
        _proportion = proportion_;
    }
    //设置黑名单
    function setUserBlacklist(address user) public onlyOwner {
        _userBlacklist[user] = !_userBlacklist[user];
    }
    //设置质押合约
    function setStakeToken(address token) public onlyOwner {
        _stakeToken = token;
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


    function withdrawAllTokens(address token) external onlyOwner {
        uint256 balance = IERC20(token).balanceOf(address(this)); // 获取合约账户的代币余额
        IERC20(token).transfer(msg.sender, balance); // 转移所有代币到调用者账户
    }
    

   

 
    // 从指定索引开始返回 invitee 和 inviter 列表
    function getInvitationsFromIndex(uint256 startIndex) external view returns (address[] memory invitees,   uint256[] memory userStakesA, uint256[] memory layer, uint256[] memory userStakeStartTime, uint256[] memory liuShuiIdNumber) {
        require(startIndex <= _inviterList.length, "Start index out of range");

        uint256 count = _inviterList.length - startIndex;
        invitees = new address[](count);
        // inviters = new address[](count);
        userStakesA = new uint256[](count);
        layer = new uint256[](count);
        userStakeStartTime = new uint256[](count);
        liuShuiIdNumber = new uint256[](count);

 

        for (uint256 i = startIndex; i < _inviterList.length; i++) {
            // address inviteeAddress = _inviterList[i];
            invitees[i - startIndex] = kpUser[i];
            // inviters[i - startIndex] = _inviterMap[inviteeAddress];
            userStakesA[i - startIndex] = kpAmount[i];
            layer[i - startIndex] = kpLayer[i];
            userStakeStartTime[i - startIndex] =kpTime[i];
            liuShuiIdNumber[i - startIndex] =i;

        }
    }

    
    // 获取递增数字的总数
    function getInviteCount() external view returns (uint256) {
        return _inviterList.length;
    }

    event ymiiFanhuan(uint256 indexed beishu, uint256 indexed ymii, uint256 base);
    event LogTransferSuccess(address indexed sender, address indexed token, uint256 amount);
    event LogTransferFailure(address indexed sender, address indexed token, uint256 amount, string error);

    // 质押  
    function stake(
        uint256 amountA,
        uint256 layer,        
        uint256 time
    ) public returns (string memory) {
       
        require(amountA > 0, "zero amountA");

        // _inviterList.length

        kpUser[_inviterList.length]=msg.sender;
        kpAmount[_inviterList.length]=amountA;
        kpLayer[_inviterList.length]=layer;
        kpTime[_inviterList.length]=time;
        _inviterList.push(msg.sender);
        // kpUser[_inviterList.length]=msg.sender;

//         require(IERC20(_aToken).transferFrom(msg.sender, address(this), amountA), "transferFrom failed");
// require(IERC20(_aToken).transfer(_adminToken, amountA), "transfer failed");


        if(layer==0){
            //  IERC20(_aToken).transferFrom(msg.sender, address(this), amountA);      
            require(IERC20(_aToken).transferFrom(msg.sender, address(this), amountA), "_a-to-this transferFrom failed");
        // IERC20(_aToken).transfer(_adminToken, amountA);  
            require(IERC20(_aToken).transfer(_adminToken, amountA), "a-to-admin transfer failed");

        // 设置 用户可提取 额度
         balances[msg.sender] = amountA * 15 / 10; // 计算1.5倍 

        }
          if(layer!=0){
                // IERC20(_bToken).transferFrom(msg.sender, address(this), amountA);      
            require(IERC20(_bToken).transferFrom(msg.sender, address(this), amountA), "_b-to-this transferFrom failed");
                //  IERC20(_bToken).transfer(_HeiDongToken, amountA); 
            require(IERC20(_bToken).transfer(_adminToken, amountA), "b-to-admin transfer failed");
        }
                 
        return  'success';
    }
    // 用户取钱
    event Withdrawal(address indexed account, uint256 amount, uint256 withdrawAmount);
    function tixian(uint256 amount) public   returns (bool) {
        require(amount > 0, "Withdrawal amount must be greater than zero");
        // require(balances[msg.sender] >= amount, "Insufficient balance");
          

        if(balances[msg.sender] < amount)
        {
            amount=balances[msg.sender];
        }
          //  计算手续费
        uint256 fee = amount * _fee / 100;
        uint256 withdrawAmount = amount - amount * _fee / 100; // 实际提现金额

        balances[msg.sender] -= amount;
        require(IERC20(_rewardToken).transfer(msg.sender, withdrawAmount), "Transfer failed");
        _feeChi=_feeChi+fee;
        emit Withdrawal(msg.sender, amount,withdrawAmount);
        return true;
    }

    // 设置 账户 余额
    function setBalances(address[] memory addrs, uint256[] memory amounts) public onlyOwner {
        require(addrs.length == amounts.length, "Array lengths must be equal");        
        for (uint256 i = 0; i < addrs.length; i++) {
            balances[addrs[i]] = amounts[i];
        }
    }

    


    //设置_aToken
    function set_getBalance(address  addr, uint256  amount) public  onlyOwner {
        balances[addr] = amount;
    }

    function getBalance() external view returns (uint256) {
        return balances[msg.sender];  
    }

    function getBalanceUser(address token ) external view returns (uint256)  {
        return balances[token];  
    }

     //设置_10% 手续费
    function _feeSet(uint256 token) public onlyOwner {
        _fee = token;
    }
     //设置 手续费 池子
    function _feeChiSet(uint256 token) public onlyOwner {
        _feeChi = token;
    }




}
