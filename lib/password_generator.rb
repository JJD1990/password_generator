module PasswordGenerator
  # Custom error raised when invalid options are provided to the password generator.
  class InvalidOptionsError < StandardError; end

  # A generator for creating secure passwords with specific requirements.
  class Generator
    # Predefined set of special characters that can be included in the password.
    SPECIAL_CHARS = '@%!?*^&'.freeze
    UPPERCASE_CHARS = ('A'..'Z').to_a.freeze
    LOWERCASE_CHARS = ('a'..'z').to_a.freeze
    NUMBER_CHARS = ('0'..'9').to_a.freeze

    class << self
      # Generates a random password based on the specified parameters.
      #
      # @param length [Integer] the total length of the generated password.
      # @param uppercase [Boolean] whether to include at least one uppercase letter.
      # @param lowercase [Boolean] whether to include at least one lowercase letter.
      # @param number [Integer] the exact number of numeric characters (0-9).
      # @param special [Integer] the exact number of special characters.
      #
      # @return [String] the randomly generated password.
      # @raise [InvalidOptionsError] if the provided options are invalid.
      def generate(length:, uppercase: false, lowercase: false, number: 0, special: 0)
        validate_options(length, uppercase, lowercase, number, special)

        # Create the required characters
        password = []
        password << UPPERCASE_CHARS.sample if uppercase
        password << LOWERCASE_CHARS.sample if lowercase
        password.concat(NUMBER_CHARS.sample(number))
        password.concat(SPECIAL_CHARS.chars.sample(special))

        # Create the character pool for remaining characters
        char_pool = build_char_pool(uppercase, lowercase)

        # Fill the remaining length with random characters from the pool
        remaining_length = length - password.length
        password.concat(char_pool.sample(remaining_length)) if remaining_length.positive?

        # Shuffle and return the password
        password.shuffle.join
      end

      private

      def validate_options(length, uppercase, lowercase, number, special)
        # Calculate minimum required characters
        min_required_chars = [uppercase, lowercase].count(true) + number + special

        raise InvalidOptionsError, "Password length must be a positive integer" unless length.positive?

        if number.negative? || special.negative?
          raise InvalidOptionsError, "Number and special must be non-negative integers"
        end

        if length < min_required_chars
          raise InvalidOptionsError, "Password length must be at least #{min_required_chars} to satisfy requirements"
        end
      end

      # Builds the character pool based on the specified requirements.
      #
      # This method constructs a pool of characters from the predefined sets
      # (uppercase, lowercase, digits, and special characters) based on the flags
      # passed to the method. It adds uppercase characters if the `uppercase` flag is
      # `true`, lowercase characters if the `lowercase` flag is `true`, and includes
      # all numeric and special characters.
      #
      # @param uppercase [Boolean] whether to include uppercase letters in the pool.
      # @param lowercase [Boolean] whether to include lowercase letters in the pool.
      #
      # @return [Array<String>] the pool of characters that can be used for generating the password.
      def build_char_pool(uppercase, lowercase)
        pool = []
        pool.concat(UPPERCASE_CHARS) if uppercase
        pool.concat(LOWERCASE_CHARS) if lowercase
        pool.concat(NUMBER_CHARS)
        pool.concat(SPECIAL_CHARS.chars)
        pool
      end
    end
  end
end
