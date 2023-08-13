module ApplicationHelper
    def acc_error_message(errors)
        # It accumulates all error in single string
        begin
           p errors
            errors.full_messages.join(", ")
        rescue =>e
            "Something went wrong"
        end
    end
end
