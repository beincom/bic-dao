import {ethers, upgrades} from "hardhat";
import {expect} from "chai";
import {Contract, Wallet} from "ethers";
import {BicVotesUpgradeable, BicVotesUpgradeableV2, BicVotesUpgradeableV12, NftVote, BeinGiveTake} from "../typechain-types";
import {HardhatEthersSigner} from "@nomicfoundation/hardhat-ethers/signers";

describe("BicVotesUpgradeable", () => {
    let bicVotesUpgradeable: BicVotesUpgradeable;
    let bicVotesUpgradeableAddress: any;
    let bgt: BeinGiveTake;
    let bgtAddress: any;
    let nftVote: NftVote;
    let nftVoteAddress: any;
    let admin: HardhatEthersSigner, user1: HardhatEthersSigner, user2: HardhatEthersSigner;
    let adminAddress: any, user1Address: any, user2Address: any;

    beforeEach(async () => {
        const BGT = await ethers.getContractFactory("BeinGiveTake");
        bgt = await BGT.deploy();
        await bgt.waitForDeployment();
        bgtAddress = await bgt.getAddress();

        const BicVotesUpgradeable = await ethers.getContractFactory("BicVotesUpgradeable");
        bicVotesUpgradeable = await upgrades.deployProxy(BicVotesUpgradeable, [bgtAddress], {
            initializer: "initialize"
        }) as BicVotesUpgradeable;
        await bicVotesUpgradeable.waitForDeployment();
        bicVotesUpgradeableAddress = await bicVotesUpgradeable.getAddress();

        const NftVote = await ethers.getContractFactory("NftVote");
        nftVote = await NftVote.deploy();
        await nftVote.waitForDeployment();
        nftVoteAddress = await nftVote.getAddress();

        [admin, user1, user2] = await ethers.getSigners();
        adminAddress = await admin.getAddress();
        user1Address = await user1.getAddress();
        user2Address = await user2.getAddress();

        await bgt.mintTo(user1Address, 1000 as any);
        await bicVotesUpgradeable.connect(user1).delegate(user1Address);
        await nftVote.mintTo(user1Address, 1 as any);
    });

    describe("Upgrade", () => {
        it("Should upgrade the contract to V2", async () => {
            expect(await bicVotesUpgradeable.getVotes(user1Address)).to.equal(1000);
            await bicVotesUpgradeable.connect(user1).delegate(user2Address);
            await bicVotesUpgradeable.connect(user1).delegate(user1Address);

            await bgt.mintTo(user1Address, 500 as any);
            expect(await bgt.balanceOf(user1Address)).to.equal(1500);
            expect(await bicVotesUpgradeable.getVotes(user1Address)).to.equal(1500);

            const BicVotesUpgradeableV2 = await ethers.getContractFactory("BicVotesUpgradeableV2");
            const bicVotesUpgradeableV2 = await upgrades.upgradeProxy(bicVotesUpgradeableAddress, BicVotesUpgradeableV2) as BicVotesUpgradeableV2;
            await bicVotesUpgradeableV2.waitForDeployment();
            await bicVotesUpgradeableV2.initializeV2(nftVoteAddress);
            expect(await bicVotesUpgradeable.getAddress()).to.equal(await bicVotesUpgradeableV2.getAddress());

            expect(await bicVotesUpgradeableV2.nftAddress()).to.equal(nftVoteAddress);
            expect(await bicVotesUpgradeableV2.bgtAddress()).to.equal(await bicVotesUpgradeable.bgtAddress());

            expect(await bicVotesUpgradeableV2.delegates(user1Address)).to.equal(user1Address);
            expect(await bicVotesUpgradeableV2.getVotes(user1Address)).to.equal(1000);
            await bicVotesUpgradeableV2.connect(user1).delegate(user1Address);
            expect(await nftVote.balanceOf(user1Address)).to.equal(1);
            expect(await bicVotesUpgradeableV2.balanceOf(user1Address)).to.equal(2000);
            expect(await bicVotesUpgradeableV2.getVotes(user1Address)).to.equal(1001);
        });

        it("Should upgrade the contract to V12", async () => {
            const BicVotesUpgradeableV12 = await ethers.getContractFactory("BicVotesUpgradeableV12");
            const bicVotesUpgradeableV12 = await upgrades.upgradeProxy(bicVotesUpgradeableAddress, BicVotesUpgradeableV12) as BicVotesUpgradeableV12;
            await bicVotesUpgradeableV12.waitForDeployment();
            await bicVotesUpgradeableV12.initialize(bgtAddress, nftVoteAddress);
            expect(await bicVotesUpgradeable.getAddress()).to.equal(await bicVotesUpgradeableV12.getAddress());

            expect(await bicVotesUpgradeableV12.nftAddress()).to.equal(nftVoteAddress);
            expect(await bicVotesUpgradeableV12.bgtAddress()).to.equal(await bicVotesUpgradeable.bgtAddress());
            expect(await bicVotesUpgradeableV12.delegates(user1Address)).to.equal(user1Address);
            expect(await bicVotesUpgradeableV12.getVotes(user1Address)).to.equal(1000);
            await bicVotesUpgradeable.connect(user1).delegate(user2Address);
            await bicVotesUpgradeable.connect(user1).delegate(user1Address);
            expect(await nftVote.balanceOf(user1Address)).to.equal(1);
            expect(await bicVotesUpgradeableV12.balanceOf(user1Address)).to.equal(2000);

            console.log("1");
            expect(await bicVotesUpgradeableV12.getVotes(user1Address)).to.equal(1001);
            console.log("2");
        });
    });
});
