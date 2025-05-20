// SPDX-License-Identifier: MIT
pragma solidity 0.8.0; // Change from ^0.8.17 to ^0.8.0

contract SHA256Precompile {
    // SHA256 Precompile Address (0x02)
    address constant SHA256_PRECOMPILE = address(0x02);

    // Function that calls SHA256 Precompile
    function hashWithSHA256(bytes memory data) public view returns (bytes32) {
        (bool success, bytes memory result) = SHA256_PRECOMPILE.staticcall(data);
        require(success, "SHA256 Precompile call failed");
        return abi.decode(result, (bytes32));
    }
}

