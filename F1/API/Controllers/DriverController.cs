using API.Models;
using API.Services;
using Dapper;
using Microsoft.AspNetCore.Mvc;

namespace API.Controllers
{
    [ApiController]
    [Route("api/[controller]/")]
    public class DriverController: ControllerBase
    {
        private readonly SqlConnectionFactory _sqlConnectionFactory;

        public DriverController(SqlConnectionFactory sqlConnectionFactory)
        {
            _sqlConnectionFactory = sqlConnectionFactory;
        }

        [HttpGet]
        async public Task<IActionResult> getAllDrivers()
        {
            using var connection = _sqlConnectionFactory.Create();

            const string sql = "EXEC DriverGet";

            var customers = await connection.QueryAsync<Driver>(sql);

            return Ok(customers);
        }

        [HttpGet]
        [Route("{DriverID}")]
        async public Task<IActionResult> getDriverByID(int DriverID)
        {
            using var connection = _sqlConnectionFactory.Create();

            const string sql = "EXEC DriverGet @intView = 1, @intDriverID = @DriverID";

            var customer = await connection.QuerySingleOrDefaultAsync<Driver>(
                sql,
                new { DriverID = DriverID });

            return customer is not null ? Ok(customer) : NotFound();
        }

        [HttpPost, HttpPut]
        async public Task<IActionResult> AddOrModifyDriver(Driver driver)
        {
            try
            {
                using var connection = _sqlConnectionFactory.Create();
                const string sql = "EXEC DriverUpd @intDriverID = @DriverID, @strDriverNm = @DriverNm, @intDriverAge = @DriverAge, @strImageID = @ImageID, @intNationalityID = @NationalityID, @intTeamID = @TeamID";

                await connection.ExecuteAsync(sql, driver);
                return Ok();
            }
            catch(Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpDelete]
        [Route("{DriverID}")]
        async public Task<IActionResult> DeleteDriverByID(int DriverID)
        {
            using var connection = _sqlConnectionFactory.Create();

            const string sql = "EXEC DriverDel @intDriverID = @DriverID";

            await connection.ExecuteAsync(
                sql,
                new { DriverID = DriverID });

            return NoContent();
        }
    }
}
