def colored_string string, color
  {
    black: "\e[30m%s\e[0m",
    red: "\e[31m%s\e[0m",
    green: "\e[32m%s\e[0m",
    brown: "\e[33m%s\e[0m",
    blue: "\e[34m%s\e[0m",
    magenta: "\e[35m%s\e[0m",
    cyan: "\e[36m%s\e[0m",
    gray: "\e[37m%s\e[0m",
    bg_black: "\e[40m%s\e[0m",
    bg_red: "\e[41m%s\e[0m",
    bg_green: "\e[42m%s\e[0m",
    bg_brown: "\e[43m%s\e[0m",
    bg_blue: "\e[44m%s\e[0m",
    bg_magenta: "\e[45m%s\e[0m",
    bg_cyan: "\e[46m%s\e[0m",
    bg_gray: "\e[47m%s\e[0m",
    bold: "\e[1m%s\e[22m",
    italic: "\e[3m%s\e[23m",
    underline: "\e[4m%s\e[24m",
    blink: "\e[5m%s\e[25m",
    reverse_color: "\e[7m%s\e[27m",
  }.fetch(color) % string
end