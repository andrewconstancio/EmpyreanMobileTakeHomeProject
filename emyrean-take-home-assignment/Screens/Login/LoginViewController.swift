//
//  LoginViewController.swift
//  empyrean-mobile-take-home-assignment
//
//  Created by Andrew Constancio on 5/29/25.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Properties
    
    /// API client
    private var apiClient: APIClientProtocol
    
    // MARK: UI Components
    
    /// Username text field
    private var usernameTextField = EMTextField(placeholder: "Username")
    
    /// Password text field
    private var passwordTextField = EMTextField(placeholder: "Password", isSecureTextEntry: true)
    
    /// Login button
    private var loginButton = EMButton(backgroundColor: .systemIndigo, title: "Login")
    
    /// Spinner indicator
    let spinner = SpinnerViewController()
    
    /// Stack view to contain off the input fields as well as the login button
    let stackView = UIStackView()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardNotifications()
        hideKeyboardWhenTappedAround()
        setupActions()
        configureStackView()
        setupUI()
    }
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI components set up
    
    /// Do set up for stack view for inputs and buttons
    func configureStackView() {
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        
        stackView.addArrangedSubview(usernameTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(loginButton)
    }
    
    /// Do UI set up and set constraints for UI components
    func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 24
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            stackView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    // MARK: UI Actions set up
    
    /// Set up target actions for tap events on buttons
    func setupActions() {
        loginButton.addTarget(
            self,
            action: #selector(loginButtonTapped),
            for: .touchUpInside
        )
    }
    
    // MARK: Actions
    
    /// Handles login button tap, validation, and sends a login request
    @objc func loginButtonTapped() {
        
        // Disable the login for multiple taps
        loginButton.isEnabled = false
        
        // Validate the username and password
        guard
            let username = usernameTextField.text, !username.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else {
            self.presentAlertOnMainThread(
                title: "Login Error",
                message: EMError.invalidUsernameOrPassword.rawValue,
                buttonTitle: "OK"
            )
            loginButton.isEnabled = true
            return
        }
        
        // Check network connection
        guard NetworkMonitor.shared.isConnected else {
            self.presentAlertOnMainThread(
                title: "No Connection",
                message: EMError.noInternetConnection.rawValue,
                buttonTitle: "OK"
            )
            loginButton.isEnabled = true
            return
        }
        
        // Show loading indicator
        createSpinnerView()
        
        // Attempt login
        apiClient.login(username: username, password: password) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.removeSpinnerView()
                self.loginButton.isEnabled = true
            
                switch result {
                case .success(let loginResponse):
                    do {
                        // Save JWT receive from server into keychain
                        try TokenManager.shared.saveAuthToken(loginResponse.token)
                        self.navigateToMainView()
                    } catch {
                        self.presentAlertOnMainThread(
                            title: "Login Error",
                            message: EMError.generalError.rawValue,
                            buttonTitle: "OK"
                        )
                    }
                case .failure(let error):
                    self.presentAlertOnMainThread(
                        title: "Login Error",
                        message: error.rawValue,
                        buttonTitle: "OK"
                    )
                }
            }
        }
    }
    
    /// Navigate to the main view by replacing the root view
    func navigateToMainView() {
        let mainVC = EMTabBarController()
        let navController = UINavigationController(rootViewController: mainVC)
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = navController
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }
    
    // MARK: - Spinner Management
    
    /// Creates a custom spinner indicator to show loading process
    fileprivate func createSpinnerView() {
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }
    
    /// Removes the spinning indicator from the view
    fileprivate func removeSpinnerView() {
        spinner.willMove(toParent: nil)
        spinner.view.removeFromSuperview()
        spinner.removeFromParent()
    }
}
