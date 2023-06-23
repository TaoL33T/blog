---
layout: post
title:  "Quicksort"
date:   2023-06-23 13:36:07 +02:00
categories: programming
description: Quicksort in haskell and rust
---

When you are talking about sorting algorithms and divide and conquer you will inevitably stumble uppon quick sort.
This is my take on explaning quick sort with two exampels of code.

## Algorithm

Quicksort takes a list of sortable data and returns a list of sorted data.

1. If the list is empty, return (an empty list)
2. Pick a pivot element and move that aside.
3. Create two lists: 
    - put all the elements smaler than the pivot element in one list
    - put all the elements larger than the pivot element in another
4. Call merge sort on both lists and concatenate them together

## Haskell Implementation

When writing this down in haskell, the solution is rather simple.

```haskell
quicksort :: Ord a => [a] -> [a]
quicksort [] = []
quicksort (p:as) = quicksort lhs ++ [p] ++ quicksort rhs
    where
    lhs = [x | x <- as, x < p]
    rhs = [x | x <- as, x >= p]
```
As you can see, this is literary what I just described in the Algorithm section.

There's just a couple of things that you might need to know to understand this piece of code:

- `++` concatenates two arrays.
- `(p:as)` will match the first element of the list (pivot) as `p` and the rest of the list as `as`.
- `[x | x <- as, x < p]` is a list comprehension where `x < p` is a filter. 
  It only copys elements smaler than the pivot element into `lhs`. Works the same for `rhs`.
- `quicksort [] = []` is the stopping condition of the recursion. 
  *There's not point in sorting an empty list, is there.*

The 3rd line concatenates the arrays that we recursively called `quicksort` on by placing the pivot element in the middle.

I think this is very elegant and is a perfect pseudocode if you want to do quicksort on paper.

## Rust Implementation

This one is probably more performant as less copying around of data is being done.
Slice syntax ensures that only references are being carried around on the call stack.
Therefore it will also consume less memory as no duplicate of the initial array is created.

```rust
pub fn quicksort(slice: &mut [i64]){
    fn partition(slice: &mut [i64], pivot: i64) -> usize {
        let mut i = 0;
        for j in 0..slice.len() {
            if slice[j] <= pivot {
                slice.swap(i, j);
                i += 1;
            }
        }
        i
    }

    let part_index = match slice {
        [] | [_] => return,
        [rest @ .., pivot] => partition(rest, *pivot),
    };
    slice.swap(part_index, slice.len() -1);
    quicksort(&mut slice[0..part_index]);
    quicksort(&mut slice[part_index + 1..]);
}
```

As you can see, this is a lot more complex.
The only section that is somewhat similar to the haskell solution is the `match slice { … }` part.
The execution stops if it is called with an empty slice or a slice with one element. I.E. nothing is there to be sorted anymore.

In this case we'll have to deal with indexes though which makes the whole thing less readable.

## Closing Thoughts

I was only able to understand how to do quick sort on paper after I came up with the haskell solution myself.
It took me about 5 minutes to write that down.
Having all of the indexes out of the way makes it very easy to understand recursive algorithms on lists.
That's because the haskell implementation is very close to mathematical notation.

I hope that someone finds this usefull!\
Cheers.
