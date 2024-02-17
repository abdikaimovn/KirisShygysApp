//
//  TabBarContoller.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 03.02.2024.
//

import UIKit

final class TabBarContoller: UITabBarController {
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVC()
    }
    
    private func setupVC() {
        let customTabBar = CustomTabBar()
        setValue(customTabBar, forKey: "tabBar")
        tabBar.tintColor = .brownColor
        tabBar.backgroundColor = .lightGrayColor
        viewControllers = [
            createVC(for: createHomeModule(),
                     icon: UIImage(systemName: "house")),
            createVC(for: createServicesModule(),
                     icon: UIImage(systemName: "square.stack.3d.up"))
        ]
        
        let plusButton = setupPlusButton()
        tabBar.addSubview(plusButton)
        plusButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(tabBar.snp.top).inset(5)
            make.size.equalTo(60)
        }
    }
    
    private func setupPlusButton() -> UIButton {
        let image = UIImage(systemName: "plus.circle.fill")?.withTintColor(.brownColor, renderingMode: .alwaysOriginal)
        let plusButton = ExtendedTapAreaButton()
        plusButton.setImage(image, for: .normal)
        plusButton.imageView?.contentMode = .scaleAspectFill
        plusButton.contentHorizontalAlignment = .fill
        plusButton.contentVerticalAlignment = .fill
        plusButton.addTarget(self, action: #selector(addTransactionPressed), for: .touchUpInside)
        return plusButton
    }

    @objc private func addTransactionPressed() {
        let service = UserDataService()
        let presenter = TransactionPresenter(networkService: service)
        let view = TransactionViewController(presenter: presenter)
        presenter.view = view
        present(view, animated: true)
    }
    
    private func createVC(for rootViewController: UIViewController, icon: UIImage?) -> UIViewController{
        let navViewController = rootViewController
        navViewController.tabBarItem.image = icon
        return navViewController
    }

    private func createHomeModule() -> UIViewController {
        let presenter = HomePresenter(networkService: UserDataService())
        let view = HomeViewController(presenter: presenter)
        presenter.view = view
        return view
    }
    
    //TODO: - FIX
    private func createServicesModule() -> UIViewController {
        let view = UIViewController()
        view.view.backgroundColor = .white
        return view
    }
}
