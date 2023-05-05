# who_borrowed_what

## Story:
I used to lend notes to my fellow mates but I am a forgetful person. I was also looking for some exploratory project implementing Flutter and Firebase. Then I came up with this idea. This app basically keeps tracks of items that I have lent to others. 

## So What's Special ?
You may be asking so what is special. Two most awesome things that I did here are:
### Made a Custom Query Handler:
So, I encountered this scenario where I had to implement search and sorting. I was using Firestore Listview that takes single query statement. So it became pesky to handle and write multiple queries for multiple scenarios/combinations for search and sorts. And this pain becomes pain++ when I had to replace/edit multiple combinations of where clauses without affecting other part of complete query.
</br>
However, for this one can argue that make a base query and then build all the required queries upon that. Well it will work but what if you have 3 or 4 statements or if you want to edit a portion of query? or maybe combos of multiple where at multiple places? Shit! So my query handler handles these things internally allowing you to replace replace/add/remove specified where clauses without affecting the rest of query statement. I did not really care about adding more than one orderBy clause as there is no meaning to it under normal scenarios. This system is not optimized yet and can't be used for general queries yet.

### Exposed findChildIndexCallback:
I encountered a scenario where my tiles were losing state or more precisely tiles' state were getting mapped to wrong tiles after the removal of tiles from FirestoreListView widget. Solution was to supply the index after the removal of tiles but there was no such property present in the package or more precisely it was not exposed for the widget that I was using. For this I could have used FirestoreQueryBuilder or maybe built a custom widget but it required a lot more biolerplate code. 
</br>
I hate boilerplates 😑 so I looked at the documentation but that too was quite vague so I dug the code itself and since, FirestoreListView is built upon the flutter's listView I did some changes to it to expose the property. I used the snapshot that the FirestoreListView was using internally and exposed it to the callback function so that I can access snapshot outside the package file. After this in the callback function I simple used the snapshot to find the new index and returned that index corresponding to the key of the tile. By the way the key that I was using for tiles is the valuse key with "docId" as its value so I was able to uniquely identify and set up One-to-One mapping function for the findChildIndexCallback.
