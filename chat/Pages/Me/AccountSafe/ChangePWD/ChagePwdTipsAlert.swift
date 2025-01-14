







import UIKit

class ChagePwdTipsAlert: AlertView, NCAlertInterface {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.okButton?.setShadow(color: UIColor(hexString: Color.shadow_Layer)!, offset: CGSize(width: 0,height: 10), radius: 20, opacity: 0.3)
    }
    
    func ncSize() -> CGSize {
        return CGSize(width: YYScreenSize().width - 30, height: 358)
    }
    
    func ncMaxY() -> CGFloat {
        return 50;
    }
}
