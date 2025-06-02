# EmpyreanMobileTakeHomeProject

This mobile app fetches the items from the MOCK API. A user can login with the correct username and passcode. The auth token retreived by the API will
kept in the Keychain untill the user signs out. The user can view the full list of items fetched by the API and then view more details on the item. 
The user can favorite and item and the item will be saved in the User Defaults until removing it. 

## Run
Please clone the repository from Github and run using Xcode

## Features
* Developed in Swift & UIKIT
* Save JWT token with Keychain
* Favorite item and save them with User Defaults
* Cache images retrieved from the internet
* Internet connection monitoring / empty states
* Error handling
* Modern UI with light and dark mode
  
## Previews

<img width="175" height="375" alt="SpaceXAppiPhoneLight" src="https://github.com/user-attachments/assets/e48902e4-7cdb-402c-8be8-f97e379ed44a"/>
<img width="175" height="375" alt="SpaceXAppiPhoneLight" src="https://github.com/user-attachments/assets/c789787c-8e49-4bf8-9126-a33387fbb6d8"/>
<img width="175" height="375" alt="SpaceXAppiPhoneLight" src="https://github.com/user-attachments/assets/5d048576-77ec-436c-8a73-5771d2259c66"/>
<img width="175" height="375" alt="SpaceXAppiPhoneLight" src="https://github.com/user-attachments/assets/581a0b65-5466-4e87-8df6-14e219f1b52d"/>
<img width="175" height="375" alt="SpaceXAppiPhoneLight" src="https://github.com/user-attachments/assets/a5bb5205-1d6c-4f48-8ee6-e6f73ef88f2c"/>

## Testing
* NetworkImage Downloader tested with XCText

## Trade Offs
I would have more thoroughly created unit test for the APIClient and UI testing for views. I would liked to better empty states and error handling.   

