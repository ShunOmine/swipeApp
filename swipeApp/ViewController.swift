//
//  ViewController.swift
//  swipeApp
//
//  Created by 大嶺舜 on 2019/08/04.
//  Copyright © 2019 大嶺舜. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var baseCard: UIView!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var person1: UIView!
    @IBOutlet weak var person2: UIView!
    @IBOutlet weak var person3: UIView!
    @IBOutlet weak var person4: UIView!
    @IBOutlet weak var person5: UIView!
    
    //  カードの中心
    var centerOfCard: CGPoint!
    
    // ユーザーカードの配列
    var people = [UIView]()
    
    // 選択したカードの数を数える変数
    var selectedCardCount: Int = 0
    let name = ["津田梅子","ガリレオガリレイ","ジョージワシントン","板垣退助","ジョン万次郎"]
    // いいねされた名前の配列
    var likedName = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerOfCard = baseCard.center
        // peopleにappend
        people.append(person1)
        people.append(person2)
        people.append(person3)
        people.append(person4)
        people.append(person5)
    }
    // 位置と角度を戻す処理をまとめる
    func resetCard() {
        baseCard.center = self.centerOfCard
        baseCard.transform = .identity
    }
    @IBAction func swipeCard(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let point = sender.translation(in: view)
        let xfromCenter = card.center.x - view.center.x
        
        // 取得できた距離をcard.centerに入れる
        card.center = CGPoint(x: card.center.x + point.x, y: card.center.y + point.y)
        // baseCardとユーザーカードに同じ動きをさせる
        people[selectedCardCount].center = CGPoint(x: card.center.x + point.x, y:card.center.y + point.y)
        // 角度がついている状態にする
        card.transform = CGAffineTransform(rotationAngle: xfromCenter / (view.frame.width / 2) * -0.785)
        people[selectedCardCount].transform = CGAffineTransform(rotationAngle: xfromCenter / (view.frame.width / 2) * -0.785)
        if xfromCenter > 0 {
            // goodボタンの表示
            likeImage.image = #imageLiteral(resourceName: "いいね")
            likeImage.isHidden = false
            
        } else if xfromCenter < 0 {
            // badボタンの表示
            likeImage.image = #imageLiteral(resourceName: "よくないね")
            likeImage.isHidden = false
        }
        // 指が離された時の処理
        if sender.state == UIGestureRecognizer.State.ended{
            if card.center.x < 50 {
                // 左に大きくスワイプしたときの処理
                UIView.animate(withDuration: 0.2, animations: {
                    // ベースカードを元の位置に戻す
                    self.resetCard()
                    // 該当のユーザーカードを画面外(マイナス方向)へ飛ばす
                    self.people[self.selectedCardCount].center = CGPoint(
                        x:self.people[self.selectedCardCount].center.x - UIScreen.main.bounds.width,
                        y: self.people[self.selectedCardCount].center.y - self.view.frame.height)
                })
                likeImage.isHidden = true
                self.selectedCardCount += 1
                if self.selectedCardCount >= people.count {
                    performSegue(withIdentifier: "PushToLikedList", sender: self)
                }
                return
            } else if card.center.x > self.view.frame.width - 50 {
                // 右に大きくスワイプしたときの処理
                UIView.animate(withDuration: 0.2, animations: {
                    // ベースカードを元の位置に戻す
                    self.resetCard()
                    // 該当のユーザーカードを画面外(プラス方向)へ飛ばす
                    self.people[self.selectedCardCount].center = CGPoint(
                        x:self.people[self.selectedCardCount].center.x + UIScreen.main.bounds.width,
                        y: self.people[self.selectedCardCount].center.y + self.view.frame.height)
                })
                likeImage.isHidden = true
                self.likedName.append(name[self.selectedCardCount])
                self.selectedCardCount += 1
                if self.selectedCardCount >= people.count {
                    performSegue(withIdentifier: "PushToLikedList", sender: self)
                }
                return
            }
            // 元に戻る処理
            UIView.animate(withDuration: 0.2, animations: {
                self.resetCard()
                self.people[self.selectedCardCount].center = self.centerOfCard
                self.people[self.selectedCardCount].transform = .identity
            })
            likeImage.isHidden = true
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        // viewController を取得
        let vc = segue.destination as! LikedListTableViewController
        vc.likedName = self.likedName
        if segue.identifier == "PushToLikedList" {
            let vc = segue.destination as! LikedListTableViewController
            // LikedListTableViewControllerのlikedName(左)にViewCountrollewのLikedName(右)を代入
            vc.likedName = self.likedName
        }
    }
    @IBAction func likeButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {
            self.resetCard()
            self.people[self.selectedCardCount].center = CGPoint(
                x:self.people[self.selectedCardCount].center.x + 500,
                y:self.people[self.selectedCardCount].center.y)
        })
        likeImage.isHidden = true
        self.likedName.append(name[selectedCardCount])
        self.selectedCardCount += 1
        if selectedCardCount >= people.count {
            // 画面遷移
            performSegue(withIdentifier: "PushToLikedList", sender: self)
        }
        return
    }
    @IBAction func dislikeButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {
            self.resetCard()
            self.people[self.selectedCardCount].center = CGPoint(x:self.people[self.selectedCardCount].center.x - 500, y:self.people[self.selectedCardCount].center.y)
        })
        likeImage.isHidden = true
        self.selectedCardCount += 1
        if selectedCardCount >= people.count {
            performSegue(withIdentifier: "PushToLikedList", sender: self)
        }
        return
    }
    func resetPeople() {
        // 5人の飛んで行ったビューを元の位置に戻す
        for i in 0..<people.count {
            // 元に戻す処理
            people[i].center = self.centerOfCard
            people[i].transform = .identity
        }
        selectedCardCount = 0
        likedName = []
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetPeople()
    }
}

