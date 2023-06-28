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

    const ENotIntendedAddress: u64 = 1;

    public entry fun request_transcript(transcript:WrappableTranscript,intended_address:address,ctx: &mut TxContext){
        let folderObject = Folder{
            id:object::new(ctx),
            transcript,
            intended_address
        };
        transfer::transfer(folderObject,intended_address);
    }

    public entry fun unpack_wrapped_transcript(folder:Folder,ctx: &mut TxContext){
        assert!(folder.intended_address == tx_context::sender(ctx),ENotIntendedAddress);
        let Folder {
            id,
            transcript,
            intended_address:_,
        } = folder;
        transfer::transfer(transcript,tx_context::sender(ctx));

        //delete
        object::delete(id);
    }
   

}