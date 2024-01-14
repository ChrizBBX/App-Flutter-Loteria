using System.Security.Cryptography;
using System.Text;

namespace Numerito.API.Utility
{
    public class Encrypt
    {
        public string HashPassword(string password)
        {
            using (SHA512 sha512 = SHA512.Create())
            {
                byte[] hashedBytes = sha512.ComputeHash(Encoding.UTF8.GetBytes(password));

                return BitConverter.ToString(hashedBytes).Replace("-", "").ToLower();
            }
        }
    }
}
