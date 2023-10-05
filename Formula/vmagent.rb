class Vmagent < Formula
	desc "VMAgent is a tiny agent which helps you collect metrics from various sources, relabel and filter the collected metrics and store them in VictoriaMetrics or any other storage systems via Prometheus remote_write protocol."
	homepage "https://docs.victoriametrics.com/vmagent.html"
	license all_of: ["MIT", "Apache-2.0"]
	version "1.94.0"

	on_macos do
	  url "https://github.com/VictoriaMetrics/VictoriaMetrics/releases/download/v#{version}/vmutils-darwin-amd64-v#{version}.tar.gz"
	  sha256 "052958ac0d7f163af42ba9499941bd3acd6bdc90214bdd07e7b9d0b8ff53a25c"

	  on_arm do
		url "https://github.com/VictoriaMetrics/VictoriaMetrics/releases/download/v#{version}/vmutils-darwin-arm64-v#{version}.tar.gz"
		sha256 "84356ee903d1faeddf5ed84007c68ed2d538c57196afdb8ff01bd02463fdc48f"
	  end
	end

	def caveats
	  <<~EOS
		When run from `brew services`, `vmagent` is run from
		`vmagent_brew_services` and uses the flags in:
		  #{etc}/vmagent/service.args

		A default `scrape-config` can be found at #{etc}/vmagent/scrape.yml
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
