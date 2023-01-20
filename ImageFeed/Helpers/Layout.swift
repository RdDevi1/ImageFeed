import UIKit

public func createViewOnVC(newView: UIView, setIn: UIView) {
    newView.translatesAutoresizingMaskIntoConstraints = false
    setIn.addSubview(newView)
}
