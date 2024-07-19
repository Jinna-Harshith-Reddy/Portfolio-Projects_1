

name = input("Enter your name: ")

weight = int(input("Enter your weight in kg: "))

height_inches = int(input("Enter your height in inches: "))

height_meters = height_inches / 39.3701

BMI = weight/(height_meters * height_meters)

print("B.M.I. = " + str(BMI))

if BMI > 0:
    if BMI < 18.5:
        print(name + ", you are underweight.")
    elif BMI <= 24.5:
        print(name + ", you are normal weight.")
    elif BMI < 29.9:
        print(name + ", you are overweight.")
    elif BMI < 34.9:
        print(name + ", you are obese.")
    elif BMI < 39.9:
        print(name + ", you are severly obese.")
    elif BMI >= 39.9:
        print(name + ", you are morbidly obese.")
    else:
        print("Enter valid inputs.")
