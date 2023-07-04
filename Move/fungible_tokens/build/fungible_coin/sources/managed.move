// Copyright (c) Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0

/// Example coin with a trusted manager responsible for minting/burning (e.g., a stablecoin)
/// By convention, modules defining custom coin types use upper case names, in contrast to
/// ordinary modules, which use camel case.
module fungible_coin::managed {
    use std::option;
    use sui::coin::{Self, Coin, TreasuryCap, CoinMetadata};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::url;

    // Define the structure "MANAGED". The keyword "has drop" indicates that instances of the type can be discarded.
struct MANAGED has drop {}
struct INPUT<T> has key, store, drop{
    obj: T
}

// Define the initialization function for the "MANAGED" structure.
// This function takes two arguments - a "MANAGED" witness and a mutable transaction context.
fun init(witness: MANAGED, ctx: &mut TxContext) {
    // Setting variables for the coin details.
    // Number of decimals to be used in the coin value.
    let decimals = 2;
    // The symbol of the coin, given in byte array format.
    let symbol = b"SYMBOL_OF_THE_COIN";
    // The name of the coin, provided as a byte array.
    let name = b"NAME_OF_THE_COIN";
    // A short description for the coin, also given as a byte array.
    let description =  b"DESCRIPTION_OF_THE_COIN";
    // The URL of the coin's icon, wrapped in an Option value using the "option::some" function.
    let icon_url = option::some(url::new_unsafe_from_bytes(b"https://blog.sui.io/content/images/2023/04/Sui_Droplet_Logo_Blue-3.png"));

    // Creating the coin currency with the defined details and obtaining the treasury cap and metadata.
    let (treasury_cap, metadata) = coin::create_currency<MANAGED>(witness, decimals, symbol, name, description, icon_url, ctx);
    // Freezing the metadata object to prevent further modifications.
    let input = INPUT{obj: metadata};
    transfer::public_freeze_object(input);
    // Minting 100000 coins and transferring them to the sender of the transaction.
    coin::mint_and_transfer(&mut treasury_cap, 100000, tx_context::sender(ctx), ctx);
    // Publicly transferring the treasury cap to the transaction sender.
    transfer::public_transfer(treasury_cap, tx_context::sender(ctx))
}

    public entry fun mint(
        treasury_cap: &mut TreasuryCap<MANAGED>, amount: u64, recipient: address, ctx: &mut TxContext
    ) {
        coin::mint_and_transfer(treasury_cap, amount, recipient, ctx)
    }

    /// Manager can burn coins
    public entry fun burn(treasury_cap: &mut TreasuryCap<MANAGED>, coin: Coin<MANAGED>) {
        coin::burn(treasury_cap, coin);
    }

}
// Publish it by running `sui client publish . --gas COIN_OBJECT_ID --gas-budget 300000000 --skip-dependency-verification`