## Hello

- 官方说明: https://docs.sui.io/build/sui-local-network#install-sui-locally
- 中文文档: https://move-book.com/cn/index.html
- 英文文档:
  - packages: https://move-language.github.io/move/packages.html
- sui farmework:
  - docs: https://github.com/MystenLabs/sui/tree/main/crates/sui-framework/docs
- 教程: https://github.com/sui-foundation/sui-move-intro-course/blob/main/unit-four/lessons/2_dynamic_fields.md
  - https://github.com/randypen/sui-move-intro-course-zh/blob/main/unit-four/lessons/2_dynamic_fields.md

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

**数组**: vectors

- `vector::empty<T>()`
- `vector::push_back<T>()` 创建
- `vector::pop_back<T>(,value)` put
- `vector::pop_back<T>()` remove
- `vector::length<T>()` size

**动态字段**

```
struct Parent has key{
  id: UID
}

// dynamic field
struct DFChild has store{
  count:u64
}


// dynamic object field
struct DOFChild has key,store{
  id:UID,
  count:u64
}
```

- 动态字段：可以存储任何具有 store 能力的值，但是储存在这种字段种的对象被视为被包装过。无法直接访问，可以通过浏览器查看存储 ID
- 动态对象字段：值必须是 Sui 对象（具有 key store，以及 `id: UID` 作为第一个字段）。仍然可以通过对象 id 直接访问被附上。

方法

- 添加都是 `xxx::add()`，但是使用不同的包 `ofield / field`
- 修改: `xxx::borrow`
- 删除: `xxx::remove`
  - 动态: `object::delete(id);`
  - 动态对象: `transfer::transfer(child, tx_context::sender(ctx));`

```
module collection::dynamic_fields {

    use sui::dynamic_object_field as ofield;
    use sui::dynamic_field as field;

  // Adds a DFChild to the parent object under the provided name
  public fun add_dfchild(parent: &mut Parent, child: DFChild, name: vector<u8>) {
      field::add(&mut parent.id, name, child);
  }

  // Adds a DOFChild to the parent object under the provided name
  public entry fun add_dofchild(parent: &mut Parent, child: DOFChild, name: vector<u8>) {
      ofield::add(&mut parent.id, name, child);
  }
}
```

**映射**: table, table 是对动态字段的封装.

- `table::add`
- `table::remove`
- `table::borrow`
- `table::borrow_mut`
- `table::coitains`
- `table::length`

**异构集合 Bag 类型**

vector 和 table 可以保存相同类型的元素，如果对于不同类型的对象，或者在变异时不知道要保存什么类型的对象。则需要异构集合的概念。

- `bag::new(ctx)`
- `bag::add(&mut bag.items, k, v);`
- `bag::remove(&mut bag.items, k)`
- `bag::borrow(&bag.items, k)`
- `bag::borrow_mut(&mut bag.items, k)`
- `bag::contains<K>(&bag.items, k)`
- `bag::length(&bag.items)`

Bag 集合交互的函数签名与与 Table 集合交互的函数签名非常相似,都是对对动态字段的封装. 底层一样的。

主要区别在于在创建新的 Bag 时不需要声明任何类型，并 添加到其中的键值对类型不需要是相同的类型。
