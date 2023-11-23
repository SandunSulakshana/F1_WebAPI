namespace API.Models
{
    public class Driver: Audit
    {
        public int DriverID { get; set; }
        public string? DriverNm { get; set; }
        public string? ImageID { get; set; }
        public int DriverAge { get; set; }
        public int NationalityID { get; set; }
        public string? NationalityNm { get; set; }
        public int TeamID { get; set; }
        public string? TeamNm { get; set; }
    }
}
