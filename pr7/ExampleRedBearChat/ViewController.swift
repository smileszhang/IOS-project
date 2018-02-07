//
//  ViewController.swift
//  ExampleRedBearChat
//
//  Created by Eric Larson on 9/26/17.
//  Copyright © 2017 Eric Larson. All rights reserved.
//

import UIKit

// MARK: CHANGE 2: No longer should this view be a BLE delegate
class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate{
    
    
    @IBOutlet weak var collectionMainView: UICollectionView!
    
    @IBOutlet weak var button0: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!

    @IBOutlet weak var button5: UIButton!
    
    @IBOutlet weak var button6: UIButton!
    
    @IBOutlet weak var sendButtonoutlet: UIButton!
    var imageArr = [UIImage]()
    var nameArray = [String]()

    lazy var bleShield:BLE = (UIApplication.shared.delegate as! AppDelegate).bleShield

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionMainView.layer.borderColor = UIColor.brown.cgColor
        collectionMainView.layer.borderWidth = 1
    }
 
    
    @IBAction func button0Action(_ sender: UIButton) {
        imageArr.append(UIImage(named:"0")!)
        nameArray.append("0")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
            self.collectionMainView.reloadData()
            
        })
    }
    
    @IBAction func button1Action(_ sender: UIButton) {
        imageArr.append(UIImage(named:"1")!)
        nameArray.append("1")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
            self.collectionMainView.reloadData()

        })

    }
    
    @IBAction func button2Action(_ sender: UIButton) {
        imageArr.append(UIImage(named:"2")!)
        nameArray.append("2")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
            self.collectionMainView.reloadData()

        })

    }
    
    @IBAction func button3Action(_ sender: UIButton) {
        imageArr.append(UIImage(named:"3")!)
        nameArray.append("3")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
            self.collectionMainView.reloadData()

        })

    }
    @IBAction func button4Action(_ sender: UIButton) {
        imageArr.append(UIImage(named:"4")!)
        nameArray.append("4")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
            self.collectionMainView.reloadData()

        })
    }
    @IBAction func button5Action(_ sender: UIButton) {
        imageArr.append(UIImage(named:"5")!)
        nameArray.append("5")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
            self.collectionMainView.reloadData()

        })
    }
    @IBAction func button6Action(_ sender: UIButton) {
        imageArr.append(UIImage(named:"6")!)
        nameArray.append("6")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
            self.collectionMainView.reloadData()

        })
    }
    
    @IBAction func sendButton(_ sender: UIButton) {
        var s = "";
        for str in nameArray{
            s+=str
        }
        let d = s.data(using: String.Encoding.utf8)!
        bleShield.write(d)
    }


    @IBAction func clearButton(_ sender: UIButton) {
        imageArr.removeAll()
        nameArray.removeAll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
            self.collectionMainView.reloadData()
        })
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArr.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath)
            as! ImageCollectionViewCell
        cell.imgImage.image = imageArr[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }

}





