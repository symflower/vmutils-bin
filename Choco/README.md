# Chocolatey

## VMAgent

Community URL: https://community.chocolatey.org/packages/vmagent

> :info: The release moderation of the chocolatey community repository is rather slow, please check if your desired version is accessible there first or use the manual install step documentation below.

### Installation

You can specify all parameters of `vmagent` during the install process via chocolatey.
```bash
choco install vmagent --params "'/httpListenAddr::8429 /memory.allowedPercent:40 /promscrape.config:C:/Users/Administrator/Documents/vmagent-scrape-config.yml'"
```

#### Manual installation

-	Download the `vmagent.nupkg` file from the [Release Page](https://github.com/symflower/vmutils-bin/releases)
-	Run the command below to install it, replace $VERSION with the version e.g. `1.94.0` and $SOURCE with the path to the `vmagent.nupkg` file downloaded before.
	```bash
	choco install vmagent --version $VERSION --source $SOURCE --params "'/httpListenAddr::8429 /memory.allowedPercent:40 /promscrape.config:C:/Users/Administrator/Documents/vmagent-scrape-config.yml'"
	```
| See more usable flags for vmagent at https://docs.victoriametrics.com/vmagent.html#advanced-usage

### Usage

The `vmagent` service should be automatically started after the installation is finished.

### Customize

If you want to change some of the parameters which are passed to `vmagent` you can modify the following file `$chocolateyLibFolder/vmagent/tools/vmagent.xml`.
