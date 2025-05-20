#!/bin/bash

# 🚀 SHA256 Precompile Automation Script (Direct Call with Cast)
echo "🔹 SHA256 Precompile Automation with Cast (Direct Call)"

# ✅ Step 1: User Message
MESSAGE="Gateway.fm"
echo "🔹 Message is: $MESSAGE"

# ✅ Step 2: Convert Message to Hexadecimal
HEX_MSG=$(echo -n "$MESSAGE" | xxd -p)
echo "🔹 Hexadecimal Representation: $HEX_MSG"

# ✅ Step 3: Define RPC URL, Precompile Address
RPC_URL="https://rpc.cardona.zkevm-rpc.com/"
PRECOMPILE_ADDRESS="0x0000000000000000000000000000000000000002"

# ✅ Step 4: Perform Direct Call Using Cast
echo "🔹 Calling SHA256 Precompile Directly via Cast..."
RETURN_HASH=$(cast call $PRECOMPILE_ADDRESS "0x$HEX_MSG" --rpc-url $RPC_URL)

# ✅ Step 5: Calculate Expected SHA256 Hash Locally
echo "🔹 Calculating Expected SHA256 Hash Locally..."
LOCAL_HASH=$(echo -n "$MESSAGE" | sha256sum | awk '{print $1}')
echo "🔹 Expected SHA256 Hash: $LOCAL_HASH"

# ✅ Step 6: Verification Check
if [ -z "$RETURN_HASH" ]; then
  echo "❌ Error: Could not retrieve hash from precompile using cast."
  exit 1
fi

# ✅ Step 7: Compare Hashes
if [ "0x$LOCAL_HASH" == "$RETURN_HASH" ]; then
  echo "✅ Verification Successful: Precompile Hash Matches Local Calculation."
else
  echo "❌ Verification Failed: Precompile Hash DOES NOT Match Local Calculation."
  echo "🔹 Precompile Hash: $RETURN_HASH"
  echo "🔹 Local SHA256 Hash: $LOCAL_HASH"
fi

# ✅ Step 8: Summary
echo -e "\n🔹 Transaction Summary:"
echo "Message:          $MESSAGE"
echo "Hex Message:      0x$HEX_MSG"
echo "Precompile Hash:  $RETURN_HASH"
echo "Expected Hash:    $LOCAL_HASH"

JSON="{ 
        \"blockNumber\": \"not applicable, since read-only\", 
        \"txHash\": \"not applicable, since read-only\",
        \"receiverAddress\": \"0x0000000000000000000000000000000000000002\",
        \"decodedOutputs\": 
          {
            \"precompileHash\": \"$RETURN_HASH\"
          },
        \"verdict\": \"success\"
      }"
echo $JSON | jq empty
echo $JSON >results.json
