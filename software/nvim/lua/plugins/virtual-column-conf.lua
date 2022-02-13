return function()
    require('virtual-column').init({
        column_number = 120,
        overlay = false,
        vert_char = "│",
        enabled = true,

        -- do not show column on this buffers and types
        buftype_exclude = {},
        filetype_exclude = {}
    })
end
