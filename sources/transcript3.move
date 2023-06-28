module hello_world::transcript {

    // imports
    use sui::object::{Self,UID};
    use sui::tx_context::{Self,TxContext};
    use sui::transfer;

    // types
     struct TranscriptObject has key{
        id:UID,
        history: u8,
        math:u8,
        literature:u8
    }

     struct WrappableTranscript has key, store{
        id:UID,
        history: u8,
        math:u8,
        literature:u8
    }
    struct Folder has key {
        id:UID,
        transcript : WrappableTranscript,
        intended_address: address
    }

    // 教师
    struct TeacherCap has key {
        id:UID,
    }

    // init
    fun init(ctx: &mut TxContext){
        transfer::transfer(TeacherCap{
            id:object::new(ctx)
        },tx_context::sender(ctx))
    }

    // funtions
    // public entry fun create_transcript_object(history:u8,math:u8,literature:u8,ctx: &mut TxContext){
    public entry fun create_transcript_object(_: &TeacherCap,history:u8,math:u8,literature:u8,ctx: &mut TxContext){
        let transcriptObject = TranscriptObject {
            id: object::new(ctx),
            history,
            math,
            literature
        }
        transfer::transfer(transcriptObject,tx_context::sender(ctx));
    }

    public entry fun add_additional_teacher(_: &TeacherCap, new_teacher_address: address, ctx: &mut TxContext){
        transfer::transfer(
            TeacherCap{
                id:object::new(ctx)
            },
            new_teacher_address
        )
    }

    // 查看
    public fun view(transcriptObject : &TranscriptObject): u8{
        transcriptObject.literature
    }

}