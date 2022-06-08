package yclib

import (
	"context"
	"os/exec"

	utils "../utils"
	"github.com/yandex-cloud/go-genproto/yandex/cloud/compute/v1"
	ycsdk "github.com/yandex-cloud/go-sdk"
)

type YC struct {
	Token     string
	FolderId  string
	SDK       *ycsdk.SDK
	Instances []*compute.Instance
}

func (yc *YC) getToken() {
	yc.Token = utils.GetCommandResult(exec.Command("yc", "config", "get", "token"))
}

func (yc *YC) getFolderId() {
	yc.FolderId = utils.GetCommandResult(exec.Command("yc", "config", "get", "folder-id"))
}

//Получение ссылки на YC sdk
func (yc *YC) getSdk(ctx context.Context) {

	yc.getToken()
	sdk, err := ycsdk.Build(ctx, ycsdk.Config{
		Credentials: ycsdk.OAuthToken(yc.Token),
	})
	utils.ShowError(err)

	yc.SDK = sdk
}

//Получение списка yc instances
func (yc *YC) GetInstances() {

	ctx := context.Background()
	yc.getSdk(ctx)

	// Получение списка Compute Instance по заданному запросом FolderId
	yc.getFolderId()
	listInstancesResponse, err := yc.SDK.Compute().Instance().List(ctx, &compute.ListInstancesRequest{
		FolderId: yc.FolderId,
	})
	utils.ShowError(err)

	yc.Instances = listInstancesResponse.GetInstances()
}
