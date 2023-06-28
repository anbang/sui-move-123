module hello_world::hello_world {

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