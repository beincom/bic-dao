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

    const BIC = await ethers.getContractFactory("BeinChain");
    const bic = await BIC.deploy();
    await bic.waitForDeployment();
    const bicAddress = await bic.getAddress();

    console.log(`Deploy success BIC on ${bicAddress}`);
    try {
        console.log(`Verify BIC on ${bicAddress}`);
        await run(`verify:verify`, {
            address: bicAddress,
            constructorArguments: [],
        });
        console.log(`Verify success BIC on ${bicAddress}`);
    } catch (e) {
        console.log(`Verify fail BIC on ${bicAddress} with error ${e}`);
    }

    const BicPower = await ethers.getContractFactory("BicPower");
    const bicPower = await BicPower.deploy(bgtAddress, bicAddress);
    await bicPower.waitForDeployment();
    const bicVotesAddress = await bicPower.getAddress();

    console.log(`Deploy success BicPower on ${bicVotesAddress}`);
    try {
        console.log(`Verify BicPower on ${bicVotesAddress}`);
        await run(`verify:verify`, {
            address: bicVotesAddress,
            constructorArguments: [bgtAddress, bicAddress],
        });
        console.log(`Verify success BicPower on ${bicVotesAddress}`);
    } catch (e) {
        console.log(`Verify fail BicPower on ${bicVotesAddress} with error ${e}`);
    }

    const BicGovernor = await ethers.getContractFactory("BicGovernor");
    const bicGovernor = await BicGovernor.deploy(bicVotesAddress, 60, 300, 100);
    await bicGovernor.waitForDeployment();
    const bicGovernorAddress = await bicGovernor.getAddress();

    console.log(`Deploy success BicGovernor on ${bicGovernorAddress}`);
    try {
        console.log(`Verify BicGovernor on ${bicGovernorAddress}`);
        await run(`verify:verify`, {
            address: bicGovernorAddress,
            constructorArguments: [bicVotesAddress, 60, 300, 100],
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
