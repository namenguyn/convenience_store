from django.db import models
from django.contrib.auth.hashers import make_password, check_password

class Admin(models.Model):
    username = models.CharField(max_length=255, unique=True)
    password = models.CharField(max_length=255)

    def save(self, *args, **kwargs):
        # Chỉ mã hóa nếu mật khẩu chưa được mã hóa
        if not self.password.startswith(('pbkdf2_sha256$', 'argon2$', 'bcrypt$')): 
            self.password = make_password(self.password)
        super().save(*args, **kwargs)

    def check_password(self, raw_password):
        """Kiểm tra mật khẩu nhập vào có khớp với mật khẩu đã mã hóa không"""
        return check_password(raw_password, self.password)

    def __str__(self):
        return self.username

    class Meta:
        db_table = 'admins'
