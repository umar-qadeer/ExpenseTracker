
import UIKit

final class AddTransactionViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, AddTransactionViewModelToViewDelegate {
    
    // MARK: - Properties
    
    private var viewModel: AddTransactionViewModel
    private var pickerView = UIPickerView()
    
    // MARK: IBOutlet
    
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var addTransactionButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Initializers
    
    init(viewModel: AddTransactionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        amountTextField.becomeFirstResponder()
    }
    
    // MARK: - Private Functions
    
    private func setupUI() {
        addTransactionButton.layer.cornerRadius = 16
        
        // pickerView
        pickerView.dataSource = self
        pickerView.delegate = self
        
        // toolBar buttons
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneButton))
        doneButton.accessibilityIdentifier = AccessibilityIdentifier.doneBarButtonItem
        
        // toolBar
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 45))
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.setItems([spaceButton, doneButton], animated: true)
        
        // typeTextField
        typeTextField.tintColor = .clear
        typeTextField.text = viewModel.transactionTypes.first
        typeTextField.inputAccessoryView = toolBar
        typeTextField.inputView = pickerView
    }
    
    private func setupNavigationBar() {
        self.title = Strings.Titles.addTransaction
    }
    
    // MARK: - Selectors
    
    @objc private func didTapDoneButton() {
        self.view.endEditing(true)
    }
    
    // MARK: - IBActions
    
    @IBAction func didTapDropDownButton(_ sender: UIButton) {
        typeTextField.becomeFirstResponder()
    }
    
    @IBAction func didTapAddTransactionButton(_ sender: UIButton) {
        // Force unwrapping is safe here because addTransactionButton will be enabled only when inputs are valid
        viewModel.addTransaction(amount: amountTextField.text!, type: typeTextField.text!, description: descriptionTextField.text!)
    }
    
    @IBAction func didChangeTextField(_ textField: UITextField) {
        addTransactionButton.isEnabled = viewModel.isValidInput(amount: amountTextField.text, type: typeTextField.text, description: descriptionTextField.text)
    }
    
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.transactionTypes.count
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.transactionTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeTextField.text = viewModel.transactionTypes[row]
    }
    
    // MARK: - AddTransactionViewModelToViewDelegate
    
    func showLoading(_ loading: Bool) {
        loading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
}
