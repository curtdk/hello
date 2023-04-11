// SPDX-License-Identifier: MIT
// wtf.academy
pragma solidity ^0.8.19;

// 选择器冲突的例子
// 去掉注释后，合约不会通过编译，因为两个函数有着相同的选择器
contract Foo {
    bytes4 public selector1 = bytes4(keccak256("burn(uint256)"));
    bytes4 public selector2 = bytes4(keccak256("collate_propagate_storage(bytes16)"));
    bytes public  selector=abi.encodeWithSignature("upgrade1(address)");
    // function burn(uint256) external {}
    // function collate_propagate_storage(bytes16) external {}
}


// 透明可升级合约的教学代码，不要用于生产。
contract TransparentProxy {
    address public  implementation; // logic合约地址
    address public admin; // 管理员
    string public words; // 字符串，可以通过逻辑合约的函数改变
    bytes public selector;
    bytes public selector5;

    // 构造函数，初始化admin和逻辑合约地址
    constructor(address _implementation){
        admin = msg.sender;
        implementation = _implementation;
        selector=abi.encodeWithSignature("foo()");
        selector5=abi.encodeWithSignature("foo(uint)",5);

    }

    // fallback函数，将调用委托给逻辑合约
    // 不能被admin调用，避免选择器冲突引发意外
    fallback() external payable {
        require(msg.sender != admin);
        (bool success, bytes memory data) = implementation.delegatecall(msg.data);
    }

    // 升级函数，改变逻辑合约地址，只能由admin调用
    function upgrade(address newImplementation) public {
        if (msg.sender != admin) revert();
        implementation = newImplementation;
    }
}

// 旧逻辑合约
contract Logic1 {
     address public  implementation; // logic合约地址
    address public admin; // 管理员
    string public words; // 字符串，可以通过逻辑合约的函数改变
    bytes public selector;
    bytes public selector5;    


    // 升级函数，改变逻辑合约地址，只能由admin调用。选择器：0x0900f010
    // UUPS中，逻辑函数中必须包含升级函数，不然就不能再升级了。
    function upgrade1(address newImplementation) external {
        require(msg.sender == admin);
        implementation = newImplementation;
         words = "upgrade1";
    }


      function foo() public{
        words = "old";
    }

      function f1() public{
        words = "oldf1";
    }
   
    // 改变proxy中状态变量，选择器： 0xc2985578
    function f2(uint8 t_1) public{
         t_1=8;
        words = "old0";
    }
      function f3(address t_s) public{          
        words = "address";
    }
}

// 新逻辑合约
contract Logic2 {
    address public  implementation; // logic合约地址
    address public admin; // 管理员
    string public words; // 字符串，可以通过逻辑合约的函数改变
    bytes public selector;
    bytes public selector5;


      // 升级函数，改变逻辑合约地址，只能由admin调用。选择器：0x0900f010
    // UUPS中，逻辑函数中必须包含升级函数，不然就不能再升级了。
    function upgrade1(address newImplementation) external {
        require(msg.sender == admin);
        implementation = newImplementation;
         words = "upgrade1";
    }


      function f1() public{
        words = "newf1";
    }



     // 改变proxy中状态变量，选择器：0xc2985578
    function foo() public{
        words = "new";
    }   

    // 改变proxy中状态变量，选择器：0xc2985578
    function foo(uint t_1) public{
        t_1=9;
        words = "new0";
    }
     function foo1(uint t_1) public{
          t_1=10;
        words = "new1";
    }
    
}