const Marketplace = artifacts.require("Marketplace")


contract("Marketplace", () => {
    const listingObj = {
        price: 100,
        itemName = "SixtyNine",
        itemDesc = "Smelly Cat smelly cat",
        item = "hash"
    }

    it("Check if listing is created", async () => {
        const marketplace = await Marketplace.deployed();
        await marketplace.createListing(listingObj.price,
            listingObj.itemName,
            listingObj.itemDesc,
            listingObj.item
        );

        const listings = await marketplace.fetchMarketItems()
        console.log(listings)
    })
})

