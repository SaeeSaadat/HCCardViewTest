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
    @IBOutlet weak var fakeView: UIImageView!
    @IBOutlet weak var avatarIcon: UIImageView!
    
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
        
        setupCards()
        setupCollectionView()
        setupRestOfTheView()
        
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
    
    private func setupRestOfTheView() {
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.fakeTapResponder))
        self.fakeView.addGestureRecognizer(recognizer)
        
        let recognizer2 = UITapGestureRecognizer(target: self, action: #selector(self.fakeTapResponder2))
        self.avatarIcon.addGestureRecognizer(recognizer2)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        haha()
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
            let toValue = (collectionViewLayout.itemSize.width + 15) * CGFloat(snapToIndex) - 10
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

// don't look at this part
extension ViewController {
    
    private func haha(text: String = "Hire Me :)))))) Tnx! ^_^") {
        
        let dimView = UIView()
        dimView.tag = 10005
        dimView.translatesAutoresizingMaskIntoConstraints = false
        
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        dimView.isOpaque = true
        
        let messageView = UIView()
        messageView.translatesAutoresizingMaskIntoConstraints = false
        dimView.addSubview(messageView)
        NSLayoutConstraint.activate([
            messageView.centerYAnchor.constraint(equalTo: dimView.centerYAnchor),
            messageView.centerXAnchor.constraint(equalTo: dimView.centerXAnchor),
            messageView.heightAnchor.constraint(equalToConstant: 250),
            messageView.leadingAnchor.constraint(equalTo: dimView.leadingAnchor, constant: 20),
            messageView.trailingAnchor.constraint(equalTo: dimView.trailingAnchor, constant: -20)
        ])
        messageView.backgroundColor = #colorLiteral(red: 0.001967329561, green: 0.08230567701, blue: 0, alpha: 1)
        messageView.layer.borderWidth = 1.0
        messageView.layer.borderColor = UIColor.white.cgColor
        messageView.layer.cornerRadius = 10
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.textColor = .white
        label.font = UIFont(name: "DIN condensed", size: 50) ?? .systemFont(ofSize: 50)
        label.numberOfLines = 0
        label.textAlignment = .center
        messageView.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: messageView.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: messageView.centerXAnchor),
            label.leadingAnchor.constraint(equalTo: messageView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: messageView.trailingAnchor)
        ])
        label.minimumScaleFactor = 0.5
     
        UIView.transition(with: self.view, duration: 0.4, options: .transitionCrossDissolve, animations: {
            
            self.view.addSubview(dimView)
            self.view.bringSubviewToFront(dimView)
            
            NSLayoutConstraint.activate([
                dimView.topAnchor.constraint(equalTo: self.view.topAnchor),
                dimView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                dimView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                dimView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ])
            
        }, completion: nil)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.removeHaha))
        dimView.addGestureRecognizer(tapRecognizer)
        
    }
    
    @objc private func removeHaha() {
        UIView.transition(with: self.view, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.view.viewWithTag(10005)?.removeFromSuperview()
        }, completion: nil)
    }
    
    @objc private func fakeTapResponder() {
        haha(text: "Come on of course i didn't implement this part! i had less than a day!")
    }
   
    @objc private func fakeTapResponder2() {
        haha(text: "Saee Saadat :) Call me 09363881556")
    }
}
