namespace API.Models
{
    public class Race: Audit
    {
        public int RaceID { get; set; }
        public int WinnerID { get; set; }
        public string? WinnerNm { get; set; }
        public DateTimeOffset WinnerTime { get; set; }
        public int GrandPixID { get; set; }
        public string? GrandPixNm { get; set; }
        public int Laps { get; set; }
        public int CarID { get; set; }
        public string? CarNm { get; set; }
    }
}
