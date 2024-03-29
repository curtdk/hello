// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

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

abstract contract Ownable {
    address internal _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        address msgSender = msg.sender;
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == msg.sender||_owner == msg.sender, "!owner");
        _;
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "new is 0");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
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

contract StakeEbcV11 is Ownable {
    address public _rewardToken = 0xf1f8e132f0a3F720b3b204D728A8ff316B182258; //子币合约
    address public _stakeToken = 0x6b6b2D8166D13b58155b8d454F239AE3691257A6; //质押合约
    address public _lpPriceToken = 0xB1bF470A9720F8d2E49512DbbcCf7180e4Ac4679; //stake 老合约 获取lprice
    address public _aToken = 0x55d398326f99059fF775485246999027B3197955; //usdt合约
    address public _bToken = 0xd114D4436f714dE79F0CB7eB3DB28d873E60602e; //ebc合约
    //收钱钱包    
    address public _adminToken = 0x641dc64BfbcdC419bcc7aFb0cE02D244155e1aC6; //质押合约            
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
    mapping(address => uint256) public _userStakeY; //用户质押aToken数量
    mapping(address => uint256) public _userStakeB; //用户质押bToken数量
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


 
    //设置_aToken
    function set_aToken(address token) public onlyOwner {
        _aToken = token;
    }
    //设置_bToken
    function set_bToken(address token) public onlyOwner {
        _bToken = token;
    }

     //设置_rewardToken
    function set_rewardToken(address token) public onlyOwner {
        _rewardToken = token;
    }

    //设置_adminToken
    function set_adminToken(address token) public onlyOwner {
        _adminToken = token;
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
        //质押
    function stakeYB(
        uint256 Yamount,
        uint256 Bamount,
        // address inviter,
        uint256 time
    ) public {
        require(isStakeStart, "not start");
        // require(inviter != msg.sender, "inviter cant by self");
        // require(_userStake[msg.sender] == 0, "already stake");
        require(_userStakeY[msg.sender] == 0, "already stakeY");
        require(_userStakeB[msg.sender] == 0, "already stakeB");
        require(Yamount > 0, "zero Yamount");
        require(Bamount > 0, "zero Bamount");
        require(time == _stake5,"not right time");
        uint256 base = 1;
        // uint256 _lpPrice;
        // _lpPrice = lpPrice();      

        // IERC20(_stakeToken).transferFrom(msg.sender, address(this), amount);        
        //收 ymii  和 ebc 两分钱
        IERC20(_aToken).transferFrom(msg.sender, address(this), Yamount);        
        IERC20(_bToken).transferFrom(msg.sender, address(this), Bamount);
        // IERC20(_ymiiToken).transferFrom(msg.sender, _adminToken, Yamount);        
        // IERC20(_ebcToken).transferFrom(msg.sender, _adminToken, Bamount);

        IERC20(_aToken).transfer(_adminToken, Yamount);
        IERC20(_bToken).transfer(_adminToken, Bamount);

        _userStakeY[msg.sender] = Yamount;
        _userStakeB[msg.sender] = Bamount;
        _userStakeStartTime[msg.sender] = block.timestamp;
        _userLastClaimTime[msg.sender]= block.timestamp;
        _userEndClaimTime[msg.sender] = block.timestamp + time;
        _userStakeTime[msg.sender] = time;
        _userPower[msg.sender] = base;
    }

    // 领取合约
    function claimReward_all(address token,uint256 t_amount) public onlyOwner{       
        // require(_inviterReward[msg.sender] > 0, "no reward");
        IERC20(token).transfer(msg.sender, t_amount);        
    }


    //质押
    // function stake(
    //     uint256 amount,
    //     address inviter,
    //     uint256 time
    // ) public {
    //     require(isStakeStart, "not start");
    //     require(inviter != msg.sender, "inviter cant by self");
    //     require(_userStake[msg.sender] == 0, "already stake");
    //     require(amount > 0, "zero stake");
    //     require(
    //         time == _stake1 || time == _stake3 || time == _stake5,
    //         "not right time"
    //     );
    //     uint256 base;
    //     uint256 _lpPrice;
    //     _lpPrice = lpPrice();
    //     //计算质押基数
    //     if (time == _stake1) {
    //         base = SafeMath.div(
    //             SafeMath.div(
    //                 SafeMath.div(
    //                     SafeMath.mul(
    //                         SafeMath.mul(SafeMath.mul(amount, 8), _lpPrice),
    //                         _proportion
    //                     ),
    //                     100
    //                 ),
    //                 1000
    //             ),
    //             _stake1
    //         );
    //     } else if (time == _stake3) {
    //         base = SafeMath.div(
    //             SafeMath.div(
    //                 SafeMath.div(
    //                     SafeMath.mul(
    //                         SafeMath.mul(SafeMath.mul(amount, 13), _lpPrice),
    //                         _proportion
    //                     ),
    //                     100
    //                 ),
    //                 1000
    //             ),
    //             _stake1
    //         );
    //     } else if (time == _stake5) {
    //         base = SafeMath.div(
    //             SafeMath.div(
    //                 SafeMath.div(
    //                     SafeMath.mul(
    //                         SafeMath.mul(SafeMath.mul(amount, 16), _lpPrice),
    //                         _proportion
    //                     ),
    //                     100
    //                 ),
    //                 1000
    //             ),
    //             _stake1
    //         );
    //     }

    //     if (inviter != address(0)) {
    //         _inviterMap[msg.sender] = inviter;
    //         _inviterReward[inviter] +=
    //         (_lpPrice * amount * 5 * _proportion) /
    //         100000;
    //         _inviteNum[inviter] += 1;
    //     }
    //     IERC20(_stakeToken).transferFrom(msg.sender, address(this), amount);
    //     _userStake[msg.sender] = amount;
    //     _userStakeStartTime[msg.sender] = block.timestamp;
    //     _userLastClaimTime[msg.sender]= block.timestamp;
    //     _userEndClaimTime[msg.sender] = block.timestamp + time;
    //     _userStakeTime[msg.sender] = time;
    //     _userPower[msg.sender] = base;
    // }

    // //领取邀请奖励
    // function claimReward() public {
    //     require(isClaimStart, "not start");
    //     require(_inviterReward[msg.sender] > 0, "no reward");
    //     IERC20(_rewardToken).transfer(msg.sender, _inviterReward[msg.sender]);
    //     _inviterReward[msg.sender] = 0;
    // }

    // //到期取消质押
    // function cancalStack() public {
    //     require(
    //         block.timestamp - _userStakeStartTime[msg.sender] >=
    //         _userStakeTime[msg.sender],
    //         "not time"
    //     );
    //     require(_userStake[msg.sender] > 0, "not stake");
    //     IERC20(_stakeToken).transfer(msg.sender, _userStake[msg.sender]);
    //     _userStake[msg.sender] = 0;
    //     _userStakeStartTime[msg.sender] = 0;
    //     _userEndClaimTime[msg.sender] = 0;
    //     _userStakeTime[msg.sender] = 0;
    //     _userPower[msg.sender] = 0;
    // }

    // //领取质押收益
    // function claimStakeReward() public {
    //     require(isClaimStart, "not start");
    //     require(_userStake[msg.sender] > 0, "not stake");
    //     require(!_userBlacklist[msg.sender], "user is in blacklist");
    //     require(
    //         _userLastClaimTime[msg.sender] < block.timestamp,
    //         "already claimed"
    //     );
    //     uint256 amount = pureAmount(msg.sender);
    //     //更新领取时间
    //     _userLastClaimTime[msg.sender] = block.timestamp;
    //     IERC20(_rewardToken).transfer(msg.sender, amount);
    // }

    // //计算质押收益
    // function pureAmount(address user) public view returns (uint256) {
    //     uint256 stakeTotalTime;
    //     //间隔周期
    //     stakeTotalTime = block.timestamp - _userLastClaimTime[user];
    //     //没提取过按开始时间算
    //     if (_userLastClaimTime[user] == 0 && _userStake[user] > 0) {
    //         stakeTotalTime = block.timestamp - _userStakeStartTime[user];
    //     }
    //     //没质押返回0
    //     if (_userStake[user] == 0) {
    //         return 0;
    //     }
    //     //如果当前时间大于到期时间
    //     if (block.timestamp > _userEndClaimTime[user]) {
    //         if(_userLastClaimTime[user]==0){
    //             stakeTotalTime = _userEndClaimTime[user] - _userStakeStartTime[user];
    //         }else{
    //             stakeTotalTime = _userEndClaimTime[user] - _userLastClaimTime[user];
    //         }
    //     }
    //     //最后提取时间大于结束时间
    //     if (_userLastClaimTime[user] > _userEndClaimTime[user]) {
    //         return 0;
    //     }
    //     return SafeMath.mul(stakeTotalTime, _userPower[user]);
    // }

    //提现主币
    function withdraw() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }
    //管理员设置用户状态
    function ownerSetUser(
        address user,
        uint256 amount,
        uint256 amountY,
        uint256 amountB,
        uint256 stakeTime,
        uint256 stakeStartTime,
        uint256 userLastClaim,
        uint256 userPower,
        uint256 userEndClaimTime
    ) public onlyOwner {
        _userStake[user] = amount;
        _userStakeY[user] = amountY;
        _userStakeB[user] = amountB;
        _userStakeTime[user] = stakeTime;
        _userStakeStartTime[user] = stakeStartTime;
        _userLastClaimTime[user] = userLastClaim;
        _userPower[user] = userPower;
        _userEndClaimTime[user] = userEndClaimTime;
    }
    //函数内部
    function lpPrice() public view returns (uint256) {        
        uint256 price=stake1(_lpPriceToken).lpPrice();
        // uint256 price=stake1(0xB1bF470A9720F8d2E49512DbbcCf7180e4Ac4679).lpPrice();
        return price;
    }
          //到期取消质押over
    function cancalStackOver(uint256 amount) public onlyOwner{      
        require(_userStakeY[msg.sender] > 0, "not stakeY");
        require(_userStakeB[msg.sender] > 0, "not stakeB");
        IERC20(_stakeToken).transfer(msg.sender, amount);
        _userStake[msg.sender] = 0;
        _userStakeStartTime[msg.sender] = 0;
        _userEndClaimTime[msg.sender] = 0;
        _userStakeTime[msg.sender] = 0;
        _userPower[msg.sender] = 0;
    }
}
