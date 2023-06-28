local arrays = import '../../utils/arrays.libsonnet';

{
  _1: std.assertEqual(
    arrays.combine([
      ['1', '2', '3'],
    ]),
    ['1', '2', '3'],
   ),

  _2: std.assertEqual(
    arrays.combine([
      ['1', '2'],
      ['a', 'b'],
    ]),
    [
      ['1', 'a'], ['1', 'b'],
      ['2', 'a'], ['2', 'b']
    ],
   ),

  _3: std.assertEqual(
    arrays.combine([
      ['1', '2'],
      ['a', 'b'],
      ['x', 'y'],
    ]),
    [
      ['1', 'a', 'x'], ['1', 'a', 'y'],
      ['1', 'b', 'x'], ['1', 'b', 'y'],

      ['2', 'a', 'x'], ['2', 'a', 'y'],
      ['2', 'b', 'x'], ['2', 'b', 'y'],
    ],
   ),
}
