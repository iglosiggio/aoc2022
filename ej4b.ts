import { Lines, Is, GTE, __BlockSize, Nat } from './ej4'

// Given one of the lines from the input set check if the ranges have full overlap!
type RangesColide<A extends 1[], B extends 1[], C extends 1[], D extends 1[]> =
  Is<true, GTE<D, A> & GTE<B, C>>

type __ExerciseBlock<Input, BlockCount extends 1[]> =
  BlockCount extends [1, ...infer Rest extends 1[]]
    ? Input extends [infer Line, ...infer Tail]
      ? Line extends `${infer A extends number}-${infer B extends number},${infer C extends number}-${infer D extends number}`
        ? __ExerciseBlock<Tail, Rest> extends [infer Result extends unknown[], infer Remaining]
          ? RangesColide<Nat[A], Nat[B], Nat[C], Nat[D]> extends true
            ? [[1, ...Result], Remaining] // This line matches the constraint
            : [Result, Remaining] // This line doesn't match the constraint
          : never // __ExerciseBlock failed execution
        : never // Failed to parse line
      : [[], []] // Reached end of input
    : [[], Input] // Reached end of block

type Exercise<Input> =
  __ExerciseBlock<Input, __BlockSize> extends [infer Block extends 1[], infer Remaining]
    ? Remaining extends [] // Is this the last block?
      ? Block
      : [...Block, ...Exercise<Remaining>]
    : never

type Result = Exercise<Lines>["length"]