# GenPact
Sample assignment.

![alt text](https://github.com/ketanshinde/GenPact/blob/master/GenPact/Assets.xcassets/IMG_0360.imageset/IMG_0360.png)


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
I installed libraries through carthage,(pods are already know)
I opted forthe mvvm architecture and pritty much modular code with followed guidline so later on easy to test.
Core data is used for coordianting with persistence storage.
Some where i have took the help of singleton pattern, used genrics (Type), business logic in separate file etc etc.

NOTE: 
Some time the api "themoviedb" donot make secure connection with server. That machine may have SSL certifcate issue.
I encountered same issue while i was running the code in different mac machine. I hit the api in browser but unable to store the secure connection, hence SLL Handshake failed.
But everything is running fine in devices when created ipa.

I also uploaded screen shot from device how app looks like.
Thanks! :)

