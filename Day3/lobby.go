package main

import (
	"log"
	"os"
	"strings"
)

func main() {
	data, err := os.ReadFile("input")
	if err != nil {
		log.Fatal(err)
	}
	input := string(data)
	batteries := strings.SplitSeq(input, "\n")

	totalPower := 0

	for battery := range batteries {
		if len(battery) == 0 {
			break
		}

		i, j := 0, len(battery)-1
		upperI := 0

		upper := int(battery[i] - '0')
		lower := int(battery[j] - '0')

		for i < j {
			if int(battery[i]-'0') > int(battery[upperI]-'0') {
				upperI = i
				upper = int(battery[i] - '0')
				if upper == 9 {
					break
				}
			}
			i++
		}

		for upperI < j {
			if int(battery[j]-'0') > lower {
				lower = int(battery[j] - '0')
				if lower == 9 {
					break
				}
			}
			j--
		}

		power := upper*10 + lower
		totalPower += power
	}

	println("Total Power: ", totalPower)
}
