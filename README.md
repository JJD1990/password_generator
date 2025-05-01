# Password Generator

## Objective

Create a password generator that can create a secure password.

It should be possible to generate a password by calling a method—you may choose the method signature for this. The method should return a string containing the new password.

This generation method should accept the following options which define the requirements of returned passwords:

- **length** — *(integer)* length of the generated password
- **uppercase** — *(boolean)* include one or more uppercase A-Z characters
- **lowercase** — *(boolean)* include one or more lowercase a-z characters
- **number** — *(integer)* exact number of numeric 0-9 characters
- **special** — *(integer)* exact number of special `@%!?*^&` characters

The function should produce an error in the event of invalid options.

External libraries are allowed for testing purposes. The actual password generation code however should be implemented in your code, and not simply call out to an external library that generates passwords for you.

The code should be packaged as a library/module which could be included into other libraries and applications.

Tests should be included to verify that the code works as intended.

Documentation should be included to demonstrate how to use the library. A well written README is more than sufficient. Please add some notes about how you approached the problem, and any difficulties or issues you encountered during development.

---

## Installation

To use this password generator in your Ruby project, you can copy the `password_generator.rb` file into your project directory or install it as part of your application. You can require it like so:

```ruby
require_relative 'lib/password_generator'
```

You will also need to run the below command to be able to run tests:

```bash
bundle install
```

## Usage

To use this within your terminal:

```bash
irb
```

Then require the file:

```ruby
'lib/password_generator'
```

The call the method:

```ruby
password = PasswordGenerator::Generator.generate(
length: 12,
uppercase: false,
lowercase: false,
number: 0,
special: 12
)
password
```

## Development Approach

1. **Understanding the Requirements**

   The task was to generate a secure password based on user-provided options, with the following:

   - A specified length.
   - At least one uppercase letter if required.
   - At least one lowercase letter if required.
   - Exact counts for numeric digits and special characters.

   I needed to ensure the password had sufficient randomness while respecting the requirements and params provided by the user.

2. **Initial Challenges**

   During the development, a few challenges emerged:

   - **Ensuring Correct Character Counts**: One of the main challenges was ensuring that the exact number of digits and special characters was included in the password, without accidentally exceeding the specified counts during the random filling process. Prioritising certain characters above others helped solve this issue.
   - **Input Validation**: Another challenge was handling incorrect input, such as when the password length was too small or when negative numbers were provided for digits or special characters. This required thorough input validation to ensure the generator only produced valid passwords.
   - **Using MiniTest**: As a regular RSpec user, after hearing about MiniTest at last years Brighton Ruby conference and thought I would give it a try. I am unsure which i prefer currently. Also, figuring out how to test this was quite difficult due to the randomness of the output.

3. **Solution Strategy**

   - **Prioritize Required Characters**: I ensured that the required characters (uppercase, lowercase, digits, special characters) were added first to the password. Then, the remaining length was filled with characters from the allowed pools.
   - **Validation**: Input validation was introduced to catch invalid inputs before attempting to generate the password. I validated the length, checked for negative values in the digit and special character counts, and made sure the length was sufficient to accommodate the required characters.
   - **Shuffling for Randomness**: To ensure that the final password was truly random, the list of characters was shuffled before being returned.

4. **Why I Chose This Approach**

   This approach ensured that:

   - **All Requirements Were Met**: The password generator guarantees that the password will have the exact number of digits and special characters, along with the required uppercase and lowercase letters.
   - **Randomness**: The password is shuffled to ensure that the characters are not predictable.
   - **Flexibility**: The method can generate passwords with a variety of configurations based on user input.

---

## Tests

The library is thoroughly tested to ensure that:

- The password length is correct.
- The password contains the required number of uppercase, lowercase, digits, and special characters.
- Invalid inputs trigger appropriate errors (e.g., negative digits, small password length).
- The password meets the minimum requirements, such as at least one uppercase, one lowercase, one digit, and one special character.

---

## Running Tests

To run the tests, use the following command:

```bash
ruby test_password_generator.rb
```
