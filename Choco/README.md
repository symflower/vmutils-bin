# Chocolatey

## VMAgent

### Installation

You can specify all parameters of `vmagent` during the install process via chocolatey.
```bash
	choco install vmagent --params "'/httpListenAddr::8429 /memory.allowedPercent:40 /promscrape.config:C:/Users/Administrator/Documents/vmagent-scrape-config.yml'"
```

### Usage

The `vmagent` service should be automatically started after the installation is finished.

### Customize

If you want to change some of the parameters which are passed to `vmagent` you can modify the following file `$chocolateyLibFolder/vmagent/tools/vmagent.xml`.
