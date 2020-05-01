//
//  TutorialMockJSON.swift
//  HowToTests
//
//  Created by Tobi Kuyoro on 01/05/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation

let validTutorialJSON = """
{
    "title": "How to Test Your Code",
    "description": "Step 1: Make Sure You Write Correct Code,\nStep 2: Test It,\nStep 3: Good Luck",
    "category": "Computing",
    "guides_id": 1
}
""".data(using: .utf8)!

let inValidTutorialJSON = """
{
    "title": "How to Test Your Code",
    "description": "Step 1: Make Sure You Write Correct Code,
                    Step 2: Test It,
                    Step 3: Good Luck"
    "category": "Computing",
    "guides_id": 1
}
""".data(using: .utf8)!

let noResultJSON = """
{
    "title": "",
    "description: "",
    category: "",
    "guides_id": 0
}
""".data(using: .utf8)!
