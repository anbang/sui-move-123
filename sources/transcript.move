module hello_world::transcript {

    // imports
    use sui::object::{Self,UID};
    use sui::tx_context::{Self,TxContext};
    use sui::transfer;

    // types
    //  struct Transcript {
    //     history: u8,
    //     math:u8,
    //     literature:u8
    // }
     struct TranscriptObject has key{
        id:UID,
        history: u8,
        math:u8,
        literature:u8
    }
  
    // funtions
    public entry fun create_transcript_object(history:u8,math:u8,literature:u8,ctx: &mut TxContext){
        let transcriptObject = TranscriptObject {
            id: object::new(ctx),
            history,
            math,
            literature
        }
        // 默认分配给sender
        transfer::transfer(transcriptObject,tx_context::sender(ctx));

        // 不可变obj ，immutable , 不可逆操作: 可以被任何人引用。可以作为代币的名称等
        // transfer::freeze_object(transcriptObject)

        // share: 任何人都可以修改
        // transfer::share_object(transcriptObject)
    }

    // 查看
    public fun view(transcriptObject : &TranscriptObject): u8{
        transcriptObject.literature
    }

    // 更新
    public fun update(transcriptObject : &mut TranscriptObject,score :u8){
        transcriptObject.literature = score
    }

    // 删除
    public fun delete(transcriptObject : TranscriptObject){
        let TranscriptObject{id,history:_,literature:_} = transcriptObject;
        object.delete(id)
    }

}