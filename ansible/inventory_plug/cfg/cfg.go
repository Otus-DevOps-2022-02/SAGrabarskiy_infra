package cfg

import (
	"encoding/json"
	"fmt"

	"github.com/yandex-cloud/go-genproto/yandex/cloud/compute/v1"
)

const APP_INSTANCE = "reddit-app-stage"
const DB_INSTANCE = "reddit-db-stage"
const APP_ROOT_NAME = "app"
const DB_ROOT_NAME = "db"

type DBHost struct {
	HostIP []string `json:"hosts"`
}

type AppHost struct {
	HostIP []string `json:"hosts"`
}

type Children struct {
	Children []string `json:"children"`
}

type Inventory struct {
	All Children `json:"all"`
	DB  DBHost   `json:"db"`
	App AppHost  `json:"app"`
}

//JSON converter
func GetJSONBytes(v interface{}) []byte {
	jsonBytes, _ := json.MarshalIndent(v, "", "  ")
	fmt.Println(string(jsonBytes))
	return jsonBytes
}

//YC Instances parser
func Parse(instances []*compute.Instance) string {

	var dbHosts []string
	var appHosts []string

	for _, instance := range instances {
		for _, networkInstance := range instance.NetworkInterfaces {
			hostIP := networkInstance.PrimaryV4Address.OneToOneNat.Address
			if instance.Name == APP_INSTANCE {
				appHosts = append(appHosts, hostIP)
			} else if instance.Name == DB_INSTANCE {
				dbHosts = append(dbHosts, hostIP)
			}
		}
	}

	inventory := Inventory{All: Children{[]string{APP_ROOT_NAME, DB_ROOT_NAME}}, DB: DBHost{dbHosts}, App: AppHost{appHosts}}
	return string(GetJSONBytes(inventory))
}
