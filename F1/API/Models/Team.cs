namespace API.Models
{
    public class Team: Audit
    {
        public int TeamID { get; set; }
        public string? TeamNm { get; set; }
        public int ManufacturerID { get; set; }
        public int DriverFirstID { get; set; }
        public string? DirverFirstNm { get; set; }
        public int DriverSecondID { get; set; }
        public string? DriverSecondNm { get; set; }
        public string? Image { get; set; }
        public string? ImageName { get; set; }
        public string? ImageSrc { get; set; }
        public IFormFile? ImageFile  { get; set; }
    }
}
