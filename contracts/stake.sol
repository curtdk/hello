// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

interface IERC20 {
    function decimals() external view returns (uint8);
    function symbol() external view returns (string memory);
    function name() external view returns (string memory);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

abstract contract Ownable {
    address internal _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    constructor () {
        address msgSender = msg.sender;
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }
    function owner() public view returns (address) {
        return _owner;
    }
    modifier onlyOwner() {
        require(_owner == msg.sender, "!owner");
        _;
    }
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "new is 0");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
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

contract Stake is Ownable {
    address public _rewardToken = 0xF8499f5d74dfdA9b7953CFB43F4e65Fa96D0F83c;//子币合约
    address public _stakeToken = 0x70f531B070495D22CadAAd9763FEDAD9F0a53472;//质押合约
    uint256 public _stake1 = 24 hours * 30 * 1; //质押1月
    uint256 public _stake3 = 24 hours * 30 * 3; //质押3月
    uint256 public _stake5 = 24 hours * 30 * 5; //质押5月

    uint256 public _1per = 100 * 10 ** 9 / 5;//1%

    uint256 public _inviteReward = _1per * 5;//1LP推广反佣5%
    mapping(address => address) public _inviterMap;//邀请人
    mapping(address => uint256) public _inviterReward;//邀请人返佣
    mapping(address => uint256) public _inviteNum;//邀请人数

    uint256 public _stake1pure = _1per * 8 / _stake1; //1个月月收益10%每秒
    uint256 public _stake3pure = _1per * 12 / _stake3 * 3;//3个月月收益12%每秒
    uint256 public _stake5pure = _1per * 15 / _stake5 * 5;//5个月月收益15%每秒

    bool public isStakeStart = true;//是否开始质押
    bool public isClaimStart = true;//是否开始领取收益

    mapping(address => uint256) public _userStake; //用户质押数量
    mapping(address => uint256) public _userStakeTime; //用户质押时间
    mapping(address => uint256) public _userStakeStartTime;//用户开始质押时间
    mapping(address => uint256) public _userLastClaimTime;//用户最后一次领取时间

    mapping(address => bool) public _userBlacklist;//黑名单

    //设置1%的数量
    function set1per(uint256 _1) public onlyOwner {
        _1per = _1;
    }

    //设置收益合约
    function setRewardToken(address token) public onlyOwner {
        _rewardToken = token;
    }

    //设置质押合约
    function setStakeToken(address token) public onlyOwner {
        _stakeToken = token;
    }

    //设置邀请奖励数量
    function setInviteReward(uint256 _invite) public onlyOwner {
        _inviteReward = _invite;
    }

    //设置质押收益数量
    function setStakePure(uint256 _1, uint _2, uint _3) public onlyOwner {
        _stake1pure = _1;
        _stake3pure = _2;
        _stake5pure = _3;
    }

    //设置开关
    function setStatus(bool stakeStart, bool claimStart) public onlyOwner {
        isStakeStart = stakeStart;
        isClaimStart = claimStart;
    }

    //质押
    function stake(uint256 amount, address inviter, uint256 time) public {
        require(isStakeStart, "not start");
        require(inviter != msg.sender, "inviter cant by self");
        require(_userStake[msg.sender] == 0, "already stake");
        require(amount > 0, "zero stake");
        require(time == _stake1 || time == _stake3 || time == _stake5, "not right time");
        if(inviter != address(0)) {
            _inviterMap[msg.sender] = inviter;
            _inviterReward[inviter] += _inviteReward * amount / 10 ** 18;
            _inviteNum[inviter] += 1;
        }
        IERC20(_stakeToken).transferFrom(msg.sender, address(this), amount);
        _userStake[msg.sender] = amount;
        _userStakeStartTime[msg.sender] = block.timestamp;
        _userStakeTime[msg.sender] = time;
    }

    //领取邀请奖励
    function claimReward() public {
        require(isClaimStart, "not start");
        require(_inviterReward[msg.sender] > 0, "no reward");
        IERC20(_rewardToken).transfer(msg.sender, _inviterReward[msg.sender]);
        _inviterReward[msg.sender] = 0;
    }

    //到期取消质押
    function cancalStack() public {
        require(block.timestamp - _userStakeStartTime[msg.sender] >= _userStakeTime[msg.sender], "not time");
        require(_userStake[msg.sender] > 0, "not stake");
        IERC20(_stakeToken).transfer(msg.sender, _userStake[msg.sender]);
        _userStake[msg.sender] = 0;
        _userStakeStartTime[msg.sender] = 0;
        _userStakeTime[msg.sender] = 0;
    }

    //领取质押收益
    function claimStakeReward() public {
        require(isClaimStart, "not start");
        require(_userStake[msg.sender] > 0, "not stake");
        require(!_userBlacklist[msg.sender], "user is in blacklist");
        require(_userLastClaimTime[msg.sender] < block.timestamp, "already claimed");
        uint256 amount = pureAmount(msg.sender);
        _userLastClaimTime[msg.sender] = block.timestamp;
        IERC20(_rewardToken).transfer(msg.sender, amount);
    }

    //计算质押收益
    function pureAmount(address user) view public returns(uint256) {
        uint256 stakeTotalTime;
        if (_userLastClaimTime[user] == 0 && _userStake[user] > 0) {
            stakeTotalTime = block.timestamp - _userStakeStartTime[user];
        } else if (_userStake[user] == 0) {
            return 0;
        } else {
            stakeTotalTime = block.timestamp - _userLastClaimTime[user];
        }
        uint256 stakeMonth;
        uint256 rewardPure;
        if (_userStakeTime[user] == _stake1) {
            rewardPure = _stake1pure;
            stakeMonth = _stake1;
        } else if(_userStakeTime[user] == _stake3) {
            rewardPure = _stake3pure;
            stakeMonth = _stake3;
        } else if(_userStakeTime[user] == _stake5) {
            rewardPure = _stake5pure;
            stakeMonth = _stake5;
        }
        return rewardPure * stakeTotalTime * _userStake[user] / 10 ** 18;
    }

    //管理员取回代币
    function ownerClaimToken(address token, address recipient, uint256 amount) public onlyOwner {
        IERC20(token).transfer(recipient, amount);
    }

    //管理员设置用户状态
    function ownerSetUser(address user, uint256 amount, uint256 stakeTime, uint256 stakeStartTime, uint256 userLastClaim) public onlyOwner {
        _userStake[user] = amount;
        _userStakeTime[user] = stakeTime;
        _userStakeStartTime[user] = stakeStartTime;
        _userLastClaimTime[user] = userLastClaim;
    }

    //获取区块当前时间
    function getBlockNow() view public returns(uint256) {
        return block.timestamp;
    }

    //获取用户总质押时间
    function getUserStakeTotalTime(address user) view public returns(uint256) {
        if (_userLastClaimTime[user] == 0 && _userStake[user] > 0) {
            return block.timestamp - _userStakeStartTime[user];
        } else if (_userStake[user] == 0) {
            return 0;
        } else {
            return block.timestamp - _userLastClaimTime[user];
        }
    }

}