package main

import (
	"fmt"
	"net/http"
	"os"
	"strconv"
)

var GRPC_PORT = os.Getenv("GRPC_PORT")
var UI_GRPC_ENDPOINT = os.Getenv("UI_GRPC_ENDPOINT")

func main() {
	var err error
	uiPort := 8080
	if uiPortStr, ok := os.LookupEnv("UI_PORT"); ok {
		if uiPort, err = strconv.Atoi(uiPortStr); err != nil {
			panic(err)
		}
	}

	staticFiles := http.FileServer(http.Dir(os.Args[1]))
	err = http.ListenAndServe(fmt.Sprintf(":%d", uiPort), staticFiles)
	panic(err)
}
