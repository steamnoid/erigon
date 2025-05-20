Because of hardware requirements I was not able to spin up a local devnet. I used the remote deployed testnet Cardona.
I create a dedicated wallet and funded it using a faucet.

Required: foundry, jq

Steps to reproduce the results:

Stage 1
```bash
cd stage_1
./stage_1.sh
Output:
🔹 SHA256 Precompile Automation with Cast (Direct Call)
🔹 Message is: Gateway.fm
🔹 Hexadecimal Representation: 476174657761792e666d
🔹 Calling SHA256 Precompile Directly via Cast...
🔹 Calculating Expected SHA256 Hash Locally...
🔹 Expected SHA256 Hash: 2b371301d100e168ccc4e6dad8f3428bf32bbc5ad9ddd9d7419da76eaf73d17a
✅ Verification Successful: Precompile Hash Matches Local Calculation.

🔹 Transaction Summary:
Message:          Gateway.fm
Hex Message:      0x476174657761792e666d
Precompile Hash:  0x2b371301d100e168ccc4e6dad8f3428bf32bbc5ad9ddd9d7419da76eaf73d17a
Expected Hash:    2b371301d100e168ccc4e6dad8f3428bf32bbc5ad9ddd9d7419da76eaf73d17a
```

Stage 2
```bash
cd ../stage_2
./stage_2.sh
Output: 
🔹 SHA256 Precompile Contract Deployment with Cast
🔹 Compiling Solidity Contract...
[⠊] Compiling...
[⠒] Compiling 1 files with Solc 0.8.0
[⠢] Solc 0.8.0 finished in 10.40ms
Compiler run successful!
🔹 Deploying Contract (Legacy Transaction)...
🔹 Deployment Transaction Hash: 0x96e23ed8f671448f817917086930a51f2310160fe62ccd20f820950302cb1874
🔹 Deployment Transaction Contract Address: 0x38596e79bCFEf1d8E1F40B103600050C28c53e06
✅ Status Verification Successful
🔹 Status: 1
🔹 Verifying Contract Code at Address...
✅ Verification Successful: Contract Code Detected.
```

Stage 2
```bash
cd ../stage_3
./stage_3.sh 
Output:
🔹 SHA256 Wrapper Function Test with Cast (Stage 1 Style, Local Calculation)
🔹 Testing Input: Hello, World!
🔹 Hexadecimal Representation: 48656c6c6f2c20576f726c6421
🔹 Expected Hash (Local): dffd6021bb2bd5b0af676290809ec3a53191dd81c7f70a4b28688a362182986f
✅ Test Passed: Contract Hash Matches Local Calculation.
----------------------------------------
🔹 Testing Input: Gateway.fm
🔹 Hexadecimal Representation: 476174657761792e666d
🔹 Expected Hash (Local): 2b371301d100e168ccc4e6dad8f3428bf32bbc5ad9ddd9d7419da76eaf73d17a
✅ Test Passed: Contract Hash Matches Local Calculation.
----------------------------------------
🔹 Testing Input: OpenAI
🔹 Hexadecimal Representation: 4f70656e4149
🔹 Expected Hash (Local): 8b7d1a3187ab355dc31bc683aaa71ab5ed217940c12196a9cd5f4ca984babfa4
✅ Test Passed: Contract Hash Matches Local Calculation.
----------------------------------------
🔹 Testing Input: Stage 1 Test
🔹 Hexadecimal Representation: 537461676520312054657374
🔹 Expected Hash (Local): e1c96a03f978d8eb0d992a1144d22a36e7f744d206f3804dd7a9484b46e7f3b1
✅ Test Passed: Contract Hash Matches Local Calculation.
----------------------------------------
🔹 Testing Input: -1
🔹 Hexadecimal Representation: 2d31
🔹 Expected Hash (Local): 1bad6b8cf97131fceab8543e81f7757195fbb1d36b376ee994ad1cf17699c464
✅ Test Passed: Contract Hash Matches Local Calculation.
----------------------------------------
🔹 Testing Input: 🔹✅
🔹 Hexadecimal Representation: f09f94b9e29c85
🔹 Expected Hash (Local): bfe03c2b3612715db6a036c788fbc39e0a1d4968f2c1c087378b17eea9aab500
✅ Test Passed: Contract Hash Matches Local Calculation.
----------------------------------------
```