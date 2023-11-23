namespace API.Services
{
    public class UtilityServices: IUtilityServices
    {
        private IConfiguration _configuration;
        public UtilityServices(IConfiguration configuration)
        {
            _configuration = configuration;
        }
        public bool SetImage(int id, IFormFile image)
        {
            var imageStoragePath = GetStoragePath();

            var imagePath = Path.Combine(imageStoragePath, id.ToString());

            using (var stream = new FileStream(imagePath, FileMode.Create))
            {
                image.CopyToAsync(stream);
            }
            return true;
        }
        public byte[] GetImage(int id)
        {
            var imageStoragePath = GetStoragePath();

            string imagePath = Path.Combine(imageStoragePath, id.ToString());

            if (File.Exists(imagePath))
            {
                return File.ReadAllBytes(imagePath);
            }

            throw new Exception("The file does not exist");
        }

        private string GetStoragePath()
        {
            string? profilePictureStoragePath = _configuration.GetConnectionString("ImageStoragePath");
            if (profilePictureStoragePath is null)
                throw new Exception("Image storage path is not set");
            return profilePictureStoragePath;
        }
    }
}
