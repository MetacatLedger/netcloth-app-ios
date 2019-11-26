







import UIKit



class ExportPrivateKeyVerifyVC: BaseViewController {
    
    @IBOutlet weak var privateKeyInput: AutoHeightTextView?
    @IBOutlet weak var verifyBtn: UIButton?
    
    var originPrivateKey: String?
    
    var disbag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configEvent()
    }
    
    func configUI() {
        self.view?.backgroundColor = UIColor(hexString: "#F7F8FA")
        self.verifyBtn?.setShadow(color: UIColor(hexString: Config.Color.shadow_Layer)!, offset: CGSize(width: 0,height: 10), radius: 20,opacity: 0.3)
    }
    
    func configEvent() {
        self.verifyBtn?.rx.tap.subscribe(onNext: { [weak self] in
            if let pk = self?.privateKeyInput?.text ,
                let opk = self?.originPrivateKey {
                if pk == opk {
                    self?.showValidAlert()
                } else {
                    self?.showInvalidAlert()
                }
            }
            else {
                Toast.show(msg: "WalletManager.Error.invalidData")
            }
        }).disposed(by: disbag)
    }
    
    func showValidAlert() {
        if let alert = R.loadNib(name: "OneButtonAlert") as? OneButtonAlert {
            alert.titleLabel?.text = "export_verify_valid_title".localized()
            alert.msgLabel?.text = "export_verify_valid_msg".localized()
            alert.okButton?.setTitle("export_verify_valid_btn".localized(), for: .normal)
            Router.showAlert(view: alert)
            
            alert.okBlock = { [weak self] in
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    func showInvalidAlert() {
        
        if let alert = R.loadNib(name: "OneButtonAlert") as? OneButtonAlert {
            alert.titleLabel?.text = "export_verify_error_title".localized()
            alert.msgLabel?.text = "export_prikey_verify_error_msg".localized()
            alert.okButton?.setTitle("export_verify_error_btn".localized(), for: .normal)
            Router.showAlert(view: alert)
        }
    }

}