//
//  PersonalInfoViewController.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 07.03.2024.
//

import UIKit
import SnapKit

final class PersonalInfoViewController: UIViewController {
    private let emailView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.cornerCurve = .continuous
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 1, height: 4)
        view.layer.shadowRadius = 15
        view.layer.shadowColor = UIColor.black.cgColor
        return view
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupNavigationBar() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backBarButtonItem.tintColor = .black
        navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButtonItem
    }
    
    @objc private func expandView() {
        let expandedHeight: CGFloat = 200
        let collapsedHeight: CGFloat = 100
        let newHeight = (self.emailView.frame.height == collapsedHeight) ? expandedHeight : collapsedHeight

        UIView.animate(withDuration: 0.3) {
            self.emailView.snp.updateConstraints { make in
                make.height.equalTo(newHeight)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    private func createItemLogo(_ imageName: String) -> UIImageView {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(systemName: imageName)
        image.tintColor = .black
        image.backgroundColor = .white
        image.layer.cornerRadius = 15
        image.layer.cornerCurve = .continuous
        return image
    }
    
    private func createBackgroundView() -> UIView {
        let view = UIView()
        view.backgroundColor = .lightGrayColor
        view.layer.cornerRadius = 10
        view.layer.cornerCurve = .continuous
        return view
    }
    
    private func setupView() {
        view.backgroundColor = .lightGrayColor
        title = "personalInfo_label".localized.uppercased()
        
        view.addSubview(emailView)
        emailView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(100)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
}
