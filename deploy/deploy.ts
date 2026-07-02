import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;

  const deployedZamapayVault = await deploy("ZamapayVault", {
    from: deployer,
    log: true,
  });

  console.log(`ZamapayVault contract: `, deployedZamapayVault.address);
};
export default func;
func.id = "deploy_zamapayVault"; // id required to prevent reexecution
func.tags = ["ZamapayVault"];
