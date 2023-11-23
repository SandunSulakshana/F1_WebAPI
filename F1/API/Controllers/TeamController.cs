using API.Models;
using API.Services;
using Dapper;
using Microsoft.AspNetCore.Mvc;

namespace API.Controllers
{
    [ApiController]
    [Route("api/[controller]/")]
    public class TeamController : ControllerBase
    {
        private readonly SqlConnectionFactory _sqlConnectionFactory;
        private readonly IUtilityServices _utilityServices;
        private readonly IWebHostEnvironment _webHostEnvironment;

        public TeamController(SqlConnectionFactory sqlConnectionFactory, IUtilityServices utilityServices, IWebHostEnvironment webHostEnvironment)
        {
            _sqlConnectionFactory = sqlConnectionFactory;
            _utilityServices = utilityServices;
            _webHostEnvironment = webHostEnvironment;
        }

        [HttpGet]
        async public Task<IActionResult> getAllTeams()
        {
            try
            {
                using var connection = _sqlConnectionFactory.Create();

                const string sql = "EXEC TeamGet";

                var teams = await connection.QueryAsync<Team>(sql);

                return Ok(teams);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpGet]
        [Route("{TeamID}")]
        async public Task<IActionResult> getTeamByID(int TeamID)
        {
            try
            {
                using var connection = _sqlConnectionFactory.Create();

                const string sql = "EXEC TeamGet @intView = 1, @intTeamID = @TeamID";

                var team = await connection.QuerySingleOrDefaultAsync<Team>(
                    sql,
                    new { TeamID = TeamID });

                return team is not null ? Ok(team) : NotFound();
            }
            catch(Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpPost, HttpPut]
        async public Task<IActionResult> AddOrModifyTeam(Team team)     
        {
            try
            {
                using var connection = _sqlConnectionFactory.Create();
                const string sql = "EXEC TeamUpd @intTeamID = @TeamID, @strTeamNm = @TeamNm, @intManufacturerID = @ManufacturerID, @intDriverFirstID = @DriverFirstID, @intDriverSecondID = @DriverSecondID, @strImage = @Image";

                await connection.ExecuteAsync(sql, team);
                return Ok();
            }
            catch (Exception ex)
            {
                return Conflict(ex.Message);
            }
        }

        [HttpPost("setImage")]
        public IActionResult SetCarImage(int id, IFormFile image)
        {
            var imageUploadSuccess = _utilityServices.SetImage(id, image);

            if (!imageUploadSuccess)
            if (!imageUploadSuccess)
            {
                return BadRequest();
            }

            return Ok(id);
        }

        [HttpGet("getImageByID")]
        public IActionResult GetCarPhoto(int id)
        {
            var imageRetrieved = _utilityServices.GetImage(id);

            if (imageRetrieved != null && imageRetrieved.Length > 0)
            {
                return Ok(imageRetrieved);
            }

            return BadRequest();
        }

        [HttpDelete]
        [Route("{TeamID}")]
        async public Task<IActionResult> DeleteDriverByID(int TeamID)
        {
            try
            {
                using var connection = _sqlConnectionFactory.Create();

                const string sql = "EXEC TeamDel @intTeamID = @TeamID";

                await connection.ExecuteAsync(
                    sql,
                    new { TeamID = TeamID });

                return NoContent();
            }
            catch(Exception ex)
            {
                return Conflict(ex.Message);
            }
        }

        [NonAction]
        public async Task<string> SaveImage(IFormFile imageFile)
        {
            string imageName = new String(Path.GetFileNameWithoutExtension(imageFile.FileName).Take(10).ToArray()).Replace(' ', '-');
            imageName = imageName + DateTime.Now.ToString("yymmssfff") + Path.GetExtension(imageFile.FileName);
            var imagePath = Path.Combine(_webHostEnvironment.ContentRootPath, "Images", imageName);
            using (var fileStream = new FileStream(imagePath, FileMode.Create))
            {
                await imageFile.CopyToAsync(fileStream);
            }
            return imageName;
        }
    }
}
