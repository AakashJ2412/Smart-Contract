// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Marketplace {
    enum State { UNSOLD, SOLD }
    struct Listing {
        uint listingID;
        string itemName;
        string itemDesc;
        uint256 askingPrice;
        address payable uniqueSellerID;
        // Encrypt with owners private key
        string password;
        State state;
    }

    uint private itemCount = 0;
    uint private itemSold = 0;

    mapping(uint256 => Listing) private listings;

    event ListingCreated ( 
        uint indexed listingID,
        string itemName,
        uint askingPrice,
        address uniqueSellerID,
    )

    function createListing(uint256 price, string itemName, string itemDesc, string password) public {
        require(price > 0, "Price must be atleast 1 wei");

        listings[itemCount] = Listing(
            itemCount,
            itemName,
            itemDesc,
            price,
            payable(msg.sender),
            // Encrypt this
            password,
            State.UNSOLD
        );

        emit ListingCreated(
            itemCount,
            itemName,
            askingPrice,
            msg.sender
        )
        itemCount += 1;
    }

    function fetchMarketItems() public view returns (Listing[] memory) {
      uint unsoldItemCount = itemCount - itemSold;
      uint currentIndex = 0;

      Listing[] memory items = new Listing[](unsoldItemCount);
      for (uint i = 0; i < itemCount; i++) {
        if (listings[i].state == State.UNSOLD) {
          MarketItem storage currentItem = idToMarketItem[i];
          items[currentIndex] = currentItem;
          currentIndex += 1;
        }
      }

      return items;
    }
}

