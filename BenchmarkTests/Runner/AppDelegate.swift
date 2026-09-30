/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddBenchmarks` -> `TowerSignalBenchmarks`,
// `ddCore` -> `TowerSignalCore`, `ddInternal` -> `TowerSignalInternal`; renamed the `DD` symbol prefix to
// `AT`; renamed `clientToken` to `licenseKey`; rebranded the `dd` name to `TowerSignal` in comments and
// docs; rebranded the licence header.

import UIKit

import TowerSignalInternal
import TowerSignalCore
import TowerSignalBenchmarks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var applicationInfo: AppInfo! //swiftlint:disable:this implicitly_unwrapped_optional
    var vitals: Vitals?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        applicationInfo = try! AppInfo() // crash if info are missing or malformed

        window = UIWindow(frame: UIScreen.main.bounds)

        if let scenario = SyntheticScenario() {
            let run = SyntheticRun()
            start(scenario: scenario, run: run)
        } else {
            window?.rootViewController = UIViewController()
        }

        window?.makeKeyAndVisible()
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return false
        }

        // bench://stop
        if components.host == "stop" {
            stop()
            return true
        }

        // bench://start?scenario=<scenario>&run=<run>
        if components.host == "start", let scenario = SyntheticScenario(urlComponents: components), let run = SyntheticRun(urlComponents: components) {
            start(scenario: scenario, run: run)
            return true
        }

        return false
    }

    /// Starts instruments for the given run and scenario.
    ///
    /// - Parameters:
    ///   - scenario: The benchmark scenario.
    ///   - run: The benchmark run.
    private func start(
        scenario: SyntheticScenario,
        run: SyntheticRun
    ) {
        switch run {
        case .baseline, .instrumented:
            collectApplicationVitals(scenario: scenario, run: run)
        case .profiling:
            profileSDK(scenario: scenario, run: run)
        case .none:
            break
        }

        if run != .baseline {
            // instrument the application with TowerSignal SDK
            // when not in baseline run
            scenario.instrument(with: applicationInfo)
        }

        window?.rootViewController = scenario.initialViewController
    }

    /// Stops all current instruments.
    ///
    /// The same process can run multiple scenarios and instruments when receiving a deeplink.
    /// It is important to stop current instruments before starting a new run.
    private func stop() {
        vitals = nil // stop collecting vitals
        TowerSignal.stopInstance() // stop runner instrumentation
#if AT_BENCHMARK
        TowerSignalInternal.bench = (NOPBench(), NOPBench()) // stop profiling the sdk
#endif
        window?.rootViewController = UIViewController()
    }

    /// Starts collection vitals of the runner application.
    ///
    /// - Parameters:
    ///   - scenario: The benchmark scenario.
    ///   - run: The benchmark run.
    private func collectApplicationVitals(
        scenario: SyntheticScenario,
        run: SyntheticRun
    ) {
        let vitals = Vitals(
            provider: Benchmarks.meterProvider(
                with: Benchmarks.Configuration(
                    info: applicationInfo,
                    scenario: scenario,
                    run: run
                )
            )
        )

        vitals.observeCPU()
        vitals.observeMemory()
        vitals.observeFPS()

        self.vitals = vitals // Keep vitals in memory
    }

    /// Starts profiling the SDK while running the application.
    ///
    /// - Parameters:
    ///   - scenario: The benchmark scenario.
    ///   - run: The benchmark run.
    private func profileSDK(
        scenario: SyntheticScenario,
        run: SyntheticRun
    ) {
        // Collect traces during profiling run
        let profiler = Profiler(
            provider: Benchmarks.tracerProvider(
                with: Benchmarks.Configuration(
                    info: applicationInfo,
                    scenario: scenario,
                    run: run
                )
            )
        )

        let meter = Meter(
            provider: Benchmarks.meterProvider(
                with: Benchmarks.Configuration(
                    info: applicationInfo,
                    scenario: scenario,
                    run: run
                )
            )
        )
#if AT_BENCHMARK
        TowerSignalInternal.bench = (profiler, meter) // Inject profiler and meter to collect telemetry
#endif
    }
}

extension Benchmarks.Configuration {
    init(
        info: AppInfo,
        scenario: SyntheticScenario,
        run: SyntheticRun,
        bundle: Bundle = .main,
        sysctl: SysctlProviding = Sysctl(),
        device: UIDevice = .current
    ) {
        self.init(
            licenseKey: info.licenseKey,
            apiKey: info.apiKey,
            context: Benchmarks.Configuration.Context(
                applicationIdentifier: bundle.bundleIdentifier!,
                applicationName: bundle.object(forInfoDictionaryKey: "CFBundleExecutable") as! String,
                applicationVersion: bundle.object(forInfoDictionaryKey: "CFBundleVersion") as! String,
                env: info.env,
                sdkVersion: "",
                deviceModel: try! sysctl.model(),
                osName: device.systemName,
                osVersion: device.systemVersion,
                run: run.rawValue,
                scenario: scenario.name.rawValue,
                branch: ""
            )
        )
    }
}
