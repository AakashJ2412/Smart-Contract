// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract SmartContract {
    uint public ListingID;
    string public ItemName;
    string public ItemDesc;
    uint public AskingPrice;
    uint public UniqueSellerID;

    string private Password;

    // 0: Unsold
    // 1: Proccessing
    // 2: Sold
    uint public State;
}
