//
//  ReportViewController.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 22.02.2024.
//

import UIKit
import SnapKit

final class ReportViewController: UIViewController {
    private let presenter: ReportPresenter
    
    //MARK: - UI Elements
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .white
        return pageControl
    }()
    
    private let storiesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(StoryCollectionViewCell.self, forCellWithReuseIdentifier: StoryCollectionViewCell.typeName)
        collectionView.register(QuoteCollectionViewCell.self, forCellWithReuseIdentifier: QuoteCollectionViewCell.typeName)
        return collectionView
    }()
    
    //MARK: - Lifecycle
    init(presenter: ReportPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
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

    //MARK: - Functions
    private func setupNavigationBar() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backBarButtonItem.tintColor = .white
        navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButtonItem
    }
    
    private func setupCollectionView() {
        storiesCollectionView.dataSource = self
        storiesCollectionView.delegate = self
    }
    
    private func setupView() {
        view.backgroundColor = .expenseColor
        
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(5)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        view.addSubview(storiesCollectionView)
        storiesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
        }
        
        setupCollectionView()
    }
}

extension ReportViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfItemsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 || indexPath.row == 1 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCollectionViewCell.typeName, for: indexPath) as? StoryCollectionViewCell {
                cell.configure(reportModel: presenter.dataForItem(at: indexPath))
                return cell
            }
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuoteCollectionViewCell.typeName, for: indexPath) as? QuoteCollectionViewCell {
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        let currentPage = Int((scrollView.contentOffset.x + width / 2) / width)
        
        // Check if the current page is different from the previous one
        if pageControl.currentPage != currentPage {
            pageControl.currentPage = currentPage
            presenter.pageControlDidChange(currentPage)
        }
    }
}

extension ReportViewController: ReportViewProtocol {
    func updateViewAppereance(with color: UIColor) {
        view.backgroundColor = color
    }
}
