module hello_world::transcript4_events {

    // imports
    use sui::object::{Self,ID,UID};
    use sui::tx_context::{Self,TxContext};
    use sui::transfer;
    use sui::event;

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

    // Events
    struct TranscriptRequestEvent has copy,drop{
        wapper_id:ID,
        requester:address,
        intended_address:address
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

    public entry fun request_transcript(transcript:WrappableTranscript,intended_address:address,ctx: &mut TxContext){
        let folderObject = Folder{
            id:object::new(ctx),
            transcript,
            intended_address
        };
        // 触发event
        event::emit(TranscriptRequestEvent{
            wapper_id:object::uid_to_inner(&folderObject.id),
            requester:tx_context::sender(ctx),
            intended_address
        })
        transfer::transfer(folderObject,intended_address);
    }

}