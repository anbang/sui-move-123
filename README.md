## Hello

- 官方说明: https://docs.sui.io/build/sui-local-network#install-sui-locally
- 中文文档: https://move-book.com/cn/index.html
- 英文文档:
  - packages: https://move-language.github.io/move/packages.html
- sui farmework:
  - docs: https://github.com/MystenLabs/sui/tree/main/crates/sui-framework/docs

## 创建 SUI 项目

创建命令: `sui move new hello_world`

项目结构

```
├── Move.toml
├── README.md
├── doc_templates
│   └── XXXX
├── examples
│   └── XXXX
├── sources
│   └── hello_world.move
└── tests
    └── XXXX
```

## Move.toml 3 个部分

- package
- dependencies
- addresses

## 常见命令

```
sui client addresses
sui client active-address

sui client active-env
sui client envs

sui move build

sui client publish --gas-budget 3000 --skip-fetch-latest-git-deps

# 调用方法
sui client call --function mint2 --module hello_world --package 0x666 --args "你好，世界!" --gas-budget 3000
```

## sui move 语法

```
module package_name::module_name {

    // imports
    // use <Address/Alias>::<ModuleName>;
    use std::string;
    use sui::object::{Self,UID};
    use sui::transfer;
    use sui::tx_context::{Self,TxContext};

    // types
    // 拥有四种能力 copy,drop,key,store,
    struct HelloWorldObjects has key,store{
        id:UID,
        text: string::String
    }

    // functions
    // 拥有三种可见性: private/public/public(friend)

    // entry 函数
    public entry fun mint(ctx: &mut TxContext){
        let object = HelloWorldObjects{
            id : object::new(ctx),
            text : string::utf8(b"Hello World!")
        };
        transfer::transfer(object,tx_context::sender(ctx));
    }
}
```

**所有权类型**

- 被拥有
  - 被一个地址拥有
  - 被另一个 object 拥有
- 共享
  - 不可变的共享
    - `transfer`
  - 可变的共享

**不可变的对象**: `transfer::freeze_object(obj)`

**共享对象**: `transder::share_object(obj)`

参数传递与删除 Object

- view: `(transcriptObject : &TranscriptObject)`
- update: `(transcriptObject : &mut TranscriptObject,score :u8)`
- delete: `(transcriptObject : TranscriptObject)`

**范型**

```
module Storage{
  struct Box<T: store + drop> has key, store{
    value: T
  }
}
```

phantom 关键字

```
struct Box<T: store> has key, store{
  id: UID
  value: T
}
struct BoomBox<phantom T> has key{
  id:UID
}
```

```
public entry fun create_box<T: store>(value: T, ctx: &mut TxContent){}
```

**witness**: 只能被启动一次，必须具有 drop 能力，使用后必须立即被销毁或丢弃，确保不能重复使用。

**One Time Witness**: (OTW),一个 move 包整个生命周期只能创建这一个 witness。（普通的 witness 无此限制）。OTW 创建的资源可以保证是整个区块链上都是唯一的。

- 名字使用"大写的模块名"
- 该类型只具有 drop 能力

```
module fungible_tokens::move{
  struct MOVE has drop{};  // OTW
  fun init(witness:MOVE, ctx: &mut TxContext){}
}
```

## 菜单相关的媒体信息

- Discord: https://discord.com/invite/2gTrfhYrmu
- GitHub : https://github.com/FiboChain
- telegram : https://t.me/FIBOGlobalCommunity
- twitter : https://twitter.com/FIBOGlobal
- Youtube : ❌ 隐藏
- Blog : https://medium.com/@Fibonaccichain
- 新闻 : ❌ 隐藏
- 事件 : ❌ 隐藏

## 顶部菜单

- 开发者
  - Start Building : 现在官网 - 开发者首页
  - 设置本地环境 : ❌ 隐藏
  - 开发者文档 : ❌ 隐藏
  - 黑客松 : ❌ 隐藏
  - Github : https://github.com/FiboChain
  - 白皮书: https://fibonaccilabs.gitbook.io/litepaper_cn/gai-shu/gong-lian-jie-shao
- 生态
  - 跨链桥: https://bridge.fibochain.org/
  - 钱包: 跳转到【当前官网-钱包页面-Figbox 区域】
  - 浏览器: https://scan.fibochain.org/
  - 发现应用: 【 当前官网-生态页面 】
  - 应用提交: ❌ 隐藏
- 关于: about 页面

## 底部菜单栏

- 使用 Fibo
  - 获取 FIBO 币:【 当前官网-获取 FIBO 页面 】
  - 发现应用【 当前官网-生态页面 】
  - 质押 FIBO: ❌ 隐藏
  - 安装钱包【当前官网-钱包页面】
- Build
  - 设置本地环境: ❌ 隐藏
  - 部署只能合约: ❌ 隐藏
  - 参与贡献: ❌ 隐藏
  - 白皮书: https://fibonaccilabs.gitbook.io/litepaper_cn/gai-shu/gong-lian-jie-shao
  - 资源下载: ❌ 隐藏
- About
  - 隐私协议: ❌ 隐藏
  - FAQ: ❌ 隐藏
  - 联系我们: https://discord.com/invite/2gTrfhYrmu
  - 博客: https://medium.com/@Fibonaccichain
