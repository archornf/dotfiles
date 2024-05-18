def calculate_effective_interest_rate(nominal_rate, compounding_periods):
    effective_rate = (1 + (nominal_rate / compounding_periods)) ** compounding_periods - 1
    return effective_rate
nominal_rate = 0.05  # 5% nominal interest rate
compounding_periods = 12  # Compounded monthly
effective_rate = calculate_effective_interest_rate(nominal_rate, compounding_periods)
print(f"The effective interest rate is: {effective_rate:.2%}")

print("hello")

import unittest
from your_file_name import calculate_effective_interest_rate

class TestCalculateEffectiveInterestRate(unittest.TestCase):

    def test_effective_interest_rate(self):
        nominal_rate = 0.05
        compounding_periods = 12
        self.assertAlmostEqual(calculate_effective_interest_rate(nominal_rate, compounding_periods), 0.05116189788173287)

    def test_effective_interest_rate_different_scenario(self):
        nominal_rate = 0.03
        compounding_periods = 4
        self.assertAlmostEqual(calculate_effective_interest_rate(nominal_rate, compounding_periods), 0.03046875)

if __name__ == '__main__':
    unittest.main()

