using Dapper;
using API.Models;
using API.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.OpenApi.Models;

namespace API.Controllers
{
    [ApiController]
    [Route("api/[controller]/")]
    public class UtilityController : ControllerBase
    {
        private readonly SqlConnectionFactory _sqlConnectionFactory;

        public UtilityController(SqlConnectionFactory sqlConnectionFactory)
        {
            _sqlConnectionFactory = sqlConnectionFactory;
        }

        [HttpGet]
        [Route("References")]
        async public Task<IActionResult> getReference([FromQuery] string referenceType)
        {
            try
            {
                using var connection = _sqlConnectionFactory.Create();

                const string sql = "EXEC ReferenceGet @strReferenceType = @ReferenceType";

                var references = await connection.QueryAsync<Utility.Reference>(sql,
                    new { ReferenceType = referenceType });

                return references is null ? NotFound() : Ok(references) ;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
}
