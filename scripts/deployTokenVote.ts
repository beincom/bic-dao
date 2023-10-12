import {ethers, network, run} from "hardhat";

async function main() {
    const TokenVote = await ethers.getContractFactory("TokenVote");
    const tokenVote = await TokenVote.deploy();
    await tokenVote.waitForDeployment();
    const tokenVoteAddress = await tokenVote.getAddress();

    console.log(`Deploy success TokenVote on ${tokenVoteAddress}`);
    try {
        console.log(`Verify TokenVote on ${tokenVoteAddress}`);
        await run(`verify:verify`, {
    address: tokenVoteAddress,
    constructorArguments: [],
    });
        console.log(`Verify success TokenVote on ${tokenVoteAddress}`);
    } catch (e) {
        console.log(`Verify fail TokenVote on ${tokenVoteAddress} with error ${e}`);
    }

    const BicGovernor = await ethers.getContractFactory("BicGovernor");
    const bicGovernor = await BicGovernor.deploy(tokenVoteAddress);
    await bicGovernor.waitForDeployment();
    const bicGovernorAddress = await bicGovernor.getAddress();

    // const bicGovernorAddress = "0x1fF8593316c5DEC3a181a1955386d32f67932E97"

    console.log(`Deploy success BicGovernor on ${bicGovernorAddress}`);
    try {
        console.log(`Verify BicGovernor on ${bicGovernorAddress}`);
        await run(`verify:verify`, {
    address: bicGovernorAddress,
    constructorArguments: [tokenVoteAddress],
    // constructorArguments: ["0x9ba1537e29290aB2147fef34504E3ec65891b25A"],
    });
        console.log(`Verify success BicGovernor on ${bicGovernorAddress}`);
    } catch (e) {
        console.log(`Verify fail BicGovernor on ${bicGovernorAddress} with error ${e}`);
    }
}

main().catch((error) => {
console.error(error);
process.exitCode = 1;
});
