-- phteven bindings: Apple Option = ALT, Command = SUPER.
-- Inspired by Amethyst. Focus, promote, resize, reset; build from here.
o.bind("ALT + SHIFT + H", "phteven: focus left", hl.dsp.focus({ direction = "l" }))
o.bind("ALT + SHIFT + J", "phteven: focus down", hl.dsp.focus({ direction = "d" }))
o.bind("ALT + SHIFT + K", "phteven: focus up", hl.dsp.focus({ direction = "u" }))
o.bind("ALT + SHIFT + L", "phteven: focus right", hl.dsp.focus({ direction = "r" }))
o.bind("ALT + SHIFT + RETURN", "phteven: swap with master", hl.dsp.layout("swapwithmaster master"))
o.bind("ALT + CTRL + SHIFT + H", "phteven: shrink master", hl.dsp.layout("mfact -0.05"))
o.bind("ALT + CTRL + SHIFT + L", "phteven: grow master", hl.dsp.layout("mfact +0.05"))
o.bind("ALT + CTRL + SHIFT + RETURN", "phteven: reset master width", hl.dsp.layout("mfact exact 0.55"))
