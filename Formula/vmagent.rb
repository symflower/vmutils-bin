class Vmagent < Formula
	desc "VMAgent is a tiny agent which helps you collect metrics from various sources, relabel and filter the collected metrics and store them in VictoriaMetrics or any other storage systems via Prometheus remote_write protocol."
	homepage "https://docs.victoriametrics.com/vmagent.html"
	license all_of: ["MIT", "Apache-2.0"]
	version "1.117.1"

	on_macos do
		on_intel do
			checksumAmd64 = "b8e35d231f6bcd84c783353eaf6e3ca8ddd4b678cb4a70ecc92f199a81e440c5" # The wording of this variable is intentional for easier automation.

			url "https://github.com/VictoriaMetrics/VictoriaMetrics/releases/download/v#{version}/vmutils-darwin-amd64-v#{version}.tar.gz"
			sha256 "#{checksumAmd64}"
		end

		on_arm do
			checksumArm64 = "e7b7621d7798941778a00d30f056882082cad2a221b129a493449194d5ce9594" # The wording of this variable is intentional for easier automation.

			url "https://github.com/VictoriaMetrics/VictoriaMetrics/releases/download/v#{version}/vmutils-darwin-arm64-v#{version}.tar.gz"
			sha256 "#{checksumArm64}"
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

		unless File.exist?(etc/"vmagent/scrape.yml")
			(etc/"vmagent/scrape.yml").write <<~EOS
				global:
				scrape_interval: 10s
				scrape_configs:
				- job_name: "vmagent"
				  static_configs:
				  - targets: ["127.0.0.1:8429"]
			EOS
		end
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
