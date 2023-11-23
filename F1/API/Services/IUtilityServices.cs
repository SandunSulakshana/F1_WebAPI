namespace API.Services
{
    public interface IUtilityServices
    {
        bool SetImage(int id, IFormFile carPhoto);
        byte[] GetImage(int id);
    }
}
