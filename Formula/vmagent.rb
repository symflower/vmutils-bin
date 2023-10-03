class Vmagent < Formula
	desc "VMAgent is a tiny agent which helps you collect metrics from various sources, relabel and filter the collected metrics and store them in VictoriaMetrics or any other storage systems via Prometheus remote_write protocol."
	homepage "https://docs.victoriametrics.com/vmagent.html"
	license all_of: ["MIT", "Apache-2.0"]
	version "1.94.0"

	on_macos do
	  url "https://github.com/VictoriaMetrics/VictoriaMetrics/releases/download/v#{version}/vmutils-darwin-amd64-v#{version}.tar.gz"
	  sha256 "c1f659d11a26ba9f8e9c30d9c8ede731270af17fbcd2f15372d15be96c7ddd68"

	  on_arm do
		url "https://github.com/VictoriaMetrics/VictoriaMetrics/releases/download/v#{version}/vmutils-darwin-arm64-v#{version}.tar.gz"
		sha256 "bad19df593d70062eb5cfb28e691166faf18885f61441c81a522dd57d17b3741"
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
