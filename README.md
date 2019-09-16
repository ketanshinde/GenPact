# GenPact
Sample assignment.

All below points are covered in sample:
1. User should be able to view list of items which will be fetched from cloud/server. 
2. User should be able to view details by selecting an item from list. 
3. The Item details includes an image, name and other details of that item. 
4. User should be able to mark as a favourite from the detail screen. You can use any local storage techniques for storing the data in device. (Using Core Data)
5. User should be able to access from the section called “Favourite” which will show list of the favourite item.
6. User should be able to navigate to item details from Favourite as well. 
7. User should be able to delete any item from the “Favourite” list.
 
Brief Explanation:
I get the api support from "themoviedb" followed by creating API_KEYS and loading the popular movies in tableView.
I opted forthe mvvm architecture and pritty much modular code with followed guidline so later on easy to test.
Core data is used for coordianting with persistence storage.
Some where i have took the help of singleton pattern, used genrics (Type), business logic in separate file etc etc.

