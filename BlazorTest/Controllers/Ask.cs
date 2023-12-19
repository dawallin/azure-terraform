using Microsoft.AspNetCore.Mvc;
using System;

namespace WebApiTest.Controllers;

[ApiController]
[Route("[controller]")]
public class AskController : ControllerBase
{
    [HttpGet]
    public ActionResult<string> Get([FromQuery] string query)
    {
        // Process the query here and return the answer
        string answer = ProcessQuery(query);
        return Ok(answer);
    }

    private string ProcessQuery(string query)
    {
        // Implement your query processing logic here
        // For now, let's just return the query as the answer
        return query;
    }
}
