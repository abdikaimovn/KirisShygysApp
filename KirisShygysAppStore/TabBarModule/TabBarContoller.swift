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
        }
    }
    
    private func setupPlusButton() -> UIButton {
        let buttonSize: CGFloat = 60
        let image = UIImage(systemName: "plus.circle.fill")?.withTintColor(.brownColor, renderingMode: .alwaysOriginal)
        let resizedImage = image?.resized(to: CGSize(width: buttonSize, height: buttonSize))
        
        let plusButton = ExtendedTapAreaButton(type: .custom)
        plusButton.setImage(resizedImage, for: .normal)
        plusButton.backgroundColor = .clear
        plusButton.addTarget(self, action: #selector(addTransactionPressed), for: .touchUpInside)
        return plusButton
    }
    
    //TODO: Добавить модуль добавления новых транзакций
    @objc private func addTransactionPressed() {

    }
    
    private func createVC(for rootViewController: UIViewController, icon: UIImage?) -> UIViewController{
        let navViewController = rootViewController
        navViewController.tabBarItem.image = icon
        return navViewController
    }
    
    //TODO: - FIX
    private func createHomeModule() -> UIViewController {
        let view = UIViewController()
        view.view.backgroundColor = .white
        return view
    }
    
    //TODO: - FIX
    private func createServicesModule() -> UIViewController {
        let view = UIViewController()
        view.view.backgroundColor = .white
        return view
    }
}
