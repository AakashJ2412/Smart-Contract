// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;


/// @title Marketplace for selling items
/// @author Aakash Jain, Ishaan Shah, Zeeshan Ahmed
/// @notice View, sell, and buy items
/// @dev It is assumed that the seller will deliver after getting paid
contract Marketplace {
    /// @dev Possible states that a Listing can take
    enum State { UNSOLD, SOLD, DELIVERED }

    /// @dev Stores the details of a listing
    struct Listing {
        uint listingID;
        string itemName;
        string itemDesc;
        uint256 askingPrice;
        address payable uniqueSellerID;
        address uniqueBuyerID;
        string item;
        State state;
    }

    uint private itemCount = 0;
    uint private itemSold = 0;

    /// @dev mapping for all the Listing
    mapping(uint256 => Listing) private listings;

    /// @notice Triggered to store the details of a listing on transaction logs
    /// @dev Must not store the item itself for privacy
    /// @param listingID Unique Id for the listing 
    /// @param itemName Name of the item
    /// @param askingPrice Price set by the seller
    /// @param uniqueSellerID The public key for the transaction
    event ListingCreated ( 
        uint indexed listingID,
        string itemName,
        uint askingPrice,
        address uniqueSellerID
    );

    /// @notice Function to add listing to the Marketplace
    /// @dev Triggers the event for logging
    /// @param price Price set by the seller
    /// @param itemName Name of the item
    /// @param itemDesc Description of the item set by seller
    /// @param item String to be sold
    function createListing(
        uint256 price,
        string memory itemName,
        string memory itemDesc,
        string memory item
    ) public {
        require(price > 0, "Price must be atleast 1 wei");

        listings[itemCount] = Listing(
            itemCount,
            itemName,
            itemDesc,
            price,
            payable(msg.sender),
            address(0),
            item,
            State.UNSOLD
        );

        emit ListingCreated(
            itemCount,
            itemName,
            price,
            msg.sender
        );
        itemCount += 1;
    }

    /// @notice Function to print all the active listings
    /// @return Listing The list of all active listings
    function fetchMarketItems() public view returns (Listing[] memory) {
        uint unsoldItemCount = itemCount - itemSold;
        uint currentIndex = 0;

        Listing[] memory items = new Listing[](unsoldItemCount);
        for (uint i = 0; i < itemCount; i++) {
            if (listings[i].state == State.UNSOLD) {
                Listing storage currentItem = listings[i];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }

    /// @notice Triggered to store the details of the sold listing on transaction logs
    /// @dev Must not store the item itself for privacy
    /// @param listingID Unique Id for the listing 
    /// @param itemName Name of the item
    /// @param askingPrice Price set by the seller
    /// @param uniqueSellerID The public key for the transaction
    /// @param uniqueBuyerID The public key for the transaction
    event ListingSold (
        uint indexed listingID,
        string itemName,
        uint askingPrice,
        address uniqueSellerID,
        address uniqueBuyerID
    );

    /// @notice Function to buy a listing
    /// @dev Triggers the event for logging
    /// @param itemId The item the buyer wants to buy
    function buyListing(uint itemId) external returns(string memory) {
        listings[itemId].uniqueBuyerID = msg.sender;
        listings[itemId].state = State.SOLD;

        return listings[itemId].item;
    }

    /// @notice Function to confirm a listing
    /// @dev Triggers the event for logging
    /// @param itemId The item the buyer wants to confirm
    function confirmListing(uint itemId) external payable {
        require(listings[itemId].state == State.SOLD && listings[itemId].uniqueBuyerID == msg.sender, "Can't confirm");
        listings[itemId].state = State.DELIVERED;
        require(listings[itemId].uniqueSellerID.send(listings[itemId].askingPrice), "Failed to transfer");

        emit ListingSold(
            listings[itemId].listingID,
            listings[itemId].itemName,
            listings[itemId].askingPrice,
            listings[itemId].uniqueSellerID,
            msg.sender
        );
    }

    /// @notice Function to allow seller to relist the item if the buyer doesn't send correct amount of Ether, doesn't confirm the delivery or change the password
    /// @dev TODO
    /// @param itemId The item the buyer wants to confirm
    /// @param item The new item (i.e the hashed password)
    function relistListing(uint itemId, string memory item) external {
        require(listings[itemId].state != State.DELIVERED && listings[itemId].uniqueSellerID == msg.sender, "Can't relist");
        listings[itemId].state = State.UNSOLD;
        listings[itemId].item = item;
    }
}
