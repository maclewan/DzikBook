def convert_bdate(bdate: str):
    try:
        arr = bdate.split('/')
        if len(arr) != 3 or len(arr[0]) != 2 or len(arr[1]) != 2 or len(arr[2]) != 4:
            raise ValueError
        return f'{arr[2]}-{arr[1]}-{arr[0]}'
    except ValueError:
        return False
