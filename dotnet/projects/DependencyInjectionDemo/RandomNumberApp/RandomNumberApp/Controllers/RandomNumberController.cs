using RandomNumberApp.Services;
using Microsoft.AspNetCore.Mvc;

namespace RandomNumberApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RandomNumberController : ControllerBase
    {
        private readonly IRandomNumberService _randomNumberService1;
        private readonly IRandomNumberService _randomNumberService2;

        public RandomNumberController(IRandomNumberService randomNumberService,  IRandomNumberService randomNumberService2)
        {
            _randomNumberService1 = randomNumberService;
            _randomNumberService2 = randomNumberService2;
        }

        [HttpGet]
        public IActionResult Get()
        {
            return Ok(new
            {
                Number1 = _randomNumberService1.GetNumber(),
                Number2 = _randomNumberService2.GetNumber()
            });
        }
    }
}
