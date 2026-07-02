// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {FHE, euint64, externalEuint64} from "@fhevm/solidity/lib/FHE.sol";
import {ZamaEthereumConfig} from "@fhevm/solidity/config/ZamaConfig.sol";

/// @title ZamaPay confidential ETH payment vault
/// @notice Phase 1 skeleton for confidential balances and payments using Zama FHEVM.
contract ZamapayVault is ZamaEthereumConfig {
    mapping(address user => euint64 balance) private _balances;

    event Shielded(address indexed user, uint256 ethAmount);
    event Transferred(address indexed from, address indexed to);
    event Unshielded(address indexed user);

    function shield(externalEuint64 encryptedAmount, bytes calldata inputProof) external payable {
        require(msg.value > 0, "ZamapayVault: ETH required");

        euint64 amount = FHE.fromExternal(encryptedAmount, inputProof);

        if (FHE.isInitialized(_balances[msg.sender])) {
            _balances[msg.sender] = FHE.add(_balances[msg.sender], amount);
        } else {
            _balances[msg.sender] = amount;
        }

        FHE.allowThis(_balances[msg.sender]);
        FHE.allow(_balances[msg.sender], msg.sender);

        emit Shielded(msg.sender, msg.value);
    }

    function balanceOf(address user) external view returns (euint64) {
        return _balances[user];
    }

    function transfer(address to, externalEuint64 encryptedAmount, bytes calldata inputProof) external {
        require(to != address(0), "ZamapayVault: zero recipient");
        require(to != msg.sender, "ZamapayVault: self transfer");

        euint64 amount = FHE.fromExternal(encryptedAmount, inputProof);

        _balances[msg.sender] = FHE.sub(_balances[msg.sender], amount);

        if (FHE.isInitialized(_balances[to])) {
            _balances[to] = FHE.add(_balances[to], amount);
        } else {
            _balances[to] = amount;
        }

        FHE.allowThis(_balances[msg.sender]);
        FHE.allow(_balances[msg.sender], msg.sender);
        FHE.allowThis(_balances[to]);
        FHE.allow(_balances[to], to);

        emit Transferred(msg.sender, to);
    }

    function unshield(externalEuint64 encryptedAmount, bytes calldata inputProof) external {
        euint64 amount = FHE.fromExternal(encryptedAmount, inputProof);

        _balances[msg.sender] = FHE.sub(_balances[msg.sender], amount);

        FHE.allowThis(_balances[msg.sender]);
        FHE.allow(_balances[msg.sender], msg.sender);

        emit Unshielded(msg.sender);
    }
}
