local strings = import '../../utils/strings.libsonnet';

{
  capitalize: [
    std.assertEqual(strings.capitalize('ABCDE'),  'Abcde'),
    std.assertEqual(strings.capitalize('abcde'),  'Abcde'),
    std.assertEqual(strings.capitalize('aBCDE'),  'Abcde'),
    std.assertEqual(strings.capitalize('aBcDe'),  'Abcde'),
    std.assertEqual(strings.capitalize('-bcde'),  '-bcde'),
    std.assertEqual(strings.capitalize('a'),      'A'),
    std.assertEqual(strings.capitalize('A'),      'A'),
    std.assertEqual(strings.capitalize(''),       ''),
  ],

  sizeof_fmt: [
    std.assertEqual(strings.sizeof_fmt(0),              '0B'),
    std.assertEqual(strings.sizeof_fmt(512),            '512B'),
    std.assertEqual(strings.sizeof_fmt(2561),           '2.50KiB'),
    std.assertEqual(strings.sizeof_fmt(2622464),        '2.50MiB'),
    std.assertEqual(strings.sizeof_fmt(2685403136),     '2.50GiB'),
    std.assertEqual(strings.sizeof_fmt(2749852811264),  '2.50TiB'),
    std.assertEqual(strings.sizeof_fmt(2.8158493e+15),  '2.50PiB'),
    std.assertEqual(strings.sizeof_fmt(2.8834297e+18),  '2.50EiB'),
    std.assertEqual(strings.sizeof_fmt(2.952632e+21),   '2.50ZiB'),
    std.assertEqual(strings.sizeof_fmt(3.0234951e+24),  '> 1 YiB'),
  ],
}
