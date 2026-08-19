# TrueFace iOS SDK Sample App

A complete, production-ready sample iOS Swift application demonstrating how to integrate the **TrueFace Liveness & Biometric Verification iOS SDK** (`TrueFaceLiveness`).

## Features Demonstrated
- Presenting the native iOS camera liveness view controller with 3D Vision face tracking
- Hosted liveness verification API integration (`start`, `upload-urls`, `complete`)
- Configuring credentials (`verificationId`, `publicKey`, `clientSecret`, `backendBaseUrl`)
- Handling delegate callbacks (`didCompleteWithResult`, `didFailWithError`, `didUpdateEvent`)

## Requirements
- Xcode 15.0 or newer
- iOS 15.0+ physical device with camera

## Quickstart

Add the Swift Package dependency to your `Package.swift` or Xcode Project:

```swift
dependencies: [
    .package(url: "https://github.com/trueface-dev/ios-sdk.git", from: "0.1.4")
]
```

Present `TrueFaceLivenessViewController`:

```swift
import UIKit
import TrueFaceLiveness

class ViewController: UIViewController, TrueFaceLivenessDelegate {

    func startLivenessCheck() {
        let config = TrueFaceConfig(
            backendBaseUrl: "https://api.trueface.dev",
            publicKey: "pk_live_your_public_key",
            verificationId: "ver_12345",
            clientSecret: "vs_secret_12345",
            showInstructions: true
        )
        
        let livenessVC = TrueFaceLivenessViewController(config: config)
        livenessVC.delegate = self
        livenessVC.modalPresentationStyle = .fullScreen
        present(livenessVC, animated: true)
    }

    // MARK: - TrueFaceLivenessDelegate
    
    func livenessViewController(_ controller: TrueFaceLivenessViewController, didCompleteWithResult result: [String: Any]) {
        controller.dismiss(animated: true)
        print("Liveness complete:", result)
    }

    func livenessViewController(_ controller: TrueFaceLivenessViewController, didFailWithError error: Error) {
        controller.dismiss(animated: true)
        print("Liveness failed:", error.localizedDescription)
    }
}
```

## License
MIT License
