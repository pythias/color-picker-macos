function fetch(pattern) {
    id = $(pattern).data('id');
    username = $(pattern).data('username');
    colors = $(pattern).data('colors');
    colors = colors.split('-');

    return {
        id: id,
        username: username,
        colors: colors,
    };
}

patterns = $(".browser-palette");
pattern_codes = [];

for (var i = 0; i < patterns.length; i++) {
    pattern = patterns[i];
    info = fetch(pattern);

    codes = "colors = [Color]()\n";
    for (var j = 0; j < info.colors.length; j++) {
        color = info.colors[j];
        codes += "colors.append(Color(red: " + parseInt(color.substring(0, 2), 16) + ", green: " + parseInt(color.substring(2, 4), 16) + ", blue: " + parseInt(color.substring(4, 6), 16) + ", alpha: 1))\n";
    }
    codes += "pattens.append(Pattern(id: \"hunt-" + info.id + "\", name: \" + info.username + \", colors: colors))\n\n";

    pattern_codes.push(codes);
}


console.log(pattern_codes.join(""));

