// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {FHE, euint64, externalEuint64} from "@fhevm/solidity/lib/FHE.sol";
import {ZamaEthereumConfig} from "@fhevm/solidity/config/ZamaConfig.sol";

/// @title ZamaPay confidential ETH payment vault
/// @notice Phase 1 skeleton for confidential balances and payments using Zama FHEVM.
contract ZamapayVault is ZamaEthereumConfig {
    mapping(address user => euint64 balance) private _balances;

    event ShieldRequested(address indexed user, uint256 ethAmount);
    event TransferRequested(address indexed from, address indexed to);
    event UnshieldRequested(address indexed user);

    function shield(externalEuint64, bytes calldata) external payable {}

    function balanceOf(address user) external view returns (euint64) {
        return _balances[user];
    }

    function transfer(address, externalEuint64, bytes calldata) external pure {}

    function unshield(externalEuint64, bytes calldata) external pure {}
}
