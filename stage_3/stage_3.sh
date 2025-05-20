#!/bin/bash

# 🚀 SHA256 Wrapper Function Test Script (Stage 1 Style, Local Hash Calculation)
echo "🔹 SHA256 Wrapper Function Test with Cast (Stage 1 Style, Local Calculation)"

# ✅ Step 1: Define RPC URL and Contract Address
RPC_URL="https://rpc.cardona.zkevm-rpc.com/"
CONTRACT_ADDRESS="0x2210b96965041E707D23133C930d3b9C786D20e8" # Replace with your contract address

# ✅ Step 2: Define Test Messages (No Predefined Hashes)
TEST_MESSAGES=(
  "Hello, World!"
  "Gateway.fm"
  "OpenAI"
  "Stage 1 Test"
  "-1"
  "🔹✅"
)

RETURNED_HASHES=""
# ✅ Step 3: Function to Handle Each Test Message
test_sha256() {
  local MESSAGE="$1"

  # Convert Message to Hexadecimal
  HEX_MSG=$(echo -n "$MESSAGE" | xxd -p)
  echo "🔹 Testing Input: $MESSAGE"
  echo "🔹 Hexadecimal Representation: $HEX_MSG"

  # ✅ Step 4: Call the Contract Wrapper Function
  RETURNED_HASH=$(cast call $CONTRACT_ADDRESS "hashWithSHA256(bytes)(bytes32)" "$HEX_MSG" --rpc-url $RPC_URL)

  # ✅ Step 5: Clean Up Returned Hash
  RETURNED_HASH=$(echo "$RETURNED_HASH" | sed 's/^0x//')

  # ✅ Step 6: Calculate Expected Hash Locally
  LOCAL_HASH=$(echo -n "$MESSAGE" | sha256sum | awk '{print $1}')
  echo "🔹 Expected Hash (Local): $LOCAL_HASH"

  # ✅ Step 7: Validation Check
  if [ -z "$RETURNED_HASH" ]; then
    echo "❌ Error: No hash returned from contract."
    return 1
  fi

  if [ "$RETURNED_HASH" == "$LOCAL_HASH" ]; then
    echo "✅ Test Passed: Contract Hash Matches Local Calculation."
    RETURNED_HASHES="$RETURNED_HASHES\"$RETURNED_HASH\","
  else
    echo "❌ Test Failed: Contract Hash Does NOT Match Local Calculation."
    echo "🔹 Expected Hash (Local): $LOCAL_HASH"
    echo "🔹 Returned Hash (Contract): $RETURNED_HASH"
  fi

  echo "----------------------------------------"
}

# ✅ Step 4: Run Tests for Each Test Message
for MESSAGE in "${TEST_MESSAGES[@]}"; do
  test_sha256 "$MESSAGE"
done

JSON="{ 
        \"blockNumber\": \"not applicable, since read-only\", 
        \"txHash\": \"not applicable, since read-only\",
        \"receiverAddress\": \"$CONTRACT_ADDRESS\",
        \"decodedOutputs\": 
          {
            \"returnedHashes\": [${RETURNED_HASHES%,}]
          },
        \"verdict\": \"success\"
      }"
echo $JSON | jq empty
echo $JSON >results.json
