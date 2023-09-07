# Homebrew Formula

## Installation

Add the repository to brew as a Tap.
```bash
brew tap symflower/vmutils-bin https://github.com/symflower/vmutils-bin
```

## VMAgent

Install `vmagent` with:
```bash
brew install vmagent
```

### Configuration

- The services parameters can be changed by modifying the file `#{etc}/vmagent/service.args`.
- The scrape config can be changed by modifying the file ` #{etc}"/vmagent/scrape.yml`.
- Please note that you have to provide the path to the `scrape.yml` yourself within `service.args` with the `promscrape.config` parameter.

### Usage

- To start the service and registering it to run at boot use `brew services start vmagent`.
