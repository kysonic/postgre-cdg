# Internals (notes)

Where is DB on the disk? 

```
SHOW data_directory;
```

DB list

```
SELECT oid, datname FROM pg_database;
```

Internal configurations (including - tables, indexes, keys etc)

```
SELECT * FROM pg_class;
```

## Indexes

Full table scan - when there is no indexes, and PG load all blocks from heap into memory and go through it

Indexes contains information about what block in heap the record is in. Data is processed and turned into Binary Search Tree for quick search O(log n);

## Index types

- BTree - creating BST (99%)
- HASH - good for simple equality checks
- GiST - Geometry, Full Text 
- SP-GiST - Clustered data
- GIN - JSON
- BRIN - 

*All PK generates auto indexes and UNIQUE constrains*

## How query works 

- Write Query 
- Parser - Evaluate SQL to query tree in special syntax 
- Rewrite - Optimizations of query tree
- Planer - Find better strategy depends on indexes and so on
- Execute - BOOM!
