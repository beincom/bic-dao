import {ethers, network, run} from "hardhat";

async function main() {
    const BGT = await ethers.getContractFactory("BeinGiveTake");
    const bgt = await BGT.deploy();
    await bgt.waitForDeployment();
    const bgtAddress = await bgt.getAddress();

    console.log(`Deploy success BGT on ${bgtAddress}`);
    try {
        console.log(`Verify BGT on ${bgtAddress}`);
        await run(`verify:verify`, {
            address: bgtAddress,
            constructorArguments: [],
        });
        console.log(`Verify success BGT on ${bgtAddress}`);
    } catch (e) {
        console.log(`Verify fail BGT on ${bgtAddress} with error ${e}`);
    }

    const BgtVote = await ethers.getContractFactory("BgtVote");
    const bgtVote = await BgtVote.deploy(bgtAddress);
    await bgtVote.waitForDeployment();
    const bgtVoteAddress = await bgtVote.getAddress();

    console.log(`Deploy success BgtVote on ${bgtAddress}`);
    try {
        console.log(`Verify BgtVote on ${bgtAddress}`);
        await run(`verify:verify`, {
            address: bgtVoteAddress,
            constructorArguments: [bgtAddress],
        });
        console.log(`Verify success BgtVote on ${bgtVoteAddress}`);
    } catch (e) {
        console.log(`Verify fail BgtVote on ${bgtVoteAddress} with error ${e}`);
    }
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
