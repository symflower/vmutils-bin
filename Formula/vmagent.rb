class Vmagent < Formula
	desc "VMAgent is a tiny agent which helps you collect metrics from various sources, relabel and filter the collected metrics and store them in VictoriaMetrics or any other storage systems via Prometheus remote_write protocol."
	homepage "https://docs.victoriametrics.com/vmagent.html"
	license all_of: ["MIT", "Apache-2.0"]
	version "1.93.3"

	on_macos do
	  url "https://github.com/VictoriaMetrics/VictoriaMetrics/releases/download/v#{version}/vmutils-darwin-amd64-v#{version}.tar.gz"
	  sha256 "fcf180f948ef54cecc65fcc5a2bc7371fb2b27d2ddc848ab377a55fbb66554b7"

	  on_arm do
		url "https://github.com/VictoriaMetrics/VictoriaMetrics/releases/download/v#{version}/vmutils-darwin-arm64-v#{version}.tar.gz"
		sha256 "1961ac5476240b434eccccf09f17700495e619b2a0db37735be2c06514a7c79d"
	  end
	end

	def caveats
	  <<~EOS
		When run from `brew services`, `vmagent` is run from
		`vmagent_brew_services` and uses the flags in:
		  #{etc}/vmagent/service.args

		A default `scrape-config` can be found at #{etc}"/vmagent/scrape.yml"
	  EOS
	end

	def install
	  bin.install "vmagent-prod" => "vmagent"

	  (bin/"vmagent_brew_services").write <<~EOS
		#!/bin/bash
		exec #{bin}/vmagent $(<#{etc}/vmagent/service.args)
	  EOS

	  (etc/"vmagent/scrape.yml").write <<~EOS
		global:
		  scrape_interval: 10s
		scrape_configs:
		  - job_name: "vmagent"
			static_configs:
			- targets: ["127.0.0.1:8429"]
	  EOS
	end

	service do
	  run [opt_bin/"vmagent_brew_services"]
	  keep_alive false
	  log_path var/"log/vmagent.log"
	  error_log_path var/"log/vmagent.err.log"
	end

	test do
	  system "#{bin}/vmagent", "--help"
	end
  end
