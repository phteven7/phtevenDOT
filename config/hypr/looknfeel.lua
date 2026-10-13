-- Project Amethyst: native dynamic centered master; keep Omarchy styling.
hl.config({
  general = { layout = "master" },
  master = {
    orientation = "center",
    mfact = 0.55,
    new_status = "slave",
    slave_count_for_center_master = 2,
    center_master_fallback = "left",
  },
})
