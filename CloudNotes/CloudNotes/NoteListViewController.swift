//
//  NoteListViewController.swift
//  CloudNotes
//
//  Created by 배은서 on 2021/06/01.
//

import UIKit

final class NoteListViewController: UIViewController {
    private let noteTableView: UITableView = UITableView()
    private var notes: [NoteData] = []
    static weak var noteDelegate: NoteDelegate?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setNavigationItem()
        setConstraint()
        fetchSampleNote()
    }
    
    private func configureTableView() {
        self.noteTableView.dataSource = self
        self.noteTableView.delegate = self
        self.noteTableView.register(NoteListTableViewCell.self,
                                forCellReuseIdentifier: NoteListTableViewCell.identifier)
        self.noteTableView.reloadData()
        self.noteTableView.showsVerticalScrollIndicator = false
    }
    
    private func setNavigationItem() {
        self.navigationItem.title = "메모"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self,
                                                                 action: nil)
    }
    
    private func setConstraint() {
        noteTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noteTableView)
        
        NSLayoutConstraint.activate([
            noteTableView.topAnchor.constraint(equalTo: view.topAnchor),
            noteTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            noteTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noteTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func fetchSampleNote() {
        guard let notesData = NSDataAsset(name: "sample")?.data,
              let notes = try? JSONDecoder().decode([NoteData].self, from: notesData) else { return }
        
        self.notes = notes
    }
}

extension NoteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteListTableViewCell.identifier, for: indexPath) as? NoteListTableViewCell
        else { return UITableViewCell() }
        
        cell.configure(notes[indexPath.row])
        
        return cell
    }
}

extension NoteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        NoteListViewController.noteDelegate?.showDetailNote(data: notes[indexPath.row])
    }
}