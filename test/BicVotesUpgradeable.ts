import {ethers, upgrades} from "hardhat";
import {expect} from "chai";
import {Contract} from "ethers";

describe("BicVotesUpgradeable", () => {
    let bicVotesUpgradeable: Contract;
    let bicVotesUpgradeableAddress: string;
    let bgt: Contract;
    let bgtAddress: string;
    let nftVote: Contract;
    let nftVoteAddress: string;

    beforeEach(async () => {
        const BGT = await ethers.getContractFactory("BeinGiveTake");
        bgt = await BGT.deploy();
        await bgt.waitForDeployment();
        bgtAddress = await bgt.getAddress();

        const BicVotesUpgradeable = await ethers.getContractFactory("BicVotesUpgradeable");
        bicVotesUpgradeable = await upgrades.deployProxy(BicVotesUpgradeable, [bgtAddress], {
            initializer: "initialize"
        });
        await bicVotesUpgradeable.waitForDeployment();
        bicVotesUpgradeableAddress = await bicVotesUpgradeable.getAddress();

        const NftVote = await ethers.getContractFactory("NftVote");
        nftVote = await NftVote.deploy();
        await nftVote.waitForDeployment();
        nftVoteAddress = await nftVote.getAddress();
    });

    describe("Upgrade", () => {
        it("Should upgrade the contract to V2", async () => {


            const BicVotesUpgradeableV2 = await ethers.getContractFactory("BicVotesUpgradeableV2");
            const bicVotesUpgradeableV2 = await upgrades.upgradeProxy(bicVotesUpgradeableAddress, BicVotesUpgradeableV2);
            await bicVotesUpgradeableV2.waitForDeployment();
            await bicVotesUpgradeableV2.initializeV2(nftVoteAddress);

            expect(await bicVotesUpgradeableV2.nftAddress()).to.equal(nftVoteAddress);
            expect(await bicVotesUpgradeableV2.bgtAddress()).to.equal(await bicVotesUpgradeable.bgtAddress());
        });

        it("Should upgrade the contract to V12", async () => {
            const BicVotesUpgradeableV12 = await ethers.getContractFactory("BicVotesUpgradeableV12");
            const bicVotesUpgradeableV12 = await upgrades.upgradeProxy(bicVotesUpgradeableAddress, BicVotesUpgradeableV12);
            await bicVotesUpgradeableV12.waitForDeployment();
            await bicVotesUpgradeableV12.initialize(bgtAddress, nftVoteAddress);

            expect(await bicVotesUpgradeableV12.nftAddress()).to.equal(nftVoteAddress);
            expect(await bicVotesUpgradeableV12.bgtAddress()).to.equal(await bicVotesUpgradeable.bgtAddress());
        });
    });
});
