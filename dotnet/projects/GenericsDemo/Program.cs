using System;
using System.Collections.Generic;

namespace GenericsDemo
{
    /// <summary>
    /// Core Concepts Highlighted
    /// * Type Safety: You specify the type parameter (T) at compile-time (e.g., IRepository<string>), 
    ///             preventing runtime type mismatch errors.
    /// * No Boxing/Unboxing: Unlike using object, generics store value types (like int or DateTime) 
    ///             directly without performance-heavy boxing allocations.No Boxing/Unboxing: Unlike using object, 
    ///             generics store value types (like int or DateTime) directly without performance-heavy boxing allocations.
    /// * Generic Constraints (where T : ...): Restricts what types can be passed to T. In the example above, 
    ///             EntityProcessor<T> guarantees that any type used implements IEntity and has a parameterless constructor (new()).
    /// </summary>
    internal class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("=== 1. Generic Class & Interface Demo ===");

            // Generic Repository for Integers
            IRepository<int> intRepository = new Repository<int>();
            intRepository.Add(101);
            intRepository.Add(102);
            Console.WriteLine($"Integer item at index 0: {intRepository.Get(0)}");

            // Generic Repository for Strings
            IRepository<string> stringRepository = new Repository<string>();
            stringRepository.Add("Hello");
            stringRepository.Add("Generics");
            Console.WriteLine($"String item at index 1: {stringRepository.Get(1)}");

            Console.WriteLine("\n=== 2. Generic Method Demo ===");

            int x = 5, y = 20;
            Console.WriteLine($"Before Swap: x = {x}, y = {y}");
            Swap(ref x, ref y);
            Console.WriteLine($"After Swap:  x = {x}, y = {y}");

            string a = "World", b = "Hello";
            Console.WriteLine($"Before Swap: a = {a}, b = {b}");
            Swap(ref a, ref b);
            Console.WriteLine($"After Swap:  a = {a}, b = {b}");

            Console.WriteLine("\n=== 3. Generic Constraints Demo ===");

            // Working with a entity class that satisfies constraints (class, IEntity, new())
            var userProcessor = new EntityProcessor<User>();
            userProcessor.Process(new User { Id = 1, Name = "Alice" });

            // Uncommenting the line below causes a compile-time error because 'int' doesn't inherit from IEntity:
            // var invalidProcessor = new EntityProcessor<int>();
        }

        // --- Generic Method ---
        /// <summary>
        /// Swaps two variables of any given type T.
        /// </summary>
        public static void Swap<T>(ref T lhs, ref T rhs)
        {
            T temp = lhs;
            lhs = rhs;
            rhs = temp;
        }
    }

    // --- Generic Interface ---
    public interface IRepository<T>
    {
        void Add(T item);
        T Get(int index);
        IEnumerable<T> GetAll();
    }

    // --- Generic Class Implementing Generic Interface ---
    public class Repository<T> : IRepository<T>
    {
        private readonly List<T> _items = new List<T>();

        public void Add(T item)
        {
            _items.Add(item);
            Console.WriteLine($"Added item of type '{typeof(T).Name}': {item}");
        }

        public T Get(int index)
        {
            if (index < 0 || index >= _items.Count)
                throw new ArgumentOutOfRangeException(nameof(index));

            return _items[index];
        }

        public IEnumerable<T> GetAll() => _items;
    }

    // --- Generic Constraints ---
    public interface IEntity
    {
        int Id { get; set; }
    }

    public class User : IEntity
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
    }

    /// <summary>
    /// Demonstrates generic constraints:
    /// 'where T : class'   -> Must be a reference type.
    /// 'where T : IEntity' -> Must implement IEntity interface.
    /// 'where T : new()'   -> Must have a public parameterless constructor.
    /// </summary>
    public class EntityProcessor<T> where T : class, IEntity, new()
    {
        public void Process(T entity)
        {
            Console.WriteLine($"Processing Entity ID: {entity.Id} of Type: {typeof(T).Name}");
        }
    }
}