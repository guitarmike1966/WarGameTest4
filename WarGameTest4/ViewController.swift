//
//  ViewController.swift
//  WarGameTest4
//
//  Created by Michael O'Connell on 5/8/20.
//  Copyright © 2020 Michael O'Connell. All rights reserved.
//

import Cocoa
import MKOGameFramework

let BoardInit: [[GameBoardCellTerrain]] = [
    [ .Water, .Water, .Water, .Grass, .Grass, .Grass, .Grass,    .Woods,    .Woods,    .Woods,    .Woods,    .Woods,    .Grass, .Grass, .Grass, .Grass, .Water, .Water, .Water, .Water, .Water, .Water, .Water ],
    [ .Water, .Water, .Water, .Water, .Grass, .Grass, .Grass,    .Woods,    .Woods,    .Woods,    .Woods,    .Woods,    .Grass, .Grass, .Grass, .Grass, .Water, .Water, .Water, .Water, .Water, .Water, .Water ],
    [ .Water, .Water, .Water, .Water, .Grass, .Grass, .Grass,    .Woods,    .Woods,    .Woods,    .Mountain, .Mountain, .Grass, .Grass, .Grass, .Grass, .Water, .Water, .Water, .Water, .Water, .Water, .Water ],
    [ .Water, .Water, .Water, .Grass, .Grass, .Grass, .Grass,    .Woods,    .Woods,    .Mountain, .Mountain, .Grass,    .Grass, .Grass, .Grass, .Grass, .Water, .Water, .Water, .Water, .Grass, .Water, .Water ],
    [ .Water, .Water, .Grass, .Grass, .Grass, .Grass, .Grass,    .Grass,    .Woods,    .Mountain, .Mountain, .Grass,    .Grass, .Grass, .Grass, .Grass, .Water, .Water, .Water, .Grass, .Grass, .Grass, .Water ],
    [ .Water, .Water, .Grass, .Grass, .Grass, .Grass, .Grass,    .Grass,    .Grass,    .Mountain, .Desert,   .Desert,   .Grass, .Grass, .Grass, .Grass, .Grass, .Water, .Water, .Grass, .Grass, .Water, .Water ],
    [ .Water, .Water, .Water, .Grass, .Grass, .Grass, .Grass,    .Grass,    .Mountain, .Mountain, .Desert,   .Grass,    .Grass, .Grass, .Grass, .Grass, .Grass, .Water, .Water, .Grass, .Grass, .Water, .Water ],
    [ .Water, .Water, .Water, .Grass, .Grass, .Grass, .Grass,    .Mountain, .Desert,   .Desert,   .Desert,   .Grass,    .Grass, .Grass, .Grass, .Grass, .Grass, .Water, .Water, .Water, .Water, .Water, .Water ],
    [ .Water, .Water, .Water, .Grass, .Grass, .Grass, .Mountain, .Mountain, .Grass,    .Desert,   .Desert,   .Grass,    .Grass, .Grass, .Grass, .Grass, .Grass, .Water, .Water, .Water, .Water, .Water, .Water ],
    [ .Water, .Water, .Woods, .Woods, .Grass, .Grass, .Mountain, .Mountain, .Grass,    .Grass,    .Woods,    .Woods,    .Grass, .Grass, .Grass, .Grass, .Grass, .Water, .Water, .Water, .Water, .Water, .Water ],
    [ .Water, .Water, .Grass, .Woods, .Woods, .Grass, .Mountain, .Grass,    .Grass,    .Woods,    .Woods,    .Woods,    .Grass, .Grass, .Grass, .Grass, .Grass, .Water, .Water, .Water, .Water, .Water, .Water ],
    [ .Water, .Water, .Grass, .Woods, .Woods, .Grass, .Mountain, .Grass,    .Grass,    .Woods,    .Woods,    .Woods,    .Grass, .Grass, .Grass, .Grass, .Water, .Water, .Water, .Water, .Water, .Water, .Water ],
    [ .Water, .Water, .Grass, .Woods, .Woods, .Grass, .Mountain, .Grass,    .Grass,    .Woods,    .Woods,    .Woods,    .Grass, .Grass, .Grass, .Grass, .Water, .Water, .Water, .Water, .Water, .Water, .Water ],
    [ .Water, .Water, .Grass, .Woods, .Woods, .Grass, .Mountain, .Grass,    .Grass,    .Woods,    .Woods,    .Woods,    .Grass, .Grass, .Grass, .Grass, .Water, .Water, .Water, .Water, .Water, .Water, .Water ],
    [ .Water, .Water, .Grass, .Woods, .Woods, .Grass, .Mountain, .Grass,    .Grass,    .Woods,    .Woods,    .Woods,    .Grass, .Grass, .Grass, .Grass, .Water, .Water, .Water, .Water, .Water, .Water, .Water ],
    [ .Water, .Water, .Grass, .Woods, .Woods, .Grass, .Mountain, .Grass,    .Grass,    .Woods,    .Woods,    .Woods,    .Grass, .Grass, .Grass, .Grass, .Water, .Water, .Water, .Water, .Water, .Water, .Water ]
]

let Padding: CGFloat = 20

class ViewController: NSViewController {
    
    var mainBoard = GameBoard(initialBoard: BoardInit, cellHeight: 60)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        for y in 0..<mainBoard.rows.count {
            for x in 0..<mainBoard.rows[y].cells.count {
                var newX = Padding + (CGFloat(x) * (mainBoard.CellWidth * 1.0))
                if (y % 2 == 1) {
                    newX = newX + (mainBoard.CellWidth / 2)
                }

                let newY = Padding + (CGFloat(y) * ((mainBoard.CellHeight * 0.7486)))

                mainBoard.rows[y].cells[x].view.frame = NSRect(x: newX, y: newY, width: mainBoard.CellWidth, height: mainBoard.CellHeight)
                mainBoard.rows[y].cells[x].view.tag = (y * 1000) + x

                self.view.addSubview(mainBoard.rows[y].cells[x].view)

                let tapGesture = NSClickGestureRecognizer()
                tapGesture.target = self
                tapGesture.buttonMask = 0x1   // left button
                tapGesture.numberOfClicksRequired = 1
                tapGesture.action = #selector(self.click(g:))
                mainBoard.rows[y].cells[x].view.addGestureRecognizer(tapGesture)
            }
        }

    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    @objc func click(g:NSGestureRecognizer) {

        if let v = g.view as? HexView {

            let touchpoint = g.location(in: v)

            if v.insideMask(x: touchpoint.x, y: touchpoint.y) {
                // print("Inside Hexagon : \(v.tag)")

                let y: Int = v.tag / 1000
                let x: Int = v.tag % 1000

                if (mainBoard.rows[y].cells[x].selected) {
                    mainBoard.rows[y].cells[x].deselectCell()
                }
                else {
                    if mainBoard.rows[y].cells[x].canSelect {
                        mainBoard.clearHighlight()
                        mainBoard.rows[y].cells[x].selectCell()
                    }
                }

            }
            else {
    //                print("Outside Hexagon")
            }

        }
    }


}

