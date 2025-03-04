![contactAnimation](https://github.com/user-attachments/assets/f0b0467f-9ab9-4440-abda-27d60a4801f9)# Contact Management App

A simple contact management app built using Core Data and Firebase to store and manage contacts.  The app allows users to add, edit, delete, and mark contacts as favorites. It synchronizes data locally with Core Data and remotely with Firebase.

## Features

- **Add Contacts**: Add new contacts with unique IDs, names, and phone numbers.
- **Edit Contacts**: Modify existing contacts' names, phone numbers, and favorite status.
- **Delete Contacts**: Remove contacts from the local database (Core Data) and Firebase.
- **Mark as Favorite**: Toggle the favorite status of contacts.
- **Core Data Persistence**: Contacts are stored locally using Core Data for offline use.
- **UI**: The app uses UIKit and Storyboard for a smooth user experience.

![contactAnimation](https://github.com/user-attachments/assets/e71044e5-e4a4-479e-8f08-0752795e6274)

## Technologies Used

- **Core Data**: For local storage of contact data.
- **Firebase**: For cloud backup of contact data.
- **UIKit**: For building the user interface.

## Requirements

- Xcode 12 or later
- iOS 12.0 or later
- Swift 5.0 or later

## MVVM architecture used

├── CoreDataManager.swift        # Manages Core Data operations
├── FirebaseManager.swift        # Manages Firebase operations
├── FavoriteManager.swift        # Manages Firebase operations
├── Models
│   └── ContactsModel.xcdatamodeld
├── ViewModels
│   ├── DetailContactViewModel.swift # ViewModel for contact details
│   ├── ContactsViewModel.swift   # ContactsViewModel for contact list
│   ├── AddContactsViewModel.swift   # AddViewModel for contact list
│   └── DetailContactsViewModel.swift   # DetailContactViewModel for contact list
├── ViewControllers
│   ├── ContactViewController.swift  # Displays a list of contacts
│   ├── AddContactViewController.swift  # Displays add contact screen
│   ├── KeypadViewController.swift  # Displays a keypad screen
│   ├── FavoriteViewController.swift  # Displays a list of contacts
│   └── DetailContactViewController.swift # Displays details for a selected contact
└──  Main.storyboard         # Storyboard with UI elements


## Installation

### 1. Clone the repository
Clone this repository to your local machine using:

```bash
git clone https://github.com/yourusername/ContactManagementApp.git
