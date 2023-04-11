// SPDX-License-Identifier: MIT
// wtf.academy
pragma solidity ^0.8.17;
// UUPS逻辑合约（升级函数写在逻辑合约内）
contract UUPS1{
    // 状态变量和proxy合约一致，防止插槽冲突
    address public implementation; // 逻辑合约地址
    address public admin; // admin地址
    string public words; // 字符串，可以通过逻辑合约的函数改变
    bool public ok;
    bytes  public by;
    
        //备用
    mapping(string => string) public _backstr; //备用名称
    mapping(string => uint256) public _backuint256; //备用名称
    mapping(string => address) public _backaddress; //备用名称

    // 改变proxy中状态变量，选择器： 0xc2985578
    function foo() public{
        words = "old";
    }

    // 升级函数，改变逻辑合约地址，只能由admin调用。选择器：0x0900f010
    // UUPS中，逻辑函数中必须包含升级函数，不然就不能再升级了。
    function upgrade(address newImplementation) external {
        require(msg.sender == admin);
        implementation = newImplementation;
    }
}
