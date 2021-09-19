const Marketplace = artifacts.require("Marketplace")


contract("Marketplace", (accounts) => {

    let marketplace; 

    const listingObj = {
        price: 100,
        itemName : "SixtyNine",
        itemDesc : "Smelly Cat smelly cat",
        item : "hash"
    }

    beforeEach(async () => {
        marketplace = await Marketplace.new({ from: accounts[0] }); 
    });

    afterEach( async () => {
        await marketplace.killMarketplace({from: accounts[0]});
    });

    it("Checks if listing is created", async () => {
        const tx = await marketplace.createListing(
            listingObj.price,
            listingObj.itemName,
            listingObj.itemDesc,
            listingObj.item
        ,
        {from: accounts[0]});

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
        assert.equal(log.args.uniqueSellerID, accounts[0]);
        
    })

    it("Checks if items are listed", async () => {
        for(let i=0;i<3;i++){
            await marketplace.createListing(
                listingObj.price,
                listingObj.itemName,
                listingObj.itemDesc,
                listingObj.item
            ,{from: accounts[i]});
        }

        let listings = await marketplace.fetchMarketItems()
        assert.equal(listings.length,3);
        const boughtItem = await marketplace.buyListing(0,{from: accounts[3]});
        listings = await marketplace.fetchMarketItems()
        assert.equal(listings.length,2);
        for(let i=0;i<2;i++){
            assert.equal(listings[i].uniqueSellerID,accounts[i+1]);
        }
    })

    it("Checks if items are being bought", async () => {
        for(let i=0;i<3;i++){
            await marketplace.createListing(
                listingObj.price,
                listingObj.itemName,
                listingObj.itemDesc,
                listingObj.item + i
            ,{from: accounts[i]});
        }

        // assert item sold = 0, after buying assert to 1, and assert hash value
        // assert event as well

        const boughtItem = await marketplace.buyListing.call(0,{from: accounts[3]});
        console.log(boughtItem)
        // listings = await marketplace.fetchMarketItems()
        // assert.equal(listings.length,2);
        // for(let i=0;i<2;i++){
        //     assert.equal(listings[i].uniqueSellerID,accounts[i+1]);
        // }
    })

    // check delivery. 
    // 3 tests - first, throws error for wrong buyer id
    // second - incorrect amount - also check wallet value
    // third - successful amount - also check wallet value

    // check relisting
})

