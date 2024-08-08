//
//  ViewController.swift
//  ScreenCaptureTest
//
//  Created by Boubyan on 08/08/2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .lightGray
        
        observeScreenRecording()
    }
    
    func observeScreenRecording() {
        if #available(iOS 17.2, *) {
            let scenes = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let window = scenes?.windows.last
            
            let isWindowCaptured = window?.traitCollection.sceneCaptureState == .active
            screenCaptureChanged(isCaptured: isWindowCaptured)
            
            window?.observeSceneCaptureStateChange(completion: { [weak self] isCaptured in
                self?.screenCaptureChanged(isCaptured: isCaptured)
            })
        } else {
            screenCaptureChanged(isCaptured: UIScreen.main.isCaptured)
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.screenCaptureChangedNotification(_:)),
                name: UIScreen.capturedDidChangeNotification, object: nil
            )
        }
    }
    
    @objc func screenCaptureChanged(isCaptured: Bool) {
        if isCaptured {
            handleScreenCaptureStarted()
        }
    }
    
    @objc private func screenCaptureChangedNotification(_ notification: Foundation.Notification) {
        print(notification)
        screenCaptureChanged(isCaptured: UIScreen.main.isCaptured)
    }
    
    private func handleScreenCaptureStarted() {
        statusLabel.text = "Recording"
        print("recording")
    }
}

@available(iOS 17.0, *)
extension UIWindow {
    func observeSceneCaptureStateChange(completion: @escaping (Bool) -> Void) {
        registerForTraitChanges([UITraitSceneCaptureState.self]) { (self: Self, _) in
            // Handle the trait change.
            completion(self.traitCollection.sceneCaptureState == .active)
        }
    }
}
