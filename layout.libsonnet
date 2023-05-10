local grid_width = 24;

{
  width:: {
    full::        grid_width,

    half::        grid_width / 2,
    quarter::     grid_width / 4,
    heighth::     grid_width / 8,

    one_third::   grid_width / 3,
    two_thirds::  grid_width / 3 * 2,

    one_fifth::   grid_width / 5,
    one_sixth::   grid_width / 6,
  },

  /**
   * @name layout.pos
   *
   * Generate standard positions based on the specified height.
   *
   * @param height The standard height for a panel.
   *
   * @return Standard layout position values.
   */
  pos(height):: {
    _1:     { w: $.width.full,       h: height        },
    _2:     { w: $.width.half,       h: height        },
    _4:     { w: $.width.quarter,    h: height        },
    _3:     { w: $.width.one_third,  h: height        },
    _5:     { w: $.width.one_fifth,  h: height        },
    _6:     { w: $.width.one_sixth,  h: height        },

    title:  { w: $.width.full,       h: height / 2    },
  },

  /**
   * @name layout.generate_grid
   *
   * Generate Grafana grid, based on panels size.
   * Should be called only once with the list of all panels that will be added.
   * It puts panels from left to right, until there is a free space, and then uses new line.
   * Line step on a new line break is the height of the last panel in a previous line.
   * You can use rows as line breaks.
   * For complex structures you can insert panels with pre-set position,
   * but you must be careful to not introduce conflicts.
   * If there are conflicts in grid, Grafana will solve them on import.
   * Grafana's negative gravity will also be applied on import, it is not computed here.
   * You should be careful with using both this and dynamic repeating with variables:
   * static generator do not know about dynamic repeating,
   * so Grafana conflict solver will be applied on import.
   *
   * @param panels List of panels (their width and height must be set in gridPos)
   *
   * @return List of panels with computed grid positions
   */
  generate_grid(panels):: [
    el {
      gridPos: {
        x: el.gridPos.x,
        y: el.gridPos.y,
        h: el.gridPos.h,
        w: el.gridPos.w,
      },
    }
    for el in std.foldl(function(_panels, p) (
      local i = std.length(_panels);
      local prev = (if i == 0 then null else _panels[i - 1]);

      if i == 0 then
        _panels + [p { gridPos: {
          x: 0,
          y: 0,
          h: p.gridPos.h,
          w: p.gridPos.w,
          x_cursor: p.gridPos.w,
          y_cursor: 0,
        } }]
      else
        local line_break = prev.gridPos.x_cursor + p.gridPos.w > grid_width;

        _panels + [p { gridPos: {
          x:
            if std.objectHas(p.gridPos, 'x') then
              p.gridPos.x
            else if line_break then
              0
            else
              prev.gridPos.x_cursor,

          y:
            if std.objectHas(p.gridPos, 'y') then
              p.gridPos.y
            else if line_break then
              prev.gridPos.y_cursor + prev.gridPos.h
            else
              prev.gridPos.y_cursor,

              h: p.gridPos.h,

              w: p.gridPos.w,

              x_cursor:
                if std.objectHas(p.gridPos, 'x') then
                  p.gridPos.x + p.gridPos.w
                else if line_break then
                  p.gridPos.w
                else
                  prev.gridPos.x_cursor + p.gridPos.w,

              y_cursor:
                if std.objectHas(p.gridPos, 'y') then
                  p.gridPos.y
                else if line_break then
                  prev.gridPos.y_cursor + prev.gridPos.h
                else
                  prev.gridPos.y_cursor,
        } }]
    ), panels, [])
  ],
}
