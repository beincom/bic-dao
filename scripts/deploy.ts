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

    const BicVotes = await ethers.getContractFactory("BicVotes");
    const bicVotes = await BicVotes.deploy(bgtAddress);
    await bicVotes.waitForDeployment();
    const bicVotesAddress = await bicVotes.getAddress();

    console.log(`Deploy success BicVotes on ${bicVotesAddress}`);
    try {
        console.log(`Verify BicVotes on ${bicVotesAddress}`);
        await run(`verify:verify`, {
            address: bicVotesAddress,
            constructorArguments: [bgtAddress],
        });
        console.log(`Verify success BicVotes on ${bicVotesAddress}`);
    } catch (e) {
        console.log(`Verify fail BicVotes on ${bicVotesAddress} with error ${e}`);
    }

    const BicGovernor = await ethers.getContractFactory("BicGovernor");
    const bicGovernor = await BicGovernor.deploy(bicVotesAddress);
    await bicGovernor.waitForDeployment();
    const bicGovernorAddress = await bicGovernor.getAddress();

    // const bicGovernorAddress = "0x1fF8593316c5DEC3a181a1955386d32f67932E97"

    console.log(`Deploy success BicGovernor on ${bicGovernorAddress}`);
    try {
        console.log(`Verify BicGovernor on ${bicGovernorAddress}`);
        await run(`verify:verify`, {
            address: bicGovernorAddress,
            constructorArguments: [bicVotesAddress],
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
