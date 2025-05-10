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

        # Start with guaranteed required characters
        password = []
        password << UPPERCASE_CHARS.sample if uppercase
        password << LOWERCASE_CHARS.sample if lowercase
        password.concat(NUMBER_CHARS.sample(number))
        password.concat(SPECIAL_CHARS.chars.sample(special))

        # Fill remaining characters
        remaining_length = length - password.length
        if remaining_length > 0
          # Only use letters for remaining characters to avoid exceeding number and special requirements
          char_pool = []
          char_pool.concat(UPPERCASE_CHARS) if uppercase
          char_pool.concat(LOWERCASE_CHARS) if lowercase
          char_pool = ['A'] if char_pool.empty? # Fallback to ensure we have characters

          password.concat(char_pool.sample(remaining_length))
        end

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
