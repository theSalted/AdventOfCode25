// You need bun to run this file: https://bun.sh/

const text = await Bun.file("input").text();
// console.log(text);
const coords = text.split("\n").slice(0, -1);

let max = 0;
for (let i = 0; i < coords.length; i++) {
    const [x, y] = coords[i].split(",").map(Number);

    for (let j = i + 1; j < coords.length; j++) {
        const [x2, y2] = coords[j].split(",").map(Number);
        const area = (Math.abs(x - x2) + 1) * (Math.abs(y - y2) + 1);
        // console.log(`Area between (${x}, ${y}) and (${x2}, ${y2}) is ${area}`);
        if (area > max) {
            max = area;
        }
    }
}

console.log(`Maximum area is ${max}`);
