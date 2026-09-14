let discount: number = 20;
if (discount < 20) discount += 10;
else discount = discount + 5;
console.log(discount);

let sales: number = 123_456_789;
let course = "TypeScript";
let level1: any = true;
let level2; // if no it is not intialized then the compiler asssumes it is 'any'
level2 = "Any value can be assigned";

let numbers: number[] = [1, 2, 3];
let myarray = [];
myarray[0] = 1;
myarray[1] = "2";
let user: [number, string] = [1, "John"];
console.log(user[1]);
