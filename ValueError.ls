
  do ->

    { typed-value-as-string } = dependency 'reflection.Value'

    invalid-value-error = (value, reason) -> new Error do

      "Invalid value #{ typed-value-as-string value }. #reason"

    {
      invalid-value-error
    }