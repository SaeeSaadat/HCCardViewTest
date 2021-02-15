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
    
    private var indexOfMajorCardBeforeDragging = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCards()
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
        ].reversed()
    }

    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionViewLayout.minimumLineSpacing = 15
        
        collectionView.register(UINib(nibName: "CardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "card")
        
        collectionView.transform = CGAffineTransform(scaleX: -1, y: 1)
    }
    
    private func configureCollectionViewSizes() {
        
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionViewLayout.itemSize = CGSize(width: collectionView.frame.width - 60 , height: collectionView.frame.height - 50)
        
    }
    

}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
        
        let indexOfMajorCard = getIndexOfMajorCard()
        
        // check if it was a swipe
        let swipeVelocityThreshold: CGFloat = 0.5
        let hasEnoughVelocityToSlideToTheNextCell = indexOfMajorCardBeforeDragging + 1 < cards.count && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfMajorCardBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging = indexOfMajorCard == indexOfMajorCardBeforeDragging
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
        
        if didUseSwipeToSkipCell {
            
            let snapToIndex = indexOfMajorCardBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            let toValue = collectionViewLayout.itemSize.width * CGFloat(snapToIndex)
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                scrollView.layoutIfNeeded()
            }, completion: nil)
            
        } else {
            let indexPath = IndexPath(row: indexOfMajorCard, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count //+ 1
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
            
        } else { // Add Card
            return UICollectionViewCell()
        }
    }
    
}

extension ViewController {
    
    private func getIndexOfMajorCard() -> Int{
        let width = collectionViewLayout.itemSize.width
        
        let proportionalOffset = collectionView.contentOffset.x / width
        
        let index = Int(round(proportionalOffset))
        return max(0, min(cards.count - 1, index))
    }
    
}
