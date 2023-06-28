{
  combine(arrays):
          if std.length(arrays) == 1 then arrays[0]
    else  if std.length(arrays) == 2 then std.flattenArrays(std.map(function(a) std.map(function(b) [a, b], arrays[1]), arrays[0]))
    else  std.flattenArrays(
      std.map(
        function(a) std.map(
          function(b) [a] + b,
          $.combine(arrays[1:std.length(arrays):1])
        ),
        arrays[0]
      )
    ),
}
