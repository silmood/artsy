
// Sends the message 'new' to the class Array
// All classes in SC respond to the message new


var array = Array.new;
array.class;

var clearArray = Array.newClear(7);
clearArray.class;

var clearByIndex = Array.newClear(indexedSize: 9);
clearByIndex.class;


// Introspection messages in order
// to check class tree and  methods for a class

Collection.dumpClassSubtree;
Collection.dumpSubclassList;
Array.dumpAllMethods;


// reverse message is passed to arr
// latter becomes its receiver
// arr looks for the method reverse
// every message returns an object
var arr = [1, 2, 3, 4];
arr.reverse;
arr.postln;