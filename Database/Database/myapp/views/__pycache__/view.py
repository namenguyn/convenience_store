from django.http import JsonResponse, HttpResponse
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.hashers import check_password, make_password
import json
from myapp.models import Admin  

@csrf_exempt
def login(request):
    # if request.method == 'GET':
    #     return JsonResponse({'message': 'Please use POST request to login'}, status=405)

    if request.method == 'POST':
        try:
            # Parse request body
            data = json.loads(request.body)
            username = data.get('username')
            password = data.get('password')

            if not username or not password:
                return JsonResponse({'success': False, 'message': 'Username and password are required'}, status=400)

            try:
                admin = Admin.objects.get(username=username)

                # Đảm bảo mật khẩu của user đã được mã hóa (fix lỗi nếu có user nhưng check_password sai)
                if not admin.password.startswith(('pbkdf2_sha256$', 'argon2$', 'bcrypt$')):
                    admin.password = make_password(admin.password)
                    admin.save()

                # Kiểm tra password
                if check_password(password, admin.password):
                    response_data = {
                        'success': True,
                        'message': 'Login successful',
                        'user': {'username': admin.username}
                    }
                    return JsonResponse(response_data, status=200)
                else:
                    return JsonResponse({'success': False, 'message': 'Invalid username or password'}, status=401)

            except Admin.DoesNotExist:
                return JsonResponse({'success': False, 'message': 'Invalid username or password'}, status=401)

        except Exception as e:
            return JsonResponse({'success': False, 'message': f'Error during login: {str(e)}'}, status=500)

    return HttpResponse(status=405)  # Method Not Allowed
