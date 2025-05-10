require 'minitest/autorun'
require_relative '../lib/password_generator'

class TestPasswordGenerator < Minitest::Test
  def test_generate_password
    # Generate password with specific criteria
    password = PasswordGenerator::Generator.generate(
      length: 15,
      uppercase: true,
      lowercase: true,
      number: 3,
      special: 2
    )

    # Ensure the password length is correct
    assert_equal 15, password.length

    # Ensure it contains at least one uppercase letter
    assert_match(/[A-Z]/, password)

    # Ensure it contains at least one lowercase letter
    assert_match(/[a-z]/, password)

    # Ensure exactly 3 digits
    assert_equal 3, password.scan(/\d/).length

    # Ensure exactly 2 special characters
    assert_equal 2, password.count('@%!?*^&')
  end

  def test_invalid_options
    # Test when length is too small to accommodate the required characters
    assert_raises(
      PasswordGenerator::InvalidOptionsError,
      "Password length must be greater than or equal to the sum of required characters"
    ) do
      PasswordGenerator::Generator.generate(length: 5, uppercase: true, lowercase: true, number: 3, special: 2)
    end

    # Test when the number of special characters is negative
    assert_raises(PasswordGenerator::InvalidOptionsError, "Number and special must be non-negative integers") do
      PasswordGenerator::Generator.generate(length: 10, uppercase: true, lowercase: true, number: 3, special: -1)
    end

    # Test when the number of numeric characters is negative
    assert_raises(PasswordGenerator::InvalidOptionsError, "Number and special must be non-negative integers") do
      PasswordGenerator::Generator.generate(length: 10, uppercase: true, lowercase: true, number: -3, special: 2)
    end

    # Test when length is zero
    assert_raises(PasswordGenerator::InvalidOptionsError, "Password length must be a positive integer") do
      PasswordGenerator::Generator.generate(length: 0, uppercase: true, lowercase: true, number: 3, special: 2)
    end
  end

  def test_minimum_requirements
    password = PasswordGenerator::Generator.generate(
      length: 8,
      uppercase: true,
      lowercase: true,
      number: 1,
      special: 1
    )

    # Ensure the password length is correct
    assert_equal 8, password.length

    # Ensure it contains at least one uppercase letter
    assert_match(/[A-Z]/, password)

    # Ensure it contains at least one lowercase letter
    assert_match(/[a-z]/, password)

    # Ensure exactly 1 digit
    assert_equal 1, password.scan(/\d/).length

    # Ensure exactly 1 special character
    assert_equal 1, password.count('@%!?*^&')
  end
end
