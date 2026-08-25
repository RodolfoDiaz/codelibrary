namespace RandomNumberApp.Services
{
    public class RandomNumberService: IRandomNumberService
    {
        private readonly int _randomNumber;

        public RandomNumberService()
        {
            _randomNumber = new Random().Next(1, 101); // Generates a random number between 1 and 100
        }

        public int GetNumber() => _randomNumber;
    }
}
