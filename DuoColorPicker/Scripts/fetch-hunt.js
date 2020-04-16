//https://colorhunt.co/palettes/popular
function fetch(pattern) {
    id = $(pattern).data('id');
    code = $(pattern).data('code');
    if (code == undefined) {
        return undefined;
    }
    
    colors = [];
    for (var i = 0; i < code.length; i+=6) {
        colors.push(code.substr(i, 6));
    }

    return {
        id: id,
        username: id,
        colors: colors,
    };
}

patterns = $(".item");
pattern_codes = [
    "var pattens = [Pattern]()\n",
    "var colors = [Color]()\n",
];

for (var i = 0; i < patterns.length; i++) {
    pattern = patterns[i];
    info = fetch(pattern);
    if (info == undefined) {
        continue;
    }

    codes = "colors = [Color]()\n";
    for (var j = 0; j < info.colors.length; j++) {
        color = info.colors[j];
        codes += "colors.append(Color(red: " + parseInt(color.substring(0, 2), 16) + ", green: " + parseInt(color.substring(2, 4), 16) + ", blue: " + parseInt(color.substring(4, 6), 16) + ", alpha: 1))\n";
    }
    codes += "pattens.append(Pattern(id: \"hunt-" + info.id + "\", name: \"" + info.username + "\", colors: colors))\n\n";

    pattern_codes.push(codes);
}

pattern_codes.push("return pattens\n");

console.log(pattern_codes.join(""));

