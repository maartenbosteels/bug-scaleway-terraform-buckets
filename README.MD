# Intro

This repo is used to reproduce https://github.com/scaleway/terraform-provider-scaleway/issues/3300

# How to reproduce

```shell

export PROJECT_ID=<your project id>

git clone git@github.com:maartenbosteels/bug-scaleway-terraform-buckets.git
cd bug-scaleway-terraform-buckets
tofu init
tofu plan -out plan -var bucket_suffix=foo -var project_id=$PROJECT_ID
tofu apply plan
tofu plan -out plan -var bucket_suffix=foo -var project_id=$PROJECT_ID
```

The second 'tofu plan -out plan' fails.
Probably because it fails to read (or parse?) the bucket policy.

This is the ouput I get:
```
╰─± tofu plan -out plan -var bucket_suffix=foo -var project_id=$PROJECT_ID
data.scaleway_iam_application.main: Reading...
scaleway_object_bucket.main: Refreshing state... [id=fr-par/terraform-provider-scaleway-issues-3300-foo]
data.scaleway_iam_application.main: Read complete after 0s [id=a927fbf5-f234-4bfd-b744-b932bf17250f]

Planning failed. OpenTofu encountered an error while generating this plan.

╷
│ Error: Request cancelled
│
│ The plugin6.(*GRPCProvider).ReadResource request was cancelled.
╵

Stack trace from the terraform-provider-scaleway_v2.62.0 plugin:

panic: runtime error: invalid memory address or nil pointer dereference
[signal SIGSEGV: segmentation violation code=0x2 addr=0x10 pc=0x10340b66c]

goroutine 67 [running]:
github.com/scaleway/terraform-provider-scaleway/v2/internal/services/object.flattenObjectBucketVersioning(...)
	github.com/scaleway/terraform-provider-scaleway/v2/internal/services/object/helpers_object.go:262
github.com/scaleway/terraform-provider-scaleway/v2/internal/services/object.resourceObjectBucketRead({0x103c00f10, 0x1400022e7e0}, 0x14000758ab0, {0x103b07ae0, 0x14000574738})
	github.com/scaleway/terraform-provider-scaleway/v2/internal/services/object/bucket.go:580 +0x97c
github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema.(*Resource).read(0x1400044f900, {0x103c00e68, 0x140007608a0}, 0x14000758ab0, {0x103b07ae0, 0x14000574738})
	github.com/hashicorp/terraform-plugin-sdk/v2@v2.38.1/helper/schema/resource.go:866 +0xe0
github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema.(*Resource).RefreshWithoutUpgrade(0x1400044f900, {0x103c00e68, 0x140007608a0}, 0x14000738dd0, {0x103b07ae0, 0x14000574738})
	github.com/hashicorp/terraform-plugin-sdk/v2@v2.38.1/helper/schema/resource.go:1162 +0x3d4
github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema.(*GRPCProviderServer).ReadResource(0x1400000e2e8, {0x103c00e68?, 0x14000760780?}, 0x1400081ac30)
	github.com/hashicorp/terraform-plugin-sdk/v2@v2.38.1/helper/schema/grpc_provider.go:915 +0x92c
github.com/hashicorp/terraform-plugin-mux/tf5to6server.v5tov6Server.ReadResource({{0x103c101e0?, 0x1400000e2e8?}}, {0x103c00e68, 0x14000760780}, 0x0?)
	github.com/hashicorp/terraform-plugin-mux@v0.21.0/tf5to6server/tf5to6server.go:188 +0x58
github.com/hashicorp/terraform-plugin-mux/tf6muxserver.(*muxServer).ReadResource(0x140005aad80, {0x103c00e68?, 0x140007604b0?}, 0x1400081abe0)
	github.com/hashicorp/terraform-plugin-mux@v0.21.0/tf6muxserver/mux_server_ReadResource.go:35 +0x178
github.com/hashicorp/terraform-plugin-go/tfprotov6/tf6server.(*server).ReadResource(0x1400042c500, {0x103c00e68?, 0x14000629920?}, 0x1400022e0e0)
	github.com/hashicorp/terraform-plugin-go@v0.29.0/tfprotov6/tf6server/server.go:863 +0x1f8
github.com/hashicorp/terraform-plugin-go/tfprotov6/internal/tfplugin6._Provider_ReadResource_Handler({0x103bb4a20, 0x1400042c500}, {0x103c00e68, 0x14000629920}, 0x14000734480, 0x0)
	github.com/hashicorp/terraform-plugin-go@v0.29.0/tfprotov6/internal/tfplugin6/tfplugin6_grpc.pb.go:753 +0x1b8
google.golang.org/grpc.(*Server).processUnaryRPC(0x140002b0000, {0x103c00e68, 0x14000629890}, 0x1400072a240, 0x14000354f00, 0x10477bd78, 0x0)
	google.golang.org/grpc@v1.75.1/server.go:1431 +0xbd0
google.golang.org/grpc.(*Server).handleStream(0x140002b0000, {0x103c01618, 0x140002e3a00}, 0x1400072a240)
	google.golang.org/grpc@v1.75.1/server.go:1842 +0x858
google.golang.org/grpc.(*Server).serveStreams.func2.1()
	google.golang.org/grpc@v1.75.1/server.go:1061 +0x74
created by google.golang.org/grpc.(*Server).serveStreams.func2 in goroutine 27
	google.golang.org/grpc@v1.75.1/server.go:1072 +0x120

Error: The terraform-provider-scaleway_v2.62.0 plugin crashed!

This is always indicative of a bug within the plugin. It would be immensely
helpful if you could report the crash with the plugin's maintainers so that it
can be fixed. The output above should help diagnose the issue. 
```


