package main

import (
    "crypto/rand"
    "fmt"
    "log"
    "math/big"
    "net/http"
    "strconv"
)

func main() {
    http.HandleFunc("/random", handleRandom)
    log.Println("Listening on: http://localhost:8080")
    log.Fatal(http.ListenAndServe(":8080", nil))
}

func handleRandom(w http.ResponseWriter, r *http.Request) {
    minStr := r.URL.Query().Get("min")
    maxStr := r.URL.Query().Get("max")

    min, err1 := strconv.ParseInt(minStr, 10, 64)
    max, err2 := strconv.ParseInt(maxStr, 10, 64)

    if err1 != nil || err2 != nil || min >= max {
        http.Error(w, "Invalid params. Usage ?min=10&max=100", http.StatusBadRequest)
        return
    }

    n, err := secureRandInt(min, max)
    if err != nil {
        http.Error(w, "Number generation failed", http.StatusInternalServerError)
        return
    }

    fmt.Fprintf(w, "%d\n", n)
}

func secureRandInt(min, max int64) (int64, error) {
    diff := max - min
    nBig, err := rand.Int(rand.Reader, big.NewInt(diff))
    if err != nil {
        return 0, err
    }
    return nBig.Int64() + min, nil
}
