package utils

import (
	"log"
	"os/exec"
	"strings"
)

func ShowError(err error) {
	if err != nil {
		log.Fatal(err)
	}
}

func GetCommandResult(cmd *exec.Cmd) string {
	outBytes, err := cmd.Output()
	ShowError(err)
	return strings.TrimSuffix(string(outBytes), "\n")
}
