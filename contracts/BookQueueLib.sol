pragma solidity ^0.4.15;

import "./GroveLib.sol";
//import "./BookPub.sol";

library BookQueueLib {
  using GroveLib for GroveLib.Index;

  int256 constant INT256_MAX = int256(~((uint256(1) << 255)));

  struct BucketQueue {
    GroveLib.Index bucketIndex;
    mapping (bytes32 => address) readerAddress;
    int lastIndex;
    int firstIndex;
  }

  struct BookQueue {
    GroveLib.Index bucketIndex;
    mapping(bytes32 => BucketQueue) buckets;
    mapping(uint => bytes32) bucketIDmap;
    uint numberBuckets;
    bytes32 highestBucketID;
  }

  function createQueue()
    internal
    returns (BookQueue)
  {
    return BookQueue({
      bucketIndex: GroveLib.Index(sha3(this, block.number)),numberBuckets:0,
          highestBucketID: 0
          });
  }

  function addToQueue(BookQueue storage queue, int value, address readerAddress) {
    //Take readers address, store it in BookQueue placement selected by value
    var bucketID = findBucket(queue, value);

    if (bucketID == 0x0) {
      bucketID = createBucket(queue, value);
      if(bucketID > queue.highestBucketID) {
        queue.highestBucketID = bucketID;
      }
    }
    addToBucket(queue, bucketID, readerAddress);
  }

  // TODO: Don't duplicate
  function addToQueueFirst(BookQueue storage queue, int value, address readerAddress) {
    //Take readers address, store it in BookQueue placement selected by value
    var bucketID = findBucket(queue, value);

    if (bucketID == 0x0) {
      bucketID = createBucket(queue, value);
      if(bucketID > queue.highestBucketID) {
        queue.highestBucketID = bucketID;
      }
    }
    addToBucketFirst(queue, bucketID, readerAddress);
  }

  function retrieve(address readerAddress){
  }

  function findBucket(BookQueue storage queue, int value)
    internal
    returns (bytes32 bucketID)
  {
    bucketID = queue.bucketIndex.query("==", value);
  }

  function remove(BookQueue storage queue, address reader, int value)
    returns (bool success)
  {
    bytes32 bucketID = queue.bucketIndex.query('==', value);
    BucketQueue bucket = queue.buckets[bucketID];
    bucket.bucketIndex.remove(bytes32(reader));
    bytes32 nextInLine = bucket.bucketIndex.query('>=', bucket.firstIndex);
    if (nextInLine == bytes32(0)) {
      queue.bucketIndex.remove(bucketID);
      if (bucketID == queue.highestBucketID) {
        queue.highestBucketID = queue.bucketIndex.query('<=', INT256_MAX);
      }
    }
    return true;
  }

  function createBucket(BookQueue storage queue, int value)
    internal
    returns(bytes32 bucketID)
  {
    bucketID = bytes32(value);
    queue.bucketIndex.insert(bucketID, value);
    queue.numberBuckets+=1;
    queue.bucketIDmap[queue.numberBuckets]=bucketID;
    return bucketID;
  }

  function addToBucket(BookQueue storage queue, bytes32 bucketID, address readerAddress)
    internal
  {
    BucketQueue bucket = queue.buckets[bucketID];
    bucket.lastIndex += 1;
    bucket.bucketIndex.insert(bytes32(readerAddress), bucket.lastIndex);
    bucket.readerAddress[bytes32(readerAddress)] = readerAddress;
  }

  function addToBucketFirst(BookQueue storage queue, bytes32 bucketID, address readerAddress)
    internal
  {
    var bucket = queue.buckets[bucketID];
    bucket.firstIndex -= 1;
    bucket.bucketIndex.insert(bytes32(readerAddress), bucket.firstIndex);
    bucket.readerAddress[bytes32(readerAddress)] = readerAddress;
  }

  function getFirstInLine(BookQueue storage queue)
    constant
    returns(address readerAddress)
  {
    var bucketID = queue.highestBucketID;
    var bucket = queue.buckets[bucketID];
    var bucketQueueID = bucket.bucketIndex.query('>=', bucket.firstIndex);
    return address(bucketQueueID);
  }
  function findAllFirst(BookQueue storage queue) returns(address[]){

    address A;
    bytes32 Temp;
    BucketQueue BQ;

    uint N=queue.numberBuckets;
    address[] memory R= new address[](N);
    for (uint i=1;i<N;i++){
      Temp=queue.bucketIDmap[i];
      BQ=queue.buckets[Temp];
      var bucketQueueID= BQ.bucketIndex.query('>=',BQ.firstIndex );

      R[i]= address(bucketQueueID);
    }
    return R;
  }

  function getLinePosition(BookQueue storage queue, uint index)
    constant
    returns(address readerAddress){
    /*var bucketID = queue.highestBucketID;
      var bucket = queue.buckets[bucketID];
      return bucket[bucket.length - 1];*/
  }

}
