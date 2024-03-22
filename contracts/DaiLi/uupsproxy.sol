// SPDX-License-Identifier: MIT
// wtf.academy
pragma solidity ^0.8.4;




// UUPS的Proxy，跟普通的proxy像。
// 升级函数在逻辑函数中，管理员可以通过升级函数更改逻辑合约地址，从而改变合约的逻辑。
// 教学演示用，不要用在生产环境
contract UUPSProxy {
    address public implementation; // 逻辑合约地址
    address public admin; // admin地址
    string public words; // 字符串，可以通过逻辑合约的函数改变
    bool public ok;
    bytes  public by;
        //备用
    mapping(string => string) public _backstr; //备用名称
    mapping(string => uint256) public _backuint256; //备用名称
    mapping(string => address) public _backaddress; //备用名称



    // 构造函数，初始化admin和逻辑合约地址
    constructor(address _implementation){
        admin = msg.sender;
        implementation = _implementation;
    }

     event fallbackEmit(bool success1,string bytes_data);
    //  event fallbackEmit1(string indexed str);

      // fallback函数，将调用委托给逻辑合约   0xc2985578
    fallback() external payable {
        (bool success, bytes memory data) = implementation.delegatecall(msg.data);       
        // require(success == true,string(data));        
        emit fallbackEmit(success,string(data));        
    }

    // // fallback函数，将调用委托给逻辑合约
    // fallback() external payable {
    //     (bool success, bytes memory data) = implementation.delegatecall(msg.data);
    //     // success=false;
       
    // }
}

