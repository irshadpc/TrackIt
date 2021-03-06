//
//  AddTagsViewModel.swift
//  TrackIt
//
//  Created by Jason Ji on 4/27/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//

import UIKit

class AddTagsModel {
    var allTags: [Tag] = []
    var tags: [Tag] = [] {
        didSet {
            tags.sortInPlace { $0.name < $1.name }
        }
    }
    var coreDataManager: CoreDataStackManager?
    
    init(coreDataManager: CoreDataStackManager) {
        self.coreDataManager = coreDataManager
        allTags = refreshAllTags()
        
    }
    
    func tryAddTag(tagName: String) {
        guard let context = coreDataManager?.managedObjectContext else { return }
        
        let fetch = NSFetchRequest(entityName: "Tag")
        fetch.predicate = NSPredicate(format: "name == %@", tagName)
        guard let results = try? context.executeFetchRequest(fetch) as! [Tag] else { return }
        if let first = results.first {
            tags.append(first)
            tags.sortInPlace { $0.name < $1.name }
        }
        else {
            let colorIndex = ColorManager.firstAvailableColorIndex(allTags)
            let tag = Tag.tagWithName(tagName, colorIndex: colorIndex, inManagedObjectContext: context)
            tags.append(tag)
            allTags = refreshAllTags()
        }
    }
    
    func removeTag(tagName: String) {
        let tag = tags.filter { $0.name == tagName }.first
        if let tag = tag {
            tags.removeAtIndex(tags.indexOf(tag)!)
        }
    }
    
    func didSelectTagAtIndex(index: Int) {
        guard index < allTags.count else { return }
        let tag = allTags[index]
        if tags.contains(tag) {
            tags.removeAtIndex(tags.indexOf(tag)!)
        }
        else {
            tags.append(allTags[index])
        }
    }
    
    func refreshAllTags() -> [Tag] {
        guard let context = coreDataManager?.managedObjectContext else { return [] }

        let fetchRequest = NSFetchRequest(entityName: "Tag")
        var result = try? context.executeFetchRequest(fetchRequest) as! [Tag]
        result?.sortInPlace { $0.name < $1.name }
        return result ?? []
    }
    
    func containsTag(tag: String) -> Bool {
        return tags.map { t in return t.name }.filter { $0 == tag }.count == 1
    }
}