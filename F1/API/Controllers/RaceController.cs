using Dapper;
using API.Models;
using API.Services;
using Microsoft.AspNetCore.Mvc;

namespace API.Controllers
{
    [ApiController]
    [Route("api/[controller]/")]
    public class RaceController : ControllerBase
    {
        private readonly SqlConnectionFactory _sqlConnectionFactory;

        public RaceController(SqlConnectionFactory sqlConnectionFactory)
        {
            _sqlConnectionFactory = sqlConnectionFactory;
        }

        [HttpGet]
        async public Task<IActionResult> getAllRaces()
        {
            try
            {
                using var connection = _sqlConnectionFactory.Create();

                const string sql = "EXEC RaceGet";

                var races = await connection.QueryAsync<Race>(sql);

                return Ok(races);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpGet]
        [Route("{RaceID}")]
        async public Task<IActionResult> getRaceByID(int RaceID)
        {
            try
            {
                using var connection = _sqlConnectionFactory.Create();

                const string sql = "EXEC RaceGet @intView = 1, @intRaceID = @RaceID";

                var race = await connection.QuerySingleOrDefaultAsync<Race>(
                    sql,
                    new { RaceID = RaceID });

                return race is not null ? Ok(race) : NotFound();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpPost, HttpPut]
        async public Task<IActionResult> AddOrModifyRace(Race race)
        {
            try
            {
                using var connection = _sqlConnectionFactory.Create();
                const string sql = "EXEC RaceUpd @intRaceID = @RaceID, @intWinnerID = @WinnerID, @dtWinnerTime = @WinnerTime, @intGrandPixID = @GrandPixID, @intCarID = @CarID, @intLaps = @Laps";

                await connection.ExecuteAsync(sql, race);
                return Ok();
            }
            catch (Exception ex)
            {
                return Conflict(ex.Message);
            }
        }

        [HttpDelete]
        [Route("{RaceID}")]
        async public Task<IActionResult> DeleteRaceByID(int RaceID)
        {
            try
            {
                using var connection = _sqlConnectionFactory.Create();

                const string sql = "EXEC RaceDel @intRaceID = @RaceID";

                await connection.ExecuteAsync(
                    sql,
                    new { RaceID = RaceID });

                return NoContent();
            }
            catch (Exception ex)
            {
                return Conflict(ex.Message);
            }
        }
    }
}
