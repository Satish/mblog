SITE = "http://www.example.com"
SITE_NAME = "example.com"
CONTACT_US_EMAIL = "info@example.com"
ADMIN_EMAIL = "admin@example.com"

PAGE_NOT_FOUND = "Page you were trying to access can't be found."
UN_PROCESSED_REQUEST = "Sorry, we are unable to process your request."
UN_AUTHORIZED_ACTION = "You are not authorized to perform the action you just attempted."

MAX_MESSAGE_LENGTH = 300
PER_PAGE = 20

ADD_THIS_USERNAME = 'satishchauhan'

PRIORITY_ZONES = ActiveSupport::TimeZone::ZONES.find_all { |z| z.name =~ /Kolkata|Mumbai|New Delhi|Chennai/ } + ActiveSupport::TimeZone.us_zones