import requests
def xd():
    url = 'http://localhost:8000/auth/validate/'
    headers = {"Authorization": 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjA0NDE0MTA5LCJqdGkiOiJjZWZkMGY5YTJjODM0MDQzYjdmYmMxYWMxMTFlZjU3MiIsInVzZXJfaWQiOjExLCJoYXNoIjoiYVhPODhaT3FzPSJ9.QWbwV7ZfcKLC8j4Ne1glKufu_FGQ0m-w5cszZQ7hItE'}
    r = requests.get(url, headers=headers)
    print(r.json()['detail'])


def authenticate(f):

    def validate(args):
        test = args
        print(args)
        f(*args)



