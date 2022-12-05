import { Input } from "./ej4.input"

// Let's define some natural numbers (0 through 100)
type CountToTen<From extends 1[]> = [
    [...From],
    [...From, 1],
    [...From, 1, 1],
    [...From, 1, 1, 1],
    [...From, 1, 1, 1, 1],
    [...From, 1, 1, 1, 1, 1],
    [...From, 1, 1, 1, 1, 1, 1],
    [...From, 1, 1, 1, 1, 1, 1, 1],
    [...From, 1, 1, 1, 1, 1, 1, 1, 1],
    [...From, 1, 1, 1, 1, 1, 1, 1, 1, 1],
]
type _00to09 = CountToTen<[]>
type _10to19 = CountToTen<[..._00to09[9], 1]>
type _20to29 = CountToTen<[..._10to19[9], 1]>
type _30to39 = CountToTen<[..._20to29[9], 1]>
type _40to49 = CountToTen<[..._30to39[9], 1]>
type _50to59 = CountToTen<[..._40to49[9], 1]>
type _60to69 = CountToTen<[..._50to59[9], 1]>
type _70to79 = CountToTen<[..._60to69[9], 1]>
type _80to89 = CountToTen<[..._70to79[9], 1]>
type _90to99 = CountToTen<[..._80to89[9], 1]>
export type Nat = [
    ..._00to09,
    ..._10to19,
    ..._20to29,
    ..._30to39,
    ..._40to49,
    ..._50to59,
    ..._60to69,
    ..._70to79,
    ..._80to89,
    ..._90to99,
    [..._90to99[9], 1]
]
// We want to use `extends` as a boolean, this is a helper
export type Is<A, B> = A extends B ? true : false
// If a number has AT LEAST `N` ones then it is AT LEAST N :)
type AtLeast<N extends 1[]> = [...N, ...1[]]
// We can build the >= relationship using our representation of natural numbers
export type GTE<A, B extends 1[]> = Is<A, AtLeast<B>>

// Unbounded recursion is banned by Typescript, doing block-processing helps us sidestep some limits
export type __BlockSize = Nat[64]

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

type __StringSplitBlock<Str, Delim extends string, BlockCount extends 1[]> =
  BlockCount extends [1, ...infer Rest extends 1[]]
    ? Str extends `${infer A}${Delim}${infer B}`
      ? __StringSplitBlock<B, Delim, Rest> extends [infer Result extends string[], infer Remaining]
        ? [[A, ...Result], Remaining]
        : never // __StringSplitBlock failed execution
      : [[Str], ""] // Reached end of input
    : [[], Str] // Reached end of block

// Given one of the lines from the input set check if the ranges have full overlap!
type RangesColide<A extends 1[], B extends 1[], C extends 1[], D extends 1[]> =
  Is<true, (GTE<A, C> & GTE<D, B> | GTE<C, A> & GTE<B, D>)>

type Exercise<Input> =
  __ExerciseBlock<Input, __BlockSize> extends [infer Block extends 1[], infer Remaining]
    ? Remaining extends [] // Is this the last block?
      ? Block
      : [...Block, ...Exercise<Remaining>]
    : never

export type StringSplit<Str, Delim extends string> =
  __StringSplitBlock<Str, Delim, __BlockSize> extends [infer Block extends string[], infer Remaining]
    ? Remaining extends "" // Is this the last block?
      ? Block
      : [...Block, ...StringSplit<Remaining, Delim>]
    : never

type Lines = StringSplit<Input, '\n'>
// The type Result only allows the correct answer as a valid value
type Result = Exercise<Lines>["length"]
