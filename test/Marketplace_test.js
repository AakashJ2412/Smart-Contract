const Marketplace = artifacts.require("Marketplace")


contract("Marketplace", () => {
    const listingObj = {
        price: 100,
        itemName : "SixtyNine",
        itemDesc : "Smelly Cat smelly cat",
        item : "hash"
    }

    it("Check if listing is created", async () => {
        const marketplace = await Marketplace.deployed();
        const tx = await marketplace.createListing(
            listingObj.price,
            listingObj.itemName,
            listingObj.itemDesc,
            listingObj.item
        );

        const listings = await marketplace.fetchMarketItems()
        assert.equal(listingObj.price,listings[0].askingPrice);
        assert.equal(listingObj.itemName,listings[0].itemName);
        assert.equal(listingObj.itemDesc,listings[0].itemDesc);
        assert.equal(listings[0].item,'');
        const { logs } = tx;
        assert.ok(Array.isArray(logs));
        assert.equal(logs.length, 1);

        const log = logs[0];
        assert.equal(log.event, 'ListingCreated');
        assert.equal(log.args.itemName.toString(), listingObj.itemName);
        assert.equal(log.args.listingID, 0);
        assert.equal(log.args.askingPrice, listingObj.price);
        // TODO: add seller ID assert
    })
})

