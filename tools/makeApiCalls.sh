#!/bin/bash

# Configuration
TOTAL_SAMPLES=1
MIN_VALUE=0
MAX_VALUE=100
THREAD_COUNT=1
SAMPLES_PER_THREAD=$((TOTAL_SAMPLES / THREAD_COUNT))
OUTPUT_FILE="samples.csv"
API_URL="http://localhost:80/random?min=$MIN_VALUE&max=$MAX_VALUE"

echo "📋 Configuration:"
printf "%-20s | %-10s\n" "Parameter" "Value"
printf "%-20s | %-10s\n" "--------------------" "----------"
printf "%-20s | %-10s\n" "Total Samples" "$TOTAL_SAMPLES"
printf "%-20s | %-10s\n" "Min Value" "$MIN_VALUE"
printf "%-20s | %-10s\n" "Max Value" "$MAX_VALUE"
printf "%-20s | %-10s\n" "Thread Count" "$THREAD_COUNT"
printf "%-20s | %-10s\n" "Samples/Thread" "$SAMPLES_PER_THREAD"
printf "%-20s | %-10s\n" "Output File" "$OUTPUT_FILE"
printf "%-20s | %-10s\n" "API URL" "$API_URL"
echo ""

START_TIME=$(date +%s)
> "$OUTPUT_FILE"

generate_samples() {
    THREAD_ID=$1
    TEMP_FILE="tmp_$THREAD_ID.csv"
    > "$TEMP_FILE"

    count=0
    while [ $count -lt $SAMPLES_PER_THREAD ]; do
        RESPONSE=$(curl -s "$API_URL")
        if echo "$RESPONSE" | grep -Eq '^[0-9]+$'; then
            echo "$RESPONSE" >> "$TEMP_FILE"
            count=$((count + 1))
        fi
    done
}

for i in $(seq 1 $THREAD_COUNT); do
    generate_samples "$i" &
done

wait

cat tmp_*.csv > "$OUTPUT_FILE"
rm tmp_*.csv

END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))

echo "✅ Samples generated in $OUTPUT_FILE"
echo "⏱️ Total time: ${ELAPSED} seconds"
