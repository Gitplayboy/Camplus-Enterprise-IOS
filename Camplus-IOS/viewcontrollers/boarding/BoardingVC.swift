//
//  BoardingVC.swift
//  Camplus-IOS
//
//  Created by yadhukrishnan E on 23/04/20.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit

class BoardingVC: UIViewController {

    @IBOutlet weak var pageController: UIPageControl!
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var cvBoardings: UICollectionView!
    
    var boards: [Board] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupCV()
        setupBoardingData()
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.topItem?.hidesBackButton = true
        navigationItem.hidesBackButton = true
    }
    
    func setupCV() {
        cvBoardings.delegate = self
        cvBoardings.dataSource = self
        
    }
    
    func setupBoardingData() {
        let one = Board()
        one.heading = "Easy to use"
        one.description = "Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing industries for previewing layouts and visual mockups."
        one.image = "slide_1"
        one.color = "#698FB7"
        boards.append(one)
        
        let two = Board()
        two.heading = "Connectivity"
        two.description = "Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing industries for previewing layouts and visual mockups."
        two.image = "slide_2"
        two.color = "#6AB1B7"
        boards.append(two)
        
        let three = Board()
        three.heading = "Latest Feeds"
        three.description = "Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing industries for previewing layouts and visual mockups."
        three.image = "slide_3"
        three.color = "#9C8FBF"
        boards.append(three)
        
        cvBoardings.reloadData()
    }
    
    @IBAction func onSkipClicked(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "boarding")
        performSegue(withIdentifier: "segue_to_login_screen", sender: sender)
    }
    
    @IBAction func onNextClicked(_ sender: Any) {
        let currentPage = self.pageController.currentPage
        if (currentPage == (boards.count - 1)) {
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "boarding")
            performSegue(withIdentifier: "segue_to_login_screen", sender: sender)
        } else {
            let indexPath = IndexPath(row: currentPage + 1, section: 0)
            cvBoardings.scrollToItem(at: indexPath, at: .right, animated: true)
        }
    }
    
}

extension BoardingVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.pageController.numberOfPages = self.boards.count
        return self.boards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_boarding_screen", for: indexPath)
        as! BoardingCVCell
        cell.setBoard(board: boards[indexPath.row])
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.tag == 0) {
            let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height) / 2)
            if let ip = self.cvBoardings.indexPathForItem(at: center) {
                cvBoardings.backgroundColor = UIColor(hexa: boards[ip.row].color)
                self.pageController.currentPage = ip.row
                if (pageController.currentPage == (boards.count - 1)) {
                    self.btnNext.setTitle("Finish", for: .normal)
                } else {
                    self.btnNext.setTitle("Next", for: .normal)
                }
            }
        }
    }
}

extension BoardingVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
}
