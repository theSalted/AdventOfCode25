use std::fs;

fn main() -> Result<(), std::io::Error> {
    let contents = fs::read_to_string("input")?;
    // println!("File contents: {}", contents);
    let lines = contents.lines().collect::<Vec<&str>>();
    let mut maps: Vec<Vec<&str>> =
        lines.iter()
             .map(|line| line.split_whitespace().collect())
             .collect();

    let op_lists = maps.pop().unwrap();
    let num_of_ops = op_lists.len();

    let mut maps_digit: Vec<Vec<i64>> = maps
        .iter()
        .map(|row| row.iter().map(|s| s.parse::<i64>().unwrap()).collect())
        .collect();

    let mut results: Vec<i64> = maps_digit.pop().unwrap();
    let digits: Vec<i64> = maps_digit.clone().into_iter().flatten().collect();



    for (i, digit) in digits.iter().enumerate() {
        let index = i % num_of_ops;
        let op = op_lists[index];
        // println!("Operation: {}, Digit: {}, Prev: {}", op, digit, results[index]);
        match op {
            "+" => results[index] += digit,
            "*" => results[index] *= digit,
            _ => panic!("Invalid operation"),
        }
    }

    let result = results.iter().sum::<i64>();

    println!("Result: {}", result);
    Ok(())
}
