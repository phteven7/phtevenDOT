-- Project Amethyst: Apple Option = ALT, Command = SUPER.
-- These combinations were unbound when installed.
o.bind("ALT + SHIFT + H", "Amethyst: focus left", hl.dsp.focus({ direction = "l" }))
o.bind("ALT + SHIFT + J", "Amethyst: focus down", hl.dsp.focus({ direction = "d" }))
o.bind("ALT + SHIFT + K", "Amethyst: focus up", hl.dsp.focus({ direction = "u" }))
o.bind("ALT + SHIFT + L", "Amethyst: focus right", hl.dsp.focus({ direction = "r" }))
o.bind("ALT + SHIFT + RETURN", "Amethyst: swap with master", hl.dsp.layout("swapwithmaster master"))
o.bind("ALT + CTRL + SHIFT + H", "Amethyst: shrink master", hl.dsp.layout("mfact -0.05"))
o.bind("ALT + CTRL + SHIFT + L", "Amethyst: grow master", hl.dsp.layout("mfact +0.05"))
o.bind("ALT + CTRL + SHIFT + RETURN", "Amethyst: reset master width", hl.dsp.layout("mfact exact 0.55"))
