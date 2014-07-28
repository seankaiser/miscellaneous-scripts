This script uses the google apps manager tool, available on [Google code](https://code.google.com/p/google-apps-manager/) to clone google group membership(s) for a user based on another user's memberships.

The option exists to purge all group memberships for the target user before cloning the model user's memberships by specifying the purge_first argument as the 3rd argument on the command line.

To use this script, adjust the two variables (gam and my_domain) to reflect your environment (my_domain is your Google Apps domain name.) Then run the script with the model user's username first, followed by the target user's username, optionally followed by purge_first.

