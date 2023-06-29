#[test_only]
module fungible_token::managed_tests {
    // use std::option;
    // use sui::coin::{Self,Coin,TreasuryCap};x
    // use sui::transfer;
    use sui::tx_context::{Self,TxContext};

    use fungible_token::managed::{Self,MANAGED};
    use sui::coin::{Coin,TreasuryCap};
    use sui::test_scenario::{Self,next_tx,ctx};
    use std::debug;

    #[test]
    fun mint_burn(){
        let addr1 = @0xA;

        // 开始
        let scenario = test_scenario::begin(addr1);
        // debug::print(&(sender(ctx &mut scenario))));

        {
            managed::test_init(ctx(&mut TxContext));
        };

        // mint
        next_tx(&mut scenario,addr1);
        {
            let treasurycap = test_scenario::take_from_sender<TreasuryCap<MANAGED>>(&scenario);
            managed::mint(&mut treasurycap,100,addr1,test_scenario::ctx(&mut TxContext));
            test_scenario::return_to_address<TreasuryCap<MANAGED>>(addr1,treasurycap);
        };


        // burn
        next_tx(&mut scenario,addr1);
        {
            let coin = test_scenario::take_from_sender<Coin<MANAGED>>(&scenario);
            let treasurycap = test_scenario::take_from_sender<TreasuryCap<MANAGED>>(&scenario);
            managed::burn(&mut treasurycap,100,coin);
            test_scenario::return_to_address<TreasuryCap<MANAGED>>(addr1,treasurycap);
        };


        // 结束
        test_scenario::end(scenario);

    }
 
}