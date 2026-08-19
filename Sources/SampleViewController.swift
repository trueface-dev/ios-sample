import UIKit
import TrueFaceLiveness

public class SampleViewController: UIViewController, TrueFaceLivenessDelegate {
    
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    private let urlTextField = UITextField()
    private let pubKeyTextField = UITextField()
    private let secretKeyTextField = UITextField()
    private let verIdTextField = UITextField()
    private let secretTextField = UITextField()
    
    private let startButton = UIButton(type: .system)
    private let resultCard = UIView()
    private let resultLabel = UILabel()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 7/255, green: 9/255, blue: 19/255, alpha: 1)
        
        stackView.axis = .vertical
        stackView.spacing = 14
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor(red: 7/255, green: 9/255, blue: 19/255, alpha: 1)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -40),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -48)
        ])
        
        titleLabel.text = "TrueFace Liveness Sample"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        titleLabel.textAlignment = .center
        stackView.addArrangedSubview(titleLabel)
        
        subtitleLabel.text = "iOS Native SDK Demo"
        subtitleLabel.textColor = UIColor(red: 148/255, green: 163/255, blue: 184/255, alpha: 1)
        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        subtitleLabel.textAlignment = .center
        stackView.addArrangedSubview(subtitleLabel)
        
        addInput(label: "Backend URL", textField: urlTextField, defaultText: "https://api.trueface.dev")
        addInput(label: "Public Key", textField: pubKeyTextField, defaultText: "pk_test_urCbiez-hIRbSF7my8Qv8OQdvTmFQXCE")
        addInput(label: "Secret Key", textField: secretKeyTextField, defaultText: "sk_test_vN3N9f78_rdxk8drYfqCAEoo1pb3XdR8")
        addInput(label: "Verification ID (auto-generated if empty)", textField: verIdTextField, defaultText: "")
        addInput(label: "Client Secret (auto-generated if empty)", textField: secretTextField, defaultText: "")
        
        startButton.setTitle("⚡ Start Liveness Check", for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        startButton.backgroundColor = UIColor(red: 79/255, green: 70/255, blue: 229/255, alpha: 1)
        startButton.layer.cornerRadius = 14
        startButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        startButton.addAction(UIAction { [weak self] _ in
            self?.onStartTapped()
        }, for: .touchUpInside)
        
        stackView.addArrangedSubview(startButton)
        
        resultCard.backgroundColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1)
        resultCard.layer.cornerRadius = 16
        resultCard.isHidden = true
        
        resultLabel.textColor = .white
        resultLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        resultLabel.numberOfLines = 0
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        resultCard.addSubview(resultLabel)
        
        NSLayoutConstraint.activate([
            resultLabel.topAnchor.constraint(equalTo: resultCard.topAnchor, constant: 16),
            resultLabel.leadingAnchor.constraint(equalTo: resultCard.leadingAnchor, constant: 16),
            resultLabel.trailingAnchor.constraint(equalTo: resultCard.trailingAnchor, constant: -16),
            resultLabel.bottomAnchor.constraint(equalTo: resultCard.bottomAnchor, constant: -16)
        ])
        
        stackView.addArrangedSubview(resultCard)
    }
    
    private func addInput(label: String, textField: UITextField, defaultText: String) {
        let lbl = UILabel()
        lbl.text = label
        lbl.textColor = UIColor(red: 203/255, green: 213/255, blue: 225/255, alpha: 1)
        lbl.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        stackView.addArrangedSubview(lbl)
        
        textField.text = defaultText
        textField.textColor = .white
        textField.backgroundColor = UIColor(red: 15/255, green: 23/255, blue: 42/255, alpha: 1)
        textField.layer.cornerRadius = 10
        textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 44))
        textField.leftView = padding
        textField.leftViewMode = .always
        stackView.addArrangedSubview(textField)
    }
    
    private func onStartTapped() {
        let verId = verIdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let clientSecret = secretTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if verId.isEmpty || clientSecret.isEmpty {
            createFreshSessionAndStart()
        } else {
            startLiveness()
        }
    }
    
    private func createFreshSessionAndStart() {
        let baseUrl = (urlTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "https://api.trueface.dev").trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let secretKey = secretKeyTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        guard let url = URL(string: "\(baseUrl)/v1/verifications") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(secretKey)", forHTTPHeaderField: "Authorization")
        
        let payload: [String: Any] = [
            "userIdentifier": "ios_sample_user",
            "challengeCount": 3,
            "allowedChallenges": ["blink", "smile", "turnLeft", "turnRight"]
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            if let error = error {
                DispatchQueue.main.async {
                    self.showResult(success: false, text: "Failed to create session:\n\(error.localizedDescription)")
                }
                return
            }
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let id = json["id"] as? String,
                  let secret = json["clientSecret"] as? String else {
                let resStr = data.flatMap { String(data: $0, encoding: .utf8) } ?? "{}"
                DispatchQueue.main.async {
                    self.showResult(success: false, text: "Failed to create session:\n\(resStr)")
                }
                return
            }
            
            DispatchQueue.main.async {
                self.verIdTextField.text = id
                self.secretTextField.text = secret
                self.startLiveness()
            }
        }.resume()
    }
    
    private func startLiveness() {
        let config = TrueFaceConfig(
            backendBaseUrl: urlTextField.text ?? "https://api.trueface.dev",
            publicKey: pubKeyTextField.text ?? "",
            verificationId: verIdTextField.text ?? "",
            clientSecret: secretTextField.text ?? "",
            showInstructions: true
        )
        let controller = TrueFaceLivenessViewController(config: config)
        controller.delegate = self
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    
    // MARK: - TrueFaceLivenessDelegate

    public func livenessViewController(_ controller: TrueFaceLivenessViewController, didUpdateEvent event: [String: Any]) {
        print("[SampleApp] Liveness event update: \(event)")
    }
    
    public func livenessViewController(_ controller: TrueFaceLivenessViewController, didCompleteWithResult result: [String: Any]) {
        controller.dismiss(animated: true)
        showResult(success: true, text: "Verification Succeeded!\n\(result)")
    }
    
    public func livenessViewController(_ controller: TrueFaceLivenessViewController, didFailWithError error: Error) {
        controller.dismiss(animated: true)
        showResult(success: false, text: "Verification Failed:\n\(error.localizedDescription)")
    }
    
    private func showResult(success: Bool, text: String) {
        resultCard.isHidden = false
        resultCard.backgroundColor = success ? UIColor(red: 6/255, green: 95/255, blue: 70/255, alpha: 1) : UIColor(red: 153/255, green: 27/255, blue: 27/255, alpha: 1)
        resultLabel.text = text
    }
}
