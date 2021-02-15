//
//  ViewController.swift
//  HCCardViewTest
//
//  Created by Saee Saadat on 2/15/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!
    
    private var cards: [CardModel] = []
    private var customCards: [CustomCardModel] = [.addCard]
//    private var customCards: [CustomCardModel] = []
    private var cardsCount: Int {
        return cards.count + customCards.count
    }
    
    private var indexOfMajorCardBeforeDragging = 0
    
    private let pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupCards()
        setupCollectionView()
        
    }
    
    override func viewDidLayoutSubviews() {
        configureCollectionViewSizes()
    }
    
    private func setupCards() {
        cards = [
            CardModel(bank: .ayande, name: "اصغر", number: "۱۲۳۴۵۶۷۸۹۰۱۲۳۴۵۶", expDate: "۰۳/۰۵"),
            CardModel(bank: .mellat, name: "غلام", number: "۱۲۳۴۲۳۴۵۳۴۵۶۴۵۶۷", expDate: "۰۹/۱۲"),
            CardModel(bank: .eghtesad, name: "پلویز", number: "۱۱۱۱۲۲۲۲۳۳۳۳۴۴۴۴", expDate: "۰۲/۰۱")
        ]
    }

    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionViewLayout.minimumLineSpacing = 15
        
        collectionView.register(UINib(nibName: "CardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "card")
        collectionView.register(UINib(nibName: "AddCardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "addCard")
        collectionView.transform = CGAffineTransform(scaleX: -1, y: 1)
        
        setupPageControl()
    }
    
    private func configureCollectionViewSizes() {
        
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionViewLayout.itemSize = CGSize(width: collectionView.frame.width - 60 , height: collectionView.frame.height - 50)
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = cardsCount
        pageControl.currentPage = 0
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: -5),
            pageControl.heightAnchor.constraint(equalToConstant: 20)
        ])
        pageControl.pageIndicatorTintColor = .white
        pageControl.currentPageIndicatorTintColor = .orange
        pageControl.hidesForSinglePage = true
        pageControl.transform = CGAffineTransform.init(scaleX: -1, y: 1)
        
        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: .touchUpInside)
    }
    
    @objc private func changePage(sender: UIPageControl) {
        collectionView.scrollToItem(at: IndexPath(row: sender.currentPage, section: 0), at: .centeredHorizontally, animated: true)
        indexOfMajorCardBeforeDragging = sender.currentPage
    }

}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.row
        
        if (index < cards.count) { // Users cards
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "card", for: indexPath) as? CardCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let card = cards[index]
            cell.setupCell(logo: card.bank?.logo, bank: card.bank?.persianName ?? "-", cardNumber: card.number ?? "---", name: card.name ?? "-", expDate: card.expDate ?? "-/-", themeColor: card.bank?.color ?? .black, numberColor: .black, backgroundColors: card.bank?.backgroundColors ?? [.systemPink, .red])
            cell.transform = CGAffineTransform(scaleX: -1, y: 1)
            
            return cell
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCard", for: indexPath) as? AddCardCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.transform = CGAffineTransform(scaleX: -1, y: 1)
            return cell
        }
    }
}

extension ViewController {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset

        let indexOfMajorCard = getIndexOfMajorCard()

        // check if it was a swipe
        let swipeVelocityThreshold: CGFloat = 0.3
        let hasEnoughVelocityToSlideToTheNextCell = indexOfMajorCardBeforeDragging + 1 < cardsCount && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfMajorCardBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let didUseSwipeToSkipCell =  (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)

        if didUseSwipeToSkipCell {

            let numberOfIndexesToSwipe = min (Int(abs(velocity.x * 0.7)), abs(indexOfMajorCardBeforeDragging - (hasEnoughVelocityToSlideToTheNextCell ? cardsCount-1 : 0)) )
            let snapToIndex = indexOfMajorCardBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1) * numberOfIndexesToSwipe
            let toValue = (collectionViewLayout.itemSize.width + 15) * CGFloat(snapToIndex)
            indexOfMajorCardBeforeDragging = snapToIndex

            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                scrollView.layoutIfNeeded()
                self.pageControl.currentPage = snapToIndex
            }, completion: nil)

        } else {
            let indexPath = IndexPath(row: indexOfMajorCard, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            indexOfMajorCardBeforeDragging = indexOfMajorCard
        }

    }
    
    private func getIndexOfMajorCard() -> Int{
        let width = collectionViewLayout.itemSize.width
        
        let proportionalOffset = collectionView.contentOffset.x / width
        
        let index = Int(round(proportionalOffset))
        return max(0, min(cardsCount - 1, index))
    }
    
}
