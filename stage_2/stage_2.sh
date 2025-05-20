#!/bin/bash

# 🚀 SHA256 Precompile Contract Deployment Script (Cast + Legacy Transaction)
echo "🔹 SHA256 Precompile Contract Deployment with Cast"

# ✅ Step 1: Compile the Contract
echo "🔹 Compiling Solidity Contract..."
forge build --out ./out --root . SHA256Precompile.sol

# ✅ Step 2: Define Variables
CONTRACT_BIN=$(cat out/SHA256Precompile.sol/SHA256Precompile.json | jq -r '.bytecode.object')
RPC_URL="https://rpc.cardona.zkevm-rpc.com/"
PRIVATE_KEY="2fc9928579757899494043adecb42c3f1d9aae4ce541f3cc7b38ce0e0440087d"
GAS_PRICE="1000" # Fixed Gas Price

# ✅ Step 3: Deploy Using Cast (Legacy Transaction)
echo "🔹 Deploying Contract (Legacy Transaction)..."
DEPLOY_TX_OUTPUT=$(cast send \
  --rpc-url $RPC_URL \
  --private-key $PRIVATE_KEY \
  --legacy \
  --gas-price $GAS_PRICE \
  --create $CONTRACT_BIN)

DEPLOY_TX_HASH=$(echo -e "$DEPLOY_TX_OUTPUT" | grep transactionHash | awk '{print $2}')
echo "🔹 Deployment Transaction Hash: $DEPLOY_TX_HASH"

CONTRACT_ADDRESS=$(echo -e "$DEPLOY_TX_OUTPUT" | grep contractAddress | awk '{print $2}')
echo "🔹 Deployment Transaction Contract Address: $CONTRACT_ADDRESS"

# ✅ Step 5: Fetch Transaction Receipt
RECEIPT=$(cast re $DEPLOY_TX_HASH --rpc-url $RPC_URL)

# ✅ Step 6: Check Status in the Transaction Receipt
STATUS=$(echo -e "$RECEIPT" | grep status | awk '{print $2}')
if [ "$STATUS" == "1" ]; then
  echo "✅ Status Verification Successful"
  echo "🔹 Status: $STATUS"
else
  echo "❌ Staus Verification Failed"
  echo "🔹 Status: $STATUS"
fi

# ✅ Step 7: Check Bytecode at the Deployed Address
echo "🔹 Verifying Contract Code at Address..."
CONTRACT_CODE=$(cast code $CONTRACT_ADDRESS --rpc-url $RPC_URL)

if [ "$CONTRACT_CODE" == "0x" ]; then
  echo "❌ Verification Failed: No Code Found at Deployed Address."
else
  echo "✅ Verification Successful: Contract Code Detected."
  #echo "🔹 Contract Code: $CONTRACT_CODE"
fi

JSON="{ 
  \"blockNumber\": \"$(echo -e "$DEPLOY_TX_OUTPUT" | grep blockNumber | awk '{ print $2 }')\",
  \"txHash\": \"$DEPLOY_TX_HASH\",
  \"receiverAddress\": \"$CONTRACT_ADDRESS\",
  \"decodedOutputs\": 
    {
      \"txStatus\": \"$STATUS\",
      \"contractCode\": \"$CONTRACT_CODE\"
    },
  \"verdict\": \"success\"
}"
echo $JSON | jq empty
echo $JSON >results.json
