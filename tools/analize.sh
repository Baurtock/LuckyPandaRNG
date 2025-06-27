#!/bin/sh

FILE="samples.csv"

if [ ! -f "$FILE" ]; then
    echo "❌ File $FILE not found."
    exit 1
fi

echo "📊 Analyzing $FILE ..."

TOTAL=$(wc -l < "$FILE")
echo "Total samples: $TOTAL"

echo "Generating frequencies..."
awk '{count[$1]++} END {
    for (i in count) print count[i], i
}' "$FILE" | sort -nr > freqs.txt

echo "Most frequent values:"
head freqs.txt

echo "🔐 Calculating Shannon entropy..."
ENTROPY=$(awk -v total=$TOTAL '{
    p = $1 / total
    if (p > 0) e += -p * log(p)/log(2)
} END { print e }' freqs.txt)

UNIQUE=$(wc -l < freqs.txt)
ENTROPY_MAX=$(echo "scale=6; l($UNIQUE)/l(2)" | bc -l)
PCT=$(echo "scale=2; 100 * $ENTROPY / $ENTROPY_MAX" | bc)

echo "Estimated entropy: $ENTROPY bits"
echo "Maximum entropy: $ENTROPY_MAX bits"
echo "Relative entropy: $PCT%"

echo "📐 Performing chi-squared test..."
CHI_SQ=$(awk -v total=$TOTAL -v k=$UNIQUE '
BEGIN { expected = total / k }
{
    observed = $1
    diff = observed - expected
    chi += (diff * diff) / expected
}
END { print chi }
' freqs.txt)

echo "Chi-squared statistic: $CHI_SQ"

CRITICAL=124.34
if echo "$CHI_SQ > $CRITICAL" | bc | grep -q 1; then
    echo "⚠️ Distribution does NOT pass uniformity test at 95% (χ² > $CRITICAL)"
else
    echo "✅ Distribution passes uniformity test at 95% (χ² ≤ $CRITICAL)"
fi

echo "📦 Preparing data for plot..."

awk '{count[$1]++} END {
    for (i = 1; i <= 100; i++) {
        if (i in count) {
            print i, count[i];
        } else {
            print i, 0;
        }
    }
}' "$FILE" > complete_freqs.txt

if command -v gnuplot > /dev/null; then
    echo "📈 Generating PNG plot..."
    gnuplot <<EOF
set terminal png size 1000,600
set output 'histogram.png'
set title "Complete Frequency Histogram"
set xlabel "Value"
set ylabel "Frequency"
set boxwidth 0.9
set style fill solid
set yrange [0:*]
plot 'complete_freqs.txt' using 1:2 with boxes notitle
EOF
    echo "✅ Plot saved as histogram.png"
else
    echo "⚠️ gnuplot not installed. Skipping visualization."
fi

rm freqs.txt complete_freqs.txt
